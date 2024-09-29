import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:o_connect/core/routes/routes_name.dart';
import 'package:o_connect/ui/utils/textfield_helper/app_fonts.dart';

import '../../signin_signup/sign_in_screen.dart';

class BackToLoginWidget extends StatelessWidget {
  const BackToLoginWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          'Back to ',
          style: TextStyle(fontSize: 14.sp, color: Theme.of(context).primaryColorLight),
        ),
        InkWell(
          onTap: () {
            Navigator.pushNamedAndRemoveUntil(context, RoutesManager.logIn, (route) => false);
          },
          child: Text("Login", style: w400_14Poppins(color: const Color(0xff1877F2))),
        )
      ],
    );
  }
}
