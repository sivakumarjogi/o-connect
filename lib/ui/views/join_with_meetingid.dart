import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import '../utils/colors/colors.dart';
import '../utils/constant_strings.dart';
import '../utils/custom_show_dialog_helper/custom_show_dialog.dart';
import '../utils/textfield_helper/app_fonts.dart';
import '../utils/textfield_helper/common_textfield.dart';
import 'authentication/form_validations.dart';
import 'home_screen/home_screen_provider/home_screen_provider.dart';

class JoinWithMeetingId extends StatefulWidget {
  const JoinWithMeetingId({super.key});

  @override
  State<JoinWithMeetingId> createState() => _JoinWithMeetingIdState();
}

class _JoinWithMeetingIdState extends State<JoinWithMeetingId> {
  TextEditingController joinMeetingController = TextEditingController();
  final GlobalKey<FormState> _key = GlobalKey<FormState>();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<HomeScreenProvider>(builder: (context, homeScreenProvider, child) {
      return Form(
        key: _key,
        autovalidateMode: AutovalidateMode.onUserInteraction,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            showDialogCustomHeader(context, headerTitle: ConstantsStrings.joinEvent),
            Padding(
              padding: EdgeInsets.all(10.sp),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // height10,
                  // Text(
                  //   ConstantsStrings.saveAsTemplateText,
                  //   style: w300_14Poppins(color: Theme.of(context).disabledColor),
                  // ),
                  // height20,
                  // const TextFieldTexts(
                  //   name: ConstantsStrings.joinEvent,
                  // ),
                  height10,
                  CommonTextFormField(
                    controller: joinMeetingController,
                    validator: (val, String? fieldName) {
                      return FormValidations.requiredFieldValidationInCreateWithMinimumCharecters(val, "Event ID");
                    },
                    numberOfchars: 30,
                    hintText: "Event ID",
                    style: w400_14Poppins(color: Colors.white),
                    keyboardType: TextInputType.text,
                    fillColor: Theme.of(context).primaryColor,
                  )
                ],
              ),
            ),
            // homeScreenProvider.saveTemplate
            //     ? Lottie.asset(AppImages.loadingJson, height: 40.w, width: 40.w)
            //     : Padding(
            //         padding: EdgeInsets.only(right: 10.w, bottom: 5.h),
            //         child: Row(
            //           mainAxisAlignment: MainAxisAlignment.end,
            //           children: [
            //             CustomOutlinedButton(
            //               height: 35.h,
            //               buttonTextStyle: w400_13Poppins(color: AppColors.mainBlueColor),
            //               buttonText: ConstantsStrings.cancel,
            //               onTap: () {
            //                 Navigator.pop(context);
            //               },
            //             ),
            //             width20,
            //             CustomButton(
            //                 width: 150.w,
            //                 height: 35.h,
            //                 buttonText: ConstantsStrings.joinEvent,
            //                 buttonTextStyle: w500_13Poppins(color: AppColors.whiteColor),
            //                 onTap: () {
            //                   FocusNode().unfocus();
            //                   if (_key.currentState!.validate()) {
            //                     print("hello siva kumar");
            //                   }
            //                 })
            //           ],
            //         ),
            //       ),
            height10,
          ],
        ),
      );
    });
  }
}
