import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:o_connect/core/screen_configs.dart';
import 'package:o_connect/ui/utils/buttons_helper/custom_botton.dart';
import 'package:o_connect/ui/utils/colors/colors.dart';
import 'package:o_connect/ui/utils/constant_strings.dart';
import 'package:o_connect/ui/utils/custom_toast_helper/custom_toast.dart';
import 'package:o_connect/ui/utils/images/images.dart';
import 'package:o_connect/ui/utils/textfield_helper/app_fonts.dart';
import 'package:o_connect/ui/utils/textfield_helper/common_textfield.dart';
import 'package:o_connect/ui/views/authentication/Auth_providers/auth_api_provider.dart';
import 'package:o_connect/ui/views/authentication/form_validations.dart';
import 'package:o_connect/ui/views/authentication/otp/widgets/back_to_login.dart';
import 'package:o_connect/ui/views/authentication/signin_signup/register_login.dart';
import 'package:provider/provider.dart';

import '../otp/widgets/otp_input_feild.dart';

class ForgotPasswordOtpScreen extends StatefulWidget {
  const ForgotPasswordOtpScreen({Key? key, required this.email}) : super(key: key);
  final String email;

  @override
  State<ForgotPasswordOtpScreen> createState() => _ForgotPasswordOtpScreenState();
}

class _ForgotPasswordOtpScreenState extends State<ForgotPasswordOtpScreen> {
  final _formKey = GlobalKey<FormState>();
  String? otp;

  late AuthApiProvider authApiProvider;
  final controller = TextEditingController();
  final focusNode = FocusNode();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    authApiProvider = Provider.of<AuthApiProvider>(context, listen: false);
  }

  @override
  void dispose() {
    controller.dispose();
    focusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: const Icon(
            Icons.arrow_back_ios,
            color: Colors.white,
          ),
        ),
      ),
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: SingleChildScrollView(
        // padding:
        //     EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
        child: Form(
          key: _formKey,
          child: SafeArea(
            child: Padding(
              padding: EdgeInsets.fromLTRB(16.w, 16.h, 16.w, MediaQuery.of(context).viewInsets.bottom),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  SizedBox(
                    height: ScreenConfig.height * 0.08,
                  ),
                  SvgPicture.asset(
                    AppImages.logo,
                    width: 60.w,
                    height: 59.h,
                  ),
                  height5,
                  Text(
                    ConstantsStrings.oConnect,
                    style: w700_18Poppins(color: Theme.of(context).hintColor),
                  ),
                  height20,
                  Text(
                    "Verification Code",
                    style: w600_20Poppins(color: AppColors.mainBlueColor),
                  ),
                  height10,
                  Text(
                    "We have sent you a 6 digit OTP Code to your Alternate Email ID",
                    style: w400_14Poppins(color: Theme.of(context).primaryColorDark),
                    textAlign: TextAlign.center,
                  ),
                  height15,
                  ////dkhgfjdhjsh
                  SizedBox(
                    height: 40.h,
                    child: CommonTextFormField(
                      fillColor: Theme.of(context).scaffoldBackgroundColor,
                      borderColor: Theme.of(context).primaryColorDark,
                      readOnly: true,
                      validator: FormValidations.passwordValidation,
                      controller: TextEditingController(text: widget.email ?? "oconnect@onpassive.com"),
                      suffixIcon: Icon(
                        Icons.mail_outlined,
                        color: Theme.of(context).primaryColorLight,
                        size: 16.sp,
                      ),
                    ),
                  ),
                  height15,
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          Text(
                            "OTP Expires in",
                            style: w400_14Poppins(color: Theme.of(context).primaryColorLight),
                          ),
                          Consumer<AuthApiProvider>(builder: (context, authApiProvider, child) {
                            return authApiProvider.enableResendButtonForgotPassword == false
                                ? TweenAnimationBuilder(
                                    tween: Tween<double>(begin: 180.0, end: 0),
                                    duration: const Duration(seconds: 180),
                                    builder: (context, value, child) {
                                      double val = value;
                                      int time = val.toInt();
                                      return Text(time == 0 ? '' : " $time Sec...", style: w400_16Poppins(color: AppColors.mainBlueColor));
                                    },
                                    onEnd: () {
                                      authApiProvider.enableResendOtpButtonForgotPasswordFun();
                                    },
                                  )
                                : const SizedBox.shrink();
                          })
                        ],
                      ),
                      Consumer<AuthApiProvider>(builder: (context, authApiProvider, child) {
                        return GestureDetector(
                          onTap: authApiProvider.enableResendButtonForgotPassword
                              ? () {
                                  authApiProvider.sendOtpRequestForForgotPassword(context: context, alternateEmailId: widget.email, isNavigationRequired: false);
                                }
                              : null,
                          child: Text(
                            'Resend OTP',
                            style: TextStyle(
                                color: authApiProvider.enableResendButtonForgotPassword ? const Color(0xff1877F2) : const Color(0xff1877F2).withOpacity(0.5),
                                fontWeight: FontWeight.bold,
                                fontSize: 14.sp,
                                decoration: TextDecoration.underline),
                          ),
                        );
                      })
                    ],
                  ),
                  height10,
                  OtpInputWidget(
                    noOfDigits: 6,
                    onChange: (pin) {
                      otp = pin;
                      print("the otp is the $otp");
                    },
                  ),
                  // Pinput(
                  //   controller: controller,
                  //   length: 6,
                  //   inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                  //   defaultPinTheme: PinTheme(
                  //     width: 56.w,
                  //     height: 56.w,
                  //     textStyle: TextStyle(
                  //         fontSize: 16.sp,
                  //         color: Theme.of(context).hintColor,
                  //         fontWeight: FontWeight.w600),
                  //     decoration: BoxDecoration(
                  //       color: Theme.of(context).cardColor,
                  //       borderRadius: BorderRadius.circular(12.r),
                  //     ),
                  //   ),
                  //   onChanged: (pin) {
                  //     otp = pin;
                  //   },
                  // showCursor: true,
                  //   focusNode: focusNode,
                  // ),
                  height10,
                  Consumer<AuthApiProvider>(builder: (context, data, child) {
                    return CustomButton(
                      buttonText: "Verify OTP",
                      buttonColor: AppColors.customButtonBlueColor,
                      onTap: () {
                        if (otp == null || otp!.length < 6) {
                          CustomToast.showErrorToast(msg: "Please Enter valid otp");
                          return;
                        }

                        data.validateForgotPasswordOtp(otp: otp.toString(), alternateEmailId: widget.email ?? "oconnect@onpassive.com", context: context);
                        controller.clear();
                      },
                    );
                  }),
                  height20,
                  const BackToLoginWidget(),
                  height40,
                  const TermsAndConditionsForAuth(),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
