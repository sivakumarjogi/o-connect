import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';



class AppStyles {
  /// Method used to set portrait device orientation of the app
  static void setDeviceOrientationOfApp() {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
      /* DeviceOrientation.landscapeLeft,
      DeviceOrientation.landscapeRight*/
    ]);
  }

  /// Method used to set landscape device orientation of the app
  static void setLandScapeDeviceOrientationOfApp() {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.landscapeRight,
      DeviceOrientation.landscapeLeft,
    ]);
  }
}
