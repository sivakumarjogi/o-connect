import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:o_connect/ui/utils/constant_strings.dart';
import 'package:o_connect/ui/views/themes/providers/webinar_themes_provider.dart';
import 'package:provider/provider.dart';
import '../../../utils/colors/colors.dart';
import '../../../utils/textfield_helper/app_fonts.dart';

class ColorPickerWidget extends StatelessWidget {
  const ColorPickerWidget({super.key, this.color, this.text, required this.title, required this.backGroundOnTap, required this.textOnTap, required this.backGroundColor, required this.textColor});

  final Color? color;
  final String? text;

  final String title;
  final VoidCallback backGroundOnTap;
  final VoidCallback textOnTap;
  final Color backGroundColor;
  final Color textColor;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Column(
          children: [
            Text(
              "BG",
              style: w400_12Poppins(color: Provider.of<WebinarThemesProviders>(context).selectedWebinarTheme != null ? Colors.white : AppColors.appmainThemeColor),
            ),
            InkWell(
              onTap: backGroundOnTap,
              child: Container(
                width: 36.w,
                height: 36.w,
                decoration: BoxDecoration(color: backGroundColor, borderRadius: BorderRadius.circular(5.r)),
              ),
            ),
          ],
        ),
        width10,
        Column(
          children: [
            Text(
              ConstantsStrings.text,
              style: w400_12Poppins(color: Provider.of<WebinarThemesProviders>(context).selectedWebinarTheme != null ? Colors.white : AppColors.appmainThemeColor),
            ),
            InkWell(
              onTap: textOnTap,
              child: Container(
                width: 36.w,
                height: 36.w,
                decoration: BoxDecoration(color: textColor, borderRadius: BorderRadius.circular(5.r)),
              ),
            ),
          ],
        ),
      ],
    );
  }
}
