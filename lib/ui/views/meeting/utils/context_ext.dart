import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:o_connect/my_app.dart';
import 'package:o_connect/ui/utils/custom_toast_helper/custom_toast.dart';
import 'package:o_connect/ui/utils/loading_helper/loading_indicator.dart';

extension MeetingContextExt on BuildContext {
  void showLoading() => Loading.indicator(this);

  /// should be called only if loading dialog is present, otherwise
  /// it will close the top most screen in the navigation stack
  void hideLoading() => Navigator.of(this).pop();

  void showErrorAndPop<T>(String message, [T? value]) {
    CustomToast.showErrorToast(msg: message).then((_) => Navigator.of(this).pop(value));
  }

  void push(Widget child) => Navigator.push(this, MaterialPageRoute(builder: (_) => child));

  void pop() => Navigator.of(this).pop();
}

extension HeightsExt on BuildContext {
  double get whiteboardHeight => MediaQuery.of(this).size.height - 270.h;
  double get bgmSheetHeight => MediaQuery.of(this).size.height * 0.7;
  double get presentationPopUpHeight => MediaQuery.of(this).size.height * 0.7;
}

extension HeightsIntExt on double {
  double get screenHeight => MediaQuery.of(navigationKey.currentContext!).size.height * this;
  double get screenWidth => MediaQuery.of(navigationKey.currentContext!).size.width * this;
}
