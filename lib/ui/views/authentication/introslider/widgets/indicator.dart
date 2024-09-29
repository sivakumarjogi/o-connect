import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:o_connect/ui/utils/colors/colors.dart';

class Indicator extends AnimatedWidget {
  final PageController controller;

  const Indicator({super.key, required this.controller})
      : super(listenable: controller);

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
        shrinkWrap: true,
        itemCount: 3,
        scrollDirection: Axis.horizontal,
        physics: const NeverScrollableScrollPhysics(),
        itemBuilder: (context, index) {
          return Container(
              width: controller.page == index ? 17.w : 12.w,
              height: controller.page == index ? 17.h : 12.h,
              margin: const EdgeInsets.all(5),
              decoration: BoxDecoration(
                color: controller.page == index
                    ? AppColors.customButtonBlueColor
                    :Theme.of(context).primaryColorLight.withOpacity(0.5), // border color
                shape: BoxShape.circle,
              ));
        });
  }
}
