import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:o_connect/ui/utils/base_urls.dart';
import 'package:o_connect/ui/utils/colors/colors.dart';
import 'package:o_connect/ui/utils/custom_toast_helper/custom_toast.dart';
import 'package:o_connect/ui/views/authentication/Auth_providers/auth_api_provider.dart';
import 'package:provider/provider.dart';
import 'package:shimmer/shimmer.dart';

import '../../../../core/providers/theme_provider.dart';
import '../../../utils/buttons_helper/custom_botton.dart';
import '../../../utils/constant_strings.dart';
import '../../../utils/images/images.dart';
import '../../../utils/textfield_helper/app_fonts.dart';
import '../../../utils/textfield_helper/common_textfield.dart';
import '../form_validations.dart';
import 'password_validator.dart';
import 'register_login.dart';

class SignupScreen extends StatefulWidget {
  const SignupScreen({Key? key}) : super(key: key);

  @override
  State<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  final TextEditingController _firstNameController = TextEditingController(text: '');
  final TextEditingController _lastNameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController = TextEditingController();
  final TextEditingController _alternateEmailController = TextEditingController();
  final TextEditingController _referalCodeController = TextEditingController();

  bool userEmailAlternated = false;
  final _formKey = GlobalKey<FormState>();

  @override
  void dispose() {
    _firstNameController.dispose();
    _lastNameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    _alternateEmailController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    Provider.of<AuthApiProvider>(context, listen: false).apiGetCaptcha();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    var themeProvider = Provider.of<ThemeProvider>(context, listen: false);
    var textThemeColor = themeProvider.isLightTheme ? AppColors.lightBlackColor : AppColors.darkWhiteColor;
    return Consumer<AuthApiProvider>(builder: (context, authApiProvider, child) {
      return WillPopScope(
        onWillPop: () async {
          authApiProvider.resetSignUpValidations();
          FocusScope.of(context).unfocus();
          return true;
        },
        child: Scaffold(
          resizeToAvoidBottomInset: false,
          body: SafeArea(
            child: Consumer<AuthApiProvider>(builder: (context, authProvider, child) {
              return _buildWidget(size, themeProvider, textThemeColor, context, authProvider);
            }),
          ),
        ),
      );
    });
  }

