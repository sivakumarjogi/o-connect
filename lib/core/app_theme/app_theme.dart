import 'package:flutter/material.dart';
import 'package:o_connect/ui/utils/colors/colors.dart';

class AppTheme {
  static final lightThemeData = ThemeData(
    /// scaffold background color
    scaffoldBackgroundColor: AppColors.chatTabBGColor,

    /// color of a container
    cardColor: AppColors.textFieldEnableBackGroundLightColor,

    ///color of a lite text
    primaryColorLight: const Color(0xff303C63),

    /// All hint & disable text and border colors
    disabledColor: AppColors.drawerColor,

    /// presenters card color in create webinar
    primaryColor: const Color(0xff5E6272),

    /// List item background color
    splashColor: AppColors.textFieldBackGroundLightColor,

    /// All text field and headers
    hintColor: AppColors.selectBGMItemColor,
    primaryColorDark: AppColors.bgColor,

    /// Application font family
    fontFamily: 'Poppins',

    /// Dialog box background color
    hoverColor: const Color(0xff11284b),

    /// Dialog box header bar color
    shadowColor: const Color(0xff5177af),

    /// timer popup card background
    highlightColor: AppColors.whiteColor,

    ///TabBar indicator color
    focusColor: const Color(0xff2D7EC1),

    /// create webinar select item background color
    secondaryHeaderColor: AppColors.darkBlackColor,
    textTheme: const TextTheme(),

    indicatorColor: const Color(0xff242526),
    //cardColor: const Color(0xffffffff),
    //primaryColorLight: const Color(0xffFFFEF7),
    // dialogBackgroundColor: const Color(0xffFFFFFF),
    // canvasColor: const Color(0xffffffff),
    // canvasColor: const Color(0xff254171),
  );

  static final darkThemeData = ThemeData(
    brightness: Brightness.dark,

    /// scaffold background color
    scaffoldBackgroundColor: const Color(0xff0C0D0E),

    primaryColorDark: const Color(0xff5E6272),

    dividerColor: const Color(0xff292B2C),

    /// All hint & disable text and border colors
    disabledColor: const Color(0xff202223),

    /// presenters card color in create webinar
    primaryColor: const Color(0xff292B2C),

    /// List item background color
    splashColor: AppColors.textFieldEnableBackGroundDarkColor,

    /// Application font family
    fontFamily: 'Poppins',

    /// All text field and headers
    hintColor: AppColors.whiteColor,

    /// Dialog box background color
    hoverColor: AppColors.whiteColor,

    /// Dialog box header bar color
    shadowColor: AppColors.whiteColor,

    /// timer popup card background
    highlightColor: const Color(0xff333664),

    ///TabBar indicator color
    focusColor: const Color(0xff48BAFF),

    ///background color of a container

    /// create webinar select item background color
    secondaryHeaderColor: const Color(0xff292B2C),

    indicatorColor: const Color(0xffF5F5F5),
    // cardColor: const Color(0xff2D7EC1),
    // canvasColor: const Color(0xff254171),
    //dialogBackgroundColor: const Color(0xff242526),
    //primaryColorLight: const Color(0xff3A3B3C),
    //dividerColor: const Color(0xff242526),

    ///color of a lite text
    primaryColorLight: const Color(0xff8F93A3),

    /// color of a container
    cardColor: const Color(0xff16181A),
  );
}
