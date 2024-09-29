import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';
// import 'package:mediasoup_client_flutter/mediasoup_client_flutter.dart';
import 'package:o_connect/core/models/dummy_models/dummy_model.dart';
import 'package:o_connect/core/screen_configs.dart';
import 'package:o_connect/my_app.dart';
import 'package:o_connect/ui/views/authentication/form_validations.dart';
import 'package:o_connect/ui/views/meeting/utils/string_extension.dart';
import 'package:o_connect/ui/views/webninar_dashboard/presentation/create_webinar/widgets/event_remainder_card.dart';
import 'package:oes_chatbot/utils/extensions/sizedbox_extension.dart';
import 'package:provider/provider.dart';
import 'package:syncfusion_flutter_datepicker/datepicker.dart';

import '../../../../../utils/buttons_helper/custom_botton.dart';
import '../../../../../utils/colors/colors.dart';
import '../../../../../utils/constant_strings.dart';
import '../../../../../utils/drawerHelper/drawerHelper.dart';
import '../../../../../utils/textfield_helper/app_fonts.dart';
import '../../../../../utils/textfield_helper/common_textfield.dart';
import '../provider/create_webinar_provider.dart';

class TimeScheduleZoneWidget extends StatefulWidget {
  TimeScheduleZoneWidget(
      {super.key,
      this.urlShow,
      required this.controller,
      required this.animation,
      required this.animationController,
      required this.dateTimeAnimation,
      required this.dateTimeAnimationController,
      required this.dateController,
      required this.timeDateController,
      required this.timeAnimation,
      required this.timeAnimationController,
      this.isEdit});

  final TextEditingController controller;
  final TextEditingController dateController;
  late TextEditingController timeDateController;
  final Animation<double> animation;
  final AnimationController animationController;
  final Animation<double> dateTimeAnimation;
  final Animation<double> timeAnimation;
  final AnimationController dateTimeAnimationController;
  final AnimationController timeAnimationController;
  String? urlShow;

  bool? isEdit;

  @override
  State<TimeScheduleZoneWidget> createState() => _TimeScheduleZoneWidgetState();
}

class _TimeScheduleZoneWidgetState extends State<TimeScheduleZoneWidget> {
  late CreateWebinarProvider createWebinarProvider;
  TextEditingController exitUrlController = TextEditingController();

  String _getCurrentTime() {
    return DateFormat('HH:mm')
        .format(DateTime.now()); // Format the current time as HH:mm
  }

  /// Toggle Container
  _toggleContainer() {
    if (widget.animationController.isCompleted) {
      widget.animationController.reverse();
    } else {
      widget.animationController.forward();
    }
  }

  /// Toggle Container
  _dateTimeToggleContainer() {
    if (widget.dateTimeAnimationController.isCompleted) {
      widget.dateTimeAnimationController.reverse();
    } else {
      widget.dateTimeAnimationController.forward();
    }
  }

