import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';
import 'package:o_connect/core/screen_configs.dart';
import 'package:o_connect/ui/utils/buttons_helper/custom_botton.dart';
import 'package:o_connect/ui/utils/colors/colors.dart';
import 'package:o_connect/ui/utils/constant_strings.dart';
import 'package:o_connect/ui/utils/textfield_helper/app_fonts.dart';
import 'package:o_connect/ui/utils/textfield_helper/common_textfield.dart';
import 'package:o_connect/ui/utils/textfield_helper/textFieldTexts.dart';
import 'package:o_connect/ui/views/authentication/form_validations.dart';
import 'package:o_connect/ui/views/call_to_action/providers/dashboard_call_to_action_provider.dart';
import 'package:o_connect/ui/views/call_to_action/widgets/color_picker.dart';
import 'package:o_connect/ui/views/themes/providers/webinar_themes_provider.dart';
import 'package:o_connect/ui/views/webinar_details/webinar_details_provider/webinar_provider.dart';
import 'package:provider/provider.dart';
import '../../utils/buttons_helper/custom_outline_button.dart';

class CallToActionPopUp extends StatefulWidget {
  const CallToActionPopUp({
    Key? key,
  }) : super(key: key);

  @override
  State<CallToActionPopUp> createState() => _CallToActionPopUpState();
}

class _CallToActionPopUpState extends State<CallToActionPopUp> {
  final _formKey = GlobalKey<FormState>();

  // CurrentView? _currentView;
  DateTime? _time;
  TextEditingController titleController = TextEditingController();

  TextEditingController displayTimeController = TextEditingController();

  TextEditingController buttonUrlController = TextEditingController();

  TextEditingController buttonTextController = TextEditingController();

  TextEditingController textYourMsg = TextEditingController();
  late DashBoardCallToActionProvider dashBoardCallToActionProvider;

