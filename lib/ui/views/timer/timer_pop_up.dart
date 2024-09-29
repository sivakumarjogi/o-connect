import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:o_connect/core/screen_configs.dart';
import 'package:o_connect/ui/utils/colors/colors.dart';
import 'package:o_connect/ui/utils/constant_strings.dart';
import 'package:o_connect/ui/utils/countrie_flags.dart';
import 'package:o_connect/ui/utils/custom_show_dialog_helper/custom_show_dialog.dart';
import 'package:o_connect/ui/utils/custom_toast_helper/custom_toast.dart';
import 'package:o_connect/ui/utils/network_image_helpers/cached_image_validation.dart';
import 'package:o_connect/ui/utils/textfield_helper/app_fonts.dart';
import 'package:o_connect/ui/utils/textfield_helper/common_textfield.dart';
import 'package:o_connect/ui/views/meeting/model/model.dart';
import 'package:o_connect/ui/views/meeting/providers/participants_provider.dart';
import 'package:o_connect/ui/views/themes/providers/webinar_themes_provider.dart';
import 'package:o_connect/ui/views/timer/provider/timer_provider.dart';
import 'package:o_connect/ui/views/webninar_dashboard/presentation/widgets/timer_toggle_buttons.dart';
import 'package:provider/provider.dart';

import '../../utils/buttons_helper/custom_botton.dart';

class TimerPopUp extends StatefulWidget {
  const TimerPopUp({Key? key}) : super(key: key);

  @override
  State<TimerPopUp> createState() => _TimerPopUpState();
}

