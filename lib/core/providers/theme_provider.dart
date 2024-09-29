import 'package:flutter/material.dart';
import 'package:o_connect/core/app_theme/app_theme.dart';
import 'package:o_connect/core/providers/base_provider.dart';

class ThemeProvider extends BaseProvider {
  bool isLightTheme = true;
  ThemeData appTheme = AppTheme.darkThemeData;
  bool isLibrary = false;

  /// Setting Theme Values
  selectedTheme(bool val) {
    isLightTheme = !isLightTheme;
    changeTheme();
    notifyListeners();
  }

  changeValue(boolValue) {
    isLibrary = boolValue;
    notifyListeners();
  }

  /// Change Theme Function
  changeTheme() {
    if (isLightTheme == true) {
      appTheme = AppTheme.darkThemeData;
    } else {
      appTheme = AppTheme.darkThemeData;
    }
    print("App Theme ==>> ${appTheme}");
    notifyListeners();
  }
}
