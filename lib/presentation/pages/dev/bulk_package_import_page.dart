// lib/presentation/pages/dev/bulk_package_import_page.dart
//
// ADMIN TOOL – Bulk Package Creator & Item Importer
//
// Only reachable from HomePage when PRINT_DEBUG == true.
//
// ── How to use ────────────────────────────────────────────────────────────────
//  1. Export the packages you want to seed from the app as ZIP files and place
//     them in assets/seed_packages/ (see seed packaging docs), OR
//  2. Prepare JSON item files in the format used by the normal JSON import
//     (array of objects with source_expression, target_expression, categories …)
//  3. Fill in _packageDefinitions below – one _PackageDef per package.
//  4. Run the app in debug mode, open Home → "Bulk Package Import".
//  5. Press ▶ Run All.
// ─────────────────────────────────────────────────────────────────────────────

import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:uuid/uuid.dart';

import '../../../core/constants/language_codes.dart';
import '../../../core/theme/app_theme.dart';
import '../../../core/utils/debug_print.dart';
import '../../../data/models/category.dart';
import '../../../data/models/example_sentence.dart';
import '../../../data/models/item.dart';
import '../../../data/models/item_language_data.dart';
import '../../../data/models/language_package.dart';
import '../../../data/models/language_package_group.dart';
import '../../../data/repositories/category_repository.dart';
import '../../../data/repositories/import_export_repository.dart';
import '../../../data/repositories/item_repository.dart';
import '../../../data/repositories/language_package_group_repository.dart';
import '../../../data/repositories/language_package_repository.dart';

// ═══════════════════════════════════════════════════════════════════════════════
// ▼▼▼  EDIT HERE – your package batch  ▼▼▼
// ═══════════════════════════════════════════════════════════════════════════════

/// Asset paths for the built-in package icons, indexed 0–12.
/// Index 0 → no icon (app default dictionary icon)
/// Index 1 → default_package_icon.svg
/// Index 2–12 → package_icon_v2.svg … package_icon_v12.svg
const List<String?> _kIconPaths = [
  null,                                                    // 0 – app default
  'assets/images/package_icons/default_package_icon.svg', // 1
  'assets/images/package_icons/package_icon_v2.svg',      // 2
  'assets/images/package_icons/package_icon_v3.png',      // 3
  'assets/images/package_icons/package_icon_v4.svg',      // 4
  'assets/images/package_icons/package_icon_v5.svg',      // 5
  'assets/images/package_icons/package_icon_v6.svg',      // 6
  'assets/images/package_icons/package_icon_v7.svg',      // 7
  'assets/images/package_icons/package_icon_v8.svg',      // 8
  'assets/images/package_icons/package_icon_v9.svg',      // 9
  'assets/images/package_icons/package_icon_v10.svg',     // 10
  'assets/images/package_icons/package_icon_v11.svg',     // 11
  'assets/images/package_icons/package_icon_v12.svg',     // 12
];

/// One package definition.
///
/// [jsonFilePath] can be:
///  • an absolute path  (e.g. r'C:\MyData\EN_DE_Animals.json')
///  • a relative path   resolved against the app's Documents folder
///    (e.g. r'JSON_to_import\EN_DE_A1_Animals.json')
class PackageDef {
  final String groupName;
  final int iconIndex;
  final String packageName;
  final String langCode1;   // source, e.g. 'en-US'
  final String langCode2;   // target, e.g. 'de-DE'
  final String description;
  final String authorName;
  final String authorEmail;
  final String version;
  final String authorWebpage;
  final bool isPurchased;
  final String jsonFilePath;

  const PackageDef({
    required this.groupName,
    required this.iconIndex,
    required this.packageName,
    required this.langCode1,
    required this.langCode2,
    this.description = '',
    this.authorName = '',
    this.authorEmail = '',
    this.version = '1.0',
    this.authorWebpage = '',
    this.isPurchased = false,
    required this.jsonFilePath,
  });
}

