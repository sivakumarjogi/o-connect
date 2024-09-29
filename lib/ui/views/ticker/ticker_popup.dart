import 'package:flutter/material.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:o_connect/core/providers/common_provider.dart';
import 'package:o_connect/ui/views/authentication/form_validations.dart';
import 'package:o_connect/ui/views/ticker/provider/ticker_provider.dart';
import 'package:o_connect/ui/utils/buttons_helper/custom_botton.dart';
import 'package:o_connect/ui/utils/close_widget.dart';
import 'package:o_connect/ui/utils/colors/colors.dart';
import 'package:o_connect/ui/utils/constant_strings.dart';
import 'package:o_connect/ui/utils/textfield_helper/common_textfield.dart';
import 'package:o_connect/ui/views/themes/providers/webinar_themes_provider.dart';
import 'package:provider/provider.dart';
import '../../../core/models/default_user_data_model.dart';
import '../../../core/providers/default_user_data_provider.dart';
import '../../utils/custom_show_dialog_helper/custom_show_dialog.dart';
import '../../utils/textfield_helper/app_fonts.dart';

class TickerPopup extends StatefulWidget {
  const TickerPopup({super.key});

  @override
  State<TickerPopup> createState() => _TickerPopupState();
}

class _TickerPopupState extends State<TickerPopup> {
  MeetingTickerProvider? tickerProvider;
  DefaultUserDataModel? defaultUserDataModel;
  TextEditingController textController = TextEditingController();

  @override
  void initState() {
    super.initState();
    tickerProvider = Provider.of<MeetingTickerProvider>(context, listen: false);
    Future.delayed(
      Duration.zero,
      () {
        context.read<MeetingTickerProvider>().resetData();
      },
    );

    print("connect 2222   ${defaultUserDataModel?.data!.ticker!.ticker}");

    defaultUserDataModel =
        context.read<DefaultUserDataProvider>().defaultUserDataModel;
    print("connect   ${defaultUserDataModel?.data!.ticker!.ticker}");

    if (defaultUserDataModel?.data!.ticker!.ticker != null ||
        defaultUserDataModel?.data!.ticker!.ticker != "") {
      // tickerProvider?.updateTicketValue(context,textController);
      tickerProvider?.isSetAsDefault = true;
      print("connect 111  ${defaultUserDataModel?.data!.ticker!.ticker}");
      print("connect 111  ${tickerProvider?.isSetAsDefault}");

      textController.text =
          defaultUserDataModel?.data!.ticker!.ticker.toString() ?? "";

      setState(() {});
    }
    // tickerProvider?.updateTicketValue(context,textController);

    // textController.text = context.read<MeetingTickerProvider>().tickerData.text ?? '';
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var commonProvider = Provider.of<CommonProvider>(context, listen: false);
    return Consumer2<WebinarThemesProviders, MeetingTickerProvider>(
        builder: (context, webinarThemesProvider, tickerProvider, child) {
      final tickerTextStyle = tickerProvider.tickerTextStyle;

      return Container(
        decoration: BoxDecoration(
            border: Border.all(
                color: webinarThemesProvider.colors.headerColor, width: 4.w),
            color: webinarThemesProvider.colors.bodyColor ??
                Theme.of(context).scaffoldBackgroundColor,
            borderRadius: BorderRadius.only(
                topLeft: Radius.circular(25.r),
                topRight: Radius.circular(25.r))),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            showDialogCustomHeader(context,
                headerTitle: ConstantsStrings.ticker),
            Form(
              key: tickerProvider.tickerFormKey,
              child: Padding(
                padding: EdgeInsets.all(8.0.sp),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      ConstantsStrings.title,
                      style: w400_14Poppins(color: Colors.white),
                    ),
                    height10,
                    CommonTextFormField(
                      controller: textController,
                      fillColor: webinarThemesProvider.unSelectButtonsColor,
                      borderColor: webinarThemesProvider.unSelectButtonsColor,
                      // prefixIcon: const Icon(Icons.title),
                      hintText: "Ticker",
                      validator: FormValidations.requiredFieldValidation,
                      onChanged: (v) {
                        tickerProvider.isSetAsDefault = false;

                        context
                            .read<MeetingTickerProvider>()
                            .onTickerTextChanged(v);
                      },
                      style: tickerProvider.tickerTextStyle,
                    ),
                    height10,
                    Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.all(Radius.circular(5.r)),
                        color: Colors.black,
                      ),
                      padding:
                          EdgeInsets.symmetric(horizontal: 10.w, vertical: 2.h),
                      child: Row(
                        children: [
                          DecoratedBox(
                            decoration: BoxDecoration(
                              border: Border.all(color: Colors.white24),
                              borderRadius: BorderRadius.circular(8.r),
                            ),
                            child: SizedBox(
                              height: 40.sp,
                              child: DropdownButtonHideUnderline(
                                child: DropdownButton(
                                  dropdownColor: webinarThemesProvider
                                      .unSelectButtonsColor,
                                  alignment: Alignment.topRight,
                                  borderRadius: BorderRadius.circular(10.0.r),
                                  padding: EdgeInsets.symmetric(
                                    horizontal: 5.0.h,
                                  ),
                                  value:
                                      tickerProvider.tickerTextStyle.fontFamily,
                                  items: tickerProvider.supportedFontFamilies
                                      .map((e) => DropdownMenuItem(
                                          value: e, child: Text(e)))
                                      .toList(),
                                  onChanged: (value) {
                                    tickerProvider.setFontFamily(value);
                                  },
                                ),
                              ),
                            ),
                          ),
                          IconButton(
                            onPressed: () => tickerProvider.toggleBoldStatus(),
                            icon: Icon(Icons.format_bold,
                                color: tickerTextStyle.isBold
                                    ? AppColors.mainBlueColor
                                    : Colors.white),
                          ),
                          IconButton(
                            onPressed: () =>
                                tickerProvider.toggleItalicStatus(),
                            icon: Icon(Icons.format_italic,
                                color: tickerTextStyle.isItalic
                                    ? AppColors.mainBlueColor
                                    : Colors.white),
                          ),
                          IconButton(
                            onPressed: () =>
                                tickerProvider.toggleDecorationStatus(
                                    TextDecoration.underline),
                            icon: Icon(Icons.format_underlined,
                                color: tickerTextStyle.isUnderline
                                    ? AppColors.mainBlueColor
                                    : Colors.white),
                          ),
                          IconButton(
                            onPressed: () {
                              showDialog(
                                context: context,
                                builder: (context) {
                                  return AlertDialog(
                                    scrollable: true,
                                    elevation: 0,
                                    titlePadding: const EdgeInsets.all(0.0),
                                    contentPadding: const EdgeInsets.all(0.0),
                                    content: Column(
                                      children: [
                                        _ColorPicker(
                                          initialColor: tickerProvider
                                              .tickerTextStyle.color!,
                                          onColorChanged: (Color color) {
                                            tickerProvider
                                                .setTickerColor(color);
                                          },
                                        ),
                                      ],
                                    ),
                                  );
                                },
                              );
                            },
                            icon: Container(
                              height: 20,
                              width: 20,
                              decoration: BoxDecoration(
                                color: tickerProvider.tickerTextStyle.color,
                                border: Border.all(color: Colors.white),
                                borderRadius: BorderRadius.circular(2),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    height5,
                    SetSpeedWidget(
                        controller: textController,
                        defaultUserDataModel:
                            tickerProvider.defaultUserDataModel),
                  ],
                ),
              ),
            ),
            height10,
            // CloseWidget(
            //   textColor: webinarThemesProvider.colors.textColor,
            //   onTap: () {
            //     Navigator.pop(context);
            //     commonProvider.removeTicker();
            //     tickerProvider.resetState();
            //   },
            // )
          ],
        ),
      );
    });
  }
}

