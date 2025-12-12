import 'package:flutter/material.dart';
import 'package:moni_pod_web/config/style.dart';

import '../features/setting/data/setting_repository.dart';

class Themes {
  static final basicLight = ThemeData(
    brightness: Brightness.light,
    dialogBackgroundColor: commonWhite,
    visualDensity: VisualDensity.adaptivePlatformDensity,
    fontFamilyFallback: SettingRepository.instance.getFontFamilyFallback(),
    scaffoldBackgroundColor: commonWhite,
    primaryColor: themeYellow, // Theme.of(context).primaryColor
    secondaryHeaderColor: themeYellow10,
    dividerColor: commonGrey2,
    canvasColor: commonWhite,
    textSelectionTheme: const TextSelectionThemeData(
        cursorColor: themeYellow, selectionColor: themeYellow20, selectionHandleColor: Colors.transparent),
    colorScheme: const ColorScheme(
        brightness: Brightness.light,
        primary: themeYellow,
        secondary: themeYellow50,
        onPrimary: themeYellow,
        onSecondary: themeYellow50,
        error: pointRed,
        onError: pointRed,
        background: commonWhite,
        onBackground: commonWhite,
        surface: commonWhite,
        onSurface: commonWhite),
    timePickerTheme: TimePickerThemeData(
        backgroundColor: commonWhite,
        dialBackgroundColor: commonWhite,
        helpTextStyle: titleSmall(commonBlack),
        dialHandColor: themeYellow,
        dialTextColor: commonBlack,
        dayPeriodColor: MaterialStateColor.resolveWith((Set<MaterialState> states) {
          return states.contains(MaterialState.selected) ? themeYellow : commonWhite;
        }),
        dayPeriodTextColor: MaterialStateColor.resolveWith((Set<MaterialState> states) {
          return states.contains(MaterialState.selected) ? commonWhite : commonGrey5;
        }),
        entryModeIconColor: commonGrey5,
        hourMinuteColor: MaterialStateColor.resolveWith((Set<MaterialState> states) {
          return states.contains(MaterialState.selected) ? themeYellow : commonWhite;
        }),
        hourMinuteTextColor: MaterialStateColor.resolveWith((Set<MaterialState> states) {
          return states.contains(MaterialState.selected) ? commonWhite : commonGrey5;
        }),
        dayPeriodBorderSide: const BorderSide(color: themeYellow),
        cancelButtonStyle: ButtonStyle(
          textStyle: MaterialStateProperty.all(titlePoint(commonBlack)),
        ),
        confirmButtonStyle: ButtonStyle(
          textStyle: MaterialStateProperty.all(titleSmall(commonBlack)),
        )),
    // colorScheme: const ColorScheme(
    //   brightness: Brightness.light,
    //   primary: themeYellow, // Theme.of(context).colorScheme.primary,
    //   onPrimary: themeYellow50,
    //   secondary: colorSecondary,
    //   onSecondary: colorSecondary,
    //   error: Color(0xFFF32424),
    //   onError: Color(0xFFF32424),
    //   background: Color(0xFFF1F2F3),
    //   onBackground: Color(0xFFFFFFFF),
    //   surface: Color(0xFF54B435),
    //   onSurface: Color(0xFF54B435),
    // )
    // appBarTheme: const AppBarTheme(
    //   backgroundColor: commonWhite,
    //   titleSpacing: 20,
    //   elevation: 0,
    // ),
    // toggleButtonsTheme: ToggleButtonsThemeData(
    //     textStyle: body_black,
    //     selectedColor: const Color(0xFFe7a90c),
    //     fillColor: const Color(0xFFf5f5f5),
    //     disabledColor: const Color(0xFFf5f5f5),
    //     selectedBorderColor: const Color(0xFFe7a90c),
    //     disabledBorderColor: const Color(0xFFe7a90c),
    //     borderRadius: BorderRadius.all(Radius.circular(20))),
  );
}
