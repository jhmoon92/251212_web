// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'environment.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Environment _$EnvironmentFromJson(Map<String, dynamic> json) => Environment(
  json['defaultServerUrl'] as String,
  (json['locales'] as List<dynamic>).map((e) => e as String).toList(),
);

Map<String, dynamic> _$EnvironmentToJson(Environment instance) =>
    <String, dynamic>{
      'defaultServerUrl': instance.defaultServerUrl,
      'locales': instance.locales,
    };