class SetSpeedWidget extends StatelessWidget {
  SetSpeedWidget({
    super.key,
    required this.controller,
    required this.defaultUserDataModel,
  });

  TextEditingController? controller;
  DefaultUserDataModel? defaultUserDataModel;

  @override
  Widget build(BuildContext context) {
    var commonProvider = Provider.of<CommonProvider>(context, listen: false);

    return Consumer2<MeetingTickerProvider, WebinarThemesProviders>(
        builder: (context, tickerProvider, webinarThemesProviders, child) {
      return Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(ConstantsStrings.setSpeed,
                  style: w400_10Poppins(
                      color: webinarThemesProviders.hintTextColor)),
              width20,
              Container(
                width: MediaQuery.of(context).size.width * .22,
                height: 40.h,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8.r),
                  color: webinarThemesProviders.closeButtonColor,
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Padding(
                      padding: EdgeInsets.only(left: 5.w),
                      child: Text(
                          "${tickerProvider.tickerData.scrollSpeed} Sec",
                          style: w400_12Poppins(
                              color: Theme.of(context).hintColor)),
                    ),
                    SizedBox(
                      height: 40.h,
                      child: Column(
                        children: [
                          SizedBox(
                            height: 19.h,
                            child: InkWell(
                              onTap: () {
                                tickerProvider.secCountUp();
                              },
                              child: Container(
                                  decoration: BoxDecoration(
                                      color: webinarThemesProviders
                                          .closeButtonColor,
                                      borderRadius: BorderRadius.only(
                                          topRight: Radius.circular(10.sp))),
                                  child: const Icon(
                                    Icons.keyboard_arrow_up_outlined,
                                    color: Colors.white,
                                  )),
                            ),
                          ),
                          SizedBox(
                            height: 19.h,
                            child: InkWell(
                              onTap: () {
                                tickerProvider.secCountDown();
                              },
                              child: Container(
                                  decoration: BoxDecoration(
                                      color: webinarThemesProviders
                                          .closeButtonColor,
                                      borderRadius: BorderRadius.only(
                                          bottomRight: Radius.circular(10.sp))),
                                  child: const Icon(
                                      Icons.keyboard_arrow_down_outlined,
                                      color: Colors.white)),
                            ),
                          )
                        ],
                      ),
                    )
                  ],
                ),
              ),
            ],
          ),
          height15,
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // if (tickerProvider.isSetAsDefault == false)
              //   SizedBox(
              //       width: MediaQuery.of(context).size.width * .38,
              //       height: 40.h,
              //       child: Row(
              //         mainAxisAlignment: MainAxisAlignment.start,
              //         children: [
              //           Checkbox(
              //               value: tickerProvider.isSetAsDefault,
              //               onChanged: (value) {
              //                 tickerProvider.isDefaultSet(controller!.text, context, true);
              //               }),
              //           Expanded(
              //               child: Text(
              //             ConstantsStrings.setAsDefault,
              //             style: w400_12Poppins(color: Theme.of(context).hintColor),
              //           ))
              //         ],
              //       )),
              // width5,
              // tickerProvider.isSetAsDefault == true
              //     ? Align(
              //         alignment: Alignment.centerRight,
              //         child: CustomButton(
              //           width: MediaQuery.of(context).size.width * .30,
              //           height: 40.h,
              //           buttonColor: webinarThemesProviders.colors.buttonColor ?? AppColors.mainBlueColor,
              //           onTap: () {
              //             tickerProvider.isDefaultSet("", context, false);
              //             controller?.text = "";
              //           },
              //           buttonText: ConstantsStrings.resetToDefault,
              //           buttonTextStyle: w600_12Poppins(color: Colors.white),
              //         ),
              //       )
              //     : const SizedBox.shrink(),

              CustomButton(
                width: MediaQuery.of(context).size.width / 2 - 30.sp,
                height: 40.h,
                buttonColor: webinarThemesProviders.closeButtonColor,
                onTap: () {
                  Navigator.pop(context);
                },
                buttonText: ConstantsStrings.close,
                buttonTextStyle: w600_12Poppins(color: Colors.white),
              ),
              width5,
              CustomButton(
                width: MediaQuery.of(context).size.width / 2 - 30.sp,
                height: 40.h,
                buttonColor: webinarThemesProviders.colors.buttonColor ??
                    AppColors.mainBlueColor,
                onTap: () {
                  if (tickerProvider.tickerFormKey.currentState!.validate()) {
                    tickerProvider.publishTicker(context);
                    commonProvider.tickerPublish(
                        tickerProvider.tickerData.text, "Right", context);
                  }
                },
                buttonText: ConstantsStrings.publish,
                buttonTextStyle: w600_12Poppins(color: Colors.white),
              ),
            ],
          ),
        ],
      );
    });
  }
}

