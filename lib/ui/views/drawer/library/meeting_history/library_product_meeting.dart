import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';
import 'package:o_connect/core/models/library_model/library_meeting_history_model.dart';
import '../../../../utils/colors/colors.dart';
import '../../../../utils/textfield_helper/app_fonts.dart';
import 'library_options_menu.dart';

class LibraryProductMeetingScreen extends StatefulWidget {
  const LibraryProductMeetingScreen({super.key, required this.meetingData});

  final LibraryMeetingHistoryDatum meetingData;

  @override
  State<LibraryProductMeetingScreen> createState() => _LibraryProductMeetingScreenState();
}

class _LibraryProductMeetingScreenState extends State<LibraryProductMeetingScreen> {
  @override
  Widget build(BuildContext context) {
    var intiDate = widget.meetingData.meetingDate;
    var finDate = DateTime.now();

    String difference = "${finDate.difference(intiDate!).inDays}";
    // print(difference);

    return Scaffold(
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Padding(
              padding: EdgeInsets.only(left: 10.w, right: 10.w, top: 10.h),
              child: Container(
                height: 40.h,
                alignment: Alignment.center,
                decoration: BoxDecoration(borderRadius: BorderRadius.circular(4.r), color: Theme.of(context).cardColor),
                child: Center(
                  child: Padding(
                    padding: EdgeInsets.only(left: 10.w),
                    child: Row(
                      children: [
                        GestureDetector(
                            onTap: () {
                              Navigator.pop(context);
                            },
                            child: Icon(
                              Icons.arrow_back_ios,
                              color: Theme.of(context).disabledColor,
                              size: 20,
                            )),
                        width20,
                        Text(
                          widget.meetingData.meetingName ?? "Test meeting",
                          textAlign: TextAlign.start,
                          style: w500_12Poppins(color: Theme.of(context).primaryColorLight),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
            height10,
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 10.w),
              child: Container(
                decoration: BoxDecoration(borderRadius: BorderRadius.circular(3.r), color: Theme.of(context).cardColor),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    height5,
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 10.w),
                      child: Text(
                        widget.meetingData.meetingName ?? "Test meeting",
                        style: w400_14Poppins(color: Theme.of(context).indicatorColor),
                      ),
                    ),
                    height5,
                    Padding(
                      padding: EdgeInsets.only(left: 10.w, right: 10.w, bottom: 3),
                      child: Text(
                        widget.meetingData.eventId ?? "000 000",
                        style: w300_12Poppins(color: Theme.of(context).primaryColorLight),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.only(left: 10.w, right: 10.w, bottom: 2),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            DateFormat("dd MMM, yyyy HH:mm").format(DateTime.parse(widget.meetingData.meetingDate.toString())),
                            style: w300_12Poppins(color: Theme.of(context).disabledColor),
                          ),
                          width15,
                          Text(
                            "Remaining Days: ${29 - int.parse(difference) ?? "00"}",
                            style: w300_12Poppins(color: Theme.of(context).disabledColor),
                          ),
                        ],
                      ),
                    ),
                    Divider(color: Theme.of(context).disabledColor),
                    SizedBox(child: LibraryOptions(meetingData: widget.meetingData)),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
