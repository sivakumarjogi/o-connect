import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:o_connect/core/screen_configs.dart';
import 'package:o_connect/ui/utils/buttons_helper/custom_botton.dart';
import 'package:o_connect/ui/utils/colors/colors.dart';
import 'package:o_connect/ui/utils/custom_show_dialog_helper/custom_show_dialog.dart';
import 'package:o_connect/ui/utils/custom_toast_helper/custom_toast.dart';
import 'package:o_connect/ui/utils/textfield_helper/app_fonts.dart';
import 'package:o_connect/ui/utils/textfield_helper/common_textfield.dart';
import 'package:o_connect/ui/views/drawer/library_revamp/library_revamp_provider.dart';
import 'package:oes_chatbot/utils/custom_text_form_fied.dart';
import 'package:oes_chatbot/utils/extensions/sizedbox_extension.dart';
import 'package:provider/provider.dart';

Future<void> showCreateFolder(BuildContext context) async {
  showAlertDialog(context, body: CreateFolderPopUp());
}

class CreateFolderPopUp extends StatelessWidget {
  CreateFolderPopUp({super.key});
  final TextEditingController textEditingController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      titlePadding: EdgeInsets.zero,
      insetPadding: EdgeInsets.all(10.sp),
      contentPadding: EdgeInsets.zero,
      clipBehavior: Clip.antiAliasWithSaveLayer,
      title: Container(
        decoration: const BoxDecoration(
          color: Color(0xff202223),
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(0),
            topRight: Radius.circular(0),
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10).copyWith(
            top: 10,
            bottom: 10,
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "Create new folder",
                style: w500_14Poppins(
                  color: AppColors.whiteColor,
                ),
              ),
              GestureDetector(
                onTap: () {
                  Navigator.pop(context);
                },
                child: CircleAvatar(
                  backgroundColor: const Color.fromARGB(255, 110, 114, 121),
                  radius: 10,
                  child: Transform.rotate(
                      angle: 40,
                      child: Icon(
                        Icons.add,
                        color: Colors.black,
                        size: 15.sp,
                      )),
                ),
              ),
            ],
          ),
        ),
      ),
      backgroundColor: Theme.of(context).cardColor,
      elevation: 0,
      content: Consumer<LibraryRevampProvider>(
        builder: (context, provider, _) {
          return Padding(
            padding: EdgeInsets.all(12.0.sp),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                height10,
                SizedBox(
                  width: ScreenConfig.width * 1,
                  // height: ScreenConfig.height * 0.16,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      SizedBox(
                        // height: ScreenConfig.height * 0.1,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "Name",
                              style: w400_14Poppins(
                                color: AppColors.whiteColor,
                              ),
                            ),
                            7.h.height,
                            CommonTextFormField(
                              controller: textEditingController,
                              keyboardType: TextInputType.name,
                              borderColor: Theme.of(context).primaryColorDark,
                              fillColor: const Color(0x16181A),
                              hintText: "Enter Name here",
                              maxLength: 30,
                              validator: (value, String? f) {
                                if (value == null || value.trim() == '') {
                                  return 'Field cannot be empty';
                                } else if (value.length < 3 || value.length > 30) {
                                  return "Maximum 30 characters allowed";
                                }
                              },
                            )
                          ],
                        ),
                      ),
                      5.h.height,
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          CustomButton(
                            width: ScreenConfig.width * 0.37,
                            height: 33.h,
                            onTap: () async {
                              Navigator.pop(context);
                            },
                            buttonText: "Close",
                            buttonColor: const Color(0xff1B2632),
                            buttonTextStyle: TextStyle(fontSize: 13.w),
                          ),
                          width10,
                          CustomButton(
                            width: ScreenConfig.width * 0.37,
                            height: 33.h,
                            onTap: () async {
                              if (textEditingController.text.trim().isEmpty) {
                                CustomToast.showErrorToast(msg: "Folder name should not be empty");
                              }
                              await provider
                                  .createLibraryFolder(
                                folderName: textEditingController.text.trim(),
                                context: context,
                              )
                                  .then((value) {
                                Navigator.pop(context);
                              });
                            },
                            buttonText: "Create",
                            buttonTextStyle: TextStyle(fontSize: 13.w),
                            buttonColor: AppColors.customButtonBlueColor,
                          ),
                        ],
                      ),
                    ],
                  ),
                )
              ],
            ),
          );
        },
      ),
    );
  }
}
