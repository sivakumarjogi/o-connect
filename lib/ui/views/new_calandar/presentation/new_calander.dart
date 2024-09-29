import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:lottie/lottie.dart';
import 'package:o_connect/ui/views/new_calandar/presentation/week_day/weekdays.dart';
import 'package:provider/provider.dart';

import '../../../../core/common_functions.dart';
import '../../../../core/providers/calender_provider.dart';
import '../../../../core/routes/routes_name.dart';
import '../../../utils/colors/colors.dart';
import '../../../utils/common_app_bar/commonAppBarTitle.dart';
import '../../../utils/custom_show_dialog_helper/custom_show_dialog.dart';
import '../../../utils/images/images.dart';
import '../../../utils/textfield_helper/app_fonts.dart';
import '../../home_screen/home_screen_provider/home_screen_provider.dart';
import '../../webninar_dashboard/presentation/create_webinar/provider/create_webinar_provider.dart';
import '../model/calander_config.dart';
import '../model/calander_date_info.dart';
import 'calander_day_widget.dart';
import 'calander_view_component.dart';
import 'events_list.dart';
import 'filter_calendar.dart';
import 'week_day/calendar_week_view.dart';

class NewCalendar extends StatefulWidget {
  // bool isWeekView = false;

  const NewCalendar({super.key});

  @override
  State<NewCalendar> createState() => _NewCalendarState();
}

class _NewCalendarState extends State<NewCalendar> {
/*  DateTime selectedMonth = DateTime.now();

  DateTime selectedDay = DateTime.now();*/

