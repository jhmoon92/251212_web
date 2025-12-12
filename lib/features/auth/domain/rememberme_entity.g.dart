// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'rememberme_entity.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

RememberMe _$RememberMeFromJson(Map<String, dynamic> json) => RememberMe(
  credential: json['credential'] as String,
  account: json['account'] as String,
  fcmToken: json['fcmToken'] as String? ?? "",
  active: json['active'] as bool? ?? false,
);

Map<String, dynamic> _$RememberMeToJson(RememberMe instance) =>
    <String, dynamic>{
      'active': instance.active,
      'account': instance.account,
      'credential': instance.credential,
      'fcmToken': instance.fcmToken,
    };
