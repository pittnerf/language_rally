// lib/data/models/package_order.dart
import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';

part 'package_order.g.dart';

/// Stores the display order of language packages
@JsonSerializable()
class PackageOrder extends Equatable {
  final List<String> packageIds; // Ordered list of package IDs
  final DateTime lastModified;

  const PackageOrder({
    required this.packageIds,
    required this.lastModified,
  });

  factory PackageOrder.fromJson(Map<String, dynamic> json) =>
      _$PackageOrderFromJson(json);

  Map<String, dynamic> toJson() => _$PackageOrderToJson(this);

  PackageOrder copyWith({
    List<String>? packageIds,
    DateTime? lastModified,
  }) =>
      PackageOrder(
        packageIds: packageIds ?? this.packageIds,
        lastModified: lastModified ?? this.lastModified,
      );

  @override
  List<Object?> get props => [packageIds, lastModified];
}

