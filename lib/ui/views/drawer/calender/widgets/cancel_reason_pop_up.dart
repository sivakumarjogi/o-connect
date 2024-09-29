import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:lottie/lottie.dart';
import 'package:o_connect/ui/utils/buttons_helper/custom_botton.dart';
import 'package:o_connect/ui/utils/colors/colors.dart';
import 'package:o_connect/ui/utils/custom_show_dialog_helper/custom_show_dialog.dart';
import 'package:o_connect/ui/utils/custom_toast_helper/custom_toast.dart';
import 'package:o_connect/ui/utils/textfield_helper/app_fonts.dart';
import 'package:o_connect/ui/utils/textfield_helper/common_textfield.dart';
import 'package:o_connect/ui/views/authentication/Auth_providers/auth_api_provider.dart';
import 'package:o_connect/ui/views/home_screen/home_screen_provider/home_screen_provider.dart';
import 'package:provider/provider.dart';
import '../../../../utils/images/images.dart';

class CancelReasonPopUp extends StatelessWidget {
  const CancelReasonPopUp({super.key, required this.controller, required this.events});
  final TextEditingController controller;
  final dynamic events;

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: true,
      onPopInvoked: (didPop) {
        controller.clear();
      },
      child: Column(mainAxisSize: MainAxisSize.min, crossAxisAlignment: CrossAxisAlignment.start, children: [
        showDialogCustomHeader(context, headerTitle: "Cancel Meeting"),
        Padding(
          padding: EdgeInsets.only(left: 16.w, bottom: 10.h),
          child: Text(
            "Reason to cancel the meeting",
            style: w400_14Poppins(color: Theme.of(context).disabledColor),
          ),
        ),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 16.w),
          child: CommonTextFormField(
            controller: controller,
            maxLines: 4,
            maxLength: 150,
            fillColor: Theme.of(context).primaryColor,
            hintText: "Test Here...",
            style: w400_14Poppins(color: Theme.of(context).primaryColorLight),
          ),
        ),
        height15,
        Consumer<HomeScreenProvider>(builder: (context, homeScreenProvider, child) {
          return homeScreenProvider.cancelMeeting
              ? Align(
                  alignment: Alignment.center,
                  child: SizedBox(
                      height: 20.w,
                      width: 20.w,
                      child: Lottie.asset(AppImages.loadingJson,
                          height: 40.w, width: 40.w) /*const CircularProgressIndicator(
                            color: AppColors.mainBlueColor,
                          )*/
                      ),
                )
              : Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    CustomButton(
                      buttonText: "Cancel",
                      buttonColor: Colors.transparent,
                      borderColor: AppColors.mainBlueColor,
                      buttonTextStyle: w600_14Poppins(color: Colors.white),
                      width: 85.w,
                      height: 32.h,
                      onTap: () {
                        controller.clear();
                        Navigator.pop(context);
                      },
                    ),
                    width15,
                    CustomButton(
                      buttonText: "Ok",
                      width: 85.w,
                      height: 32.h,
                      buttonTextStyle: w600_14Poppins(color: Colors.white),
                      onTap: () {
                        print("the events $events");
                        if (controller.text.isNotEmpty) {
                          homeScreenProvider.deleteMeeting(
                              meetingId: events ?? "",
                              reason: controller.text,
                              userName: Provider.of<AuthApiProvider>(context, listen: false).profileData!.data!.emailId!.toString(),
                              context: context,
                              fromCalender: true);
                          controller.clear();
                          FocusScope.of(context).unfocus();
                        } else {
                          CustomToast.showErrorToast(msg: "Cancel Statement is required");
                        }
                      },
                    )
                  ],
                );
        }),
        height15,
      ]),
    );
  }
}
