import 'dart:ui';

import 'package:flutter/material.dart';

import '../../../common/provider/sensing/account_resp.dart';
import '../../../common/provider/sensing/sensing_api.dart';
import '../domain/auth_repository_interface.dart';
import '../domain/rememberme_entity.dart';
import 'auth_local_data_source.dart';

class ReadRememberMeException implements Exception {
  ReadRememberMeException([message = "Error : Remember me"]);
}

class SignInException implements Exception {
  SignInException([message = "Error : SignIn"]);
}

class AutoSignInException implements Exception {
  AutoSignInException([message = "Error : Auto SignIn"]);
}

class AuthRepository implements AuthRepositoryInterface {
  final AuthLocalDataSource rememberLocalDataSource;
  final SensingApi _client;
  // AccountEntity _currentAccount = defaultAccountEntity;
  //PeopleEntity _currentPeople = defaultPeopleEntity;

  AuthRepository(this.rememberLocalDataSource, this._client);
  // @override
  // AccountEntity get currentAccount => _currentAccount;

  // @override
  // bool get isSigned => currentAccount.token.isNotEmpty;
  //
  // @override
  // int get currentAccountId => _currentAccount.id;

  // @override
  // Future<int> restoreSession() async {
  //   try {
  //     // first run
  //     // if (SettingRepository.instance.runCount < 1) {
  //     //   await rememberLocalDataSource.deleteAll();
  //     //   //return FAIL;
  //     // }
  //     RememberMe rememberMe = await rememberLocalDataSource.getRememberMe();
  //     if ((rememberMe.credential.isNotEmpty || rememberMe.peopleId.isNotEmpty)) {
  //       if (rememberMe.credential.isNotEmpty) {
  //         _currentAccount =
  //             AccountEntity(email: rememberMe.account, token: rememberMe.credential, remember: rememberMe.active, id: rememberMe.accountId);
  //       }
  //       _client.setToken(token: rememberMe.credential, accountId: rememberMe.account);
  //       if (rememberMe.peopleId.isNotEmpty) {
  //         currentPeople = PeopleEntity(id: rememberMe.peopleId, accountId: _currentAccount.id);
  //         _client.setToken(peopleToken: rememberMe.peopleId, accountId: rememberMe.account, deviceId: rememberMe.deviceId);
  //       }
  //       await getAccountInfo(false);
  //       currentPeople = findPeople(rememberMe.peopleId) ?? PeopleEntity(id: rememberMe.peopleId, accountId: _currentAccount.id);
  //       _client.setToken(
  //           token: rememberMe.credential, peopleToken: rememberMe.peopleId, accountId: rememberMe.account, deviceId: rememberMe.deviceId);
  //       //_signUpPeople = await rememberLocalDataSource.getSignupPeople();
  //
  //       return SUCCESS;
  //     } else if ((rememberMe.active) && (rememberMe.account.isNotEmpty)) {
  //       if (SettingRepository.instance.runCount != 0) {
  //         _currentAccount =
  //             AccountEntity(email: rememberMe.account, token: "", remember: rememberMe.active, id: -1); // get from getAccountInfo
  //         await getAccountInfo(false);
  //       }
  //       return SUCCESS;
  //     }
  //     return SUCCESS;
  //   } catch (e) {
  //     await rememberLocalDataSource.deleteRememberMe();
  //     rethrow; //// TODO : need to reset rememberLocalDataSource
  //   }
  //
  //   return FAIL;
  // }
  //
  // @override
  // Future<AccountEntity> fetchAccount() async {
  //   try {
  //     if (_currentAccount.email.isEmpty) {
  //       RememberMe rememberMe = await rememberLocalDataSource.getRememberMe();
  //       debugPrint("fetchAccount ${rememberMe.credential}/${rememberMe.accountId}");
  //       _currentAccount =
  //           AccountEntity(email: rememberMe.account, token: rememberMe.credential, remember: rememberMe.active, id: rememberMe.accountId);
  //     }
  //     await getAccountInfo();
  //     return _currentAccount;
  //   } catch (e) {
  //     rethrow;
  //   }
  // }
  //
  // @override
  // Future<void> resetSession([bool onlyPeople = false]) async {
  //   int re = FAIL;
  //   try {
  //     if (onlyPeople) {
  //       /// reset people token
  //
  //       _client.reSetToken(peopleToken: true, deviceId: true);
  //       currentPeople = PeopleEntity(id: "", accountId: _currentAccount.id);
  //       await rememberLocalDataSource.resetToken(true);
  //     } else {
  //       /// reset all token
  //       _client.reSetToken(token: true, peopleToken: true, deviceId: true);
  //       currentPeople = defaultPeopleEntity;
  //       _currentAccount = AccountEntity(email: _currentAccount.email, id: -1, token: "", remember: _currentAccount.remember);
  //       await rememberLocalDataSource.resetToken();
  //     }
  //   } catch (e) {
  //     rethrow;
  //   }
  // }

  @override
  Future<bool> signIn(String id, String pwd) async {
    try {
      UserLogin? data = await _client.accountLogin(id, pwd);
      if (data != null) {
        //if (active /*&& _user.remember != active*/) {
        await rememberLocalDataSource
            .setRememberMe(RememberMe(credential: data.access_token, account: id, active: true));

        /// after sign in account , set account token url
        _client.setToken(token: data.access_token,tokenType: data.token_type,accountId: id);
        // fetch account info to repo
        // _currentAccount = AccountEntity(email: id, remember: active, id: data.account_id, token: data.access_token);
        // await getAccountInfo();
        return true;
      }
      //_authState.value = currentUser.updateUserId(id, pw, null, null);
      throw SignInException();
    } catch (e) {
      //_authState.value = currentUser.updateUserId(id, pw, null, null);
      rethrow;
    }
  }


  @override
  Future<UserListResponse> getAccountList() async {
    try {
      UserListResponse? data = await _client.getAccountList();
      if (data != null) {
        print("SUCCESS");
        print(data.toString());
        return data;
      }
      throw Error();
    } catch (e) {
      rethrow;
    }
  }
}
