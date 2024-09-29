import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:o_connect/core/models/default_user_data_model.dart';
import 'package:o_connect/core/providers/common_provider.dart';
import 'package:o_connect/core/providers/default_user_data_provider.dart';
import 'package:o_connect/core/screen_configs.dart';
import 'package:o_connect/ui/utils/buttons_helper/custom_botton.dart';
import 'package:o_connect/ui/utils/colors/colors.dart';
import 'package:o_connect/ui/utils/custom_show_dialog_helper/custom_show_dialog.dart';
import 'package:o_connect/ui/utils/set_as_default.dart';
import 'package:o_connect/ui/utils/textfield_helper/app_fonts.dart';
import 'package:o_connect/ui/utils/textfield_helper/common_textfield.dart';
import 'package:o_connect/ui/views/authentication/form_validations.dart';
import 'package:o_connect/ui/views/push_link/provider/push_link_provider.dart';
import 'package:o_connect/ui/views/themes/providers/webinar_themes_provider.dart';
import 'package:provider/provider.dart';
import '../../utils/constant_strings.dart';
import '../../utils/textfield_helper/textFieldTexts.dart';

class PushLinkPopup extends StatefulWidget {
  const PushLinkPopup({super.key});

  @override
  State<PushLinkPopup> createState() => _PushLinkPopupState();
}

class _PushLinkPopupState extends State<PushLinkPopup> {
  final _pushLinkFormKey = GlobalKey<FormState>();

  FocusNode urlFocusNode = FocusNode();
  late PushLinkProvider pushLinkProvider;

  @override
  void initState() {
    // TODO: implement initState
    pushLinkProvider = Provider.of<PushLinkProvider>(context, listen: false);
    // DefaultUserDataModel? defaultUserDataModel = context.read<DefaultUserDataProvider>().defaultUserDataModel;
    pushLinkProvider.initControllers(
      title: "",
      url: "",
    );
    // Future.delayed(
    //   Duration.zero,
    //   () {
    //     pushLinkProvider.toggleShowAsDefault(status: false);
    //   },
    // );
    super.initState();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    pushLinkProvider.disposeControllers();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer3<CommonProvider, PushLinkProvider, WebinarThemesProviders>(builder: (context, commonProvider, pushLinkProvider, webinarThemesProviders, child) {
      return Form(
        key: _pushLinkFormKey,
        child: Container(
          decoration: BoxDecoration(
            border: Border.all(color: webinarThemesProviders.colors.headerColor, width: 4.w),
            borderRadius: BorderRadius.only(topLeft: Radius.circular(25.r), topRight: Radius.circular(25.r)),
            color: webinarThemesProviders.colors.bodyColor,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              showDialogCustomHeader(context, headerTitle: "Push Link",backNavigationRequired: false),
              Padding(
                padding: EdgeInsets.only(left: 20.w, right: 20.w),
                child: Column(
                  children: [
                    const TextFieldTexts(
                      name: "URL",
                      textColor: Colors.white,
                    ),
                    CommonTextFormField(
                      validator: (val, String? f) {
                        return FormValidations.urlValidation(val);
                      },
                      controller: pushLinkProvider.pushLinkUrlController,
                      hintText: "Enter button url",
                      fillColor: Provider.of<WebinarThemesProviders>(context).bgColor,
                      onChanged: (value) {
                        pushLinkProvider.toggleShowAsDefault(status: value.isNotEmpty && pushLinkProvider.pushLinkTextController.text.isNotEmpty);
                      },
                    ),
                    height5,
                    const TextFieldTexts(
                      name: ConstantsStrings.buttontext,
                      textColor: Colors.white,
                    ),
                    CommonTextFormField(
                      validator: (val, String? f) {
                        return FormValidations.requiredFieldValidation(val, "Push link text");
                      },
                      controller: pushLinkProvider.pushLinkTextController,
                      hintText: "Enter button text",
                      fillColor: Provider.of<WebinarThemesProviders>(context).bgColor,
                      onChanged: (value) {
                        // pushLinkProvider.toggleShowAsDefault(
                        //   status: value.isNotEmpty && pushLinkProvider.pushLinkUrlController.text.isNotEmpty,
                        // );
                      },
                    ),
                    height10,
                    // SetAsDefault(
                    //   onChanged: (value) {
                    //     pushLinkProvider.toggleShowAsDefaultStatus(status: value ?? false);
                    //   },
                    //   showSetAsDefault: pushLinkProvider.showSetAsDefault,
                    //   status: pushLinkProvider.setAsDefaultStatus,
                    // )
                  ],
                ),
              ),
              Padding(
                padding: EdgeInsets.only(right: 20.w, bottom: 10.h, left: 20.w),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    // CustomButton(
                    //   width: 100.w,
                    //   height: 35.h,
                    //   buttonColor: Colors.transparent,
                    //   borderColor: Provider.of<WebinarThemesProviders>(context).colors.textColor,
                    //   buttonText: "Clear",
                    //   onTap: () {
                    //     pushLinkProvider.pushLinkUrlController.clear();
                    //     pushLinkProvider.pushLinkTextController.clear();
                    //     pushLinkProvider.toggleShowAsDefaultStatus();
                    //     // Navigator.pop(context);
                    //   },
                    //   buttonTextStyle: w500_14Poppins(color: Provider.of<WebinarThemesProviders>(context).colors.textColor),
                    // ),
                    // width15,
                    CustomButton(
                      width: ScreenConfig.width * 0.4,
                      height: 35.h,
                      buttonColor: Provider.of<WebinarThemesProviders>(context).closeButtonColor,
                      borderColor: Provider.of<WebinarThemesProviders>(context).closeButtonColor,
                      buttonText: "Close",
                      onTap: () {
                        pushLinkProvider.pushLinkUrlController.clear();
                        pushLinkProvider.pushLinkTextController.clear();
                        Navigator.pop(context);
                      },
                      buttonTextStyle: w500_14Poppins(color: Provider.of<WebinarThemesProviders>(context).colors.textColor),
                    ),
                    const Spacer(),
                    CustomButton(
                      width: ScreenConfig.width * 0.4,
                      height: 35.h,
                      buttonColor: Provider.of<WebinarThemesProviders>(context).colors.buttonColor ?? AppColors.mainBlueColor,
                      buttonText: "Publish",
                      onTap: () {
                        urlFocusNode.unfocus();
                        if (_pushLinkFormKey.currentState!.validate()) {
                          pushLinkProvider.setPushLink(context, pushLinkProvider.pushLinkTextController.text, pushLinkProvider.pushLinkUrlController.text);
                          /*      commonProvider.showPushLinkMethod();*/
                          /*  dashBoardCallToActionProvider
                              .showPushLinkDashBoard();*/
                          Navigator.pop(context);
                        }
                      },
                      buttonTextStyle: w500_14Poppins(color: AppColors.whiteColor),
                    ),
                  ],
                ),
              )
            ],
          ),
        ),
      );
    });
  }
}
