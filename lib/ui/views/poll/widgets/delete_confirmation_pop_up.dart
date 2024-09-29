import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:o_connect/ui/utils/colors/colors.dart';
import 'package:provider/provider.dart';

import '../../../../core/screen_configs.dart';
import '../../../utils/buttons_helper/custom_botton.dart';
import '../../../utils/buttons_helper/custom_outline_button.dart';
import '../../../utils/custom_show_dialog_helper/custom_show_dialog.dart';
import '../../../utils/textfield_helper/app_fonts.dart';
import '../../themes/providers/webinar_themes_provider.dart';

class DeleteConfirmationPopUp extends StatelessWidget {
  const DeleteConfirmationPopUp({super.key, this.onTap});
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(borderRadius: BorderRadius.only(topLeft: Radius.circular(5.sp),topRight: Radius.circular(5.sp))),
      height: ScreenConfig.height * 0.25,
      child: Column(crossAxisAlignment: CrossAxisAlignment.center, children: [
        showDialogCustomHeader(context, headerTitle: "Delete Poll", removeDivider: false),
        height10,
         Text("Do you want to delete this poll?",style:  w400_14Poppins(color: Colors.white),),
        height10,
        Consumer<WebinarThemesProviders>(builder: (context, webinarThemesProvider, child) {
          return Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              CustomOutlinedButton(
                outLineBorderColor:Provider.of<WebinarThemesProviders>(context).unSelectButtonsColor,
                height: 35.h,
                color: Provider.of<WebinarThemesProviders>(context).unSelectButtonsColor,
                width: MediaQuery.of(context).size.width/2-30.sp,
                buttonTextStyle: w400_13Poppins(color: Colors.white),
                buttonText: "No",
                onTap: () {
                  Navigator.pop(context);
                },
              ),
              width10,
              CustomButton(
                buttonColor: webinarThemesProvider.themeHighLighter ?? AppColors.mainBlueColor,
                width: MediaQuery.of(context).size.width/2-30.sp,
                height: 35.h,
                buttonText: "yes",
                buttonTextStyle: w500_13Poppins(color: AppColors.whiteColor),
                onTap: onTap,
              )
            ],
          );
        })
      ]),
    );
  }
}
