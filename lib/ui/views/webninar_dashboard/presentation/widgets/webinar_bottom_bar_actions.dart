import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:o_connect/ui/utils/textfield_helper/app_fonts.dart';
import 'package:o_connect/ui/views/chat_screen/providers/chat_provider.dart';
import 'package:o_connect/ui/views/meeting/providers/participants_provider.dart';
import 'package:o_connect/ui/views/webinar_details/webinar_details_provider/webinar_provider.dart';
import 'package:provider/provider.dart';

class WebinarBottomBarActions extends StatelessWidget {
  const WebinarBottomBarActions({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer2<WebinarProvider, ParticipantsProvider>(builder: (context, webinarProvider, participantsProvider, child) {
      return Container(
        height: Platform.isIOS ? 70.h : 60.h,
        color: const Color(0xff0C0D0E),
        padding: EdgeInsets.symmetric(vertical: 5.h, horizontal: 16.w),
        child: SingleChildScrollView(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: List.generate(
                webinarProvider.webinarBottomBarAllowedActions.length,
                (index) => Stack(
                      children: [
                        InkWell(
                          onTap: () {
                            webinarProvider.webinarBottomBarAllowedActions[index].onTap();
                            webinarProvider.callNotify();
                          },
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              SvgPicture.asset(
                                webinarProvider.webinarBottomBarAllowedActions[index].icon,
                                width: 25.w,
                                height: 25.w,
                              ),
                              Container(
                                alignment: Alignment.center,
                                width: 50,
                                child: Text(
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  webinarProvider.webinarBottomBarAllowedActions[index].iconTitle,
                                  style: w400_10Poppins(color: Colors.white),
                                ),
                              )
                            ],
                          ),
                        ),
                        if (webinarProvider.webinarBottomBarAllowedActions[index].iconTitle == "Chat")
                          Positioned(
                            right: 5.sp,
                            top: 0,
                            child: Container(
                              height: 14.w,
                              width: 14.w,
                              alignment: Alignment.center,
                              decoration: BoxDecoration(borderRadius: BorderRadius.all(Radius.circular(7.r)), color: Colors.green),
                              child: Text(
                                context.read<ChatProvider>().getGroupChatCount.toString(),
                                style: w400_10Poppins(color: Colors.white),
                              ),
                            ),
                          ),
                      ],
                    )),
          ),
        ),
      );
    });
  }
}
