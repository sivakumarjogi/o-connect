import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:o_connect/my_app.dart';
import 'package:o_connect/ui/utils/custom_toast_helper/custom_toast.dart';
import 'package:o_connect/ui/views/authentication/Auth_providers/auth_api_provider.dart';
import 'package:o_connect/ui/views/webinar_details/webinar_details_provider/webinar_provider.dart';
import 'package:o_connect/core/screen_configs.dart';
import 'package:o_connect/ui/utils/colors/colors.dart';
import 'package:provider/provider.dart';
import '../../../../core/providers/app_global_state_provider.dart';
import '../../../../core/providers/theme_provider.dart';
import '../../../../core/routes/routes_name.dart';
import '../../../utils/buttons_helper/custom_botton.dart';
import '../../../utils/constant_strings.dart';
import '../../../utils/images/images.dart';
import '../../../utils/textfield_helper/app_fonts.dart';
import '../../../utils/textfield_helper/common_textfield.dart';
import '../form_validations.dart';
import '../otp/widgets/otp_password_tab.dart';
import 'register_login.dart';

class SignInScreen extends StatefulWidget {
  const SignInScreen({Key? key}) : super(key: key);

  @override
  State<SignInScreen> createState() => _SignInScreenState();
}

class _SignInScreenState extends State<SignInScreen> with RouteAware {
  final _formKey = GlobalKey<FormState>();

  final _formKeyForOTP = GlobalKey<FormState>();

  ThemeProvider? themeProvider;

  final otpFormKey = GlobalKey<FormState>();

  String? otp;

  DateTime? currentBackPressTime;

  late AuthApiProvider authApiProvider;

  @override
  void initState() {
    authApiProvider = Provider.of<AuthApiProvider>(context, listen: false);
    themeProvider = Provider.of<ThemeProvider>(context, listen: false);
    authApiProvider.emailControllerOTP = TextEditingController();
    authApiProvider.emailController = TextEditingController();
    authApiProvider.passwordController = TextEditingController();
    authApiProvider.usernameController = TextEditingController();

    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
    routeObserver.unsubscribe(this);
    authApiProvider.emailController.clear();
    authApiProvider.emailControllerOTP.clear();
    authApiProvider.passwordController.clear();
    authApiProvider.usernameController.clear();
  }

  @override
  void didChangeDependencies() {
    routeObserver.subscribe(this, ModalRoute.of(context)!);
    themeProvider = Provider.of<ThemeProvider>(context, listen: false);
    super.didChangeDependencies();
  }

