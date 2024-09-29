import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:o_connect/ui/utils/colors/colors.dart';
import 'package:o_connect/ui/utils/constant_strings.dart';
import 'package:o_connect/ui/utils/images/images.dart';
import 'package:o_connect/ui/utils/textfield_helper/app_fonts.dart';
import 'package:o_connect/ui/utils/textfield_helper/common_textfield.dart';
import 'package:o_connect/ui/views/authentication/Auth_providers/auth_api_provider.dart';
import 'package:o_connect/ui/views/authentication/form_validations.dart';
import 'package:o_connect/ui/views/authentication/signin_signup/password_validator.dart';
import 'package:o_connect/ui/views/profile_screen/profile_provider/profile_api_provider.dart';
import 'package:provider/provider.dart';

class ChangePasswordProfile extends StatefulWidget {
  const ChangePasswordProfile({super.key});

  @override
  State<ChangePasswordProfile> createState() => _ChangePasswordProfileState();
}

class _ChangePasswordProfileState extends State<ChangePasswordProfile> {
  final _formKey = GlobalKey<FormState>();

  TextEditingController newPasswordController = TextEditingController();
  TextEditingController confirmPasswordController = TextEditingController();
  TextEditingController currentPasswordController = TextEditingController();
  AuthApiProvider? authProvider;
  ProfileScreenProvider? profileScreenProvider;