  @override
  void initState() {
    dashBoardCallToActionProvider = Provider.of<DashBoardCallToActionProvider>(context, listen: false);
    dashBoardCallToActionProvider.clearData();
    // Future.delayed(
    //   Duration.zero,
    //   () {
    //     dashBoardCallToActionProvider.clearData(fromInitState: true);
    //     displayTimeController.text = dashBoardCallToActionProvider.setTime.toString();
    //     DefaultUserDataModel? defaultUserDataModel = context.read<DefaultUserDataProvider>().defaultUserDataModel;
    //     if (defaultUserDataModel != null && defaultUserDataModel.data?.cta != null) {
    //       if (defaultUserDataModel.data!.cta!.title.isNotEmpty) {
    //         titleController.text = defaultUserDataModel.data!.cta!.title;
    //       }
    //       if (defaultUserDataModel.data!.cta!.buttonTxt.isNotEmpty) {
    //         buttonTextController.text = defaultUserDataModel.data!.cta!.buttonTxt;
    //       }
    //       if (defaultUserDataModel.data!.cta!.buttonUrl.isNotEmpty) {
    //         buttonUrlController.text = defaultUserDataModel.data!.cta!.buttonUrl;
    //       }
    //       if (defaultUserDataModel.data!.cta!.title.isNotEmpty && defaultUserDataModel.data!.cta!.buttonTxt.isNotEmpty && defaultUserDataModel.data!.cta!.buttonUrl.isNotEmpty) {
    //         dashBoardCallToActionProvider.changeSetAsDefaultStatus(status: false);
    //         dashBoardCallToActionProvider.toggleShowSetAsDefault = false;
    //         setState(() {});
    //       }
    //       if (defaultUserDataModel.data?.cta!.btnBgClr != null) {
    //         dashBoardCallToActionProvider.updateButtonUrlBGColor = defaultUserDataModel.data!.cta!.btnBgClr.toColor();
    //       }
    //       if (defaultUserDataModel.data?.cta!.btnClr != null) {
    //         dashBoardCallToActionProvider.updateButtonUrlTextColor = defaultUserDataModel.data!.cta!.btnClr.toColor();
    //       }
    //       if (defaultUserDataModel.data?.cta!.titleClr != null) {
    //         dashBoardCallToActionProvider.updateTitleTextColor = defaultUserDataModel.data!.cta!.titleClr.toColor();
    //       }
    //       if (defaultUserDataModel.data?.cta!.titleBgClr != null) {
    //         dashBoardCallToActionProvider.updateTitleTextBgColor = defaultUserDataModel.data!.cta!.titleBgClr.toColor();
    //       }
    //       // print(defaultUserDataModel.data.toJson());
    //       // dashBoardCallToActionProvider.updateDefaultColors(
    //       //   btnBgClr: defaultUserDataModel.data.cta.btnBgClr,
    //       //   btnClr: defaultUserDataModel.data.cta.btnClr,
    //       //   titleBgClr: defaultUserDataModel.data.cta.titleBgClr,
    //       //   titleClr: defaultUserDataModel.data.cta.titleClr,
    //       // );
    //       print(dashBoardCallToActionProvider);
    //       setState(() {});
    //     }
    //   },
    // );

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: true,
      onPopInvoked: (value) async {
        // dashBoardCallToActionProvider.clearData();
      },
      child: Consumer2<WebinarProvider, WebinarThemesProviders>(builder: (context, data, webinarThemesProviders, child) {
        return Container(
            height: MediaQuery.of(context).size.height * 0.69,
            decoration: BoxDecoration(
                color: webinarThemesProviders.colors.headerColor,
                border: Border.all(color: webinarThemesProviders.colors.headerColor, width: 4.w),
                borderRadius: BorderRadius.only(topRight: Radius.circular(25.r), topLeft: Radius.circular(25.r))),
            child: Form(
              key: _formKey,
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    height20,
                    Align(
                      alignment: Alignment.center,
                      child: Container(
                        height: 5.h,
                        width: 100.w,
                        decoration: BoxDecoration(
                            border: Border.all(color: webinarThemesProviders.colors.headerColor, width: 4.w), borderRadius: BorderRadius.circular(20.r), color: Theme.of(context).highlightColor),
                      ),
                    ),
                    height10,
                    Padding(
                      padding: EdgeInsets.only(left: 16.w),
                      child: Text(
                        "Call To Action",
                        style: w500_16Poppins(color: Theme.of(context).hoverColor),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 16.w),
                      child: Divider(
                        color: Theme.of(context).highlightColor,
                      ),
                    ),
                    Container(
                      height: ScreenConfig.height * 0.59,
                      color: webinarThemesProviders.colors.bodyColor,
                      child: Column(
                        children: [
                          Expanded(
                            child: Padding(
                              padding: EdgeInsets.only(left: 20.w, right: 20.w, top: 10.h),
                              child: ListView(
                                children: [
                                  Text(
                                    "Preview",
                                    style: w400_12Poppins(color: Colors.white),
                                  ),
                                  Row(
                                    children: [
                                      Consumer<DashBoardCallToActionProvider>(builder: (context, data, child) {
                                        return SizedBox(
                                          height: 40.h,
                                          width: MediaQuery.of(context).size.width * 0.6,
                                          child: CommonTextFormField(
                                            fillColor: data.titleTextBGColor,
                                            controller: titleController,
                                            readOnly: true,
                                            hintText: "Type your Message",
                                            style: TextStyle(fontSize: 12.sp, color: data.titleTextColor),
                                            keyboardType: TextInputType.text,
                                            // validator: (val, String? f) {
                                            //   return FormValidations.requiredFieldValidation(val, "Text");
                                            // },
                                            hintStyle: w400_12Poppins(color: data.titleTextColor),
                                            enableBorder: false,
                                          ),
                                        );
                                      }),
                                      const Spacer(),
                                      Consumer<DashBoardCallToActionProvider>(builder: (context, data, child) {
                                        return SizedBox(
                                          height: 40.h,
                                          width: ScreenConfig.width * 0.25,
                                          child: CommonTextFormField(
                                            style: w400_12Poppins(color: data.buttonUrlTextColor),
                                            readOnly: true,
                                            fillColor: data.buttonUrlBGColor,
                                            controller: buttonTextController,
                                            hintText: "Text",
                                            keyboardType: TextInputType.text,
                                            hintStyle: w400_12Poppins(color: Provider.of<WebinarThemesProviders>(context).themeBackGroundColor != null ? Colors.white : data.buttonUrlTextColor),
                                            enableBorder: false,
                                          ),
                                        );
                                      }),
                                    ],
                                  ),
                                  height10,
                                  Row(
                                    crossAxisAlignment: CrossAxisAlignment.end,
                                    children: [
                                      Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          const TextFieldTexts(
                                            name: ConstantsStrings.title,
                                            textColor: Colors.white,
                                          ),
                                          SizedBox(
                                            width: ScreenConfig.width * 0.62,
                                            height: 35.h,
                                            child: CommonTextFormField(
                                              validator: (val, String? f) {
                                                return FormValidations.requiredFieldValidation(val, "Text");
                                              },
                                              fillColor: webinarThemesProviders.colors.itemColor,
                                              controller: titleController,
                                              hintText: "Type your text",
                                              style: TextStyle(fontSize: 14.sp, color: Theme.of(context).hintColor),
                                              keyboardType: TextInputType.text,
                                              enableBorder: false,
                                              onChanged: (value) {
                                                dashBoardCallToActionProvider.toggleSetAsDefault(
                                                  titleController.text.isNotEmpty && buttonTextController.text.isNotEmpty && buttonUrlController.text.isNotEmpty,
                                                );

                                                setState(() {});
                                              },
                                            ),
                                          ),
                                        ],
                                      ),
                                      width10,
                                      Consumer<DashBoardCallToActionProvider>(builder: (context, data, child) {
                                        return ColorPickerWidget(
                                            title: ConstantsStrings.titleColors,
                                            backGroundOnTap: () {
                                              data.updatedColorForCallToActions(context: context, updateColor: data.currentBackGroundTitleColor, pickedColor: data.titleTextBGColor, index: 1);
                                            },
                                            textOnTap: () {
                                              data.updatedColorForCallToActions(context: context, updateColor: data.currentTextTitleColor, pickedColor: data.titleTextColor, index: 2);
                                            },
                                            backGroundColor: data.titleTextBGColor,
                                            textColor: data.titleTextColor);
                                      }),
                                    ],
                                  ),
                                  height20,
                                  const TextFieldTexts(
                                    name: ConstantsStrings.buttonUrl,
                                    textColor: Colors.white,
                                  ),
                                  height5,
                                  SizedBox(
                                    height: 40.h,
                                    child: CommonTextFormField(

                                      style: w400_14Poppins(color: Theme.of(context).hintColor),
                                      validator: (val, String? f) {
                                        return FormValidations.urlValidation(val);
                                      },
                                   hintStyle: w400_14Poppins(color: Theme.of(context).hintColor),
                                      fillColor: webinarThemesProviders.colors.itemColor,
                                      hintText: "Enter button url",
                                      controller: buttonUrlController,
                                      keyboardType: TextInputType.text,
                                      inputAction: TextInputAction.next,
                                      enableBorder: false,
                                      onChanged: (value) {
                                        dashBoardCallToActionProvider
                                            .toggleSetAsDefault(titleController.text.isNotEmpty && buttonTextController.text.isNotEmpty && buttonUrlController.text.isNotEmpty);
                                        setState(() {});
                                      },
                                    ),
                                  ),
                                  height10,
                                  Row(
                                    crossAxisAlignment: CrossAxisAlignment.end,
                                    children: [
                                      Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          const TextFieldTexts(
                                            name: ConstantsStrings.buttontext,
                                            textColor: Colors.white,
                                          ),
                                          SizedBox(
                                            height: 35.h,
                                            width: ScreenConfig.width * 0.6,
                                            child: CommonTextFormField(
                                              style: w400_12Poppins(color: Theme.of(context).hintColor),
                                              hintText: "Type button text",
                                              fillColor: webinarThemesProviders.colors.itemColor,
                                              controller: buttonTextController,
                                              keyboardType: TextInputType.text,
                                              inputAction: TextInputAction.next,
                                              enableBorder: true,
                                              onChanged: (value) {
                                                dashBoardCallToActionProvider.toggleSetAsDefault(
                                                  titleController.text.isNotEmpty && buttonTextController.text.isNotEmpty && buttonUrlController.text.isNotEmpty,
                                                );
                                                setState(() {});
                                              },
                                            ),
                                          ),
                                        ],
                                      ),
                                      width10,
                                      Consumer<DashBoardCallToActionProvider>(builder: (context, data, child) {
                                        return ColorPickerWidget(
                                          title: ConstantsStrings.buttonColors,
                                          backGroundOnTap: () {
                                            data.updatedColorForCallToActions(context: context, updateColor: data.currentBackGroundButtonColor, pickedColor: data.buttonUrlBGColor, index: 3);
                                          },
                                          textOnTap: () {
                                            data.updatedColorForCallToActions(context: context, updateColor: data.currentTextButtonColor, pickedColor: data.buttonUrlTextColor, index: 4);
                                          },
                                          backGroundColor: data.buttonUrlBGColor,
                                          textColor: data.buttonUrlTextColor,
                                        );
                                      })
                                    ],
                                  ),
                                  // height20,
                                  // Text("Choose custom timer below: ",
                                  //     textAlign: TextAlign.center,
                                  //     style: w400_14Poppins(
                                  //       color: Theme.of(context).hintColor,
                                  //     )),
                                  height10,
                                  Consumer2<DashBoardCallToActionProvider, WebinarThemesProviders>(builder: (context, data, webinarThemesProviders, child) {
                                    return Column(
                                      children: [
                                        // Row(
                                        //   mainAxisAlignment: MainAxisAlignment.center,
                                        //   children: [
                                        //     TimerToggleButtons(
                                        //       addTime: AddTime.two,
                                        //       isSelected: data.selectedTime == AddTime.two,
                                        //       buttonName: '2 mins',
                                        //       onPressed: data.updateTotalTime,
                                        //     ),
                                        //     TimerToggleButtons(
                                        //       addTime: AddTime.five,
                                        //       isSelected: data.selectedTime == AddTime.five,
                                        //       buttonName: '5 mins',
                                        //       onPressed: data.updateTotalTime,
                                        //     ),
                                        //     TimerToggleButtons(
                                        //       addTime: AddTime.ten,
                                        //       isSelected: data.selectedTime == AddTime.ten,
                                        //       buttonName: '10 mins',
                                        //       onPressed: data.updateTotalTime,
                                        //     ),
                                        //     TimerToggleButtons(
                                        //       addTime: AddTime.fifteen,
                                        //       isSelected: data.selectedTime == AddTime.fifteen,
                                        //       buttonName: '15 mins',
                                        //       onPressed: data.updateTotalTime,
                                        //     ),
                                        //   ],
                                        // ),
                                        Column(
                                          children: [
                                            const TextFieldTexts(
                                              name: "Display time",
                                              textColor: Colors.white,
                                            ),
                                            Container(
                                              width: ScreenConfig.width,
                                              height: 45.h,
                                              padding: EdgeInsets.only(left: 10.w),
                                              decoration: BoxDecoration(border: Border.all(color: Colors.grey, width: 1)),
                                              child: Row(
                                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                children: [
                                                  Text(
                                                    data.formatTotalTimeInSeconds == null ? "02:00" : data.formatTotalTimeInSeconds!,
                                                    style: w400_14Poppins(color: Theme.of(context).hintColor),
                                                  ),
                                                  Column(
                                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                    children: [
                                                      RotatedBox(
                                                        quarterTurns: 1,
                                                        child: InkWell(
                                                          onTap: () {
                                                            data.increaseDecreaseTime(type: "increase");
                                                          },
                                                          child: Container(
                                                            height: 30.w,
                                                            width: 20.w,
                                                            decoration: const BoxDecoration(
                                                                color: Color(0xff292B2C), borderRadius: BorderRadius.only(topLeft: Radius.circular(5), topRight: Radius.circular(5))),
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
                                                            data.increaseDecreaseTime(type: "decrease");
                                                          },
                                                          child: Container(
                                                            height: 30.w,
                                                            width: 20.w,
                                                            decoration: const BoxDecoration(
                                                                color: Color(0xff292B2C), borderRadius: BorderRadius.only(bottomLeft: Radius.circular(5), bottomRight: Radius.circular(5))),
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
                                            ),
                                          ],
                                        ),
                                      ],
                                    );
                                  }),
                                  height15,
                                ],
                              ),
                            ),
                          ),
                          // SetAsDefault(
                          //   onChanged: (value) {
                          //     dashBoardCallToActionProvider.changeSetAsDefaultStatus(
                          //       status: value ?? false,
                          //       buttonTxt: buttonTextController.text.trim(),
                          //       buttonUrl: buttonUrlController.text.trim(),
                          //       title: titleController.text.trim(),
                          //       callApi: true,
                          //     );
                          //     setState(() {});
                          //   },
                          //   showSetAsDefault: dashBoardCallToActionProvider.showSetAsDefault,
                          //   status: dashBoardCallToActionProvider.setAsDefaultStatus,
                          // ),
                          Consumer<DashBoardCallToActionProvider>(
                            builder: (context, data, child) {
                              return !data.callToActionLoading
                                  ? Padding(
                                      padding: EdgeInsets.only(right: 8.w, top: 10.h, bottom: 10.h),
                                      child: Row(
                                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                                        children: [
                                          // CustomOutlinedButton(
                                          //   outLineBorderColor: Provider.of<WebinarThemesProviders>(context).colors.textColor,
                                          //   height: 35.h,
                                          //   buttonTextStyle: w400_13Poppins(color: Provider.of<WebinarThemesProviders>(context).colors.textColor),
                                          //   buttonText: ConstantsStrings.clear,
                                          //   onTap: () {
                                          //     titleController.clear();
                                          //     buttonTextController.clear();
                                          //     buttonUrlController.clear();
                                          //     dashBoardCallToActionProvider.clearData(callUserDefaultApi: true);
                                          //     dashBoardCallToActionProvider.changeSetAsDefaultStatus(status: false);
                                          //     dashBoardCallToActionProvider.toggleShowSetAsDefault = false;
                                          //     setState(() {});
                                          //   },
                                          // ),

                                          CustomOutlinedButton(
                                            outLineBorderColor: Provider.of<WebinarThemesProviders>(context).colors.textColor,
                                            height: 35.h,
                                            width: 150.w,
                                            buttonTextStyle: w400_13Poppins(color: Colors.white /* Provider.of<WebinarThemesProviders>(context).colors.textColor */),
                                            color: Provider.of<WebinarThemesProviders>(context).colors.cardColor,
                                            buttonText: ConstantsStrings.cancel,
                                            onTap: () {
                                              dashBoardCallToActionProvider.clearData();
                                              Navigator.pop(context);
                                            },
                                          ),

                                          CustomButton(
                                              buttonColor: Provider.of<WebinarThemesProviders>(context).colors.buttonColor,
                                              width: 150.w,
                                              height: 35.h,
                                              buttonText: "Publish",
                                              buttonTextStyle: w500_13Poppins(color: Colors.white),
                                              onTap: () {
                                                if (_formKey.currentState!.validate()) {
                                                  String finalUrl = buttonUrlController.text.startsWith("https://") || buttonUrlController.text.startsWith("http://")
                                                      ? buttonUrlController.text
                                                      : "https://${buttonUrlController.text}";
                                                  dashBoardCallToActionProvider.updateValues(title: titleController.text.trim(), url: finalUrl, buttonTextValue: buttonTextController.text.trim());
                                                  dashBoardCallToActionProvider.createCallToAction();
                                                  Navigator.of(context).pop();
                                                  /* data.showCallToActionPopUpAtDashBoard();
                                Navigator.pop(context);*/
                                                }
                                              })
                                        ],
                                      ),
                                    )
                                  : Center(
                                      child: SizedBox(
                                        width: 20.w,
                                        height: 20.w,
                                        child: const CircularProgressIndicator(
                                          color: Colors.white,
                                        ),
                                      ),
                                    );
                            },
                          ),
                        ],
                      ),
                    )
                  ],
                ),
              ),
            ));
      }),
    );
  }
}

