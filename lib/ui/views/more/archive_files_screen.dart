import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:o_connect/core/models/library_model/library_meeting_history_model.dart';
import 'package:o_connect/core/screen_configs.dart';
import 'package:o_connect/ui/utils/colors/colors.dart';
import 'package:o_connect/ui/utils/images/images.dart';
import 'package:o_connect/ui/utils/textfield_helper/app_fonts.dart';
import 'package:o_connect/ui/views/drawer/library/meeting_history/library_options_menu.dart';
import 'package:o_connect/ui/views/more/archive_options_screen.dart';

class ArchiveFilesScreen extends StatefulWidget {
  const ArchiveFilesScreen({super.key, required this.meetingData});
  final LibraryMeetingHistoryDatum meetingData;

  @override
  State<ArchiveFilesScreen> createState() => _ArchiveFilesScreenState();
}

class _ArchiveFilesScreenState extends State<ArchiveFilesScreen> {
  @override
  Widget build(BuildContext context) {
    var intiDate = widget.meetingData.meetingDate;
    var finDate = DateTime.now();

    String difference = "${finDate.difference(intiDate!).inDays}";
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: SafeArea(
          child: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(10.sp),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: ScreenConfig.width,
                decoration: BoxDecoration(borderRadius: BorderRadius.circular(8.r), color: Theme.of(context).cardColor),
                child: Row(
                  children: [
                    IconButton(
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        icon: Icon(
                          Icons.chevron_left_outlined,
                          color: Theme.of(context).primaryColorLight,
                        )),
                    Text(
                      "Files",
                      style: w400_14Poppins(color: Theme.of(context).hintColor.withOpacity(0.8)),
                    ),
                  ],
                ),
              ),
              height15,
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 8.w),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "Remaining Days ",
                      style: w500_14Poppins(color: Theme.of(context).hintColor),
                    ),
                    Text(
                      "${29 - int.parse(difference)} Days" ?? "00",
                      style: w500_14Poppins(color: Theme.of(context).hintColor),
                    ),
                  ],
                ),
              ),
              height15,
              SizedBox(child: ArchiveOptionsScreen(meetingData: widget.meetingData)),
            ],
          ),
        ),
      )),
    );
  }
}
