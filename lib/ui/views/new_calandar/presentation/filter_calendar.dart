import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:provider/provider.dart';

import '../../../../core/models/dummy_models/dummy_model.dart';
import '../../../../core/providers/calender_provider.dart';
import '../../../utils/colors/colors.dart';
import '../../../utils/images/images.dart';
import '../../../utils/textfield_helper/app_fonts.dart';

class FilterCalendar extends StatelessWidget {
  FilterCalendar({super.key});

  CalenderProvider? calenderProvider;

  @override
  Widget build(BuildContext context) {
    calenderProvider = Provider.of<CalenderProvider>(context, listen: false);

    return Container(
      padding: EdgeInsets.symmetric(horizontal: 10.w),
      decoration: BoxDecoration(
          color: AppColors.calendarBg,
          borderRadius: BorderRadius.only(
            topRight: Radius.circular(10.r),
            topLeft: Radius.circular(10.r),
          )),
      child: Wrap(
        /*mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.center,*/
        children: [
          Container(
            height: 20.h,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                height: 6.h,
                width: 60.w,
                decoration: BoxDecoration(
                    color: AppColors.appmainThemeColor,
                    borderRadius: BorderRadius.circular(10.r)),
              ),
            ],
          ),
          Container(
            height: 20.h,
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "Filter ",
                  style: w500_14Poppins(color: AppColors.whiteColor),
                ),
                GestureDetector(
                  onTap: () {
                    Navigator.pop(context);
                  },
                  child: SvgPicture.asset(
                    AppImages.iconClose,
                    color: Theme.of(context).primaryColorLight,
                    height: 22.w,
                    width: 22.w,
                  ),
                )
              ],
            ),
          ),
          Container(
            height: 1,
            margin: const EdgeInsets.symmetric(vertical: 10),
            color: Colors.grey.withOpacity(0.2),
          ),
          Container(
            height: 10.h,
          ),
          Consumer<CalenderProvider>(
              builder: (context, calenderProvider, child) {
            return Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Padding(
                      padding: EdgeInsets.only(left: 20.w,bottom: 10.h),
                      child: Text(
                        "Type of Product",
                        style: w500_14Poppins(color: Theme.of(context).hoverColor),
                      ),
                    ),
                  ],
                ),
                Wrap(
                  children: List.generate(
                    checkboxList.length,
                    (index) => Wrap(
                      children: [
                        Container(

                          width: MediaQuery.of(context).size.width/2-30,
                          margin:
                              EdgeInsets.symmetric(horizontal: 5.w, vertical: 5.h),
                          decoration: BoxDecoration(
                              color: AppColors.filterBg,
                              borderRadius: BorderRadius.circular(3.r)),
                          child: CheckboxListTile(
                            controlAffinity: ListTileControlAffinity.leading,
                            contentPadding: EdgeInsets.zero,
                            visualDensity: const VisualDensity(
                                horizontal: VisualDensity.minimumDensity),
                            dense: true,
                            title: Text(
                              checkboxList[index].checkboxText,
                              style: w400_14Poppins(
                                  color: Theme.of(context).primaryColorLight),
                            ),
                            checkColor: AppColors.whiteColor,
                            side: const BorderSide(color: AppColors.calendarBg2),
                            activeColor: AppColors.statusButtonCa,
                            value: checkboxList[index].isCheck,
                            onChanged: (value) {
                              // calenderProvider.updateCheckboxListIndex(value!, index);
                              calenderProvider!
                                  .updateSelectedOptions(value!, index);
                            },
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                SizedBox(
                  height: 20.h,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Padding(
                      padding: EdgeInsets.only(left: 20.w),
                      child: Text(
                        "Type of Contacts",
                        style: w500_14Poppins(color: Theme.of(context).hoverColor),
                      ),
                    ),
                  ],
                ),

                SizedBox(height:10.h,),
                Column(
                  children: List.generate(
                    checkboxListEvent.length,
                    (index) => Container(
                      margin:
                          EdgeInsets.symmetric(horizontal: 16.w, vertical: 5.h),
                      decoration: BoxDecoration(
                          color: AppColors.filterBg,
                          borderRadius: BorderRadius.circular(3.r)),
                      child: CheckboxListTile(
                        controlAffinity: ListTileControlAffinity.leading,
                        contentPadding: EdgeInsets.zero,
                        visualDensity: const VisualDensity(
                            horizontal: VisualDensity.minimumDensity),
                        dense: true,
                        title: Text(
                          checkboxListEvent[index].checkboxText,
                          style: w400_14Poppins(
                              color: Theme.of(context).primaryColorLight),
                        ),
                        checkColor: AppColors.whiteColor,
                        side: const BorderSide(color: AppColors.calendarBg2),
                        activeColor: AppColors.statusButtonCa,
                        value: checkboxListEvent[index].isCheck,
                        onChanged: (value) {
                          // calenderProvider.updateCheckboxListIndex(value!, index);
                          calenderProvider!
                              .updateSelectedOptionsEvent(value!, index);
                        },
                      ),
                    ),
                  ),
                ),
                SizedBox(
                  height: 20.h,
                ),
                Row(
                  children: [
                    Expanded(
                      child: GestureDetector(
                        onTap: () {
                          calenderProvider.clearAllFields();
                          Navigator.pop(context);
                        },
                        child: Container(
                          height: 45.h,
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(6.r),
                              color: AppColors.editTextColors.withOpacity(0.2)),
                          child: Center(
                            child: Text(
                              "Cancel",
                              textAlign: TextAlign.center,
                              style:
                                  w400_14Poppins(color: AppColors.whiteColor),
                            ),
                          ),
                        ),
                      ),
                    ),
                    SizedBox(
                      width: 20.w,
                    ),
                    Expanded(
                      child: GestureDetector(
                        onTap: () {
                          calenderProvider.applyFilter();
                          calenderProvider.allowSelection();
                          Navigator.pop(context);
                        },
                        child: Container(
                          height: 45.h,
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(6.r),
                              color: AppColors.calendarMonthText),
                          child: Center(
                            child: Text(
                              "Apply",
                              textAlign: TextAlign.center,
                              style:
                                  w400_14Poppins(color: AppColors.whiteColor),
                            ),
                          ),
                        ),
                      ),
                    )
                  ],
                ),
                SizedBox(
                  height: 20.h,
                ),

                /* CancelOkButtons(okTap: () async {
                  calenderProvider!.allowSelection();
                  Navigator.pop(context);
                }, cancelTap: () async {
                  calenderProvider!.clearAllFields();
                  Navigator.pop(context);
                }),*/
              ],
            );
          }),
        ],
      ),
    );
  }
}
