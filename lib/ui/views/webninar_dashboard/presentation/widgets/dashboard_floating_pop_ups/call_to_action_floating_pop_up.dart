import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:o_connect/core/common_functions.dart';
import 'package:o_connect/core/providers/theme_provider.dart';
import 'package:o_connect/ui/utils/colors/colors.dart';
import 'package:o_connect/ui/utils/images/images.dart';
import 'package:o_connect/ui/utils/textfield_helper/app_fonts.dart';
import 'package:o_connect/ui/views/call_to_action/providers/dashboard_call_to_action_provider.dart';
import 'package:o_connect/ui/views/themes/providers/webinar_themes_provider.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../../webinar_details/webinar_details_provider/webinar_provider.dart';

class CallToActionFloatingPopUp extends StatelessWidget {
  const CallToActionFloatingPopUp({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer3<ThemeProvider, DashBoardCallToActionProvider, WebinarThemesProviders>(builder: (context, themeProvider, callToActionProvider, webinarThemesProviders, child) {
      var myHubInfo = callToActionProvider.myHubInfo;
      debugPrint("the CTA values are the ${callToActionProvider.ctaResponseDataModel?.title}");
      return Container(
        height: 100.h,
        margin: EdgeInsets.symmetric(horizontal: 10.w),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(5.r),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Row(
              children: [
                width5,
                Icon(
                  Icons.access_time,
                  color: AppColors.whiteColor,
                  size: 20.sp,
                ),
                width5,
                Text(
                  callToActionProvider.displayTimeValue.toString(),
                  style: w400_12Poppins(color: AppColors.whiteColor),
                ),
                width5,
                if (myHubInfo.isHostOrActiveHost) ...[
                  Icon(
                    Icons.touch_app,
                    size: 18.sp,
                  ),
                  width5,
                  Text(
                    callToActionProvider.ctaTapCount.toString(),
                    style: w400_12Poppins(color: AppColors.whiteColor),
                  ),
                ],
                const Spacer(),
                if (myHubInfo.isHostOrActiveHost)
                  InkWell(
                      onTap: () {
                        context.read<WebinarProvider>().disableActiveFuture();
                      },
                      child: SvgPicture.asset(
                        AppImages.popUpMinimizelIcon,
                        height: 24.w,
                        width: 24.w,
                      )),
                width10,
                if (myHubInfo.isHostOrActiveHost)
                  InkWell(
                      onTap: () {
                        callToActionProvider.deleteCTAGlobalSet().then((value) => context.read<WebinarProvider>().disableActiveFuture());
                      },
                      child: SvgPicture.asset(
                        AppImages.popUpCancelIcon,
                        height: 24.w,
                        width: 24.w,
                      )),
              ],
            ),
            height15,
            Row(
              children: [
                width5,
                InkWell(
                    onTap: () async {
                      /*                  FlPiP().enable(ios: FlPiPiOSConfig(), android: FlPiPAndroidConfig(aspectRatio: Rational.square()));*/
                    },
                    child: Container(
                      width: ScreenUtil.defaultSize.width / 2 - 30.sp,
                      height: 40.h,
                      decoration: BoxDecoration(
                        color: callToActionProvider.ctaResponseDataModel?.headerBgColor.toString().toColor() ?? const Color(0xff9DEE90),
                        borderRadius: BorderRadius.circular(5.r),
                      ),
                      child: Center(
                          child: Text(
                        callToActionProvider.ctaResponseDataModel?.title.toString() ?? "NA",
                        style: w400_12Poppins(color: Colors.white),
                        overflow: TextOverflow.ellipsis,
                        maxLines: 1,
                      )),
                    )),
                const Spacer(),
                InkWell(
                    onTap: () async {
                      if (!callToActionProvider.myHubInfo.isHostOrActiveHost && !callToActionProvider.myHubInfo.isCohost) {
                        callToActionProvider.getCTANoOfTapsCount(context);
                      }
                      await launchUrl(
                        Uri.parse(callToActionProvider.ctaResponseDataModel?.buttonUrl.toString() ?? "https://www.onpassive.com/"),
                      );
                    },
                    child: Container(
                      width: ScreenUtil.defaultSize.width / 2 - 30.sp,
                      height: 40.h,
                      decoration: BoxDecoration(
                        color: callToActionProvider.ctaResponseDataModel?.buttonBgColor.toString().toColor() ?? webinarThemesProviders.colors.buttonColor,
                        borderRadius: BorderRadius.circular(5.r),
                      ),
                      child: Center(
                          child: Text(
                        callToActionProvider.ctaResponseDataModel?.buttonText ?? "Proceed",
                        style: w400_12Poppins(color: callToActionProvider.ctaResponseDataModel?.buttonTextColor.toString().toColor() ?? webinarThemesProviders.colors.textColor),
                        overflow: TextOverflow.ellipsis,
                        maxLines: 1,
                      )),
                    )),
                // CustomButton(
                //   width: 80.w,
                //   height: 50.h,
                //   buttonText: callToActionProvider.ctaResponseDataModel?.buttonText ?? "Proceed",
                //   buttonTextStyle: w400_12Poppins(color: callToActionProvider.ctaResponseDataModel?.buttonTextColor.toString().toColor() ?? webinarThemesProviders.colors.textColor),
                //   buttonColor: callToActionProvider.ctaResponseDataModel?.buttonBgColor.toString().toColor() ?? webinarThemesProviders.colors.buttonColor,
                //   onTap: () async {
                //     print("[sfidshfuhfgirdghghh");
                //     final meetingData = context.read<ParticipantsProvider>().myHubInfo;
                //     // if (!meetingData.isHost) {
                //     callToActionProvider.getCTANoOfTapsCount(context);
                //     // }
                //     await launchUrl(
                //       Uri.parse(callToActionProvider.ctaResponseDataModel?.buttonUrl.toString() ?? "https://www.onpassive.com/"),
                //     );
                //   },
                // ),
              ],
            ),
          ],
        ),
      );
    });
  }
}
