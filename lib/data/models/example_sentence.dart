import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';

part 'example_sentence.g.dart';

@JsonSerializable()
class ExampleSentence extends Equatable {
  final String id;
  final String textLanguage1;
  final String textLanguage2;

  const ExampleSentence({
    required this.id,
    required this.textLanguage1,
    required this.textLanguage2,
  });

  factory ExampleSentence.fromJson(Map<String, dynamic> json) =>
      _$ExampleSentenceFromJson(json);

  Map<String, dynamic> toJson() => _$ExampleSentenceToJson(this);

  @override
  List<Object?> get props => [id, textLanguage1, textLanguage2];
}
