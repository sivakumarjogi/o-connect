import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:intl/intl.dart';
import 'package:o_connect/core/providers/library_provider.dart';
import 'package:o_connect/core/screen_configs.dart';
import 'package:o_connect/ui/utils/buttons_helper/custom_botton.dart';
import 'package:o_connect/ui/utils/colors/colors.dart';
import 'package:o_connect/ui/utils/custom_show_dialog_helper/custom_show_dialog.dart';
import 'package:o_connect/ui/utils/images/images.dart';
import 'package:o_connect/ui/utils/textfield_helper/app_fonts.dart';
import 'package:o_connect/ui/views/home_screen/home_screen_provider/home_screen_provider.dart';
import 'package:o_connect/ui/views/webinar_details/webinar_details_provider/webinar_details_provider.dart';
import 'package:provider/provider.dart';
import 'package:syncfusion_flutter_datepicker/datepicker.dart';
import '../../../../utils/constant_strings.dart';
import '../../../../utils/textfield_helper/common_textfield.dart';

class SearchWidget extends StatelessWidget {
  const SearchWidget({super.key, required this.controller});

  final TextEditingController controller;

  @override
  Widget build(BuildContext context) {
    return Consumer2<HomeScreenProvider, WebinarDetailsProvider>(builder: (context, homeScreenProvider, provider, child) {
      return CommonTextFormField(
        borderColor: Theme.of(context).primaryColorDark,
        fillColor: Theme.of(context).scaffoldBackgroundColor,
        controller: controller,
        keyboardType: TextInputType.text,
        hintText: ConstantsStrings.search,
        prefixIcon: Padding(
          padding: EdgeInsets.all(5.0.sp),
          child: Icon(
            Icons.search,
            size: 20.sp,
            color: Theme.of(context).primaryColorLight,
          ),
        ),
        suffixIcon: InkWell(
          onTap: () {
            provider.searchBoxEnableDisable();
          },
          child: Icon(
            Icons.close,
            color: Theme.of(context).primaryColorLight,
          ),
        ),
        onChanged: (value) {
          print(value.toString());
          // homeScreenProvider.localSearchForMeetingRequest(value);

          if (value.length > 2) {
            homeScreenProvider.getMeetings(context, searchHistory: value.toString());
          } else if (value.isEmpty) {
            homeScreenProvider.getMeetings(context, searchHistory: "");
          } else if (value.length > 2) {
            context.read<LibraryProvider>().fetchTemplateFirstLoadRunning(searchedTextValue: value.toString());
          } else if (value.isEmpty) {
            context.read<LibraryProvider>().fetchTemplateFirstLoadRunning(searchedTextValue: "");
          }
        },
        inputAction: TextInputAction.next,
      );
    });
  }
}

class DateWidget extends StatelessWidget {
  const DateWidget({super.key, required this.provider, required this.screenName});

  final WebinarDetailsProvider provider;
  final String screenName;

  @override
  Widget build(BuildContext context) {
    return CommonTextFormField(
      key: UniqueKey(),
      borderColor: Colors.grey.shade100,
      fillColor: Theme.of(context).cardColor,
      readOnly: true,
      onTap: () {
        // screenName != "Statistics" ? provider.updateDateRangePickerValue() : provider.upDateInStatisticsCalenderView();
        customShowDialog(context, RangeCalenderWidget(provider: provider, screenName: "Statistics"));
      },
      controller: provider.dateController,
      keyboardType: TextInputType.text,
      hintText: screenName != "Statistics" ? provider.startEndDate : provider.startEndDateStatics,
      hintStyle: w400_14Poppins(color: Colors.white),
      style: w400_14Poppins(color: Colors.white),
      suffixIcon: Padding(
        padding: EdgeInsets.all(9.0.sp),
        child: SvgPicture.asset(
          AppImages.dashboardCalendarIcon,
        ),
      ),
      inputAction: TextInputAction.next,
    );
  }
}

class RangeCalenderWidget extends StatelessWidget {
  const RangeCalenderWidget({super.key, required this.provider, required this.screenName});

  final WebinarDetailsProvider provider;
  final String screenName;

