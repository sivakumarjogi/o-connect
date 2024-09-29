import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:o_connect/core/providers/calender_provider.dart';
import 'package:o_connect/core/routes/routes_name.dart';
import 'package:o_connect/ui/utils/colors/colors.dart';
import 'package:o_connect/ui/utils/custom_show_dialog_helper/custom_show_dialog.dart';
import 'package:o_connect/ui/utils/images/images.dart';
import 'package:o_connect/ui/utils/textfield_helper/app_fonts.dart';
import 'package:o_connect/ui/views/drawer/calender/widgets/month_year_scroll_view.dart';
import 'package:provider/provider.dart';

class EventsButton extends StatefulWidget {
  final String text;

  const EventsButton({super.key, required this.text});

  @override
  State<EventsButton> createState() => _EventsButtonState();
}

class _EventsButtonState extends State<EventsButton> {
  @override
  Widget build(BuildContext context) {
    return Consumer<CalenderProvider>(
      builder: (context, value, child) {
        return GestureDetector(
          onTap: () async {
            // if (value.categorySelected == 2) {
            //   customShowDialog(
            //     context,
            //     MonthYearSelector(
            //       initialMonth: DateTime.now(),
            //       onChanged: (val) {
            //         if (val.month != DateTime.now().month) {
            //           value.onPageChangeDate = val.toString();
            //           value.setStartEnd();
            //           value.fetchEventsInDay(context);
            //         }
            //       },
            //     ),
            //   );
            // } else {
            //   DateTime? pickedDate = await showDatePicker(
            //     context: context,
            //     initialDate: DateTime.now(),
            //     firstDate: DateTime(1990),
            //     lastDate: DateTime(DateTime.now().year + 2),
            //     builder: (context, child) {
            //       return Theme(
            //         data: Theme.of(context).copyWith(
            //           shadowColor: Colors.transparent,
            //           dialogBackgroundColor: Theme.of(context).scaffoldBackgroundColor,
            //           textButtonTheme: TextButtonThemeData(
            //             style: TextButton.styleFrom(
            //               primary: Theme.of(context).primaryColorLight, // button text color
            //             ),
            //           ),
            //           textTheme: Theme.of(context).textTheme.apply(bodyColor: Colors.white),
            //           colorScheme: ColorScheme.light(
            //                   primary: Theme.of(context).primaryColor,
            //                   onPrimary: Theme.of(context).primaryColorLight,
            //                   background: Theme.of(context).primaryColorLight,
            //                   onBackground: Theme.of(context).primaryColorLight,
            //                   surface: Theme.of(context).primaryColorLight,
            //                   onSurface: Theme.of(context).primaryColorLight)
            //               .copyWith(background: Colors.red),
            //         ),
            //         child: child!,
            //       );
            //     },
            //   );
            //   if (pickedDate != null) {
            //     if (DateTime.parse(value.onPageChangeDate).month != pickedDate.month) {
            //       value.onPageChangeDate = pickedDate.toString();

            //       value.setStartEnd();
            //       value.fetchEventsInDay(context);
            //     } else {
            //       value.onPageChangeDate = pickedDate.toString();
            //     }
            //     value.callNotify();
            //   }
            // }
          },
          child: Card(
            elevation: 0,
            color: Theme.of(context).primaryColor,
            margin: EdgeInsets.only(bottom: 10.h),
            child: Padding(
              padding: EdgeInsets.all(5.0.sp),
              child: Row(
                children: [
                  SizedBox(width: 10.w),
                  Text(
                    widget.text,
                    style: w500_16Poppins(color: AppColors.mainBlueColor),
                  ),
                  SizedBox(width: 10.w),
                  const Icon(
                    Icons.calendar_month_sharp,
                    color: AppColors.mainBlueColor,
                    size: 20,
                  ),
                  const Spacer(),
                  GestureDetector(
                    onTap: () {
                      Navigator.pushNamed(context, RoutesManager.viewAllEventsInCalender);
                      // customShowDialog(context, const EventsPopup());
                    },
                    child: Padding(
                      padding: const EdgeInsets.only(right: 20.0, bottom: 5),
                      child: SvgPicture.asset(AppImages.calendarViewIcon, color: AppColors.mainBlueColor),
                    ),
                  )
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
