import 'package:blood_sugar_tracking/constants/colors.dart';
import 'package:flutter/material.dart';

import '../utils/device/size_config.dart';
import 'font_family.dart';

class AppTheme {
  static ThemeData lightTheme = ThemeData(
      primaryColor: Color(0xFF0F1049),
      scaffoldBackgroundColor: Colors.white,
      fontFamily: FontFamily.IBMPlexSans,
      //this changes the colour
      hintColor: Colors.grey,
     
     );

  static ThemeData darkTheme = ThemeData(
    primaryColor: Colors.black,
    scaffoldBackgroundColor: Colors.grey[900],
    // Các thuộc tính khác của theme
    // ...
  );

  static final TextStyle appBodyTextStyle = TextStyle(
    color: AppColors.AppColor4,
    fontWeight: FontWeight.w600,
    decoration: TextDecoration.none,
    fontSize: TextSizeConfig.getAdjustedFontSize(12),
    fontFamily: FontFamily.IBMPlexSans,
  );
  static final TextStyle appBodyTextStyle36 = TextStyle(
    color: AppColors.AppColor4,
    fontWeight: FontWeight.w600,
    decoration: TextDecoration.none,
    height: 0.95,
    fontSize: TextSizeConfig.getAdjustedFontSize(36),
    fontFamily: FontFamily.IBMPlexSans,
  );
  static final TextStyle timeText = TextStyle(
    color: Colors.black,
    fontWeight: FontWeight.w500,
    decoration: TextDecoration.none,
    // height: 0.95,
    fontSize: TextSizeConfig.getAdjustedFontSize(10),
    fontFamily: FontFamily.IBMPlexSans,
  );

  static final TextStyle statusTxt = TextStyle(
    color: Colors.black,
    fontWeight: FontWeight.w900,
    decoration: TextDecoration.none,
    // height: 0.95,
    fontSize: TextSizeConfig.getAdjustedFontSize(12),
    fontFamily: FontFamily.IBMPlexSans,
  );

  static final TextStyle BtnText = TextStyle(
    color: Colors.white,
    fontWeight: FontWeight.w500,
    decoration: TextDecoration.none,
    // height: 0.95,
    fontSize: TextSizeConfig.getAdjustedFontSize(16),
    fontFamily: FontFamily.IBMPlexSans,
  );
  static final TextStyle Headline16Text = TextStyle(
    color: Colors.white,
    fontWeight: FontWeight.w800,
    decoration: TextDecoration.none,
    // height: 0.95,
    fontSize: TextSizeConfig.getAdjustedFontSize(16),
    fontFamily: FontFamily.IBMPlexSans,
  );

  static final TextStyle Headline20Text = TextStyle(
    color: Colors.white,
    fontWeight: FontWeight.w800,
    decoration: TextDecoration.none,
    // height: 0.95,
    fontSize: TextSizeConfig.getAdjustedFontSize(16),
    fontFamily: FontFamily.IBMPlexSans,
  );

  static final TextStyle hintText = TextStyle(
    color: AppColors.hintTextColor,
    fontWeight: FontWeight.w400,
    decoration: TextDecoration.none,
    // height: 0.95,
    fontSize: TextSizeConfig.getAdjustedFontSize(16),
    fontFamily: FontFamily.IBMPlexSans,
  );

  static final TextStyle sugarInputText = TextStyle(
    color: Colors.black,
    fontWeight: FontWeight.w600,
    decoration: TextDecoration.none,
    // height: 0.95,
    fontSize: TextSizeConfig.getAdjustedFontSize(32),
    fontFamily: FontFamily.IBMPlexSans,
  );

  static final TextStyle errorText = TextStyle(
    color: Colors.red,
    fontWeight: FontWeight.w500,
    decoration: TextDecoration.none,
    // height: 0.95,
    fontSize: TextSizeConfig.getAdjustedFontSize(12),
  );

  static final TextIntroline16Text = TextStyle(
    color: Colors.white,
    fontWeight: FontWeight.w600,
    decoration: TextDecoration.none,
    // height: 0.95,
    fontSize: TextSizeConfig.getAdjustedFontSize(16),
    fontFamily: FontFamily.IBMPlexSans,
  );
}
