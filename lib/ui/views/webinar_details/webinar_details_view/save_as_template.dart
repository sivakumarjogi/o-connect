import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:lottie/lottie.dart';
import 'package:o_connect/ui/views/home_screen/home_screen_provider/home_screen_provider.dart';
import 'package:provider/provider.dart';
import '../../../utils/buttons_helper/custom_botton.dart';
import '../../../utils/buttons_helper/custom_outline_button.dart';
import '../../../utils/colors/colors.dart';
import '../../../utils/constant_strings.dart';
import '../../../utils/custom_show_dialog_helper/custom_show_dialog.dart';
import '../../../utils/images/images.dart';
import '../../../utils/textfield_helper/app_fonts.dart';
import '../../../utils/textfield_helper/common_textfield.dart';
import '../../../utils/textfield_helper/textFieldTexts.dart';
import '../../authentication/form_validations.dart';
import '../webinar_details_model/meeting_details_model.dart';

class SaveAsTemplate extends StatefulWidget {
  SaveAsTemplate({Key? key, required this.dataList}) : super(key: key);

  final MeetingDetailsModel dataList;

  @override
  State<SaveAsTemplate> createState() => _SaveAsTemplateState();
}

class _SaveAsTemplateState extends State<SaveAsTemplate> {
  TextEditingController saveAsTemplateController = TextEditingController();

  final GlobalKey<FormState> _key = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Consumer<HomeScreenProvider>(builder: (context, homeScreenProvider, child) {
      return Form(
        key: _key,
        autovalidateMode: AutovalidateMode.onUserInteraction,
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.only(topRight: Radius.circular(24.r), topLeft: Radius.circular(24.r)),
            color: Theme.of(context).cardColor,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              showDialogCustomHeader(
                context,
                headerTitle: ConstantsStrings.saveAsTemplate,
              ),
              Padding(
                padding: EdgeInsets.all(10.sp),
                child: Container(
                  color: Theme.of(context).cardColor,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      height10,
                      Text(
                        ConstantsStrings.saveAsTemplateText,
                        style: w300_14Poppins(color: Theme.of(context).primaryColorLight),
                      ),
                      height20,
                      const TextFieldTexts(
                        name: ConstantsStrings.templateName,
                      ),
                      height10,
                      CommonTextFormField(
                        controller: saveAsTemplateController,
                        validator: (val, String? fieldName) {
                          return FormValidations.requiredFieldValidationInCreateWithMinimumCharecters(val, "Template name");
                        },
                        numberOfchars: 30,
                        hintText: "Template name",
                        style: w400_14Poppins(color: Colors.white),
                        keyboardType: TextInputType.text,
                        fillColor: Theme.of(context).cardColor,
                      )
                    ],
                  ),
                ),
              ),
              homeScreenProvider.saveTemplate
                  ? Lottie.asset(AppImages.loadingJson, height: 40.w, width: 40.w)
                  : Padding(
                      padding: EdgeInsets.only(right: 10.w, bottom: 5.h),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          CustomOutlinedButton(
                            color: const Color(0xff1B2632),
                            outLineBorderColor: Colors.transparent,
                            height: 35.h,
                            width: 150.w,
                            buttonTextStyle: w400_13Poppins(color: Colors.white),
                            buttonText: ConstantsStrings.cancel,
                            onTap: () {
                              Navigator.pop(context);
                            },
                          ),
                          width20,
                          CustomButton(
                              width: 150.w,
                              height: 35.h,
                              buttonText: ConstantsStrings.saveAsTemplate,
                              buttonTextStyle: w500_13Poppins(color: AppColors.whiteColor),
                              onTap: () {
                                FocusNode().unfocus();
                                if (_key.currentState!.validate()) {
                                  homeScreenProvider.saveMeetingTemplate(widget.dataList, saveAsTemplateController.text, context);
                                }
                              }),
                        ],
                      ),
                    ),
              height10,
            ],
          ),
        ),
      );
    });
  }
}

// import 'package:flutter/cupertino.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter/widgets.dart';
// import 'package:flutter_screenutil/flutter_screenutil.dart';
// import 'package:o_connect/core/screen_configs.dart';
// import 'package:o_connect/ui/utils/buttons_helper/custom_botton.dart';
// import 'package:o_connect/ui/utils/colors/colors.dart';
// import 'package:o_connect/ui/utils/custom_show_dialog_helper/custom_show_dialog.dart';
// import 'package:o_connect/ui/utils/custom_toast_helper/custom_toast.dart';
// import 'package:o_connect/ui/utils/textfield_helper/app_fonts.dart';
// import 'package:o_connect/ui/utils/textfield_helper/common_textfield.dart';
// import 'package:o_connect/ui/views/drawer/library_revamp/library_revamp_provider.dart';
// import 'package:o_connect/ui/views/home_screen/home_screen_provider/home_screen_provider.dart';
// import 'package:o_connect/ui/views/webinar_details/webinar_details_model/meeting_details_model.dart';
// import 'package:oes_chatbot/utils/custom_text_form_fied.dart';
// import 'package:oes_chatbot/utils/extensions/sizedbox_extension.dart';
// import 'package:provider/provider.dart';

