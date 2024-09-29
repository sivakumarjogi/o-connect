import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:o_connect/ui/utils/custom_dotted_divider.dart';
import 'package:o_connect/ui/utils/custom_show_dialog_helper/custom_show_dialog.dart';
import 'package:o_connect/ui/utils/images/images.dart';
import 'package:oes_chatbot/utils/extensions/sizedbox_extension.dart';

import '../../../utils/textfield_helper/app_fonts.dart';

class RecurringWebinarWidget extends StatefulWidget {
  RecurringWebinarWidget({super.key});
  @override
  State<RecurringWebinarWidget> createState() => _RecurringWebinarWidgetState();
}

class _RecurringWebinarWidgetState extends State<RecurringWebinarWidget> {
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Expanded(
          child: ListView.builder(
              shrinkWrap: true,
              itemCount: 4,
              physics: BouncingScrollPhysics(),
              itemBuilder: (context, i) {
                return Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Container(
                    decoration: BoxDecoration(borderRadius: BorderRadius.circular(6), color: Theme.of(context).cardColor),
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          5.h.height,
                          Container(
                            decoration: BoxDecoration(borderRadius: BorderRadius.circular(6), color: Color(0xff2B243C)),
                            child: Padding(
                              padding: const EdgeInsets.all(6.0),
                              child: Text(
                                "RECURRING",
                                style: w500_10Poppins(color: Colors.purple),
                              ),
                            ),
                          ),
                          5.h.height,
                          Text(
                            "Help a local business reinvent itself",
                            style: w500_14Poppins(color: Theme.of(context).hintColor),
                          ),
                          5.h.height,
                          Text(
                            "#765568",
                            style: w400_13Poppins(color: Theme.of(context).primaryColorLight),
                          ),
                          5.h.height,
                          Row(
                            children: [
                              SvgPicture.asset(AppImages.profileIcon),
                              10.w.width,
                              Text(
                                "John Robert",
                                style: w400_13Poppins(color: Theme.of(context).primaryColorLight),
                              )
                            ],
                          ),
                          5.h.height,
                          Row(
                            children: [
                              SvgPicture.asset(AppImages.calendarEvent),
                              10.w.width,
                              Text(
                                "14 Feb 2024   12:30 - 14:30",
                                style: w400_13Poppins(color: Theme.of(context).primaryColorLight),
                              )
                            ],
                          ),
                          5.h.height,
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Flexible(
                                flex: 1,
                                child: InkWell(
                                  onTap: () {
                                    customShowDialog(
                                      context,
                                      viewDetailsWidget(),
                                      isDismissible: false,
                                      backGroundColor: Theme.of(context).scaffoldBackgroundColor,
                                    );
                                  },
                                  child: Container(
                                    // width: 80.w,
                                    height: 40.h,
                                    decoration: BoxDecoration(borderRadius: BorderRadius.circular(3), color: Color(0xff1B2632)),
                                    child: Center(
                                      child: Text(
                                        "Details",
                                        style: w400_14Poppins(color: Colors.white),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                              SizedBox(
                                width: 10.w,
                              ),
                              Flexible(
                                flex: 1,
                                child: InkWell(
                                  onTap: () {},
                                  child: Container(
                                      // width: 100.w,
                                      height: 40.h,
                                      decoration: BoxDecoration(borderRadius: BorderRadius.circular(3), color: Colors.blue),
                                      child: Center(
                                        child: Text(
                                          "Join",
                                          style: w400_14Poppins(color: Colors.white),
                                        ),
                                      )),
                                ),
                              )
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              }),
        )
      ],
    );
  }

  viewDetailsWidget() {
    return Padding(
      padding: const EdgeInsets.all(10.0),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Align(
            alignment: Alignment.center,
            child: Container(
              height: 5.h,
              width: 100.w,
              decoration: BoxDecoration(borderRadius: BorderRadius.circular(20.r), color: Color(0xff202223)),
            ),
          ),
          25.h.height,
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "Details",
                style: w500_14Poppins(color: Colors.white),
              ),
              Row(
                children: [
                  Icon(
                    Icons.edit,
                    color: Theme.of(context).primaryColorLight,
                  ),
                  10.w.width,
                  GestureDetector(
                    onTap: () {
                      Navigator.pop(context);
                    },
                    child: Container(
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: Theme.of(context).primaryColorLight,
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(4.0),
                        child: Icon(
                          Icons.close,
                          size: 18,
                          color: Theme.of(context).scaffoldBackgroundColor,
                        ),
                      ),
                    ),
                  )
                ],
              ),
            ],
          ),
          Divider(),
          10.h.height,
          Container(
            decoration: BoxDecoration(borderRadius: BorderRadius.circular(6), color: Color(0xff2B243C)),
            child: Padding(
              padding: const EdgeInsets.all(6.0),
              child: Text(
                "RECURRING",
                style: w500_10Poppins(color: Colors.purple),
              ),
            ),
          ),
          5.h.height,
          Text(
            "Help a local business reinvent itself",
            style: w500_14Poppins(color: Theme.of(context).hintColor),
          ),
          5.h.height,
          Text(
            "#765568",
            style: w400_13Poppins(color: Theme.of(context).primaryColorLight),
          ),
          15.h.height,
          Text(
            "Host",
            style: w400_13Poppins(color: Theme.of(context).primaryColorLight),
          ),
          5.h.height,
          Text(
            "Cameron",
            style: w500_14Poppins(color: Theme.of(context).hintColor),
          ),
          15.h.height,
          Text(
            "Start Date & Time",
            style: w400_13Poppins(color: Theme.of(context).primaryColorLight),
          ),
          5.h.height,
          Text(
            " 14 Feb 2024 12:20pm",
            style: w500_14Poppins(color: Theme.of(context).hintColor),
          ),
          15.h.height,
          Text(
            "Recurring Type",
            style: w400_13Poppins(color: Theme.of(context).primaryColorLight),
          ),
          5.h.height,
          Text(
            "Monthly",
            style: w400_13Poppins(color: Theme.of(context).hintColor),
          ),
          15.h.height,
          Text(
            "End Date ",
            style: w400_13Poppins(color: Theme.of(context).primaryColorLight),
          ),
          5.h.height,
          Text(
            " 14 Dec 2024 ",
            style: w500_14Poppins(color: Theme.of(context).hintColor),
          ),
          10.h.height,
          10.h.height,
          CustomDottedDivider(),
          10.h.height,
          Text(
            "Invite Link",
            style: w400_12Poppins(color: Theme.of(context).primaryColorLight),
          ),
          5.h.height,
          Container(
            decoration: BoxDecoration(borderRadius: BorderRadius.circular(4), color: Theme.of(context).cardColor),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: Text(
                    "Select the role",
                    style: w400_14Poppins(color: Colors.white),
                  ),
                ),
                Icon(Icons.chevron_right_rounded)
              ],
            ),
          ),
          10.h.height,
          Text(
            "Passcode",
            style: w400_12Poppins(color: Theme.of(context).primaryColorLight),
          ),
          5.h.height,
          Container(
            decoration: BoxDecoration(borderRadius: BorderRadius.circular(4), color: Theme.of(context).cardColor),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: Text(
                    "444444",
                    style: w400_14Poppins(color: Colors.white),
                  ),
                ),
                Icon(Icons.link)
              ],
            ),
          ),
          30.h.height,
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Flexible(
                flex: 1,
                child: InkWell(
                  onTap: () {},
                  child: Container(
                    // width: 80.w,
                    height: 40.h,
                    decoration: BoxDecoration(borderRadius: BorderRadius.circular(3), color: Color(0xff1B2632)),
                    child: Center(
                      child: Text(
                        "Transfer",
                        style: w400_14Poppins(color: Colors.white),
                      ),
                    ),
                  ),
                ),
              ),
              SizedBox(
                width: 10.w,
              ),
              Flexible(
                flex: 1,
                child: InkWell(
                  onTap: () {},
                  child: Container(
                      // width: 100.w,
                      height: 40.h,
                      decoration: BoxDecoration(borderRadius: BorderRadius.circular(3), color: Colors.blue),
                      child: Center(
                        child: Text(
                          "Save as",
                          style: w400_14Poppins(color: Colors.white),
                        ),
                      )),
                ),
              )
            ],
          ),
        ],
      ),
    );
  }
}
