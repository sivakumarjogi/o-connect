import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:o_connect/core/models/library_model/library_meeting_history_model.dart';
import 'package:o_connect/core/providers/library_provider.dart';
import 'package:o_connect/ui/utils/colors/colors.dart';
import 'package:o_connect/ui/utils/images/images.dart';
import 'package:o_connect/ui/utils/textfield_helper/app_fonts.dart';
import 'package:provider/provider.dart';

class ArchiveOptionsScreen extends StatefulWidget {
  ArchiveOptionsScreen({super.key, required this.meetingData});

  var meetingData;

  @override
  State<ArchiveOptionsScreen> createState() => _ArchiveOptionsScreenState();
}

class _ArchiveOptionsScreenState extends State<ArchiveOptionsScreen> {
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
                        libraryProvider.getItemDetails("presentation", widget.meetingData!.id, context);
                      },
                      child: DataCard(
                        itemIcon: AppImages.presentationsIcon,
                        itemName: "Presentations",
                        itemCount: libraryProvider.presentationCount,
                      ),
                    ),
                    height15,
                    InkWell(
                      onTap: () {
                        libraryProvider.getItemDetails("webinar-video", widget.meetingData!.id, context);
                      },
                      child: DataCard(
                        itemIcon: AppImages.moreVideosIcon,
                        itemName: "Videos",
                        itemCount: libraryProvider.videosCount,
                      ),
                    ),
                    height15,
                    // InkWell(
                    //   onTap: () {
                    //     libraryProvider.getItemDetails("Chat", widget.meetingData!.id, context);
                    //   },
                    //   child: DataCard(
                    //     itemIcon: AppImages.whiteboardIcon,
                    //     itemName: "Whiteboard",
                    //     itemCount: libraryProvider.attachmentCount,
                    //   ),
                    // ),
                    // height15,
                    // InkWell(
                    //   onTap: () {
                    //     libraryProvider.getItemDetails("ScreenShot", widget.meetingData!.id, context);
                    //   },
                    //   child: DataCard(
                    //     itemIcon: AppImages.questionsIcon,
                    //     itemName: "Questions",
                    //     itemCount: libraryProvider.screenShotCount,
                    //   ),
                    // ),
                    // height15,
                    InkWell(
                      onTap: () {
                        libraryProvider.getItemDetails("Chat", widget.meetingData!.id, context);
                      },
                      child: DataCard(
                        itemIcon: AppImages.chatsIcon,
                        itemName: "Chat",
                        itemCount: libraryProvider.screenShotCount,
                      ),
                    ),
                    height15,
                    InkWell(
                      onTap: () {
                        libraryProvider.getItemDetails("ScreenShot", widget.meetingData!.id, context);
                      },
                      child: DataCard(
                        itemIcon: AppImages.screenCaptureIcon,
                        itemName: "Screen Capture",
                        itemCount: libraryProvider.screenShotCount,
                      ),
                    ),
                    height15,
                    InkWell(
                      onTap: () {
                        libraryProvider.getItemDetails("Recordings", widget.meetingData!.id, context);
                      },
                      child: DataCard(
                        itemIcon: AppImages.recordingsIcon,
                        itemName: "Recordings",
                        itemCount: libraryProvider.recordingCount,
                      ),
                    ),
                    height15,
                    // InkWell(
                    //   onTap: () {
                    //     libraryProvider.getItemDetails("ScreenShot", widget.meetingData!.id, context);
                    //   },
                    //   child: DataCard(
                    //     itemIcon: AppImages.backgroundMusicIcon,
                    //     itemName: "Background Music",
                    //     itemCount: libraryProvider.screenShotCount,
                    //   ),
                    // ),
                    // height15,
                    // InkWell(
                    //   onTap: () {
                    //     libraryProvider.getItemDetails("ScreenShot", widget.meetingData!.id, context);
                    //   },
                    //   child: DataCard(
                    //     itemIcon: AppImages.virtualImagesIcon,
                    //     itemName: "Virtual Images",
                    //     itemCount: libraryProvider.screenShotCount,
                    //   ),
                    // ),
                    // height15,
                    // InkWell(
                    //   onTap: () {
                    //     libraryProvider.getItemDetails("ScreenShot", widget.meetingData!.id, context);
                    //   },
                    //   child: DataCard(
                    //     itemIcon: AppImages.virtualImagesIcon,
                    //     itemName: "Call to Action",
                    //     itemCount: libraryProvider.screenShotCount,
                    //   ),
                    // ),
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

class DataCard extends StatelessWidget {
  const DataCard({
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
              decoration: BoxDecoration(borderRadius: BorderRadius.circular(10.r), color: Theme.of(context).cardColor),
              child: Padding(
                padding: EdgeInsets.all(12.0.sp),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(
                          width: 40.w,
                          child: SvgPicture.asset(
                            itemIcon!,
                            // color: Theme.of(context).primaryColorLight,
                          ),
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              itemName ?? "Test",
                              style: w500_16Poppins(color: Theme.of(context).hintColor),
                            ),
                            Text(
                              " ${itemCount}Files" ?? "0",
                              style: w400_12Poppins(color: Theme.of(context).primaryColorLight),
                            )
                          ],
                        ),
                      ],
                    ),
                    const Icon(Icons.arrow_forward_ios)
                  ],
                ),
              ),
            ));
      },
    );
  }
}
