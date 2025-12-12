import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:moni_pod_web/router.dart';
import 'config/theme.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends ConsumerWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    String locale = 'en';
    initializeDateFormatting(locale);
    return EasyLocalization(
      supportedLocales: const [Locale('en', 'US')],
      path: 'assets/strings',
      fallbackLocale: const Locale('en'),
      useOnlyLangCode: true,
      child: Builder(
        builder: (context) {
          return MaterialApp.router(
            routerConfig: router,
            debugShowCheckedModeBanner: false,
            // localizationsDelegates: context.localizationDelegates,
            // supportedLocales: context.supportedLocales,
            theme: Themes.basicLight,
            // home:  BaseScreen(child: ManageBuildingScreen(),),
            builder: (context, child) {
              // This code is to ignore system font size
              return MediaQuery(data: MediaQuery.of(context).copyWith(textScaleFactor: 1.0), child: child!);
            },
          );
        },
      ),
    );
  }
}
