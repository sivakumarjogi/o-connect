import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:o_connect/ui/utils/colors/colors.dart';
import 'package:o_connect/ui/utils/images/images.dart';
import 'package:o_connect/ui/utils/textfield_helper/app_fonts.dart';
import 'package:o_connect/ui/views/themes/providers/webinar_themes_provider.dart';
import 'package:o_connect/ui/views/timer/provider/timer_provider.dart';
import 'package:provider/provider.dart';

import '../../../webinar_details/webinar_details_provider/webinar_provider.dart';

class ParticipantTimer extends StatefulWidget {
  const ParticipantTimer({super.key});

  @override
  State<ParticipantTimer> createState() => _ParticipantTimerState();
}

class _ParticipantTimerState extends State<ParticipantTimer> with SingleTickerProviderStateMixin {
  late TimerProvider _timerProvider;

  @override
  void initState() {
    super.initState();
    _timerProvider = Provider.of<TimerProvider>(context, listen: false);
    _timerProvider.initAnimation(this);
  }

  @override
  void dispose() {
    _timerProvider.animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer2<TimerProvider, WebinarThemesProviders>(
      builder: (context, timerProvider, webinarThemesProviders, child) {
        return Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.all(Radius.circular(5.sp),

            ),
            color: webinarThemesProviders.unSelectButtonsColor
          ),
          child: Row(
            children: [
              width10,
              SvgPicture.asset(
                AppImages.timerNewIcon,
                height: 24.w,
                width: 24.w,
              ),
              width10,
              Visibility(
                visible: timerProvider.myHubInfo.isHostOrActiveHost || timerProvider.myHubInfo.isCohost,
                child: Text(
                  timerProvider.selectedUser ?? "",
                  style: w400_14Poppins(
                    color: webinarThemesProviders.colors.textColor,
                  ),
                ),
              ),
              Spacer(),
              width10,
              AnimatedBuilder(
                  animation: _timerProvider.animation,
                  builder: (context, _) {
                    return Transform.scale(
                      scale: _timerProvider.animation.value,
                      child: Container(
                        height: 40.h,
                        alignment: Alignment.center,
                        padding: EdgeInsets.symmetric(horizontal: 6.0.h),
                        decoration: BoxDecoration(color: timerProvider.timerCountDownStart ? Colors.red : webinarThemesProviders.colors.itemColor, borderRadius: BorderRadius.circular(3.r)),
                        margin: EdgeInsets.only(right: 20.w),
                        child: Text(
                          timerProvider.displayTimeValue,
                          style: w400_14Poppins(
                            color: Colors.white,
                          ),
                        ),
                      ),
                    );
                  }),

              width5,
              InkWell(
                  onTap: () {
                    context.read<WebinarProvider>().disableActiveFuture();
                  },
                  child: SvgPicture.asset(
                    "assets/new_ui_icons/webinar_dashboard/miniView.svg",
                    height: 24.w,
                    width: 24.w,
                  )),
              width10,
              Visibility(
                visible: timerProvider.myHubInfo.isHostOrActiveHost || timerProvider.myHubInfo.isCohost ,
                child: InkWell(
                  onTap: () {
                    if (timerProvider.timer != null) {
                      timerProvider.timer!.cancel();
                      timerProvider.timerCountDownStart = false;
                    }
                    timerProvider.deleteTimerGlobalSet(context).then((value) => context.read<WebinarProvider>().disableActiveFuture());
                  },
                  child:  SvgPicture.asset(
          "assets/new_ui_icons/webinar_dashboard/cancel.svg",
          height: 24.w,
          width: 24.w,
          ),
                ),
              ),
              width10,
            ],
          ),
        );
      },
    );
  }
}
