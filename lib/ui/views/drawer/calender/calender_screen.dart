import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:o_connect/core/common_functions.dart';
import 'package:o_connect/core/providers/calender_provider.dart';
import 'package:o_connect/core/routes/routes_name.dart';
import 'package:o_connect/core/screen_configs.dart';
import 'package:o_connect/ui/utils/colors/colors.dart';
import 'package:o_connect/ui/utils/constant_strings.dart';
import 'package:o_connect/ui/utils/custom_show_dialog_helper/custom_show_dialog.dart';
import 'package:o_connect/ui/utils/textfield_helper/app_fonts.dart';
import 'package:o_connect/ui/views/drawer/calender/monthwise_calender.dart';
import 'package:o_connect/ui/views/drawer/custom_drawer_view.dart';
import 'package:o_connect/ui/views/drawer/drawer_viewmodel.dart';
import 'package:provider/provider.dart';

import '../../../utils/common_app_bar/common_appbar.dart';
import 'day_wise_calender.dart';
import 'week_wise_calender.dart';
import 'widgets/calender_dropdown.dart';
import 'widgets/day_week_month_tabview.dart';

class MyCalenderScreen extends StatefulWidget {
  const MyCalenderScreen({super.key});

  @override
  State<MyCalenderScreen> createState() => _MyCalenderScreenState();
}

class _MyCalenderScreenState extends State<MyCalenderScreen> {
  late CalenderProvider cp;

  @override
  void initState() {
    cp = Provider.of<CalenderProvider>(context, listen: false);
    cp.fetchEventsInDay(context);
    cp.setSelectedItem(0, fromInitState: true);
    cp.onPageChangeDate = DateTime.now().toString();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        Provider.of<DrawerViewModel>(context, listen: false).mainSelectedChange(ConstantsStrings.home);
        return true;
      },
      child: Scaffold(
        appBar: commonAppBar(context, titleName: "My Calender"),
        drawer: const CustomDrawerView(),
        drawerEnableOpenDragGesture: false,
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        floatingActionButton: FloatingActionButton(
          backgroundColor: AppColors.calendarIconColor,
          elevation: 0,
          onPressed: () async {
            bool canCreate = await checkUserSubScription();
            if (canCreate) {
              Navigator.pushNamed(context, RoutesManager.createWebinarScreen);
            }
          },
          shape: const RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(30.0))),
          child: const Icon(Icons.add),
        ),
        body: SafeArea(
          child: Consumer<CalenderProvider>(builder: (key, calenderProvider, child) {
            return Padding(
              padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 13.h),
              child: SizedBox(
                height: ScreenConfig.height,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    GestureDetector(
                      onTap: () {
                        customShowDialog(context, const CalenderDropDownPopup(), height: ScreenConfig.height * 0.38);
                      },
                      child: Container(
                        padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 5.h),
                        decoration: BoxDecoration(
                          color: Theme.of(context).primaryColor,
                          borderRadius: BorderRadius.all(Radius.circular(4.r)),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              calenderProvider.checkboxSelectedText,
                              textAlign: TextAlign.start,
                              style: w400_14Poppins(color: Colors.white),
                            ),
                            Icon(
                              Icons.keyboard_arrow_down_rounded,
                              color: Theme.of(context).primaryColorLight,
                            )
                          ],
                        ),
                      ),
                    ),
                    height10,
                    SizedBox(height: 35.h, child: const DayWeekMonthTabViewWidget()),
                    height10,
                    calenderProvider.categorySelected == 0
                        ? const DayCalender()
                        : calenderProvider.categorySelected == 1
                            ? const WeekCalender()
                            : calenderProvider.categorySelected == 2
                                ? const MonthWiseCalender()
                                : const Text("calender data"),
                  ],
                ),
              ),
            );
          }),
        ),
      ),
    );
  }
}
