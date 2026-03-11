// lib/presentation/pages/test/windows_audio_recording_test_page.dart
//
// Windows Audio Recording Test Page - RTAudio Implementation
//
// Tests audio recording on Windows using RTAudio library

import 'dart:io';
import 'dart:math' as math;
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:path_provider/path_provider.dart';
import '../../../core/utils/debug_print.dart';
import '../../../core/audio/rtaudio_recorder.dart';
import '../../../core/services/speech_recognition_service.dart';
import '../../providers/app_settings_provider.dart';
import '../../../l10n/app_localizations.dart';

class WindowsAudioRecordingTestPage extends ConsumerStatefulWidget {
  const WindowsAudioRecordingTestPage({super.key});

  @override
  ConsumerState<WindowsAudioRecordingTestPage> createState() =>
      _WindowsAudioRecordingTestPageState();
}

class _WindowsAudioRecordingTestPageState
    extends ConsumerState<WindowsAudioRecordingTestPage> {

  final RtAudioRecorder _audioRecorder = RtAudioRecorder();
  bool _isRecording = false;
  String? _recordedFilePath;

  List<RtAudioDevice> _availableDevices = [];
  RtAudioDevice? _selectedDevice;
  bool _isLoadingDevices = false;

  bool _isStereo = false;
  int _sampleRate = 48000;
  double _gainMultiplier = 3.0;

  static const List<int> _commonSampleRates = [
    8000, 16000, 22050, 32000, 44100, 48000, 88200, 96000,
  ];

  bool _isPlaying = false;
  DateTime? _recordingStartTime;
  Duration? _recordingDuration;
  int? _recordedFileSize;

  final List<String> _tempFiles = [];

  bool _isTranscribing = false;
  String? _transcriptionResult;
  String? _transcriptionError;

  // true once app settings have been loaded and applied to the controls
  bool _settingsLoaded = false;
  // platform check — all controls are disabled on non-Windows
  final bool _isWindows = Platform.isWindows;

  // Saved notifier reference — captured in initState so it is safe to use in dispose()
  late final AppSettingsNotifier _settingsNotifier;

  @override
  void initState() {
    super.initState();
    // Capture the notifier NOW, while the widget is still mounted and ref is valid.
    _settingsNotifier = ref.read(appSettingsProvider.notifier);
    _loadSettingsThenInit();
  }

  /// Wait for the app-settings provider to finish loading, apply the persisted
  /// audio-test values to the local state, then initialise RTAudio.
  Future<void> _loadSettingsThenInit() async {
    // The provider loads asynchronously; poll until the key is non-null OR
    // up to 2 s so the UI is never blocked indefinitely.
    var settings = ref.read(appSettingsProvider);
    if (settings.openaiApiKey == null && settings.audioTestSampleRate == 48000) {
      // Might still be loading — wait for up to 2 s
      for (int i = 0; i < 40; i++) {
        await Future.delayed(const Duration(milliseconds: 50));
        if (!mounted) return;
        settings = ref.read(appSettingsProvider);
        // Stop waiting as soon as a non-default value appears OR openai key loaded
        if (settings.openaiApiKey != null ||
            settings.audioTestSampleRate != 48000 ||
            settings.audioTestDeviceId != null) break;
      }
    }

    if (!mounted) return;

    // Apply persisted values
    setState(() {
      _isStereo     = settings.audioTestStereo;
      _sampleRate   = settings.audioTestSampleRate;
      _gainMultiplier = settings.audioTestGain;
      _settingsLoaded = true;
    });

    logDebug('📥 Audio test settings restored: '
        'stereo=$_isStereo  rate=$_sampleRate  gain=$_gainMultiplier  '
        'deviceId=${settings.audioTestDeviceId}  device=${settings.audioTestDeviceName}');

    if (_isWindows) {
      await _initializeRtAudio(preferredDeviceId: settings.audioTestDeviceId);
    }
  }

  @override
  void dispose() {
    // Save current settings synchronously via the notifier (fire-and-forget is fine
    // because SharedPreferences.setX() is fast and we don't need to await it here).
    _saveCurrentSettings();

    final pathsToDelete = List<String>.from(_tempFiles);
    _tempFiles.clear();
    Future(() async {
      try { await _audioRecorder.stopAudio(); } catch (_) {}
      try { await _audioRecorder.dispose(); } catch (_) {}
      _deleteFiles(pathsToDelete);
    });
    super.dispose();
  }

  /// Persist the current page settings to SharedPreferences via the provider.
  void _saveCurrentSettings() {
    try {
      // Use the notifier reference captured in initState — safe to call in dispose()
      _settingsNotifier.setAudioTestSettings(
        deviceId:   _selectedDevice?.id,
        deviceName: _selectedDevice?.name,
        stereo:     _isStereo,
        sampleRate: _sampleRate,
        gain:       _gainMultiplier,
      );
      logDebug('💾 Audio test settings saved on page close');
    } catch (e) {
      logDebug('⚠️ Could not save audio test settings: $e');
    }
  }

  void _deleteFiles(List<String> paths) {
    for (final rawPath in paths) {
      final path = rawPath.replaceAll('/', '\\');
      try {
        final file = File(path);
        if (file.existsSync()) {
          file.deleteSync();
          logDebug('🗑️ Deleted temp file: $path');
        }
      } catch (e) {
        logDebug('⚠️ Could not delete temp file: $path — $e');
      }
    }
  }

  // ── RTAudio init ──────────────────────────────────────────────────────────

  Future<void> _initializeRtAudio({int? preferredDeviceId}) async {
    logDebug('═══════════════════════════════════════════════════════════');
    logDebug('🎵 Initializing RTAudio');
    logDebug('═══════════════════════════════════════════════════════════');
    final success = await _audioRecorder.initialize();
    if (success) {
      logDebug('✅ RTAudio initialized successfully');
      await _loadInputDevices(preferredDeviceId: preferredDeviceId);
    } else {
      logDebug('❌ RTAudio initialization failed');
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text(AppLocalizations.of(context)!.failedToInitRtAudio),
          backgroundColor: Colors.red,
        ));
      }
    }
    logDebug('═══════════════════════════════════════════════════════════');
    logDebug('');
  }

  Future<void> _loadInputDevices({int? preferredDeviceId}) async {
    logDebug('═══════════════════════════════════════════════════════════');
    logDebug('🎧 Loading Available Input Devices (RTAudio)');
    logDebug('═══════════════════════════════════════════════════════════');
    setState(() => _isLoadingDevices = true);
    try {
      final devices = await _audioRecorder.listInputDevices();
      logDebug('📊 Found ${devices.length} RTAudio input device(s)');
      if (mounted) {
        setState(() {
          _availableDevices = devices;
          if (devices.isEmpty) {
            _selectedDevice = null;
          } else {
            // 1. Try to restore the previously selected device by ID
            if (preferredDeviceId != null) {
              try {
                _selectedDevice = devices.firstWhere((d) => d.id == preferredDeviceId);
                logDebug('✅ Restored last-used device: ${_selectedDevice!.name}');
              } catch (_) {
                // Device no longer available — fall through to default
              }
            }
            // 2. Fall back to system default input device
            if (_selectedDevice == null) {
              try {
                _selectedDevice = devices.firstWhere((d) => d.isDefaultInput);
              } catch (_) {
                _selectedDevice = devices.first;
              }
            }
          }
          // Use restored sample rate from settings; only override if it's the
          // default placeholder AND the device has a preferred rate.
          if (_sampleRate == 48000 &&
              _selectedDevice != null &&
              _selectedDevice!.preferredSampleRate > 0) {
            _sampleRate = _selectedDevice!.preferredSampleRate;
          }
          _isLoadingDevices = false;
        });
      }
      if (_selectedDevice != null) {
        logDebug('✅ Selected device: ${_selectedDevice!.name} (ID: ${_selectedDevice!.id})');
      }
    } catch (e, st) {
      logDebug('❌ Error loading devices: $e\n$st');
      if (mounted) setState(() => _isLoadingDevices = false);
    }
    logDebug('═══════════════════════════════════════════════════════════');
    logDebug('');
  }

  // ── Recording ─────────────────────────────────────────────────────────────

  Future<void> _startRecording() async {
    final l10n = AppLocalizations.of(context)!;
    logDebug('═══════════════════════════════════════════════════════════');
    logDebug('🎙️ Starting Windows Audio Recording (RTAudio)');
    logDebug('═══════════════════════════════════════════════════════════');
    if (_selectedDevice == null) {
      logDebug('❌ No device selected');
      if (mounted) ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text(l10n.noDeviceSelectedSnack), backgroundColor: Colors.red));
      return;
    }
    try {
      _recordedFilePath = null;
      _recordingDuration = null;
      _recordedFileSize = null;
      _transcriptionResult = null;
      _transcriptionError = null;
      _recordingStartTime = DateTime.now();

      logDebug('📊 Device: ${_selectedDevice!.name} (ID: ${_selectedDevice!.id})');
      logDebug('   Max channels: ${_selectedDevice!.maxInputChannels}');
      logDebug('   Preferred rate: ${_selectedDevice!.preferredSampleRate} Hz');

      final int requestedRate = _sampleRate;
      final numChannels = (_isStereo ? 2 : 1).clamp(1, _selectedDevice!.maxInputChannels);
      logDebug('   Requested rate: $requestedRate Hz  |  Channels: $numChannels');

      final success = await _audioRecorder.startRecording(
        deviceId: _selectedDevice!.id,
        sampleRate: requestedRate,
        numChannels: numChannels,
        gainMultiplier: _gainMultiplier,
      );

      if (success) {
        final actualRate = _audioRecorder.actualSampleRate;
        setState(() => _isRecording = true);
        if (actualRate == requestedRate) {
          logDebug('✅ Recording started — $actualRate Hz ✓ (exclusive mode)');
        } else {
          logDebug('✅ Recording started — $actualRate Hz (WASAPI forced; requested $requestedRate Hz)');
        }
        logDebug('   Channels: ${_audioRecorder.actualChannels}');
        logDebug('═══════════════════════════════════════════════════════════');
        logDebug('');

        await Future.delayed(const Duration(milliseconds: 500));
        final info = await _audioRecorder.getBufferInfo();
        final cb = info['callbackCount'] ?? 0;
        final nz = info['nonzeroCount'] ?? 0;
        logDebug('📊 Diagnostics after 500ms:  buffer=${((info['byteSize'] ?? 0) / 1024).toStringAsFixed(1)} KB  callbacks=$cb  with-signal=$nz');
        if (cb == 0) logDebug('   ⚠️ Callback never fired!');
        else if (nz == 0) logDebug('   ⚠️ All callbacks silent — check Windows Privacy > Microphone');
        else logDebug('   ✓ Real audio signal in $nz/$cb callbacks');
      } else {
        logDebug('❌ Failed to start recording');
        if (mounted) ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text(l10n.errorStartingRecording), backgroundColor: Colors.red));
      }
    } catch (e, st) {
      logDebug('❌ $e\n$st');
      if (mounted) {
        setState(() => _isRecording = false);
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text('${l10n.errorStartingRecording}: $e'), backgroundColor: Colors.red));
      }
    }
  }

  Future<void> _stopRecording() async {
    final l10n = AppLocalizations.of(context)!;
    logDebug('═══════════════════════════════════════════════════════════');
    logDebug('🛑 Stopping Windows Audio Recording (RTAudio)');
    logDebug('═══════════════════════════════════════════════════════════');
    try {
      final endTime = DateTime.now();
      _recordingDuration = endTime.difference(_recordingStartTime!);
      logDebug('   Duration: ${_recordingDuration!.inSeconds}.${_recordingDuration!.inMilliseconds % 1000}s');

      final audioData = await _audioRecorder.stopRecording();
      setState(() => _isRecording = false);

      if (audioData == null || audioData.isEmpty) {
        logDebug('⚠️ No audio data');
        if (mounted) ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text(l10n.noAudioDataSnack), backgroundColor: Colors.orange));
        return;
      }

      final int actualRate = _audioRecorder.actualSampleRate;
      final int actualCh   = _audioRecorder.actualChannels;
      logDebug('✅ ${(audioData.length / 1024).toStringAsFixed(1)} KB captured at ${actualRate}Hz x${actualCh}ch');

      final tempDir   = await getTemporaryDirectory();
      final timestamp = DateTime.now().millisecondsSinceEpoch;
      final wavPath   = '${tempDir.path}\\windows_audio_test_$timestamp.wav';

      final wavData = _createWavFile(audioData, sampleRate: actualRate, channels: actualCh, bitsPerSample: 16);
      await File(wavPath).writeAsBytes(wavData);
      _tempFiles.add(wavPath);

      final fileSize = await File(wavPath).length();
      logDebug('💾 WAV saved: $wavPath  (${(fileSize / 1024).toStringAsFixed(1)} KB)');

      String snackMsg;
      Color snackColor;
      if (_recordingDuration!.inMilliseconds < 500) {
        logDebug('⚠️ Too short');
        snackMsg = l10n.recordingTooShortSnack;
        snackColor = Colors.orange;
      } else if (audioData.length < 5000) {
        logDebug('⚠️ Very small');
        snackMsg = l10n.recordingSmallSnack;
        snackColor = Colors.orange;
      } else {
        logDebug('✓ Valid recording');
        snackMsg = '${l10n.recordingSavedSnack}: ${_recordingDuration!.inSeconds}s, ${(fileSize / 1024).toStringAsFixed(1)} KB';
        snackColor = Colors.green;
      }
      if (mounted) ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(snackMsg), backgroundColor: snackColor));

      setState(() {
        _recordedFilePath = wavPath;
        _recordedFileSize = fileSize;
      });
    } catch (e, st) {
      logDebug('❌ Stop failed: $e\n$st');
      if (mounted) {
        setState(() => _isRecording = false);
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text('Stop failed: $e'), backgroundColor: Colors.red));
      }
    }
    logDebug('═══════════════════════════════════════════════════════════');
    logDebug('');
  }

  // ── Playback ──────────────────────────────────────────────────────────────

  Future<void> _playAudio() async {
    if (_recordedFilePath == null) return;
    logDebug('▶️ Playing: $_recordedFilePath');
    setState(() => _isPlaying = true);
    try {
      final ok = await _audioRecorder.playAudio(_recordedFilePath!);
      if (ok) {
        final waitMs = (_recordingDuration?.inMilliseconds ?? 30000) + 600;
        Future.delayed(Duration(milliseconds: waitMs), () {
          if (mounted && _isPlaying) {
            logDebug('✅ Playback completed');
            setState(() => _isPlaying = false);
          }
        });
      } else {
        if (mounted) setState(() => _isPlaying = false);
      }
    } catch (e) {
      logDebug('❌ Playback error: $e');
      if (mounted) setState(() => _isPlaying = false);
    }
  }

  Future<void> _stopPlayback() async {
    logDebug('⏹️ Stopping playback');
    await _audioRecorder.stopAudio();
    if (mounted) setState(() => _isPlaying = false);
  }

  // ── Whisper ───────────────────────────────────────────────────────────────

  Future<void> _transcribeAudio() async {
    if (_recordedFilePath == null) return;
    logDebug('═══════════════════════════════════════════════════════════');
    logDebug('📤 Sending to OpenAI Whisper API');
    logDebug('═══════════════════════════════════════════════════════════');
    setState(() { _isTranscribing = true; _transcriptionResult = null; _transcriptionError = null; });
    try {
      var settings = ref.read(appSettingsProvider);
      if (settings.openaiApiKey == null) {
        for (int i = 0; i < 20; i++) {
          await Future.delayed(const Duration(milliseconds: 100));
          settings = ref.read(appSettingsProvider);
          if (settings.openaiApiKey != null) break;
        }
      }
      final apiKey = settings.openaiApiKey;
      if (apiKey == null || apiKey.isEmpty) {
        throw Exception('OpenAI API key not configured. Add it in Settings.');
      }
      logDebug('✅ API key loaded (${apiKey.length} chars)  file=${_recordedFileSize ?? 0} bytes  format=WAV 16-bit PCM');
      final result = await SpeechRecognitionService(apiKey: apiKey)
          .transcribeAudio(audioFilePath: _recordedFilePath!, language: 'en');
      logDebug('✅ Transcription: "${result.text}"  lang=${result.language}  dur=${result.duration?.toStringAsFixed(1)}s');
      if (mounted) setState(() { _transcriptionResult = result.text; _isTranscribing = false; });
    } catch (e) {
      logDebug('❌ Transcription failed: $e');
      if (mounted) setState(() { _transcriptionError = e.toString(); _isTranscribing = false; });
    }
    logDebug('═══════════════════════════════════════════════════════════');
    logDebug('');
  }

  // ── Helpers ───────────────────────────────────────────────────────────────

  List<int> _availableRatesForDevice() {
    if (_selectedDevice == null || _selectedDevice!.sampleRates.isEmpty) return _commonSampleRates;
    final deviceRates = _selectedDevice!.sampleRates.toSet();
    final filtered = _commonSampleRates.where((r) => deviceRates.contains(r)).toList();
    return filtered.isEmpty ? _commonSampleRates : filtered;
  }

  Uint8List _createWavFile(Uint8List data, {required int sampleRate, required int channels, required int bitsPerSample}) {
    final byteRate   = sampleRate * channels * (bitsPerSample ~/ 8);
    final blockAlign = channels * (bitsPerSample ~/ 8);
    final wav = BytesBuilder();
    wav.add('RIFF'.codeUnits); wav.add(_i2b(36 + data.length, 4));
    wav.add('WAVE'.codeUnits);
    wav.add('fmt '.codeUnits); wav.add(_i2b(16, 4));
    wav.add(_i2b(1, 2)); wav.add(_i2b(channels, 2));
    wav.add(_i2b(sampleRate, 4)); wav.add(_i2b(byteRate, 4));
    wav.add(_i2b(blockAlign, 2)); wav.add(_i2b(bitsPerSample, 2));
    wav.add('data'.codeUnits); wav.add(_i2b(data.length, 4));
    wav.add(data);
    return wav.toBytes();
  }

  Uint8List _i2b(int v, int n) {
    final r = Uint8List(n);
    for (int i = 0; i < n; i++) r[i] = (v >> (i * 8)) & 0xFF;
    return r;
  }

  // ── Build ─────────────────────────────────────────────────────────────────

  @override
  Widget build(BuildContext context) {
    final l10n  = AppLocalizations.of(context)!;
    final theme = Theme.of(context);
    // Watch so the Whisper button updates reactively when the API key is saved
    final settings = ref.watch(appSettingsProvider);
    final hasApiKey = (settings.openaiApiKey ?? '').isNotEmpty;

    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.windowsAudioTestPageTitle),
        backgroundColor: theme.colorScheme.primaryContainer,
        actions: [
          if (!_isWindows)
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12),
              child: Chip(
                label: Text('Windows only', style: theme.textTheme.labelSmall),
                backgroundColor: theme.colorScheme.errorContainer,
                labelStyle: TextStyle(color: theme.colorScheme.onErrorContainer),
              ),
            ),
        ],
      ),
      body: !_settingsLoaded
          // ── Loading overlay while settings + RTAudio initialise ──────────
          ? Center(
              child: Column(mainAxisSize: MainAxisSize.min, children: [
                const CircularProgressIndicator(),
                const SizedBox(height: 16),
                Text(l10n.loadingAudioDevices, style: theme.textTheme.bodyMedium),
              ]),
            )
          : Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          children: [
            Expanded(
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // ── LEFT: device + settings ──────────────────────────────
                  Expanded(
                    flex: 5,
                    child: SingleChildScrollView(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          _buildDeviceSelector(theme, l10n),
                          const SizedBox(height: 8),
                          _buildRecordingSettings(theme, l10n),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  // ── RIGHT: debug info + status + transcription result ────
                  Expanded(
                    flex: 4,
                    child: SingleChildScrollView(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          if (_isRecording || _recordedFilePath != null) ...[
                            _buildRecordingStatus(theme, l10n),
                            const SizedBox(height: 8),
                          ],
                          _buildDebugInfo(theme, l10n),
                          if (_transcriptionResult != null) ...[
                            const SizedBox(height: 8),
                            _buildTranscriptionResult(theme, l10n),
                          ],
                          if (_transcriptionError != null) ...[
                            const SizedBox(height: 8),
                            _buildTranscriptionError(theme, l10n),
                          ],
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const Divider(height: 16),
            _buildBottomBar(theme, l10n, hasApiKey: hasApiKey),
          ],
        ),
      ),
    );
  }

  // ── Left panel widgets ────────────────────────────────────────────────────

  Widget _buildDeviceSelector(ThemeData theme, AppLocalizations l10n) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(children: [
              Icon(Icons.mic, color: theme.colorScheme.primary, size: 18),
              const SizedBox(width: 6),
              Text(l10n.audioInputDevice, style: theme.textTheme.titleSmall?.copyWith(fontWeight: FontWeight.bold)),
            ]),
            const SizedBox(height: 8),
            if (_isLoadingDevices)
              Row(children: [
                const SizedBox(width: 16, height: 16, child: CircularProgressIndicator(strokeWidth: 2)),
                const SizedBox(width: 8),
                Text(l10n.loadingAudioDevices, style: theme.textTheme.bodySmall),
              ])
            else if (_availableDevices.isEmpty)
              Row(children: [
                const Icon(Icons.warning, color: Colors.orange, size: 18),
                const SizedBox(width: 6),
                Text(l10n.noAudioDevicesFound, style: theme.textTheme.bodySmall),
                const Spacer(),
                TextButton(onPressed: _loadInputDevices, child: Text(l10n.refreshDevices)),
              ])
            else ...[
              DropdownButtonFormField<RtAudioDevice>(
                initialValue: _selectedDevice,
                decoration: InputDecoration(
                  labelText: l10n.selectMicrophone,
                  border: const OutlineInputBorder(),
                  contentPadding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                  isDense: true,
                ),
                isExpanded: true,
                items: _availableDevices.map((d) => DropdownMenuItem(
                  value: d,
                  child: Row(children: [
                    if (d.isDefaultInput) const Icon(Icons.star, size: 14, color: Colors.amber),
                    if (d.isDefaultInput) const SizedBox(width: 4),
                    Expanded(child: Text(d.name, overflow: TextOverflow.ellipsis, style: theme.textTheme.bodySmall)),
                  ]),
                )).toList(),
                onChanged: (_isRecording || !_isWindows) ? null : (RtAudioDevice? d) {
                  if (d != null) {
                    setState(() {
                      _selectedDevice = d;
                      if (d.preferredSampleRate > 0) _sampleRate = d.preferredSampleRate;
                    });
                    logDebug('🎤 Selected: ${d.name} (ID: ${d.id}, preferred: ${d.preferredSampleRate} Hz)');
                  }
                },
              ),
              const SizedBox(height: 4),
              Align(
                alignment: Alignment.centerRight,
                child: TextButton.icon(
                  onPressed: (_isRecording || !_isWindows) ? null : _loadInputDevices,
                  icon: const Icon(Icons.refresh, size: 14),
                  label: Text(l10n.refreshDevices, style: theme.textTheme.bodySmall),
                  style: TextButton.styleFrom(visualDensity: VisualDensity.compact),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildRecordingSettings(ThemeData theme, AppLocalizations l10n) {
    final rates = _availableRatesForDevice();
    final dropdownValue = rates.contains(_sampleRate) ? _sampleRate : (rates.isNotEmpty ? rates.last : 48000);

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(children: [
              Icon(Icons.settings, color: theme.colorScheme.primary, size: 18),
              const SizedBox(width: 6),
              Text(l10n.recordingSettings, style: theme.textTheme.titleSmall?.copyWith(fontWeight: FontWeight.bold)),
            ]),
            const SizedBox(height: 8),

            // Mono/Stereo
            SwitchListTile(
              dense: true,
              contentPadding: EdgeInsets.zero,
              title: Text(l10n.stereoRecording, style: theme.textTheme.bodySmall),
              subtitle: Text(_isStereo ? l10n.stereoChannels : l10n.monoChannel, style: theme.textTheme.bodySmall),
              value: _isStereo,
              onChanged: (_isRecording || !_isWindows) ? null : (v) {
                setState(() => _isStereo = v);
                logDebug('🎚️ Changed to ${v ? "stereo" : "mono"}');
              },
            ),

            // Sample rate
            DropdownButtonFormField<int>(
              initialValue: dropdownValue,
              decoration: InputDecoration(
                labelText: l10n.sampleRateLabel,
                border: const OutlineInputBorder(),
                prefixIcon: const Icon(Icons.graphic_eq, size: 18),
                contentPadding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                isDense: true,
              ),
              items: rates.map((rate) {
                final isPreferred = rate == (_selectedDevice?.preferredSampleRate ?? 0);
                return DropdownMenuItem<int>(
                  value: rate,
                  child: Row(children: [
                    Text('$rate Hz', style: theme.textTheme.bodySmall),
                    if (isPreferred) ...[
                      const SizedBox(width: 6),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 1),
                        decoration: BoxDecoration(
                          color: Colors.green.withValues(alpha: 0.15),
                          borderRadius: BorderRadius.circular(3),
                        ),
                        child: Text(l10n.nativeRateBadge, style: const TextStyle(fontSize: 10, color: Colors.green)),
                      ),
                    ],
                  ]),
                );
              }).toList(),
              onChanged: (_isRecording || !_isWindows) ? null : (int? r) {
                if (r != null) {
                  setState(() => _sampleRate = r);
                  logDebug('🎚️ Sample rate → $r Hz');
                }
              },
            ),
            const SizedBox(height: 8),

            // Gain slider
            Row(children: [
              const Icon(Icons.volume_up, size: 16),
              const SizedBox(width: 4),
              Expanded(child: Text(
                '${l10n.microphoneGainLabel}: ${_gainMultiplier.toStringAsFixed(1)}x'
                ' (${(20 * math.log(_gainMultiplier) / math.ln10).toStringAsFixed(1)} dB)',
                style: theme.textTheme.bodySmall,
              )),
            ]),
            Slider(
              value: _gainMultiplier,
              min: 1.0, max: 10.0, divisions: 18,
              label: '${_gainMultiplier.toStringAsFixed(1)}x',
              onChanged: (_isRecording || !_isWindows) ? null : (v) => setState(() => _gainMultiplier = v),
            ),
            Text(l10n.gainHint, style: theme.textTheme.bodySmall?.copyWith(color: theme.colorScheme.onSurfaceVariant)),
          ],
        ),
      ),
    );
  }

  // ── Right panel widgets ───────────────────────────────────────────────────

  Widget _buildRecordingStatus(ThemeData theme, AppLocalizations l10n) {
    return Container(
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: (_isRecording ? Colors.red : Colors.green).withValues(alpha: 0.1),
        border: Border.all(color: _isRecording ? Colors.red : Colors.green, width: 1.5),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(children: [
        Icon(_isRecording ? Icons.fiber_manual_record : Icons.check_circle,
            color: _isRecording ? Colors.red : Colors.green, size: 20),
        const SizedBox(width: 8),
        Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Text(
            _isRecording ? l10n.recording : l10n.recordingCompleteLabel,
            style: theme.textTheme.bodyMedium?.copyWith(
              fontWeight: FontWeight.bold,
              color: _isRecording ? Colors.red : Colors.green,
            ),
          ),
          if (_isRecording)
            Text(l10n.tapMicToStop, style: theme.textTheme.bodySmall)
          else if (_recordingDuration != null && _recordedFileSize != null)
            Text('${_recordingDuration!.inSeconds}s · ${(_recordedFileSize! / 1024).toStringAsFixed(1)} KB',
                style: theme.textTheme.bodySmall),
        ])),
      ]),
    );
  }

  Widget _buildDebugInfo(ThemeData theme, AppLocalizations l10n) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(l10n.debugInformationLabel,
                style: theme.textTheme.titleSmall?.copyWith(fontWeight: FontWeight.bold)),
            const SizedBox(height: 4),
            Text(l10n.debugConsoleHint,
                style: theme.textTheme.bodySmall?.copyWith(color: theme.colorScheme.onSurfaceVariant)),
            const SizedBox(height: 8),
            _dbgRow(l10n.debugDevicesFound, '${_availableDevices.length}', theme),
            _dbgRow(l10n.debugSelectedDevice, _selectedDevice?.name ?? '-', theme),
            _dbgRow(l10n.debugDeviceRateNative,
                _selectedDevice != null ? '${_selectedDevice!.preferredSampleRate} Hz' : '-', theme),
            _dbgRow(l10n.debugRequestedRate, '$_sampleRate Hz', theme),
            if (_audioRecorder.actualSampleRate > 0)
              _dbgRow(l10n.debugActualRate,
                  '${_audioRecorder.actualSampleRate} Hz '
                  '${_audioRecorder.actualSampleRate == _sampleRate ? l10n.debugActualRateOk : l10n.debugActualRateForced}',
                  theme),
            _dbgRow(l10n.debugRecordingMode, _isStereo ? l10n.debugStereo : l10n.debugMono, theme),
            if (_recordingDuration != null)
              _dbgRow(l10n.debugLastRecording, '${_recordingDuration!.inSeconds}s', theme),
            if (_recordedFileSize != null)
              _dbgRow(l10n.debugFileSize, '${(_recordedFileSize! / 1024).toStringAsFixed(1)} KB', theme),
          ],
        ),
      ),
    );
  }

  Widget _buildTranscriptionResult(ThemeData theme, AppLocalizations l10n) {
    return Container(
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: Colors.green.withValues(alpha: 0.08),
        border: Border.all(color: Colors.green),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Row(children: [
          const Icon(Icons.check_circle, color: Colors.green, size: 16),
          const SizedBox(width: 6),
          Text(l10n.transcriptionResultLabel,
              style: theme.textTheme.labelMedium?.copyWith(color: Colors.green)),
        ]),
        const SizedBox(height: 6),
        SelectableText(_transcriptionResult!, style: theme.textTheme.bodySmall),
      ]),
    );
  }

  Widget _buildTranscriptionError(ThemeData theme, AppLocalizations l10n) {
    return Container(
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: Colors.red.withValues(alpha: 0.08),
        border: Border.all(color: Colors.red),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Row(children: [
          const Icon(Icons.error_outline, color: Colors.red, size: 16),
          const SizedBox(width: 6),
          Text(l10n.transcriptionFailedLabel,
              style: theme.textTheme.labelMedium?.copyWith(color: Colors.red)),
        ]),
        const SizedBox(height: 6),
        Text(_transcriptionError!, style: theme.textTheme.bodySmall),
      ]),
    );
  }

  Widget _dbgRow(String label, String value, ThemeData theme) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 2),
      child: Row(children: [
        Expanded(flex: 2, child: Text(label,
            style: theme.textTheme.bodySmall?.copyWith(fontWeight: FontWeight.w500))),
        Expanded(flex: 3, child: Text(value, style: theme.textTheme.bodySmall)),
      ]),
    );
  }

  // ── Bottom bar ────────────────────────────────────────────────────────────

  Widget _buildBottomBar(ThemeData theme, AppLocalizations l10n, {required bool hasApiKey}) {
    final hasRecording = _recordedFilePath != null && !_isRecording;

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [

        // ── Microphone button ──────────────────────────────────────────────
        _BottomBarButton(
          onTap: _isRecording ? _stopRecording : _startRecording,
          icon: _isRecording ? Icons.stop : Icons.mic,
          label: _isRecording ? l10n.tapToStopRec : l10n.tapToStartRec,
          color: _isRecording ? Colors.red : theme.colorScheme.primary,
          isActive: _isRecording,
          disabled: !_isWindows,
        ),

        // ── Play button ────────────────────────────────────────────────────
        _BottomBarButton(
          onTap: (!hasRecording || !_isWindows) ? null : (_isPlaying ? _stopPlayback : _playAudio),
          icon: _isPlaying ? Icons.stop : Icons.play_arrow,
          label: _isPlaying ? l10n.stopPlaybackLabel : l10n.playRecordingLabel,
          color: theme.colorScheme.secondary,
          isActive: _isPlaying,
          disabled: !hasRecording || !_isWindows,
          subtitle: hasRecording && _recordedFilePath != null
              ? '${(_recordedFileSize ?? 0) ~/ 1024} KB · ${_recordingDuration?.inSeconds ?? 0}s'
              : null,
        ),

        // ── Whisper button — only active when recording exists AND API key set ──
        _BottomBarButton(
          onTap: (!hasRecording || _isTranscribing || _isPlaying || !hasApiKey) ? null : _transcribeAudio,
          icon: Icons.transcribe,
          label: _isTranscribing ? l10n.transcribingLabel : l10n.sendToWhisperLabel,
          color: theme.colorScheme.tertiary,
          isActive: _isTranscribing,
          disabled: !hasRecording || !hasApiKey,
          isLoading: _isTranscribing,
          subtitle: hasApiKey ? l10n.whisperWavNote : l10n.openaiApiKey,
        ),
      ],
    );
  }
}