  @override
  void dispose() {
    currentPasswordController.dispose();
    confirmPasswordController.dispose();
    newPasswordController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    authProvider = Provider.of<AuthApiProvider>(context, listen: false);
    profileScreenProvider = Provider.of<ProfileScreenProvider>(context, listen: false);
    authProvider?.formKey = GlobalKey<FormState>();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer2<ProfileScreenProvider, AuthApiProvider>(builder: (context, profileScreenProvider, authProvider, child) {
      return WillPopScope(
          child: SafeArea(
            child: Scaffold(
              backgroundColor: Theme.of(context).scaffoldBackgroundColor,
              appBar: AppBar(
                elevation: 0,
                bottomOpacity: 0.0,
                backgroundColor: Theme.of(context).cardColor,
                centerTitle: false,
                leading: IconButton(
                  icon: Icon(
                    Icons.chevron_left,
                    size: 30,
                    color: Theme.of(context).primaryColorLight,
                  ),
                  onPressed: () {
                    Navigator.pop(context);
                  },
                ),
                title: Text(
                  "Change Password",
                  style: w500_16Poppins(color: Theme.of(context).hintColor),
                ),
              ),
              resizeToAvoidBottomInset: false,
              body: SingleChildScrollView(
                child: Form(
                  key: _formKey,
                  child: Padding(
                    padding: EdgeInsets.all(10.0.r),
                    child: Padding(
                      padding: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
                      child: Column(
                        children: [
                          height40,
                          Image.asset(AppImages.changePassword),
                          height70,
                          CommonTextFormField(
                            fillColor: Theme.of(context).scaffoldBackgroundColor,
                            borderColor: Theme.of(context).primaryColorDark,
                            controller: currentPasswordController,
                            hintText: "Current Password",
                            maxLength: 16,
                            keyboardType: TextInputType.visiblePassword,
                            obscureText: !profileScreenProvider.currentPassword,
                            validator: (val, String? f) {
                              return FormValidations.passwordValidation(val, "Current password");
                            },
                            hintStyle: w400_14Poppins(color: Theme.of(context).primaryColorLight),
                            onChanged: (val) {},
                            suffixIcon: Padding(
                              padding: EdgeInsets.all(14.0.sp),
                              child: InkWell(
                                  onTap: () {
                                    profileScreenProvider.currentPasswordStatus();
                                  },
                                  child: !profileScreenProvider.currentPassword
                                      ? SvgPicture.asset(
                                          AppImages.eyeOff,
                                          color: Theme.of(context).primaryColorLight,
                                        )
                                      : SvgPicture.asset(
                                          AppImages.eyeOn,
                                          color: Theme.of(context).primaryColorLight,
                                        )),
                            ),
                          ),
                          height10,
                          Column(
                            children: [
                              CommonTextFormField(
                                fillColor: Theme.of(context).scaffoldBackgroundColor,
                                borderColor: Theme.of(context).primaryColorDark,
                                controller: newPasswordController,
                                hintText: "New Password",
                                obscureText: !profileScreenProvider.newPassword,
                                maxLength: 16,
                                errorTextHeight: 0,
                                validator: (val, String? f) {
                                  if ((profileScreenProvider.passwordValidState.password.isNotEmpty) && !profileScreenProvider.passwordValidState.isValidPassWord) {
                                    return "";
                                  } else {
                                    return null;
                                  }
                                  // return FormValidations.passwordValidation(val, "Password");
                                },
                                /* (val, String? f) {
                                  return FormValidations.passwordValidation(val, "New password");
                                }, */
                                hintStyle: w400_14Poppins(color: Theme.of(context).primaryColorLight),
                                onChanged: (val) {
                                  profileScreenProvider.passwordValidator(val, false);
                                  setState(() {});
                                },
                                suffixIcon: Padding(
                                  padding: EdgeInsets.all(14.0.sp),
                                  child: InkWell(
                                      onTap: () {
                                        profileScreenProvider.newPasswordStatus();
                                      },
                                      child: !profileScreenProvider.newPassword
                                          ? SvgPicture.asset(
                                              AppImages.eyeOff,
                                              color: Theme.of(context).primaryColorLight,
                                            )
                                          : SvgPicture.asset(
                                              AppImages.eyeOn,
                                              color: Theme.of(context).primaryColorLight,
                                            )),
                                ),
                              ),
                              if ((profileScreenProvider.passwordValidState.password.isNotEmpty) && !profileScreenProvider.passwordValidState.isValidPassWord)
                                PasswordValidators.passwordInfoWidget(profileScreenProvider.passwordValidState, context),
                            ],
                          ),
                          height10,
                          CommonTextFormField(
                            fillColor: Theme.of(context).scaffoldBackgroundColor,
                            borderColor: Theme.of(context).primaryColorDark,
                            controller: confirmPasswordController,
                            hintText: "Confirm Password",
                            maxLength: 16,
                            validator: (value, String? fieldName) {
                              return FormValidations.createAccountConfirmPasswordValidation(value, fieldName, newPasswordController.text);
                            },
                            obscureText: !profileScreenProvider.confirmPassword,
                            hintStyle: w400_14Poppins(color: Theme.of(context).primaryColorLight),
                            onChanged: (val) {
                              setState(() {});
                              // profileScreenProvider.confirmPasswordStatus();
                            },
                            suffixIcon: Padding(
                              padding: EdgeInsets.all(14.0.sp),
                              child: InkWell(
                                  onTap: () {
                                    profileScreenProvider.confirmPasswordStatus();
                                  },
                                  child: !profileScreenProvider.confirmPassword
                                      ? SvgPicture.asset(
                                          AppImages.eyeOff,
                                          color: Theme.of(context).primaryColorLight,
                                        )
                                      : SvgPicture.asset(
                                          AppImages.eyeOn,
                                          color: Theme.of(context).primaryColorLight,
                                        )),
                            ),
                          ),
                          height40,
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Flexible(
                                flex: 1,
                                child: InkWell(
                                  onTap: () {
                                    Navigator.pop(context);
                                  },
                                  child: Container(
                                    // width: 80.w,
                                    height: 40.h,
                                    decoration: BoxDecoration(borderRadius: BorderRadius.circular(3), color: Color(0xff141D28)),
                                    child: const Center(
                                      child: Text(
                                        ConstantsStrings.cancel,
                                        style: TextStyle(color: Colors.white, fontSize: 13, fontWeight: FontWeight.bold),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                              SizedBox(
                                width: 10.w,
                              ),
                              Flexible(
                                flex: 1,
                                child: InkWell(
                                  onTap: () {
                                    if (_formKey.currentState!.validate() /*&& authProvider.enableConfirmPasswordFeild != false*/) {
                                      profileScreenProvider.changePasswordProfile(password: newPasswordController.text, oldPassword: currentPasswordController.text, context: context);
                                      FocusScope.of(context).unfocus();
                                    } else {
                                      print((_formKey.currentState?.validate() ?? false));
                                      print(authProvider.enableConfirmPasswordFeild);
                                    }
                                  },
                                  child: Container(
                                      // width: 100.w,
                                      height: 40.h,
                                      decoration: BoxDecoration(
                                          borderRadius: BorderRadius.circular(3),
                                          color: (_formKey.currentState?.validate() ?? false) /*&& authProvider.enableConfirmPasswordFeild ==true )*/
                                              ? Colors.blue
                                              : LightThemeColors.buttonDisabledColor),
                                      child: const Center(
                                        child: Text(
                                          ConstantsStrings.save,
                                          style: TextStyle(color: Colors.white, fontSize: 13, fontWeight: FontWeight.bold),
                                        ),
                                      )),
                                ),
                              )
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
          onWillPop: () async {
            profileScreenProvider.resetValidationsSignUp();
            FocusScope.of(context).unfocus();
            return true;
          });
    });
  }
}
