// lib/presentation/pages/training/pronunciation_practice_page.dart
//
// Pronunciation Practice Page - Interactive pronunciation training session
//
// FEATURES:
// - Record and compare user pronunciation using OpenAI Whisper API (premium)
// - Fallback to native speech recognition if no API key
// - Manual recording control - user decides when to stop
// - Visual feedback with tachometer showing match rate
// - Text-to-speech for listening to correct pronunciation
// - Item filtering based on training settings
// - Progress tracking with status indicators

import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:speech_to_text/speech_to_text.dart' as stt;
import 'package:record/record.dart';
import 'package:audioplayers/audioplayers.dart';
import 'dart:math' as math;
import 'dart:io';
import 'dart:async';
import 'dart:typed_data';
import 'package:path_provider/path_provider.dart';
import '../../../core/theme/app_theme.dart';
import '../../../core/services/tts_service.dart';
import '../../../core/services/speech_recognition_service.dart';
import '../../../data/models/training_settings.dart';
import '../../../data/models/language_package.dart';
import '../../../data/models/item.dart';
import '../../../data/repositories/item_repository.dart';
import '../../../data/repositories/category_repository.dart';
import '../../../l10n/app_localizations.dart';
import '../../providers/app_settings_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class PronunciationPracticePage extends ConsumerStatefulWidget {
  final LanguagePackage package;
  final TrainingSettings settings;

  const PronunciationPracticePage({
    super.key,
    required this.package,
    required this.settings,
  });

  @override
  ConsumerState<PronunciationPracticePage> createState() =>
      _PronunciationPracticePageState();
}