/// ══════════════════════════════════════════════════════════
///  ▼  INSERT YOUR PACKAGE LIST HERE  ▼
/// ══════════════════════════════════════════════════════════
const List<PackageDef> _packageDefinitions = [
  // Example (uncomment and adapt):
//  PackageDef(
//    groupName:    'A1 EN-DE expressions',
//    iconIndex:    4,
//    packageName:  'A1 Animals',
//    langCode1:    'en-UK',
//    langCode2:    'de-DE',
//    description:  'Vocabulary for Animals at A1 level.',
//    authorName:   'Language Rally Team',
//    authorEmail:  'languagerally.support@gmail.com',
//    version:      '1.0',
//    authorWebpage:'https://sites.google.com/view/language-rally',
//    isPurchased:  true,
//    jsonFilePath: r'JSON_to_import\EN_DE_A1_Animals_EXPRESSIONS.json',
//  ),
  PackageDef(
    groupName:    'EN-RU B1',
    iconIndex:    7,
    packageName:  'B1 Basic politics & society',
    langCode1:    'en-UK',
    langCode2:    'ru-RU',
    description:  'Vocabulary for Basic politics & society at B1 level.',
    authorName:   'Language Rally Team',
    authorEmail:  'languagerally.support@gmail.com',
    version:      '1.0',
    authorWebpage:'https://sites.google.com/view/language-rally',
    isPurchased:  true,
    jsonFilePath: r'JSON_to_import\EN_RU_B1_Communication_language_learning.json',
  ),
  PackageDef(
    groupName:    'EN-RU B1',
    iconIndex:    10,
    packageName:  'B1 City vs countryside',
    langCode1:    'en-UK',
    langCode2:    'ru-RU',
    description:  'Vocabulary for City vs countryside at B1 level.',
    authorName:   'Language Rally Team',
    authorEmail:  'languagerally.support@gmail.com',
    version:      '1.0',
    authorWebpage:'https://sites.google.com/view/language-rally',
    isPurchased:  true,
    jsonFilePath: r'JSON_to_import\EN_RU_B1_City_vs_countryside.json',
  ),
  PackageDef(
    groupName:    'EN-RU B1',
    iconIndex:    1,
    packageName:  'B1 Communication & language learning',
    langCode1:    'en-UK',
    langCode2:    'ru-RU',
    description:  'Vocabulary for Communication & language learning at B1 level.',
    authorName:   'Language Rally Team',
    authorEmail:  'languagerally.support@gmail.com',
    version:      '1.0',
    authorWebpage:'https://sites.google.com/view/language-rally',
    isPurchased:  true,
    jsonFilePath: r'JSON_to_import\EN_RU_B1_Basic_politics_society.json',
  ),
  PackageDef(
    groupName:    'EN-RU B1',
    iconIndex:    9,
    packageName:  'B1 Culture & traditions',
    langCode1:    'en-UK',
    langCode2:    'ru-RU',
    description:  'Vocabulary for Culture & traditions at B1 level.',
    authorName:   'Language Rally Team',
    authorEmail:  'languagerally.support@gmail.com',
    version:      '1.0',
    authorWebpage:'https://sites.google.com/view/language-rally',
    isPurchased:  true,
    jsonFilePath: r'JSON_to_import\EN_RU_B1_Culture_traditions.json',
  ),
  PackageDef(
    groupName:    'EN-RU B1',
    iconIndex:    6,
    packageName:  'B1 Education systems',
    langCode1:    'en-UK',
    langCode2:    'ru-RU',
    description:  'Vocabulary for Education systems at B1 level.',
    authorName:   'Language Rally Team',
    authorEmail:  'languagerally.support@gmail.com',
    version:      '1.0',
    authorWebpage:'https://sites.google.com/view/language-rally',
    isPurchased:  true,
    jsonFilePath: r'JSON_to_import\EN_RU_B2_Travel_globalization.json',
  ),
  PackageDef(
    groupName:    'EN-RU B1',
    iconIndex:    9,
    packageName:  'B1 Entertainment & arts',
    langCode1:    'en-UK',
    langCode2:    'ru-RU',
    description:  'Vocabulary for Entertainment & arts at B1 level.',
    authorName:   'Language Rally Team',
    authorEmail:  'languagerally.support@gmail.com',
    version:      '1.0',
    authorWebpage:'https://sites.google.com/view/language-rally',
    isPurchased:  true,
    jsonFilePath: r'JSON_to_import\EN_RU_B2_Urbanization_housing.json',
  ),
  PackageDef(
    groupName:    'EN-RU B1',
    iconIndex:    11,
    packageName:  'B1 Environment & nature',
    langCode1:    'en-UK',
    langCode2:    'ru-RU',
    description:  'Vocabulary for Environment & nature at B1 level.',
    authorName:   'Language Rally Team',
    authorEmail:  'languagerally.support@gmail.com',
    version:      '1.0',
    authorWebpage:'https://sites.google.com/view/language-rally',
    isPurchased:  true,
    jsonFilePath: r'JSON_to_import\EN_RU_B1_Travel_experiences_problems.json',
  ),
  PackageDef(
    groupName:    'EN-RU B1',
    iconIndex:    7,
    packageName:  'B1 Fitness & diet',
    langCode1:    'en-UK',
    langCode2:    'ru-RU',
    description:  'Vocabulary for Fitness & diet at B1 level.',
    authorName:   'Language Rally Team',
    authorEmail:  'languagerally.support@gmail.com',
    version:      '1.0',
    authorWebpage:'https://sites.google.com/view/language-rally',
    isPurchased:  true,
    jsonFilePath: r'JSON_to_import\EN_RU_B1_Education_systems.json',
  ),
  PackageDef(
    groupName:    'EN-RU B1',
    iconIndex:    4,
    packageName:  'B1 Food culture & cooking',
    langCode1:    'en-UK',
    langCode2:    'ru-RU',
    description:  'Vocabulary for Food culture & cooking at B1 level.',
    authorName:   'Language Rally Team',
    authorEmail:  'languagerally.support@gmail.com',
    version:      '1.0',
    authorWebpage:'https://sites.google.com/view/language-rally',
    isPurchased:  true,
    jsonFilePath: r'JSON_to_import\EN_RU_B1_Entertainment_arts.json',
  ),
  PackageDef(
    groupName:    'EN-RU B1',
    iconIndex:    7,
    packageName:  'B1 Grammar focus: phrasal verbs, first & second conditional, past tenses',
    langCode1:    'en-UK',
    langCode2:    'ru-RU',
    description:  'Vocabulary for Grammar focus: phrasal verbs, first & second conditional, past tenses at B1 level.',
    authorName:   'Language Rally Team',
    authorEmail:  'languagerally.support@gmail.com',
    version:      '1.0',
    authorWebpage:'https://sites.google.com/view/language-rally',
    isPurchased:  true,
    jsonFilePath: r'JSON_to_import\EN_RU_B1_Environment_nature.json',
  ),
  PackageDef(
    groupName:    'EN-RU B1',
    iconIndex:    5,
    packageName:  'B1 Health & lifestyle',
    langCode1:    'en-UK',
    langCode2:    'ru-RU',
    description:  'Vocabulary for Health & lifestyle at B1 level.',
    authorName:   'Language Rally Team',
    authorEmail:  'languagerally.support@gmail.com',
    version:      '1.0',
    authorWebpage:'https://sites.google.com/view/language-rally',
    isPurchased:  true,
    jsonFilePath: r'JSON_to_import\EN_RU_B1_Fitness_diet.json',
  ),
  PackageDef(
    groupName:    'EN-RU B1',
    iconIndex:    4,
    packageName:  'B1 Media (TV, news, social media)',
    langCode1:    'en-UK',
    langCode2:    'ru-RU',
    description:  'Vocabulary for Media (TV, news, social media) at B1 level.',
    authorName:   'Language Rally Team',
    authorEmail:  'languagerally.support@gmail.com',
    version:      '1.0',
    authorWebpage:'https://sites.google.com/view/language-rally',
    isPurchased:  true,
    jsonFilePath: r'JSON_to_import\EN_RU_B1_Food_culture_cooking.json',
  ),
  PackageDef(
    groupName:    'EN-RU B1',
    iconIndex:    9,
    packageName:  'B1 Money & personal finance',
    langCode1:    'en-UK',
    langCode2:    'ru-RU',
    description:  'Vocabulary for Money & personal finance at B1 level.',
    authorName:   'Language Rally Team',
    authorEmail:  'languagerally.support@gmail.com',
    version:      '1.0',
    authorWebpage:'https://sites.google.com/view/language-rally',
    isPurchased:  true,
    jsonFilePath: r'JSON_to_import\EN_RU_B1_Grammar_focus_phrasal_verbs_first_second_conditional_past_tenses.json',
  ),
  PackageDef(
    groupName:    'EN-RU B1',
    iconIndex:    6,
    packageName:  'B1 Problem-solving (lost items, complaints)',
    langCode1:    'en-UK',
    langCode2:    'ru-RU',
    description:  'Vocabulary for Problem-solving (lost items, complaints) at B1 level.',
    authorName:   'Language Rally Team',
    authorEmail:  'languagerally.support@gmail.com',
    version:      '1.0',
    authorWebpage:'https://sites.google.com/view/language-rally',
    isPurchased:  true,
    jsonFilePath: r'JSON_to_import\EN_RU_B1_Health_lifestyle.json',
  ),
  PackageDef(
    groupName:    'EN-RU B1',
    iconIndex:    10,
    packageName:  'B1 Relationships & emotions',
    langCode1:    'en-UK',
    langCode2:    'ru-RU',
    description:  'Vocabulary for Relationships & emotions at B1 level.',
    authorName:   'Language Rally Team',
    authorEmail:  'languagerally.support@gmail.com',
    version:      '1.0',
    authorWebpage:'https://sites.google.com/view/language-rally',
    isPurchased:  true,
    jsonFilePath: r'JSON_to_import\EN_RU_B1_Media_TV_news_social_media.json',
  ),
  PackageDef(
    groupName:    'EN-RU B1',
    iconIndex:    6,
    packageName:  'B1 Shopping & consumer habits',
    langCode1:    'en-UK',
    langCode2:    'ru-RU',
    description:  'Vocabulary for Shopping & consumer habits at B1 level.',
    authorName:   'Language Rally Team',
    authorEmail:  'languagerally.support@gmail.com',
    version:      '1.0',
    authorWebpage:'https://sites.google.com/view/language-rally',
    isPurchased:  true,
    jsonFilePath: r'JSON_to_import\EN_RU_B1_Money_personal_finance.json',
  ),
  PackageDef(
    groupName:    'EN-RU B1',
    iconIndex:    10,
    packageName:  'B1 Sports & competitions',
    langCode1:    'en-UK',
    langCode2:    'ru-RU',
    description:  'Vocabulary for Sports & competitions at B1 level.',
    authorName:   'Language Rally Team',
    authorEmail:  'languagerally.support@gmail.com',
    version:      '1.0',
    authorWebpage:'https://sites.google.com/view/language-rally',
    isPurchased:  true,
    jsonFilePath: r'JSON_to_import\EN_RU_B1_Problem_solving_lost_items_complaints.json',
  ),
  PackageDef(
    groupName:    'EN-RU B1',
    iconIndex:    6,
    packageName:  'B1 Technology & mobile apps',
    langCode1:    'en-UK',
    langCode2:    'ru-RU',
    description:  'Vocabulary for Technology & mobile apps at B1 level.',
    authorName:   'Language Rally Team',
    authorEmail:  'languagerally.support@gmail.com',
    version:      '1.0',
    authorWebpage:'https://sites.google.com/view/language-rally',
    isPurchased:  true,
    jsonFilePath: r'JSON_to_import\EN_RU_B1_Relationships_emotions.json',
  ),
  PackageDef(
    groupName:    'EN-RU B1',
    iconIndex:    2,
    packageName:  'B1 Travel experiences & problems',
    langCode1:    'en-UK',
    langCode2:    'ru-RU',
    description:  'Vocabulary for Travel experiences & problems at B1 level.',
    authorName:   'Language Rally Team',
    authorEmail:  'languagerally.support@gmail.com',
    version:      '1.0',
    authorWebpage:'https://sites.google.com/view/language-rally',
    isPurchased:  true,
    jsonFilePath: r'JSON_to_import\EN_RU_B1_Shopping_consumer_habits.json',
  ),
  PackageDef(
    groupName:    'EN-RU B1',
    iconIndex:    8,
    packageName:  'B1 Work & career',
    langCode1:    'en-UK',
    langCode2:    'ru-RU',
    description:  'Vocabulary for Work & career at B1 level.',
    authorName:   'Language Rally Team',
    authorEmail:  'languagerally.support@gmail.com',
    version:      '1.0',
    authorWebpage:'https://sites.google.com/view/language-rally',
    isPurchased:  true,
    jsonFilePath: r'JSON_to_import\EN_RU_B1_Sports_competitions.json',
  ),
  PackageDef(
    groupName:    'EN-RU B2',
    iconIndex:    4,
    packageName:  'B2 Business basics',
    langCode1:    'en-UK',
    langCode2:    'ru-RU',
    description:  'Vocabulary for Business basics at B2 level.',
    authorName:   'Language Rally Team',
    authorEmail:  'languagerally.support@gmail.com',
    version:      '1.0',
    authorWebpage:'https://sites.google.com/view/language-rally',
    isPurchased:  true,
    jsonFilePath: r'JSON_to_import\EN_RU_B1_Technology_mobile_apps.json',
  ),
  PackageDef(
    groupName:    'EN-RU B2',
    iconIndex:    4,
    packageName:  'B2 Career development',
    langCode1:    'en-UK',
    langCode2:    'ru-RU',
    description:  'Vocabulary for Career development at B2 level.',
    authorName:   'Language Rally Team',
    authorEmail:  'languagerally.support@gmail.com',
    version:      '1.0',
    authorWebpage:'https://sites.google.com/view/language-rally',
    isPurchased:  true,
    jsonFilePath: r'JSON_to_import\EN_RU_B2_Work_life_balance.json',
  ),
  PackageDef(
    groupName:    'EN-RU B2',
    iconIndex:    10,
    packageName:  'B2 Crime & law (basic)',
    langCode1:    'en-UK',
    langCode2:    'ru-RU',
    description:  'Vocabulary for Crime & law (basic) at B2 level.',
    authorName:   'Language Rally Team',
    authorEmail:  'languagerally.support@gmail.com',
    version:      '1.0',
    authorWebpage:'https://sites.google.com/view/language-rally',
    isPurchased:  true,
    jsonFilePath: r'JSON_to_import\EN_RU_B1_Work_career.json',
  ),
  PackageDef(
    groupName:    'EN-RU B2',
    iconIndex:    8,
    packageName:  'B2 Culture & identity',
    langCode1:    'en-UK',
    langCode2:    'ru-RU',
    description:  'Vocabulary for Culture & identity at B2 level.',
    authorName:   'Language Rally Team',
    authorEmail:  'languagerally.support@gmail.com',
    version:      '1.0',
    authorWebpage:'https://sites.google.com/view/language-rally',
    isPurchased:  true,
    jsonFilePath: r'JSON_to_import\EN_RU_B2_Business_basics.json',
  ),
  PackageDef(
    groupName:    'EN-RU B2',
    iconIndex:    10,
    packageName:  'B2 Debate & argumentation',
    langCode1:    'en-UK',
    langCode2:    'ru-RU',
    description:  'Vocabulary for Debate & argumentation at B2 level.',
    authorName:   'Language Rally Team',
    authorEmail:  'languagerally.support@gmail.com',
    version:      '1.0',
    authorWebpage:'https://sites.google.com/view/language-rally',
    isPurchased:  true,
    jsonFilePath: r'JSON_to_import\EN_RU_B2_Career_development.json',
  ),
  PackageDef(
    groupName:    'EN-RU B2',
    iconIndex:    9,
    packageName:  'B2 Economics (basic concepts)',
    langCode1:    'en-UK',
    langCode2:    'ru-RU',
    description:  'Vocabulary for Economics (basic concepts) at B2 level.',
    authorName:   'Language Rally Team',
    authorEmail:  'languagerally.support@gmail.com',
    version:      '1.0',
    authorWebpage:'https://sites.google.com/view/language-rally',
    isPurchased:  true,
    jsonFilePath: r'JSON_to_import\EN_RU_B2_Crime_law_basic.json',
  ),
  PackageDef(
    groupName:    'EN-RU B2',
    iconIndex:    3,
    packageName:  'B2 Education & systems',
    langCode1:    'en-UK',
    langCode2:    'ru-RU',
    description:  'Vocabulary for Education & systems at B2 level.',
    authorName:   'Language Rally Team',
    authorEmail:  'languagerally.support@gmail.com',
    version:      '1.0',
    authorWebpage:'https://sites.google.com/view/language-rally',
    isPurchased:  true,
    jsonFilePath: r'JSON_to_import\EN_RU_B2_Culture_identity.json',
  ),
  PackageDef(
    groupName:    'EN-RU B2',
    iconIndex:    5,
    packageName:  'B2 Environment & sustainability',
    langCode1:    'en-UK',
    langCode2:    'ru-RU',
    description:  'Vocabulary for Environment & sustainability at B2 level.',
    authorName:   'Language Rally Team',
    authorEmail:  'languagerally.support@gmail.com',
    version:      '1.0',
    authorWebpage:'https://sites.google.com/view/language-rally',
    isPurchased:  true,
    jsonFilePath: r'JSON_to_import\EN_RU_B2_Debate_argumentation.json',
  ),
  PackageDef(
    groupName:    'EN-RU B2',
    iconIndex:    11,
    packageName:  'B2 Ethics & moral dilemmas',
    langCode1:    'en-UK',
    langCode2:    'ru-RU',
    description:  'Vocabulary for Ethics & moral dilemmas at B2 level.',
    authorName:   'Language Rally Team',
    authorEmail:  'languagerally.support@gmail.com',
    version:      '1.0',
    authorWebpage:'https://sites.google.com/view/language-rally',
    isPurchased:  true,
    jsonFilePath: r'JSON_to_import\EN_RU_B2_Economics_basic_concepts.json',
  ),
  PackageDef(
    groupName:    'EN-RU B2',
    iconIndex:    4,
    packageName:  'B2 Globalization',
    langCode1:    'en-UK',
    langCode2:    'ru-RU',
    description:  'Vocabulary for Globalization at B2 level.',
    authorName:   'Language Rally Team',
    authorEmail:  'languagerally.support@gmail.com',
    version:      '1.0',
    authorWebpage:'https://sites.google.com/view/language-rally',
    isPurchased:  true,
    jsonFilePath: r'JSON_to_import\EN_RU_B2_Education_systems.json',
  ),
  PackageDef(
    groupName:    'EN-RU B2',
    iconIndex:    1,
    packageName:  'B2 Grammar focus: second & third conditional, passive voice, reported speech',
    langCode1:    'en-UK',
    langCode2:    'ru-RU',
    description:  'Vocabulary for Grammar focus: second & third conditional, passive voice, reported speech at B2 level.',
    authorName:   'Language Rally Team',
    authorEmail:  'languagerally.support@gmail.com',
    version:      '1.0',
    authorWebpage:'https://sites.google.com/view/language-rally',
    isPurchased:  true,
    jsonFilePath: r'JSON_to_import\EN_RU_B2_Environment_sustainability.json',
  ),
  PackageDef(
    groupName:    'EN-RU B2',
    iconIndex:    10,
    packageName:  'B2 Health systems & medicine',
    langCode1:    'en-UK',
    langCode2:    'ru-RU',
    description:  'Vocabulary for Health systems & medicine at B2 level.',
    authorName:   'Language Rally Team',
    authorEmail:  'languagerally.support@gmail.com',
    version:      '1.0',
    authorWebpage:'https://sites.google.com/view/language-rally',
    isPurchased:  true,
    jsonFilePath: r'JSON_to_import\EN_RU_B2_Ethics_moral_dilemmas.json',
  ),
  PackageDef(
    groupName:    'EN-RU B2',
    iconIndex:    4,
    packageName:  'B2 News & media analysis',
    langCode1:    'en-UK',
    langCode2:    'ru-RU',
    description:  'Vocabulary for News & media analysis at B2 level.',
    authorName:   'Language Rally Team',
    authorEmail:  'languagerally.support@gmail.com',
    version:      '1.0',
    authorWebpage:'https://sites.google.com/view/language-rally',
    isPurchased:  true,
    jsonFilePath: r'JSON_to_import\EN_RU_B2_Globalization.json',
  ),
  PackageDef(
    groupName:    'EN-RU B2',
    iconIndex:    4,
    packageName:  'B2 Science & innovation',
    langCode1:    'en-UK',
    langCode2:    'ru-RU',
    description:  'Vocabulary for Science & innovation at B2 level.',
    authorName:   'Language Rally Team',
    authorEmail:  'languagerally.support@gmail.com',
    version:      '1.0',
    authorWebpage:'https://sites.google.com/view/language-rally',
    isPurchased:  true,
    jsonFilePath: r'JSON_to_import\EN_RU_B2_Grammar_focus_second_third_conditional_passive_voice_reported_speech.json',
  ),
  PackageDef(
    groupName:    'EN-RU B2',
    iconIndex:    9,
    packageName:  'B2 Social media influence',
    langCode1:    'en-UK',
    langCode2:    'ru-RU',
    description:  'Vocabulary for Social media influence at B2 level.',
    authorName:   'Language Rally Team',
    authorEmail:  'languagerally.support@gmail.com',
    version:      '1.0',
    authorWebpage:'https://sites.google.com/view/language-rally',
    isPurchased:  true,
    jsonFilePath: r'JSON_to_import\EN_RU_B2_Health_systems_medicine.json',
  ),
  PackageDef(
    groupName:    'EN-RU B2',
    iconIndex:    7,
    packageName:  'B2 Society & social issues',
    langCode1:    'en-UK',
    langCode2:    'ru-RU',
    description:  'Vocabulary for Society & social issues at B2 level.',
    authorName:   'Language Rally Team',
    authorEmail:  'languagerally.support@gmail.com',
    version:      '1.0',
    authorWebpage:'https://sites.google.com/view/language-rally',
    isPurchased:  true,
    jsonFilePath: r'JSON_to_import\EN_RU_B2_News_media_analysis.json',
  ),
  PackageDef(
    groupName:    'EN-RU B2',
    iconIndex:    6,
    packageName:  'B2 Technology impact',
    langCode1:    'en-UK',
    langCode2:    'ru-RU',
    description:  'Vocabulary for Technology impact at B2 level.',
    authorName:   'Language Rally Team',
    authorEmail:  'languagerally.support@gmail.com',
    version:      '1.0',
    authorWebpage:'https://sites.google.com/view/language-rally',
    isPurchased:  true,
    jsonFilePath: r'JSON_to_import\EN_RU_B2_Science_innovation.json',
  ),
  PackageDef(
    groupName:    'EN-RU B2',
    iconIndex:    11,
    packageName:  'B2 Travel & globalization',
    langCode1:    'en-UK',
    langCode2:    'ru-RU',
    description:  'Vocabulary for Travel & globalization at B2 level.',
    authorName:   'Language Rally Team',
    authorEmail:  'languagerally.support@gmail.com',
    version:      '1.0',
    authorWebpage:'https://sites.google.com/view/language-rally',
    isPurchased:  true,
    jsonFilePath: r'JSON_to_import\EN_RU_B2_Social_media_influence.json',
  ),
  PackageDef(
    groupName:    'EN-RU B2',
    iconIndex:    8,
    packageName:  'B2 Urbanization & housing',
    langCode1:    'en-UK',
    langCode2:    'ru-RU',
    description:  'Vocabulary for Urbanization & housing at B2 level.',
    authorName:   'Language Rally Team',
    authorEmail:  'languagerally.support@gmail.com',
    version:      '1.0',
    authorWebpage:'https://sites.google.com/view/language-rally',
    isPurchased:  true,
    jsonFilePath: r'JSON_to_import\EN_RU_B2_Society_social_issues.json',
  ),
  PackageDef(
    groupName:    'EN-RU B2',
    iconIndex:    5,
    packageName:  'B2 Work-life balance',
    langCode1:    'en-UK',
    langCode2:    'ru-RU',
    description:  'Vocabulary for Work-life balance at B2 level.',
    authorName:   'Language Rally Team',
    authorEmail:  'languagerally.support@gmail.com',
    version:      '1.0',
    authorWebpage:'https://sites.google.com/view/language-rally',
    isPurchased:  true,
    jsonFilePath: r'JSON_to_import\EN_RU_B2_Technology_impact.json',
  )



];

