// lib/data/models/app_settings.dart
//
// Application Settings Model
//

import 'package:equatable/equatable.dart';

/// Application-level settings stored in SharedPreferences
class AppSettings extends Equatable {
  /// User's preferred UI language code (e.g., 'en', 'hu')
  final String userLanguageCode;

  /// User's preferred UI language name (e.g., 'English', 'Hungarian')
  final String userLanguageName;

  /// DeepL API key (optional)
  final String? deeplApiKey;

  /// OpenAI API key (optional)
  final String? openaiApiKey;

  /// Selected OpenAI model for AI text analysis
  final String openaiModel;

  /// Selected knowledge level for AI text analysis (A1, A2, B1, B2, C1, C2)
  final String aiKnowledgeLevel;

  /// Minimum number of guesses required in training session to earn badges (not visible to user)
  final int minItemsForBadges;

  /// Last trained package ID (hidden setting to remember last training session)
  final String? lastTrainedPackageId;

  /// Show examples card in training rally page (hidden setting)
  final bool showTrainingExamples;

  /// Show training statistics chart in training rally page (hidden setting)
  final bool showTrainingStatistics;

  const AppSettings({
    this.userLanguageCode = 'en-US',
    this.userLanguageName = 'English (United States)',
    this.deeplApiKey,
    this.openaiApiKey,
    this.openaiModel = 'gpt-4-turbo',
    this.aiKnowledgeLevel = 'B1',
    this.minItemsForBadges = 10,
    this.lastTrainedPackageId,
    this.showTrainingExamples = true,
    this.showTrainingStatistics = true,
  });

  AppSettings copyWith({
    String? userLanguageCode,
    String? userLanguageName,
    Object? deeplApiKey = _sentinel,  // Use sentinel to distinguish null from "not provided"
    Object? openaiApiKey = _sentinel,
    String? openaiModel,
    String? aiKnowledgeLevel,
    int? minItemsForBadges,
    Object? lastTrainedPackageId = _sentinel,
    bool? showTrainingExamples,
    bool? showTrainingStatistics,
  }) {
    return AppSettings(
      userLanguageCode: userLanguageCode ?? this.userLanguageCode,
      userLanguageName: userLanguageName ?? this.userLanguageName,
      deeplApiKey: deeplApiKey == _sentinel ? this.deeplApiKey : deeplApiKey as String?,
      openaiApiKey: openaiApiKey == _sentinel ? this.openaiApiKey : openaiApiKey as String?,
      openaiModel: openaiModel ?? this.openaiModel,
      aiKnowledgeLevel: aiKnowledgeLevel ?? this.aiKnowledgeLevel,
      minItemsForBadges: minItemsForBadges ?? this.minItemsForBadges,
      lastTrainedPackageId: lastTrainedPackageId == _sentinel ? this.lastTrainedPackageId : lastTrainedPackageId as String?,
      showTrainingExamples: showTrainingExamples ?? this.showTrainingExamples,
      showTrainingStatistics: showTrainingStatistics ?? this.showTrainingStatistics,
    );
  }

  @override
  List<Object?> get props => [
        userLanguageCode,
        userLanguageName,
        deeplApiKey,
        openaiApiKey,
        openaiModel,
        aiKnowledgeLevel,
        minItemsForBadges,
        lastTrainedPackageId,
        showTrainingExamples,
        showTrainingStatistics,
      ];
}

// Sentinel value to distinguish between "not provided" and "provided as null"
const _sentinel = Object();

