# Language Rally - Achievement Badges

## Overview

This folder contains the achievement badge assets for the Language Rally application. Users earn badges based on the percentage of words they know in a package.

---

## Badge Levels

### 1. **25% Badge - Beginner** 🥉
**File**: `badge_25.svg`
- **Color**: Bronze (#CD7F32)
- **Stars**: 1 star
- **Label**: BEGINNER
- **Description**: First steps in learning - user knows 25% of vocabulary

### 2. **50% Badge - Learner** 🥈
**File**: `badge_50.svg`
- **Color**: Silver (#E8E8E8)
- **Stars**: 2 stars
- **Label**: LEARNER
- **Description**: Halfway milestone - user knows 50% of vocabulary

### 3. **75% Badge - Skilled** 🥇
**File**: `badge_75.svg`
- **Color**: Gold (#FFD700)
- **Stars**: 3 stars
- **Label**: SKILLED
- **Description**: Strong progress - user knows 75% of vocabulary

### 4. **80% Badge - Advanced** 💚
**File**: `badge_80.svg`
- **Color**: Emerald Green (#50C878)
- **Stars**: 3 stars + laurel
- **Label**: ADVANCED
- **Description**: Advanced level - user knows 80% of vocabulary

### 5. **85% Badge - Proficient** 💙
**File**: `badge_85.svg`
- **Color**: Sapphire Blue (#4169E1)
- **Stars**: 4 stars
- **Label**: PROFICIENT
- **Description**: Proficient level - user knows 85% of vocabulary

### 6. **90% Badge - Excellent** 💜
**File**: `badge_90.svg`
- **Color**: Purple (#9370DB)
- **Stars**: 5 stars + crown
- **Label**: EXCELLENT
- **Description**: Excellent achievement - user knows 90% of vocabulary

### 7. **95% Badge - Master** ⭐
**File**: `badge_95.svg`
- **Color**: Platinum (#E5E4E2)
- **Stars**: 5 premium stars + diamond + laurel wreath
- **Label**: MASTER
- **Description**: Master level - user knows 95% of vocabulary

---

## Badge Design Elements

### Visual Components
- **Circular badge** with gradient fill
- **Decorative ribbons** at bottom
- **Stars** indicating achievement level (1-5)
- **Percentage text** prominently displayed
- **Label text** describing the level
- **Special decorations** for higher levels (crown, laurel, diamond)

### Color Progression
1. Bronze (25%) → Silver (50%) → Gold (75%)
2. Emerald (80%) → Sapphire (85%) → Purple (90%)
3. Platinum (95%) - ultimate achievement

### Size Specifications
- **Dimensions**: 128x128 pixels (SVG, scalable)
- **Format**: SVG (Scalable Vector Graphics)
- **Viewbox**: 0 0 128 128

---

## Usage in Code

### Display a Badge
```dart
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

Widget buildBadge(String badgeId) {
  return SvgPicture.asset(
    'assets/images/badges/$badgeId.svg',
    width: 64,
    height: 64,
  );
}

// Example
buildBadge('badge_75')  // Shows the 75% Gold badge
```

### Check Which Badge User Has Earned
```dart
String getBadgeId(double accuracy) {
  if (accuracy >= 95) return 'badge_95';
  if (accuracy >= 90) return 'badge_90';
  if (accuracy >= 85) return 'badge_85';
  if (accuracy >= 80) return 'badge_80';
  if (accuracy >= 75) return 'badge_75';
  if (accuracy >= 50) return 'badge_50';
  if (accuracy >= 25) return 'badge_25';
  return '';  // No badge yet
}
```

### Display All Earned Badges
```dart
class BadgeDisplay extends StatelessWidget {
  final List<String> earnedBadges;
  
  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: 8,
      runSpacing: 8,
      children: earnedBadges.map((badgeId) {
        return SvgPicture.asset(
          'assets/images/badges/$badgeId.svg',
          width: 48,
          height: 48,
        );
      }).toList(),
    );
  }
}
```

### Badge Progress Indicator
```dart
Widget buildBadgeProgress(double currentAccuracy) {
  final thresholds = [25.0, 50.0, 75.0, 80.0, 85.0, 90.0, 95.0];
  
  return Row(
    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
    children: thresholds.map((threshold) {
      final badgeId = 'badge_${threshold.toInt()}';
      final isEarned = currentAccuracy >= threshold;
      
      return Opacity(
        opacity: isEarned ? 1.0 : 0.3,
        child: SvgPicture.asset(
          'assets/images/badges/$badgeId.svg',
          width: 40,
          height: 40,
        ),
      );
    }).toList(),
  );
}
```

### Badge Notification
```dart
void showBadgeEarned(BuildContext context, String badgeId) {
  final badgeNames = {
    'badge_25': 'Beginner',
    'badge_50': 'Learner',
    'badge_75': 'Skilled',
    'badge_80': 'Advanced',
    'badge_85': 'Proficient',
    'badge_90': 'Excellent',
    'badge_95': 'Master',
  };
  
  showDialog(
    context: context,
    builder: (context) => AlertDialog(
      title: Text('🏆 Badge Earned!'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          SvgPicture.asset(
            'assets/images/badges/$badgeId.svg',
            width: 80,
            height: 80,
          ),
          SizedBox(height: 16),
          Text(
            badgeNames[badgeId] ?? '',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: Text('Awesome!'),
        ),
      ],
    ),
  );
}
```

---

## Badge Logic

### Calculating Accuracy
```dart
double calculateAccuracy(int knownItems, int totalItems) {
  if (totalItems == 0) return 0.0;
  return (knownItems / totalItems) * 100;
}
```

### Determining Badge Thresholds
Based on user requirements:
- **25%** = At least 1/4 of items known
- **50%** = At least 1/2 of items known
- **75%** = At least 3/4 of items known
- **80%** = At least 4/5 of items known
- **85%** = At least 17/20 of items known
- **90%** = At least 9/10 of items known
- **95%** = At least 19/20 of items known

### Badge Detection in Training Session
```dart
List<String> checkNewBadges(
  TrainingSession session,
  List<String> previousBadges,
) {
  final newBadges = <String>[];
  final accuracy = session.accuracy;
  
  final badgeThresholds = [
    (95.0, 'badge_95'),
    (90.0, 'badge_90'),
    (85.0, 'badge_85'),
    (80.0, 'badge_80'),
    (75.0, 'badge_75'),
    (50.0, 'badge_50'),
    (25.0, 'badge_25'),
  ];
  
  for (final (threshold, badgeId) in badgeThresholds) {
    if (accuracy >= threshold && !previousBadges.contains(badgeId)) {
      newBadges.add(badgeId);
    }
  }
  
  return newBadges;
}
```

---

## Installation

### 1. Ensure badges are in assets folder
```
assets/
  images/
    badges/
      badge_25.svg
      badge_50.svg
      badge_75.svg
      badge_80.svg
      badge_85.svg
      badge_90.svg
      badge_95.svg
```

### 2. Add to pubspec.yaml
```yaml
flutter:
  assets:
    - assets/images/badges/
```

### 3. Add flutter_svg dependency
```yaml
dependencies:
  flutter_svg: ^2.0.0
```

### 4. Run flutter pub get
```bash
flutter pub get
```

---

## Display Patterns

### Package Card with Badges
```dart
Card(
  child: Column(
    children: [
      // Package info
      Text('English → German'),
      
      // Badge display
      if (earnedBadges.isNotEmpty)
        Row(
          children: earnedBadges.take(3).map((badge) {
            return Padding(
              padding: EdgeInsets.all(4),
              child: SvgPicture.asset(
                'assets/images/badges/$badge.svg',
                width: 32,
                height: 32,
              ),
            );
          }).toList(),
        ),
    ],
  ),
)
```

### Statistics Screen
```dart
GridView.builder(
  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
    crossAxisCount: 3,
    mainAxisSpacing: 16,
    crossAxisSpacing: 16,
  ),
  itemCount: 8,
  itemBuilder: (context, index) {
    final thresholds = [25, 50, 75, 80, 85, 90, 95, 100];
    final threshold = thresholds[index];
    final badgeId = 'badge_$threshold';
    final isEarned = earnedBadges.contains(badgeId);
    
    return Column(
      children: [
        Container(
          decoration: BoxDecoration(
            border: isEarned ? Border.all(color: Colors.amber, width: 2) : null,
            borderRadius: BorderRadius.circular(8),
          ),
          child: Stack(
            children: [
              SvgPicture.asset(
                'assets/images/badges/$badgeId.svg',
                width: 80,
                height: 80,
                color: isEarned ? null : Colors.grey,
                colorBlendMode: isEarned ? null : BlendMode.saturation,
              ),
              if (!isEarned)
                Positioned.fill(
                  child: Icon(Icons.lock, size: 32, color: Colors.grey),
                ),
            ],
          ),
        ),
        SizedBox(height: 4),
        Text('$threshold%'),
      ],
    );
  },
)
```

---

## Future Enhancements

Potential improvements:
- Animated badge reveal
- Badge sharing to social media
- Special event badges
- Combo badges (multiple packages)
- Time-limited badges
- Streak badges

---

## Credits

- Designed for Language Rally application
- SVG format for scalability
- Theme-consistent color palette
- Material Design inspired

---

**Note**: These badges are SVG format and require the `flutter_svg` package to display in Flutter applications.