  @override
  Widget build(BuildContext context) {
    return Consumer<HomeScreenProvider>(builder: (context, homeScreeProvider, child) {
      return Container(
        decoration: BoxDecoration(color: Theme.of(context).cardColor, borderRadius: BorderRadius.only(topLeft: Radius.circular(15.r), topRight: Radius.circular(15.r))),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            height15,
            Container(
              height: 5.h,
              width: 60.w,
              decoration: BoxDecoration(borderRadius: BorderRadius.circular(10.r), color: Theme.of(context).primaryColorLight.withOpacity(0.2)),
            ),
            height10,
            SfDateRangePicker(
              selectionMode: DateRangePickerSelectionMode.range,
              maxDate: DateTime.now(),
              headerStyle: DateRangePickerHeaderStyle(
                  textStyle: TextStyle(
                    color: Theme.of(context).hintColor,
                  ),
                  textAlign: TextAlign.center),
              yearCellStyle: DateRangePickerYearCellStyle(disabledDatesTextStyle: TextStyle(color: Theme.of(context).disabledColor), textStyle: TextStyle(color: Theme.of(context).primaryColorLight)),
              rangeTextStyle: TextStyle(color: Theme.of(context).primaryColorLight),
              // monthViewSettings: DateRangePickerMonthViewSettings(
              //   viewHeaderStyle: DateRangePickerViewHeaderStyle(textStyle: TextStyle(color: Theme.of(context).primaryColorLight))),
              monthViewSettings: DateRangePickerMonthViewSettings(
                viewHeaderStyle: DateRangePickerViewHeaderStyle(
                  textStyle: TextStyle(color: Theme.of(context).primaryColorLight),
                ),
                firstDayOfWeek: DateTime.monday, // Set the first day of the week to Monday
              ),
              monthCellStyle: DateRangePickerMonthCellStyle(
                todayCellDecoration: BoxDecoration(
                    color: AppColors.customButtonBlueColor, // Set background color to yellow for the current date
                    borderRadius: BorderRadius.circular(6.r) // Optionally, set the shape to circle
                    ),
                // weekendTextStyle: TextStyle(color: Colors.Fred),
                disabledDatesTextStyle: TextStyle(fontWeight: FontWeight.w300, fontSize: 15, color: Theme.of(context).primaryColor),
                textStyle: TextStyle(fontWeight: FontWeight.w400, fontSize: 15, color: Theme.of(context).primaryColorLight),
                todayTextStyle: TextStyle(fontSize: 15, fontWeight: FontWeight.w500, color: Theme.of(context).hintColor),
              ),

              onSelectionChanged: (DateRangePickerSelectionChangedArgs dateRange) {
                provider.calendarDateRange = dateRange.value as PickerDateRange;

                //    screenName != "Statistics"
                //     ? provider.updateStartAndEndDates(startedDate: calendarDateRange.startDate, endedDate: calendarDateRange.endDate)
                //     : provider.updateStartAndEndDatesStastics(startedDate: calendarDateRange.startDate, endedDate: calendarDateRange.endDate);

                // homeScreeProvider.getMeetingStatisticsInfo(provider.sData, provider.eData);

                // print(calendarDateRange.startDate.toString().split(" ").first);
                // print(calendarDateRange.endDate.toString().split(" ").first);
              },
            ),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 10.w),
              child: Divider(),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Column(
                  children: [
                    Text(
                      "Start Date",
                      style: w400_12Poppins(color: Theme.of(context).primaryColorLight),
                    ),
                    Text(provider.sData, style: w400_12Poppins(color: Theme.of(context).hintColor))
                  ],
                ),
                Container(
                  width: 1, // Adjust width as needed
                  height: 30, // Adjust height as needed
                  color: Theme.of(context).primaryColorLight, // Ensure the color is visible
                ),
                Column(
                  children: [Text("End Date", style: w400_12Poppins(color: Theme.of(context).primaryColorLight)), Text(provider.eData, style: w400_12Poppins(color: Theme.of(context).hintColor))],
                )
              ],
            ),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 10.w),
              child: const Divider(),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                CustomButton(
                  width: ScreenConfig.width * 0.45,
                  buttonColor: AppColors.customButtonBlueColor.withOpacity(0.1),
                  buttonText: "Cancel",
                  onTap: () {
                    screenName != "Statistics"
                        ? provider.updateStartAndEndDates(startedDate: provider.calendarDateRange!.startDate, endedDate: provider.calendarDateRange!.endDate)
                        : provider.updateStartAndEndDatesStastics(startedDate: provider.calendarDateRange!.startDate, endedDate: provider.calendarDateRange!.endDate);

                    homeScreeProvider.getMeetingStatisticsInfo(provider.sData, provider.eData);
                    // provider.dateController.text="";
                    // provider.startEndDateStatics="${DateFormat("MMM dd yyyy").format(DateTime.now().subtract(const Duration(days: 364)))}-${DateFormat("MMM dd yyyy").format(DateTime.now())}";
                    // homeScreeProvider.getMeetingStatisticsInfo("${DateFormat("MMM dd yyyy").format(DateTime.now().subtract(const Duration(days: 364)))}", "${DateFormat("MMM dd yyyy").format(DateTime.now())}");
                    Navigator.pop(context);
                  },
                ),
                width20,
                CustomButton(
                  width: ScreenConfig.width * 0.45,
                  buttonColor: AppColors.customButtonBlueColor,
                  buttonText: "Apply",
                  onTap: () {

                    print("call here data ${provider.calendarDateRange!.startDate}");
                    screenName != "Statistics"
                        ? provider.updateStartAndEndDates(startedDate: provider.calendarDateRange!.startDate, endedDate: provider.calendarDateRange!.endDate)
                        : provider.updateStartAndEndDatesStastics(startedDate: provider.calendarDateRange!.startDate, endedDate: provider.calendarDateRange!.endDate);

                    screenName != "Statistics" ? provider.updateDateRangePickerValue() : provider.upDateInStatisticsCalenderView();

                    homeScreeProvider.getMeetingStatisticsInfo(DateFormat('yyyy-M-d').format(provider.calendarDateRange!.startDate!), DateFormat('yyyy-M-d').format(provider.calendarDateRange!.endDate!)).then((value) => Navigator.pop(context));
                  },
                ),
              ],
            ),
            height10
          ],
        ),
      );
    });
  }
}