  Widget _buildWidget(Size size, ThemeProvider themeProvider, Color textThemeColor, BuildContext context, AuthApiProvider authProvider) {
    return Consumer<AuthApiProvider>(builder: (context, authApiProvider, child) {
      return SizedBox(
        height: size.height,
        child: Form(
          key: _formKey,
          child: Padding(
            padding: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
            child: Column(
              children: [
                Expanded(
                  child: ListView(
                    children: [
                      height50,
                      _logoAndRegisterText(),
                      height10,
                      _firstNameWidget(themeProvider, textThemeColor, context),
                      height10,
                      _lastNameWidget(themeProvider, textThemeColor, context),
                      height10,
                      _omailWidget(themeProvider, textThemeColor, context),
                      height10,
                      suggestionWidget(authProvider),
                      _createPwdWidget(textThemeColor, themeProvider, authProvider, context),
                      height10,
                      _confirmPwdWidget(textThemeColor, themeProvider, context, authProvider),
                      height10,
                      _alternateEmailWidget(themeProvider, context),
                      height10,
                      referalCodeWidget(themeProvider, context),
                      height10,
                      _captchaWidget(context, authApiProvider),
                      height10,
                      _registerButton(authProvider, context),
                      height5,
                      _loginNowText(),
                      height5,
                      const TermsAndConditionsForAuth(),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      );
    });
  }

  Widget suggestionWidget(AuthApiProvider authApiProvider) {
    return authApiProvider.suggestionsUserNamesList.isNotEmpty
        ? SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: List.generate(
                  authApiProvider.suggestionsUserNamesList.length,
                  (index) => GestureDetector(
                        onTap: () {
                          _emailController.text = authApiProvider.suggestionsUserNamesList[index];
                        },
                        child: Container(
                          margin: EdgeInsets.symmetric(horizontal: 5.w),
                          decoration: BoxDecoration(color: Theme.of(context).cardColor, borderRadius: BorderRadius.circular(50), border: Border.all(color: Colors.white)),
                          child: Padding(
                            padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 1.h),
                            child: Text(
                              authApiProvider.suggestionsUserNamesList[index],
                              style: w400_14Poppins(color: Theme.of(context).primaryColorLight),
                            ),
                          ),
                        ),
                      )),
            ),
          )
        : const SizedBox.shrink();
  }

  Uint8List convertBase64Image(String? base64String) {
    return const Base64Decoder().convert(base64String!.split(',').last);
  }

  Widget _loginNowText() {
    return const RegisterOrLogin(
      text: "Login",
      value: 2,
    );
  }

  Widget _captchaWidget(BuildContext context, AuthApiProvider authProvider) {
    return Padding(
      padding: EdgeInsets.only(left: 8.w, right: 8.w, bottom: 4.h),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text("Captcha"),
          const SizedBox(
            height: 10,
          ),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 10.w),
            child: Row(
              children: [
                authProvider.captchaModel.data != null && authProvider.captchaModel.data!.captcha != null
                    ? Image.memory(
                        convertBase64Image(authProvider.captchaModel.data!.captcha),
                        height: 45,
                        width: 250.w,
                        fit: BoxFit.fill,
                      )
                    : Shimmer.fromColors(
                        baseColor: Colors.grey.withOpacity(0.2),
                        highlightColor: Colors.grey.withOpacity(0.4),
                        enabled: true,
                        child: Container(
                          height: MediaQuery.of(context).size.height * 0.04,
                          width: 220.w,
                          decoration: BoxDecoration(borderRadius: BorderRadius.circular(5), color: AppColors.customButtonBlueColor),
                        ),
                      ),

                width10,
                GestureDetector(
                    onTap: () {
                      authProvider.captchaController.clear();

                      authProvider.apiGetCaptcha();

                      print("lkvn.,kvnf.v");
                    },
                    child: Icon(
                      Icons.refresh_outlined,
                      color: Theme.of(context).primaryColorLight,
                      size: 30,
                    )),
                // width30,
                // SvgPicture.asset(ImagesUrl.textToSpeech)
              ],
            ),
          ),
          height10,
          Padding(
            padding: EdgeInsets.only(left: 8.w, right: 8.w, bottom: 4.h),
            child: CommonTextFormField(
              fillColor: Theme.of(context).scaffoldBackgroundColor,
              hintText: "Write text from image",
              validator: (val, String? fieldName) {
                return FormValidations.captchValidation(val, fieldName!);
              },
              style: w400_14Poppins(color: Theme.of(context).hintColor /*textThemeColor*/),
              controller: authProvider.captchaController,
              keyboardType: TextInputType.emailAddress,
            ),
          ),
        ],
      ),
    );
  }

  Widget _logoAndRegisterText() {
    return Column(
      children: [
        height10,
        SvgPicture.asset(
          AppImages.logo,
          width: 60.w,
          height: 59.h,
          fit: BoxFit.contain,
        ),
        height5,
        Text(
          ConstantsStrings.oConnect,
          style: w700_18Poppins(color: Theme.of(context).hintColor),
        ),
        height20,
        Center(
          child: Text(
            "Register",
            style: w500_20Poppins(color: Theme.of(context).hintColor),
          ),
        ),
        height10,
      ],
    );
  }

