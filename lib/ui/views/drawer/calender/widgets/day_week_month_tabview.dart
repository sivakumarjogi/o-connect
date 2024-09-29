import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:o_connect/core/providers/calender_provider.dart';
import 'package:o_connect/core/screen_configs.dart';
import 'package:o_connect/ui/utils/colors/colors.dart';
import 'package:o_connect/ui/utils/textfield_helper/app_fonts.dart';
import 'package:provider/provider.dart';

class DayWeekMonthTabViewWidget extends StatefulWidget {
  const DayWeekMonthTabViewWidget({super.key});

  @override
  State<DayWeekMonthTabViewWidget> createState() => _DayWeekMonthTabViewWidgetState();
}

class _DayWeekMonthTabViewWidgetState extends State<DayWeekMonthTabViewWidget> {
  @override
  Widget build(BuildContext context) {
    return Consumer<CalenderProvider>(builder: (context, cp, child) {
      return ListView.separated(
          separatorBuilder: (BuildContext context, int index) => VerticalDivider(
                width: 10.w,
                color: Theme.of(context).splashColor,
              ),
          itemCount: cp.tabsList.length,
          shrinkWrap: true,
          scrollDirection: Axis.horizontal,
          itemBuilder: (context, index) {
            return InkWell(
              onTap: () {
                cp.setSelectedItem(index);
                cp.setStartEnd();
              },
              child: Container(
                width: ScreenConfig.width * 0.3,
                decoration: BoxDecoration(
                  borderRadius: const BorderRadius.all(Radius.circular(5.0)),
                  color: cp.categorySelected == index ? AppColors.mainBlueColor : Theme.of(context).primaryColor,
                ),
                child: Center(
                  child: Text(
                    cp.tabsList[index],
                    textAlign: TextAlign.center,
                    style: w500_13Poppins(color: cp.categorySelected == index ? Theme.of(context).primaryColorLight : AppColors.mainBlueColor),
                  ),
                ),
              ),
            );
          });
    });
  }
}
