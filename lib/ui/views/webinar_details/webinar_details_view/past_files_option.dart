import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:o_connect/core/models/library_model/library_meeting_history_model.dart';
import 'package:o_connect/core/providers/library_provider.dart';
import 'package:o_connect/ui/utils/colors/colors.dart';
import 'package:o_connect/ui/utils/images/images.dart';
import 'package:o_connect/ui/utils/textfield_helper/app_fonts.dart';
import 'package:o_connect/ui/views/webinar_details/webinar_details_view/past_recording_files.dart';
import 'package:oes_chatbot/utils/extensions/sizedbox_extension.dart';
import 'package:provider/provider.dart';

class PastFilesOptionsScreen extends StatefulWidget {
  PastFilesOptionsScreen({
    super.key,
  });

  @override
  State<PastFilesOptionsScreen> createState() => _PastFilesOptionsScreenState();
}

class _PastFilesOptionsScreenState extends State<PastFilesOptionsScreen> {
  LibraryProvider? libraryProvider;

  @override
  void initState() {
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
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => RecordingPastFilesPopup(
                                      popUpName: "Recordings ",
                                    )));
                      },
                      child: DataCard(
                        itemIcon: AppImages.recordingsIcon,
                        itemName: "Recordings",
                        itemCount: "1",
                      ),
                    ),
                    height5,

                    InkWell(
                      onTap: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => RecordingPastFilesPopup(
                                      popUpName: "Presentations",
                                    )));
                      },
                      child: DataCard(
                        itemIcon: AppImages.presentationsIcon,
                        itemName: "Presentations",
                        itemCount: "1",
                      ),
                    ),
                    height5,

                    InkWell(
                      onTap: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => RecordingPastFilesPopup(
                                      popUpName: "Videos",
                                    )));
                      },
                      child: DataCard(
                        itemIcon: AppImages.videosIcon,
                        itemName: "Videos",
                        itemCount: "1",
                      ),
                    ),
                    height5,
                    //     InkWell(
                    //       onTap: () {
                    // Navigator.push(context, MaterialPageRoute(builder: (context)=> RecordingPastFilesPopup(popUpName: "Whiteboard",)));

                    //       },
                    //       child: DataCard(
                    //         itemIcon: AppImages.whiteboardIcon,
                    //         itemName: "Whiteboard",
                    //                              itemCount: "1",

                    //       ),
                    //     ),
                    //     height5,
                    //     InkWell(
                    //       onTap: () {
                    // Navigator.push(context, MaterialPageRoute(builder: (context)=> RecordingPastFilesPopup(popUpName: "Questions",)));

                    //       },
                    //       child: DataCard(
                    //         itemIcon: AppImages.questionsIcon,
                    //         itemName: "Questions",
                    //                                itemCount: "1",

                    //       ),
                    //     ),
                    height5,
                    InkWell(
                      onTap: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => RecordingPastFilesPopup(
                                      popUpName: "Chat",
                                    )));
                      },
                      child: DataCard(
                        itemIcon: AppImages.chatsIcon,
                        itemName: "Chat",
                        itemCount: "1",
                      ),
                    ),
                    height5,
                    InkWell(
                      onTap: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => RecordingPastFilesPopup(
                                      popUpName: "Screen Capture",
                                    )));
                      },
                      child: DataCard(
                        itemIcon: AppImages.screenCaptureIcon,
                        itemName: "Screen Capture",
                        itemCount: "1",
                      ),
                    ),
                    height5,

                    //     InkWell(
                    //       onTap: () {
                    // Navigator.push(context, MaterialPageRoute(builder: (context)=> RecordingPastFilesPopup(popUpName: "Background Music",)));

                    //       },
                    //       child: DataCard(
                    //         itemIcon: AppImages.backgroundMusicIcon,
                    //         itemName: "Background Music",
                    //                                 itemCount: "1",

                    //       ),
                    //     ),
                    //     height5,
                    //     InkWell(
                    //       onTap: () {
                    // Navigator.push(context, MaterialPageRoute(builder: (context)=> RecordingPastFilesPopup(popUpName: "Virtual Images",)));

                    //       },
                    //       child: DataCard(
                    //         itemIcon: AppImages.virtualImagesIcon,
                    //         itemName: "Virtual Images",
                    //                               itemCount: "1",

                    //       ),
                    //     ),
                    //     height5,
                    //     InkWell(
                    //       onTap: () {
                    // Navigator.push(context, MaterialPageRoute(builder: (context)=> RecordingPastFilesPopup(popUpName: "Call to Action",)));

                    //       },
                    //       child: DataCard(
                    //         itemIcon: AppImages.callToActionIcon
                    //         ,
                    //         itemName: "Call to Action",
                    //         itemCount: "1",
                    //       ),
                    //     ),
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
                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: 8.0),
                          child: SizedBox(
                            width: 40.w,
                            child: SvgPicture.asset(
                              itemIcon!,
                              // color: Theme.of(context).primaryColorLight,
                            ),
                          ),
                        ),
                        5.w.width,
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            height5,
                            Text(
                              itemName ?? "Test",
                              style: w500_16Poppins(color: Theme.of(context).hintColor),
                            ),
                            Text(
                              " ${itemCount} Files" ?? "0",
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
