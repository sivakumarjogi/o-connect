import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:o_connect/core/common_functions.dart';
import 'package:o_connect/core/providers/library_provider.dart';
import 'package:o_connect/core/screen_configs.dart';
import '../../../utils/colors/colors.dart';
import '../../../utils/textfield_helper/app_fonts.dart';

class StartAndEndDate extends StatelessWidget {
  const StartAndEndDate({super.key, required this.provider});

  final LibraryProvider provider;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        GestureDetector(
          onTap: () async {
            final DateTime? pickedDate = await showDatePicker(
              context: context,
              initialDate: provider.startDate.toConvertedDateTime(),
              firstDate: provider.libraryDropdownSelectedItem == "Meeting History" ? provider.startDate.toConvertedDateTime() : DateTime(DateTime.now().year - 2),
              lastDate: DateTime.now(),
              builder: (context, child) {
                return Theme(
                  data: Theme.of(context).copyWith(
                      shadowColor: Colors.transparent,
                      dialogBackgroundColor: Theme.of(context).scaffoldBackgroundColor,
                      textTheme: const TextTheme(),
                      textButtonTheme: TextButtonThemeData(
                        style: TextButton.styleFrom(
                          foregroundColor: Theme.of(context).primaryColorLight, // button text color
                        ),
                      ),
                      colorScheme: AppColors.datePickerThemeColorScheme),
                  child: child!,
                );
              },
            );
            if (pickedDate != null) {
              provider.updateStartDate(pickedDate);
            }
          },
          child: Container(
            padding: EdgeInsets.symmetric(horizontal: 10.0.w, vertical: 5.h),
            width: MediaQuery.of(context).size.width * 0.43,
            height: 40.h,
            decoration: BoxDecoration(borderRadius: BorderRadius.circular(5.r), color: Theme.of(context).cardColor),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(provider.startDate, style: w400_14Poppins(color: Theme.of(context).hintColor)),
                Icon(
                  Icons.calendar_today_outlined,
                  color: Theme.of(context).disabledColor,
                  size: 20,
                )
              ],
            ),
          ),
        ),
        width20,
        GestureDetector(
          onTap: () async {
            /* if (provider.startPickedDate == null) {
              CustomToast.showErrorToast(msg: "Please select startDate");
            } else {*/
            final DateTime? endDate = await showDatePicker(
              context: context,
              initialDate: DateTime.now(),
              firstDate: provider.startDate.toConvertedDateTime(),
              lastDate: DateTime.now(),
              builder: (context, child) {
                return Theme(
                  data: Theme.of(context).copyWith(
                      shadowColor: Colors.transparent,
                      textTheme: const TextTheme(),
                      dialogBackgroundColor: Theme.of(context).scaffoldBackgroundColor,
                      textButtonTheme: TextButtonThemeData(
                        style: TextButton.styleFrom(
                          foregroundColor: Theme.of(context).primaryColorLight, // button text color
                        ),
                      ),
                      colorScheme: AppColors.datePickerThemeColorScheme),
                  child: child!,
                );
              },
            );
            if (endDate != null) {
              provider.updateEndDate(endDate);
            }
            // }
          },
          child: Container(
            padding: EdgeInsets.symmetric(horizontal: 10.0.w, vertical: 5.h),
            width: ScreenConfig.width * 0.43,
            height: 40.h,
            decoration: BoxDecoration(borderRadius: BorderRadius.circular(5.r), color: Theme.of(context).cardColor),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(provider.endDate, style: w400_14Poppins(color: Theme.of(context).hintColor)),
                Icon(
                  Icons.calendar_today_outlined,
                  color: Theme.of(context).disabledColor,
                  size: 20,
                )
              ],
            ),
          ),
        ),
      ],
    );
  }
}