class _ColorPicker extends StatefulWidget {
  const _ColorPicker(
      {required this.initialColor, required this.onColorChanged});

  final Color initialColor;
  final void Function(Color color) onColorChanged;

  @override
  State<_ColorPicker> createState() => __ColorPickerState();
}

class __ColorPickerState extends State<_ColorPicker> {
  late Color selected;

  @override
  void initState() {
    super.initState();
    selected = widget.initialColor;
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        ColorPicker(
          pickerColor: selected,
          onColorChanged: (color) {
            setState(() {
              selected = color;
            });
          },
          colorPickerWidth: 300.0,
          pickerAreaHeightPercent: 0.7,
          enableAlpha: true,
          // hexInputController will respect it too.
          displayThumbColor: true,
          showLabel: true,
          paletteType: PaletteType.hslWithHue,
          pickerAreaBorderRadius: const BorderRadius.only(
            topLeft: Radius.circular(2.0),
            topRight: Radius.circular(2.0),
          ),
          // <- here
          // hexInputController: controller,
          portraitOnly: true,
        ),
        Padding(
          padding: const EdgeInsets.all(12.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              GestureDetector(
                  onTap: () {
                    Navigator.pop(context);
                  },
                  child: Text(
                    ConstantsStrings.cancel,
                    style: w500_16Poppins(
                        color: Provider.of<WebinarThemesProviders>(context,
                                        listen: false)
                                    .themeHighLighter !=
                                null
                            ? Theme.of(context).hoverColor
                            : AppColors.mainBlueColor),
                  )),
              GestureDetector(
                  onTap: () {
                    widget.onColorChanged(selected);
                    Navigator.pop(context);
                  },
                  child: Text(
                    ConstantsStrings.ok,
                    style: w500_16Poppins(
                        color: Provider.of<WebinarThemesProviders>(context,
                                        listen: false)
                                    .themeHighLighter !=
                                null
                            ? Theme.of(context).hoverColor
                            : AppColors.mainBlueColor),
                  )),
            ],
          ),
        )
      ],
    );
  }
}
