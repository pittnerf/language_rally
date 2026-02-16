import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';

part 'language_package.g.dart';

enum PackageType { defaultPackage, userCreated, purchased }

@JsonSerializable()
class LanguagePackage extends Equatable {
  final String id;
  final String groupId; // Reference to LanguagePackageGroup
  final String? packageName; // User-friendly name for the package
  final String languageCode1;
  final String languageName1;
  final String languageCode2;
  final String languageName2;
  final String? description;
  final String? icon; // Path to custom icon image, null = use default dictionary icon
  final String? authorName;
  final String? authorEmail;
  final String? authorWebpage;
  final String version;
  final PackageType packageType;
  final bool isPurchased;
  final bool isReadonly;
  final bool isCompactView; // UI preference: compact or expanded view
  final DateTime? purchasedAt;
  final DateTime createdAt;
  final double price;

  const LanguagePackage({
    required this.id,
    required this.groupId,
    this.packageName,
    required this.languageCode1,
    required this.languageName1,
    required this.languageCode2,
    required this.languageName2,
    this.description,
    this.icon, // null = default dictionary icon will be shown
    this.authorName,
    this.authorEmail,
    this.authorWebpage,
    this.version = '1.0',
    this.packageType = PackageType.userCreated,
    this.isPurchased = false,
    this.isReadonly = false,
    this.isCompactView = false, // Default to expanded view
    this.purchasedAt,
    required this.createdAt,
    this.price = 0.0,
  });

  factory LanguagePackage.fromJson(Map<String, dynamic> json) =>
      _$LanguagePackageFromJson(json);

  Map<String, dynamic> toJson() => _$LanguagePackageToJson(this);

  /// Helper to check if package can be edited
  bool get canEdit => !isReadonly && !isPurchased;

  /// Helper to check if package can be exported
  bool get canExport => !isPurchased && packageType == PackageType.userCreated;

  /// Create a copy with modified fields
  LanguagePackage copyWith({
    String? id,
    String? groupId,
    String? packageName,
    String? languageCode1,
    String? languageName1,
    String? languageCode2,
    String? languageName2,
    String? description,
    String? icon,
    String? authorName,
    String? authorEmail,
    String? authorWebpage,
    String? version,
    PackageType? packageType,
    bool? isPurchased,
    bool? isReadonly,
    bool? isCompactView,
    DateTime? purchasedAt,
    DateTime? createdAt,
    double? price,
  }) {
    return LanguagePackage(
      id: id ?? this.id,
      groupId: groupId ?? this.groupId,
      packageName: packageName ?? this.packageName,
      languageCode1: languageCode1 ?? this.languageCode1,
      languageName1: languageName1 ?? this.languageName1,
      languageCode2: languageCode2 ?? this.languageCode2,
      languageName2: languageName2 ?? this.languageName2,
      description: description ?? this.description,
      icon: icon ?? this.icon,
      authorName: authorName ?? this.authorName,
      authorEmail: authorEmail ?? this.authorEmail,
      authorWebpage: authorWebpage ?? this.authorWebpage,
      version: version ?? this.version,
      packageType: packageType ?? this.packageType,
      isPurchased: isPurchased ?? this.isPurchased,
      isReadonly: isReadonly ?? this.isReadonly,
      isCompactView: isCompactView ?? this.isCompactView,
      purchasedAt: purchasedAt ?? this.purchasedAt,
      createdAt: createdAt ?? this.createdAt,
      price: price ?? this.price,
    );
  }

  @override
  List<Object?> get props => [
        id,
        groupId,
        packageName,
        languageCode1,
        languageName1,
        languageCode2,
        languageName2,
        description,
        icon,
        authorName,
        authorEmail,
        authorWebpage,
        version,
        packageType,
        isPurchased,
        isReadonly,
        isCompactView,
        purchasedAt,
        createdAt,
        price
      ];
}
