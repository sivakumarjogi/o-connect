import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:o_connect/core/providers/library_provider.dart';
import 'package:o_connect/ui/utils/custom_show_dialog_helper/custom_show_dialog.dart';
import 'package:o_connect/ui/utils/images/images.dart';
import 'package:o_connect/ui/views/home_screen/home_screen_provider/home_screen_provider.dart';
import 'package:o_connect/ui/views/webinar_details/webinar_details_provider/webinar_details_provider.dart';
import 'package:oes_chatbot/utils/extensions/sizedbox_extension.dart';
import 'package:provider/provider.dart';

import '../../../utils/textfield_helper/app_fonts.dart';

class DeclinedWebinarWidget extends StatefulWidget {
  DeclinedWebinarWidget({super.key});

  @override
  State<DeclinedWebinarWidget> createState() => _DeclinedWebinarWidgetState();
}

class _DeclinedWebinarWidgetState extends State<DeclinedWebinarWidget> {
  LibraryProvider? provider;
  @override
  Widget build(BuildContext context) {
    return Consumer2<WebinarDetailsProvider, HomeScreenProvider>(builder: (context, provider, homeScreenProvider, child) {
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
                              decoration: BoxDecoration(borderRadius: BorderRadius.circular(6), color: Color(0xff3B1F20)),
                              child: Padding(
                                padding: const EdgeInsets.all(6.0),
                                child: Text(
                                  "DECLINED",
                                  style: w500_10Poppins(color: Colors.red),
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
                              "545444",
                              style: w500_14Poppins(color: Theme.of(context).primaryColorLight),
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
                                5.w.width,
                                SvgPicture.asset(
                                  AppImages.calendarIcon,
                                  color: Theme.of(context).primaryColorLight,
                                ),
                                10.w.width,
                                Text(
                                  "Webinar",
                                  style: w400_13Poppins(color: Theme.of(context).primaryColorLight),
                                )
                              ],
                            ),
                            10.h.height,
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Flexible(
                                  flex: 1,
                                  child: InkWell(
                                    onTap: () {
                                      showModalBottomSheet(
                                          isScrollControlled: true,
                                          isDismissible: false,
                                          backgroundColor: Theme.of(context).scaffoldBackgroundColor,
                                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.only(topRight: Radius.circular(24.r), topLeft: Radius.circular(24.r))),
                                          context: context,
                                          builder: (context) {
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
                                                      ),
                                                    ],
                                                  ),
                                                  Divider(),
                                                  10.h.height,
                                                  Container(
                                                    decoration: BoxDecoration(borderRadius: BorderRadius.circular(6), color: Color(0xff3B1F20)),
                                                    child: Padding(
                                                      padding: const EdgeInsets.all(6.0),
                                                      child: Text(
                                                        "DECLINED",
                                                        style: w500_10Poppins(color: Colors.red),
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
                                                    "Duration",
                                                    style: w400_13Poppins(color: Theme.of(context).primaryColorLight),
                                                  ),
                                                  5.h.height,
                                                  Text(
                                                    "2h 30m",
                                                    style: w400_13Poppins(color: Theme.of(context).hintColor),
                                                  ),
                                                  10.h.height,
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
                                                                "Delete",
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
                                          });
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
                                            "Delete",
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
    });
  }
}
