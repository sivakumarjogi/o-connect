import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:otp_input_editor/otp_input_editor.dart';

class OtpInputWidget extends StatelessWidget {
  final int noOfDigits;
  final bool? showOTP;
  final Color? borderColor;
  final Function(String) onChange;

  const OtpInputWidget({super.key, required this.noOfDigits, required this.onChange, this.showOTP, this.borderColor});

  @override
  Widget build(BuildContext context) {
    return OtpInputEditor(
      obscureText: showOTP ?? false,
      otpLength: noOfDigits,
      onOtpChanged: (String pin) {
        // updatePin = pin;
        onChange(pin);
      },
      invalid: false,
      otpTextFieldBackgroundColor: Colors.white,
      boxShadow: const [
        BoxShadow(
          color: Colors.black12,
          blurRadius: 2.0,
          spreadRadius: 1.0,
        ),
      ],
      fieldWidth: 56.w,
      fieldHeight: 56.w,
      cursorWidth: 2.0,
      cursorHeight: 22.0,
      textInputStyle: TextStyle(fontSize: 16.sp, color: Theme.of(context).hintColor, fontWeight: FontWeight.w600),
      boxDecoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(12.r),
      ),
    );
  }
}
