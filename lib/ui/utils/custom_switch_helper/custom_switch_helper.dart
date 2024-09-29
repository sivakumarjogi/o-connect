import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:o_connect/ui/utils/images/images.dart';

import '../custom_toast_helper/custom_toast.dart';

class CustomSwitch extends StatefulWidget {
  final bool value;
  final ValueChanged<bool> onChanged;

  const CustomSwitch({super.key, required this.value, required this.onChanged});

  @override
  _CustomSwitchState createState() => _CustomSwitchState();
}

class _CustomSwitchState extends State<CustomSwitch> with SingleTickerProviderStateMixin {
  late Animation _circleAnimation;
  late AnimationController _animationController;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(vsync: this, duration: const Duration(milliseconds: 60));
    _circleAnimation = AlignmentTween(begin: widget.value ? Alignment.centerRight : Alignment.centerLeft, end: widget.value ? Alignment.centerLeft : Alignment.centerRight)
        .animate(CurvedAnimation(parent: _animationController, curve: Curves.linear));
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _animationController,
      builder: (context, child) {
        return GestureDetector(
          onTap: () {
            CustomToast.showInfoToast(msg: "Coming Soon...");
            // if (_animationController.isCompleted) {
            //   _animationController.reverse();
            // } else {
            //   _animationController.forward();
            // }
            // widget.value == false
            //     ? widget.onChanged(true)
            //     : widget.onChanged(false);
          },
          child: Container(
            width: 45.0.w,
            height: 28.0.h,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(24.0.r),
              image: DecorationImage(image: AssetImage(_animationController.isCompleted ? AppImages.dark_theme_icon : AppImages.light_theme_icon), fit: BoxFit.fill),
              color: _circleAnimation.value == Alignment.centerLeft ? Colors.grey : Colors.blue,
            ),
            child: Padding(
              padding: EdgeInsets.all(2.sp),
              child: Align(
                alignment: _animationController.isCompleted ? Alignment.centerLeft : Alignment.centerRight,
                child: Container(
                  width: 20.0.w,
                  height: 20.0.w,
                  decoration: const BoxDecoration(shape: BoxShape.circle, color: Colors.white),
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
