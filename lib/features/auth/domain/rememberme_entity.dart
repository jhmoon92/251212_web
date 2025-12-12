import 'package:json_annotation/json_annotation.dart';

part 'rememberme_entity.g.dart';

RememberMe defaultRememberMe = RememberMe(account: "", credential: "");

@JsonSerializable()
class RememberMe {
  RememberMe({required this.credential, required this.account, this.fcmToken = "", this.active = false});

  bool active;
  String account;
  String credential;
  String fcmToken;

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is RememberMe && other.active == active && other.account == account && other.credential == credential;
  }

  factory RememberMe.fromJson(Map<String, dynamic> json) => _$RememberMeFromJson(json);

  Map<String, dynamic> toJson() => _$RememberMeToJson(this);
}

extension RememberMeExtension on RememberMe {
  RememberMe updatePeople(newPeopleId, newFcmToken) {
    return RememberMe(active: active, account: account, credential: credential, fcmToken: newFcmToken);
  }
}