class EventRangeCalenderWidget extends StatelessWidget {
  const EventRangeCalenderWidget({super.key, required this.provider, required this.screenName});

  final WebinarDetailsProvider provider;
  final String screenName;

  @override
  Widget build(BuildContext context) {
    return Consumer<HomeScreenProvider>(builder: (context, homeScreeProvider, child) {
      return Container(
        decoration: BoxDecoration(color: Theme.of(context).cardColor, borderRadius: BorderRadius.only(topLeft: Radius.circular(15.r), topRight: Radius.circular(15.r))),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            height15,
            Container(
              height: 5.h,
              width: 60.w,
              decoration: BoxDecoration(borderRadius: BorderRadius.circular(10.r), color: Theme.of(context).primaryColorLight.withOpacity(0.2)),
            ),
            height10,
            SfDateRangePicker(
              selectionMode: DateRangePickerSelectionMode.range,
              maxDate: DateTime.now(),
              headerStyle: DateRangePickerHeaderStyle(
                  textStyle: TextStyle(
                    color: Theme.of(context).hintColor,
                  ),
                  textAlign: TextAlign.center),
              yearCellStyle: DateRangePickerYearCellStyle(disabledDatesTextStyle: TextStyle(color: Theme.of(context).disabledColor), textStyle: TextStyle(color: Theme.of(context).primaryColorLight)),
              rangeTextStyle: TextStyle(color: Theme.of(context).primaryColorLight),
              // monthViewSettings: DateRangePickerMonthViewSettings(
              //   viewHeaderStyle: DateRangePickerViewHeaderStyle(textStyle: TextStyle(color: Theme.of(context).primaryColorLight))),
              monthViewSettings: DateRangePickerMonthViewSettings(
                viewHeaderStyle: DateRangePickerViewHeaderStyle(
                  textStyle: TextStyle(color: Theme.of(context).primaryColorLight),
                ),
                firstDayOfWeek: DateTime.monday, // Set the first day of the week to Monday
              ),
              monthCellStyle: DateRangePickerMonthCellStyle(
                todayCellDecoration: BoxDecoration(
                    color: AppColors.customButtonBlueColor, // Set background color to yellow for the current date
                    borderRadius: BorderRadius.circular(6.r) // Optionally, set the shape to circle
                    ),
                // weekendTextStyle: TextStyle(color: Colors.Fred),
                disabledDatesTextStyle: TextStyle(fontWeight: FontWeight.w300, fontSize: 15, color: Theme.of(context).primaryColor),
                textStyle: TextStyle(fontWeight: FontWeight.w400, fontSize: 15, color: Theme.of(context).primaryColorLight),
                todayTextStyle: TextStyle(fontSize: 15, fontWeight: FontWeight.w500, color: Theme.of(context).hintColor),
              ),

              onSelectionChanged: (DateRangePickerSelectionChangedArgs dateRange) {
                PickerDateRange calendarDateRange = dateRange.value as PickerDateRange;
                screenName != "Statistics"
                    ? provider.updateStartAndEndDates(startedDate: calendarDateRange.startDate, endedDate: calendarDateRange.endDate)
                    : provider.updateStartAndEndDatesStastics(startedDate: calendarDateRange.startDate, endedDate: calendarDateRange.endDate);
                print(calendarDateRange.startDate.toString().split(" ").first);
                print(calendarDateRange.endDate.toString().split(" ").first);
              },
            ),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 10.w),
              child: Divider(),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Column(
                  children: [
                    Text(
                      "Start Date",
                      style: w400_12Poppins(color: Theme.of(context).primaryColorLight),
                    ),
                    Text(provider.sData, style: w400_12Poppins(color: Theme.of(context).hintColor))
                  ],
                ),
                Container(
                  width: 1, // Adjust width as needed
                  height: 30, // Adjust height as needed
                  color: Theme.of(context).primaryColorLight, // Ensure the color is visible
                ),
                Column(
                  children: [Text("End Date", style: w400_12Poppins(color: Theme.of(context).primaryColorLight)), Text(provider.eData, style: w400_12Poppins(color: Theme.of(context).hintColor))],
                )
              ],
            ),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 10.w),
              child: Divider(),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                CustomButton(
                  width: ScreenConfig.width * 0.45,
                  buttonColor: AppColors.customButtonBlueColor.withOpacity(0.1),
                  buttonText: "Cancel",
                  onTap: () {
                    Navigator.pop(context);
                  },
                ),
                width20,
                CustomButton(
                  width: ScreenConfig.width * 0.45,
                  buttonColor: AppColors.customButtonBlueColor,
                  buttonText: "Apply",
                  onTap: () {
                    screenName != "Statistics" ? provider.updateDateRangePickerValue() : provider.upDateInStatisticsCalenderView();
                    homeScreeProvider.getMeetingStatisticsInfo(provider.sData, provider.eData).then((value) => Navigator.pop(context));
                  },
                ),
              ],
            ),
            height10
          ],
        ),
      );
    });
  }
}

