import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:o_connect/my_app.dart';

class AppColors {
  static const Color bgColor = Color(0xffF7F8FB);
  static const Color mainTextColor = Color(0xff101827);
  static const Color filterBg= Color(0xff202223);

  // savita
  static const Color calendarBg = Color(0xff16181A);
  static const Color calendarBg2 = Color(0xff5E6272);
  static const Color statusButtonCa = Color(0xff12B22E);



  static const Color statusButtonBl = Color(0xff3162F9);
  static const Color statusButtonBl2 = Color(0xff6a89e8);
  static const Color statusButtonBlMore = Color(0xff3B3BF9);
  static const Color statusButtonBlDark = Color(0xff10E0F9);
  static const Color statusButtonWh = Color(0xffFFFFFF);

  static const Color statusButtonPin = Color(0xffFF027A);
  static const Color statusButtonPinMore = Color(0xffF26DFF);


  static const Color statusButtonGreen = Color(0xff10994D);
  static const Color statusButtonGreenMore = Color(0xff00FF79);

  // YELLOW


  static const Color statusButtonYellow = Color(0xffFF5C00);
  static const Color statusButtonYellowMore = Color(0xffFFCA40);

  static const Color calendarWeekDay = Color(0xff5E6272);
  static const Color calendarWeekHide = Color(0xff292B2C);
  static const Color calendarMonthText = Color(0xff0E78F9);
  static const Color editTextColors = Color(0xff315D92);
  static const Color redColors = Color(0xffFF5959);

  /// dark theme
  static const Color darkBlackColor = Color(0xff000000);
  static const Color darkWhiteColor = Color(0xffFFFFFF);
  static const Color scaffoldBackGroundDarkColor = Color(0xff10182F);
  static const Color textFieldBackGroundDarkColor = Color(0xff1B2441);
  static const Color textFieldEnableBackGroundDarkColor = Color(0xff10182F);
  static const Color mediumBG = Color(0xff232547);

  // static const Color drawerBottomTextDarkColor = Color(0xff353d54);
  // static const Color drawerBottomTextLightColor = Color(0xff10182F);

  /// light theme
  static const Color lightBlackColor = Color(0xff000000);
  static const Color lightWhiteColor = Color(0xffFFFFFF);
  static const Color scaffoldBackGroundLightColor = Color(0xffFFFFFF);
  static const Color textFieldBackGroundLightColor = Color(0xffE1E4EF);
  static const Color textFieldEnableBackGroundLightColor = Color(0xffEEEFF6);

  ///common colors
  static const Color buttonsBackGroundColor = Color(0xff1D9BF0);
  static const Color borderEnableLightColor = Color(0xff45474b);
  static const Color borderEnableDarkColor = Color(0xff3c88d3);
  static const Color commonTextButtonColor = Color(0xff398ada);
  static const Color haveAnAccountButtonColor = Color(0xff757577);
  static const Color calendarIconColor = Color(0xff0E78F9);
  static const Color popUpBGColor = Color(0xff1C1E38);
  static const Color textBGColor = Color(0xff333664);

  // static const Color bgColor = Color(0xffDBEBFF);
  static const Color mainBlueColor = Color(0xff0DA0FF);
  static Color textColor = const Color(0xff051127);
  static Color blackColor = const Color(0xff000000);
  static Color chatTabBGColor = const Color(0xffF6FAFF);
  static Color chatEditMenuBGColor = const Color(0xff35426A);
  static Color privateChatEditMenuBGColor = const Color(0xffEEF0FF);
  static Color paragraphColor = const Color(0xff858FA9);
  static Color lightDarkColor = const Color(0xff9296A5);
  static Color secondColor = const Color(0xff2fD08B);
  static const Color whiteColor = Color(0xffFFFFFF);
  static Color inputStrokeColor = const Color(0xffD8D9DC);
  static Color errorsColor = const Color(0xffFC3C67);
  static Color bgStrokeColor = const Color(0xffEEEFF3);
  static const Color drawerColor = Color(0xff3B5782);
  static const Color webinarAppBarBackgroundColor = Color(0xffDBEBFF);
  static const Color whiteLightColor = Color.fromARGB(255, 240, 245, 250);
  static const Color whiteLight2Color = Color(0xffEEF0FF);
  static const Color appmainThemeColor = Color(0xff3B5782);
  static const Color addQuestionColor = Color(0xff30748a);
  static const Color pushLinkBGColor = Color(0xff4F5570);
  static const Color callToActionBGColor = Color(0xffF4F3F3);
  static const Color orangeRedColor = Color(0xffFF4C38);
  static const Color liteBgColor = Color(0xffE1E4EF);
  static Color lightBgColor = const Color.fromARGB(255, 240, 245, 250);
  static Color greyBgColor = const Color(0xffEEF0FF);
  static Color blueColor = const Color(0xff17468E);
  static Color selectBGMItemColor = const Color(0xff0C1330);