// ═══════════════════════════════════════════════════════════════════════════════
// ▲▲▲  END OF EDIT ZONE  ▲▲▲
// ═══════════════════════════════════════════════════════════════════════════════

// ── internal status model ────────────────────────────────────────────────────

enum _ImportStatus { idle, running, done, error }

class _PackageResult {
  final _ImportStatus status;
  final String message;
  _PackageResult(this.status, this.message);
}

// ── page ─────────────────────────────────────────────────────────────────────

class BulkPackageImportPage extends StatefulWidget {
  const BulkPackageImportPage({super.key});

  @override
  State<BulkPackageImportPage> createState() => _BulkPackageImportPageState();
}

class _BulkPackageImportPageState extends State<BulkPackageImportPage> {
  final _packageRepo = LanguagePackageRepository();
  final _groupRepo   = LanguagePackageGroupRepository();
  final _categoryRepo = CategoryRepository();
  final _itemRepo    = ItemRepository();
  final _logController = ScrollController();
  final _logBuffer = StringBuffer();

  List<_PackageResult> _results = List.generate(
    _packageDefinitions.length,
    (_) => _PackageResult(_ImportStatus.idle, ''),
  );
  bool _isRunning = false;
  /// When true, any existing package with the same name is deleted first so
  /// that it can be re-imported fresh (useful after a category fix).
  bool _forceReimport = false;