// Future<void> saveAsTemple(BuildContext context) async {
//   showAlertDialog(context, body: SaveAsTemplate());
// }

// class SaveAsTemplate extends StatelessWidget {
//   SaveAsTemplate({super.key, this.dataList});
//   final TextEditingController textEditingController = TextEditingController();
//   MeetingDetailsModel? dataList;

//   @override
//   Widget build(BuildContext context) {
//     return AlertDialog(
//       titlePadding: EdgeInsets.zero,
//       insetPadding: EdgeInsets.all(12.sp),
//       contentPadding: EdgeInsets.zero,
//       clipBehavior: Clip.antiAliasWithSaveLayer,
//       title: Container(
//         decoration: const BoxDecoration(
//           color: Color(0xff202223),
//           borderRadius: BorderRadius.only(
//             topLeft: Radius.circular(10),
//             topRight: Radius.circular(10),
//           ),
//         ),
//         child: Padding(
//           padding: const EdgeInsets.symmetric(horizontal: 10).copyWith(
//             top: 10,
//             bottom: 10,
//           ),
//           child: Row(
//             mainAxisAlignment: MainAxisAlignment.spaceBetween,
//             children: [
//               Text(
//                 "Save As",
//                 style: w500_14Poppins(
//                   color: AppColors.whiteColor,
//                 ),
//               ),
//               GestureDetector(
//                 onTap: () {
//                   Navigator.pop(context);
//                 },
//                 child: CircleAvatar(
//                   backgroundColor: const Color.fromARGB(255, 110, 114, 121),
//                   radius: 10,
//                   child: Transform.rotate(
//                       angle: 40,
//                       child: Icon(
//                         Icons.add,
//                         color: Colors.black,
//                         size: 15.sp,
//                       )),
//                 ),
//               ),
//             ],
//           ),
//         ),
//       ),
//       backgroundColor: Theme.of(context).cardColor,
//       elevation: 0,
//       content: Consumer<HomeScreenProvider>(
//         builder: (context, provider, _) {
//           return Padding(
//             padding: EdgeInsets.all(12.0.sp),
//             child: Column(
//               mainAxisSize: MainAxisSize.min,
//               children: [
//                 height10,
//                 SizedBox(
//                   width: ScreenConfig.width * 1,
//                   // height: ScreenConfig.height * 0.16,
//                   child: Column(
//                     mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                     children: [
//                       SizedBox(
//                         // height: ScreenConfig.height * 0.1,
//                         child: Column(
//                           crossAxisAlignment: CrossAxisAlignment.start,
//                           children: [
//                             Text(
//                               "Name",
//                               style: w400_14Poppins(
//                                 color: AppColors.whiteColor,
//                               ),
//                             ),
//                             7.h.height,
//                             CommonTextFormField(
//                               controller: textEditingController,
//                               keyboardType: TextInputType.name,
//                               borderColor: Theme.of(context).primaryColorDark,
//                               fillColor: const Color(0x16181A),
//                               hintText: "Enter Name here",
//                               validator: (value, String? f) {
//                                 if (value == null || value.trim() == '') {
//                                   return 'Field cannot be empty';
//                                 } else if (value.length < 3 || value.length > 30) {
//                                   return "Maximum 30 characters allowed";
//                                 }
//                               },
//                             )
//                           ],
//                         ),
//                       ),
//                       5.h.height,
//                       Row(
//                         mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//                         children: [
//                           CustomButton(
//                             width: ScreenConfig.width * 0.37,
//                             height: 33.h,
//                             onTap: () async {
//                               Navigator.pop(context);
//                             },
//                             buttonText: "Close",
//                             buttonColor: const Color(0xff1B2632),
//                             buttonTextStyle: TextStyle(fontSize: 13.w),
//                           ),
//                           width10,
//                           CustomButton(
//                             width: ScreenConfig.width * 0.37,
//                             height: 33.h,
//                             onTap: () async {
//                               if (textEditingController.text.trim().isEmpty) {
//                                 CustomToast.showErrorToast(msg: "Folder name should not be empty");
//                                 return;
//                               }
//                               FocusNode().unfocus();

//                               provider.saveMeetingTemplate(dataList!, textEditingController.text, context);

//                               Navigator.pop(context);
//                             },
//                             buttonText: "Save As",
//                             buttonTextStyle: TextStyle(fontSize: 13.w),
//                             buttonColor: AppColors.customButtonBlueColor,
//                           ),
//                         ],
//                       ),
//                     ],
//                   ),
//                 )
//               ],
//             ),
//           );
//         },
//       ),
//     );
//   }
// }
