import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:o_connect/core/screen_configs.dart';
import 'package:o_connect/ui/utils/textfield_helper/app_fonts.dart';
import 'package:o_connect/ui/views/meeting/providers/participants_provider.dart';
import 'package:o_connect/ui/views/themes/providers/webinar_themes_provider.dart';
import 'package:o_connect/ui/views/webinar_details/webinar_details_provider/webinar_provider.dart';
import 'package:provider/provider.dart';

class WebinarFeaturesPopUp extends StatelessWidget {
  const WebinarFeaturesPopUp({super.key});
  @override
  Widget build(BuildContext context) {
    return Consumer2<WebinarProvider, WebinarThemesProviders>(builder: (context, webinarProvider, webinarThemesProviders, child) {
      return AnimatedPadding(
        duration: const Duration(seconds: 10),
        padding: EdgeInsets.only(
          bottom: webinarProvider.showMoreFeaturesPopUp
              ? Platform.isIOS
                  ? 80.h
                  : 70.h
              : 0,
        ),
        child: Align(
          alignment: Alignment.bottomCenter,
          child: Container(
            // height: 350.h,
            constraints: BoxConstraints(maxHeight: 300.h),
            alignment: Alignment.center,
            width: ScreenConfig.width,
            color: const Color(0xff16181A),
            child: GridView.builder(
              physics: const NeverScrollableScrollPhysics(),
              itemCount: webinarProvider.webinarAllowedFeatures.length,
              padding: const EdgeInsets.all(0),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 4, childAspectRatio: 1.3),
              itemBuilder: (context, index) {
                return WebinarFeatureItemsList(
                  index: index,
                );
              },
            ),
          ),
        ),
      );
    });
  }
}

class WebinarFeatureItemsList extends StatelessWidget {
  const WebinarFeatureItemsList({super.key, required this.index});
  final int index;
  @override
  Widget build(BuildContext context) {
    return Consumer2<WebinarProvider, ParticipantsProvider>(builder: (context, webinarProvider, participantsProvider, child) {
      return InkWell(
        onTap: () {
          webinarProvider.showMoreFeature();
          Future.delayed(const Duration(seconds: 1));
          webinarProvider.webinarAllowedFeatures[index].onTap();
          webinarProvider.callNotify();
        },
        child: Container(
          alignment: Alignment.center,
          child: Column(mainAxisAlignment: MainAxisAlignment.center, crossAxisAlignment: CrossAxisAlignment.center, children: [
            Container(
                padding: EdgeInsets.all(8.sp),
                decoration: BoxDecoration(color: const Color(0xff202223), borderRadius: BorderRadius.circular(5.r)),
                child: SvgPicture.asset(webinarProvider.webinarAllowedFeatures[index].icon)),
            SizedBox(
              height: 2.h,
            ),
            Text(
              webinarProvider.webinarAllowedFeatures[index].iconTitle,
              style: w400_10Poppins(color: Colors.white),
            )
          ]),
        ),
      );
    });
  }
}