  Widget _registerButton(AuthApiProvider authProvider, BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(left: 8.w, right: 8.w, bottom: 4.h),
      child: CustomButton(
        buttonText: ConstantsStrings.register,
        buttonColor: AppColors.customButtonBlueColor,
        onTap: () {
          if (_formKey.currentState!.validate()) {
            if (!authProvider.passwordValidState.isValidPassWord) {
              CustomToast.showErrorToast(msg: "Please enter valid password");
            } else if (_passwordController.text != _confirmPasswordController.text) {
              CustomToast.showErrorToast(msg: "Passwords don't match");
            } else {
              if (_emailController.text.length <= 4 || _emailController.text.length > 50) {
                CustomToast.showErrorToast(msg: "Username should be min 4 and max 50");
              } else {
                authProvider.registerUser({
                  "emailId": _emailController.text.trim() + BaseUrls.oMailEndTag,
                  "alternateEmail": _alternateEmailController.text.trim(),
                  "firstName": _firstNameController.text.trim(),
                  "lastName": _lastNameController.text.trim(),
                  "password": _passwordController.text.trim(),
                  "confirmPassword": _confirmPasswordController.text.trim(),
                  "referredBy": 0,
                  "referralCode": _referalCodeController.text.isEmpty ? null : _referalCodeController.text.trim(),
                  "source": "OES",
                  "isOFounder": false,
                  "base64CaptchaImage": authProvider.captchaController.text.trim(),
                  "registrationUUID": authProvider.captchaModel.data?.uuid
                }, context);
              }
              FocusScope.of(context).unfocus();
            }
          }
          // authProvider.captchaController.clear();
        },
      ),
    );
  }

  Widget _alternateEmailWidget(ThemeProvider themeProvider, BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(left: 8.w, right: 8.w, bottom: 4.h),
      child: CommonTextFormField(
        borderColor: Theme.of(context).primaryColorDark,
        fillColor: Theme.of(context).scaffoldBackgroundColor,
        controller: _alternateEmailController,
        hintText: 'Enter Alternate Email ID',
        keyboardType: TextInputType.emailAddress,
        style: w500_14Poppins(color: Colors.white /*themeProvider.isLightTheme
                ? AppColors.lightBlackColor
                : AppColors.darkWhiteColor*/
            ),
        validator: (val, String? fieldName) {
          return FormValidations.alternateEmailValidation(val, "Alternate email id");
        },
        suffixIcon: Padding(
            padding: EdgeInsets.all(12.sp),
            child: SvgPicture.asset(
              AppImages.mailIcon,
              height: 16.h,
              width: 16.w,
              fit: BoxFit.contain,
              color: Theme.of(context).primaryColorLight,
            )),
      ),
    );
  }

  Widget referalCodeWidget(ThemeProvider themeProvider, BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(left: 8.w, right: 8.w, bottom: 4.h),
      child: CommonTextFormField(
        fillColor: Theme.of(context).scaffoldBackgroundColor,
        borderColor: Theme.of(context).primaryColorDark,
        controller: _referalCodeController,
        hintText: 'Referal Code(Optional)',
        keyboardType: TextInputType.emailAddress,
        inputAction: TextInputAction.done,
        style: w500_14Poppins(color: Colors.white /*themeProvider.isLightTheme
                ? AppColors.lightBlackColor
                : AppColors.darkWhiteColor*/
            ),
        suffixIcon: Padding(
            padding: EdgeInsets.all(12.sp),
            child: Transform.rotate(
              angle: 120,
              child: Icon(
                Icons.link_rounded,
                size: 20.sp,
                color: Theme.of(context).primaryColorLight,
                /* AppImages.invite_new,
                height: 16.h,
                width: 16.w,
                fit: BoxFit.contain,
                color: Theme.of(context).disabledColor,*/
              ),
            )),
      ),
    );
  }

  Widget _createPwdWidget(Color textThemeColor, ThemeProvider themeProvider, AuthApiProvider authProvider, BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(left: 8.w, right: 8.w, bottom: 4.h),
      child: Column(
        children: [
          CommonTextFormField(
            style: w500_14Poppins(color: Colors.white),
            fillColor: Theme.of(context).scaffoldBackgroundColor,
            borderColor: Theme.of(context).primaryColorDark,
            hintText: ConstantsStrings.createPassword,
            onChanged: (changed) {
              authProvider.passwordValidator(changed, false);
              authProvider.enableConfirmPasswordFeildFun(_passwordController.text);
            },
            obscureText: !authProvider.passObsureSignUp,
            enableErrorBoarder: true,
            errorTextHeight: 0,
            validator: (val, String? f) {
              if ((authProvider.passwordValidState.password.isNotEmpty) && !authProvider.passwordValidState.isValidPassWord) {
                return "";
              } else {
                return null;
              }
              // return FormValidations.passwordValidation(val, "Password");
            },
            controller: _passwordController,
            suffixIcon: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly, // added line
              mainAxisSize: MainAxisSize.min,
              children: [
                (authProvider.passwordValidState.password.isNotEmpty) && !authProvider.passwordValidState.isValidPassWord
                    ? InkWell(
                        onTap: () {
                          authProvider.passwordValidator(_passwordController.text.toString(), true);
                        },
                        child: Icon(
                          Icons.warning_amber_rounded,
                          color: Colors.red,
                          size: 18.sp,
                        ),
                      )
                    : const SizedBox(),
                height5,
                InkWell(
                    onTap: () {
                      authProvider.updatePasswordSignup();
                    },
                    child: SvgPicture.asset(
                      !authProvider.passObsureSignUp ? AppImages.eyeOff : AppImages.eyeOn,
                      height: 18.w,
                      width: 18.w,
                      fit: BoxFit.contain,
                      color: Theme.of(context).primaryColorLight,
                    )),
                width5,
              ],
            ),
          ),
          if ((authProvider.passwordValidState.password.isNotEmpty) && !authProvider.passwordValidState.isValidPassWord)
            PasswordValidators.passwordInfoWidget(authProvider.passwordValidState, context),
        ],
      ),
    );
  }

  Widget _confirmPwdWidget(Color textThemeColor, ThemeProvider themeProvider, BuildContext context, AuthApiProvider authProvider) {
    return Padding(
      padding: EdgeInsets.only(left: 8.w, right: 8.w, bottom: 4.w),
      child: CommonTextFormField(
        readOnly: authProvider.enableConfirmPasswordFeild,
        onTap: () {
          authProvider.enableConfirmPasswordFeildFun(_passwordController.text);
        },
        style: w500_14Poppins(color: Colors.white /*textThemeColor*/),
        fillColor: Theme.of(context).scaffoldBackgroundColor,
        borderColor: Theme.of(context).primaryColorDark,
        hintText: ConstantsStrings.confirmPassword,
        onChanged: (changed) {},
        validator: (val, String? f) {
          return FormValidations.createAccountConfirmPasswordValidation(_passwordController.text, "Confirm password", val);
        },
        obscureText: !authProvider.confirmPassObsureSignUp,
        suffixIcon: Padding(
          padding: EdgeInsets.all(14.0.sp),
          child: InkWell(
              onTap: () {
                authProvider.updateConfirmPassword();
              },
              child: SvgPicture.asset(
                !authProvider.confirmPassObsureSignUp ? AppImages.eyeOff : AppImages.eyeOn,
                height: 18.w,
                width: 18.w,
                fit: BoxFit.contain,
                color: Theme.of(context).primaryColorLight,
              )),
        ),
        controller: _confirmPasswordController,
        keyboardType: TextInputType.visiblePassword,
      ),
    );
  }

  Widget _firstNameWidget(ThemeProvider themeProvider, Color textThemeColor, BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
        left: 8.w,
        right: 8.w,
        bottom: 4.h,
      ),
      child: CommonTextFormField(
        fillColor: Theme.of(context).scaffoldBackgroundColor,
        borderColor: Theme.of(context).primaryColorDark,
        hintText: ConstantsStrings.firstName,
        labelStyle: w500_14Poppins(color: Colors.white),
        maxLength: 55,
        style: w500_14Poppins(color: Colors.white /*textThemeColor*/),
        suffixIcon: Padding(
            padding: EdgeInsets.all(12.sp),
            child: SvgPicture.asset(
              AppImages.userImage,
              height: 16.h,
              width: 16.w,
              fit: BoxFit.contain,
              color: Theme.of(context).primaryColorLight,
            )),
        onChanged: (searchedText) {
          if (searchedText.length >= 50) {
            Fluttertoast.showToast(msg: "First Name should be min 1 and max 50");
          }
        },
        controller: _firstNameController,
        validator: (val, String? f) {
          return FormValidations.validateAndShowToast(val, "Enter First Name is required", "First");
        },
        keyboardType: TextInputType.name,
      ),
    );
  }

  Widget _lastNameWidget(ThemeProvider themeProvider, Color textThemeColor, BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(left: 8.w, right: 8.w, bottom: 4.h),
      child: CommonTextFormField(
        fillColor: Theme.of(context).scaffoldBackgroundColor,
        borderColor: Theme.of(context).primaryColorDark,
        hintText: ConstantsStrings.lastName,
        style: w500_14Poppins(color: Colors.white /*textThemeColor*/),
        maxLength: 55,
        onChanged: (searchedText) {
          if (searchedText.length >= 50) {
            Fluttertoast.showToast(msg: "Last Name should be min 1 and max 50");

            // _lastNameController.clear();
            //FocusScope.of(context).unfocus();
          }
        },
        validator: (val, String? fieldName) {
          return FormValidations.validateAndShowToast(val, "Enter Last Name is required", "Last");
        },
        suffixIcon: Padding(
            padding: EdgeInsets.symmetric(vertical: 12.h),
            child: SvgPicture.asset(
              AppImages.userImage,
              height: 16.h,
              width: 16.w,
              fit: BoxFit.contain,
              color: Theme.of(context).primaryColorLight,
            )),
        controller: _lastNameController,
        keyboardType: TextInputType.name,
      ),
    );
  }

  Widget _omailWidget(ThemeProvider themeProvider, Color textThemeColor, BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(left: 8.w, right: 8.w, bottom: 4.h),
      child: CommonTextFormField(
        fillColor: Theme.of(context).scaffoldBackgroundColor,
        borderColor: Theme.of(context).primaryColorDark,
        hintText: ConstantsStrings.omailID,
        validator: (val, String? fieldName) {
          return FormValidations.omailValidationCharecters(val, fieldName!);
        },
        inputFormatters: [
          CustomTextInputFormatterRegistrationMail(),
        ],
        errorMaxLines: 2,
        style: w500_14Poppins(color: Colors.white /*textThemeColor*/),
        suffixIcon: Padding(
            padding: EdgeInsets.only(right: 10.h),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  "@omail.ai",
                  style: w400_14Poppins(color: Colors.white),
                ),
              ],
            ) /*Image.asset(
              AppImages.mailImage,
              height: 16.h,
              width: 16.w,
              color: Theme.of(context).disabledColor,
            )*/
            ),
        controller: _emailController,
        keyboardType: TextInputType.emailAddress,
      ),
    );
  }
}

