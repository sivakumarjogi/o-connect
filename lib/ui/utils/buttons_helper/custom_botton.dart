import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:o_connect/ui/utils/colors/colors.dart';
import 'package:o_connect/ui/utils/textfield_helper/app_fonts.dart';

class CustomButton extends StatelessWidget {
  CustomButton(
      {Key? key,
      required this.buttonText,
      this.onTap,
      this.buttonColor = AppColors.mainBlueColor,
      this.textColor = Colors.black,
      this.height,
      this.width,
      this.buttonTextStyle,
      this.borderColor,
      this.isLoading = false,
      this.borderRadius,
      this.leadingWidget})
      : super(key: key);

  final String buttonText;
  final VoidCallback? onTap;
  final Color buttonColor;
  final Color textColor;
  double? height;
  double? width;
  TextStyle? buttonTextStyle;
  double? borderRadius;
  final bool isLoading;
  final Color? borderColor;
  Widget? leadingWidget;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Container(
        width: width ?? MediaQuery.of(context).size.width,
        margin: EdgeInsets.symmetric(horizontal: 0.w, vertical: 5.h),
        height: height ?? 40.h,
        decoration: BoxDecoration(
            border: Border.all(color: borderColor ?? Colors.transparent),
            color: buttonColor,
            borderRadius: BorderRadius.circular(borderRadius ?? 5.r)),
        child: Center(
            child: isLoading
                ? SizedBox(
                    width: 20.w,
                    height: 20.w,
                    child: const CircularProgressIndicator(
                      color: Colors.white,
                    ),
                  )
                : Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      leadingWidget ?? const IgnorePointer(),
                      SizedBox(
                        width: 10,
                      ),
                      Text(
                        buttonText,
                        style: buttonTextStyle ??
                            w400_16Poppins(color: Colors.white),
                      ),
                    ],
                  )),
      ),
    );
  }
}
