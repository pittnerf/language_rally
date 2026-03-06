# Pronunciation Practice - OpenAI Whisper API Integration

## Overview

The Pronunciation Practice feature now supports **two modes** of operation:

1. **Premium Mode (Recommended)**: Uses OpenAI's Whisper API for high-quality speech recognition
2. **Fallback Mode**: Uses native platform speech recognition (Google/Apple)

## Why Whisper API is Better

### Advantages of OpenAI Whisper:

✅ **Superior Accuracy** - State-of-the-art speech recognition  
✅ **99+ Languages** - Supports more languages than native platforms  
✅ **Better with Accents** - More robust to different pronunciations and accents  
✅ **No Timeout Issues** - Manual recording control, no automatic timeouts  
✅ **Consistent Quality** - Same high quality across Android, iOS, and Desktop  
✅ **Offline Recording** - Records locally, processes when ready  
✅ **Context-Aware** - Uses expected text as prompt for better accuracy  

### Native Speech Recognition Limitations:

❌ Platform-dependent quality  
❌ Automatic timeout (can cause "no speech detected" errors)  
❌ Limited language support  
❌ Varies by device manufacturer  
❌ Requires internet for some languages  
❌ Less accurate with accents  

## How It Works

### With OpenAI API Key (Premium Mode):

1. **User presses record button**
2. **Audio recording starts** (no speech recognition yet)
3. **User speaks** at their own pace
4. **User presses stop button** when done (manual control)
5. **Audio file is sent to OpenAI Whisper API** for transcription
6. **High-quality transcription** returned in seconds
7. **Match rate calculated** and feedback shown

### Without OpenAI API Key (Fallback Mode):

1. **User presses record button**
2. **Native speech recognition starts** immediately
3. **User must speak** within 2-5 seconds or it times out
4. **Automatic stop** after pause or timeout
5. **Basic transcription** from native platform
6. **Match rate calculated** and feedback shown

## Setup Instructions

### 1. Get OpenAI API Key

