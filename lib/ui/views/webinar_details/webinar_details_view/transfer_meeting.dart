import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:lottie/lottie.dart';
import 'package:o_connect/ui/utils/images/images.dart';
import 'package:provider/provider.dart';

import '../../../utils/buttons_helper/custom_botton.dart';
import '../../../utils/buttons_helper/custom_outline_button.dart';
import '../../../utils/colors/colors.dart';
import '../../../utils/constant_strings.dart';
import '../../../utils/custom_show_dialog_helper/custom_show_dialog.dart';
import '../../../utils/textfield_helper/app_fonts.dart';
import '../../../utils/textfield_helper/common_textfield.dart';
import '../../../utils/textfield_helper/textFieldTexts.dart';
import '../../authentication/form_validations.dart';
import '../../home_screen/home_screen_provider/home_screen_provider.dart';
import '../webinar_details_model/meeting_details_model.dart';

class TransferPopup extends StatelessWidget {
  TransferPopup({super.key, required this.dataList});

  final MeetingDetailsModel dataList;
  TextEditingController oMailAddressController = TextEditingController();
  final GlobalKey<FormState> _key = GlobalKey();

  @override
  Widget build(BuildContext context) {
    return Consumer<HomeScreenProvider>(builder: (_, homeScreenProvider, __) {
      return Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.only(
              topRight: Radius.circular(24.r), topLeft: Radius.circular(24.r)),
          color: Theme.of(context).cardColor,
        ),
        child: Form(
          key: _key,
          autovalidateMode: AutovalidateMode.onUserInteraction,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              showDialogCustomHeader(
                context,
                headerTitle: ConstantsStrings.transfer,
                headerColor: const Color(0xff202223),
              ),
              Padding(
                padding: EdgeInsets.all(10.sp),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    height10,
                    Text(
                      ConstantsStrings.transferText,
                      style: w300_14Poppins(
                          color: Theme.of(context).primaryColorLight),
                    ),
                    height20,
                    const TextFieldTexts(
                      name: ConstantsStrings.oMailAddress,
                    ),
                    height10,
                    CommonTextFormField(
                      fillColor: Theme.of(context).cardColor,
                      borderColor: Theme.of(context).primaryColorDark,
                      controller: oMailAddressController,
                      hintText: "Enter o-mail address",
                      style: w400_14Poppins(color: Theme.of(context).hintColor),
                      keyboardType: TextInputType.text,
                      onChanged: (val) {
                        bool isValid =
                            FormValidations.omailFieldValidation(val) != null
                                ? false
                                : true;
                        homeScreenProvider.setIsValidOMailIdToTransfer(isValid);
                      },
                      validator: (val, String? fieldName) {
                        return FormValidations.omailFieldValidation(val);
                      },
                    )
                  ],
                ),
              ),
              Padding(
                padding: EdgeInsets.only(right: 10.w, bottom: 5.h),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    CustomOutlinedButton(
                      height: 35.h,
                      width: 80.w,
                      buttonTextStyle: w400_13Poppins(color: Colors.white),
                      outLineBorderColor: Colors.transparent,
                      color: const Color(0xff1B2632),
                      buttonText: ConstantsStrings.cancel,
                      onTap: () {
                        Navigator.pop(context);
                      },
                    ),
                    width20,
                    homeScreenProvider.isMeetingTransfer == true
                        ? SizedBox(
                            width: 40.w,
                            height: 40.w,
                            child: Lottie.asset(AppImages.loadingJson),
                          )
                        : homeScreenProvider.isValidOMailIdToTransfer
                            ? CustomButton(
                                width: 80.w,
                                height: 35.h,
                                buttonText: ConstantsStrings.transfer,
                                buttonTextStyle:
                                    w500_13Poppins(color: AppColors.whiteColor),
                                onTap: () {
                                  if (_key.currentState!.validate()) {
                                    homeScreenProvider.transferMeetingData(
                                        dataList,
                                        oMailAddressController.text,
                                        context);
                                  }
                                  // Navigator.pop(context);
                                })
                            : CustomButton(
                                width: 80.w,
                                height: 35.h,
                                buttonText: ConstantsStrings.transfer,
                                buttonColor: Theme.of(context)
                                    .hintColor
                                    .withOpacity(0.5),
                                buttonTextStyle:
                                    w500_13Poppins(color: AppColors.whiteColor),
                              )
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
