import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:o_connect/ui/utils/colors/colors.dart';
import 'package:o_connect/ui/utils/custom_toast_helper/custom_toast.dart';
import 'package:o_connect/ui/utils/textfield_helper/app_fonts.dart';
import 'package:o_connect/ui/views/meeting/providers/participants_provider.dart';
import 'package:o_connect/ui/views/meeting/providers/video_share_provider.dart';
import 'package:provider/provider.dart';

import '../themes/providers/webinar_themes_provider.dart';

class SpeakerRequest extends StatefulWidget {
  const SpeakerRequest({super.key});

  @override
  State<SpeakerRequest> createState() => _SpeakerRequestState();
}

class _SpeakerRequestState extends State<SpeakerRequest> {
  @override
  void initState() {
    print("speakerRequestedList    ${context.read<VideoShareProvider>().speakerRequestedList.length}");
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer2<WebinarThemesProviders, VideoShareProvider>(builder: (_, webinarThemesProviders, videoShareProvider, __) {
      return Container(
        height: 300.h,
        decoration: BoxDecoration(
          color: webinarThemesProviders.colors.headerColor,
          borderRadius: BorderRadius.circular(15.r),
        ),
        child: Column(
          children: [
            height20,
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 8.0.sp),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(
                    "Speaker Request",
                    style: w400_14Poppins(color: webinarThemesProviders.colors.textColor),
                  ),
                  InkWell(
                    onTap: () {
                      Navigator.pop(context);
                    },
                    child: Icon(
                      Icons.cancel,
                      color: webinarThemesProviders.hintTextColor,
                    ),
                  )
                ],
              ),
            ),
            height20,
            Divider(
              height: 2.sp,
              color: webinarThemesProviders.hintTextColor,
            ),
            height20,
            Expanded(
              child: ListView.builder(
                itemBuilder: (context, index) => Padding(
                  padding: EdgeInsets.symmetric(horizontal: 8.0.w, vertical: 10.h),
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.all(Radius.circular(5.sp)),
                      color: webinarThemesProviders.unSelectButtonsColor,
                    ),
                    child: Row(
                      children: [
                        Padding(
                          padding: EdgeInsets.symmetric(horizontal: 10.sp),
                          child: CircleAvatar(
                            child: Text(
                              videoShareProvider.speakerRequestedList[index].name!.substring(0, 2).toUpperCase().toString() ?? "",
                              style: w600_14Poppins(color: webinarThemesProviders.hintTextColor),
                            ),
                          ),
                        ),
                        Expanded(
                          child: Padding(
                            padding: EdgeInsets.symmetric(vertical: 5.sp),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  videoShareProvider.speakerRequestedList[index].name.toString() ?? "",
                                  style: w400_14Poppins(color: webinarThemesProviders.hintTextColor),
                                ),
                                height5,
                                Text(
                                  videoShareProvider.speakerRequestedList[index].email ?? "",
                                  overflow: TextOverflow.ellipsis,
                                  style: w400_14Poppins(color: webinarThemesProviders.hintTextColor),
                                ),
                              ],
                            ),
                          ),
                        ),
                        InkWell(
                          onTap: () {
                            if (videoShareProvider.speakerRequestedList[index].id != null) {
                              context.read<ParticipantsProvider>().hostCancelSpeakerRequest(videoShareProvider.speakerRequestedList[index].id.toString(),false);
                            } else {
                              CustomToast.showErrorToast(msg: "Unable to cancel request");
                            }
                          },
                          child: Padding(
                            padding: EdgeInsets.symmetric(horizontal: 10.sp),
                            child:  Icon(
                              Icons.clear,
                              size: 25.sp,
                              color: Colors.red,
                            ),
                          ),
                        ),
                        InkWell(
                          onTap: () {
                            if (videoShareProvider.speakerRequestedList[index].id != null) {
                              context.read<ParticipantsProvider>().hostCancelSpeakerRequest(videoShareProvider.speakerRequestedList[index].id.toString(),true);
                            } else {
                              CustomToast.showErrorToast(msg: "Unable to accept request");
                            }
                          },
                          child: Padding(
                            padding: EdgeInsets.symmetric(horizontal: 10.sp),
                            child:  Icon(
                              Icons.check,
                              size: 25.sp,
                              color: Colors.green,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                itemCount: context.read<VideoShareProvider>().speakerRequestedList.length,
              ),
            )
          ],
        ),
      );
    });
  }
}
