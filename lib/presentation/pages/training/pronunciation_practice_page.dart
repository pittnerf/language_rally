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
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:path_provider/path_provider.dart';
import '../../../core/theme/app_theme.dart';
import '../../../core/services/tts_service.dart';
import '../../../core/services/speech_recognition_service.dart';
import '../../../core/utils/debug_print.dart';
import '../../../data/models/training_settings.dart';
import '../../../data/models/language_package.dart';
import '../../../data/models/item.dart';
import '../../../data/repositories/item_repository.dart';
import '../../../data/repositories/category_repository.dart';
import '../../../l10n/app_localizations.dart';
import '../../providers/app_settings_provider.dart';
import '../settings/app_settings_page.dart';
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

  // Sub-scores exposed in the tachometer panel after recording
  double _volumeScore = 0.0; // Envelope (Pearson) similarity
  double _rhythmScore = 0.0; // Rhythm / peak-pattern similarity
  double _textScore  = 0.0; // Text (word + char) similarity

  // Statistics
  int _totalPracticed = 0;

  @override
  void initState() {
    super.initState();
    logDebug('📱 PronunciationPracticePage.initState() called');
    _ttsService.initialize();
    _loadAndFilterItems();
    _loadPlaybackPreference();

    // Set up listener for settings changes - this will handle both initial load and updates
    // Using the same pattern as app_settings_page to ensure API key is properly detected
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      logDebug('📍 postFrameCallback executing...');

      // Check current settings state BEFORE initialization
      final currentSettings = ref.read(appSettingsProvider);
      logDebug('📊 Current settings state at postFrameCallback:');
      logDebug('   - openaiApiKey present: ${currentSettings.openaiApiKey != null && currentSettings.openaiApiKey!.isNotEmpty}');
      if (currentSettings.openaiApiKey != null && currentSettings.openaiApiKey!.isNotEmpty) {
        logDebug('   - openaiApiKey length: ${currentSettings.openaiApiKey!.length}');
        logDebug('   - openaiApiKey prefix: ${currentSettings.openaiApiKey!.substring(0, math.min(10, currentSettings.openaiApiKey!.length))}...');
      }

      // First, initialize with current settings - AWAIT to ensure it completes!
      logDebug('🚀 Calling _initializeSpeechRecognition() for the first time...');
      await _initializeSpeechRecognition();
      logDebug('✅ Initial speech recognition setup complete');

      // Then listen for any FUTURE changes (not the current state)
      ref.listenManual(
        appSettingsProvider,
        (previous, next) {
          logDebug('🔄 Settings provider notified of change:');
          logDebug('   - Previous: ${previous != null ? "exists" : "null"}');
          if (previous != null) {
            logDebug('   - Previous had key: ${previous.openaiApiKey != null && previous.openaiApiKey!.isNotEmpty}');
          }
          logDebug('   - Now has key: ${next.openaiApiKey != null && next.openaiApiKey!.isNotEmpty}');

          // IMPORTANT: Ignore the first notification where previous is null
          // This happens during initial setup and we've already initialized
          if (previous == null) {
            logDebug('ℹ️ Ignoring first listener call (previous is null) - already initialized');
            return;
          }

          // Check if API key changed
          final previousHadKey = previous.openaiApiKey != null && previous.openaiApiKey!.isNotEmpty;
          final nowHasKey = next.openaiApiKey != null && next.openaiApiKey!.isNotEmpty;

          // Re-initialize ONLY if API key status actually changed
          if (previousHadKey != nowHasKey) {
            logDebug('✅ API key status changed from $previousHadKey to $nowHasKey');
            logDebug('   Re-initializing speech recognition...');
            _hasInitializedSpeech = false; // Reset to allow re-initialization
            _initializeSpeechRecognition();
          } else {
            logDebug('ℹ️ Settings changed but API key status unchanged ($previousHadKey -> $nowHasKey), no re-initialization needed');
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
    logDebug('');
    logDebug('═══════════════════════════════════════════════════════════');
    logDebug('⚙️ _initializeSpeechRecognition() called');
    logDebug('   - _hasInitializedSpeech: $_hasInitializedSpeech');
    logDebug('   - _useWhisperAPI: $_useWhisperAPI');
    logDebug('   - Call stack:');
    final stackLines = StackTrace.current.toString().split('\n');
    for (int i = 0; i < math.min(5, stackLines.length); i++) {
      logDebug('     ${stackLines[i]}');
    }
    logDebug('═══════════════════════════════════════════════════════════');
    logDebug('');

    if (_hasInitializedSpeech) {
      logDebug('   ⏭️ Already initialized, skipping');
      return;
    }

    logDebug('   🔒 Setting _hasInitializedSpeech = true');
    _hasInitializedSpeech = true;

    // Get OpenAI API key from settings
    logDebug('   📖 Reading appSettingsProvider...');
    var appSettings = ref.read(appSettingsProvider);
    var openaiApiKey = appSettings.openaiApiKey;

    // CRITICAL FIX: Wait for settings to load if they're still at default values
    // The provider's build() method calls _loadSettings() without awaiting, so on first
    // load the settings might still be loading. We need to wait a bit for them to load.
    if (openaiApiKey == null) {
      logDebug('   ⏳ API key is null, waiting for settings to load...');
      logDebug('   (Settings provider loads asynchronously on first access)');

      // Wait up to 500ms for settings to load, checking every 50ms
      for (int i = 0; i < 10; i++) {
        await Future.delayed(const Duration(milliseconds: 50));
        appSettings = ref.read(appSettingsProvider);
        openaiApiKey = appSettings.openaiApiKey;

        if (openaiApiKey != null && openaiApiKey.isNotEmpty) {
          logDebug('   ✅ Settings loaded after ${(i + 1) * 50}ms - API key found!');
          break;
        }
      }

      if (openaiApiKey == null) {
        logDebug('   ⚠️ Settings still not loaded after 500ms - proceeding with null key');
      }
    }

    logDebug('');
    logDebug('╔═══════════════════════════════════════════════════════════╗');
    logDebug('║      CHECKING OPENAI API KEY AVAILABILITY               ║');
    logDebug('╚═══════════════════════════════════════════════════════════╝');
    logDebug('OpenAI API Key: ${openaiApiKey == null ? "NULL" : openaiApiKey.isEmpty ? "EMPTY STRING" : "PRESENT"}');
    if (openaiApiKey != null && openaiApiKey.isNotEmpty) {
      logDebug('OpenAI API Key length: ${openaiApiKey.length}');
      logDebug('OpenAI API Key (first 10 chars): ${openaiApiKey.substring(0, openaiApiKey.length > 10 ? 10 : openaiApiKey.length)}...');
    }
    logDebug('');

    final hasApiKey = openaiApiKey != null && openaiApiKey.isNotEmpty;
    logDebug('Decision: hasApiKey = $hasApiKey');
    logDebug('');

    // Initialize Whisper service if API key is available
    if (hasApiKey) {
      logDebug('✅ BRANCH: Using OpenAI Whisper API');
      logDebug('   🎯 Creating SpeechRecognitionService with API key...');
      _speechRecognitionService = SpeechRecognitionService(apiKey: openaiApiKey);
      _useWhisperAPI = true;
      _speechAvailable = true;
      logDebug('   🎙️ Using OpenAI Whisper API for speech recognition');
      logDebug('   ✓ High-quality transcription enabled');
      logDebug('   ✓ Manual recording control (no automatic timeout)');
      logDebug('   ✓ No speech timeout issues');
    } else {
      // Fall back to native speech recognition
      logDebug('⚠️ BRANCH: Using native speech recognition');
      logDebug('   Reason: OpenAI API key not found or empty');
      logDebug('   openaiApiKey == null: ${openaiApiKey == null}');
      logDebug('   openaiApiKey.isEmpty: ${openaiApiKey?.isEmpty ?? "N/A"}');
      logDebug('   ⚠️ Note: Native mode has automatic timeout (may cause issues)');
      logDebug('   💡 Add OpenAI API key in Settings for better experience');
      logDebug('   📞 Calling _initializeSpeech()...');
      await _initializeSpeech();
      _useWhisperAPI = false;
    }

    logDebug('🔄 Calling setState() to update UI...');
    if (mounted) {
      setState(() {});
      logDebug('✅ setState() completed, UI should update now');
    } else {
      logDebug('⚠️ Widget not mounted, setState() skipped');
    }
  }

  @override
  void dispose() {
    _ttsService.stop();
    _speech.stop();
    _audioRecorder.dispose();
    _amplitudeTimer?.cancel();
    // Stop playback first so files are not in use when we delete them
    _audioPlayer.stop().whenComplete(() => _audioPlayer.dispose());
    // Fire-and-forget file deletion — cannot await inside dispose()
    final recPath = _recordedAudioPath;
    final refPath = _referenceAudioPath;
    Future(() async {
      try {
        if (recPath != null && await File(recPath).exists()) await File(recPath).delete();
        if (refPath != null && await File(refPath).exists()) await File(refPath).delete();
      } catch (_) {}
    });
    super.dispose();
  }

  Future<void> _cleanupAudioFiles() async {
    // Capture paths and null them immediately so concurrent calls don't re-delete
    final recPath = _recordedAudioPath;
    final refPath = _referenceAudioPath;
    _recordedAudioPath = null;
    _referenceAudioPath = null;
    // Stop playback before deleting the files that may be in use
    try { await _audioPlayer.stop(); } catch (_) {}
    try {
      if (recPath != null && await File(recPath).exists()) {
        await File(recPath).delete();
        logDebug('🗑️ Deleted recorded audio: $recPath');
      }
      if (refPath != null && await File(refPath).exists()) {
        await File(refPath).delete();
        logDebug('🗑️ Deleted reference audio: $refPath');
      }
    } catch (e) {
      logDebug('Error during audio cleanup: $e');
    }
  }

  Future<void> _initializeSpeech() async {
    logDebug('');
    logDebug('╔═══════════════════════════════════════════════════════════╗');
    logDebug('║ 🚨 _initializeSpeech() CALLED (Native Speech Recognition) ║');
    logDebug('║ This should ONLY be called when there is NO OpenAI API!  ║');
    logDebug('╚═══════════════════════════════════════════════════════════╝');
    logDebug('   Current state:');
    logDebug('   - _useWhisperAPI: $_useWhisperAPI');
    logDebug('   - _hasInitializedSpeech: $_hasInitializedSpeech');
    logDebug('   - _speechAvailable: $_speechAvailable');

    // Check if OpenAI key is available in settings
    final appSettings = ref.read(appSettingsProvider);
    final hasOpenAIKey = appSettings.openaiApiKey != null && appSettings.openaiApiKey!.isNotEmpty;
    logDebug('   - OpenAI API key in settings: $hasOpenAIKey');
    if (hasOpenAIKey) {
      logDebug('   - API key length: ${appSettings.openaiApiKey!.length}');
    }

    logDebug('   Call stack:');
    final stackLines = StackTrace.current.toString().split('\n');
    for (int i = 0; i < math.min(10, stackLines.length); i++) {
      logDebug('     $i: ${stackLines[i]}');
    }
    logDebug('');

    // DEFENSIVE CHECK: This should never be called if we're using Whisper API or have an API key
    if (_useWhisperAPI) {
      logDebug('❌ ERROR: _initializeSpeech() called but _useWhisperAPI is TRUE!');
      logDebug('   This is a bug - native speech should not initialize when using Whisper API');
      logDebug('   RETURNING WITHOUT INITIALIZING NATIVE SPEECH');
      logDebug('');
      return; // Don't proceed with native initialization
    }

    if (hasOpenAIKey) {
      logDebug('❌ ERROR: _initializeSpeech() called but OpenAI API key EXISTS!');
      logDebug('   This is a bug - native speech should not initialize when API key is available');
      logDebug('   RETURNING WITHOUT INITIALIZING NATIVE SPEECH');
      logDebug('');
      return; // Don't proceed with native initialization
    }

    logDebug('✓ Proceeding with native speech recognition initialization...');
    logDebug('');

    try {
      logDebug('=== Speech Recognition Initialization ===');
      logDebug('Platform: ${Platform.operatingSystem}');
      logDebug('Is Web: $kIsWeb');

      // Check if running on a supported platform
      final isDesktop = !kIsWeb && (Platform.isWindows || Platform.isLinux || Platform.isMacOS);
      final isAndroid = !kIsWeb && Platform.isAndroid;
      final isIOS = !kIsWeb && Platform.isIOS;

      logDebug('Is Desktop: $isDesktop');
      logDebug('Is Android: $isAndroid');
      logDebug('Is iOS: $isIOS');

      if (isDesktop) {
        logDebug('Warning: Speech recognition support on desktop platforms is limited or unavailable');
      }

      if (isIOS) {
        logDebug('iOS specific checks:');
        logDebug('  - Ensure NSMicrophoneUsageDescription is set in Info.plist');
        logDebug('  - Ensure NSSpeechRecognitionUsageDescription is set in Info.plist');
        logDebug('  - Check Settings > Privacy > Microphone > Language Rally');
        logDebug('  - Check Settings > Privacy > Speech Recognition > Language Rally');
      }

      logDebug('Attempting to initialize speech recognition...');
      _speechAvailable = await _speech.initialize(
        onError: (error) {
          logDebug('!!! Speech recognition error: ${error.errorMsg}');
          logDebug('    Error permanent: ${error.permanent}');

          if (error.errorMsg.contains('timeout')) {
            logDebug('    Speech timeout - user did not speak or speech was too quiet');
          } else if (error.errorMsg.contains('no-speech')) {
            logDebug('    No speech detected - microphone may not be picking up voice');
          }

          if (isIOS) {
            if (error.errorMsg.toLowerCase().contains('permission')) {
              logDebug('    iOS Permission Issue Detected!');
              logDebug('    Go to: Settings > Privacy > Microphone/Speech Recognition > Enable for Language Rally');
            } else if (error.errorMsg.toLowerCase().contains('not available')) {
              logDebug('    iOS Speech Recognition may not be available on this device');
              logDebug('    Check: Settings > General > Language & Region > Siri Language');
            }
          }
        },
        onStatus: (status) {
          logDebug('>>> Speech recognition status: $status');
          if (status == 'notListening') {
            logDebug('    Speech recognition stopped listening');
          } else if (status == 'done') {
            logDebug('    Speech recognition session completed');
          }
        },
      );

      if (!_speechAvailable) {
        logDebug('!!! Speech recognition failed to initialize');
        if (isIOS) {
          logDebug('iOS Troubleshooting:');
          logDebug('  1. Check microphone permission: Settings > Privacy > Microphone');
          logDebug('  2. Check speech recognition permission: Settings > Privacy > Speech Recognition');
          logDebug('  3. Ensure Siri is enabled: Settings > Siri & Search');
          logDebug('  4. Check language support: Settings > General > Language & Region');
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
        logDebug('✓ Speech recognition initialized successfully');

        // Get available locales for debugging
        final locales = await _speech.locales();
        logDebug('Available locales: ${locales.length}');
        if (locales.isNotEmpty) {
          logDebug('First 5 locales: ${locales.take(5).map((l) => l.localeId).join(", ")}');
          if (isIOS) {
            logDebug('iOS Note: Available locales depend on:');
            logDebug('  - Siri language settings');
            logDebug('  - Keyboard languages added to device');
            logDebug('  - iOS version and device model');
          }
        } else if (isIOS) {
          logDebug('!!! No locales available on iOS - possible issues:');
          logDebug('    - Siri not enabled');
          logDebug('    - No keyboard languages configured');
          logDebug('    - Speech recognition permission denied');
        }
      }

      if (mounted) setState(() {});
    } catch (e, stackTrace) {
      logDebug('!!! Exception during speech initialization: $e');
      logDebug('Stack trace: $stackTrace');
      if (Platform.isIOS && e.toString().contains('PlatformException')) {
        logDebug('iOS Platform Exception - Check:');
        logDebug('  1. Info.plist has required permission keys');
        logDebug('  2. App has been granted permissions in Settings');
        logDebug('  3. Device supports speech recognition (iOS 10+)');
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
    logDebug('=== Start Recording Called ===');
    logDebug('Using Whisper API: $_useWhisperAPI');
    logDebug('Speech available: $_speechAvailable');

    if (!_speechAvailable) {
      logDebug('!!! Speech recognition not available, showing error message');
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
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const AppSettingsPage()),
              );
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

    logDebug('Target language code: $languageCode');
    logDebug('Full language code: ${languageData.languageCode}');
    logDebug('Current item text: ${languageData.text}');

    setState(() {
      _isRecording = true;
      _hasRecorded = false;
      _matchRate = 0.0;
      _volumeScore = 0.0;
      _rhythmScore = 0.0;
      _textScore   = 0.0;
      _recordedText = '';
      _recordedAudioPath = null;
      _recordingStartTime = DateTime.now();
    });

    if (_useWhisperAPI) {
      // ========================================
      // WHISPER API MODE - Manual stop only
      // ========================================
      logDebug('📱 Starting audio recording for Whisper API...');
      logDebug('   ⏱️ Recording will continue until user presses STOP button');

      try {
        final hasPermission = await _audioRecorder.hasPermission();
        logDebug('Audio recording permission: $hasPermission');

        if (!hasPermission) {
          logDebug('!!! Audio recording permission not granted');
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
        final filePath = '${directory.path}/recording_${DateTime.now().millisecondsSinceEpoch}.wav';
        logDebug('Audio file path: $filePath');

        await _audioRecorder.start(
          const RecordConfig(
            encoder: AudioEncoder.wav,
            sampleRate: 16000, // 16 kHz mono — optimal for Whisper AND lightweight for analysis
            numChannels: 1,
          ),
          path: filePath,
        );

        _recordedAudioPath = filePath;
        logDebug('✓ Audio recording started successfully (Whisper mode)');
        logDebug('   User controls when to stop recording');

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
        logDebug('!!! Error starting audio recording: $e');
        logDebug('Stack trace: $stackTrace');
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
      logDebug('🎤 Starting native speech recognition...');

      // Check if the requested locale is available
      final availableLocales = await _speech.locales();
      final requestedLocaleAvailable = availableLocales.any(
        (locale) => locale.localeId.toLowerCase().startsWith(languageCode.toLowerCase())
      );

      logDebug('Requested locale available: $requestedLocaleAvailable');
      if (!requestedLocaleAvailable && availableLocales.isNotEmpty) {
        logDebug('!!! Warning: Requested locale "$languageCode" not found in available locales');
        logDebug('Available locales: ${availableLocales.take(10).map((l) => l.localeId).join(", ")}');
      }

      // Start speech-to-text for word recognition
      try {
        logDebug('Attempting to start speech recognition...');
        logDebug('Using locale: $languageCode');

        bool listeningStarted = false;
        bool soundDetected = false;
        double maxSoundLevel = 0.0;

        await _speech.listen(
          onResult: (result) {
            logDebug('>>> Speech result received:');
            logDebug('    Recognized: ${result.recognizedWords}');
            logDebug('    Confidence: ${result.confidence}');
            logDebug('    Final result: ${result.finalResult}');

            if (!listeningStarted) {
              listeningStarted = true;
              logDebug('✓ Speech recognition started successfully');
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
              logDebug('✓ Sound detected! Level: $level');
            }
            if (DateTime.now().millisecond % 500 < 100) {
              logDebug('Sound level: $level (max: $maxSoundLevel)');
            }
          },
        );

        logDebug('✓ Speech listen command executed successfully');

        final isListening = _speech.isListening;
        logDebug('Is actually listening: $isListening');

        if (!isListening) {
          logDebug('!!! Warning: Speech recognition is not in listening state after listen() call');
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
            final filePath = '${directory.path}/recording_${DateTime.now().millisecondsSinceEpoch}.wav';
            await _audioRecorder.start(
              const RecordConfig(
                encoder: AudioEncoder.wav,
                sampleRate: 16000,
                numChannels: 1,
              ),
              path: filePath,
            );
            _recordedAudioPath = filePath;
            logDebug('✓ Audio recording started successfully (native mode)');
          }
        } catch (e) {
          logDebug('Warning: Could not start audio recording: $e');
        }

      } catch (e, stackTrace) {
        logDebug('!!! Error starting speech recognition: $e');
        logDebug('Stack trace: $stackTrace');
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

    logDebug('=== Recording setup complete ===');
  }

  Future<void> _stopRecording() async {
    logDebug('=== Stop Recording Called ===');
    logDebug('Using Whisper API: $_useWhisperAPI');

    // Stop amplitude monitoring
    _stopAmplitudeMonitoring();

    if (_useWhisperAPI) {
      // ========================================
      // WHISPER API MODE - Process recorded audio
      // ========================================
      logDebug('🎙️ Stopping audio recording...');

      try{
        final audioPath = await _audioRecorder.stop();
        logDebug('Audio recording stopped, path: $audioPath');

        if (audioPath != null && await File(audioPath).exists()) {
          final fileSize = await File(audioPath).length();
          logDebug('Audio file size: $fileSize bytes');

          // Check recording duration
          final recordingDuration = _recordingStartTime != null
              ? DateTime.now().difference(_recordingStartTime!)
              : Duration.zero;
          logDebug('Recording duration: ${recordingDuration.inMilliseconds}ms');

          // Minimum duration check (0.1 seconds = 100ms)
          if (recordingDuration.inMilliseconds < 100) {
            logDebug('⚠️ Recording too short: ${recordingDuration.inMilliseconds}ms (minimum: 100ms)');

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
            logDebug('⚠️ Audio file too small: $fileSize bytes (suspicious)');

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

            // Play back the user's recording if enabled – wait for TRUE completion
            Completer<void>? playbackCompleter;
            StreamSubscription<void>? playbackSub;
            if (_playbackAfterRecording) {
              logDebug('🔊 Playing back user recording...');
              try {
                final completer = Completer<void>();
                playbackCompleter = completer;
                // Subscribe BEFORE play() so short clips don't slip through
                playbackSub = _audioPlayer.onPlayerComplete.listen((_) {
                  if (!completer.isCompleted) completer.complete();
                });
                await _audioPlayer.play(DeviceFileSource(audioPath));
              } catch (e) {
                logDebug('Warning: Could not play back recording: $e');
                await playbackSub?.cancel();
                playbackSub = null;
                playbackCompleter = null;
              }
            }

            // Show processing message
            if (mounted) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(AppLocalizations.of(context)!.processingAudio),
                  duration: const Duration(seconds: 5), // Long duration while processing
                ),
              );
            }

            // Transcribe using Whisper API (in parallel with playback)
            final currentItem = _filteredItems[_currentItemIndex];
            final languageData = _displayLanguage1
                ? currentItem.language1Data
                : currentItem.language2Data;
            final languageCode = languageData.languageCode.split('-')[0];
            final expectedText = '${languageData.preItem?.isNotEmpty ?? false ? "${languageData.preItem} " : ""}${languageData.text}';

            logDebug('📤 Sending to OpenAI Whisper API...');
            logDebug('   Expected text: "$expectedText"');

            try {
              final result = await _speechRecognitionService!.transcribeAudio(
                audioFilePath: audioPath,
                language: languageCode,
                prompt: expectedText, // Helps Whisper understand context
              );

              logDebug('✓ Whisper transcription received: "${result.text}"');
              logDebug('   Detected language: ${result.language}');
              logDebug('   Audio duration: ${result.duration}s');

              setState(() {
                _recordedText = result.text;
              });

              // Hide processing message
              if (mounted) {
                ScaffoldMessenger.of(context).hideCurrentSnackBar();
              }

              // Generate reference audio using TTS (can run in background)
              await _generateReferenceAudio(expectedText, languageData.languageCode);

              // IMPORTANT: Wait for user's audio to fully finish before playing AI audio
              if (playbackCompleter != null) {
                logDebug('⏳ Waiting for user recording playback to complete...');
                try {
                  await playbackCompleter.future
                      .timeout(const Duration(seconds: 20));
                } catch (_) {
                  logDebug('⚠️ Playback wait timed out or was interrupted');
                } finally {
                  await playbackSub?.cancel();
                }
                logDebug('✓ User recording playback completed');
              }

              // Now speak the correct pronunciation (after user's audio finished)
              await _ttsService.speak(expectedText, languageData.languageCode);

              // Calculate match rate (can run in background)
              await _calculateMatchRate(currentItem);

              setState(() {
                _hasRecorded = true;
                _totalPracticed++;
              });

            } catch (e) {
              logDebug('!!! Error transcribing with Whisper: $e');

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
                      onPressed: () => Navigator.push(
                        context,
                        MaterialPageRoute(builder: (_) => const AppSettingsPage()),
                      ),
                    ) : null,
                  ),
                );

                setState(() => _isRecording = false);
              }
            }
          } else {
            logDebug('!!! Audio file is empty or does not exist');
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
          logDebug('!!! No audio file was created');
          if (mounted) {
            setState(() => _isRecording = false);
          }
        }
      } catch (e, stackTrace) {
        logDebug('!!! Error stopping audio recording: $e');
        logDebug('Stack trace: $stackTrace');
        if (mounted) {
          setState(() => _isRecording = false);
        }
      }
    } else {
      // ========================================
      // NATIVE SPEECH RECOGNITION MODE
      // ========================================
      logDebug('Speech is listening: ${_speech.isListening}');
      logDebug('Recorded text so far: "$_recordedText"');

      await _speech.stop();
      logDebug('Speech recognition stopped');

      // Stop audio recording
      try {
        final audioPath = await _audioRecorder.stop();
        logDebug('Audio recording stopped, path: $audioPath');

        if (audioPath != null && await File(audioPath).exists()) {
          final fileSize = await File(audioPath).length();
          logDebug('Audio file size: $fileSize bytes');
        }
      } catch (e) {
        logDebug('!!! Error stopping audio recording: $e');
      }

      if (mounted) {
        setState(() => _isRecording = false);

        if (_recordedText.isNotEmpty) {
          logDebug('✓ Text was recognized: "$_recordedText"');

          // Generate reference audio using TTS
          final currentItem = _filteredItems[_currentItemIndex];
          final languageData = _displayLanguage1
              ? currentItem.language1Data
              : currentItem.language2Data;
          final fullText =
              '${languageData.preItem?.isNotEmpty ?? false ? "${languageData.preItem} " : ""}${languageData.text}';

          logDebug('Expected text: "$fullText"');

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
          logDebug('!!! No text recognized - possible issues:');
          logDebug('    1. Microphone permission not granted');
          logDebug('    2. Language/locale not supported on device');
          logDebug('    3. No speech detected by recognition engine');
          logDebug('    4. Microphone hardware issue');
          logDebug('    5. Background noise too high');
          logDebug('    6. Speaking too quietly or too far from microphone');

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

    logDebug('=== Stop Recording Complete ===');
  }

  Future<void> _generateReferenceAudio(String text, String languageCode) async {
    try {
      if (!_useWhisperAPI) return; // Only when Whisper/OpenAI key is available

      final appSettings = ref.read(appSettingsProvider);
      final apiKey = appSettings.openaiApiKey;
      if (apiKey == null || apiKey.isEmpty) return;

      final directory = await getTemporaryDirectory();
      final filePath =
          '${directory.path}/reference_${DateTime.now().millisecondsSinceEpoch}.wav';

      logDebug('🔊 Generating reference audio via OpenAI TTS...');
      final response = await http.post(
        Uri.parse('https://api.openai.com/v1/audio/speech'),
        headers: {
          'Authorization': 'Bearer $apiKey',
          'Content-Type': 'application/json',
        },
        body: jsonEncode({
          'model': 'tts-1',
          'input': text,
          'voice': 'alloy',
          'response_format': 'wav',
        }),
      );

      if (response.statusCode == 200) {
        await File(filePath).writeAsBytes(response.bodyBytes);
        _referenceAudioPath = filePath;
        logDebug('✓ Reference audio saved: $filePath');
      } else {
        logDebug('⚠️ TTS API error ${response.statusCode}: ${response.body}');
      }
    } catch (e) {
      logDebug('Error generating reference audio: $e');
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

    logDebug('🎯 Calculating match rate:');
    logDebug('   Expected: "$fullText"');
    logDebug('   Recorded: "$recorded"');

    // ── 1. Text score (word + character similarity) ───────────────────────
    final expectedWords = fullText.split(RegExp(r'\s+'));
    final recordedWords = recorded.split(RegExp(r'\s+'));

    int matchedWords = 0;
    for (final word in recordedWords) {
      if (expectedWords.any(
          (expected) => expected.contains(word) || word.contains(expected))) {
        matchedWords++;
      }
    }
    final wordMatchRate = expectedWords.isNotEmpty
        ? matchedWords / expectedWords.length
        : 0.0;

    final charMatchRate = _calculateStringSimilarity(fullText, recorded);

    logDebug('   Word match: $matchedWords/${expectedWords.length} = ${(wordMatchRate * 100).toStringAsFixed(1)}%');
    logDebug('   Char similarity: ${(charMatchRate * 100).toStringAsFixed(1)}%');

    // Whisper transcription is highly accurate → weight words more
    final textScore = _useWhisperAPI
        ? (wordMatchRate * 0.9 + charMatchRate * 0.1)
        : (wordMatchRate * 0.7 + charMatchRate * 0.3);

    // ── 2. Audio score (volume envelope + rhythm) ─────────────────────────
    final audioScore = await _analyzeAudioSimilarity(fullText);

    logDebug('   Text score : ${(textScore  * 100).toStringAsFixed(1)}%');
    logDebug('   Audio score: ${(audioScore * 100).toStringAsFixed(1)}%');

    // ── 3. Final score: 50 % text + 50 % audio ───────────────────────────
    final finalRate = ((textScore * 0.5 + audioScore * 0.5) * 100)
        .clamp(0.0, 100.0);
    logDebug('   Final rate : ${finalRate.toStringAsFixed(1)}%');

    setState(() {
      _matchRate  = finalRate;
      _textScore  = textScore;
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

  /// Analyzes audio characteristics: volume patterns and rhythm.
  /// When a reference WAV (from OpenAI TTS) is available the user's recording
  /// is compared directly against it; otherwise text-based heuristics are used.
  /// Returns a normalized score between 0.0 and 1.0.
  Future<double> _analyzeAudioSimilarity(String expectedText) async {
    try {
      if (_recordedAudioPath == null ||
          !await File(_recordedAudioPath!).exists()) {
        return 0.0;
      }

      final userBytes    = await File(_recordedAudioPath!).readAsBytes();
      final userFeatures = _extractAudioFeatures(userBytes);
      final rawUserVolume = List<double>.from(
          userFeatures['volumePattern'] as List? ?? []);

      // Trim leading/trailing silence from the user's recording so that the
      // shape comparison is not biased by the quiet parts before the user
      // starts talking and after they stop.  The reference audio (TTS) is
      // already clean and needs no trimming.
      final userVolume = _trimSilence(rawUserVolume);
      logDebug('   Silence trim: ${rawUserVolume.length} → ${userVolume.length} '
          'frames (removed ${rawUserVolume.length - userVolume.length})');

      double durationScore;
      double volumeScore;
      double rhythmScore;

      final hasReference = _referenceAudioPath != null &&
          await File(_referenceAudioPath!).exists();

      if (hasReference) {
        // ── Direct audio-vs-audio comparison ────────────────────────────────
        logDebug('🎵 Comparing user audio against reference audio...');
        final refBytes    = await File(_referenceAudioPath!).readAsBytes();
        final refFeatures = _extractAudioFeatures(refBytes);
        final refVolume   = List<double>.from(
            refFeatures['volumePattern'] as List? ?? []);

        final userDuration = userFeatures['duration'] as double? ?? 0.0;
        final refDuration  = refFeatures['duration']  as double? ?? 0.0;
        durationScore = refDuration > 0
            ? _calculateDurationScore(userDuration, refDuration)
            : 0.0;

        volumeScore  = _compareVolumeEnvelopes(userVolume, refVolume);
        rhythmScore  = _compareRhythmPatterns(userVolume, refVolume);

        logDebug('   Duration score : ${(durationScore * 100).toStringAsFixed(1)}% - not used');
        logDebug('   Envelope score : ${(volumeScore  * 100).toStringAsFixed(1)}%');
        logDebug('   Rhythm score   : ${(rhythmScore  * 100).toStringAsFixed(1)}%');
      } else {
        // ── Fallback: text-based temporal expectations ───────────────────────
        logDebug('🎵 No reference audio — using text-based audio heuristics...');
        final words = expectedText.split(RegExp(r'\s+'));
        final expectedDuration = words.length / 2.5; // ~150 wpm

        durationScore = _calculateDurationScore(
            userFeatures['duration'] as double? ?? 0.0, expectedDuration);
        volumeScore   = _calculateVolumePatternScore(userVolume, words.length);
        rhythmScore   = _calculateRhythmScore(userVolume, words.length);
      }

      //final score =
      //    (durationScore * 0.3 + volumeScore * 0.4 + rhythmScore * 0.3)
      //        .clamp(0.0, 1.0);
      final score =
      ( volumeScore * 0.5 + rhythmScore * 0.5).clamp(0.0, 1.0);
      // Persist sub-scores for the tachometer panel
      _volumeScore = volumeScore;
      _rhythmScore = rhythmScore;
      logDebug('   Audio similarity score: ${(score * 100).toStringAsFixed(1)}%');
      return score;
    } catch (e) {
      logDebug('Error analyzing audio similarity: $e');
      return 0.0;
    }
  }

  // ── Audio comparison helpers ───────────────────────────────────────────────

  /// Compare two volume envelopes by resampling both to 100 points and
  /// computing the Pearson correlation (remapped to [0, 1]).
  double _compareVolumeEnvelopes(List<double> user, List<double> reference) {
    if (user.isEmpty || reference.isEmpty) return 0.0;
    return _pearsonCorrelation(
        _resamplePattern(user, 100), _resamplePattern(reference, 100));
  }

  /// Compare rhythm by matching the relative positions of energy peaks.
  double _compareRhythmPatterns(List<double> user, List<double> reference) {
    if (user.isEmpty || reference.isEmpty) return 0.0;

    final uPeaks = _findRelativePeakPositions(user);
    final rPeaks = _findRelativePeakPositions(reference);

    if (uPeaks.isEmpty && rPeaks.isEmpty) return 1.0;
    if (uPeaks.isEmpty || rPeaks.isEmpty) return 0.0;

    // Peak-count similarity
    final countScore = 1.0 -
        ((uPeaks.length - rPeaks.length).abs() /
                math.max(uPeaks.length, rPeaks.length))
            .clamp(0.0, 1.0);

    // Average distance between each user peak and its nearest reference peak
    double posScore = 0.0;
    for (final up in uPeaks) {
      final nearest =
          rPeaks.reduce((a, b) => (a - up).abs() < (b - up).abs() ? a : b);
      posScore += 1.0 - (up - nearest).abs().clamp(0.0, 1.0);
    }
    posScore /= uPeaks.length;

    return (countScore * 0.4 + posScore * 0.6).clamp(0.0, 1.0);
  }

  /// Resample a pattern to [targetLength] using linear interpolation.
  List<double> _resamplePattern(List<double> pattern, int targetLength) {
    if (pattern.length == targetLength) return List.of(pattern);
    if (pattern.isEmpty) return List.filled(targetLength, 0.0);
    if (pattern.length == 1) return List.filled(targetLength, pattern[0]);

    final result = List<double>.filled(targetLength, 0.0);
    for (int i = 0; i < targetLength; i++) {
      final src = i * (pattern.length - 1) / (targetLength - 1);
      final lo  = src.floor().clamp(0, pattern.length - 1);
      final hi  = (lo + 1).clamp(0, pattern.length - 1);
      result[i] = pattern[lo] * (1 - (src - lo)) + pattern[hi] * (src - lo);
    }
    return result;
  }

  /// Pearson correlation coefficient, remapped from [-1, 1] → [0, 1].
  double _pearsonCorrelation(List<double> a, List<double> b) {
    if (a.length != b.length || a.length < 2) return 0.0;
    final n    = a.length;
    final meanA = a.reduce((x, y) => x + y) / n;
    final meanB = b.reduce((x, y) => x + y) / n;

    double cov = 0, varA = 0, varB = 0;
    for (int i = 0; i < n; i++) {
      final da = a[i] - meanA;
      final db = b[i] - meanB;
      cov  += da * db;
      varA += da * da;
      varB += db * db;
    }
    final denom = math.sqrt(varA * varB);
    if (denom == 0) return 0.0;
    return ((cov / denom) + 1.0) / 2.0; // remap to [0, 1]
  }

  /// Returns relative peak positions in [0.0, 1.0] for the given envelope.
  /// Only peaks above 40 % of the maximum are considered significant.
  List<double> _findRelativePeakPositions(List<double> pattern) {
    if (pattern.length < 3) return [];
    final threshold = pattern.reduce(math.max) * 0.4;
    final peaks = <double>[];
    for (int i = 1; i < pattern.length - 1; i++) {
      if (pattern[i] > pattern[i - 1] &&
          pattern[i] > pattern[i + 1] &&
          pattern[i] > threshold) {
        peaks.add(i / (pattern.length - 1));
      }
    }
    return peaks;
  }

  /// Extract audio features by properly parsing a WAV (PCM) file.
  /// Returns duration (seconds), a normalized volume envelope, and averageVolume.
  Map<String, dynamic> _extractAudioFeatures(Uint8List audioBytes) {
    const empty = {'duration': 0.0, 'volumePattern': <double>[], 'averageVolume': 0.0};
    if (audioBytes.length < 44) return empty;

    // ── WAV header parsing ────────────────────────────────────────────────────
    // Bytes 22-23: num channels  (little-endian uint16)
    final numChannels = audioBytes[22] | (audioBytes[23] << 8);
    // Bytes 24-27: sample rate   (little-endian uint32)
    final sampleRate  = audioBytes[24] | (audioBytes[25] << 8) |
                        (audioBytes[26] << 16) | (audioBytes[27] << 24);
    // Bytes 34-35: bits per sample (little-endian uint16)
    final bitsPerSample = audioBytes[34] | (audioBytes[35] << 8);

    if (sampleRate == 0 || numChannels == 0 || bitsPerSample == 0) return empty;

    // Walk chunks to find the 'data' chunk (handles LIST/INFO chunks gracefully)
    int offset = 12; // skip 'RIFF' + fileSize + 'WAVE'
    int dataOffset = -1;
    int dataSize   = 0;
    while (offset + 8 <= audioBytes.length) {
      final id = String.fromCharCodes(audioBytes.sublist(offset, offset + 4));
      final chunkSize = audioBytes[offset + 4] | (audioBytes[offset + 5] << 8) |
                        (audioBytes[offset + 6] << 16) | (audioBytes[offset + 7] << 24);
      if (id == 'data') {
        dataOffset = offset + 8;
        dataSize   = chunkSize;
        break;
      }
      offset += 8 + chunkSize;
    }
    if (dataOffset < 0 || dataOffset >= audioBytes.length) return empty;

    // ── PCM analysis ─────────────────────────────────────────────────────────
    final bytesPerSample = bitsPerSample ~/ 8;
    final frameSize      = numChannels * bytesPerSample;
    final totalFrames    = dataSize ~/ frameSize;
    final durationSeconds = totalFrames / sampleRate;

    // 50 ms windows give fine-grained but not noisy envelope
    final windowFrames = (sampleRate * 0.05).round().clamp(1, totalFrames);
    final volumePattern = <double>[];

    for (int frame = 0; frame < totalFrames; frame += windowFrames) {
      final endFrame = math.min(frame + windowFrames, totalFrames);
      double sumSq = 0;
      for (int f = frame; f < endFrame; f++) {
        final byteIdx = dataOffset + f * frameSize;
        if (byteIdx + 1 >= audioBytes.length) break;
        // Read first channel only (mono or left channel of stereo)
        int raw = audioBytes[byteIdx] | (audioBytes[byteIdx + 1] << 8);
        if (raw >= 32768) raw -= 65536; // two's-complement → signed
        final norm = raw / 32768.0;
        sumSq += norm * norm;
      }
      volumePattern.add(math.sqrt(sumSq / (endFrame - frame)));
    }

    // Normalize envelope to [0, 1]
    if (volumePattern.isNotEmpty) {
      final peak = volumePattern.reduce(math.max);
      if (peak > 0) {
        for (int i = 0; i < volumePattern.length; i++) {
          volumePattern[i] /= peak;
        }
      }
    }

    final avgVol = volumePattern.isEmpty
        ? 0.0
        : volumePattern.reduce((a, b) => a + b) / volumePattern.length;

    return {
      'duration':       durationSeconds,
      'volumePattern':  volumePattern,
      'averageVolume':  avgVol,
      'sampleRate':     sampleRate.toDouble(),
    };
  }

  /// Trims leading and trailing silence from a normalised volume envelope.
  ///
  /// The envelope is expected to be normalised so the loudest frame = 1.0.
  /// The noise-floor threshold is derived **automatically** from the recording
  /// itself: the bottom [noisePercentile] fraction of frames is used to
  /// estimate the ambient background level, and the cut-off is set to
  /// [noiseMultiplier] times that level.  Hard limits ([minThreshold] and
  /// [maxThreshold]) keep the result sensible in very quiet or very noisy
  /// environments.
  ///
  /// [holdFrames] extra frames are kept on each side so that the soft
  /// onset/offset of real speech (which can start quietly) is not clipped.
  List<double> _trimSilence(
    List<double> pattern, {
    double noisePercentile  = 0.20, // bottom 20 % of frames → noise estimate
    double noiseMultiplier  = 3.0,  // threshold = noise floor × 3
    double minThreshold     = 0.05, // never cut above 5 % of peak
    double maxThreshold     = 0.20, // never require more than 20 % of peak
    int    holdFrames       = 2,    // 2 × 50 ms = 100 ms grace on each side
  }) {
    if (pattern.length < 4) return pattern;

    // ── Adaptive noise-floor estimation ─────────────────────────────────────
    final sorted = List<double>.from(pattern)..sort();
    final noiseFloorIdx = ((pattern.length - 1) * noisePercentile).round();
    final noiseFloor    = sorted[noiseFloorIdx];
    final threshold     = (noiseFloor * noiseMultiplier)
        .clamp(minThreshold, maxThreshold);

    logDebug('   trimSilence: noise floor=${(noiseFloor * 100).toStringAsFixed(1)}%'
        '  threshold=${(threshold * 100).toStringAsFixed(1)}%');

    // ── Find first frame above threshold ────────────────────────────────────
    int start = pattern.length; // sentinel = "nothing found"
    for (int i = 0; i < pattern.length; i++) {
      if (pattern[i] >= threshold) {
        start = i;
        break;
      }
    }
    if (start == pattern.length) {
      // Entire recording is below threshold (complete silence / mic off).
      // Return as-is so the caller still has data to work with.
      logDebug('   trimSilence: entire recording below threshold — skipping trim');
      return pattern;
    }

    // ── Find last frame above threshold ─────────────────────────────────────
    int end = 0;
    for (int i = pattern.length - 1; i >= 0; i--) {
      if (pattern[i] >= threshold) {
        end = i;
        break;
      }
    }

    // ── Apply hold margin ────────────────────────────────────────────────────
    start = (start - holdFrames).clamp(0, pattern.length - 1);
    end   = (end   + holdFrames).clamp(0, pattern.length - 1);

    if (start >= end) return pattern;
    return pattern.sublist(start, end + 1);
  }
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

  Future<void> _nextItem() async {
    // Stop player and delete audio files before moving on
    await _cleanupAudioFiles();

    if (_currentItemIndex < _filteredItems.length - 1) {
      setState(() {
        _currentItemIndex++;
        _hasRecorded = false;
        _matchRate = 0.0;
        _volumeScore = 0.0;
        _rhythmScore = 0.0;
        _textScore   = 0.0;
        _recordedText = '';
        // _recordedAudioPath / _referenceAudioPath already nulled by cleanup

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
        actions: [_buildModeInfoAction(theme, l10n)],
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

                // Status indicators (includes playback checkbox when using Whisper API)
                _buildStatusIndicators(theme, l10n),
                SizedBox(height: isTablet ? AppTheme.spacing8 : AppTheme.spacing8),

                // Pronunciation item and tachometer - side by side on tablets, stacked on phones
                if (isTablet)
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Item to pronounce (left side, takes 60% of width)
                      Expanded(
                        flex: 3,
                        child: _buildPronunciationItem(theme, l10n, currentItem, isTablet),
                      ),
                      SizedBox(width: AppTheme.spacing8),
                      // Tachometer (right side, takes 40% of width)
                      Expanded(
                        flex: 2,
                        child: _buildTachometer(theme, l10n, isTablet),
                      ),
                    ],
                  )
                else ...[
                  // Phone layout - stacked vertically
                  _buildPronunciationItem(theme, l10n, currentItem, isTablet),
                  SizedBox(height: AppTheme.spacing8),
                  _buildTachometer(theme, l10n, isTablet),
                ],
                SizedBox(height: isTablet ? AppTheme.spacing8 : AppTheme.spacing8),

                // Navigation buttons
                _buildNavigationButtons(theme, l10n, isTablet),
              ],
            ),
          ),
        ),
      ),
    );
  }


  Widget _buildModeInfoAction(ThemeData theme, AppLocalizations l10n) {
    if (_useWhisperAPI) {
      return Tooltip(
        message: 'Premium Mode: AI Speech Recognition (OpenAI Whisper)',
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(Icons.verified, color: theme.colorScheme.primary, size: 18),
              const SizedBox(width: 4),
              Text(
                'AI',
                style: theme.textTheme.labelSmall?.copyWith(
                  color: theme.colorScheme.primary,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ),
      );
    } else if (_speechAvailable) {
      return Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Tooltip(
            message: 'Basic Mode: Native Speech Recognition. Add OpenAI API key for better experience.',
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(Icons.info_outline, color: theme.colorScheme.tertiary, size: 18),
                  const SizedBox(width: 4),
                  Text(
                    'Basic',
                    style: theme.textTheme.labelSmall?.copyWith(
                      color: theme.colorScheme.tertiary,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
          ),
          IconButton(
            icon: Icon(Icons.settings, size: 18, color: theme.colorScheme.tertiary),
            onPressed: () => Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => const AppSettingsPage()),
            ),
            tooltip: l10n.settings,
          ),
        ],
      );
    } else {
      return Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Tooltip(
            message: '⚠️ Speech Recognition Unavailable. Add OpenAI API key in Settings.',
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
              child: Icon(Icons.warning, color: theme.colorScheme.error, size: 18),
            ),
          ),
          IconButton(
            icon: Icon(Icons.settings, size: 18, color: theme.colorScheme.error),
            onPressed: () => Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => const AppSettingsPage()),
            ),
            tooltip: l10n.settings,
          ),
        ],
      );
    }
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
            if (_useWhisperAPI)
              Flexible(
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    SizedBox(
                      width: 32,
                      height: 32,
                      child: Checkbox(
                        value: _playbackAfterRecording,
                        onChanged: (bool? value) {
                          if (value != null) _savePlaybackPreference(value);
                        },
                        activeColor: theme.colorScheme.primary,
                        materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                      ),
                    ),
                    Icon(
                      Icons.play_circle_outline,
                      size: 18,
                      color: theme.colorScheme.primary,
                    ),
                    const SizedBox(width: AppTheme.spacing4),
                    Flexible(
                      child: Text(
                        l10n.playbackRecording,
                        style: theme.textTheme.bodySmall?.copyWith(fontSize: 10),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
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
    return Row(
      children: [
        Icon(icon, size: 20, color: theme.colorScheme.primary),
        const SizedBox(width: AppTheme.spacing4),
        Text(
          value,
          style: theme.textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.bold,
            color: theme.colorScheme.primary,
          ),
        ),
        const SizedBox(width: AppTheme.spacing4),
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

    final isLandscape =
        MediaQuery.of(context).orientation == Orientation.landscape;
    // Only phones in landscape get the side-by-side layout
    final isPhoneLandscape = !isTablet && isLandscape;

    // ── Text-to-pronounce section ──────────────────────────────────────
    final Widget textSection = Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        if (preText.isNotEmpty) ...[
          Text(
            preText,
            style: theme.textTheme.bodyMedium?.copyWith(
              color: theme.colorScheme.onPrimaryContainer.withValues(alpha: 0.8),
              fontStyle: FontStyle.italic,
              fontSize: isTablet ? null : 10,
            ),
          ),
          const SizedBox(height: AppTheme.spacing4),
        ],
        Text(
          mainText,
          style: theme.textTheme.headlineSmall?.copyWith(
            color: theme.colorScheme.onPrimaryContainer,
            fontWeight: FontWeight.bold,
            fontSize: isTablet ? null : 14,
          ),
        ),
      ],
    );

    // ── Microphone + status section ────────────────────────────────────
    final Widget micSection = Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // Microphone button
              Container(
                width: isTablet ? 80 : 50,
                height: isTablet ? 80 : 50,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: !_useWhisperAPI
                      ? theme.colorScheme.surfaceContainerHighest
                      : _isRecording
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
                    color: !_useWhisperAPI
                        ? theme.colorScheme.onSurface.withValues(alpha: 0.38)
                        : _isRecording
                            ? theme.colorScheme.onError
                            : theme.colorScheme.onSecondary,
                    size: isTablet ? 40 : 24,
                  ),
                  onPressed: !_useWhisperAPI
                      ? null
                      : (_isRecording ? _stopRecording : _startRecording),
                ),
              ),

              // Volume meter (shown during recording, to the right of microphone)
              if (_isRecording) ...[
                SizedBox(width: isTablet ? AppTheme.spacing12 : AppTheme.spacing8),
                _buildVolumeMeter(theme, isTablet),
              ],
            ],
          ),
          SizedBox(height: isTablet ? AppTheme.spacing8 : AppTheme.spacing4),
          Text(
            !_useWhisperAPI
                ? l10n.openaiKeyRequired
                : _isRecording
                    ? l10n.recording
                    : (_hasRecorded ? l10n.recorded : l10n.tapToRecord),
            style: theme.textTheme.bodyMedium?.copyWith(
              color: theme.colorScheme.onPrimaryContainer,
              fontWeight: FontWeight.w500,
              fontSize: isTablet ? null : 10,
            ),
          ),
          if (_recordedText.isNotEmpty) ...[
            SizedBox(height: isTablet ? AppTheme.spacing8 : AppTheme.spacing4),
            Text(
              '"$_recordedText"',
              style: theme.textTheme.bodyMedium?.copyWith(
                color: theme.colorScheme.onPrimaryContainer.withValues(alpha: 0.7),
                fontStyle: FontStyle.italic,
                fontSize: isTablet ? null : 10,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ],
      ),
    );

    return Card(
      elevation: 2,
      color: theme.colorScheme.primaryContainer,
      child: Padding(
        padding: EdgeInsets.all(isTablet ? AppTheme.spacing8 : AppTheme.spacing8),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header with language code and speaker icon
            Row(
              children: [
                Expanded(
                  child: Text(
                    '${l10n.pronounce} - $languageCode',
                    style: theme.textTheme.labelLarge?.copyWith(
                      color: theme.colorScheme.onPrimaryContainer,
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

            // Phone landscape: text (70%) | mic (30%) side by side
            // All other layouts: text above mic (existing vertical order)
            if (isPhoneLandscape)
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Expanded(flex: 7, child: textSection),
                  Expanded(flex: 3, child: micSection),
                ],
              )
            else ...[
              textSection,
              micSection,
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildTachometer(ThemeData theme, AppLocalizations l10n, bool isTablet) {
    // Get screen orientation for better sizing
    final mediaQuery = MediaQuery.of(context);
    final isLandscape = mediaQuery.orientation == Orientation.landscape;

    // Adaptive sizing based on device type and orientation
    double tachometerHeight;
    double percentageFontSize;
    double labelFontSize;
    double titleFontSize;
    double topPadding;

    if (isTablet) {
      if (isLandscape) {
        // Tablet landscape - compact (as just fixed)
        tachometerHeight = 150;
        percentageFontSize = 40;
        labelFontSize = 13;
        titleFontSize = 16;
        topPadding = 30;
      } else {
        // Tablet portrait - can be a bit larger
        tachometerHeight = 130;
        percentageFontSize = 44;
        labelFontSize = 14;
        titleFontSize = 18;
        topPadding = 35;
      }
    } else {
      // Phone
      if (isLandscape) {
        // Phone landscape - very compact
        tachometerHeight = 120;
        percentageFontSize = 18;
        labelFontSize = 11;
        titleFontSize = 13;
        topPadding = 20;
      } else {
        // Phone portrait - standard size
        tachometerHeight = 100;
        percentageFontSize = 18;
        labelFontSize = 12;
        titleFontSize = 14;
        topPadding = 30;
      }
    }

    return Card(
      elevation: 2,
      child: Padding(
        padding: EdgeInsets.all(isTablet ? AppTheme.spacing8 : AppTheme.spacing8),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // ── Label ────────────────────────────────────────────────────
            SizedBox(

              height: tachometerHeight,
              child: Center(
                child: Text(
                  l10n.pronunciationAccuracy,
                  style: theme.textTheme.titleSmall?.copyWith(
                    fontWeight: FontWeight.bold,
                    fontSize: titleFontSize - 2,
                  ),
                  textAlign: TextAlign.center,
                  softWrap: true,
                ),
              ),
            ),
            const SizedBox(width: 4),
            // ── Arc ──────────────────────────────────────────────────────
            Expanded(
                  flex: 3,
                  child: SizedBox(
                    height: tachometerHeight,
                    child: CustomPaint(
                      painter: TachometerPainter(
                        percentage: _matchRate,
                        theme: theme,
                        availableHeight: tachometerHeight,
                      ),
                      child: Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            SizedBox(height: topPadding),
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
                                    fontSize: percentageFontSize,
                                  ),
                                );
                              },
                            ),
                            Text(
                              _getMatchRateLabel(l10n, _matchRate),
                              style: theme.textTheme.bodyMedium?.copyWith(
                                color: theme.colorScheme.onSurfaceVariant,
                                fontSize: labelFontSize,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),

                // ── Sub-score bars (only after a recording) ──────────────────
                if (_hasRecorded) ...[
                  const SizedBox(width: AppTheme.spacing8),
                  Expanded(
                    flex: 2,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        _buildScoreBar(
                          theme,
                          l10n.envelopeScoreLabel,
                          _volumeScore,
                          Icons.show_chart,
                          labelFontSize,
                        ),
                        SizedBox(height: AppTheme.spacing8),
                        _buildScoreBar(
                          theme,
                          l10n.rhythmScoreLabel,
                          _rhythmScore,
                          Icons.music_note,
                          labelFontSize,
                        ),
                        SizedBox(height: AppTheme.spacing8),
                        _buildScoreBar(
                          theme,
                          l10n.textScoreLabel,
                          _textScore,
                          Icons.text_fields,
                          labelFontSize,
                        ),
                      ],
                    ),
                  ),
                ],
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

  /// Compact labelled progress bar used in the tachometer panel.
  Widget _buildScoreBar(
    ThemeData theme,
    String label,
    double score,
    IconData icon,
    double fontSize,
  ) {
    final pct = (score * 100).round();
    final color = _getMatchRateColor(theme, score * 100);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        Row(
          children: [
            Icon(icon, size: fontSize + 2, color: color),
            const SizedBox(width: 4),
            Expanded(
              child: Text(
                label,
                style: theme.textTheme.bodySmall?.copyWith(
                  fontSize: fontSize - 1,
                ),
                overflow: TextOverflow.ellipsis,
              ),
            ),
            Text(
              '$pct%',
              style: theme.textTheme.bodySmall?.copyWith(
                fontSize: fontSize,
                fontWeight: FontWeight.bold,
                color: color,
              ),
            ),
          ],
        ),
        const SizedBox(height: 2),
        ClipRRect(
          borderRadius: BorderRadius.circular(3),
          child: LinearProgressIndicator(
            value: score.clamp(0.0, 1.0),
            backgroundColor: theme.colorScheme.surfaceContainerHighest,
            valueColor: AlwaysStoppedAnimation<Color>(color),
            minHeight: 6,
          ),
        ),
      ],
    );
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
    final meterHeight = isTablet ? 80.0 : 60.0; // Match microphone button height
    final meterWidth = isTablet ? 16.0 : 12.0;

    return Row(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        // Vertical volume meter
        Container(
          width: meterWidth,
          height: meterHeight,
          decoration: BoxDecoration(
            color: theme.colorScheme.onPrimaryContainer.withValues(alpha: 0.2),
            borderRadius: BorderRadius.circular(meterWidth / 2),
          ),
          child: FractionallySizedBox(
            alignment: Alignment.bottomCenter,
            heightFactor: _currentVolumeLevel.clamp(0.0, 1.0),
            child: Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.bottomCenter,
                  end: Alignment.topCenter,
                  colors: [
                    Colors.green,
                    Colors.yellow,
                    Colors.orange,
                    Colors.red,
                  ],
                  stops: [0.0, 0.5, 0.75, 1.0],
                ),
                borderRadius: BorderRadius.circular(meterWidth / 2),
              ),
            ),
          ),
        ),
        const SizedBox(width: 4),
        // "Volume" label rotated vertically
        RotatedBox(
          quarterTurns: 3,
          child: Text(
            'Volume',
            style: theme.textTheme.bodySmall?.copyWith(
              color: theme.colorScheme.onPrimaryContainer.withValues(alpha: 0.7),
              fontSize: isTablet ? 10 : 8,
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
  final double availableHeight;

  TachometerPainter({
    required this.percentage,
    required this.theme,
    required this.availableHeight,
  });

  @override
  void paint(Canvas canvas, Size size) {
    // Calculate radius to fit within available height
    // The arc needs to fit: radius + strokeWidth/2 at top and bottom
    final strokeWidth = 20.0;
    final maxRadius = (availableHeight - strokeWidth) / 2;

    // Also constrain by width
    final maxRadiusByWidth = (size.width * 0.4);

    // Use the smaller of the two to ensure it fits
    final radius = math.min(maxRadius, maxRadiusByWidth);

    // Center the arc vertically and horizontally
    final center = Offset(size.width / 2, availableHeight * 0.6);

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

