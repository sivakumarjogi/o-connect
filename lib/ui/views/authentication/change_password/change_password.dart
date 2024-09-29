import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:o_connect/ui/utils/buttons_helper/custom_botton.dart';
import 'package:o_connect/ui/utils/colors/colors.dart';
import 'package:o_connect/ui/utils/constant_strings.dart';
import 'package:o_connect/ui/utils/textfield_helper/app_fonts.dart';
import 'package:o_connect/ui/utils/textfield_helper/common_textfield.dart';
import 'package:o_connect/ui/views/authentication/Auth_providers/auth_api_provider.dart';
import 'package:o_connect/ui/views/authentication/form_validations.dart';
import 'package:o_connect/ui/views/authentication/signin_signup/password_validator.dart';
import 'package:o_connect/ui/views/authentication/signin_signup/register_login.dart';
import 'package:provider/provider.dart';
import '../../../../core/providers/theme_provider.dart';
import '../../../utils/images/images.dart';

class ChangePasswordPage extends StatefulWidget {
  const ChangePasswordPage({Key? key, required this.data}) : super(key: key);
  final Map<String, dynamic> data;

  @override
  State<ChangePasswordPage> createState() => _ChangePasswordPageState();
}

class _ChangePasswordPageState extends State<ChangePasswordPage> {
  final _formKey = GlobalKey<FormState>();

  TextEditingController currentController = TextEditingController();
  TextEditingController newPasswordController = TextEditingController();
  TextEditingController confirmPasswordController = TextEditingController();
  AuthApiProvider? authProvider;

  @override
  void dispose() {
    currentController.dispose();
    confirmPasswordController.dispose();
    newPasswordController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    authProvider = Provider.of<AuthApiProvider>(context, listen: false);
  }

  @override
  Widget build(BuildContext context) {
    var themeProvider = Provider.of<ThemeProvider>(context, listen: false);
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: const Icon(Icons.arrow_back_ios),
        ),
      ),
      body: SafeArea(
        child: Consumer<AuthApiProvider>(builder: (context, authProvider, child) {
          return Padding(
            padding: EdgeInsets.symmetric(horizontal: 16.w),
            child: Form(
              key: _formKey,
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    height50,
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
                      ConstantsStrings.createPassword,
                      style: w500_16Poppins(color: Theme.of(context).primaryColorLight),
                    ),
                    height30,
                    Text(
                      ConstantsStrings.newPasswordText,
                      textAlign: TextAlign.center,
                      style: w500_15Poppins(color: const Color(0xff1877F2)),
                    ),
                    height30,
                    _newPwdWidget(themeProvider, authProvider),
                    height15,
                    _confirmPwdWidget(themeProvider, authProvider),
                    height50,
                    CustomButton(
                      height: 40.h,
                      buttonColor: AppColors.customButtonBlueColor,
                      buttonText: "Confirm Password",
                      buttonTextStyle: w600_14Poppins(color: AppColors.whiteColor),
                      onTap: () {
                        if (_formKey.currentState!.validate() && authProvider.passwordValidState.isValidPassWord) {
                          authProvider.changeUserPassword(password: newPasswordController.text, alternateMailId: widget.data["emailId"], context: context);
                        }

                        FocusScope.of(context).unfocus();
                      },
                    ),
                    height50,
                    const TermsAndConditionsForAuth(),
                  ],
                ),
              ),
            ),
          );
        }),
      ),
    );
  }

  Widget _confirmPwdWidget(ThemeProvider themeProvider, AuthApiProvider provider) {
    return CommonTextFormField(
      fillColor: Theme.of(context).scaffoldBackgroundColor,
      borderColor: Theme.of(context).primaryColorDark,
      controller: confirmPasswordController,
      hintText: "Confirm Password",
      validator: (value, String? fieldName) {
        return FormValidations.createAccountConfirmPasswordValidation(value, fieldName, newPasswordController.text);
      },
      obscureText: !provider.confirmPassObsureChangePwd,
      errorMaxLines: 2,
      hintStyle: w400_14Poppins(color: Theme.of(context).primaryColorDark),
      suffixIcon: Padding(
        padding: EdgeInsets.all(14.0.sp),
        child: InkWell(
            onTap: () {
              provider.updateConfirmPasswordInChangePwd();
            },
            child: !provider.confirmPassObsureChangePwd
                ? SvgPicture.asset(
                    AppImages.eyeOff,
                    color: Theme.of(context).primaryColorDark,
                  )
                : SvgPicture.asset(
                    AppImages.eyeOn,
                    color: Theme.of(context).primaryColorDark,
                  )),
      ),
    );
  }

  Widget _newPwdWidget(ThemeProvider themeProvider, AuthApiProvider provider) {
    return Column(
      children: [
        CommonTextFormField(
          fillColor: Theme.of(context).scaffoldBackgroundColor,
          borderColor: Theme.of(context).primaryColorDark,
          controller: newPasswordController,
          hintText: "New Password",
          maxLength: 16,
          errorTextHeight: 0,
          errorMaxLines: 2,
          enableErrorBoarder: true,
          validator: (val, String? f) {
            if ((authProvider!.passwordValidState.password.isNotEmpty) && !authProvider!.passwordValidState.isValidPassWord) {
              return "";
            } else {
              return null;
            }
            // return FormValidations.passwordValidation(val, "New password");
          },
          obscureText: !provider.passObsureChangePwd,
          hintStyle: w400_14Poppins(color: Theme.of(context).primaryColorDark),
          onChanged: (val) {
            authProvider!.passwordValidator(val, false);
            authProvider!.enableConfirmPasswordFeildFun(newPasswordController.text);
          },
          suffixIcon: Padding(
            padding: EdgeInsets.all(14.0.sp),
            child: InkWell(
                onTap: () {
                  provider.updateNewPasswordChangePwd();
                },
                child: !provider.passObsureChangePwd
                    ? SvgPicture.asset(
                        AppImages.eyeOff,
                        color: Theme.of(context).primaryColorDark,
                      )
                    : SvgPicture.asset(
                        AppImages.eyeOn,
                        color: Theme.of(context).primaryColorDark,
                      )),
          ),
        ),
        if ((authProvider!.passwordValidState.password.isNotEmpty) && !authProvider!.passwordValidState.isValidPassWord)
          PasswordValidators.passwordInfoWidget(authProvider!.passwordValidState, context),
      ],
    );
  }
}
