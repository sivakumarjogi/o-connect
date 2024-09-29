import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:o_connect/core/providers/common_provider.dart';
import 'package:o_connect/ui/utils/colors/colors.dart';
import 'package:o_connect/ui/utils/textfield_helper/app_fonts.dart';
import 'package:provider/provider.dart';

import '../../views/themes/providers/webinar_themes_provider.dart';

Future<dynamic> customShowDialog(
  BuildContext context,
  Widget dialogWidget, {
  double? height,
  CommonProvider? commonProvider,
  Color? color,
  RouteSettings? routeSettings,
  bool enableDrag = false,
  bool isDismissible = true,
  Color? backGroundColor,
}) {
  return showModalBottomSheet(
      isDismissible: isDismissible,
      isScrollControlled: true,
      routeSettings: routeSettings,
      enableDrag: enableDrag,
      backgroundColor: backGroundColor ?? Theme.of(context).scaffoldBackgroundColor,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          topRight: Radius.circular(24.r),
          topLeft: Radius.circular(24.r),
        ),
      ),
      context: context,
      builder: (context) {
        return Padding(
          padding: EdgeInsets.only(
            bottom: MediaQuery.of(context).viewInsets.bottom,
          ),
          child: SizedBox(
            height: height,
            child: dialogWidget,
          ),
        );
      }).whenComplete(() {
    // commonProvider?.updateSelectedSound();
  });
}

Future<void> showAlertDialog(
  BuildContext context, {
  Widget? title,
  Widget? body,
  Color? backgrounColor,
}) async {
  return showDialog<void>(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        elevation: 0,
        insetPadding: EdgeInsets.zero,
        titlePadding: EdgeInsets.zero,
        actionsPadding: EdgeInsets.zero,
        contentPadding: EdgeInsets.symmetric(horizontal: 7.w),
        title: title,
        content: body,
        backgroundColor: Colors.transparent,
      );
    },
  );
}

Widget showDialogCustomHeader(BuildContext context, {required String headerTitle, bool removeDivider = false, Color? headerColor, bool backNavigationRequired = true, VoidCallback? backButtonFuc}) {
  return Consumer<WebinarThemesProviders>(builder: (context, webinarThemesProviders, __) {
    // webinarThemesProviders.setupDefaultColors();
    return Container(
      decoration: BoxDecoration(
          // color: headerColor ?? webinarThemesProviders.colors.headerColor,
          borderRadius: BorderRadius.only(
        topRight: Radius.circular(20.r),
        topLeft: Radius.circular(20.r),
      )),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          height20,
          Align(
            alignment: Alignment.center,
            child: Container(
              height: 5.h,
              width: 100.w,
              decoration: BoxDecoration(borderRadius: BorderRadius.circular(20.r), color: const Color(0xff202223)),
            ),
          ),
          height10,
          Padding(
            padding: EdgeInsets.all(8.0.sp),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  headerTitle,
                  style: w500_14Poppins(color: Theme.of(context).hoverColor),
                ),
                if (backNavigationRequired)
                  GestureDetector(
                    onTap: backButtonFuc ??
                        () {
                          Navigator.pop(context);
                        },
                    child: Container(
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: Theme.of(context).primaryColorLight,
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(4.0),
                        child: Icon(
                          Icons.close,
                          size: 18,
                          color: Theme.of(context).scaffoldBackgroundColor,
                        ),
                      ),
                    ),
                  )
              ],
            ),
          ),
          removeDivider
              ? const SizedBox.shrink()
              : Padding(
                  padding: EdgeInsets.symmetric(horizontal: 12.w),
                  child: const Divider(),
                ),
        ],
      ),
    );
  });
}
