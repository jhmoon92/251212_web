//import 'package:example/config/providers.dart' as providers;
import 'dart:io';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

//import 'package:timezone/data/latest.dart';

import 'features/setting/setting_provider.dart';

/// Initializes services and controllers before the start of the application
Future<ProviderContainer> bootstrap([bool emul = false]) async {
  WidgetsFlutterBinding.ensureInitialized();
  EasyLocalization.ensureInitialized();

  /// timezone plugin init

  if (emul == false) {
    //    FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);
  }

  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp, DeviceOrientation.portraitDown]);

  final container = ProviderContainer(overrides: [], observers: [if (kDebugMode) _Logger()]);
  await initializeProviders(container);
  return container;
}

class _Logger extends ProviderObserver {
  @override
  void didUpdateProvider(ProviderBase<dynamic> provider, Object? previousValue, Object? newValue, ProviderContainer container) {
    debugPrint('''
      {
      "provider": "${provider.name ?? provider.runtimeType}",
      "newValue": "$newValue"
      }''');
  }
}

/// Triggered from bootstrap() to complete futures
Future<void> initializeProviders(ProviderContainer container) async {
  /// ConfigRepository init
  await container.read(appConfigRepositoryProvider.future);

  ///setting repository init
  await container.read(appSettingRepositoryProvider.future);

  // ///push noti (ex firebase ) init
  // await container.read(pushNotiInitProvider.future);
}
