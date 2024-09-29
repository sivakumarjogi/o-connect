import 'package:flutter/material.dart';
import 'package:o_connect/core/screen_configs.dart';
import 'package:o_connect/ui/utils/buttons_helper/custom_botton.dart';

class CloseApplyButtons extends StatelessWidget {
  const CloseApplyButtons({
    super.key,
    required this.closeOnTap,
    required this.applyOnTap,
    this.width,
    this.leftButtonText = "Close",
    this.rightButtonText = "Apply",
    this.leftButtonColor = const Color(0x315D9233),
    this.rightButtonColor = const Color(0xff0E78F9),
    this.leftButtonBorderColor = const Color(0xFF2196F3),
    this.rightButtonBorderColor = const Color(0x00000000),
  });
  final VoidCallback closeOnTap;
  final VoidCallback applyOnTap;
  final double? width;
  final String leftButtonText;
  final String rightButtonText;
  final Color leftButtonColor;
  final Color rightButtonColor;
  final Color leftButtonBorderColor;
  final Color rightButtonBorderColor;
  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        CustomButton(
          width: width ?? ScreenConfig.width * 0.47,
          buttonText: leftButtonText,
          buttonColor: leftButtonColor,
          borderColor: leftButtonBorderColor,
          onTap: closeOnTap,
        ),
        CustomButton(
          width: width ?? ScreenConfig.width * 0.47,
          buttonText: rightButtonText,
          onTap: applyOnTap,
          buttonColor: rightButtonColor,
          borderColor: rightButtonBorderColor,
        )
      ],
    );
  }
}
