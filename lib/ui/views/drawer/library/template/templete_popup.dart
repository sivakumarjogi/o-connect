import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:o_connect/core/providers/library_provider.dart';
import 'package:o_connect/ui/views/pip_views/pip_global_navigation.dart';

import '../../../../utils/buttons_helper/custom_botton.dart';
import '../../../../utils/buttons_helper/custom_outline_button.dart';
import '../../../../utils/close_widget.dart';
import '../../../../utils/colors/colors.dart';
import '../../../../utils/constant_strings.dart';
import '../../../../utils/custom_show_dialog_helper/custom_show_dialog.dart';
import '../../../../utils/images/images.dart';
import '../../../../utils/textfield_helper/app_fonts.dart';
import '../../../../utils/textfield_helper/common_textfield.dart';
import '../../../../utils/textfield_helper/textFieldTexts.dart';
import '../../../webinar_details/webinar_details_view/upcoming_more_button.dart';
import '../../../webninar_dashboard/presentation/create_webinar/create_webinar_screen.dart';

class TemplatePopUp extends StatefulWidget {
  const TemplatePopUp(
      {super.key, required this.templateObject, required this.provider});

  final LibraryProvider provider;
  final dynamic templateObject;

  @override
  State<TemplatePopUp> createState() => _TemplatePopUpState();
}

class _TemplatePopUpState extends State<TemplatePopUp> {
  TextEditingController templateNameController = TextEditingController();

  @override
  void initState() {
    templateNameController.text = widget.templateObject["template_name"];
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        showDialogCustomHeader(context, headerTitle: "More"),
        Padding(
          padding:
              EdgeInsets.only(left: 10.w, right: 20.w, top: 10.h, bottom: 4.h),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Padding(
                padding: EdgeInsets.all(2.0.sp),
                child: Container(
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(8),
                      color: Theme.of(context).primaryColor),
                  child: Padding(
                    padding: EdgeInsets.all(8.sp),
                    child: BuildRowWidget(
                      text: "Edit",
                      imagepath: AppImages.templateEdit,
                      onTap: () {
                        Navigator.pop(context);
                        customShowDialog(
                            context,
                            EditTemplatePopup(
                                templatenameController: templateNameController,
                                templateObject: widget.templateObject,
                                provider: widget.provider));
                      },
                    ),
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsets.all(2.0.sp),
                child: Container(
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(8),
                      color: Theme.of(context).primaryColor),
                  child: Padding(
                    padding: EdgeInsets.all(8.sp),
                    child: BuildRowWidget(
                        text: "Delete",
                        imagepath: AppImages.templateDelete,
                        onTap: () {
                          Navigator.pop(context);
                          customShowDialog(
                              context,
                              DeleteTemplatePopup(
                                  templateObject: widget.templateObject,
                                  provider: widget.provider));
                        }),
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsets.all(2.0.sp),
                child: Container(
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(8),
                      color: Theme.of(context).primaryColor),
                  child: Padding(
                    padding: EdgeInsets.all(8.sp),
                    child: BuildRowWidget(
                        text: "Apply To",
                        imagepath: AppImages.templateApply,
                        onTap: () {
                          print(widget.templateObject.toString());
                          Navigator.of(context).pop;
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => PIPGlobalNavigation(
                                          childWidget: CreateWebinarScreen(
                                        templateObject: widget.templateObject,
                                        isEdit: false,
                                        eventId:
                                            widget.templateObject["meeting_id"],
                                      ))));
                        }),
                  ),
                ),
              ),
            ],
          ),
        ),
        const CloseWidget()
      ],
    );
  }
}

class EditTemplatePopup extends StatelessWidget {
  const EditTemplatePopup(
      {super.key,
      required this.templatenameController,
      required this.templateObject,
      required this.provider});

  final LibraryProvider provider;
  final dynamic templateObject;
  final TextEditingController templatenameController;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        showDialogCustomHeader(context, headerTitle: "Edit Template"),
        height10,
        Padding(
          padding: EdgeInsets.only(left: 20.w),
          child: const TextFieldTexts(name: "Template name"),
        ),
        height5,
        Padding(
          padding: EdgeInsets.only(left: 20.w, right: 15.w),
          child: CommonTextFormField(
            borderColor: Colors.grey,
            fillColor: Theme.of(context).primaryColor,
            controller: templatenameController,
            style: w400_14Poppins(color: Theme.of(context).hintColor),
            labelStyle: w400_14Poppins(color: Theme.of(context).hintColor),
            hintStyle: w400_14Poppins(color: Theme.of(context).hintColor),
            keyboardType: TextInputType.text,
            inputAction: TextInputAction.next,
          ),
        ),
        height20,
        Padding(
          padding: EdgeInsets.only(right: 20.w, bottom: 10.h),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              CustomOutlinedButton(
                height: 35.h,
                buttonTextStyle: w400_13Poppins(color: AppColors.mainBlueColor),
                buttonText: ConstantsStrings.cancel,
                onTap: () {
                  Navigator.pop(context);
                },
              ),
              width10,
              CustomButton(
                width: 140.w,
                height: 35.h,
                buttonText: "Update",
                buttonTextStyle: w500_13Poppins(color: AppColors.whiteColor),
                onTap: () async {
                  FocusNode().unfocus();
                  await provider.updateTemplate(
                      templateName: templatenameController.text.toString(),
                      templateID: templateObject["_id"],
                      context: context);
                },
              )
            ],
          ),
        )
      ],
    );
  }
}

class DeleteTemplatePopup extends StatelessWidget {
  const DeleteTemplatePopup(
      {super.key, required this.templateObject, required this.provider});

  final dynamic templateObject;
  final LibraryProvider provider;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: MediaQuery.of(context).viewInsets,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          showDialogCustomHeader(context, headerTitle: "Delete Template"),
          height10,
          Text(
            "Do you want to delete this template?",
            style: w400_15Poppins(color: Theme.of(context).hintColor),
          ),
          height20,
          Padding(
            padding: EdgeInsets.only(right: 20.w, bottom: 10.h),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                CustomOutlinedButton(
                  height: 35.h,
                  width: 100.w,
                  buttonTextStyle:
                      w400_13Poppins(color: AppColors.mainBlueColor),
                  buttonText: ConstantsStrings.cancel,
                  onTap: () {
                    Navigator.pop(context);
                  },
                ),
                width10,
                CustomButton(
                  width: 100.w,
                  height: 35.h,
                  buttonText: "Delete",
                  buttonTextStyle: w500_13Poppins(color: AppColors.whiteColor),
                  onTap: () async {
                    await provider.deleteParticularTemplate(
                        templateID: templateObject["_id"],
                        userId: templateObject["user_id"],
                        context: context);
                  },
                )
              ],
            ),
          )
        ],
      ),
    );
  }
}