// ── Bottom bar button widget ──────────────────────────────────────────────────

class _BottomBarButton extends StatelessWidget {
  final VoidCallback? onTap;
  final IconData icon;
  final String label;
  final Color color;
  final bool isActive;
  final bool disabled;
  final bool isLoading;
  final String? subtitle;

  const _BottomBarButton({
    required this.onTap,
    required this.icon,
    required this.label,
    required this.color,
    this.isActive = false,
    this.disabled = false,
    this.isLoading = false,
    this.subtitle,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final effectiveColor = disabled ? theme.disabledColor : color;

    return Expanded(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 6),
        child: InkWell(
          onTap: disabled ? null : onTap,
          borderRadius: BorderRadius.circular(12),
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
            decoration: BoxDecoration(
              color: isActive
                  ? effectiveColor.withValues(alpha: 0.15)
                  : (disabled ? Colors.transparent : effectiveColor.withValues(alpha: 0.08)),
              border: Border.all(
                color: isActive ? effectiveColor : (disabled ? theme.disabledColor : effectiveColor.withValues(alpha: 0.5)),
                width: isActive ? 2 : 1,
              ),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Icon or spinner
                if (isLoading)
                  SizedBox(width: 28, height: 28,
                    child: CircularProgressIndicator(strokeWidth: 2.5, color: effectiveColor))
                else
                  Icon(icon, size: 28, color: effectiveColor),
                const SizedBox(width: 10),
                Flexible(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(label,
                        style: theme.textTheme.bodyMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                          color: disabled ? theme.disabledColor : effectiveColor,
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                      if (subtitle != null)
                        Text(subtitle!,
                          style: theme.textTheme.bodySmall?.copyWith(
                            color: disabled
                                ? theme.disabledColor
                                : theme.colorScheme.onSurfaceVariant,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

