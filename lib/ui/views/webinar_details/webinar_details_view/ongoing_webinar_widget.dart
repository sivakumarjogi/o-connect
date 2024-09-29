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

class OngoingWebinarWidget extends StatefulWidget {
  OngoingWebinarWidget({super.key});

  @override
  State<OngoingWebinarWidget> createState() => _OngoingWebinarWidgetState();
}

class _OngoingWebinarWidgetState extends State<OngoingWebinarWidget> {
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
                              decoration: BoxDecoration(borderRadius: BorderRadius.circular(6), color: Color(0xff143227)),
                              child: Padding(
                                padding: const EdgeInsets.all(6.0),
                                child: Text(
                                  "ONGOING",
                                  style: w500_10Poppins(color: Colors.green),
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
                            InkWell(
                              onTap: () {},
                              child: Container(
                                // width: 80.w,
                                height: 40.h,
                                decoration: BoxDecoration(borderRadius: BorderRadius.circular(3), color: Colors.blue),
                                child: Center(
                                  child: Text(
                                    "Join",
                                    style: w400_14Poppins(color: Colors.white),
                                  ),
                                ),
                              ),
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