1. Go to https://platform.openai.com/signup
2. Create an account (if you don't have one)
3. Navigate to https://platform.openai.com/api-keys
4. Click "Create new secret key"
5. Copy the key (starts with `sk-`)
6. **Important**: Store it securely - you won't see it again!

### 2. Add API Key to App

1. Open Language Rally app
2. Go to **Settings**
3. Find **OpenAI API Key** field
4. Paste your API key
5. Save settings

### 3. Start Using Pronunciation Practice

Once the API key is configured:
- Pronunciation Practice will **automatically use Whisper API**
- You'll see **"Using OpenAI Whisper API"** in the debug logs
- Recording is now **manual** - you control when to stop

## Cost Information

### OpenAI Whisper API Pricing (as of 2024):

- **$0.006 per minute** of audio
- Example costs:
  - 100 practice sessions (30 sec each) = 50 minutes = **$0.30**
  - 1000 practice sessions = 500 minutes = **$3.00**
  - Daily practice for a month = ~$1-2

### Recommendations:

- **For casual users**: $5-10 credit lasts months
- **For teachers/schools**: Consider usage limits
- **Monitor usage**: Check https://platform.openai.com/usage

## Features

### Manual Recording Control

**With Whisper API (Premium)**:
- Press record → speak at your own pace → press stop
- No automatic timeouts
- No rush to start speaking
- Can speak for as long as needed
- Better for longer phrases and sentences

**Without API Key (Fallback)**:
- Press record → must speak within 2-5 seconds
- Automatic stop after pause
- Limited to ~60 seconds
- Can timeout if speaking too quietly

### Context-Aware Transcription

Whisper API uses the expected text as a "prompt" to improve accuracy:

```dart
final result = await _speechRecognitionService!.transcribeAudio(
  audioFilePath: audioPath,
  language: languageCode,
  prompt: expectedText, // Helps Whisper understand context
);
```

This means Whisper knows what you're trying to say, leading to better recognition of:
- Technical terms
- Proper nouns
- Language-specific expressions
- Subject-specific vocabulary

## Technical Implementation

### New Service: `SpeechRecognitionService`

Location: `lib/core/services/speech_recognition_service.dart`

Key methods:

```dart
// Check if Whisper API is available
bool get isWhisperAvailable

// Transcribe audio file
Future<WhisperTranscriptionResult> transcribeAudio({
  required String audioFilePath,
  String? language,
  String? prompt,
})

// Calculate confidence
double calculateConfidence(String transcribed, String expected)
```

### Updated Page: `PronunciationPracticePage`

Key changes:

1. **Initialization**:
   ```dart
   Future<void> _initializeSpeechRecognition() async {
     final openaiApiKey = appSettings.openaiApiKey;
     if (openaiApiKey != null && openaiApiKey.isNotEmpty) {
       _speechRecognitionService = SpeechRecognitionService(apiKey: openaiApiKey);
       _useWhisperAPI = true;
       _speechAvailable = true;
     } else {
       await _initializeSpeech(); // Fallback to native
       _useWhisperAPI = false;
     }
   }
   ```

2. **Recording Start**:
   - Whisper mode: Only starts audio recording
   - Native mode: Starts both audio recording and speech recognition

3. **Recording Stop**:
   - Whisper mode: Stops recording, sends to API, waits for transcription
   - Native mode: Stops recording, uses already-transcribed text

### API Request Format

```http
POST https://api.openai.com/v1/audio/transcriptions
Authorization: Bearer sk-...
Content-Type: multipart/form-data

file: <audio_file.m4a>
model: whisper-1
language: en
prompt: "The expected text to help with context"
response_format: verbose_json
```

### API Response Format

```json
{
  "text": "The transcribed text",
  "language": "en",
  "duration": 3.5,
  "segments": [
    {
      "id": 0,
      "start": 0.0,
      "end": 3.5,
      "text": "The transcribed text"
    }
  ]
}
```

## Debugging

### Check Which Mode is Active

Look for these log messages when starting pronunciation practice:

**Whisper API Mode**:
```
🎙️ Using OpenAI Whisper API for speech recognition
   ✓ High-quality transcription enabled
   ✓ Manual recording control (no automatic timeout)
```

**Native Mode**:
```
🎙️ OpenAI API key not found, attempting native speech recognition...
=== Speech Recognition Initialization ===
Platform: android
✓ Speech recognition initialized successfully
```

### During Recording

**Whisper Mode**:
```
📱 Starting audio recording for Whisper API...
   ⏱️ Recording will continue until user presses STOP button
✓ Audio recording started successfully (Whisper mode)
   User controls when to stop recording
```

**Native Mode**:
```
🎤 Starting native speech recognition...
✓ Speech listen command executed successfully
Is actually listening: true
```

### During Transcription

**Whisper Mode**:
```
🎙️ Stopping audio recording...
Audio file size: 53932 bytes
📤 Sending to OpenAI Whisper API...
   Expected text: "Physiological Dampening"
✓ Whisper transcription received: "Physiological dampening"
   Detected language: en
   Audio duration: 3.2s
```

### Error Messages

**Invalid API Key**:
```
!!! Whisper API error: Invalid OpenAI API key
```
→ **Solution**: Check API key in Settings

**Rate Limit**:
```
!!! Whisper API error: Rate limit exceeded
```
→ **Solution**: Wait a few minutes or upgrade OpenAI plan

**File Too Large**:
```
!!! Whisper API error: Audio file too large. Maximum size is 25MB
```
→ **Solution**: Keep recordings under 25MB (~5 minutes at standard quality)

## Best Practices

### For Users:

1. **Set up OpenAI API key** for best experience
2. **Speak naturally** - no need to rush with Whisper API
3. **Use longer phrases** - Whisper handles them better than native
4. **Monitor API usage** - Check costs periodically
5. **Practice more confidently** - No timeout pressure

### For Developers:

1. **Always provide fallback** to native speech recognition
2. **Show clear indicators** of which mode is active
3. **Handle API errors gracefully** with helpful messages
4. **Cache transcriptions** if repeating same items
5. **Consider batch processing** for multiple items
6. **Provide usage estimates** to users

### For Teachers:

1. **Shared API key** for class use (monitor costs)
2. **Set up school account** with usage limits
3. **Track student usage** for billing purposes
4. **Educate students** on API costs
5. **Consider alternatives** for large-scale deployments

## Comparison: Whisper vs Native

| Feature | Whisper API | Native Speech Recognition |
|---------|-------------|---------------------------|
| **Accuracy** | ⭐⭐⭐⭐⭐ Excellent | ⭐⭐⭐ Good (varies) |
| **Languages** | ⭐⭐⭐⭐⭐ 99+ | ⭐⭐⭐ Limited by platform |
| **Accents** | ⭐⭐⭐⭐⭐ Very robust | ⭐⭐ Variable |
| **Recording Control** | ⭐⭐⭐⭐⭐ Manual (no timeout) | ⭐⭐ Automatic timeout |
| **Cost** | 💰 $0.006/min | 💰 Free |
| **Internet Required** | ✅ Yes | ⚠️ Sometimes |
| **Setup** | 🔧 API key needed | 🔧 Platform setup |
| **Consistency** | ✅ Same everywhere | ❌ Varies by device |
| **Processing Time** | ⏱️ 2-5 seconds | ⏱️ Real-time |

## Migration Guide

### For Existing Users:

1. **Nothing changes** if you don't add an API key
2. **Add API key** to upgrade to Whisper mode
3. **Test both modes** to compare quality
4. **Choose based on needs** - free vs. accuracy

### Code Changes Required:

None! The feature automatically detects the API key and switches modes.

### Rollback:

To revert to native-only:
1. Remove OpenAI API key from Settings
2. App will automatically use native speech recognition
3. No code changes needed

## Future Enhancements

Potential improvements:

1. **Offline Whisper** - Run Whisper locally on powerful devices
2. **Batch Processing** - Process multiple recordings at once
3. **Voice Cloning** - Generate reference audio with native speaker voices
4. **Pronunciation Scoring** - Detailed phoneme-level analysis
5. **Real-time Feedback** - Show waveform and pitch during recording
6. **Usage Analytics** - Track API costs and accuracy improvements
7. **Caching** - Store transcriptions for frequently practiced items

## Troubleshooting

### Issue: "Speech recognition not available"

**Check**:
1. OpenAI API key configured in Settings?
2. API key valid? (test at https://platform.openai.com/playground)
3. Internet connection active?

### Issue: "Invalid OpenAI API key"

**Solutions**:
1. Verify key starts with `sk-`
2. Check for extra spaces when pasting
3. Regenerate key if compromised
4. Ensure API key has audio permissions

### Issue: "Rate limit exceeded"

**Solutions**:
1. Wait 1 minute and try again
2. Check usage at https://platform.openai.com/usage
3. Upgrade to paid plan if on free tier
4. Reduce practice frequency temporarily

### Issue: Processing takes too long

**Check**:
1. Internet speed - slow connection delays response
2. Audio file size - large files take longer
3. OpenAI service status - check https://status.openai.com
4. Recording length - keep under 1 minute for fast processing

## Support

For issues:
- **API Key Issues**: https://help.openai.com
- **App Issues**: Create an issue in the repository
- **Documentation**: See `/doc` folder

---

Last updated: 2026-03-06
Version: 2.0 (Whisper API Integration)