  static const Color fontBody = Color(0xff3B5782);
  static const Color buttonBgColor = Color(0xffc5e9f5);
  static const Color dashboardButtonColor = Color(0xff6049EF);
  static const Color dashboardGreenColor = Color(0xFF00C146);
  static const Color dashboardAmberColor = Color(0xFFFFAB00);
  static const Color dashboardPurpleColor = Color(0xFF9C43F0);
  static const Color customButtonBlueColor = Color(0xff0E78F9);
  static const Color bottomSheetColor = Color.fromARGB(255, 8, 16, 34);
  static ColorScheme? datePickerThemeColorScheme = ColorScheme.light(
          primary: Theme.of(navigationKey.currentContext!).disabledColor,
          onPrimary: Theme.of(navigationKey.currentContext!).primaryColorLight,
          background: Theme.of(navigationKey.currentContext!).primaryColorLight,
          onBackground: Theme.of(navigationKey.currentContext!).scaffoldBackgroundColor,
          surface: Theme.of(navigationKey.currentContext!).primaryColor,
          onSurface: Theme.of(navigationKey.currentContext!).primaryColorLight)
      .copyWith(background: Theme.of(navigationKey.currentContext!).primaryColor);
}

class LightThemeColors {
  static const Color textFieldColor = Color(0xffEEF0FF);

  //DRAWER
  static const Color mainInnerSelected = Color(0xffEEF0FF);
  static const Color mainSelected = Color(0xffDBEBFF);
  static const Color appbarTextColor = Colors.white;
  static const Color borderColor = Color(0xFFD8F1FF);
  static const Color greyBorderColor = Color(0xffEEEEEE);
  static const Color fillColor = Color(0xffffffff);
  //dark swatch
  static const Color blue = Color(0xff1D9BF0);
  static const Color accentColor = Color(0xFFD9EDE1);

  //SCAFFOLD
  static const Color scaffoldBackgroundColor = Color(0xffF2F7FF);
  static const Color backgroundColor = Color(0xffF2F7FF);
  static const Color dividerColor = Color(0xffE6ECF6);
  static const Color cardColor = Color(0xfffafafa);

  //ICONS
  static const Color appBarIconsColor = Colors.white;
  static const Color iconColor = Colors.black;

  static const Color buttonTextColor = Colors.white;
  static const Color buttonDisabledColor = Colors.grey;
  static const Color buttonDisabledTextColor = Colors.black;

  //TEXT
  static const Color bodyTextColor = Color(0xff424855);
  static const Color headlinesTextColor = Color(0xff424855);
  static const Color captionTextColor = Color(0xff424855);
  static const Color hintTextColor = Color(0xff9296A5);

  static const Color chipTextColor = Colors.white;
  static const Color greyTextColor = Color(0xff5B678E);

  // progress bar indicator
  static const Color progressIndicatorColor = Color(0xFF40A76A);

  //SNACKBAR
  static const Color greenSnackbar = Color(0xff007829);
  static const Color redSnackbar = Color(0xffffffff);
  static const Color barChartBorderColor = Color(0xffE5E5EF);

  //darktheme
  static const Color BGColor = Color(0xff0A0C18);
  static const Color liteBlueColor = Color(0x000000ff);
}

class TextColor {
  static const Color fontBig = Color(0xff17468E);
  static const Color fontBody = Color(0xff3B5782);
}

SizedBox height5 = SizedBox(
  height: 5.h,
);
SizedBox height8 = SizedBox(
  height: 8.h,
);
SizedBox height10 = SizedBox(
  height: 10.h,
);
SizedBox height15 = SizedBox(
  height: 15.h,
);
SizedBox height20 = SizedBox(
  height: 20.h,
);
SizedBox height30 = SizedBox(
  height: 30.h,
);
SizedBox height40 = SizedBox(
  height: 40.h,
);
SizedBox height50 = SizedBox(
  height: 50.h,
);
SizedBox height70 = SizedBox(
  height: 70.h,
);
SizedBox width5 = SizedBox(
  width: 5.w,
);
SizedBox width10 = SizedBox(
  width: 10.w,
);
SizedBox width15 = SizedBox(
  width: 15.w,
);
SizedBox width20 = SizedBox(
  width: 20.w,
);
SizedBox width30 = SizedBox(
  width: 30.w,
);
SizedBox width40 = SizedBox(
  width: 40.w,
);
SizedBox width50 = SizedBox(
  width: 50.w,
);
SizedBox width55 = SizedBox(
  width: 55.w,
);
SizedBox width60 = SizedBox(
  width: 60.w,
);
