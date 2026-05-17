import 'package:flutter/material.dart';
import '../../l10n/app_localizations.dart';

class OpenAiModelOption {
  final String id;
  final String Function(AppLocalizations l10n) labelBuilder;
  final String Function(AppLocalizations l10n)? descriptionBuilder;

  const OpenAiModelOption({
    required this.id,
    required this.labelBuilder,
    this.descriptionBuilder,
  });

  String label(AppLocalizations l10n) => labelBuilder(l10n);

  String description(AppLocalizations l10n) => descriptionBuilder?.call(l10n) ?? '';
}

class OpenAiModelCatalog {
  static const String defaultModelId = 'gpt-5.5';

  static const List<OpenAiModelOption> availableModels = [
    OpenAiModelOption(
      id: 'gpt-3.5-turbo',
      labelBuilder: _labelGpt35Turbo,
      descriptionBuilder: _descGpt35Turbo,
    ),
    OpenAiModelOption(
      id: 'gpt-5.5',
      labelBuilder: _labelGpt55,
      descriptionBuilder: _descGpt55,
    ),
    OpenAiModelOption(
      id: 'gpt-5.5-pro',
      labelBuilder: _labelGpt55Pro,
      descriptionBuilder: _descGpt55Pro,
    ),
    OpenAiModelOption(
      id: 'gpt-5.4',
      labelBuilder: _labelGpt54,
      descriptionBuilder: _descGpt54,
    ),
    OpenAiModelOption(
      id: 'gpt-5.4-pro',
      labelBuilder: _labelGpt54Pro,
      descriptionBuilder: _descGpt54Pro,
    ),
    OpenAiModelOption(
      id: 'gpt-5.4-mini',
      labelBuilder: _labelGpt54Mini,
      descriptionBuilder: _descGpt54Mini,
    ),
    OpenAiModelOption(
      id: 'gpt-5-mini',
      labelBuilder: _labelGpt5Mini,
      descriptionBuilder: _descGpt5Mini,
    ),
    OpenAiModelOption(
      id: 'gpt-4.1',
      labelBuilder: _labelGpt41,
      descriptionBuilder: _descGpt41,
    ),
    OpenAiModelOption(
      id: 'gpt-4-turbo',
      labelBuilder: _labelGpt4Turbo,
      descriptionBuilder: _descGpt4Turbo,
    ),
  ];

  static bool contains(String? modelId) {
    if (modelId == null || modelId.trim().isEmpty) {
      return false;
    }

    return availableModels.any((model) => model.id == modelId);
  }

  static String normalizeSelection(String? modelId) {
    if (contains(modelId)) {
      return modelId!;
    }

    return defaultModelId;
  }

  static String descriptionFor(String? modelId, AppLocalizations l10n) {
    final option = modelFor(modelId);
    return option?.description(l10n) ?? '';
  }

  static OpenAiModelOption? modelFor(String? modelId) {
    for (final model in availableModels) {
      if (model.id == modelId) {
        return model;
      }
    }

    return null;
  }

  static List<DropdownMenuItem<String>> buildDropdownItems(AppLocalizations l10n) {
    final sortedModels = [...availableModels]
      ..sort((a, b) => a.label(l10n).toLowerCase().compareTo(b.label(l10n).toLowerCase()));

    return sortedModels
        .map(
          (model) => DropdownMenuItem<String>(
            value: model.id,
            child: Text(model.label(l10n)),
          ),
        )
        .toList(growable: false);
  }

  static String _labelGpt35Turbo(AppLocalizations l10n) => l10n.modelGpt35Turbo;
  static String _descGpt35Turbo(AppLocalizations l10n) => l10n.modelGpt35TurboDesc;
  static String _labelGpt55(AppLocalizations l10n) => l10n.modelGpt55;
  static String _descGpt55(AppLocalizations l10n) => l10n.modelGpt55Desc;
  static String _labelGpt55Pro(AppLocalizations l10n) => l10n.modelGpt55Pro;
  static String _descGpt55Pro(AppLocalizations l10n) => l10n.modelGpt55ProDesc;
  static String _labelGpt54(AppLocalizations l10n) => l10n.modelGpt54;
  static String _descGpt54(AppLocalizations l10n) => l10n.modelGpt54Desc;
  static String _labelGpt54Pro(AppLocalizations l10n) => l10n.modelGpt54Pro;
  static String _descGpt54Pro(AppLocalizations l10n) => l10n.modelGpt54ProDesc;
  static String _labelGpt54Mini(AppLocalizations l10n) => l10n.modelGpt54Mini;
  static String _descGpt54Mini(AppLocalizations l10n) => l10n.modelGpt54MiniDesc;
  static String _labelGpt5Mini(AppLocalizations l10n) => l10n.modelGpt5Mini;
  static String _descGpt5Mini(AppLocalizations l10n) => l10n.modelGpt5MiniDesc;
  static String _labelGpt41(AppLocalizations l10n) => l10n.modelGpt41;
  static String _descGpt41(AppLocalizations l10n) => l10n.modelGpt41Desc;
  static String _labelGpt4Turbo(AppLocalizations l10n) => l10n.modelGpt4Turbo;
  static String _descGpt4Turbo(AppLocalizations l10n) => l10n.modelGpt4TurboDesc;
}