class CustomTextInputFormatterRegistrationMail extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(TextEditingValue oldValue, TextEditingValue newValue) {
    if (newValue.text.isEmpty) {
      return newValue;
    }

    String filteredValue = newValue.text.replaceAll(
      RegExp(r'[^\w.\-@]'), // Allow any word character, ., -, and @
      '',
    );

    List<String> disallowedSequences = ['..', '.-', '._', '-_', '@-', '@_', '-@', '_@', '.@', '-.', '_-', '_.', '@.'];

    for (String sequence in disallowedSequences) {
      if (filteredValue.contains(sequence)) {
        return oldValue;
      }
    }

    int underscoreCount = 0;
    int hyphenCount = 0;
    int atCount = 0;
    int dotCount = 0;

    for (int i = 0; i < filteredValue.length; i++) {
      if (filteredValue[i] == '_') {
        underscoreCount++;
        hyphenCount = 0;
        atCount = 0;
        dotCount = 0;
      } else if (filteredValue[i] == '-') {
        hyphenCount++;
        underscoreCount = 0;
        atCount = 0;
        dotCount = 0;
      } else if (filteredValue[i] == '@') {
        atCount++;
        underscoreCount = 0;
        hyphenCount = 0;
        dotCount = 0;
      } else if (filteredValue[i] == '.') {
        dotCount++;
        underscoreCount = 0;
        hyphenCount = 0;
        atCount = 0;
      }

      if (underscoreCount > 1 || hyphenCount > 1 || atCount > 1 || dotCount > 2) {
        return oldValue;
      }
    }

