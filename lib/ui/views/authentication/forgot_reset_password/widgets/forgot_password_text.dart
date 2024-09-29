import 'package:flutter/material.dart';
import 'package:o_connect/core/routes/routes_name.dart';

import '../forgot_password_screen.dart';

class ForgetPasswordText extends StatefulWidget {
  Function? onTap;
  final formKey;
  ForgetPasswordText({super.key, this.onTap, this.formKey});

  @override
  State<ForgetPasswordText> createState() => _ForgetPasswordTextState();
}

class _ForgetPasswordTextState extends State<ForgetPasswordText> {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        widget.formKey.currentState.reset();
        if (widget.onTap != null) {
          widget.onTap!();
        }
        Navigator.pushNamed(context, RoutesManager.forgotPasswordScreen);
      },
      child: const Align(
          alignment: Alignment.topRight,
          child: Padding(
            padding: EdgeInsets.only(right: 15, top: 10),
            child: Text(
              "Forgot Password?",
              style: TextStyle(
                  color: Color(0xff1877F2),
                  fontSize: 15,
                  fontFamily: "Poppins",
                  fontWeight: FontWeight.normal),
            ),
          )),
    );
  }
}
