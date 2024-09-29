import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:o_connect/core/screen_configs.dart';
import 'package:o_connect/my_app.dart';
import 'package:o_connect/ui/utils/buttons_helper/custom_botton.dart';
import 'package:o_connect/ui/utils/colors/colors.dart';
import 'package:o_connect/ui/utils/constant_strings.dart';
import 'package:o_connect/ui/utils/custom_toast_helper/custom_toast.dart';
import 'package:o_connect/ui/utils/images/images.dart';
import 'package:o_connect/ui/utils/textfield_helper/app_fonts.dart';
import 'package:o_connect/ui/utils/textfield_helper/common_textfield.dart';
import 'package:o_connect/ui/views/authentication/Auth_providers/auth_api_provider.dart';
import 'package:o_connect/ui/views/authentication/form_validations.dart';
import 'package:o_connect/ui/views/authentication/signin_signup/register_login.dart';
import 'package:provider/provider.dart';

import 'otp/widgets/otp_input_feild.dart';

class LoginOtpScreen extends StatefulWidget {
  const LoginOtpScreen({Key? key, required this.email}) : super(key: key);
  final String email;

  @override
  State<LoginOtpScreen> createState() => _LoginOtpScreenState();
}

class _LoginOtpScreenState extends State<LoginOtpScreen> with RouteAware {
  final _formKey = GlobalKey<FormState>();
  String? otp;

  late AuthApiProvider authApiProvider;

  final controller = TextEditingController();
  final focusNode = FocusNode();

  @override
  void initState() {
    super.initState();
    authApiProvider = Provider.of<AuthApiProvider>(context, listen: false);
  }

  @override
  void didChangeDependencies() {
    routeObserver.subscribe(this, ModalRoute.of(context)!);

    super.didChangeDependencies();
  }

  @override
  void didPop() {
    authApiProvider.updateOtpPasswordStatus(status: true);
    super.didPop();
  }

  @override
  void dispose() {
    routeObserver.unsubscribe(this);
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
                    style: w400_14Poppins(color: Theme.of(context).primaryColorLight),
                    textAlign: TextAlign.center,
                  ),
                  height15,
                  SizedBox(
                    height: 40.h,
                    child: CommonTextFormField(
                      fillColor: Theme.of(context).scaffoldBackgroundColor,
                      borderColor: Colors.white,
                      readOnly: true,
                      validator: FormValidations.passwordValidation,
                      controller: TextEditingController(text: widget.email ?? "oconnect@onpassive.com"),
                      suffixIcon: GestureDetector(
                        onTap: () {
                          Navigator.pop(context);
                        },
                        child: Container(
                          height: 12.w,
                          width: 12.w,
                          margin: EdgeInsets.all(8.sp),
                          decoration: BoxDecoration(color: Theme.of(context).cardColor, shape: BoxShape.circle),
                          child: SvgPicture.asset(AppImages.editMailIcon),
                        ),
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
                            return authApiProvider.enableResendButtonForLoginOtp == false
                                ? TweenAnimationBuilder(
                                    tween: Tween<double>(begin: 180.0, end: 0),
                                    duration: const Duration(seconds: 180),
                                    builder: (context, value, child) {
                                      double val = value;
                                      int time = val.toInt();
                                      return Text(time == 0 ? '' : " $time Sec...", style: w400_16Poppins(color: AppColors.mainBlueColor));
                                    },
                                    onEnd: () {
                                      authApiProvider.enableResendOtpButtonLoginFun();
                                    },
                                  )
                                : const SizedBox.shrink();
                          })
                        ],
                      ),
                      Consumer<AuthApiProvider>(builder: (context, authApiProvider, child) {
                        return GestureDetector(
                          onTap: Provider.of<AuthApiProvider>(context, listen: false).enableResendButtonForLoginOtp
                              ? () {
                                  Provider.of<AuthApiProvider>(context, listen: false).sendOtpRequestLogin(widget.email.trim(), context, isFromResendButton: true);
                                  FocusScope.of(context).unfocus();
                                }
                              : null,
                          child: Text(
                            'Resend OTP',
                            style: w600_14Poppins(
                                color: Provider.of<AuthApiProvider>(context, listen: false).enableResendButtonForLoginOtp ? const Color(0xff1877F2) : const Color(0xff1877F2).withOpacity(0.5)),
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
                    },
                  ),
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

                        authApiProvider.validateOtpForForgotPassword(context: context, alternateMail: widget.email.trim(), otp: otp!, isFromLoginOtp: true);
                      },
                      width: 200.w,
                    );
                  }),
                  height15,
                  const RegisterOrLogin(text: "Register", value: 1),
                  height20,
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
