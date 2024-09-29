import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:o_connect/ui/utils/buttons_helper/custom_botton.dart';
import 'package:o_connect/ui/utils/colors/colors.dart';
import 'package:o_connect/ui/utils/constant_strings.dart';
import 'package:o_connect/ui/utils/custom_show_dialog_helper/custom_show_dialog.dart';
import 'package:o_connect/ui/utils/textfield_helper/app_fonts.dart';
import 'package:o_connect/ui/views/themes/providers/webinar_themes_provider.dart';
import 'package:provider/provider.dart';

class ScreenShareAlertPopup extends StatelessWidget {
  const ScreenShareAlertPopup({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<WebinarThemesProviders>(builder: (_, themes, __) {
      return Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          showDialogCustomHeader(context, headerTitle: "Screen Share"),
          height10,
          SafeArea(
            minimum: EdgeInsets.all(16.sp),
            child: Column(
              children: [
                Text(
                  ConstantsStrings.screenShareAlertTitle,
                  textAlign: TextAlign.center,
                  style: w500_16Poppins(color: AppColors.mainBlueColor),
                ),
                height10,
                Text(
                  ConstantsStrings.screenShareAlertContent,
                  textAlign: TextAlign.center,
                  style: w400_14Poppins(color:const Color(0xff8F93A3)),
                ),
                height10,
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    CustomButton(
                      buttonText: "Cancel",
                      buttonColor: Colors.transparent,
                      borderColor: themes.colors.textColor,
                      buttonTextStyle: w400_14Poppins(color: themes.colors.textColor),
                      width: MediaQuery.of(context).size.width/2-50.sp,
                      height: 32.h,
                      onTap: () => Navigator.pop(context, false),
                    ),
                    width15,
                    CustomButton(
                      buttonText: "Start Now",
                      width: MediaQuery.of(context).size.width/2-50.sp,
                      height: 32.h,
                      buttonColor: themes.colors.buttonColor,
                      buttonTextStyle: w400_14Poppins(color: Colors.white),
                      onTap: () => Navigator.of(context).pop(true),
                    )
                  ],
                ),
              ],
            ),
          ),
        ],
      );
    });
  }
}