class TimeSelector extends StatefulWidget {
  const TimeSelector({
    super.key,
    required this.onChanged,
    this.initialTime,
    required this.isInfinite,
    required this.minuteGap,
    this.customMinutes,
  });

  final void Function(DateTime time) onChanged;

  final DateTime? initialTime;

  final bool isInfinite;

  final int minuteGap;

  final List<String>? customMinutes;

  @override
  State<StatefulWidget> createState() => _TimeSelectorState();
}

class _TimeSelectorState extends State<TimeSelector> {
  int selectedHour = 0;

  int selectedMinute = 0;

  int selectedTimeMode = 0;

  late final List<String> hours;

  late final List<String> minutes;

  late final List<String> timeModes;

  @override
  void initState() {
    super.initState();

    hours = List.generate(12, (index) => '${index + 1}'.padLeft(2, '0'));

    minutes = widget.customMinutes != null ? widget.customMinutes! : List.generate(60 ~/ widget.minuteGap, (index) => '${index * widget.minuteGap}'.padLeft(2, '0'));

    timeModes = ['AM', 'PM'];

    if (widget.initialTime != null) {
      final parts = DateFormat("hh mm aa").format(widget.initialTime!).split(" ");

      selectedHour = hours.indexOf(parts.first);

      selectedMinute = minutes.indexOf(parts[1]);

      selectedTimeMode = timeModes.indexOf(parts.last);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          SizedBox(
            height: 250,
            child: Row(
              children: [
                Expanded(
                  child: _Wheel(
                    isInfinite: widget.isInfinite,
                    initialItemIndex: selectedHour,
                    onChanged: (index) {
                      setState(() {
                        selectedHour = index;
                        _passSelection();
                      });
                    },
                    children: hours
                        .map(
                          (e) => Container(
                            width: double.infinity,
                            decoration: BoxDecoration(
                              color: hours[selectedHour] == e ? Colors.blue.shade50 : Colors.transparent,
                              borderRadius: BorderRadius.circular(12.0),
                            ),
                            padding: const EdgeInsets.all(8),
                            child: Center(child: Text(e)),
                          ),
                        )
                        .toList(),
                  ),
                ),
                Expanded(
                  child: _Wheel(
                    isInfinite: widget.isInfinite,
                    initialItemIndex: selectedMinute,
                    onChanged: (index) {
                      setState(() {
                        selectedMinute = index;

                        _passSelection();
                      });
                    },
                    children: minutes
                        .map(
                          (e) => Container(
                            width: double.infinity,
                            decoration: BoxDecoration(
                              color: minutes[selectedMinute] == e ? Colors.blue.shade50 : Colors.transparent,
                              borderRadius: BorderRadius.circular(12.0),
                            ),
                            padding: const EdgeInsets.all(8),
                            child: Center(child: Text(e)),
                          ),
                        )
                        .toList(),
                  ),
                ),
                Expanded(
                  child: _Wheel(
                    isInfinite: false,
                    initialItemIndex: selectedTimeMode,
                    onChanged: (index) {
                      setState(() {
                        selectedTimeMode = index;
                        _passSelection();
                      });
                    },
                    children: timeModes
                        .map(
                          (e) => Container(
                            width: double.infinity,
                            decoration: BoxDecoration(
                              color: timeModes[selectedTimeMode] == e ? Colors.blue.shade50 : Colors.transparent,
                              borderRadius: BorderRadius.circular(12.0),
                            ),
                            padding: const EdgeInsets.all(8),
                            child: Center(child: Text(e)),
                          ),
                        )
                        .toList(),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  void _passSelection() {
    final time = DateFormat("hh:mm a").parse('${hours[selectedHour]}:${minutes[selectedMinute]} ${timeModes[selectedTimeMode]}');

    widget.onChanged(time);
  }
}

class _Wheel extends StatelessWidget {
  const _Wheel({
    required this.onChanged,
    required this.children,
    required this.initialItemIndex,
    required this.isInfinite,
  });

  final void Function(int index) onChanged;

  final List<Widget> children;

  final int initialItemIndex;

  final bool isInfinite;

  @override
  Widget build(BuildContext context) {
    return ListWheelScrollView.useDelegate(
      itemExtent: 50,
      perspective: 0.00001,
      onSelectedItemChanged: onChanged,
      magnification: 1.1,
      useMagnifier: true,
      physics: const FixedExtentScrollPhysics(),
      controller: FixedExtentScrollController(initialItem: initialItemIndex),
      childDelegate: isInfinite && children.length > 10 ? ListWheelChildLoopingListDelegate(children: children) : ListWheelChildListDelegate(children: children),
    );
  }
}
