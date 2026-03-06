# Pronunciation Scoring System

## Overview
The pronunciation practice feature uses a sophisticated hybrid scoring system that combines **speech recognition accuracy** with **audio waveform analysis** to provide comprehensive feedback on pronunciation quality.

## Scoring Components

### 1. Word Match Rate (50% Weight)
Evaluates how accurately the user spoke the expected words using speech-to-text recognition.

**How it works:**
- The expected text is split into individual words
- The user's speech is converted to text using speech recognition
- Each recognized word is checked against the expected words
- Words that match (exactly or partially) are counted
- Formula: `wordMatchRate = matchedWords / totalExpectedWords`

**Example:**
- Expected: "hello world"
- User said: "hello word"
- Match: 1 out of 2 words = **50% word match**

### 2. Audio Waveform & Volume Analysis (50% Weight)
Analyzes the acoustic characteristics of the user's pronunciation to evaluate rhythm, intonation, and speech patterns.

This component is further divided into three sub-metrics:

#### 2.1 Duration Similarity (30% of audio score)
Compares the speaking duration with the expected duration.

**How it works:**
- Expected duration is calculated based on text length: ~2.5 words per second
- Actual duration is extracted from the audio recording
- Optimal range: 0.8x to 1.2x of expected duration (100% score)
- Acceptable range: 0.7x to 1.5x (gradual penalty)
- Too fast (<0.7x) or too slow (>1.5x) receive lower scores

**Normalization:** Duration ratios are used (not absolute times), making it fair for both short and long phrases.

#### 2.2 Volume Pattern Score (40% of audio score)
Analyzes stress patterns and intonation through volume variations.

**How it works:**
- Audio is sampled every 1000 bytes to create a volume pattern
- RMS (Root Mean Square) is calculated for each chunk and normalized (0-1 range)
- **Dynamic Range:** Good pronunciation has varied volume (min 0.3 range normalized)
- **Peak Detection:** Identifies volume peaks (stressed syllables)
- Expected: roughly one peak per word
- Normalization: All volume values are normalized to 0-1 scale, making it fair for both men (typically deeper/louder) and women (typically higher/softer)

**Gender Neutrality:**
- Volume is normalized relative to the speaker's own maximum volume
- Peak detection uses relative thresholds (>0.5 normalized)
- No absolute volume thresholds are used

#### 2.3 Rhythm Score (30% of audio score)
Evaluates pacing and natural speech flow.

**How it works:**
- **Pause Detection:** Identifies low-volume segments (threshold: 0.2 normalized)
- Expected pauses: 0-2 per sentence (varies with length: wordCount/5)
- **Pacing Consistency:** Standard deviation of volume pattern
- Optimal variance: 0.15-0.35 (natural speech variation)
- Too consistent or too erratic results in lower scores

**Normalization:** Relative thresholds and ratios ensure fairness across all voices.

## Audio Feature Extraction

### Technical Implementation
The system extracts features from recorded audio (AAC format, 44.1kHz, 128kbps):

1. **Duration Estimation:**
   - File size ÷ 16KB per second ≈ duration in seconds

2. **Volume Pattern:**
   - Sample every 1000 bytes
   - Calculate RMS for each chunk: √(Σ(normalized_byte²) / chunk_size)
   - Normalize to 0-1 range by dividing by max volume

3. **Normalization Benefits:**
   - **Gender-neutral:** Relative values work for all voice types
   - **Device-independent:** Works across different microphone sensitivities
   - **Volume-independent:** Whispered or loud speech both work

## Final Score Calculation

```
Final Score = (Word Match Rate × 0.5) + (Audio Analysis × 0.5)

Where Audio Analysis = 
  (Duration Score × 0.3) + 
  (Volume Pattern Score × 0.4) + 
  (Rhythm Score × 0.3)
```

## Score Categories

The final percentage (0-100%) is categorized into five zones:

| Score Range | Label | Color | Interpretation |
|-------------|-------|-------|----------------|
| 80-100% | Excellent | Green | Near-native pronunciation |
| 60-79% | Good | Light Green | Solid pronunciation |
| 40-59% | Fair | Orange | Needs practice |
| 20-39% | Needs Improvement | Deep Orange | Significant errors |
| 0-19% | Try Again | Red | Not understood |

## Advantages Over Previous System

### Old System (Removed):
- ❌ 70% word match + 30% character similarity
- ❌ Only text-based comparison
- ❌ No acoustic analysis
- ❌ No intonation/rhythm evaluation

### New System:
- ✅ 50% word match + 50% audio analysis
- ✅ Waveform and volume pattern evaluation
- ✅ Stress pattern detection (peaks)
- ✅ Rhythm and pacing assessment
- ✅ Duration accuracy check
- ✅ **Gender-neutral through normalization**
- ✅ **Device-independent through relative metrics**

## Normalization Strategy

The key to fair scoring across different speakers:

1. **Volume Normalization:**
   - All volumes are normalized to 0-1 relative to the speaker's maximum
   - No absolute volume thresholds

2. **Duration Ratios:**
   - Uses ratios (actual/expected) instead of absolute times
   - Works for fast and slow speakers

3. **Relative Thresholds:**
   - Peak detection: >0.5 (relative to normalized volume)
   - Pause detection: <0.2 (relative to normalized volume)
   - Dynamic range: minimum 0.3 (30% of speaker's range)

4. **Statistical Measures:**
   - Standard deviation and variance for consistency
   - Independent of absolute values

## Limitations

1. **TTS Reference Audio:**
   - Currently, the system doesn't generate a reference audio file from TTS
   - Future enhancement: Compare user audio directly with TTS-generated audio

2. **Simplified Audio Processing:**
   - Uses basic RMS calculation (production would use FFT/MFCC)
   - Approximates duration from file size
   - No actual audio decoding (just byte analysis)

3. **Speech Recognition Dependency:**
   - Word match depends on speech recognition accuracy
   - May struggle with accents or background noise

4. **No Phonetic Analysis:**
   - Doesn't analyze actual phonemes or sounds
   - Relies on pattern recognition rather than linguistic analysis

## Future Enhancements

1. **Deep Audio Comparison:**
   - Generate TTS reference audio
   - Compare waveforms directly using cross-correlation
   - MFCC (Mel-Frequency Cepstral Coefficients) analysis

2. **Advanced Audio Processing:**
   - Proper audio decoding (not just byte analysis)
   - Pitch detection and comparison
   - Formant analysis for vowel quality

3. **Machine Learning:**
   - Train on native speaker samples
   - Personalized scoring based on learner's progress
   - Accent-specific evaluation

4. **Real-time Feedback:**
   - Live waveform visualization during recording
   - Immediate feedback on stress patterns
   - Practice mode with guided exercises

## Gestures

The pronunciation practice page supports swipe gestures:
- **Swipe right (→):** Next item
- **Swipe left (←):** End practice

Works in all orientations (portrait/landscape) and device types (phone/tablet).

## Technical Notes

### Dependencies
- **record** package version: 5.2.1
- **record_linux** dependency override: 1.3.0 (fixes Windows build compatibility issues)

### Windows Build Fix
If you encounter build errors related to `record_linux`, ensure the `pubspec.yaml` includes:
```yaml
dependency_overrides:
  record_linux: ^1.3.0
```

This resolves compatibility issues between the record package and Windows platform builds.

