import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:o_connect/ui/utils/colors/colors.dart';
import 'package:o_connect/ui/utils/textfield_helper/app_fonts.dart';
import 'package:o_connect/ui/views/authentication/Auth_providers/auth_api_provider.dart';
import 'package:o_connect/ui/views/authentication/otp/widgets/back_to_login.dart';
import 'package:o_connect/ui/views/authentication/signin_signup/register_login.dart';
import 'package:provider/provider.dart';
import '../../../../core/providers/app_global_state_provider.dart';
import '../../../../core/providers/theme_provider.dart';
import '../../../utils/buttons_helper/custom_botton.dart';
import '../../../utils/constant_strings.dart';
import '../../../utils/images/images.dart';
import '../../../utils/textfield_helper/common_textfield.dart';
import '../form_validations.dart';

class ForgotPasswordScreen extends StatefulWidget {
  const ForgotPasswordScreen({super.key});

  @override
  State<ForgotPasswordScreen> createState() => _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends State<ForgotPasswordScreen> {
  final _emailController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  @override
  void dispose() {
    _emailController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var themeProvider = Provider.of<ThemeProvider>(context, listen: false);
    return Scaffold(
      resizeToAvoidBottomInset: false,
    
      body: SafeArea(child: Consumer2<AuthApiProvider,AppGlobalStateProvider>(builder: (context, authProvider,appGlobalStateProvider, child) {
        return AbsorbPointer(
          absorbing: !appGlobalStateProvider.isConnected,
          child: Center(
            child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: SizedBox(
                    height: MediaQuery.of(context).size.height,
                    child: Form(
                        key: _formKey,
                        child: Column(crossAxisAlignment: CrossAxisAlignment.center, mainAxisAlignment: MainAxisAlignment.center, children: [
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
                          height40,
                          Text(
                            ConstantsStrings.resetText,
                            style: w400_14Poppins(color: Theme.of(context).primaryColorDark),
                          ),
                          height30,
                          _emailWidget(themeProvider, context),
                          height10,
                          _submitButton(context, authProvider),
                          height10,
                          const BackToLoginWidget(),
                          height40,
                          const TermsAndConditionsForAuth(),
                        ])))),
          ),
        );
      })),
    );
  }

  Widget _submitButton(BuildContext context, AuthApiProvider authProvider) {
    return CustomButton(
      buttonColor: AppColors.customButtonBlueColor,
      buttonText: "Submit",
      onTap: () {
        if (_formKey.currentState!.validate()) {
          authProvider.sendOtpRequestForForgotPassword(context: context, alternateEmailId: _emailController.text.trim());
          FocusScope.of(context).unfocus();
        }
      },
    );
  }

  Widget _emailWidget(ThemeProvider themeProvider, BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(bottom: 15.h),
      child: CommonTextFormField(
        fillColor: Theme.of(context).scaffoldBackgroundColor,
        borderColor: Theme.of(context).primaryColorDark ,
        controller: _emailController,
        hintText: 'Enter Alternate Email ID',
        keyboardType: TextInputType.emailAddress,
        style: w500_14Poppins(color: Colors.white),
        validator: (val, String? fieldName) {
          return FormValidations.alternateEmailValidation(val, "Alternate email id");
        },
        suffixIcon: Padding(
          padding: EdgeInsets.all(10.sp),
          child: SvgPicture.asset(
            AppImages.mailIcon,
            color: Theme.of(context).primaryColorDark,
            height: 16.w,
            width: 16.w,
          ),
        ),
      ),
    );
  }
}
