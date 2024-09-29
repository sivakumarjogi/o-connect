import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:o_connect/core/screen_configs.dart';
import 'package:o_connect/ui/utils/textfield_helper/app_fonts.dart';
import 'package:o_connect/ui/views/meeting/providers/participants_provider.dart';
import 'package:o_connect/ui/views/webinar_details/webinar_details_provider/webinar_provider.dart';
import 'package:provider/provider.dart';

class WebinarMoreOptionsPopUp extends StatelessWidget {
  const WebinarMoreOptionsPopUp({super.key});
  @override
  Widget build(BuildContext context) {
    return Consumer2<WebinarProvider, ParticipantsProvider>(builder: (_, webinarProvider, participantsProvider, __) {
      return Padding(
        padding: EdgeInsets.only(bottom: Platform.isIOS ? 75.h : 70.h),
        child: Align(
          alignment: Alignment.bottomCenter,
          child: Container(
            height: 80.h,
            color: const Color(0xff16181A),
            width: ScreenConfig.width,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                ...List.generate(
                    webinarProvider.webinarAllowedMoreOptions.length,
                    (index) => InkWell(
                          onTap: () {
                            webinarProvider.showWebinarMoreOptions();
                            Future.delayed(const Duration(seconds: 1));
                            webinarProvider.webinarAllowedMoreOptions[index].onTap();
                            webinarProvider.callNotify();
                          },
                          child: Container(
                            alignment: Alignment.center,
                            child: Column(mainAxisAlignment: MainAxisAlignment.center, crossAxisAlignment: CrossAxisAlignment.center, children: [
                              Container(
                                  padding: EdgeInsets.all(8.sp),
                                  decoration: BoxDecoration(color: const Color(0xff202223), borderRadius: BorderRadius.circular(5.r)),
                                  child: SvgPicture.asset(webinarProvider.webinarAllowedMoreOptions[index].icon)),
                              SizedBox(
                                height: 3.h,
                              ),
                              Text(
                                webinarProvider.webinarAllowedMoreOptions[index].iconTitle,
                                style: w400_10Poppins(color: Colors.white),
                              )
                            ]),
                          ),
                        ))
              ],
            ),
          ),
        ),
      );
    });
  }
}
