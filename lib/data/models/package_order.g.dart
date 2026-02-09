// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'package_order.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

PackageOrder _$PackageOrderFromJson(Map<String, dynamic> json) => PackageOrder(
  packageIds: (json['packageIds'] as List<dynamic>)
      .map((e) => e as String)
      .toList(),
  lastModified: DateTime.parse(json['lastModified'] as String),
);

Map<String, dynamic> _$PackageOrderToJson(PackageOrder instance) =>
    <String, dynamic>{
      'packageIds': instance.packageIds,
      'lastModified': instance.lastModified.toIso8601String(),
    };
