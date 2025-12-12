import 'dart:convert';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../../config/theme.dart';
import '../../../flavors.dart';
import '../domain/environment.dart';

const String configServer = "mobregist.wifisensing.net";

class AppConfigRepository {
  late final String configFile;
  late final Environment config;

  static final AppConfigRepository instance = AppConfigRepository();

  String get configServerUrl => configServer;
  String get serverUrl => config.defaultServerUrl;
  String get appName => F.title;
  Locale get appLanguage => getLanLocale();
  String get appCountry => getCountryLocale();


  String get fullLocale {
    if (config.locales.isNotEmpty && config.locales[0].contains("_")) {
      return config.locales[0];
    }
    return "";
  }

  Locale getLanLocale() {
    if (config.locales.isNotEmpty && config.locales[0].contains("_")) {
      String loc = config.locales[0].split("_")[0]; //
      debugPrint("getLanLocale $loc");
      return Locale(loc);
    }
    return const Locale('en');
  }

  List<Locale> getSupportedFullLocales() {
    List<Locale> re = [];
    if (config.locales.isNotEmpty) {
      for (var value in config.locales) {
        if (value.contains("_")) {
          String loc = value.split("_")[0];
          re.add(Locale(loc));
        }
      }
    }
    debugPrint("getLanLocale ${re.toString()}");
    return re;
  }

  List<String> getSupportedLocales() {
    List<String> re = [];
    if (config.locales.isNotEmpty) {
      for (var value in config.locales) {
        if (value.contains("_")) {
          String loc = value.split("_")[0];
          re.add(loc);
        }
      }
    }
    debugPrint("getLanLocale ${re.toString()}");
    return re;
  }

  String getCountryLocale() {
    if (config.locales.isNotEmpty && config.locales[0].contains("_")) {
      return config.locales[0].split("_")[1];
    }
    return "KR";
  }

  Future<bool> init() async {
    configFile = await rootBundle.loadString(F.envFileName);
    //final env =
    config = Environment.fromJson(jsonDecode(configFile) as Map<String, dynamic>);
    return config.defaultServerUrl.isNotEmpty;
  }
}