  _timeToggleContainer() {
    if (widget.timeAnimationController.isCompleted) {
      widget.timeAnimationController.reverse();
    } else {
      widget.timeAnimationController.forward();
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    createWebinarProvider =
        Provider.of<CreateWebinarProvider>(context, listen: false);

    widget.timeDateController.text =
        DateTime.now().toString().substring(11, 16);

    super.initState();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    exitUrlController.dispose();
    super.dispose();
  }

  clearValues() {
    exitUrlController.clear();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
          color: Theme.of(context).cardColor,
          borderRadius: BorderRadius.circular(10.sp)),
      child: Padding(
        padding: EdgeInsets.all(10.sp),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              ConstantsStrings.timeSchedule,
              style: w500_16Poppins(color: Theme.of(context).hintColor),
            ),
            height10,
            Text(
              "Date",
              style: w400_13Poppins(color: Theme.of(context).hintColor),
            ),
            height5,
            CommonTextFormField(
              borderColor: Theme.of(context).primaryColorDark,
              fillColor: Theme.of(context).cardColor,
              readOnly: true,
              onTap: () {
                showModalBottomSheet(
                    isScrollControlled: true,
                    backgroundColor: Theme.of(context).scaffoldBackgroundColor,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.only(
                            topRight: Radius.circular(24.r),
                            topLeft: Radius.circular(24.r))),
                    context: context,
                    builder: (context) {
                      return Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          10.h.height,
                          Align(
                            alignment: Alignment.center,
                            child: Container(
                              height: 5.h,
                              width: 100.w,
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(20.r),
                                  color: const Color(0xff202223)),
                            ),
                          ),
                          10.h.height,
                          SfDateRangePicker(
                            selectionMode: DateRangePickerSelectionMode.single,
                            minDate: DateTime.now(),
                            showNavigationArrow: true,
                            todayHighlightColor: Colors.blue,
                            yearCellStyle: DateRangePickerYearCellStyle(
                                textStyle: w400_14Poppins(color: Colors.white),
                                disabledDatesTextStyle:
                                    w400_14Poppins(color: Colors.white),
                                leadingDatesTextStyle:
                                    w400_14Poppins(color: Colors.white)),
                            monthCellStyle: DateRangePickerMonthCellStyle(
                              textStyle: w400_14Poppins(color: Colors.white),
                              disabledDatesTextStyle: w400_14Poppins(
                                  color: Theme.of(context).primaryColorLight),
                            ),
                            monthViewSettings: DateRangePickerMonthViewSettings(
                              viewHeaderStyle: DateRangePickerViewHeaderStyle(
                                  textStyle: w400_14Poppins(
                                      color:
                                          Theme.of(context).primaryColorLight)),
                            ),
                            headerStyle: DateRangePickerHeaderStyle(
                                textAlign: TextAlign.center,
                                textStyle: w400_14Poppins(
                                    color: Theme.of(context).indicatorColor)),
                            onSelectionChanged:
                                (DateRangePickerSelectionChangedArgs
                                    dateRange) {
                              print("fast time call");
                              createWebinarProvider
                                  .updateSelectedDateValue(dateRange.value);
                              //    createWebinarProvider.changeMeetingCountDateFormat = dateRange.value.meetingCountFormat;

                              /* setState(() {

                         });*/
                            },
                          ),
                          height10,
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Row(
                              children: [
                                CustomButton(
                                  buttonText: "Cancel",
                                  buttonColor: const Color(0xff1B2632),
                                  width: ScreenConfig.width * 0.46,
                                  onTap: () {
                                    Navigator.pop(context);
                                  },
                                ),
                                10.w.width,
                                CustomButton(
                                  width: ScreenConfig.width * 0.46,
                                  buttonText: "Apply",
                                  onTap: () {
                                    // createWebinarProvider
                                    //     .updateDateView(widget.dateController);
                                    widget.dateController.text =
                                        createWebinarProvider.selectedDate;
                                    _dateTimeToggleContainer();
                                    Navigator.pop(context);
                                  },
                                ),
                              ],
                            ),
                          )
                        ],
                      );
                    });
              },
              style: w400_14Poppins(color: Theme.of(context).hintColor),
              labelStyle: w400_14Poppins(color: Theme.of(context).hintColor),
              controller: widget.dateController,
              hintStyle: w400_14Poppins(color: Theme.of(context).hintColor),
              hintText: "meeting date",
              errorMaxLines: 2,
              validator: (value, fieldName) {
                print("the value is the $value");
                // DateTime now = DateTime.now();
                // DateFormat format = DateFormat("MMM dd,yyyy");
                // String formatted = DateFormat.yMMMEd().format(now);
                // DateTime selectedTime = format.parse(value);

                return FormValidations.checkUserSubScriptionEndDate(
                    value, fieldName);
              },
              keyboardType: TextInputType.text,
              suffixIcon: Icon(
                Icons.calendar_today_outlined,
                size: 18.sp,
                color: Theme.of(context).primaryColorLight,
              ),
              inputAction: TextInputAction.next,
            ),
            height10,
            Text(
              "Time",
              style: w400_13Poppins(color: Theme.of(context).hintColor),
            ),
            height5,
            CommonTextFormField(
              borderColor: Theme.of(context).primaryColorDark,
              fillColor: Theme.of(context).cardColor,
              readOnly: true,
              onTap: () {
                showModalBottomSheet(
                    isScrollControlled: true,
                    backgroundColor: Theme.of(context).scaffoldBackgroundColor,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.only(
                            topRight: Radius.circular(24.r),
                            topLeft: Radius.circular(24.r))),
                    context: context,
                    builder: (context) {
                      return Padding(
                        padding: const EdgeInsets.all(8.0),
                        child:
                            Column(mainAxisSize: MainAxisSize.min, children: [
                          10.h.height,
                          Align(
                            alignment: Alignment.center,
                            child: Container(
                              height: 5.h,
                              width: 100.w,
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(20.r),
                                  color: const Color(0xff202223)),
                            ),
                          ),
                          15.h.height,
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                "Select Time",
                                style: w500_15Poppins(
                                    color: Theme.of(context).primaryColorLight),
                              ),
                              GestureDetector(
                                onTap: () {
                                  Navigator.pop(context);
                                },
                                child: Container(
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    color: Theme.of(context).primaryColorLight,
                                  ),
                                  child: Padding(
                                    padding: const EdgeInsets.all(4.0),
                                    child: Icon(
                                      Icons.close,
                                      size: 16,
                                      color: Theme.of(context)
                                          .scaffoldBackgroundColor,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                          5.h.height,
                          const Divider(),
                          10.h.height,
                          Padding(
                            padding: const EdgeInsets.all(10),
                            child: Center(
                              child: Consumer<CreateWebinarProvider>(
                                builder: (context, value, child) => Row(
                                  children: [
                                    60.w.width,
                                    dateTimeDurationBoxWidget(
                                        inCreaseTimeOnTap: createWebinarProvider
                                            .increaseHoursCount,
                                        decreaseTimeOnTap: createWebinarProvider
                                            .decreaseHoursCount,
                                        durationValue:
                                            createWebinarProvider.hoursValue),
                                    Text(
                                      ":",
                                      style:
                                          w600_16Poppins(color: Colors.white),
                                    ),
                                    50.w.width,
                                    dateTimeDurationBoxWidget(
                                        inCreaseTimeOnTap: createWebinarProvider
                                            .increaseMintsCount,
                                        decreaseTimeOnTap: createWebinarProvider
                                            .decreaseMintsCount,
                                        durationValue:
                                            createWebinarProvider.mintsValue)
                                  ],
                                ),
                              ),
                            ),
                          ),
                          Row(
                            children: [
                              CustomButton(
                                buttonText: "Cancel",
                                buttonColor: const Color(0xff1B2632),
                                width: ScreenConfig.width * 0.46,
                                onTap: () {
                                  Navigator.pop(context);
                                },
                              ),
                              10.w.width,
                              CustomButton(
                                width: ScreenConfig.width * 0.46,
                                buttonText: "Apply",
                                onTap: () {
                                  createWebinarProvider.updateTimeView(
                                      widget.timeDateController);
                                  Navigator.pop(context);
                                },
                              ),
                            ],
                          ),
                        ]),
                      );
                    });
              },
              style: w400_14Poppins(color: Theme.of(context).hintColor),
              labelStyle: w400_14Poppins(color: Theme.of(context).hintColor),
              controller: widget.timeDateController,
              hintStyle:
                  w400_14Poppins(color: Theme.of(context).primaryColorLight),
              hintText: "Select",
              errorMaxLines: 2,
              keyboardType: TextInputType.text,
              // validator: (value, fieldName) {
              //   print("the value is the $value");
              //   DateTime format = DateFormat("HH:mm") as DateTime;
              //   DateTime selectedTime = int.parse(value) as DateTime;
              //   DateTime currentTime = DateTime.now();
              //   if (selectedTime.isAfter(currentTime)) {
              //     // return null;
              //   } else {
              //     return 'Time Should not be past';
              //   }
              //   return FormValidations.checkUserSubScriptionEndDate(value, fieldName);
              // },
              suffixIcon: Icon(
                Icons.access_time,
                size: 18.sp,
                color: Theme.of(context).primaryColorLight,
              ),
              inputAction: TextInputAction.next,
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                height10,
                Text(
                  ConstantsStrings.duration,
                  style: w400_13Poppins(color: Theme.of(context).hintColor),
                ),
                height5,
                CommonTextFormField(
                  borderColor: Theme.of(context).primaryColorDark,
                  fillColor: Theme.of(context).cardColor,
                  readOnly: true,
                  labelStyle: w400_14Poppins(
                    color: Theme.of(context).hintColor,
                  ),
                  style: w400_14Poppins(
                    color: Theme.of(context).hintColor,
                  ),
                  onTap: () {
                    showModalBottomSheet(
                        isScrollControlled: true,
                        backgroundColor:
                            Theme.of(navigationKey.currentState!.context)
                                .scaffoldBackgroundColor,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.only(
                                topRight: Radius.circular(24.r),
                                topLeft: Radius.circular(24.r))),
                        context: navigationKey.currentState!.context,
                        builder: (context) {
                          return Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    10.h.height,
                                    Align(
                                      alignment: Alignment.center,
                                      child: Container(
                                        height: 5.h,
                                        width: 100.w,
                                        decoration: BoxDecoration(
                                            borderRadius:
                                                BorderRadius.circular(20.r),
                                            color: Color(0xff202223)),
                                      ),
                                    ),
                                    15.h.height,
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text(
                                          "Duration",
                                          style: w500_15Poppins(
                                              color: Theme.of(navigationKey
                                                      .currentState!.context)
                                                  .primaryColorLight),
                                        ),
                                        GestureDetector(
                                          onTap: () {
                                            Navigator.pop(navigationKey
                                                .currentState!.context);
                                          },
                                          child: Container(
                                            decoration: BoxDecoration(
                                              shape: BoxShape.circle,
                                              color: Theme.of(navigationKey
                                                      .currentState!.context)
                                                  .primaryColorLight,
                                            ),
                                            child: Padding(
                                              padding:
                                                  const EdgeInsets.all(4.0),
                                              child: Icon(
                                                Icons.close,
                                                size: 16,
                                                color: Theme.of(navigationKey
                                                        .currentState!.context)
                                                    .scaffoldBackgroundColor,
                                              ),
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                    5.h.height,
                                    const Divider(),
                                    10.h.height,
                                    Consumer<CreateWebinarProvider>(
                                      builder: (context, value, child) =>
                                          Padding(
                                        padding: EdgeInsets.only(top: 10.h),
                                        child: Row(
                                          children: [
                                            Column(
                                              children: [
                                                Row(
                                                  children: [
                                                    60.w.width,
                                                    arrowsWidget(
                                                      onTap: () {
                                                        createWebinarProvider
                                                            .increaseDurationHoursCount();
                                                      },
                                                      quarterTurns: 3,
                                                    ),
                                                  ],
                                                ),
                                                Row(
                                                  children: [
                                                    20.w.width,
                                                    Text(
                                                      "Hours",
                                                      style: w500_15Poppins(
                                                          color: Theme.of(
                                                                  navigationKey
                                                                      .currentState!
                                                                      .context)
                                                              .primaryColorLight),
                                                    ),
                                                    10.w.width,
                                                    SizedBox(
                                                      height: 60.w,
                                                      width: 60.w,
                                                      child: Center(
                                                          child: Text(
                                                        createWebinarProvider
                                                            .durationHoursValue,
                                                        style: w400_15Poppins(
                                                            color: Theme.of(
                                                                    navigationKey
                                                                        .currentState!
                                                                        .context)
                                                                .hintColor),
                                                      )),
                                                    ),
                                                  ],
                                                ),
                                                Row(
                                                  children: [
                                                    70.w.width,
                                                    arrowsWidget(
                                                        onTap: () {
                                                          createWebinarProvider
                                                              .decreaseDurationHoursCount();
                                                        },
                                                        quarterTurns: 1),
                                                  ],
                                                )
                                              ],
                                            ),
                                            width20,
                                            Text(
                                              ":",
                                              style: w500_16Poppins(
                                                  color: Colors.white),
                                            ),
                                            width20,
                                            Row(
                                              children: [
                                                Column(
                                                  children: [
                                                    arrowsWidget(
                                                        onTap: () {
                                                          createWebinarProvider
                                                              .inCreaseAndDecreaseMinutesValue();
                                                        },
                                                        quarterTurns: 3),
                                                    Consumer<
                                                            CreateWebinarProvider>(
                                                        builder: (_,
                                                            createWebinarProvider,
                                                            __) {
                                                      return SizedBox(
                                                        height: 60.h,
                                                        width: 80.w,
                                                        child: Center(
                                                            child: Text(
                                                          createWebinarProvider
                                                              .durationMintsValue,
                                                          style: w400_15Poppins(
                                                              color: Theme.of(
                                                                      navigationKey
                                                                          .currentState!
                                                                          .context)
                                                                  .hintColor),
                                                        )),
                                                      );
                                                    }),
                                                    Row(
                                                      children: [
                                                        arrowsWidget(
                                                          onTap: () {
                                                            createWebinarProvider
                                                                .inCreaseAndDecreaseMinutesValue(
                                                                    isDecreaseTime:
                                                                        true);
                                                          },
                                                          quarterTurns: 1,
                                                        ),
                                                      ],
                                                    )
                                                  ],
                                                ),
                                                10.w.width,
                                                Text(
                                                  "Mins",
                                                  style: w500_16Poppins(
                                                      color: Theme.of(
                                                              navigationKey
                                                                  .currentState!
                                                                  .context)
                                                          .primaryColorLight),
                                                )
                                              ],
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                    Row(
                                      children: [
                                        CustomButton(
                                          buttonText: "Cancel",
                                          buttonColor: const Color(0xff1B2632),
                                          width: ScreenConfig.width * 0.46,
                                          onTap: () {
                                            Navigator.pop(navigationKey
                                                .currentState!.context);
                                          },
                                        ),
                                        10.w.width,
                                        CustomButton(
                                          width: ScreenConfig.width * 0.46,
                                          buttonText: "Apply",
                                          onTap: () {
                                            createWebinarProvider
                                                .updateTimeValue(
                                                    widget.controller);
                                            _toggleContainer();
                                            Navigator.pop(navigationKey
                                                .currentState!.context);
                                          },
                                        ),
                                      ],
                                    ),
                                  ]));
                        });
                  },
                  controller: widget.controller,
                  keyboardType: TextInputType.text,
                  suffixIcon: Icon(
                    Icons.access_time,
                    size: 18.sp,
                    color: Theme.of(context).primaryColorLight,
                  ),
                  inputAction: TextInputAction.next,
                ),
                height10,
                EventRemainderCard(),
                height10,
                Text(
                  ConstantsStrings.timeZone,
                  style: w400_13Poppins(color: Theme.of(context).hintColor),
                ),
                height5,
                Container(
                    decoration: BoxDecoration(
                        color: Theme.of(context).cardColor,
                        borderRadius: BorderRadius.circular(5.sp),
                        border: Border.all(
                            color: Theme.of(context).primaryColorDark,
                            width: 0.2)),
                    padding: EdgeInsets.symmetric(vertical: 5.h),
                    child: DropDownHelper(
                      borderRadius: 5.r,
                      dropDownPadding:
                          const EdgeInsets.only(top: 100, bottom: 100),
                      selectedValue: createWebinarProvider.selectedTimeZone,
                      hintText: "Select Timezone",
                      dropDownItems: timeZonedDopdownTimeItems,
                      buttonColor: Theme.of(context).cardColor,
                      onChanged: (value) {
                        createWebinarProvider.updateTimeZone(value!);
                      },
                    )),
                height10,
                Text(
                  ConstantsStrings.exitUrl,
                  style: w400_13Poppins(color: Theme.of(context).hintColor),
                ),
                height5,
                CommonTextFormField(
                  fillColor: Theme.of(context).cardColor,
                  borderColor: Theme.of(context).primaryColorDark,
                  controller: exitUrlController,
                  validator: (val, String? fieldName) {
                    // return FormValidations.urlValidation(val.toString(), isRequiredFeild: false);
                    return FormValidations.urlValidation(val);
                  },
                  onChanged: (value) {
                    createWebinarProvider.toggleSetAsDefault = value.isValidUrl;
                  },
                  hintText: ConstantsStrings.enterExitUrl,
                  hintStyle: w400_13Poppins(
                      color: Theme.of(context).primaryColorLight),
                ),

                // siva told need to comment right now
                /*  SetAsDefault(
                    showSetAsDefault: createWebinarProvider.showSetAsDefault,
                    status: createWebinarProvider.setAsDefaultStatus,
                    showMessage: widget.isEdit!?"ReSet as Default":"Set as Default",
                    onChanged: (bool? status) async {
                      bool feildStatus = status ?? false;
                      await createWebinarProvider.toggleSetAsDefaultStatus(
                        status: feildStatus,
                        callApi: true,
                        url: feildStatus ? exitUrlController.text : "",
                      );
                    })*/
              ],
            )
          ],
        ),
      ),
    );
  }

  Widget dateTimeDurationBoxWidget(
      {required VoidCallback inCreaseTimeOnTap,
      required VoidCallback decreaseTimeOnTap,
      required String durationValue}) {
    return Expanded(
      child: Container(
        height: 85.h,
        padding: EdgeInsets.only(left: 10.w, right: 10.w),
        margin: EdgeInsets.symmetric(horizontal: 5.w),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              children: [
                GestureDetector(
                  onTap: inCreaseTimeOnTap,
                  child: RotatedBox(
                      quarterTurns: 3,
                      child: Icon(
                        Icons.arrow_forward_ios_outlined,
                        size: 18.sp,
                        color: Theme.of(context).primaryColorLight,
                      )),
                ),
                10.h.height,
                Center(
                  child: Text(
                    durationValue,
                    style: w400_16Poppins(color: Theme.of(context).hintColor),
                  ),
                ),
                10.h.height,
                GestureDetector(
                  onTap: decreaseTimeOnTap,
                  child: RotatedBox(
                      quarterTurns: 1,
                      child: Icon(
                        Icons.arrow_forward_ios_outlined,
                        size: 18.sp,
                        color: Theme.of(context).primaryColorLight,
                      )),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }

  Widget arrowsWidget(
      {required VoidCallback onTap, required int quarterTurns}) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 40.w,
        height: 25.w,
        margin: EdgeInsets.symmetric(vertical: 10.h),
        child: RotatedBox(
            quarterTurns: quarterTurns,
            child: Icon(Icons.arrow_forward_ios_outlined,
                size: 18.sp, color: Theme.of(context).primaryColorLight)),
      ),
    );
  }
}
