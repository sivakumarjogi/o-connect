import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:o_connect/ui/utils/colors/colors.dart';
import 'package:o_connect/ui/utils/images/images.dart';
import 'package:o_connect/ui/utils/network_image_helpers/cached_image_validation.dart';
import 'package:o_connect/ui/utils/textfield_helper/app_fonts.dart';
import 'package:o_connect/ui/views/chat_screen/providers/chat_provider.dart';
import 'package:o_connect/ui/views/meeting/utils/meeting_utils_mixin.dart';
import 'package:provider/provider.dart';

import '../../../meeting/model/user_role.dart';
import '../../../themes/providers/webinar_themes_provider.dart';

class QAView extends StatelessWidget with MeetingUtilsMixin {
  QAView({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<ChatProvider>(
      builder: (context, chatProvider, child) {
        return SingleChildScrollView(
          child: Column(
            children: [
              if (myRole == UserRole.host)
                InkWell(
                    onTap: () {
                      chatProvider.questionAndAnsClose(context);
                    },
                    child: Padding(
                      padding: EdgeInsets.all(10.0.sp),
                      child: Align(
                        alignment: Alignment.topLeft,
                        child: Icon(
                          Icons.cancel,
                          color: Colors.red,
                          size: 30.sp,
                        ),
                      ),
                    )),
              chatProvider.webinarQAndAMessagesList.isEmpty
                  ? SizedBox(
                      width: MediaQuery.of(context).size.width,
                      height: MediaQuery.of(context).size.height / 1.5,
                      child: Center(
                        child: SizedBox(
                          height: 290.w,
                          width: 290.w,
                          child: Column(
                            children: [
                              Image.asset(
                                AppImages.qAndAEmptyIconPng,
                                width: 225.w,
                                height: 175.h,
                              ),
                              Container(
                                alignment: Alignment.center,
                                height: 30.h,
                                child: Text(
                                  textAlign: TextAlign.center,
                                  "The Q&A window is empty",
                                  style: w600_18Poppins(color: const Color(0xff0E78F9)),
                                ),
                              ),
                              Container(
                                alignment: Alignment.center,
                                width: 224.w,
                                height: 42.h,
                                child: Text(
                                  textAlign: TextAlign.center,
                                  "The attendees haven't asked any questions yet for you to answer",
                                  style: w400_14Poppins(color: context.read<WebinarThemesProviders>().hintTextColor),
                                ),
                              )
                            ],
                          ),
                        ),
                      ),
                    )
                  : ListView.builder(
                      shrinkWrap: true,
                      itemCount: chatProvider.webinarQAndAMessagesList.length,
                      itemBuilder: (context, index) {
                        return Padding(
                          padding: EdgeInsets.symmetric(vertical: 5.w, horizontal: 30.h),
                          child: Column(
                            children: [
                              Row(
                                children: [
                                  Align(
                                    alignment: Alignment.centerRight,
                                    child: Padding(
                                      padding: EdgeInsets.only(right: 30.0.sp),
                                      child: Row(
                                        crossAxisAlignment: CrossAxisAlignment.center,
                                        mainAxisAlignment: MainAxisAlignment.end,
                                        children: [
                                          Container(
                                            height: 40.w,
                                            width: 40.w,
                                            decoration: BoxDecoration(border: Border.all(color: AppColors.whiteColor, width: 2.w), borderRadius: BorderRadius.all(Radius.circular(25.r))),
                                            child: chatProvider.webinarQAndAMessagesList[index].ppic.toString() == null || chatProvider.webinarQAndAMessagesList[index].ppic.toString() == "null"
                                                ? Text(
                                                    textAlign: TextAlign.center,
                                                    chatProvider.webinarQAndAMessagesList[index].userName!.split("").first.toString() ?? "s",
                                                    style: w500_20Poppins(color: Colors.white),
                                                  )
                                                : ClipRRect(
                                                    borderRadius: BorderRadius.circular(50.r), child: ImageServiceWidget(networkImgUrl: chatProvider.webinarQAndAMessagesList[index].ppic.toString())),
                                          ),
                                          width15,
                                          Text(
                                            chatProvider.webinarQAndAMessagesList[index].userName.toString(),
                                            textAlign: TextAlign.start,
                                            style: w400_16Poppins(color: Theme.of(context).hintColor),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                  const Spacer(),
                                  if (myRole == UserRole.host)
                                    Padding(
                                      padding: EdgeInsets.all(3.0.sp),
                                      child: Align(
                                        alignment: Alignment.topRight,
                                        child: InkWell(
                                          onTap: () {
                                            chatProvider.deleteQAnsAMessageDelete(context, chatProvider.webinarQAndAMessagesList[index].chatId);
                                          },
                                          child: const Icon(
                                            Icons.cancel,
                                            color: Colors.red,
                                          ),
                                        ),
                                      ),
                                    )
                                ],
                              ),
                              height10,
                              Container(
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(8.r),
                                  color: context.read<WebinarThemesProviders>().unSelectButtonsColor
                                ),
                                padding: EdgeInsets.all(5.sp),
                                width: MediaQuery.of(context).size.width,
                                child: Row(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    SvgPicture.asset(AppImages.q,color: context.read<WebinarThemesProviders>().hintTextColor,),
                                    SvgPicture.asset(AppImages.q,color: context.read<WebinarThemesProviders>().hintTextColor),
                                    width20,
                                    Flexible(
                                      child: Text(
                                        chatProvider.webinarQAndAMessagesList[index].message.toString(),
                                        // textAlign: TextAlign.center,
                                        style: w400_16Poppins(color: context.read<WebinarThemesProviders>().hintTextColor),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              height10,
                            ],
                          ),
                        );
                      }),
            ],
          ),
        );
      },
    );
  }
}
