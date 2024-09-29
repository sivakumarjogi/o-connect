import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:o_connect/ui/utils/textfield_helper/app_fonts.dart';
import 'package:provider/provider.dart';
import 'package:o_connect/ui/views/themes/providers/webinar_themes_provider.dart';

enum AddTime { two, five, ten, fifteen }

class TimerToggleButtons extends StatelessWidget {
  const TimerToggleButtons({Key? key, required this.addTime, required this.isSelected, required this.buttonName, required this.onPressed}) : super(key: key);

  final AddTime addTime;
  final bool isSelected;
  final String buttonName;
  final Function(AddTime) onPressed;

  @override
  Widget build(BuildContext context) {
    return InkWell(
        onTap: () => onPressed(addTime),
        child: Container(
          padding: EdgeInsets.all(5.sp),
          margin: EdgeInsets.symmetric(horizontal: 5.w),
          decoration: BoxDecoration(
            color: context.watch<WebinarThemesProviders>().colors.buttonColor,
            borderRadius: BorderRadius.circular(5.r),
          ),
          child: Center(
              child: Row(
            children: [
              Text(
                buttonName,
                style: w300_14Poppins(
                  color: Theme.of(context).hintColor,
                ),
              ),
            ],
          )),
        ));
  }
}
