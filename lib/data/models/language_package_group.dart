import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';

part 'language_package_group.g.dart';

@JsonSerializable()
class LanguagePackageGroup extends Equatable {
  final String id;
  final String name;

  const LanguagePackageGroup({
    required this.id,
    required this.name,
  });

  factory LanguagePackageGroup.fromJson(Map<String, dynamic> json) =>
      _$LanguagePackageGroupFromJson(json);

  Map<String, dynamic> toJson() => _$LanguagePackageGroupToJson(this);

  /// Create a copy with modified fields
  LanguagePackageGroup copyWith({
    String? id,
    String? name,
  }) {
    return LanguagePackageGroup(
      id: id ?? this.id,
      name: name ?? this.name,
    );
  }

  @override
  List<Object?> get props => [id, name];
}

