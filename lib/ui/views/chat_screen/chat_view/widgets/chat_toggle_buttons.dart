import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:o_connect/ui/utils/colors/colors.dart';
import 'package:o_connect/ui/utils/textfield_helper/app_fonts.dart';

import '../../../../../core/providers/theme_provider.dart';

enum ChatType {
  group,
  private,
  qAnda,
}

class Button extends StatelessWidget {
  Button({
    Key? key,
    required this.chatType,
    required this.isSelected,
    required this.onPressed,
    required this.countText,
    required this.buttonName,
    required this.themeProvider,
  }) : super(key: key);

  final ChatType chatType;
  final bool isSelected;
  final String countText;
  final String buttonName;
  final Function(ChatType) onPressed;
  ThemeProvider? themeProvider;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () => onPressed(chatType),
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 6.w, vertical: 8.h),
        decoration: BoxDecoration(
            color: isSelected ? AppColors.mainBlueColor : null,
            borderRadius: BorderRadius.circular(5.r)),
        child: Center(
            child: Row(
          children: [
            Text(
              buttonName,
              style: w500_14Poppins(
                  color: isSelected
                      ? (themeProvider!.isLightTheme
                          ? AppColors.whiteColor
                          : AppColors.whiteLightColor)
                      : (themeProvider!.isLightTheme
                          ? AppColors.mainBlueColor
                          : AppColors.mainBlueColor)),
            ),
            width5,
            Container(
              width: 18.w,
              height: 18.w,
              decoration: BoxDecoration(
                  color: isSelected
                      ? AppColors.whiteColor
                      : (themeProvider!.isLightTheme
                          ? AppColors.paragraphColor
                          : AppColors.mainBlueColor),
                  borderRadius: BorderRadius.circular(50.r)),
              child: Center(
                  child: Text(
                countText,
                style: w600_14Poppins(
                    color: isSelected
                        ? AppColors.mainBlueColor
                        : AppColors.whiteColor),
              )),
            )
          ],
        )),
      ),
    );
  }
}