  @override
  void dispose() {
    _logController.dispose();
    super.dispose();
  }

  // ── helpers ────────────────────────────────────────────────────────────────

  void _appendLog(String text) {
    logDebug(text);
    setState(() => _logBuffer.writeln(text));
    // Auto-scroll to bottom
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_logController.hasClients) {
        _logController.animateTo(
          _logController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 120),
          curve: Curves.easeOut,
        );
      }
    });
  }

  void _setResult(int index, _ImportStatus status, String message) {
    setState(() {
      _results[index] = _PackageResult(status, message);
    });
  }

  /// Resolve a file path: absolute paths are used as-is; relative paths are
  /// joined to the app's Documents directory.
  Future<String> _resolvePath(String filePath) async {
    if (File(filePath).isAbsolute) return filePath;
    final docsDir = await getApplicationDocumentsDirectory();
    return '${docsDir.path}${Platform.pathSeparator}$filePath';
  }

  /// Export [packageId] as a ZIP into the Documents/exported_package_ZIPs
  /// folder. The [forceExport] flag bypasses the purchased-package guard so
  /// that freshly created purchased packages can be exported immediately.
  /// Returns the full path of the written ZIP file, or null on failure.
  Future<String?> _exportToZip(String packageId) async {
    try {
      final docsDir = await getApplicationDocumentsDirectory();
      final exportDir = Directory(
        '${docsDir.path}${Platform.pathSeparator}exported_package_ZIPs',
      );
      if (!await exportDir.exists()) {
        await exportDir.create(recursive: true);
        _appendLog('    ├ Created output folder: ${exportDir.path}');
      }

      final repo = ImportExportRepository(
        packageRepo:  _packageRepo,
        groupRepo:    _groupRepo,
        categoryRepo: _categoryRepo,
        itemRepo:     _itemRepo,
      );

      final zipPath = await repo.exportPackageToZip(
        packageId,
        exportDir.path,
        forceExport: true,
      );
      return zipPath;
    } catch (e) {
      _appendLog('    ⚠  ZIP export failed: $e');
      return null;
    }
  }

  // ── core import ────────────────────────────────────────────────────────────

  Future<void> _runAll() async {
    if (_isRunning) return;
    if (_packageDefinitions.isEmpty) {
      _appendLog('⚠️  No package definitions found.\n'
          'Add entries to _packageDefinitions in bulk_package_import_page.dart.');
      return;
    }

    setState(() {
      _isRunning = true;
      _logBuffer.clear();
      _results = List.generate(
        _packageDefinitions.length,
        (_) => _PackageResult(_ImportStatus.idle, ''),
      );
    });

    _appendLog('🚀 Starting bulk import of '
        '${_packageDefinitions.length} package(s)…\n');

    int doneCount = 0;
    int errorCount = 0;

    for (int i = 0; i < _packageDefinitions.length; i++) {
      final def = _packageDefinitions[i];
      _appendLog('[${i + 1}/${_packageDefinitions.length}] '
          '"${def.packageName}"  (${def.langCode1} → ${def.langCode2})');
      _setResult(i, _ImportStatus.running, 'running…');

      try {
        final summary = await _importOne(def);
        _appendLog('  ✅ $summary');
        _setResult(i, _ImportStatus.done, summary);
        doneCount++;
      } catch (e) {
        final msg = e.toString();
        _appendLog('  ❌ $msg');
        _setResult(i, _ImportStatus.error, msg);
        errorCount++;
      }
    }

    _appendLog(
      '\n──────────────────────────────────────────\n'
      '✔ Done: $doneCount   ✘ Errors: $errorCount\n',
    );
    setState(() => _isRunning = false);
  }

  Future<String> _importOne(PackageDef def) async {
    // 1. Find or create the group ──────────────────────────────────────────
    var group = await _groupRepo.getGroupByName(def.groupName);
    if (group == null) {
      group = LanguagePackageGroup(
        id: const Uuid().v4(),
        name: def.groupName,
      );
      await _groupRepo.insertGroup(group);
      _appendLog('    ├ Created group "${def.groupName}"');
    } else {
      _appendLog('    ├ Using existing group "${def.groupName}"');
    }

    // 2. Guard against duplicates ─────────────────────────────────────────
    final allPackages = await _packageRepo.getAllPackages();
    final existing = allPackages.where(
      (p) =>
          p.groupId == group!.id &&
          (p.packageName?.toLowerCase() ==
              def.packageName.toLowerCase()),
    );
    if (existing.isNotEmpty) {
      if (_forceReimport) {
        // Delete the existing package (and its categories/items via cascade)
        for (final p in existing) {
          await _packageRepo.deletePackage(p.id);
        }
        _appendLog('    ├ ⚠  Deleted existing package (force re-import)');
      } else {
        throw Exception(
          'Package "${def.packageName}" already exists in '
          'group "${def.groupName}" — skipped. '
          'Enable "Force re-import" to delete and re-import.',
        );
      }
    }

    // 3. Resolve language names ────────────────────────────────────────────
    final lang1Name =
        LanguageCodes.getLanguageName(def.langCode1) ?? def.langCode1;
    final lang2Name =
        LanguageCodes.getLanguageName(def.langCode2) ?? def.langCode2;

    // 4. Resolve icon path ────────────────────────────────────────────────
    final iconPath =
        (def.iconIndex >= 0 && def.iconIndex < _kIconPaths.length)
            ? _kIconPaths[def.iconIndex]
            : null;

    // 5. Create the package ───────────────────────────────────────────────
    final packageId = const Uuid().v4();
    final package = LanguagePackage(
      id: packageId,
      groupId: group.id,
      packageName: def.packageName,
      languageCode1: def.langCode1,
      languageName1: lang1Name,
      languageCode2: def.langCode2,
      languageName2: lang2Name,
      description: def.description.isNotEmpty ? def.description : null,
      icon: iconPath,
      authorName: def.authorName.isNotEmpty ? def.authorName : null,
      authorEmail: def.authorEmail.isNotEmpty ? def.authorEmail : null,
      authorWebpage: def.authorWebpage.isNotEmpty ? def.authorWebpage : null,
      version: def.version,
      packageType:
          def.isPurchased ? PackageType.purchased : PackageType.userCreated,
      isPurchased: def.isPurchased,
      purchasedAt: def.isPurchased ? DateTime.now() : null,
      createdAt: DateTime.now(),
    );
    await _packageRepo.insertPackage(package);
    _appendLog('    ├ Package created (id: $packageId)');

    // 6. Resolve & read the JSON file ─────────────────────────────────────
    final resolvedPath = await _resolvePath(def.jsonFilePath);
    final jsonFile = File(resolvedPath);
    if (!await jsonFile.exists()) {
      throw Exception('JSON file not found:\n    $resolvedPath');
    }

    final rawJson = jsonDecode(await jsonFile.readAsString());
    final List<Map<String, dynamic>> itemList;
    if (rawJson is List) {
      itemList = rawJson.cast<Map<String, dynamic>>();
    } else if (rawJson is Map<String, dynamic> && rawJson['items'] is List) {
      itemList = (rawJson['items'] as List).cast<Map<String, dynamic>>();
    } else {
      throw Exception(
        'Unsupported JSON format. Expected a top-level array '
        'or an object with an "items" array.',
      );
    }
    _appendLog('    ├ Read ${itemList.length} item(s) from JSON');

    // 7. Import items ─────────────────────────────────────────────────────
    final result = await _importItems(
      packageId: packageId,
      langCode1: def.langCode1,
      langCode2: def.langCode2,
      items: itemList,
    );
    _appendLog('    ├ ${result.imported} / ${itemList.length} items imported'
        '  •  ${result.categories} unique categor${result.categories == 1 ? "y" : "ies"} created');

    // 8. Auto-export to ZIP (bypasses the purchased-package guard) ────────
    final zipPath = await _exportToZip(packageId);
    if (zipPath != null) {
      final zipName = zipPath.split(Platform.pathSeparator).last;
      _appendLog('    └ Exported → $zipName');
    } else {
      _appendLog('    └ ⚠  ZIP export skipped (see warning above)');
    }

    return '${result.imported} / ${itemList.length} items · ${result.categories} categories'
        '${zipPath != null ? " · ZIP saved" : " · export failed"}';
  }

  /// Mirrors the logic of _processJsonImportItems in package_form_page.dart.
  Future<({int imported, int categories})> _importItems({
    required String packageId,
    required String langCode1,
    required String langCode2,
    required List<Map<String, dynamic>> items,
  }) async {
    // Build category cache
    final existingCats =
        await _categoryRepo.getCategoriesForPackage(packageId);
    final categoryMap = <String, Category>{
      for (final c in existingCats) c.name.toLowerCase(): c,
    };

    // Build duplicate-key cache
    final categoryIds = existingCats.map((c) => c.id).toList();
    final existingKeys = <String>{};
    if (categoryIds.isNotEmpty) {
      final existingItems =
          await _itemRepo.getItemsForCategories(categoryIds);
      for (final it in existingItems) {
        existingKeys.add(
          '${it.language1Data.text.toLowerCase()}'
          '|${it.language2Data.text.toLowerCase()}',
        );
      }
    }

    int importedCount = 0;

    for (int idx = 0; idx < items.length; idx++) {
      final j = items[idx];
      try {
        final sourceExpr = j['source_expression'] as String?;
        if (sourceExpr == null || sourceExpr.trim().isEmpty) continue;

        final sourcePre   = (j['source_pre']   as String?)?.trim();
        final sourcePost  = (j['source_post']  as String?)?.trim();
        final targetExpr  = ((j['target_expression'] as String?)?.trim()) ?? '';
        final targetPre   = (j['target_pre']   as String?)?.trim();
        final targetPost  = (j['target_post']  as String?)?.trim();

        // Duplicate check
        final key = '${sourceExpr.trim().toLowerCase()}|${targetExpr.toLowerCase()}';
        if (existingKeys.contains(key)) continue;

        // Examples
        final examplesJson = j['examples'] as List<dynamic>?;
        final examples = <ExampleSentence>[
          if (examplesJson != null)
            for (final e in examplesJson)
              if (e is Map<String, dynamic>)
                ExampleSentence(
                  id: const Uuid().v4(),
                  textLanguage1: (e['source'] as String?) ?? '',
                  textLanguage2: (e['target'] as String?) ?? '',
                ),
        ];

        // Categories
        final catNames = <String>[];
        final catsJson = j['categories'] as List<dynamic>?;
        if (catsJson != null) {
          for (final c in catsJson) {
            if (c is String && c.trim().isNotEmpty) {
              catNames.add(c.trim());
            } else if (c is Map<String, dynamic>) {
              // Handle {"category_name": "..."} or {"name": "..."} object format
              final name = (c['category_name'] as String?)?.trim() ??
                           (c['name'] as String?)?.trim();
              if (name != null && name.isNotEmpty) catNames.add(name);
            }
          }
        }
        if (catNames.isEmpty) catNames.add('Imported');

        // Resolve / create categories
        final catIds = <String>[];
        for (final name in catNames) {
          final lk = name.toLowerCase();
          if (!categoryMap.containsKey(lk)) {
            final newCat = Category(
              id: const Uuid().v4(),
              packageId: packageId,
              name: name,
              description: null,
            );
            await _categoryRepo.insertCategory(newCat);
            categoryMap[lk] = newCat;
          }
          catIds.add(categoryMap[lk]!.id);
        }

        // Create item
        final item = Item(
          id: const Uuid().v4(),
          packageId: packageId,
          categoryIds: catIds,
          language1Data: ItemLanguageData(
            languageCode: langCode1,
            text: sourceExpr.trim(),
            preItem: (sourcePre?.isNotEmpty == true) ? sourcePre : null,
            postItem: (sourcePost?.isNotEmpty == true) ? sourcePost : null,
          ),
          language2Data: ItemLanguageData(
            languageCode: langCode2,
            text: targetExpr,
            preItem: (targetPre?.isNotEmpty == true) ? targetPre : null,
            postItem: (targetPost?.isNotEmpty == true) ? targetPost : null,
          ),
          examples: examples,
          isKnown: false,
          isFavourite: false,
          isImportant: false,
          dontKnowCounter: 1,
          lastReviewedAt: null,
        );
        await _itemRepo.insertItem(item);
        existingKeys.add(key);
        importedCount++;
      } catch (e) {
        _appendLog('    ⚠  Item ${idx + 1} failed: $e');
      }
    }
    return (imported: importedCount, categories: categoryMap.length);
  }

  // ── UI ─────────────────────────────────────────────────────────────────────

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final cs    = theme.colorScheme;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Bulk Package Import  ⚙️'),
        backgroundColor: cs.errorContainer,
        foregroundColor: cs.onErrorContainer,
      ),
      body: Column(
        children: [
          // ── top banner ──────────────────────────────────────────────────
          Container(
            color: cs.errorContainer.withValues(alpha: 0.35),
            padding: const EdgeInsets.symmetric(
              horizontal: AppTheme.spacing16,
              vertical: AppTheme.spacing8,
            ),
            child: Row(
              children: [
                Icon(Icons.warning_amber_rounded, color: cs.error, size: 18),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    'Admin tool — visible only when PRINT_DEBUG = true. '
                    'Fill in _packageDefinitions in the source file before running.',
                    style: theme.textTheme.bodySmall
                        ?.copyWith(color: cs.onErrorContainer),
                  ),
                ),
                const SizedBox(width: 8),
                // Force re-import toggle
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Switch(
                      value: _forceReimport,
                      onChanged: _isRunning
                          ? null
                          : (v) => setState(() => _forceReimport = v),
                      materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                    ),
                    const SizedBox(width: 4),
                    Text(
                      'Force re-import',
                      style: theme.textTheme.labelSmall
                          ?.copyWith(color: cs.onErrorContainer),
                    ),
                  ],
                ),
                const SizedBox(width: 12),
                FilledButton.icon(
                  onPressed: _isRunning ? null : _runAll,
                  icon: _isRunning
                      ? SizedBox(
                          width: 16,
                          height: 16,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            color: cs.onPrimary,
                          ),
                        )
                      : const Icon(Icons.play_arrow),
                  label: Text(_isRunning ? 'Running…' : '▶  Run All'),
                  style: FilledButton.styleFrom(
                    backgroundColor: cs.primary,
                    foregroundColor: cs.onPrimary,
                  ),
                ),
              ],
            ),
          ),

          // ── package list ─────────────────────────────────────────────────
          Expanded(
            flex: 2,
            child: _packageDefinitions.isEmpty
                ? Center(
                    child: Padding(
                      padding: const EdgeInsets.all(AppTheme.spacing16),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(Icons.inbox_outlined,
                              size: 48, color: cs.onSurfaceVariant),
                          const SizedBox(height: 12),
                          Text(
                            'No package definitions yet.\n'
                            'Add PackageDef entries to _packageDefinitions\n'
                            'in bulk_package_import_page.dart.',
                            textAlign: TextAlign.center,
                            style: theme.textTheme.bodyMedium
                                ?.copyWith(color: cs.onSurfaceVariant),
                          ),
                        ],
                      ),
                    ),
                  )
                : ListView.separated(
                    padding: const EdgeInsets.symmetric(
                      horizontal: AppTheme.spacing8,
                      vertical: AppTheme.spacing4,
                    ),
                    itemCount: _packageDefinitions.length,
                    separatorBuilder: (_, _) => const Divider(height: 1),
                    itemBuilder: (context, i) =>
                        _buildPackageRow(context, i, theme, cs),
                  ),
          ),

          const Divider(height: 1),

          // ── log output ───────────────────────────────────────────────────
          Expanded(
            flex: 3,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Padding(
                  padding: const EdgeInsets.fromLTRB(12, 6, 12, 2),
                  child: Row(
                    children: [
                      Icon(Icons.terminal, size: 14,
                          color: cs.onSurfaceVariant),
                      const SizedBox(width: 6),
                      Text(
                        'Log output',
                        style: theme.textTheme.labelSmall
                            ?.copyWith(color: cs.onSurfaceVariant),
                      ),
                      const Spacer(),
                      TextButton(
                        onPressed: () =>
                            setState(() => _logBuffer.clear()),
                        style: TextButton.styleFrom(
                            visualDensity: VisualDensity.compact),
                        child: const Text('Clear'),
                      ),
                    ],
                  ),
                ),
                Expanded(
                  child: Container(
                    margin: const EdgeInsets.fromLTRB(8, 0, 8, 8),
                    decoration: BoxDecoration(
                      color: cs.surfaceContainerHighest,
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(
                          color: cs.outlineVariant, width: 1),
                    ),
                    child: SingleChildScrollView(
                      controller: _logController,
                      padding: const EdgeInsets.all(10),
                      child: SelectableText(
                        _logBuffer.isEmpty
                            ? 'Press ▶ Run All to start…'
                            : _logBuffer.toString(),
                        style: TextStyle(
                          fontFamily: 'monospace',
                          fontSize: 12,
                          color: cs.onSurfaceVariant,
                          height: 1.5,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPackageRow(
    BuildContext context,
    int index,
    ThemeData theme,
    ColorScheme cs,
  ) {
    final def    = _packageDefinitions[index];
    final result = _results[index];

    final (statusIcon, statusColor) = switch (result.status) {
      _ImportStatus.idle    => (Icons.radio_button_unchecked, cs.outlineVariant),
      _ImportStatus.running => (Icons.sync, cs.primary),
      _ImportStatus.done    => (Icons.check_circle_outline, Colors.green),
      _ImportStatus.error   => (Icons.error_outline, cs.error),
    };

    // Resolve icon widget for preview
    final iconPath = (def.iconIndex >= 0 && def.iconIndex < _kIconPaths.length)
        ? _kIconPaths[def.iconIndex]
        : null;

    return ListTile(
      dense: true,
      leading: SizedBox(
        width: 36,
        height: 36,
        child: iconPath == null
            ? Icon(Icons.menu_book, color: cs.primary, size: 28)
            : (iconPath.endsWith('.svg')
                ? Image.asset(iconPath,
                    width: 32, height: 32, errorBuilder: (_, _, _) =>
                        Icon(Icons.menu_book, size: 28, color: cs.primary))
                : Image.asset(iconPath,
                    width: 32, height: 32, errorBuilder: (_, _, _) =>
                        Icon(Icons.menu_book, size: 28, color: cs.primary))),
      ),
      title: Text(
        '${def.packageName}  '
        '(${def.langCode1.split('-')[0].toUpperCase()} → '
        '${def.langCode2.split('-')[0].toUpperCase()})',
        style: theme.textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.w600),
      ),
      subtitle: Text(
        '${def.groupName}  •  '
        '${def.isPurchased ? "purchased" : "user-created"}  •  '
        'icon #${def.iconIndex}  •  '
        '${def.jsonFilePath.split(Platform.pathSeparator).last}',
        style: theme.textTheme.bodySmall?.copyWith(color: cs.onSurfaceVariant),
        overflow: TextOverflow.ellipsis,
      ),
      trailing: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (result.status == _ImportStatus.running)
            SizedBox(
              width: 16,
              height: 16,
              child: CircularProgressIndicator(
                strokeWidth: 2,
                color: cs.primary,
              ),
            )
          else
            Icon(statusIcon, color: statusColor, size: 20),
          if (result.message.isNotEmpty) ...[
            const SizedBox(width: 6),
            ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 220),
              child: Text(
                result.message,
                style: theme.textTheme.labelSmall?.copyWith(color: statusColor),
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ],
      ),
    );
  }
}

