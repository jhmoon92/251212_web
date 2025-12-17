import 'package:flutter/material.dart';

// themeColor
const Color themeYellow = Color(0xFFeab722);
const Color themeYellow60 = Color(0x99eab722);
const Color themeYellow50 = Color(0x80eab722);
const Color themeYellow25 = Color(0x40eab722);
const Color themeYellow20 = Color(0x33eab722);
const Color themeYellow10 = Color(0x1Aeab722);

const Color themeYellowLv5 = Color(0xFFCA990A);
// const Color themeYellowLv4 = Color(0xFFeab722); themeYellowLv4 = themeYellow
const Color themeYellowLv3 = Color(0xFFFCC525);
const Color themeYellowLv2 = Color(0xFFFAD567);
const Color themeYellowLv1 = Color(0xFFFFEAAA);

// color
const Color themePurple = Color(0xFF9164cb);
const Color themePurple20 = Color(0x339164cb);
const Color themePurple10 = Color(0x1A9164cb);
const Color themePink = Color(0xFFd0688b);
const Color themePink20 = Color(0x33d0688b);
const Color themePink10 = Color(0x1Ad0688b);
const Color themeMint = Color(0xFF63c595);
const Color themeMint20 = Color(0x3363c595);
const Color themeMint10 = Color(0x1A63c595);
const Color themeBlue = Color(0xFF5f7ec9);
const Color themeBlue20 = Color(0x335f7ec9);
const Color themeBlue10 = Color(0x1A5f7ec9);
const Color themeCerulean = Color(0xFF414F89);
const Color themeCerulean20 = Color(0x33414F89);
const Color themeCerulean10 = Color(0x1A414F89);
const Color themeOrange = Color(0xFFcf7a5c);
const Color themeOrange20 = Color(0x33cf7a5c);
const Color themeOrange10 = Color(0x1Acf7a5c);
const Color themeSky = Color(0xFF5fb6c9);
const Color themeSky20 = Color(0x335fb6c9);
const Color themeSky10 = Color(0x1A5fb6c9);
const Color themeRed = Color(0xFFc95f5f);
const Color themeRed20 = Color(0x33c95f5f);
const Color themeRed10 = Color(0x1Ac95f5f);
const Color themeGreen = Color(0xFF68b631);
const Color themeGreen20 = Color(0x3368b631);
const Color themeGreen10 = Color(0x1A68b631);
const Color themeNavy = Color(0xFF414F89);
const Color pointDarkGreen = Color(0xFF559B3D);
const Color pointGreen = Color(0xFF6FD94A);
const Color pointGreen10 = Color(0x1A6FD94A);
const Color pointGreen50 = Color(0x806FD94A);
const Color pointRed = Color(0xFFDC362E);

const Color newBlue = Color(0xFF1678F9);
const Color warningRed = Color(0xFFDC362E);
const Color successGreen = Color(0xFF75CE36);
const Color newBlueBg1 = Color(0xFFE8F2FF);
const Color warningRedBg1 = Color(0xFFFCEBEB);
const Color successGreenBg1 = Color(0xFFF2FBEB);
const Color newBlueBg2 = Color(0xFFD0E4FE);
const Color warningRedBg2 = Color(0xFFF8D7D5);
const Color successGreenBg2 = Color(0xFFE1F0D6);
const Color cautionYellowBg1 = Color(0xFFFDF8E9);
const Color cautionYellowBg2 = Color(0xFFFBF1D3);

// grayscale
const Color commonBlack = Color(0xFF000000);
const Color commonBlack50 = Color(0x80000000);
const Color commonBlack10 = Color(0x1A000000);
const Color commonBlack20 = Color(0x33000000);
const Color commonWhite = Color(0xFFFFFFFF);
const Color commonGrey7 = Color(0xFF333333);
const Color commonGrey6 = Color(0xFF666666);
const Color commonGrey5 = Color(0xFF999999);
const Color commonGrey4 = Color(0xFFAAAAAA);
const Color commonGrey3 = Color(0xFFCCCCCC);
const Color commonGrey2 = Color(0xFFEEEEEE);
const Color commonGrey1 = Color(0xFFF5F5F5);