  Future<bool> onWillPop() {
    DateTime now = DateTime.now();
    if (currentBackPressTime == null || now.difference(currentBackPressTime!) > const Duration(seconds: 2)) {
      currentBackPressTime = now;
      CustomToast.showInfoToast(msg: "back again to exit", duration: const Duration(seconds: 1));
      return Future.value(false);
    }
    return Future.value(true);
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
        onWillPop: onWillPop,
        child: Consumer<AppGlobalStateProvider>(
          builder: (context,appGlobalStateProvider,__) {
            return Scaffold(
              resizeToAvoidBottomInset: false,
              body: SafeArea(
                child: _buildWidget(),
              ),
            );
          }
        ));
  }

  Widget _buildWidget() {
    return Consumer2<AuthApiProvider, WebinarProvider>(builder: (context, authProvider, provider, child) {
      return SingleChildScrollView(
        child: Form(
          key: authProvider.isOtpPasswordStatus ? _formKeyForOTP : _formKey,
          child: Padding(
            padding:  EdgeInsets.symmetric(horizontal: 12.w),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                SizedBox(
                  height: ScreenConfig.height * 0.11,
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
                height30,
                Text(
                  ConstantsStrings.logIn,
                  style: w600_18Poppins(color: Theme.of(context).hintColor),
                ),
                height30,
                OtpAndPasswordTab(
                  onTap: () {
                    clearTextFields();
                  },
                ),
                height15,
                (!authProvider.isOtpPasswordStatus) ? _passwordColumnWidget(context, authProvider, provider) : _otpColumnWidget(context, authProvider, provider),
                /*     const Spacer(),*/
                SizedBox(
                  height: ScreenConfig.height * 0.1,
                ),
                const TermsAndConditionsForAuth(),
                SizedBox(
                  height: ScreenConfig.height * 0.05,
                )
              ],
            ),
          ),
        ),
      );
    });
  }

  Widget _passwordColumnWidget(BuildContext context, AuthApiProvider authApiProvider, WebinarProvider provider) {
    return Column(
      children: [
        _userNameWidget(context),
        _passwordWidget(context, authApiProvider),
        GestureDetector(
          onTap: () {
            _formKey.currentState!.reset();
            Navigator.pushNamed(context, RoutesManager.forgotPasswordScreen);
          },
          child: Align(
              alignment: Alignment.topRight,
              child: Padding(
                padding: EdgeInsets.only(right: 15.w, top: 10.h),
                child: Text(
                  "Forgot Password?",
                  style: w400_13Poppins(color: const Color(0xff1877F2)),
                ),
              )),
        ),
        height10,
        _loginButton(authApiProvider, context, provider),
        height10,
        const RegisterOrLogin(
          text: "Register",
          value: 1,
        ),
      ],
    );
  }

  Widget _otpColumnWidget(BuildContext context, AuthApiProvider authApiProvider, WebinarProvider provider) {
    return SizedBox(
      height: ScreenConfig.height * 0.35,
      child: Column(
        children: [
          _alternateEmailForOTPWidget(context),
          _loginButton(authApiProvider, context, provider),
          const RegisterOrLogin(
            text: "Register",
            value: 1,
          ),
        ],
      ),
    );
  }

  Widget _userNameWidget(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(left: 15.0.w, right: 15.w, bottom: 15.h),
      child: CommonTextFormField(
        fillColor: Theme.of(context).scaffoldBackgroundColor,
        borderColor:  Theme.of(context).primaryColorDark,
        hintText: ConstantsStrings.enterUsername,
        validator: (val, String? f) {
          return FormValidations.requiredFieldValidation(val, "User name");
        },
        style: w500_14Poppins(color: Colors.white),
        labelStyle: w500_14Poppins(color: Colors.white),
        suffixIcon: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Padding(
              padding: EdgeInsets.only(right: 10.h),
              child: Text(
                "@omail.ai",
                style: w400_14Poppins(color: Theme.of(context).primaryColorDark),
              ),
            ),
          ],
        ),
        controller: authApiProvider.usernameController,
        keyboardType: TextInputType.emailAddress,
        inputAction: TextInputAction.next,
      ),
    );
  }

  Widget _alternateEmailForOTPWidget(BuildContext context) {
    return Form(
      key: otpFormKey,
      child: Padding(
        padding: EdgeInsets.only(left: 15.0.w, right: 15.w, bottom: 15.h),
        child: CommonTextFormField(
          fillColor: Theme.of(context).scaffoldBackgroundColor,
          borderColor:  Theme.of(context).primaryColorDark,
          controller: authApiProvider.emailControllerOTP,
          hintText: 'Enter Alternate Email ID',
          keyboardType: TextInputType.emailAddress,
          inputAction: TextInputAction.done,
          style: w500_14Poppins(color: Theme.of(context).primaryColorLight),
          validator: (val, String? fieldName) {
            return FormValidations.alternateEmailValidation(val, "Alternate email id");
          },
          suffixIcon: Padding(
            padding: EdgeInsets.all(12.sp),
            child: SvgPicture.asset(
              AppImages.mailIcon,
              color: Theme.of(context).primaryColorLight,
              height: 16.w,
              width: 16.w,
            ),
          ),
        ),
      ),
    );
  }

  Widget _passwordWidget(BuildContext context, AuthApiProvider authProvider) {
    return Padding(
      padding: EdgeInsets.only(left: 15.w, right: 15.w),
      child: CommonTextFormField(
        fillColor: Theme.of(context).scaffoldBackgroundColor,
        borderColor:  Theme.of(context).primaryColorDark,
        maxLength: 16,
        hintText: ConstantsStrings.password,
        onChanged: (changed) {},
        style: w500_14Poppins(color: Colors.white),
        obscureText: !authProvider.passObsureSignIn,
        inputAction: TextInputAction.done,
        validator: (val, String? f) {
          if (val.length > 16) {
            return "Characters limit 8-16";
          }
          return FormValidations.requiredFieldValidation(val, "Password");
        },
        suffixIcon: Padding(
          padding: EdgeInsets.symmetric(vertical: 14.h),
          child: InkWell(
              onTap: () {
                authProvider.updatePasswordSignIn();
              },
              child: SvgPicture.asset(
                !authProvider.passObsureSignIn ? AppImages.eyeOff : AppImages.eyeOn,
                color: Theme.of(context).primaryColorDark,
                height: 12.w,
                width: 12.w,
                fit: BoxFit.contain,
              )),
        ),
        controller: authApiProvider.passwordController,
        keyboardType: TextInputType.visiblePassword,
      ),
    );
  }

  Widget _loginButton(AuthApiProvider authProvider, BuildContext context, WebinarProvider provider) {
    return Padding(
      padding: EdgeInsets.only(left: 15.0.w, right: 15.w, bottom: 10.h),
      child: CustomButton(
        buttonColor: AppColors.customButtonBlueColor,
          buttonText: authProvider.isOtpPasswordStatus ? ConstantsStrings.REQUESTOTP : ConstantsStrings.logIn,
          onTap: authProvider.isOtpPasswordStatus
              ? () {
                  if (otpFormKey.currentState!.validate()) {
                    authProvider.sendOtpRequestLogin(authApiProvider.emailControllerOTP.text.trim(), context);
                    FocusScope.of(context).unfocus();
                  }
                  {}
                }
              : () {
                  if (_formKey.currentState!.validate()) {
                    authProvider.loginUser(authApiProvider.usernameController.text.trim(), authApiProvider.passwordController.text.trim(), context, provider);
                    FocusScope.of(context).unfocus();
                  }
                }),
    );
  }

  void clearTextFields() {
    authApiProvider.emailController.clear();
    authApiProvider.usernameController.clear();
    authApiProvider.emailControllerOTP.clear();
    authApiProvider.usernameController.clear();
    authApiProvider.passwordController.clear();
  }
}
