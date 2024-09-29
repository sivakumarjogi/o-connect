import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:marquee/marquee.dart';
import 'package:o_connect/core/screen_configs.dart';
import 'package:o_connect/ui/utils/images/images.dart';
import 'package:o_connect/ui/views/meeting/providers/participants_provider.dart';
import 'package:o_connect/ui/views/ticker/provider/ticker_provider.dart'
    as ticker;
import 'package:provider/provider.dart';

import '../../utils/colors/colors.dart';
import '../themes/providers/webinar_themes_provider.dart';

class TickerWidget extends StatelessWidget {
  const TickerWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer2<ticker.MeetingTickerProvider, WebinarThemesProviders>(
        builder: (_, provider, webinarThemesProviders, __) {
      if (!provider.displayTicker) return const SizedBox();

      final tickerData = provider.tickerData;

      return Container(
        width: ScreenConfig.width,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.all(Radius.circular(5.r)),
          color: webinarThemesProviders.unSelectButtonsColor,
        ),
        alignment: Alignment.center,
        height: 35.h,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // width5,
            // InkWell(
            //   onTap: () => provider.togglePause(),
            //   child: tickerData.pauseButton == true ? const Icon(Icons.pause) : const Icon(Icons.play_arrow),
            // ),
            width10,
            Consumer<ParticipantsProvider>(builder: (_, pro, __) {
              var myHubInfo = pro.myHubInfo;
              if (myHubInfo.isActiveHost ||
                  myHubInfo.isHost ||
                  myHubInfo.isCohost) {
                return Padding(
                  padding: EdgeInsets.symmetric(vertical: 5.0.sp),
                  child: InkWell(
                    onTap: () => provider.removeTicker(context),
                    child: SvgPicture.asset(AppImages.tickerStop),
                  ),
                );
              }

              return const SizedBox();
            }),
            width10,
            Expanded(
              child: Marquee(
                text: tickerData.text ?? '',
                style: provider.tickerTextStyle,
                blankSpace: MediaQuery.of(context).size.width,
                velocity: (tickerData.scrollSpeed?.toDouble() ?? 10.0) * 5,
              ),
            ),
          ],
        ),
      );
    });
  }
}
