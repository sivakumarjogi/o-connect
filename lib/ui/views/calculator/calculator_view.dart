import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:o_connect/core/providers/calculator_provider.dart';
import 'package:o_connect/core/providers/theme_provider.dart';
import 'package:o_connect/core/screen_configs.dart';
import 'package:o_connect/ui/utils/close_widget.dart';
import 'package:o_connect/ui/utils/colors/colors.dart';
import 'package:o_connect/ui/utils/constant_strings.dart';
import 'package:o_connect/ui/utils/textfield_helper/app_fonts.dart';
import 'package:o_connect/ui/views/meeting/model/model.dart';
import 'package:o_connect/ui/views/meeting/providers/participants_provider.dart';
import 'package:o_connect/ui/views/themes/providers/webinar_themes_provider.dart';
import 'package:provider/provider.dart';
import '../../utils/custom_show_dialog_helper/custom_show_dialog.dart';
import 'widgets/flutter_awesome_calculator.dart';

class Calculator extends StatefulWidget {
  const Calculator({super.key, this.disableClick = false});

  final bool disableClick;

  @override
  State<Calculator> createState() => _CalculatorState();
}

class _CalculatorState extends State<Calculator> {
  @override
  void initState() {
    super.initState();
    context.read<CalculatorProvider>().setWidgetContext(context);
  }

  @override
  Widget build(BuildContext context) {
    return Consumer4<WebinarThemesProviders, ThemeProvider, CalculatorProvider, ParticipantsProvider>(
        builder: (context, webinarThemesProviders, themeProvider, calProvider, participantProvider, child) {
      return Container(
        height: ScreenConfig.height * 0.85,
        decoration: BoxDecoration(
            border: Border.all(color: webinarThemesProviders.colors.headerColor, width: 4.w),
            color: webinarThemesProviders.colors.bodyColor,
            borderRadius: BorderRadius.only(topLeft: Radius.circular(25.r), topRight: Radius.circular(25.r))),
        child: Column(
          children: [
            Consumer<WebinarThemesProviders>(builder: (context, webinarThemesProviders, __) {
              // webinarThemesProviders.setupDefaultColors();
              return Container(
                decoration: BoxDecoration(
                    // color: headerColor ?? webinarThemesProviders.colors.headerColor,
                    borderRadius: BorderRadius.only(
                  topRight: Radius.circular(20.r),
                  topLeft: Radius.circular(20.r),
                )),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    height10,
                    Align(
                      alignment: Alignment.center,
                      child: Container(
                        height: 5.h,
                        width: 100.w,
                        decoration: BoxDecoration(borderRadius: BorderRadius.circular(20.r), color: const Color(0xff202223)),
                      ),
                    ),
                    height10,
                    Padding(
                      padding: EdgeInsets.all(5.0.sp),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            ConstantsStrings.calculator,
                            style: w500_14Poppins(color: Theme.of(context).hoverColor),
                          ),
                          Consumer2<ParticipantsProvider, WebinarThemesProviders>(
                            builder: (context, provider, webinarThemesProviders, child) {
                              if (provider.myRole == UserRole.unknown) return const SizedBox();
                              if (provider.myRole == UserRole.speaker) return const SizedBox();
                              if (provider.myRole == UserRole.guest) return const SizedBox();

                              final isHostPresent = provider.isHostPresent;
                              final myHubInfo = provider.myHubInfo;

                              // if (!isHostPresent && !myHubInfo.isActiveHost) return const SizedBox();
                              if (isHostPresent && provider.myRole == UserRole.speaker &&
                                  provider.myRole == UserRole.activeHost &&
                                  provider.myRole == UserRole.coHost &&
                                  provider.myRole == UserRole.unknown &&
                                  provider.myRole == UserRole.guest) return const SizedBox();
                              if (provider.isActiveHostPresent &&
                                  provider.myRole == UserRole.speaker &&
                                  provider.myRole == UserRole.coHost &&
                                  provider.myRole == UserRole.unknown &&
                                  provider.myRole == UserRole.guest) return const SizedBox();
                              if (provider.isCoHostPresent &&
                                  provider.myRole == UserRole.speaker &&
                                  provider.myRole == UserRole.unknown &&
                                  provider.myRole == UserRole.guest) return const SizedBox();
                              return GestureDetector(
                                onTap: () {
                                  context.read<CalculatorProvider>().setCalculatorIsClosed();
                                  Navigator.of(context).pop();
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
                                      size: 18,
                                      color: Theme.of(context).scaffoldBackgroundColor,
                                    ),
                                  ),
                                ),
                              );
                            },
                          )
                        ],
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 12.w),
                      child: const Divider(),
                    ),
                  ],
                ),
              );
            }),
            height10,
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 8.w),
              child: FlutterAwesomeCalculator(
                controller: calProvider.calculatorController,
                disableClick: widget.disableClick,

                context: context,
                expressionAnswerColor: Colors.white,
                showAnswerField: true,
                fractionDigits: 1,
                height: ScreenConfig.height * 0.48,
                clearButtonTextStyle: w500_20Poppins(color: Colors.white),
                digitsButtonTextStyle: w500_20Poppins(color: Colors.white),
                expressionAnswerTextStyle: w500_20Poppins(color: Colors.white),
                operatorsButtonTextStyle: w500_20Poppins(color: Colors.white),

                ///Ans buttons
                answerFieldColor: webinarThemesProviders.bgColor,
                digitsButtonColor: webinarThemesProviders.colors.calButtonColors,
                backgroundColor: webinarThemesProviders.bgColor,
                equalToButtonColor: webinarThemesProviders.colors.itemColor,
                clearButtonColor: webinarThemesProviders.colors.itemColor,
                operatorsButtonColor: webinarThemesProviders.colors.itemColor,

                buttonRadius: 15.r,
                answerFontSize: 28.sp,
                onChanged: (ans, expression) {
                  calProvider.emitCalculatorInput(ans, expression);
                },
              ),
            ),
            // const _CloseWidget(),
          ],
        ),
      );
    });
  }
}

/// If host is available in the meeting, then the host will see the close options.
/// Otherwise activehost will see the close option.
class _CloseWidget extends StatelessWidget {
  const _CloseWidget();

  @override
  Widget build(BuildContext context) {
    return Consumer2<ParticipantsProvider, WebinarThemesProviders>(
      builder: (context, provider, webinarThemesProviders, child) {
        if (provider.myRole == UserRole.unknown) return const SizedBox();

        final isHostPresent = provider.isHostPresent;
        final myHubInfo = provider.myHubInfo;

        if (isHostPresent && !myHubInfo.isHost) return const SizedBox();
        if (!isHostPresent && !myHubInfo.isActiveHost) return const SizedBox();
        return CloseWidget(
          textColor: webinarThemesProviders.hintTextColor,
          onTap: () {
            context.read<CalculatorProvider>().setCalculatorIsClosed();
            Navigator.of(context).pop();
          },
        );
      },
    );
  }
}