  late CalenderProvider cp;
  late DateTime minDate;
  late DateTime maxDate;
  final GlobalKey _topContainerKey = GlobalKey();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    initializeCalenderProvider();
  }

  void initializeCalenderProvider() {
    cp = Provider.of<CalenderProvider>(context, listen: false);
    DateTime now = DateTime.now();
    minDate = DateTime(now.year - 5, 1, 1);
    maxDate = DateTime(now.year + 5, 1, 1);
    Future.delayed(
      const Duration(milliseconds: 3),
      () {
        cp.clearOldSelected();
        cp.isSelectedMethod(false);

        cp.isCalendarViewChanges(false);
        cp.clearAllFields();
        cp.fetchEventsAccordingToDate(context,
            startTime: DateTime(cp.selectedDay.year, cp.selectedDay.month, 1), endTime: DateTime(cp.selectedDay.year, cp.selectedDay.month + 1, 0), multipleSelectedCon: [], filterApplyEvent: []);
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: commonAppBarTitle(context, logoNotVisible: true, titleName: "My Calender"),
        backgroundColor: AppColors.lightBlackColor,
        body: NotificationListener<DraggableScrollableNotification>(
          onNotification: (notification) {
            // it will work when you use
            /*   if (notification is ScrollUpdateNotification) {
              print("check scroll up${notification.metrics.pixels}");
              if (notification.metrics.pixels > 5) {
                cp.isCalendarViewChanges(true);
              } else {
                cp.isCalendarViewChanges(false);
              }
            }*/

            if (notification.extent == 1.0) {
              cp.isCalendarViewChanges(true);
            } else {
              cp.isCalendarViewChanges(false);
            }

            return true;
          },
          child: Consumer<CalenderProvider>(builder: (key, calenderProvider, child) {
            return Stack(
              children: [
                Container(
                  key: _topContainerKey,
                  //      height:  calenderProvider.  isWeekView?155.h:700.h,
                  margin: EdgeInsets.only(left: 15.w, right: 15.w, top: 10.h),
                  decoration: BoxDecoration(
                    color: AppColors.calendarBg,
                    borderRadius: BorderRadius.circular(6.r),
                  ),
                  child: Wrap(
                    children: [
                      Container(
                        height: 10.h,
                      ),
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: 20.w),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              calenderProvider.isWeekView ? cp.formatMonthYear(calenderProvider.selectedDay) : cp.formatMonthYear(calenderProvider.selectedMonth),
                              style: w600_14Poppins(color: AppColors.calendarMonthText),
                            ),
                            GestureDetector(
                              onTap: () {
                                customShowDialog(context, FilterCalendar());
                              },
                              child: SvgPicture.asset(
                                AppImages.calendarFilter,
                                color: Theme.of(context).primaryColorLight,
                                height: 16.w,
                                width: 16.w,
                              ),
                            )
                          ],
                        ),
                      ),
                      Container(
                        height: 10.h,
                      ),
                      const WeekdaysWidget(),
                      Container(
                        height: 10.h,
                      ),
                      calenderProvider.isWeekView
                          ? CalendarWeekView(
                              curDate: calenderProvider.selectedDay,
                              dayBuilder: (e) {
                                final isSameDay = calenderProvider.selectedDay.day == e.date.day;

                                final showEventHint = calenderProvider.selectedDay.day == e.date.day;
                                return CalanderDayWidget(
                                  date: e.date,
                                  enabled: e.enabled,
                                  selected: cp.isSelected == false ? e.isToday : isSameDay,
                                  //  showEventHint: showEventHint,

                                  //hasEvents: state.hasEventsOnDay(e.date),
                                  onTap: () {
                                    cp.selectedDay = e.date;
                                    cp.selectedMonth = cp.selectedDay;
                                    cp.isSelectedMethod(true);
                                    debugPrint("call hrs CalendarWeekView");
                                    setState(() {});
                                    //   context.read<CalendarCubit>().onDayChanged(e.date);
                                  },
                                  applyBorder: e.applyBorder,
                                );
                              },
                            )
                          : CalanderView(
                              month: calenderProvider.selectedMonth,
                              config: CalendarConfig(maxDate: maxDate, minDate: minDate),
                              builder: (CalendarDateInfo e) {
                                return CalanderDayWidget(
                                  isToday: e.isToday,
                                  date: e.date,
                                  enabled: e.enabled && e.date.month == calenderProvider.selectedMonth.month && e.date.year == calenderProvider.selectedMonth.year,
                                  selected: cp.isSelected == false
                                      ? e.isToday
                                      : e.enabled && calenderProvider.selectedMonth.day == e.date.day && e.enabled && calenderProvider.selectedMonth.month == e.date.month,
                                  onTap: () {
                                    cp.selectedMonth = e.date;
                                    cp.selectedDay = cp.selectedMonth;
                                    cp.isSelectedMethod(true);
                                    setState(() {});
                                  },
                                  applyBorder: e.applyBorder,
                                );
                              }),
                      Container(
                        height: 10.h,
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(
                      top: calenderProvider.isWeekView
                          ? 180.h
                          : _getTopContainerHeight(context) > 331
                              ? _getTopContainerHeight(context) == 396
                                  ? 230
                                  : 158.h
                              : 150.h),
                  child: SizedBox.expand(
                      child: DraggableScrollableSheet(
                          minChildSize: 0.6,
                          initialChildSize: 0.6,
                          builder: (context, scrollController) {
                            scrollController.addListener(() {
                              print("cal gere data scrollController");
                              print("cal gere data scrollController${scrollController.offset}");
                            });
                            return Container(
                              color: AppColors.lightBlackColor,
                              child: Stack(
                                children: [
                                  CustomScrollView(
                                    physics: const AlwaysScrollableScrollPhysics(),
                                    controller: scrollController,
                                    slivers: [
                                      SliverPersistentHeader(
                                        pinned: true,
                                        floating: true,
                                        delegate: _MyHeaderDelegate(),
                                      ),
                                      SliverList(
                                        delegate: SliverChildListDelegate(
                                          [
                                            // list  data
                                            Padding(
                                              padding: EdgeInsets.only(top: 0.h),
                                              child: calenderProvider.isLoadingDataCale!
                                                  ? Padding(
                                                      padding: EdgeInsets.only(top: 100.h),
                                                      child: Center(child: Lottie.asset(AppImages.loadingJson, height: 40.w, width: 40.w)),
                                                    )
                                                  : calenderProvider.noDataFound == false && calenderProvider.calenderMonthEvent != null
                                                      ? EventList(calenderProvider.calenderMonthEvent, isSelected: calenderProvider.isSelected, dateTimeC: calenderProvider.selectedDay)
                                                      : Padding(
                                                          padding: EdgeInsets.only(top: 100.h),
                                                          child: Center(
                                                              child: Text(
                                                            "No Record Found",
                                                            style: w500_12Poppins(color: Theme.of(context).hintColor.withOpacity(0.8)),
                                                          )),
                                                        ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            );
                          })),
                ),
              ],
            );
          }),
        ),
        floatingActionButton: FloatingActionButton(
          backgroundColor: AppColors.calendarIconColor,
          elevation: 0,
          onPressed: () async {
            bool canCreate = await checkUserSubScription();
            if (canCreate) {
              //Navigator.pop(context);
              Provider.of<HomeScreenProvider>(context, listen: false).updateCurrentPage(2);
              //  Navigator.pushNamed(context, RoutesManager.createWebinarScreen);
            }
          },
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(60.r))),
          child: const Icon(Icons.add),
        ),
      ),
    );
  }

  int _getTopContainerHeight(BuildContext context) {
    if (_topContainerKey.currentContext != null && _topContainerKey.currentContext!.findRenderObject() != null) {
      RenderBox topContainerBox = _topContainerKey.currentContext!.findRenderObject() as RenderBox;
      print("what is new ${topContainerBox.size.height.toInt()}");
      return topContainerBox.size.height.toInt();
    } else {
      return 120;
    }
  }
}

class _MyHeaderDelegate extends SliverPersistentHeaderDelegate {
  @override
  Widget build(BuildContext context, double shrinkOffset, bool overlapsContent) {
    return Container(
      padding: const EdgeInsets.only(top: 7, bottom: 7),
      color: AppColors.lightBlackColor,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Container(
            height: 6.h,
            width: 60.w,
            decoration: BoxDecoration(
              color: AppColors.appmainThemeColor,
              borderRadius: BorderRadius.circular(10.r),
            ),
          ),
        ],
      ),
    );
  }

  @override
  double get maxExtent => 22.h; // Set the maximum height of the header

  @override
  double get minExtent => 22.h; // Set the minimum height of the header

  @override
  bool shouldRebuild(covariant SliverPersistentHeaderDelegate oldDelegate) {
    return false;
  }
}