class _TimerPopUpState extends State<TimerPopUp> {
  late TimerProvider timerProvider;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    timerProvider = Provider.of<TimerProvider>(context, listen: false);
    timerProvider.searchController = TextEditingController();
    timerProvider.clearTimeData();
    timerProvider.initParticipants(context);
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    timerProvider.searchController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer2<WebinarThemesProviders, TimerProvider>(builder: (context, webinarThemesProviders, timerProvider, child) {
      return Container(
        decoration: BoxDecoration(
          border: Border.all(color: webinarThemesProviders.colors.headerColor, width: 4.w),
          borderRadius: BorderRadius.only(topRight: Radius.circular(25.r), topLeft: Radius.circular(25.r)),
          color: webinarThemesProviders.colors.bodyColor ?? Theme.of(context).scaffoldBackgroundColor,
        ),
        child: Column(
          children: [
            showDialogCustomHeader(context, headerTitle: ConstantsStrings.timer),
            Expanded(
              child: Column(
                children: [
                  // height10,
                  // Padding(
                  //   padding: EdgeInsets.symmetric(horizontal: 30.w),
                  //   child: Text(ConstantsStrings.asAHostText,
                  //       textAlign: TextAlign.center,
                  //       style: w300_13Poppins(
                  //         color: Colors.white,
                  //       )),
                  // ),
                  height10,
                  /*  !timerProvider.showTimeView && timerProvider.participants.isNotEmpty
                      ?  */
                  SizedBox(
                    height: 40.h,
                    width: ScreenConfig.width * 0.9,
                    child: CommonTextFormField(
                      allowSpace: true,
                      fillColor: webinarThemesProviders.bgColor ?? Theme.of(context).primaryColor,
                      controller: timerProvider.searchController,
                      style: w400_12Poppins(color: webinarThemesProviders.hintTextColor),
                      keyboardType: TextInputType.text,
                      inputAction: TextInputAction.next,
                      onChanged: (value) {
                        timerProvider.updateTimeView(value);
                      },
                      suffixIcon: Icon(
                        Icons.search,
                        size: 25.sp,
                        color: webinarThemesProviders.hintTextColor,
                      ),
                      hintText: "Search",
                    ),
                  ),
                  height15,
                  Consumer2<TimerProvider, ParticipantsProvider>(builder: (context, timerProvider, participantsProvider, child) {
                    return /* timerProvider.selectedParticipant == null
                        ? timerProvider.searchedParticipants.isNotEmpty
                            ? */
                        timerProvider.searchedParticipants.isNotEmpty
                            ? SizedBox(
                                // height: ScreenConfig.height * 0.18,
                                child: SingleChildScrollView(
                                  scrollDirection: Axis.horizontal,
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: List.generate(
                                        timerProvider.searchedParticipants.length,
                                        (index) => InkWell(
                                              onTap: () {
                                                timerProvider.addParticipants(index);
                                              },
                                              child: Container(
                                                margin: EdgeInsets.symmetric(vertical: 2.h, horizontal: 5.w),
                                                decoration: BoxDecoration(
                                                    color: timerProvider.selectedParticipant?.id.toString() == timerProvider.searchedParticipants[index].id.toString()
                                                        ? webinarThemesProviders.colors.buttonColor
                                                        : webinarThemesProviders.colors.itemColor,
                                                    borderRadius: BorderRadius.circular(5.r)),
                                                child: Padding(
                                                  padding: EdgeInsets.symmetric(horizontal: 15.w, vertical: 5.h),
                                                  child: Column(
                                                    mainAxisSize: MainAxisSize.min,
                                                    children: [
                                                      SizedBox(
                                                        height: 50.h,
                                                        child: Stack(
                                                          alignment: Alignment.topCenter,
                                                          children: [
                                                            ClipRRect(
                                                              borderRadius: BorderRadius.circular(50.r),
                                                              child: SizedBox(
                                                                  width: 42.w,
                                                                  height: 42.w,
                                                                  child: ImageServiceWidget(
                                                                    imageBorderRadius: 50.r,
                                                                    networkImgUrl: timerProvider.searchedParticipants[index].profilePic,
                                                                  )),
                                                            ),
                                                            Align(alignment: Alignment.bottomCenter, child: Countries(countriesFlag: timerProvider.searchedParticipants[index].countryFlag))
                                                          ],
                                                        ),
                                                      ),
                                                      width10,
                                                      Column(
                                                        children: [
                                                          Text(
                                                            timerProvider.searchedParticipants[index].displayName ?? "",
                                                            style: w400_12Poppins(color: Theme.of(context).hintColor),
                                                          ),
                                                        ],
                                                      ),

                                                      // GestureDetector(
                                                      //   onTap: () {
                                                      //     timerProvider.addParticipants(index);
                                                      //   },
                                                      //   child: Icon(
                                                      //     Icons.add,
                                                      //     color: webinarThemesProviders.colors.textColor,
                                                      //     size: 18.sp,
                                                      //   ),
                                                      // )
                                                    ],
                                                  ),
                                                ),
                                              ),
                                            )),
                                  ),
                                ),
                              )
                            : SizedBox(
                                height: ScreenConfig.height * 0.18,
                                child: Center(
                                    child: Text(
                                  "No Speakers",
                                  style: w400_14Poppins(color: Theme.of(context).hintColor),
                                )),
                              );
                  }),
                  height10,
                  if (timerProvider.selectedParticipant != null)
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 16.w),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text("Enter custom timer below: ",
                              textAlign: TextAlign.center,
                              style: w400_12Poppins(
                                color: Theme.of(context).hintColor,
                              )),
                          height10,
                          // Row(
                          //   mainAxisAlignment: MainAxisAlignment.center,
                          //   children: [
                          //     TimerToggleButtons(
                          //       addTime: AddTime.two,
                          //       isSelected: timerProvider.selectedTime == AddTime.two,
                          //       buttonName: '2 mins',
                          //       onPressed: timerProvider.updateTotalTime,
                          //     ),
                          //     TimerToggleButtons(
                          //       addTime: AddTime.five,
                          //       isSelected: timerProvider.selectedTime == AddTime.five,
                          //       buttonName: '5 mins',
                          //       onPressed: timerProvider.updateTotalTime,
                          //     ),
                          //     TimerToggleButtons(
                          //       addTime: AddTime.ten,
                          //       isSelected: timerProvider.selectedTime == AddTime.ten,
                          //       buttonName: '10 mins',
                          //       onPressed: timerProvider.updateTotalTime,
                          //     ),
                          //     TimerToggleButtons(
                          //       addTime: AddTime.fifteen,
                          //       isSelected: timerProvider.selectedTime == AddTime.fifteen,
                          //       buttonName: '15 mins',
                          //       onPressed: timerProvider.updateTotalTime,
                          //     ),
                          //   ],
                          // ),
                          // height20,
                          Container(
                            padding: EdgeInsets.all(10.sp),
                            decoration: BoxDecoration(color: Provider.of<WebinarThemesProviders>(context, listen: false).colors.itemColor, borderRadius: BorderRadius.circular(5.r)),
                            child: Row(
                              children: [
                                ClipRRect(
                                  borderRadius: BorderRadius.circular(50.r),
                                  child: SizedBox(
                                      width: 42.w,
                                      height: 42.w,
                                      child: ImageServiceWidget(
                                        imageBorderRadius: 50.r,
                                        networkImgUrl: timerProvider.selectedParticipant?.profilePic,
                                      )),
                                ),
                                // width10,
                                Column(
                                  children: [
                                    Text(
                                      timerProvider.selectedParticipant!.displayName.toString(),
                                      style: w400_14Poppins(color: Colors.white),
                                    ),
                                    Row(
                                      children: [
                                        Text(
                                          "Speaker ",
                                          style: w400_12Poppins(color: Colors.white),
                                        ),
                                        Countries(countriesFlag: timerProvider.selectedParticipant?.countryFlag)
                                      ],
                                    ),
                                  ],
                                ),
                                const Spacer(),
                                Consumer<TimerProvider>(builder: (_, timeProvide, __) {
                                  return Container(
                                    width: 100.w,
                                    height: 45.h,
                                    padding: EdgeInsets.only(left: 10.w),
                                    decoration: BoxDecoration(border: Border.all(color: Colors.grey, width: 1), borderRadius: BorderRadius.circular(5.r)),
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text(
                                          timerProvider.formatTotalTimeInSeconds,
                                          style: w400_14Poppins(color: Theme.of(context).hintColor),
                                        ),
                                        Column(
                                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                          children: [
                                            RotatedBox(
                                              quarterTurns: 1,
                                              child: InkWell(
                                                onTap: () {
                                                  timerProvider.increaseDecreaseTime(type: "increase");
                                                },
                                                child: Container(
                                                  height: 30.w,
                                                  width: 20.w,
                                                  decoration: const BoxDecoration(color: Color(0xff292B2C), borderRadius: BorderRadius.only(topLeft: Radius.circular(5), topRight: Radius.circular(5))),
                                                  child: Icon(
                                                    Icons.arrow_back_ios_new,
                                                    size: 16.sp,
                                                  ),
                                                ),
                                              ),
                                            ),
                                            RotatedBox(
                                              quarterTurns: 3,
                                              child: InkWell(
                                                onTap: () {
                                                  timerProvider.increaseDecreaseTime(type: "decrease");
                                                },
                                                child: Container(
                                                  height: 30.w,
                                                  width: 20.w,
                                                  decoration:
                                                      const BoxDecoration(color: Color(0xff292B2C), borderRadius: BorderRadius.only(bottomLeft: Radius.circular(5), bottomRight: Radius.circular(5))),
                                                  child: Icon(
                                                    Icons.arrow_back_ios_new,
                                                    size: 16.sp,
                                                  ),
                                                ),
                                              ),
                                            )
                                          ],
                                        )
                                      ],
                                    ),
                                  );
                                }),
                              ],
                            ),
                          ),
                          // Row(
                          //   mainAxisAlignment: MainAxisAlignment.center,
                          //   children: [
                          //     InkWell(
                          //       onTap: () {
                          //         timerProvider.increaseDecreaseTime(type: "increase");
                          //       },
                          //       child: Container(
                          //         width: 30.w,
                          //         height: 30.w,
                          //         decoration: BoxDecoration(
                          //             borderRadius: BorderRadius.only(topLeft: Radius.circular(5.r), bottomLeft: Radius.circular(5.r)),
                          //             color: webinarThemesProviders.colors.itemColor ?? AppColors.appmainThemeColor),
                          //         child: Center(
                          //             child: Icon(
                          //           Icons.add,
                          //           color: webinarThemesProviders.themeHighLighter != null ? Theme.of(context).hoverColor : Colors.blue,
                          //         )),
                          //       ),
                          //     ),
                          //     Container(
                          //       width: 80.w,
                          //       height: 30.w,
                          //       decoration: BoxDecoration(border: Border.symmetric(horizontal: BorderSide(color: webinarThemesProviders.colors.itemColor, width: 1))),
                          //       child: Center(
                          //           child: Text(
                          //         timerProvider.formatTotalTimeInSeconds,
                          //         style: w400_14Poppins(color: Theme.of(context).hintColor),
                          //       )),
                          //     ),
                          //     InkWell(
                          //       onTap: () {
                          //         timerProvider.increaseDecreaseTime(type: "decrease");
                          //       },
                          //       child: Container(
                          //         width: 30.w,
                          //         height: 30.w,
                          //         decoration:
                          //             BoxDecoration(borderRadius: BorderRadius.only(topRight: Radius.circular(5.r), bottomRight: Radius.circular(5.r)), color: webinarThemesProviders.colors.itemColor),
                          //         child: Center(
                          //             child: Icon(
                          //           Icons.remove,
                          //           color: webinarThemesProviders.themeHighLighter != null ? Theme.of(context).hoverColor : Colors.blue,
                          //         )),
                          //       ),
                          //     ),
                          //   ],
                          // ),
                        ],
                      ),
                    )
                ],
              ),
            ),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 10.w),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  CustomButton(
                    width: ScreenConfig.width * 0.4,
                    buttonColor: Colors.transparent,
                    borderColor: webinarThemesProviders.colors.buttonColor ?? AppColors.mainBlueColor,
                    buttonText: "Cancel",
                    onTap: () {
                      timerProvider.clearTimeData();
                      Navigator.pop(context);
                    },
                    buttonTextStyle: w500_14Poppins(color: webinarThemesProviders.colors.textColor ?? AppColors.mainBlueColor),
                  ),
                  width20,
                  Consumer<TimerProvider>(builder: (context, timerProvider, child) {
                    return CustomButton(
                      width: ScreenConfig.width * 0.4,
                      buttonColor: timerProvider.searchedParticipants.isEmpty
                          ? webinarThemesProviders.colors.buttonColor.withOpacity(0.4)
                          : webinarThemesProviders.colors.buttonColor ?? AppColors.mainBlueColor,
                      buttonText: "Set Timer",
                      onTap: timerProvider.searchedParticipants.isEmpty
                          ? () {
                              CustomToast.showErrorToast(msg: "Select at least one attendee");
                            }
                          : () {
                              if (timerProvider.selectedParticipant == null) {
                                CustomToast.showErrorToast(msg: "Select at least one attendee");
                                return;
                              }
                              timerProvider.setTimerGlobalSet(context);
                              // timerProvider.showTimeView = false;
                              Navigator.pop(context);
                            },
                      buttonTextStyle: w500_14Poppins(color: AppColors.whiteColor),
                    );
                  }),
                ],
              ),
            )
          ],
        ),
      );
    });
  }
}
