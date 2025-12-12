import 'dart:convert';

import '../provider_base.dart';
import 'account_resp.dart';

const userAuthLoginAPI = "api/sign-in";
const getAccountListAPI = "api/account/page/accounts?page=0&size=600";

class AuthClient extends ClientProvider {
  AuthClient(client) : super(client, ApiType.cloudAuth);

  Future<UserLogin?> userLogin(String email, String password) async {
    print("AuthClient userLogin $email $password");
    try {
      // for test
      //UserLogin user = UserLogin(
      //    19, "Bearer", "eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJzdWIiO", 1697956820961);

      //return user;
      ApiResponse response = await client.httpPost(
          userAuthLoginAPI, null, '{"email":"$email","password":${jsonEncode(password)}, "rememberMe" : true}');

      // for jsonSerialization
      if (response.statusCode == 200) {
        Map<String, dynamic> resMap = jsonDecode(response.body.toString());
        UserLogin result = UserLogin.fromJson(resMap);
        print(result.toString());

        print("server account login ok");
        return result;
      } else {

        return UserLogin("", "", 0);

      }

      // // Test code (Sign in Fail Case)
      // switch (response.statusCode) {
      //   case 200: // sign_in fail
      //     Map<String, dynamic> resMap = jsonDecode(response.body.toString());
      //     UserLogin result = UserLogin.fromJson(resMap);
      //     print(result.toString());
      //     user = AccountEntity(
      //
      //         /// TODO : have to be changed
      //         email: username,
      //         remember: defaultRememberMe,
      //         token: result.access_token,
      //         id: result.account_id);
      //     print("server account logint ok");
      //     return user;
      //   case 400:
      //     Map<String, dynamic> resMap = jsonDecode(response.body.toString());
      //     UserLogin result = UserLogin.fromJson(resMap);
      //     print(result.toString());
      //     user = AccountEntity(
      //
      //         /// TODO : have to be changed
      //         email: username,
      //         remember: defaultRememberMe,
      //         token: result.access_token,
      //         id: result.account_id);
      //     print("server account logint ok");
      //     return user;
      //   case 401:
      //     throw signInFailException();
      //   case 402:
      //     throw alreadyRegisterException();
      //   case 403:
      //     throw exceedPasswordException();
      //   case 404:
      //     throw dormantInformationException();
      //   case 405:
      //     throw passwordChangeException();
      // }
    } catch (e) {
      rethrow;
      // print("server account login exception");
      // if (e is SocketException) {
      //   throw communicationErrorException;
      // } else {
      //   rethrow;
      // }
    }
  }

  Future<UserListResponse?> getAccountList() async {
    try {
      ApiResponse response = await client.httpGet(getAccountListAPI);

      // for jsonSerialization
      if (response.statusCode == 200) {
        Map<String, dynamic> resMap = jsonDecode(response.body.toString());
        UserListResponse result = UserListResponse.fromJson(resMap);
        print(result.toString());

        print("Account List ok");
        return result;
      } else {
        throw Exception("error");
      }

    } catch (e) {
      rethrow;
    }
  }


}