TextStyle headLineLarge(Color color) {
  return TextStyle(
      fontWeight: FontWeight.w700,
      fontSize: 32,
      color: color,
      height: 40 / 32,
      leadingDistribution: TextLeadingDistribution.even);
}

TextStyle headLineMedium(Color color) {
  return TextStyle(
      fontWeight: FontWeight.w700,
      fontSize: 28,
      color: color,
      height: 36 / 28,
      leadingDistribution: TextLeadingDistribution.even);
}

TextStyle headLineSmall(Color color) {
  return TextStyle(
      fontWeight: FontWeight.w700,
      fontSize: 24,
      color: color,
      height: 32 / 24,
      leadingDistribution: TextLeadingDistribution.even);
}

TextStyle titleLarge(Color color) {
  return TextStyle(
      fontWeight: FontWeight.w700,
      fontSize: 20,
      color: color,
      height: 28 / 20,
      leadingDistribution: TextLeadingDistribution.even);
}

TextStyle titleMedium(Color color) {
  return TextStyle(
      fontWeight: FontWeight.w700,
      fontSize: 18,
      color: color,
      height: 26 / 18,
      leadingDistribution: TextLeadingDistribution.even);
}

TextStyle titleSmall(Color color) {
  return TextStyle(
      fontWeight: FontWeight.w700,
      fontSize: 16,
      color: color,
      height: 24 / 16,
      leadingDistribution: TextLeadingDistribution.even);
}

TextStyle titlePoint(Color color) {
  return TextStyle(
      fontWeight: FontWeight.w500,
      fontSize: 16,
      color: color,
      height: 24 / 16,
      leadingDistribution: TextLeadingDistribution.even);
}

TextStyle titleCommon(Color color) {
  return TextStyle(
      fontWeight: FontWeight.w400,
      fontSize: 16,
      color: color,
      height: 24 / 16,
      leadingDistribution: TextLeadingDistribution.even);
}

TextStyle bodyTitle(Color color) {
  return TextStyle(
      fontWeight: FontWeight.w700,
      fontSize: 14,
      color: color,
      height: 18 / 14,
      leadingDistribution: TextLeadingDistribution.even);
}

TextStyle bodyPoint(Color color) {
  return TextStyle(
      fontWeight: FontWeight.w500,
      fontSize: 14,
      color: color,
      height: 18 / 14,
      leadingDistribution: TextLeadingDistribution.even);
}

TextStyle bodyCommon(Color color) {
  return TextStyle(
      fontWeight: FontWeight.w400,
      fontSize: 14,
      color: color,
      height: 18 / 14,
      leadingDistribution: TextLeadingDistribution.even,
      decorationThickness: 0);
}

TextStyle captionTitle(Color color) {
  return TextStyle(
      fontWeight: FontWeight.w700,
      fontSize: 12,
      color: color,
      height: 16 / 12,
      leadingDistribution: TextLeadingDistribution.even);
}

TextStyle captionPoint(Color color) {
  return TextStyle(
      fontWeight: FontWeight.w500,
      fontSize: 12,
      color: color,
      height: 16 / 12,
      leadingDistribution: TextLeadingDistribution.even);
}

TextStyle captionCommon(Color color) {
  return TextStyle(
      fontWeight: FontWeight.w400,
      fontSize: 12,
      color: color,
      height: 16 / 12,
      leadingDistribution: TextLeadingDistribution.even);
}

TextStyle captionMiniPoint(Color color) {
  return TextStyle(
      fontWeight: FontWeight.w500,
      fontSize: 10,
      color: color,
      height: 10 / 14,
      leadingDistribution: TextLeadingDistribution.even);
}