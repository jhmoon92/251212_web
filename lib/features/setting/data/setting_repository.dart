import 'dart:io';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../common/provider/sensing/sensing_api.dart';
import 'app_config_repository.dart';

//import '../../auth/auth_index.dart';

const STR_SETTING_VERSION = "STR_SETTING_VERSION";
const APP_RUN_COUNT = "APP_RUN_COUNT";
const UPDATE_STATUS = "UPDATE_STATUS";
const ALARM_PAGE_RUN_COUNT = "ALARM_PAGE_RUN_COUNT";
const VIEW_PADDING_BOTTOM = "VIEW_PADDING_BOTTOM";
//const USER_ACCOUNT = "USER_ACCOUNT";
const REMEMBER_ME = "REMEMBER_ME";
const NEW_HOME_PAGE = "NEW_HOME_PAGE";
const NODE_LOCATION = "NODE_LOCATION";
const STR_SERVER_URL = "STR_SERVER_URL";
const SHOW_NODE_ACTIVITY_INFO = "SHOW_NODE_ACTIVITY_INFO";
const SHOW_MORE_NODE_INFO = "SHOW_MORE_NODE_INFO";
const ALLOW_NODE_DRAG = "ALLOW_NODE_DRAG";
const NODE_DRAG_METHOD_2ND = "NODE_DRAG_METHOD_2ND";
const ACTIVITY_RIPPLE_2ND = "ACTIVITY_RIPPLE_2ND";
const ACTIVITY_RIPPLE_3RD = "ACTIVITY_RIPPLE_3RD";
const FCM_TOKEN = "FCM_TOKEN";
const UNIQUE_DEV_ID = "UNIQUE_DEV_ID";
const MAX_ALARM = "MAX_ALARM";
const PERMISSION_REQUESTED = "PERMISSION_REQUESTED";
const SHOW_MOTION_DURATION = "SHOW_MOTION_DURATION";
const SHOW_ALARM_SETTING = "SHOW_ALARM_SETTING";
const SHOW_MOTION_TOOLTIP = "SHOW_MOTION_TOOLTIP";
const STR_LOCALE = "STR_LOCALE";
const CONNECT_GATEWAYIP = "CONNECT_GATEWAYIP";

const GATEWAY_TOKEN = "GATEWAY_TOKEN";
const DEVICE_SPECIFIC_ID = "DEVICE_SPECIFIC_ID";
const USER_CHANGE_SERVER_URL = "USER_CHANGE_SERVER_URL";
const SIGNIN_ERROR_COUNT = "SIGNIN_ERROR_COUNT";
const SIGNIN_ERROR_COUNT_STRING = "SIGNIN_ERROR_COUNT_STRING";

const CPE_TIMEZONE = "CPE_TIMEZONE";
const MOBILE_TIMEZONE = "MOBILE_TIMEZONE";
const CPE_TIMEOFFSET = "MOBILE_TIMEOFFSET";
const CPE_TIMEOFFSET_USER = "MOBILE_TIMEOFFSET_USER";

const TOKENEXPIRE_TIME = "TOKENEXPIRE_TIME";
const HOME_ALLSENSING_SKIP = "HOME_ALLSENSING_SKIP";
const HOME_ALLPEOPLE_SKIP = "HOME_ALLPEOPLE_SKIP";
const WEEK_REPORT_GUIDE_SKIP = "WEEK_REPORT_GUIDE_SKIP";
const WEEK_REPORT_INIT_SKIP = "WEEK_REPORT_INIT_SKIP";

SingInError defaultErrorInfo = SingInError("", -1);

class SingInError {
  SingInError(this.account, this.count);
  final String account;
  late final int count;
}

class SettingRepository {
  //final SettingLocalStorage localStorage = SettingLocalStorage();
  late final SharedPreferences preferences;

  static final SettingRepository instance = SettingRepository();

  int get runCount => preferences.getInt(APP_RUN_COUNT) ?? 0;
  set runCount(int value) => preferences.setInt(APP_RUN_COUNT, value);

  late final String _packageName;
  String get packageName => _packageName;

  late final String _appName;
  String get appName => _appName;

  String get settingVersion => preferences.getString(STR_SETTING_VERSION) ?? "";
  set settingVersion(data) => preferences.setString(STR_SETTING_VERSION, data);

  String get serverUrl => getServerUrl();
  set serverUrl(data) => preferences.setString(STR_SERVER_URL, data);
  String getServerUrl() {
    String? data = preferences.getString(STR_SERVER_URL);
    if (data == null) {
      preferences.setString(STR_SERVER_URL, AppConfigRepository.instance.serverUrl);
      data = preferences.getString(STR_SERVER_URL);
    }
    return data!;
  }

  Future<void> init() async {
    try {
      preferences = await SharedPreferences.getInstance();
      //await localStorage.init();
      /// after preference loading, have to reset sensing api serverurl
      ///// check config version & setting version
      if (serverUrl != AppConfigRepository.instance.serverUrl) SensingApi.instance.setServerApi(serverUrl);
    } catch (e) {
      ///TODO :
    }
  }

  List<String> getFontFamilyFallback() {
    List<String> fontFamily = ['Archivo', 'NotoSans'];
    Locale currentLocale = PlatformDispatcher.instance.locale;

    if (currentLocale.languageCode == "th" && AppConfigRepository.instance.getSupportedFullLocales().contains(Locale("th"))) {
      fontFamily.insert(0, 'Sarabun');
    }

    return fontFamily;
  }

  Future<String> getInitServerUrl() async {
    debugPrint("setting repo getInitServerUrl");
    try {
      //   String device = await _getUniqueDeviceId();
      //   String os = Platform.operatingSystem;
      //
      //   String? country = WidgetsBinding
      //       .instance.platformDispatcher.locales.first.countryCode; // WidgetsBinding.instance.window.locales;
      //   // debugPrint("country $country country1 $country1");
      //   if ((country == null) || (country.isEmpty)) {
      //     country = AppConfigRepository.instance.appCountry;
      //   }
      //   if ((Platform.isAndroid) && (country != AppConfigRepository.instance.appCountry)) {
      //     // TODO: need release check
      //     country = await getCountryByGeo(device, AppConfigRepository.instance.appCountry);
      //     //debugPrint("after getCountryByGeo $country");
      //   }
      //
      //   String _currentVersion = await getAppBuildNumber();
      //   _currentVersion = 'v' + _currentVersion;
      //   //_currentVersion = "v9.9.9"; // this is wsens4dev.wifisensing.net
      //
      //   String server =
      //       await remoteStorage.getInitServerUrl(device, os, country, _currentVersion) ?? AppConfigRepository().serverUrl;
      //   //debugPrint("getServerUrl device ${device} os ${os},country${country}, _currentVersion${_currentVersion}/${LocalDb.Instance.userChangeServerUrl}->${serverUrl} ");
      //   //String server = "wsens4dev.wifisensing.net";//AppConfigRepository.instance.serverUrl; // TODO: have to change
      //   if ((server.isNotEmpty) && (userChangeServerUrl == false)) {
      //     serverUrl = server;
      //   }
      //   debugPrint("setting repo getInitServerUrl return $serverUrl");
      //   return serverUrl;
      return AppConfigRepository.instance.serverUrl;
    } catch (e) {
      debugPrint("getInitServerUrl exception ${e.toString()}");
      return serverUrl;
    }
  }
}
