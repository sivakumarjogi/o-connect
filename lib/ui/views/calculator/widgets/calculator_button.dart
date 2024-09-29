import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:o_connect/ui/utils/textfield_helper/app_fonts.dart';

class CalcButton extends StatelessWidget {
  final Color color;
  final TextStyle? calcButtonTextStyle;
  final String buttonText;
  final void Function()? buttonTapped;
  final double buttonRadius;

  const CalcButton({Key? key, required this.color, required this.calcButtonTextStyle, required this.buttonText, required this.buttonTapped, required this.buttonRadius}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: buttonTapped,
      child: Container(
        height: 60.h,
        margin:  EdgeInsets.symmetric(vertical: 2.h, horizontal: 3.w),
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(buttonRadius),
          /* boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.3),
              spreadRadius: 0.5,
              blurRadius: 1,
              offset: const Offset(0, 1), // changes position of shadow
            ),
          ],*/
        ),
        child: Center(
          child: FittedBox(
            fit: BoxFit.scaleDown,
            child: Text(
              buttonText,
              style: calcButtonTextStyle ?? w500_20Poppins(),
            ),
          ),
        ),
      ),
    );
  }
}