class _PronunciationPracticePageState
    extends ConsumerState<PronunciationPracticePage> {
  final _itemRepo = ItemRepository();
  final _categoryRepo = CategoryRepository();
  final _ttsService = TtsService();
  final _speech = stt.SpeechToText();
  final _audioRecorder = AudioRecorder();
  final _audioPlayer = AudioPlayer();
  SpeechRecognitionService? _speechRecognitionService;
  bool _useWhisperAPI = false;
  bool _hasInitializedSpeech = false;
  bool _playbackAfterRecording = true; // User preference for playback
  Timer? _amplitudeTimer; // For volume meter updates

  List<Item> _filteredItems = [];
  int _currentItemIndex = 0;
  bool _isLoading = true;
  bool _displayLanguage1 = true;

  // Pronunciation practice state
  bool _isRecording = false;
  bool _hasRecorded = false;
  double _matchRate = 0.0;
  String _recordedText = '';
  bool _speechAvailable = false;
  String? _recordedAudioPath;
  String? _referenceAudioPath;
  DateTime? _recordingStartTime;
  double _currentVolumeLevel = 0.0; // For volume meter (0.0 to 1.0)

  // Statistics
  int _totalPracticed = 0;

  @override
  void initState() {
    super.initState();
    _ttsService.initialize();
    _loadAndFilterItems();
    _loadPlaybackPreference();

    // Listen for settings changes and initialize speech when ready
    // This is needed because settings are loaded asynchronously
    WidgetsBinding.instance.addPostFrameCallback((_) {
      // Initialize immediately with current state
      _initializeSpeechRecognition();

      // Also listen for future changes (e.g., if API key is added later)
      ref.listenManual(
        appSettingsProvider,
        (previous, next) {
          print('🔄 Settings changed, checking if we need to reinitialize speech recognition...');
          final hadApiKey = previous?.openaiApiKey != null && previous!.openaiApiKey!.isNotEmpty;
          final hasApiKey = next.openaiApiKey != null && next.openaiApiKey!.isNotEmpty;

          // Reinitialize if API key changed from empty to filled
          if (!hadApiKey && hasApiKey && !_useWhisperAPI) {
            print('✓ API key was added, switching to Whisper API mode');
            _hasInitializedSpeech = false;
            _initializeSpeechRecognition();
          }
        },
      );
    });
  }

  Future<void> _loadPlaybackPreference() async {
    final prefs = await SharedPreferences.getInstance();
    if (mounted) {
      setState(() {
        _playbackAfterRecording = prefs.getBool('pronunciation_playback_enabled') ?? true;
      });
    }
  }

  Future<void> _savePlaybackPreference(bool value) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('pronunciation_playback_enabled', value);
    setState(() {
      _playbackAfterRecording = value;
    });
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    // No longer needed - initialization handled in initState's postFrameCallback
  }

  Future<void> _initializeSpeechRecognition() async {
    if (_hasInitializedSpeech) return;
    _hasInitializedSpeech = true;

    // Get OpenAI API key from settings - use watch to ensure we have latest value
    final appSettings = ref.read(appSettingsProvider);
    final openaiApiKey = appSettings.openaiApiKey;

    print('=== Initializing Speech Recognition ===');
    print('OpenAI API Key present: ${openaiApiKey != null && openaiApiKey.isNotEmpty}');
    if (openaiApiKey != null && openaiApiKey.isNotEmpty) {
      print('OpenAI API Key (first 10 chars): ${openaiApiKey.substring(0, openaiApiKey.length > 10 ? 10 : openaiApiKey.length)}...');
    }

    // Initialize Whisper service if API key is available
    if (openaiApiKey != null && openaiApiKey.isNotEmpty) {
      _speechRecognitionService = SpeechRecognitionService(apiKey: openaiApiKey);
      _useWhisperAPI = true;
      _speechAvailable = true;
      print('🎙️ Using OpenAI Whisper API for speech recognition');
      print('   ✓ High-quality transcription enabled');
      print('   ✓ Manual recording control (no automatic timeout)');
      print('   ✓ No speech timeout issues');
    } else {
      // Fall back to native speech recognition
      print('🎙️ OpenAI API key not found, using native speech recognition...');
      print('   ⚠️ Note: Native mode has automatic timeout (may cause issues)');
      print('   💡 Add OpenAI API key in Settings for better experience');
      await _initializeSpeech();
      _useWhisperAPI = false;
    }

    if (mounted) setState(() {});
  }

  @override
  void dispose() {
    _ttsService.stop();
    _speech.stop();
    _audioRecorder.dispose();
    _audioPlayer.dispose();
    _amplitudeTimer?.cancel();
    _cleanupAudioFiles();
    super.dispose();
  }

  Future<void> _cleanupAudioFiles() async {
    try {
      if (_recordedAudioPath != null && await File(_recordedAudioPath!).exists()) {
        await File(_recordedAudioPath!).delete();
      }
      if (_referenceAudioPath != null && await File(_referenceAudioPath!).exists()) {
        await File(_referenceAudioPath!).delete();
      }
    } catch (e) {
      // Ignore cleanup errors
    }
  }

  Future<void> _initializeSpeech() async {
    try {
      print('=== Speech Recognition Initialization ===');
      print('Platform: ${Platform.operatingSystem}');
      print('Is Web: $kIsWeb');

      // Check if running on a supported platform
      final isDesktop = !kIsWeb && (Platform.isWindows || Platform.isLinux || Platform.isMacOS);
      final isAndroid = !kIsWeb && Platform.isAndroid;
      final isIOS = !kIsWeb && Platform.isIOS;

      print('Is Desktop: $isDesktop');
      print('Is Android: $isAndroid');
      print('Is iOS: $isIOS');

      if (isDesktop) {
        print('Warning: Speech recognition support on desktop platforms is limited or unavailable');
      }

      if (isIOS) {
        print('iOS specific checks:');
        print('  - Ensure NSMicrophoneUsageDescription is set in Info.plist');
        print('  - Ensure NSSpeechRecognitionUsageDescription is set in Info.plist');
        print('  - Check Settings > Privacy > Microphone > Language Rally');
        print('  - Check Settings > Privacy > Speech Recognition > Language Rally');
      }

      print('Attempting to initialize speech recognition...');
      _speechAvailable = await _speech.initialize(
        onError: (error) {
          print('!!! Speech recognition error: ${error.errorMsg}');
          print('    Error permanent: ${error.permanent}');

          if (error.errorMsg.contains('timeout')) {
            print('    Speech timeout - user did not speak or speech was too quiet');
          } else if (error.errorMsg.contains('no-speech')) {
            print('    No speech detected - microphone may not be picking up voice');
          }

          if (isIOS) {
            if (error.errorMsg.toLowerCase().contains('permission')) {
              print('    iOS Permission Issue Detected!');
              print('    Go to: Settings > Privacy > Microphone/Speech Recognition > Enable for Language Rally');
            } else if (error.errorMsg.toLowerCase().contains('not available')) {
              print('    iOS Speech Recognition may not be available on this device');
              print('    Check: Settings > General > Language & Region > Siri Language');
            }
          }
        },
        onStatus: (status) {
          print('>>> Speech recognition status: $status');
          if (status == 'notListening') {
            print('    Speech recognition stopped listening');
          } else if (status == 'done') {
            print('    Speech recognition session completed');
          }
        },
      );

      if (!_speechAvailable) {
        print('!!! Speech recognition failed to initialize');
        if (isIOS) {
          print('iOS Troubleshooting:');
          print('  1. Check microphone permission: Settings > Privacy > Microphone');
          print('  2. Check speech recognition permission: Settings > Privacy > Speech Recognition');
          print('  3. Ensure Siri is enabled: Settings > Siri & Search');
          print('  4. Check language support: Settings > General > Language & Region');
        }
        if (mounted && isDesktop) {
          final l10n = AppLocalizations.of(context)!;
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(l10n.speechRecognitionNotSupported),
              duration: const Duration(seconds: 5),
            ),
          );
        }
      } else {
        print('✓ Speech recognition initialized successfully');

        // Get available locales for debugging
        final locales = await _speech.locales();
        print('Available locales: ${locales.length}');
        if (locales.isNotEmpty) {
          print('First 5 locales: ${locales.take(5).map((l) => l.localeId).join(", ")}');
          if (isIOS) {
            print('iOS Note: Available locales depend on:');
            print('  - Siri language settings');
            print('  - Keyboard languages added to device');
            print('  - iOS version and device model');
          }
        } else if (isIOS) {
          print('!!! No locales available on iOS - possible issues:');
          print('    - Siri not enabled');
          print('    - No keyboard languages configured');
          print('    - Speech recognition permission denied');
        }
      }

      if (mounted) setState(() {});
    } catch (e, stackTrace) {
      print('!!! Exception during speech initialization: $e');
      print('Stack trace: $stackTrace');
      if (Platform.isIOS && e.toString().contains('PlatformException')) {
        print('iOS Platform Exception - Check:');
        print('  1. Info.plist has required permission keys');
        print('  2. App has been granted permissions in Settings');
        print('  3. Device supports speech recognition (iOS 10+)');
      }
      _speechAvailable = false;
      if (mounted) setState(() {});
    }
  }

  Future<void> _loadAndFilterItems() async {
    setState(() => _isLoading = true);

    try {
      List<Item> items = [];

      if (widget.settings.selectedCategoryIds.isNotEmpty) {
        items = await _itemRepo
            .getItemsForCategories(widget.settings.selectedCategoryIds);
      } else {
        final categories =
            await _categoryRepo.getCategoriesForPackage(widget.package.id);
        final categoryIds = categories.map((c) => c.id).toList();
        if (categoryIds.isNotEmpty) {
          items = await _itemRepo.getItemsForCategories(categoryIds);
        }
      }

      // Filter based on item scope
      final filteredItems = _filterItemsByScope(items);

      // Shuffle if random order
      if (widget.settings.itemOrder == ItemOrder.random) {
        filteredItems.shuffle();
      }

      // Determine display language
      _determineDisplayLanguage();

      setState(() {
        _filteredItems = filteredItems;
        _isLoading = false;
      });
    } catch (e) {
      setState(() => _isLoading = false);
    }
  }

  List<Item> _filterItemsByScope(List<Item> items) {
    switch (widget.settings.itemScope) {
      case ItemScope.all:
        return items;
      case ItemScope.lastN:
        // Since Item doesn't have createdAt, use lastReviewedAt or just take last N items
        final sorted = items.toList()
          ..sort((a, b) {
            final aDate = a.lastReviewedAt ?? DateTime(1970);
            final bDate = b.lastReviewedAt ?? DateTime(1970);
            return bDate.compareTo(aDate);
          });
        return sorted.take(widget.settings.lastNItems).toList();
      case ItemScope.onlyUnknown:
        return items.where((item) => !item.isKnown).toList();
      case ItemScope.onlyImportant:
        return items.where((item) => item.isImportant).toList();
      case ItemScope.onlyFavourite:
        return items.where((item) => item.isFavourite).toList();
    }
  }

  void _determineDisplayLanguage() {
    switch (widget.settings.displayLanguage) {
      case DisplayLanguage.motherTongue:
        _displayLanguage1 = true;
        break;
      case DisplayLanguage.targetLanguage:
        _displayLanguage1 = false;
        break;
      case DisplayLanguage.random:
        _displayLanguage1 = math.Random().nextBool();
        break;
    }
  }

  /// Start monitoring audio amplitude for volume meter
  void _startAmplitudeMonitoring() {
    _amplitudeTimer?.cancel();
    _amplitudeTimer = Timer.periodic(const Duration(milliseconds: 100), (timer) async {
      try {
        final amplitude = await _audioRecorder.getAmplitude();
        if (mounted) {
          setState(() {
            // Normalize amplitude to 0.0-1.0 range
            // current is typically between -160 (silent) and 0 (loud)
            // We convert to 0.0 (silent) to 1.0 (loud)
            _currentVolumeLevel = ((amplitude.current + 160) / 160).clamp(0.0, 1.0);
          });
        }
      } catch (e) {
        // Ignore errors - some platforms may not support amplitude monitoring
      }
    });
  }

  /// Stop monitoring audio amplitude
  void _stopAmplitudeMonitoring() {
    _amplitudeTimer?.cancel();
    _amplitudeTimer = null;
    if (mounted) {
      setState(() {
        _currentVolumeLevel = 0.0;
      });
    }
  }

  Future<void> _startRecording() async {
    print('=== Start Recording Called ===');
    print('Using Whisper API: $_useWhisperAPI');
    print('Speech available: $_speechAvailable');

    if (!_speechAvailable) {
      print('!!! Speech recognition not available, showing error message');
      final l10n = AppLocalizations.of(context)!;

      // Show message about needing OpenAI API key
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(l10n.speechRecognitionUnavailable),
          duration: const Duration(seconds: 5),
          action: SnackBarAction(
            label: l10n.settings,
            onPressed: () {
              // Open settings page
              Navigator.pushNamed(context, '/settings');
            },
          ),
        ),
      );
      return;
    }

    final currentItem = _filteredItems[_currentItemIndex];
    final languageData =
        _displayLanguage1 ? currentItem.language1Data : currentItem.language2Data;
    final languageCode = languageData.languageCode.split('-')[0];

    print('Target language code: $languageCode');
    print('Full language code: ${languageData.languageCode}');
    print('Current item text: ${languageData.text}');

    setState(() {
      _isRecording = true;
      _hasRecorded = false;
      _matchRate = 0.0;
      _recordedText = '';
      _recordedAudioPath = null;
      _recordingStartTime = DateTime.now();
    });

    if (_useWhisperAPI) {
      // ========================================
      // WHISPER API MODE - Manual stop only
      // ========================================
      print('📱 Starting audio recording for Whisper API...');
      print('   ⏱️ Recording will continue until user presses STOP button');

      try {
        final hasPermission = await _audioRecorder.hasPermission();
        print('Audio recording permission: $hasPermission');

        if (!hasPermission) {
          print('!!! Audio recording permission not granted');
          if (mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(AppLocalizations.of(context)!.microphonePermissionRequired),
                duration: const Duration(seconds: 5),
              ),
            );
            setState(() => _isRecording = false);
          }
          return;
        }

        final directory = await getTemporaryDirectory();
        final filePath = '${directory.path}/recording_${DateTime.now().millisecondsSinceEpoch}.m4a';
        print('Audio file path: $filePath');

        await _audioRecorder.start(
          const RecordConfig(
            encoder: AudioEncoder.aacLc,
            sampleRate: 44100,
            bitRate: 128000,
          ),
          path: filePath,
        );

        _recordedAudioPath = filePath;
        print('✓ Audio recording started successfully (Whisper mode)');
        print('   User controls when to stop recording');

        // Start monitoring amplitude for volume meter
        _startAmplitudeMonitoring();

        // Show helpful message
        if (mounted) {
          final l10n = AppLocalizations.of(context)!;
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(l10n.speakNow),
              duration: const Duration(seconds: 3),
              backgroundColor: Theme.of(context).colorScheme.primary,
            ),
          );
        }
      } catch (e, stackTrace) {
        print('!!! Error starting audio recording: $e');
        print('Stack trace: $stackTrace');
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Error starting recording: $e'),
              duration: const Duration(seconds: 5),
            ),
          );
          setState(() => _isRecording = false);
        }
      }
    } else {
      // ========================================
      // NATIVE SPEECH RECOGNITION MODE
      // ========================================
      print('🎤 Starting native speech recognition...');

      // Check if the requested locale is available
      final availableLocales = await _speech.locales();
      final requestedLocaleAvailable = availableLocales.any(
        (locale) => locale.localeId.toLowerCase().startsWith(languageCode.toLowerCase())
      );

      print('Requested locale available: $requestedLocaleAvailable');
      if (!requestedLocaleAvailable && availableLocales.isNotEmpty) {
        print('!!! Warning: Requested locale "$languageCode" not found in available locales');
        print('Available locales: ${availableLocales.take(10).map((l) => l.localeId).join(", ")}');
      }

      // Start speech-to-text for word recognition
      try {
        print('Attempting to start speech recognition...');
        print('Using locale: $languageCode');

        bool listeningStarted = false;
        bool soundDetected = false;
        double maxSoundLevel = 0.0;

        await _speech.listen(
          onResult: (result) {
            print('>>> Speech result received:');
            print('    Recognized: ${result.recognizedWords}');
            print('    Confidence: ${result.confidence}');
            print('    Final result: ${result.finalResult}');

            if (!listeningStarted) {
              listeningStarted = true;
              print('✓ Speech recognition started successfully');
            }

            if (mounted) {
              setState(() {
                _recordedText = result.recognizedWords;
              });
            }
          },
          localeId: languageCode,
          pauseFor: const Duration(seconds: 5),
          listenFor: const Duration(seconds: 60),
          onSoundLevelChange: (level) {
            if (level > maxSoundLevel) {
              maxSoundLevel = level;
            }

            if (level > 0.1 && !soundDetected) {
              soundDetected = true;
              print('✓ Sound detected! Level: $level');
            }
            if (DateTime.now().millisecond % 500 < 100) {
              print('Sound level: $level (max: $maxSoundLevel)');
            }
          },
        );

        print('✓ Speech listen command executed successfully');

        final isListening = _speech.isListening;
        print('Is actually listening: $isListening');

        if (!isListening) {
          print('!!! Warning: Speech recognition is not in listening state after listen() call');
        } else {
          if (mounted) {
            final l10n = AppLocalizations.of(context)!;
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(l10n.speakNow),
                duration: const Duration(seconds: 3),
                backgroundColor: Theme.of(context).colorScheme.primary,
              ),
            );
          }
        }

        // Also start audio recording for waveform analysis
        try {
          final hasPermission = await _audioRecorder.hasPermission();
          if (hasPermission) {
            final directory = await getTemporaryDirectory();
            final filePath = '${directory.path}/recording_${DateTime.now().millisecondsSinceEpoch}.m4a';
            await _audioRecorder.start(
              const RecordConfig(
                encoder: AudioEncoder.aacLc,
                sampleRate: 44100,
                bitRate: 128000,
              ),
              path: filePath,
            );
            _recordedAudioPath = filePath;
            print('✓ Audio recording started successfully (native mode)');
          }
        } catch (e) {
          print('Warning: Could not start audio recording: $e');
        }

      } catch (e, stackTrace) {
        print('!!! Error starting speech recognition: $e');
        print('Stack trace: $stackTrace');
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('${AppLocalizations.of(context)!.voiceInputPlaceholder}\n\nError: $e'),
              duration: const Duration(seconds: 5),
            ),
          );
          setState(() => _isRecording = false);
          return;
        }
      }
    }

    print('=== Recording setup complete ===');
  }

  Future<void> _stopRecording() async {
    print('=== Stop Recording Called ===');
    print('Using Whisper API: $_useWhisperAPI');

    // Stop amplitude monitoring
    _stopAmplitudeMonitoring();

    if (_useWhisperAPI) {
      // ========================================
      // WHISPER API MODE - Process recorded audio
      // ========================================
      print('🎙️ Stopping audio recording...');

      try{
        final audioPath = await _audioRecorder.stop();
        print('Audio recording stopped, path: $audioPath');

        if (audioPath != null && await File(audioPath).exists()) {
          final fileSize = await File(audioPath).length();
          print('Audio file size: $fileSize bytes');

          // Check recording duration
          final recordingDuration = _recordingStartTime != null
              ? DateTime.now().difference(_recordingStartTime!)
              : Duration.zero;
          print('Recording duration: ${recordingDuration.inMilliseconds}ms');

          // Minimum duration check (0.1 seconds = 100ms)
          if (recordingDuration.inMilliseconds < 100) {
            print('⚠️ Recording too short: ${recordingDuration.inMilliseconds}ms (minimum: 100ms)');

            setState(() => _isRecording = false);

            if (mounted) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(
                    AppLocalizations.of(context)!.recordingTooShort,
                  ),
                  duration: const Duration(seconds: 5),
                  backgroundColor: Theme.of(context).colorScheme.error,
                ),
              );
            }
            return;
          }

          // Check file size (should be at least a few KB for valid audio)
          if (fileSize < 1000) {
            print('⚠️ Audio file too small: $fileSize bytes (suspicious)');

            setState(() => _isRecording = false);

            if (mounted) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(
                    AppLocalizations.of(context)!.recordingTooShort,
                  ),
                  duration: const Duration(seconds: 5),
                  backgroundColor: Theme.of(context).colorScheme.error,
                ),
              );
            }
            return;
          }

          if (fileSize > 0 && mounted) {
            setState(() => _isRecording = false);

            // Play back the user's recording if enabled (while processing in background)
            if (_playbackAfterRecording) {
              print('🔊 Playing back user recording...');
              try {
                // Play the recorded audio asynchronously (don't wait)
                _audioPlayer.play(DeviceFileSource(audioPath));
              } catch (e) {
                print('Warning: Could not play back recording: $e');
              }
            }

            // Show processing message
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(AppLocalizations.of(context)!.processingAudio),
                duration: const Duration(seconds: 30), // Long duration while processing
              ),
            );

            // Transcribe using Whisper API (in parallel with playback)
            final currentItem = _filteredItems[_currentItemIndex];
            final languageData = _displayLanguage1
                ? currentItem.language1Data
                : currentItem.language2Data;
            final languageCode = languageData.languageCode.split('-')[0];
            final expectedText = '${languageData.preItem?.isNotEmpty ?? false ? "${languageData.preItem} " : ""}${languageData.text}';

            print('📤 Sending to OpenAI Whisper API...');
            print('   Expected text: "$expectedText"');

            try {
              final result = await _speechRecognitionService!.transcribeAudio(
                audioFilePath: audioPath,
                language: languageCode,
                prompt: expectedText, // Helps Whisper understand context
              );

              print('✓ Whisper transcription received: "${result.text}"');
              print('   Detected language: ${result.language}');
              print('   Audio duration: ${result.duration}s');

              setState(() {
                _recordedText = result.text;
              });

              // Hide processing message
              if (mounted) {
                ScaffoldMessenger.of(context).hideCurrentSnackBar();
              }

              // Generate reference audio using TTS
              await _generateReferenceAudio(expectedText, languageData.languageCode);

              // Speak the correct pronunciation
              await _ttsService.speak(expectedText, languageData.languageCode);

              // Calculate match rate
              await _calculateMatchRate(currentItem);

              setState(() {
                _hasRecorded = true;
                _totalPracticed++;
              });

            } catch (e) {
              print('!!! Error transcribing with Whisper: $e');

              // Hide processing message
              if (mounted) {
                ScaffoldMessenger.of(context).hideCurrentSnackBar();

                String errorMessage = 'Error transcribing audio: $e';
                String? guidance;

                if (e.toString().contains('too short') || e.toString().contains('0.1 seconds')) {
                  errorMessage = AppLocalizations.of(context)!.recordingTooShort;
                  guidance = 'Please speak for at least 1 second before stopping.\n\n'
                      'Tips:\n'
                      '• Speak the full phrase slowly\n'
                      '• Hold record button longer\n'
                      '• Count to 2 before stopping';
                } else if (e.toString().contains('Invalid OpenAI API key')) {
                  errorMessage = 'Invalid OpenAI API key. Please check your API key in Settings.';
                } else if (e.toString().contains('rate limit')) {
                  errorMessage = 'OpenAI API rate limit exceeded. Please try again later.';
                } else if (e.toString().contains('file too large') || e.toString().contains('25MB')) {
                  errorMessage = 'Audio file too large (max 25MB)';
                  guidance = 'Try recording for a shorter duration.';
                }

                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(guidance != null ? '$errorMessage\n\n$guidance' : errorMessage),
                    duration: const Duration(seconds: 7),
                    action: guidance == null ? SnackBarAction(
                      label: 'Settings',
                      onPressed: () => Navigator.pushNamed(context, '/settings'),
                    ) : null,
                  ),
                );

                setState(() => _isRecording = false);
              }
            }
          } else {
            print('!!! Audio file is empty or does not exist');
            if (mounted) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(AppLocalizations.of(context)!.noSpeechDetected),
                  duration: const Duration(seconds: 3),
                ),
              );
              setState(() => _isRecording = false);
            }
          }
        } else {
          print('!!! No audio file was created');
          if (mounted) {
            setState(() => _isRecording = false);
          }
        }
      } catch (e, stackTrace) {
        print('!!! Error stopping audio recording: $e');
        print('Stack trace: $stackTrace');
        if (mounted) {
          setState(() => _isRecording = false);
        }
      }
    } else {
      // ========================================
      // NATIVE SPEECH RECOGNITION MODE
      // ========================================
      print('Speech is listening: ${_speech.isListening}');
      print('Recorded text so far: "$_recordedText"');

      await _speech.stop();
      print('Speech recognition stopped');

      // Stop audio recording
      try {
        final audioPath = await _audioRecorder.stop();
        print('Audio recording stopped, path: $audioPath');

        if (audioPath != null && await File(audioPath).exists()) {
          final fileSize = await File(audioPath).length();
          print('Audio file size: $fileSize bytes');
        }
      } catch (e) {
        print('!!! Error stopping audio recording: $e');
      }

      if (mounted) {
        setState(() => _isRecording = false);

        if (_recordedText.isNotEmpty) {
          print('✓ Text was recognized: "$_recordedText"');

          // Generate reference audio using TTS
          final currentItem = _filteredItems[_currentItemIndex];
          final languageData = _displayLanguage1
              ? currentItem.language1Data
              : currentItem.language2Data;
          final fullText =
              '${languageData.preItem?.isNotEmpty ?? false ? "${languageData.preItem} " : ""}${languageData.text}';

          print('Expected text: "$fullText"');

          // Generate reference audio file (if needed)
          await _generateReferenceAudio(fullText, languageData.languageCode);

          // Speak the correct pronunciation
          await _ttsService.speak(fullText, languageData.languageCode);

          // Calculate match rate (word match + audio similarity)
          await _calculateMatchRate(currentItem);

          setState(() {
            _hasRecorded = true;
            _totalPracticed++;
          });
        } else {
          print('!!! No text recognized - possible issues:');
          print('    1. Microphone permission not granted');
          print('    2. Language/locale not supported on device');
          print('    3. No speech detected by recognition engine');
          print('    4. Microphone hardware issue');
          print('    5. Background noise too high');
          print('    6. Speaking too quietly or too far from microphone');

          // Show more helpful error message
          final l10n = AppLocalizations.of(context)!;
          String errorMessage = l10n.noSpeechDetected;

          // Check if we have the last error from speech recognition
          if (_speech.lastError != null && _speech.lastError!.errorMsg.contains('timeout')) {
            errorMessage = 'Speech timeout - Please speak louder and closer to the microphone.\n\n'
                'Tips:\n'
                '• Hold device 6-12 inches from your mouth\n'
                '• Speak clearly at normal volume\n'
                '• Reduce background noise\n'
                '• Start speaking within 2 seconds of pressing record';
          }

          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(errorMessage),
              duration: const Duration(seconds: 5),
              action: SnackBarAction(
                label: 'OK',
                onPressed: () {},
              ),
            ),
          );
        }
      }
    }

    print('=== Stop Recording Complete ===');
  }

  Future<void> _generateReferenceAudio(String text, String languageCode) async {
    try {
      final directory = await getTemporaryDirectory();
      final filePath = '${directory.path}/reference_${DateTime.now().millisecondsSinceEpoch}.wav';

      // Note: TTS doesn't directly save to file in flutter_tts
      // We'll use the TTS service to speak and capture the audio conceptually
      // For a full implementation, you'd need a TTS service that can save to file
      // or use platform-specific TTS APIs that support file output

      _referenceAudioPath = filePath;

      // This is a placeholder - in reality, you'd need to implement
      // platform-specific code to save TTS output to a file
      // For now, we'll work with the recorded audio only
    } catch (e) {
      print('Error generating reference audio: $e');
    }
  }

  Future<void> _calculateMatchRate(Item item) async {
    final languageData =
        _displayLanguage1 ? item.language1Data : item.language2Data;
    final fullText =
        '${languageData.preItem?.isNotEmpty ?? false ? "${languageData.preItem} " : ""}${languageData.text}'
            .toLowerCase()
            .trim();
    final recorded = _recordedText.toLowerCase().trim();

    if (recorded.isEmpty) {
      setState(() => _matchRate = 0.0);
      return;
    }

    print('🎯 Calculating match rate:');
    print('   Expected: "$fullText"');
    print('   Recorded: "$recorded"');

    // 1. Word-level matching (primary metric for Whisper API)
    final expectedWords = fullText.split(RegExp(r'\s+'));
    final recordedWords = recorded.split(RegExp(r'\s+'));

    int matchedWords = 0;
    for (final word in recordedWords) {
      if (expectedWords.any((expected) => expected.contains(word) || word.contains(expected))) {
        matchedWords++;
      }
    }

    final wordMatchRate = expectedWords.isNotEmpty
        ? matchedWords / expectedWords.length
        : 0.0;

    print('   Word match: $matchedWords/${expectedWords.length} = ${(wordMatchRate * 100).toStringAsFixed(1)}%');

    // 2. Character-level similarity (Levenshtein distance)
    final charMatchRate = _calculateStringSimilarity(fullText, recorded);
    print('   Char similarity: ${(charMatchRate * 100).toStringAsFixed(1)}%');

    // For Whisper API: prioritize word matching (90%) with character similarity (10%)
    // This gives better results since Whisper transcription is highly accurate
    final combinedRate = _useWhisperAPI
        ? (wordMatchRate * 0.9 + charMatchRate * 0.1)
        : (wordMatchRate * 0.7 + charMatchRate * 0.3);

    final finalRate = (combinedRate * 100).clamp(0.0, 100.0);
    print('   Final rate: ${finalRate.toStringAsFixed(1)}%');

    setState(() {
      _matchRate = finalRate;
    });
  }

  /// Calculate string similarity using a simplified algorithm
  double _calculateStringSimilarity(String expected, String recorded) {
    if (expected.isEmpty && recorded.isEmpty) return 1.0;
    if (expected.isEmpty || recorded.isEmpty) return 0.0;

    // Remove extra spaces and normalize
    final exp = expected.replaceAll(RegExp(r'\s+'), ' ').trim();
    final rec = recorded.replaceAll(RegExp(r'\s+'), ' ').trim();

    // Calculate similarity based on matching characters
    int matches = 0;
    final maxLen = exp.length > rec.length ? exp.length : rec.length;
    final minLen = exp.length < rec.length ? exp.length : rec.length;

    for (int i = 0; i < minLen; i++) {
      if (exp[i] == rec[i]) matches++;
    }

    return matches / maxLen;
  }

  /// Analyzes audio characteristics: volume patterns and rhythm
  /// Returns a normalized score between 0.0 and 1.0
  Future<double> _analyzeAudioSimilarity(String expectedText) async {
    try {
      if (_recordedAudioPath == null || !await File(_recordedAudioPath!).exists()) {
        return 0.0;
      }

      // Read the audio file
      final audioFile = File(_recordedAudioPath!);
      final audioBytes = await audioFile.readAsBytes();

      // Extract audio features
      final audioFeatures = _extractAudioFeatures(audioBytes);

      // Calculate expected duration based on text length
      // Average speaking rate: ~150 words per minute = 2.5 words per second
      final words = expectedText.split(RegExp(r'\s+'));
      final expectedDuration = words.length / 2.5; // in seconds

      // 1. Duration similarity (normalized)
      final durationScore = _calculateDurationScore(
        audioFeatures['duration'] ?? 0.0,
        expectedDuration,
      );

      // 2. Volume/energy patterns (syllable stress detection)
      final volumeScore = _calculateVolumePatternScore(
        audioFeatures['volumePattern'] ?? [],
        words.length,
      );

      // 3. Rhythm score (pauses and pacing)
      final rhythmScore = _calculateRhythmScore(
        audioFeatures['volumePattern'] ?? [],
        words.length,
      );

      // Combine audio metrics
      final audioScore = (durationScore * 0.3 + volumeScore * 0.4 + rhythmScore * 0.3);

      return audioScore.clamp(0.0, 1.0);
    } catch (e) {
      print('Error analyzing audio similarity: $e');
      return 0.0;
    }
  }

  /// Extract basic audio features from raw audio data
  Map<String, dynamic> _extractAudioFeatures(Uint8List audioBytes) {
    // This is a simplified implementation
    // For production, you'd use audio processing libraries

    // Estimate duration from file size (very rough approximation)
    // AAC LC at 128kbps = 16KB per second
    final durationSeconds = audioBytes.length / (16 * 1024);

    // Extract volume pattern by sampling the audio data
    // This is a simplified approach - real implementation would need proper audio decoding
    final volumePattern = <double>[];
    const sampleInterval = 1000; // Sample every 1000 bytes

    for (int i = 0; i < audioBytes.length; i += sampleInterval) {
      final endIdx = math.min(i + sampleInterval, audioBytes.length);
      final chunk = audioBytes.sublist(i, endIdx);

      // Calculate RMS (root mean square) as volume indicator
      double sumSquares = 0;
      for (final byte in chunk) {
        final normalized = (byte - 128) / 128.0; // Normalize to -1 to 1
        sumSquares += normalized * normalized;
      }
      final rms = math.sqrt(sumSquares / chunk.length);
      volumePattern.add(rms);
    }

    // Normalize volume pattern
    if (volumePattern.isNotEmpty) {
      final maxVolume = volumePattern.reduce(math.max);
      if (maxVolume > 0) {
        for (int i = 0; i < volumePattern.length; i++) {
          volumePattern[i] = volumePattern[i] / maxVolume;
        }
      }
    }

    return {
      'duration': durationSeconds,
      'volumePattern': volumePattern,
      'averageVolume': volumePattern.isEmpty
          ? 0.0
          : volumePattern.reduce((a, b) => a + b) / volumePattern.length,
    };
  }

  /// Calculate how well the duration matches expected duration
  double _calculateDurationScore(double actualDuration, double expectedDuration) {
    if (expectedDuration <= 0) return 0.0;

    final ratio = actualDuration / expectedDuration;

    // Penalize if too fast (<0.7x) or too slow (>1.5x)
    if (ratio < 0.7 || ratio > 1.5) {
      return math.max(0.0, 1.0 - (ratio - 1.0).abs());
    }

    // Optimal range: 0.8x to 1.2x
    if (ratio >= 0.8 && ratio <= 1.2) {
      return 1.0;
    }

    // Gradual decrease outside optimal range
    return 1.0 - ((ratio - 1.0).abs() - 0.2) / 0.3;
  }

  /// Analyze volume pattern to detect proper stress and intonation
  double _calculateVolumePatternScore(List<double> volumePattern, int expectedWords) {
    if (volumePattern.isEmpty || expectedWords <= 0) return 0.0;

    // Check for dynamic range (good pronunciation has varied volume)
    final maxVolume = volumePattern.reduce(math.max);
    final minVolume = volumePattern.reduce(math.min);
    final dynamicRange = maxVolume - minVolume;

    // Good pronunciation should have at least 0.3 dynamic range (normalized)
    final dynamicRangeScore = (dynamicRange / 0.3).clamp(0.0, 1.0);

    // Check for presence of volume peaks (stress on syllables)
    int peakCount = 0;
    for (int i = 1; i < volumePattern.length - 1; i++) {
      if (volumePattern[i] > volumePattern[i - 1] &&
          volumePattern[i] > volumePattern[i + 1] &&
          volumePattern[i] > 0.5) {
        peakCount++;
      }
    }

    // Expected: roughly one peak per word (can vary)
    final peakScore = expectedWords > 0
        ? (1.0 - ((peakCount - expectedWords).abs() / expectedWords)).clamp(0.0, 1.0)
        : 0.5;

    return (dynamicRangeScore * 0.6 + peakScore * 0.4);
  }

  /// Analyze rhythm and pacing
  double _calculateRhythmScore(List<double> volumePattern, int expectedWords) {
    if (volumePattern.isEmpty || expectedWords <= 0) return 0.0;

    // Detect pauses (low volume segments)
    final threshold = 0.2;
    int pauseCount = 0;
    bool inPause = false;

    for (final volume in volumePattern) {
      if (volume < threshold && !inPause) {
        pauseCount++;
        inPause = true;
      } else if (volume >= threshold) {
        inPause = false;
      }
    }

    // Natural speech has some pauses, but not too many
    // Expected: 0-2 pauses per sentence depending on length
    final expectedPauses = (expectedWords / 5).clamp(0.0, 3.0);
    final pauseScore = pauseCount > 0
        ? (1.0 - ((pauseCount - expectedPauses).abs() / 3.0)).clamp(0.0, 1.0)
        : 0.7;

    // Check for consistent pacing (standard deviation of segment volumes)
    if (volumePattern.length > 1) {
      final mean = volumePattern.reduce((a, b) => a + b) / volumePattern.length;
      final variance = volumePattern
          .map((v) => math.pow(v - mean, 2))
          .reduce((a, b) => a + b) / volumePattern.length;
      final stdDev = math.sqrt(variance);

      // Moderate variance is good (0.15-0.35), too low or high is bad
      final consistencyScore = stdDev >= 0.15 && stdDev <= 0.35
          ? 1.0
          : (1.0 - ((stdDev - 0.25).abs() / 0.25)).clamp(0.0, 1.0);

      return (pauseScore * 0.5 + consistencyScore * 0.5);
    }

    return pauseScore;
  }

  void _nextItem() {
    if (_currentItemIndex < _filteredItems.length - 1) {
      // Clean up audio files
      _cleanupAudioFiles();

      setState(() {
        _currentItemIndex++;
        _hasRecorded = false;
        _matchRate = 0.0;
        _recordedText = '';
        _recordedAudioPath = null;
        _referenceAudioPath = null;

        // Redetermine display language if random
        if (widget.settings.displayLanguage == DisplayLanguage.random) {
          _displayLanguage1 = math.Random().nextBool();
        }
      });
    } else {
      _endPractice();
    }
  }

  void _endPractice() {
    Navigator.of(context).pop();
  }

  void _speakCurrentItem() {
    if (_filteredItems.isEmpty) return;

    final currentItem = _filteredItems[_currentItemIndex];
    final languageData =
        _displayLanguage1 ? currentItem.language1Data : currentItem.language2Data;
    final fullText =
        '${languageData.preItem?.isNotEmpty ?? false ? "${languageData.preItem} " : ""}${languageData.text}';

    _ttsService.speak(fullText, languageData.languageCode);
  }

  @override
  Widget build(BuildContext context) {
    // Watch settings to rebuild when they change
    ref.watch(appSettingsProvider);

    final l10n = AppLocalizations.of(context)!;
    final theme = Theme.of(context);
    final mediaQuery = MediaQuery.of(context);
    final isTablet = mediaQuery.size.shortestSide >= 600;

    if (_isLoading) {
      return Scaffold(
        appBar: AppBar(title: Text(l10n.pronunciationPractice)),
        body: const Center(child: CircularProgressIndicator()),
      );
    }

    if (_filteredItems.isEmpty) {
      return Scaffold(
        appBar: AppBar(title: Text(l10n.pronunciationPractice)),
        body: Center(
          child: Padding(
            padding: const EdgeInsets.all(AppTheme.spacing24),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.inbox,
                  size: 64,
                  color: theme.colorScheme.onSurfaceVariant,
                ),
                const SizedBox(height: AppTheme.spacing16),
                Text(
                  l10n.noItemsToTrain,
                  style: theme.textTheme.titleLarge,
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),
        ),
      );
    }

    final currentItem = _filteredItems[_currentItemIndex];

    return Scaffold(
      appBar: AppBar(
        title: Text(
          l10n.pronunciationPractice,
          style: theme.textTheme.titleMedium,
        ),
      ),
      body: GestureDetector(
        onHorizontalDragEnd: (details) {
          // Swipe left to right = next item
          if (details.primaryVelocity != null && details.primaryVelocity! > 300) {
            _nextItem();
          }
          // Swipe right to left = end practice
          else if (details.primaryVelocity != null && details.primaryVelocity! < -300) {
            _endPractice();
          }
        },
        child: SafeArea(
          child: SingleChildScrollView(
            padding: EdgeInsets.all(isTablet ? AppTheme.spacing16 : AppTheme.spacing8),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // Info banner showing speech recognition mode
                _buildModeInfoBanner(theme, l10n),
                SizedBox(height: isTablet ? AppTheme.spacing12 : AppTheme.spacing8),

                // Playback preference checkbox (only for Whisper API mode)
                if (_useWhisperAPI) ...[
                  _buildPlaybackCheckbox(theme, l10n),
                  SizedBox(height: isTablet ? AppTheme.spacing12 : AppTheme.spacing8),
                ],

                // Status indicators
                _buildStatusIndicators(theme, l10n),
                SizedBox(height: isTablet ? AppTheme.spacing16 : AppTheme.spacing8),

                // Item to pronounce
                _buildPronunciationItem(theme, l10n, currentItem, isTablet),
                SizedBox(height: isTablet ? AppTheme.spacing16 : AppTheme.spacing8),

                // Tachometer (only shown after recording)
                if (_hasRecorded) ...[
                  _buildTachometer(theme, l10n, isTablet),
                  SizedBox(height: isTablet ? AppTheme.spacing16 : AppTheme.spacing8),
                ],

                // Navigation buttons
                _buildNavigationButtons(theme, l10n, isTablet),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildModeInfoBanner(ThemeData theme, AppLocalizations l10n) {
    if (_useWhisperAPI) {
      // Premium mode - Whisper API
      return Container(
        padding: const EdgeInsets.all(AppTheme.spacing12),
        decoration: BoxDecoration(
          color: theme.colorScheme.primaryContainer,
          borderRadius: BorderRadius.circular(AppTheme.radiusMedium),
        ),
        child: Row(
          children: [
            Icon(
              Icons.verified,
              color: theme.colorScheme.primary,
              size: 24,
            ),
            const SizedBox(width: AppTheme.spacing8),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '🎙️ Premium Mode: AI Speech Recognition',
                    style: theme.textTheme.titleSmall?.copyWith(
                      color: theme.colorScheme.onPrimaryContainer,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    'Record manually - no timeouts. High accuracy with OpenAI Whisper.',
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: theme.colorScheme.onPrimaryContainer,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      );
    } else if (_speechAvailable) {
      // Native mode - fallback
      return Container(
        padding: const EdgeInsets.all(AppTheme.spacing12),
        decoration: BoxDecoration(
          color: theme.colorScheme.tertiaryContainer,
          borderRadius: BorderRadius.circular(AppTheme.radiusMedium),
          border: Border.all(
            color: theme.colorScheme.tertiary.withValues(alpha: 0.5),
            width: 1,
          ),
        ),
        child: Row(
          children: [
            Icon(
              Icons.info_outline,
              color: theme.colorScheme.tertiary,
              size: 24,
            ),
            const SizedBox(width: AppTheme.spacing8),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '📱 Basic Mode: Native Speech Recognition',
                    style: theme.textTheme.titleSmall?.copyWith(
                      color: theme.colorScheme.onTertiaryContainer,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    'Auto-timeout may occur. Add OpenAI API key in Settings for better experience.',
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: theme.colorScheme.onTertiaryContainer,
                    ),
                  ),
                ],
              ),
            ),
            IconButton(
              icon: Icon(
                Icons.settings,
                color: theme.colorScheme.tertiary,
                size: 20,
              ),
              onPressed: () {
                Navigator.pushNamed(context, '/settings');
              },
              tooltip: l10n.settings,
            ),
          ],
        ),
      );
    } else {
      // Speech recognition not available
      return Container(
        padding: const EdgeInsets.all(AppTheme.spacing12),
        decoration: BoxDecoration(
          color: theme.colorScheme.errorContainer,
          borderRadius: BorderRadius.circular(AppTheme.radiusMedium),
        ),
        child: Row(
          children: [
            Icon(
              Icons.warning,
              color: theme.colorScheme.error,
              size: 24,
            ),
            const SizedBox(width: AppTheme.spacing8),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '⚠️ Speech Recognition Unavailable',
                    style: theme.textTheme.titleSmall?.copyWith(
                      color: theme.colorScheme.onErrorContainer,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    'Add OpenAI API key in Settings to enable pronunciation practice.',
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: theme.colorScheme.onErrorContainer,
                    ),
                  ),
                ],
              ),
            ),
            IconButton(
              icon: Icon(
                Icons.settings,
                color: theme.colorScheme.error,
                size: 20,
              ),
              onPressed: () {
                Navigator.pushNamed(context, '/settings');
              },
              tooltip: l10n.settings,
            ),
          ],
        ),
      );
    }
  }

  Widget _buildPlaybackCheckbox(ThemeData theme, AppLocalizations l10n) {
    return Card(
      elevation: 1,
      child: CheckboxListTile(
        dense: true,
        contentPadding: const EdgeInsets.symmetric(
          horizontal: AppTheme.spacing12,
          vertical: 0,
        ),
        title: Row(
          children: [
            Icon(
              Icons.play_circle_outline,
              size: 20,
              color: theme.colorScheme.primary,
            ),
            const SizedBox(width: AppTheme.spacing8),
            Expanded(
              child: Text(
                l10n.playbackRecording,
                style: theme.textTheme.bodyMedium,
              ),
            ),
          ],
        ),
        subtitle: Text(
          l10n.playbackRecordingSubtitle,
          style: theme.textTheme.bodySmall?.copyWith(
            color: theme.colorScheme.onSurfaceVariant,
          ),
        ),
        value: _playbackAfterRecording,
        onChanged: (bool? value) {
          if (value != null) {
            _savePlaybackPreference(value);
          }
        },
        activeColor: theme.colorScheme.primary,
      ),
    );
  }

  Widget _buildStatusIndicators(ThemeData theme, AppLocalizations l10n) {
    return Card(
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(AppTheme.spacing8),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            _buildStatusItem(
              theme,
              Icons.format_list_numbered,
              l10n.items,
              '${_currentItemIndex + 1}/${_filteredItems.length}',
            ),
            _buildStatusItem(
              theme,
              Icons.check_circle,
              l10n.practiced,
              _totalPracticed.toString(),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatusItem(
    ThemeData theme,
    IconData icon,
    String label,
    String value,
  ) {
    return Column(
      children: [
        Icon(icon, size: 20, color: theme.colorScheme.primary),
        const SizedBox(height: AppTheme.spacing4),
        Text(
          value,
          style: theme.textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.bold,
            color: theme.colorScheme.primary,
          ),
        ),
        Text(
          label,
          style: theme.textTheme.bodySmall?.copyWith(
            color: theme.colorScheme.onSurfaceVariant,
            fontSize: 10,
          ),
        ),
      ],
    );
  }

  Widget _buildPronunciationItem(
    ThemeData theme,
    AppLocalizations l10n,
    Item item,
    bool isTablet,
  ) {
    final languageData =
        _displayLanguage1 ? item.language1Data : item.language2Data;
    final preText = languageData.preItem ?? '';
    final mainText = languageData.text;
    final languageCode = (_displayLanguage1
            ? widget.package.languageCode1
            : widget.package.languageCode2)
        .split('-')[0]
        .toUpperCase();

    return Card(
      elevation: 2,
      color: theme.colorScheme.primaryContainer,
      child: Padding(
        padding: EdgeInsets.all(isTablet ? AppTheme.spacing16 : AppTheme.spacing8),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header with language code and speaker icon
            Row(
              children: [
                Expanded(
                  child: Text(
                    '${l10n.pronounce} - $languageCode',
                    style: theme.textTheme.titleMedium?.copyWith(
                      color: theme.colorScheme.onPrimaryContainer,
                      fontWeight: FontWeight.bold,
                      fontSize: isTablet ? null : 14,
                    ),
                  ),
                ),
                IconButton(
                  icon: Icon(
                    Icons.volume_up,
                    color: theme.colorScheme.onPrimaryContainer,
                    size: isTablet ? 24 : 20,
                  ),
                  tooltip: l10n.listenToPronunciation,
                  onPressed: _speakCurrentItem,
                ),
              ],
            ),
            SizedBox(height: isTablet ? AppTheme.spacing12 : AppTheme.spacing8),

            // Text to pronounce
            if (preText.isNotEmpty) ...[
              Text(
                preText,
                style: theme.textTheme.bodyMedium?.copyWith(
                  color: theme.colorScheme.onPrimaryContainer.withValues(alpha: 0.8),
                  fontStyle: FontStyle.italic,
                  fontSize: isTablet ? null : 12,
                ),
              ),
              const SizedBox(height: AppTheme.spacing4),
            ],
            Text(
              mainText,
              style: theme.textTheme.headlineSmall?.copyWith(
                color: theme.colorScheme.onPrimaryContainer,
                fontWeight: FontWeight.bold,
                fontSize: isTablet ? null : 18,
              ),
            ),
            SizedBox(height: isTablet ? AppTheme.spacing16 : AppTheme.spacing12),

            // Microphone button
            Center(
              child: Column(
                children: [
                  Container(
                    width: isTablet ? 80 : 60,
                    height: isTablet ? 80 : 60,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: _isRecording
                          ? theme.colorScheme.error
                          : theme.colorScheme.secondary,
                      boxShadow: _isRecording
                          ? [
                              BoxShadow(
                                color: theme.colorScheme.error.withValues(alpha: 0.5),
                                blurRadius: 20,
                                spreadRadius: 5,
                              ),
                            ]
                          : null,
                    ),
                    child: IconButton(
                      icon: Icon(
                        _isRecording ? Icons.stop : Icons.mic,
                        color: _isRecording
                            ? theme.colorScheme.onError
                            : theme.colorScheme.onSecondary,
                        size: isTablet ? 40 : 30,
                      ),
                      onPressed: _isRecording ? _stopRecording : _startRecording,
                    ),
                  ),
                  SizedBox(height: isTablet ? AppTheme.spacing12 : AppTheme.spacing8),
                  Text(
                    _isRecording
                        ? l10n.recording
                        : (_hasRecorded ? l10n.recorded : l10n.tapToRecord),
                    style: theme.textTheme.bodyMedium?.copyWith(
                      color: theme.colorScheme.onPrimaryContainer,
                      fontWeight: FontWeight.w500,
                      fontSize: isTablet ? null : 12,
                    ),
                  ),

                  // Volume meter during recording
                  if (_isRecording) ...[
                    SizedBox(height: isTablet ? AppTheme.spacing12 : AppTheme.spacing8),
                    _buildVolumeMeter(theme, isTablet),
                  ],

                  if (_recordedText.isNotEmpty) ...[
                    SizedBox(height: isTablet ? AppTheme.spacing8 : AppTheme.spacing4),
                    Text(
                      '"$_recordedText"',
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: theme.colorScheme.onPrimaryContainer.withValues(alpha: 0.7),
                        fontStyle: FontStyle.italic,
                        fontSize: isTablet ? null : 11,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTachometer(ThemeData theme, AppLocalizations l10n, bool isTablet) {
    return Card(
      elevation: 2,
      child: Padding(
        padding: EdgeInsets.all(isTablet ? AppTheme.spacing16 : AppTheme.spacing12),
        child: Column(
          children: [
            Text(
              l10n.pronunciationAccuracy,
              style: theme.textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.bold,
                fontSize: isTablet ? null : 14,
              ),
            ),
            SizedBox(height: isTablet ? AppTheme.spacing16 : AppTheme.spacing12),

            // Tachometer widget
            SizedBox(
              height: isTablet ? 200 : 150,
              child: CustomPaint(
                painter: TachometerPainter(
                  percentage: _matchRate,
                  theme: theme,
                ),
                child: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      SizedBox(height: isTablet ? 40 : 30),
                      TweenAnimationBuilder<double>(
                        duration: const Duration(milliseconds: 1000),
                        curve: Curves.easeOutCubic,
                        tween: Tween<double>(begin: 0, end: _matchRate),
                        builder: (context, value, child) {
                          return Text(
                            '${value.toStringAsFixed(0)}%',
                            style: theme.textTheme.displayMedium?.copyWith(
                              fontWeight: FontWeight.bold,
                              color: _getMatchRateColor(theme, value),
                              fontSize: isTablet ? 48 : 36,
                            ),
                          );
                        },
                      ),
                      Text(
                        _getMatchRateLabel(l10n, _matchRate),
                        style: theme.textTheme.bodyMedium?.copyWith(
                          color: theme.colorScheme.onSurfaceVariant,
                          fontSize: isTablet ? null : 12,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Color _getMatchRateColor(ThemeData theme, double rate) {
    if (rate >= 80) return Colors.green;
    if (rate >= 60) return Colors.lightGreen;
    if (rate >= 40) return Colors.orange;
    if (rate >= 20) return Colors.deepOrange;
    return theme.colorScheme.error;
  }

  String _getMatchRateLabel(AppLocalizations l10n, double rate) {
    if (rate >= 80) return l10n.excellent;
    if (rate >= 60) return l10n.good;
    if (rate >= 40) return l10n.fair;
    if (rate >= 20) return l10n.needsImprovement;
    return l10n.tryAgain;
  }

  Widget _buildNavigationButtons(ThemeData theme, AppLocalizations l10n, bool isTablet) {
    final buttonPadding = isTablet
        ? const EdgeInsets.symmetric(horizontal: AppTheme.spacing16, vertical: AppTheme.spacing12)
        : const EdgeInsets.symmetric(horizontal: AppTheme.spacing12, vertical: AppTheme.spacing8);
    final fontSize = isTablet ? 16.0 : 14.0;
    final iconSize = isTablet ? 24.0 : 20.0;

    return Row(
      children: [
        Expanded(
          child: FilledButton.icon(
            onPressed: _nextItem,
            icon: Icon(Icons.arrow_forward, size: iconSize),
            label: Text(
              l10n.nextItem,
              style: TextStyle(fontSize: fontSize),
            ),
            style: FilledButton.styleFrom(
              padding: buttonPadding,
            ),
          ),
        ),
        SizedBox(width: isTablet ? AppTheme.spacing12 : AppTheme.spacing8),
        Expanded(
          child: OutlinedButton.icon(
            onPressed: _endPractice,
            icon: Icon(Icons.stop, size: iconSize),
            label: Text(
              l10n.endPractice,
              style: TextStyle(fontSize: fontSize),
            ),
            style: OutlinedButton.styleFrom(
              padding: buttonPadding,
            ),
          ),
        ),
      ],
    );
  }


  Widget _buildVolumeMeter(ThemeData theme, bool isTablet) {
    return Column(
      children: [
        Text(
          'Volume',
          style: theme.textTheme.bodySmall?.copyWith(
            color: theme.colorScheme.onPrimaryContainer.withValues(alpha: 0.7),
            fontSize: isTablet ? null : 10,
          ),
        ),
        const SizedBox(height: 4),
        Container(
          width: isTablet ? 200 : 150,
          height: isTablet ? 8 : 6,
          decoration: BoxDecoration(
            color: theme.colorScheme.onPrimaryContainer.withValues(alpha: 0.2),
            borderRadius: BorderRadius.circular(10),
          ),
          child: FractionallySizedBox(
            alignment: Alignment.centerLeft,
            widthFactor: _currentVolumeLevel.clamp(0.0, 1.0),
            child: Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    Colors.green,
                    Colors.yellow,
                    Colors.orange,
                    Colors.red,
                  ],
                  stops: [0.0, 0.5, 0.75, 1.0],
                ),
                borderRadius: BorderRadius.circular(10),
              ),
            ),
          ),
        ),
      ],
    );
  }
}

// Custom painter for the tachometer
class TachometerPainter extends CustomPainter {
  final double percentage;
  final ThemeData theme;

  TachometerPainter({
    required this.percentage,
    required this.theme,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height * 0.75);
    final radius = size.width * 0.35;

    // Draw background arc (gray)
    final backgroundPaint = Paint()
      ..color = theme.colorScheme.surfaceContainerHighest
      ..style = PaintingStyle.stroke
      ..strokeWidth = 20
      ..strokeCap = StrokeCap.round;

    canvas.drawArc(
      Rect.fromCircle(center: center, radius: radius),
      math.pi,
      math.pi,
      false,
      backgroundPaint,
    );

    // Draw colored zones
    final zones = [
      {'start': 0.0, 'end': 0.2, 'color': theme.colorScheme.error},
      {'start': 0.2, 'end': 0.4, 'color': Colors.deepOrange},
      {'start': 0.4, 'end': 0.6, 'color': Colors.orange},
      {'start': 0.6, 'end': 0.8, 'color': Colors.lightGreen},
      {'start': 0.8, 'end': 1.0, 'color': Colors.green},
    ];

    for (final zone in zones) {
      final zonePaint = Paint()
        ..color = (zone['color'] as Color).withValues(alpha: 0.3)
        ..style = PaintingStyle.stroke
        ..strokeWidth = 20
        ..strokeCap = StrokeCap.round;

      final startAngle = math.pi + (math.pi * (zone['start'] as double));
      final sweepAngle = math.pi * ((zone['end'] as double) - (zone['start'] as double));

      canvas.drawArc(
        Rect.fromCircle(center: center, radius: radius),
        startAngle,
        sweepAngle,
        false,
        zonePaint,
      );
    }

    // Draw progress arc (animated)
    if (percentage > 0) {
      final progressPaint = Paint()
        ..color = _getColorForPercentage(percentage / 100)
        ..style = PaintingStyle.stroke
        ..strokeWidth = 20
        ..strokeCap = StrokeCap.round;

      final sweepAngle = math.pi * (percentage / 100);

      canvas.drawArc(
        Rect.fromCircle(center: center, radius: radius),
        math.pi,
        sweepAngle,
        false,
        progressPaint,
      );

      // Draw needle
      final needleAngle = math.pi + sweepAngle;
      final needleEnd = Offset(
        center.dx + radius * 0.8 * math.cos(needleAngle),
        center.dy + radius * 0.8 * math.sin(needleAngle),
      );

      final needlePaint = Paint()
        ..color = theme.colorScheme.onSurface
        ..style = PaintingStyle.stroke
        ..strokeWidth = 3
        ..strokeCap = StrokeCap.round;

      canvas.drawLine(center, needleEnd, needlePaint);

      // Draw needle center circle
      canvas.drawCircle(
        center,
        6,
        Paint()
          ..color = theme.colorScheme.onSurface
          ..style = PaintingStyle.fill,
      );
    }
  }

  Color _getColorForPercentage(double normalizedPercentage) {
    if (normalizedPercentage >= 0.8) return Colors.green;
    if (normalizedPercentage >= 0.6) return Colors.lightGreen;
    if (normalizedPercentage >= 0.4) return Colors.orange;
    if (normalizedPercentage >= 0.2) return Colors.deepOrange;
    return theme.colorScheme.error;
  }

  @override
  bool shouldRepaint(TachometerPainter oldDelegate) {
    return oldDelegate.percentage != percentage;
  }
}

