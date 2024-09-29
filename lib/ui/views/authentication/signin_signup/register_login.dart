import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:o_connect/core/routes/routes_name.dart';
import 'package:o_connect/ui/utils/base_urls.dart';
import 'package:o_connect/ui/utils/constant_strings.dart';
import 'package:o_connect/ui/utils/textfield_helper/app_fonts.dart';
import 'package:url_launcher/url_launcher.dart';

class RegisterOrLogin extends StatelessWidget {
  final String text;
  final int value;

  const RegisterOrLogin({super.key, required this.text, required this.value});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          value == 1 ? ConstantsStrings.noAccount : ConstantsStrings.haveAccount,
          style: w400_14Poppins(color: Theme.of(context).primaryColorLight),
        ),
        GestureDetector(
          onTap: () async {
            if (value == 2) {
              Navigator.pushNamed(
                context,
                RoutesManager.logIn,
              );
            } else {
              // Navigator.pushNamed(context, RoutesManager.signupScreen);
              await launchUrl(
                Uri.parse(BaseUrls.redirectRegisterUrl),
              );
            } 

            // ?
            // : Navigator.pushNamed(context, RoutesManager.signupScreen);
            // Navigator.pushNamed(context, RoutesManager.signupScreen);
          },
          child: Text(text, style: w500_14Poppins(color: const Color(0xff1877F2))),
        )
      ],
    );
  }
}

class TermsAndConditionsForAuth extends StatelessWidget {
  const TermsAndConditionsForAuth({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(8.0.sp),
      child: Wrap(
        crossAxisAlignment: WrapCrossAlignment.center,
        alignment: WrapAlignment.center,
        runAlignment: WrapAlignment.center,
        children: [
          Text(
            '''By continuing, you agree to the''',
            style: w400_14Poppins(color: Theme.of(context).primaryColorDark),
          ),
          GestureDetector(
            onTap: () {
              Navigator.pushNamed(context, RoutesManager.termsOfService);
            },
            child: Text(
              ''' Terms of Service''',
              style: w400_14Poppins(color: const Color(0xff1877F2)),
            ),
          ),
          Text(''' and ''', style: w400_14Poppins(color: Theme.of(context).primaryColorDark)),
          GestureDetector(
            onTap: () {
              Navigator.pushNamed(context, RoutesManager.privacyPolicy);
            },
            child: Text('''Privacy Policy''', style: w400_14Poppins(color: const Color(0xff1877F2))),
          ),
        ],
      ),
    );
  }
}
