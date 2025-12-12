import 'package:json_annotation/json_annotation.dart';

part 'environment.g.dart';

toNull(_) => null;

@JsonSerializable()
/// Environment variables model, parsed from config.json files for selected flavor
class Environment {
  /// Default constructor for the [Environment] model
  String defaultServerUrl;
  List<String> locales;

  Environment(this.defaultServerUrl, this.locales,) {}

  ///
  factory Environment.fromJson(Map<String, dynamic> json) => _$EnvironmentFromJson(json);
  Map<String, dynamic> toJson() => _$EnvironmentToJson(this);
}
