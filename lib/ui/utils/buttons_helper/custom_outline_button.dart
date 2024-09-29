import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:o_connect/ui/utils/colors/colors.dart';
import 'package:o_connect/ui/views/themes/providers/webinar_themes_provider.dart';
import 'package:provider/provider.dart';

import '../textfield_helper/app_fonts.dart';

class CustomOutlinedButton extends StatelessWidget {
  CustomOutlinedButton(
      {Key? key,
      required this.buttonText,
      this.onTap,
      this.color = Colors.transparent,
      this.outLineBorderColor = AppColors.mainBlueColor,
      this.buttonTextStyle,
      this.height,
      this.width,
      this.leadingIcon,
      this.suffixIcon})
      : super(key: key);
  final String buttonText;
  final VoidCallback? onTap;
  final Color color;
  final Color outLineBorderColor;
  double? height = 40.h;
  double? width;
  double borderRadius = 6.r;
  Widget? leadingIcon;
  Widget? suffixIcon;
  TextStyle? buttonTextStyle = w400_16Poppins();

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Container(
        height: height,
        width: width ?? MediaQuery.of(context).size.width * .5 - 50.sp,
        padding: EdgeInsets.symmetric(horizontal: 15.w, vertical: 5.h),
        decoration: BoxDecoration(
          border: Border.all(
              width: 1,
              color: Provider.of<WebinarThemesProviders>(context)
                          .themeHighLighter !=
                      null
                  ? Colors.white
                  : outLineBorderColor),
          borderRadius: BorderRadius.circular(borderRadius),
          color: color,
        ),
        child: Center(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              leadingIcon != null
                  ? Row(
                      children: [
                        leadingIcon!,
                        SizedBox(
                          width: 5,
                        ),
                      ],
                    )
                  : const IgnorePointer(),
              Text(
                buttonText,
                style: buttonTextStyle,
              ),
              suffixIcon != null
                  ? Row(
                      children: [
                        SizedBox(
                          width: 5,
                        ),
                        suffixIcon!,
                      ],
                    )
                  : const IgnorePointer(),
            ],
          ),
        ),
      ),
    );
  }
}