// SfDateRangePicker(
//   rangeTextStyle: TextStyle(
//     fontWeight: FontWeight.bold,
//     color: Theme.of(context).hintColor,
//   ),
//   rangeSelectionColor:
//       AppTheme.introductionCardDarkThemeHeadingColor,
//   backgroundColor: Theme.of(context).cardColor,
//   selectionShape: DateRangePickerSelectionShape.circle,
//   maxDate: DateTime.now(),
//   yearCellStyle: DateRangePickerYearCellStyle(
//     leadingDatesTextStyle:
//         TextStyle(color: Theme.of(context).hintColor),
//     textStyle: TextStyle(color: Theme.of(context).hintColor),
//     disabledDatesTextStyle: TextStyle(
//       color: Theme.of(context).hintColor.withOpacity(0.4),
//     ),
//   ),
//   monthViewSettings: DateRangePickerMonthViewSettings(
//       viewHeaderStyle: DateRangePickerViewHeaderStyle(
//           textStyle: TextStyle(
//     color: Theme.of(context).hintColor,
//   ))),
//   monthCellStyle: DateRangePickerMonthCellStyle(
//       textStyle:
//           TextStyle(color: Theme.of(context).hintColor),
//       blackoutDateTextStyle:
//           TextStyle(color: Theme.of(context).hintColor),
//       weekendTextStyle:
//           TextStyle(color: Theme.of(context).hintColor)),
//   headerStyle: DateRangePickerHeaderStyle(
//       textStyle:
//           TextStyle(color: Theme.of(context).hintColor)),
//   initialSelectedRange: widget.initialDateRange,
//   onSelectionChanged:
//       (DateRangePickerSelectionChangedArgs dateRange) {
//     PickerDateRange calendarDateRange =
//         dateRange.value as PickerDateRange;
//     context.read<CalendarDateRangeBloc>().add(
//           OnCalendarDateChangeEvent(
//             calendarDateRange: calendarDateRange,
//           ),
//         );
//     if (widget.onCalendarDatePickerChange != null) {
//       widget.onCalendarDatePickerChange!(calendarDateRange);
//     }
//   },
//   selectionMode: DateRangePickerSelectionMode.range,
// ),
