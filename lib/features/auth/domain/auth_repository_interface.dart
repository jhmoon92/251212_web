

import 'package:moni_pod_web/common/provider/sensing/account_resp.dart';

abstract class AuthRepositoryInterface {
  Future<bool> signIn(String email, String password);
  Future<UserListResponse> getAccountList();
}
