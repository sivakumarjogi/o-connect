import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:o_connect/core/models/library_model/library_meeting_history_model.dart';
import 'package:o_connect/core/providers/library_provider.dart';
import 'package:o_connect/core/screen_configs.dart';
import 'package:o_connect/ui/utils/colors/colors.dart';
import 'package:o_connect/ui/utils/images/images.dart';
import 'package:o_connect/ui/utils/textfield_helper/app_fonts.dart';
import 'package:o_connect/ui/views/drawer/library/meeting_history/library_options_menu.dart';
import 'package:o_connect/ui/views/home_screen/home_screen_provider/home_screen_provider.dart';
import 'package:o_connect/ui/views/more/archive_options_screen.dart';
import 'package:o_connect/ui/views/webinar_details/webinar_details_view/past_files_option.dart';
import 'package:provider/provider.dart';

class PastWebinarsFilesScreen extends StatefulWidget {
  const PastWebinarsFilesScreen({super.key, required this.meetingId});

  final String meetingId;

  @override
  State<PastWebinarsFilesScreen> createState() => _PastWebinarsFilesScreenState();
}

class _PastWebinarsFilesScreenState extends State<PastWebinarsFilesScreen> {
  LibraryProvider? libraryProvider;
  @override
  void initState() {
    libraryProvider = Provider.of<LibraryProvider>(context, listen: false);

    SchedulerBinding.instance.addPostFrameCallback((_) {
      libraryProvider?.getCompletedItemDetails(context: context, meetingId: widget.meetingId);
    });

    super.initState();
  }



  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
                      "00",
                      style: w500_14Poppins(color: Theme.of(context).hintColor),
                    ),
                  ],
                ),
              ),
              height15,
              SizedBox(child: PastFilesOptionsScreen()),
            ],
          ),
        ),
      )),
    );
  }
}
