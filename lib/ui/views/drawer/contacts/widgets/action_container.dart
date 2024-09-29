import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:o_connect/core/screen_configs.dart';
import '../../../../utils/images/images.dart';

class ActionContainer extends StatelessWidget {
  const ActionContainer({required this.imagePath, this.borderColor = Colors.blue, this.backgroundColor = Colors.transparent, this.extraPadding, this.iconColor, this.width,this.imgHeight,this.imgWidth, this.onTap, Key? key})
      : super(key: key);
  final Color? borderColor;
  final String imagePath;
  final Color? backgroundColor;
  final double? extraPadding;
  final VoidCallback? onTap;
  final double? width;
  final Color? iconColor;
  final double? imgHeight;
  final double? imgWidth;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap ?? () {},
      child: Container(
        height: 35.h,
        width: width ?? ScreenConfig.width * 0.44,
        decoration: BoxDecoration(
          color: backgroundColor,
          borderRadius: BorderRadius.circular(5.r),
          border: Border.all(color: borderColor ?? Colors.transparent),
        ),
        child: Center(
          child: SvgPicture.asset(
            imagePath,
            color: iconColor,
            height:imgHeight?? 15.w,
            width: imgWidth??15.w,
          ),
        ),
      ),
    );
  }
}
