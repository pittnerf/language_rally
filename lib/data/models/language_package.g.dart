// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'language_package.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

LanguagePackage _$LanguagePackageFromJson(Map<String, dynamic> json) =>
    LanguagePackage(
      id: json['id'] as String,
      languageCode1: json['languageCode1'] as String,
      languageName1: json['languageName1'] as String,
      languageCode2: json['languageCode2'] as String,
      languageName2: json['languageName2'] as String,
      description: json['description'] as String?,
      icon: json['icon'] as String?,
      authorName: json['authorName'] as String?,
      authorEmail: json['authorEmail'] as String?,
      authorWebpage: json['authorWebpage'] as String?,
      version: json['version'] as String? ?? '1.0',
      packageType:
          $enumDecodeNullable(_$PackageTypeEnumMap, json['packageType']) ??
          PackageType.userCreated,
      isPurchased: json['isPurchased'] as bool? ?? false,
      isReadonly: json['isReadonly'] as bool? ?? false,
      isCompactView: json['isCompactView'] as bool? ?? false,
      purchasedAt: json['purchasedAt'] == null
          ? null
          : DateTime.parse(json['purchasedAt'] as String),
      createdAt: DateTime.parse(json['createdAt'] as String),
      price: (json['price'] as num?)?.toDouble() ?? 0.0,
    );

Map<String, dynamic> _$LanguagePackageToJson(LanguagePackage instance) =>
    <String, dynamic>{
      'id': instance.id,
      'languageCode1': instance.languageCode1,
      'languageName1': instance.languageName1,
      'languageCode2': instance.languageCode2,
      'languageName2': instance.languageName2,
      'description': instance.description,
      'icon': instance.icon,
      'authorName': instance.authorName,
      'authorEmail': instance.authorEmail,
      'authorWebpage': instance.authorWebpage,
      'version': instance.version,
      'packageType': _$PackageTypeEnumMap[instance.packageType]!,
      'isPurchased': instance.isPurchased,
      'isReadonly': instance.isReadonly,
      'isCompactView': instance.isCompactView,
      'purchasedAt': instance.purchasedAt?.toIso8601String(),
      'createdAt': instance.createdAt.toIso8601String(),
      'price': instance.price,
    };

const _$PackageTypeEnumMap = {
  PackageType.defaultPackage: 'defaultPackage',
  PackageType.userCreated: 'userCreated',
  PackageType.purchased: 'purchased',
};
