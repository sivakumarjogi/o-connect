import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:o_connect/core/models/library_model/library_meeting_history_model.dart';
import 'package:o_connect/core/providers/library_provider.dart';
import 'package:o_connect/ui/utils/images/images.dart';
import 'package:provider/provider.dart';
import '../../../../utils/colors/colors.dart';
import '../../../../utils/textfield_helper/app_fonts.dart';

class LibraryOptions extends StatefulWidget {
  LibraryOptions({super.key, required this.meetingData});

  var meetingData;

  @override
  State<LibraryOptions> createState() => _LibraryOptionsState();
}

class _LibraryOptionsState extends State<LibraryOptions> {
  LibraryProvider? libraryProvider;

  @override
  void initState() {
    libraryProvider = Provider.of<LibraryProvider>(context, listen: false);
    libraryProvider?.screenShotCount = widget.meetingData?.screenShot.toString() ?? "0";
    libraryProvider?.recordingCount = widget.meetingData?.recordings.toString() ?? "0";
    libraryProvider?.presentationCount = widget.meetingData?.presentation.toString() ?? "0";
    libraryProvider?.videosCount = widget.meetingData?.webinarVideo.toString() ?? "0";
    libraryProvider?.attachmentCount = widget.meetingData?.chat.toString() ?? "0";
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      child: Consumer<LibraryProvider>(builder: (context, libraryProvider, child) {
        return Center(
          child: Padding(
            padding: EdgeInsets.all(8.sp),
            child: Container(
              decoration: BoxDecoration(borderRadius: BorderRadius.circular(5.r), color: Theme.of(context).scaffoldBackgroundColor),
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    InkWell(
                      onTap: () {
                        libraryProvider.getItemDetails("Recordings", widget.meetingData!.id, context);
                      },
                      child: MeetingDataCard(
                        itemIcon: AppImages.micMeetingHistory,
                        itemName: "Recordings",
                        itemCount: libraryProvider.recordingCount,
                      ),
                    ),
                    InkWell(
                      onTap: () {
                        libraryProvider.getItemDetails("presentation", widget.meetingData!.id, context);
                      },
                      child: MeetingDataCard(
                        itemIcon: AppImages.meetingHistoryPresentation,
                        itemName: "Presentation",
                        itemCount: libraryProvider.presentationCount,
                      ),
                    ),
                    InkWell(
                      onTap: () {
                        libraryProvider.getItemDetails("webinar-video", widget.meetingData!.id, context);
                      },
                      child: MeetingDataCard(
                        itemIcon: AppImages.meetingHistoryVideo,
                        itemName: "Videos",
                        itemCount: libraryProvider.videosCount,
                      ),
                    ),
                    InkWell(
                      onTap: () {
                        libraryProvider.getItemDetails("Chat", widget.meetingData!.id, context);
                      },
                      child: MeetingDataCard(
                        itemIcon: AppImages.meetingHistoryChat,
                        itemName: "Chat",
                        itemCount: libraryProvider.attachmentCount,
                      ),
                    ),
                    InkWell(
                      onTap: () {
                        libraryProvider.getItemDetails("ScreenShot", widget.meetingData!.id, context);
                      },
                      child: MeetingDataCard(
                        itemIcon: AppImages.meetingHistoryScreenshot,
                        itemName: "Screen Capture",
                        itemCount: libraryProvider.screenShotCount,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      }),
    );
  }
}

class MeetingDataCard extends StatelessWidget {
  const MeetingDataCard({
    super.key,
    this.itemName,
    this.itemCount,
    this.itemIcon,
  });

  final String? itemName;
  final String? itemCount;
  final String? itemIcon;

  @override
  Widget build(BuildContext context) {
    return Consumer<LibraryProvider>(
      builder: (context, provider, child) {
        return Padding(
          padding: EdgeInsets.symmetric(vertical: 1.h),
          child: Container(
            color: Theme.of(context).primaryColor,
            child: Padding(
              padding: EdgeInsets.all(4.sp),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      SvgPicture.asset(
                        itemIcon!,
                        height: 20.w,
                        width: 20.w,
                      ),
                      width20,
                      Text(itemName ?? "Test",
                          style: w400_14Poppins(
                            color: Theme.of(context).primaryColorLight,
                          )),
                    ],
                  ),
                  Container(
                    decoration: BoxDecoration(color: Theme.of(context).cardColor, shape: BoxShape.circle),
                    child: Center(
                        child: Padding(
                      padding: EdgeInsets.all(8.sp),
                      child: Text(
                        itemCount ?? "0",
                        style: w400_12Poppins(color: Theme.of(context).indicatorColor),
                      ),
                    )),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