    // Check if underscore and hyphen count is restricted to one each
    if (underscoreCount > 1 || hyphenCount > 1) {
      return oldValue;
    }

    int dotCountBeforeAt = 0;
    int dotCountAfterAt = 0;

    int atIndex = filteredValue.indexOf('@');
    if (atIndex != -1) {
      String beforeAt = filteredValue.substring(0, atIndex);
      dotCountBeforeAt = beforeAt.split('.').length - 1;

      String afterAt = filteredValue.substring(atIndex + 1);
      dotCountAfterAt = afterAt.split('.').length - 1;

      // Check if there is more than two dots after @ or if underscore or hyphen is present after @
      if (dotCountBeforeAt > 2 || dotCountAfterAt > 2 || underscoreCount > 0 || hyphenCount > 0) {
        return oldValue;
      }
    } else {
      dotCountBeforeAt = filteredValue.split('.').length - 1;

      if (dotCountBeforeAt > 2) {
        return oldValue;
      }
    }

    final int selectionStart = newValue.selection.start.clamp(0, filteredValue.length);
    final int selectionEnd = newValue.selection.end.clamp(0, filteredValue.length);

    return TextEditingValue(
      text: filteredValue,
      selection: TextSelection.collapsed(offset: selectionEnd),
    );
  }
}
