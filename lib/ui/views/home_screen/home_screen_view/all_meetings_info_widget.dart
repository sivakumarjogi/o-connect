import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:o_connect/ui/utils/custom_toast_helper/custom_toast.dart';
import 'package:o_connect/ui/views/home_screen/home_screen_provider/home_screen_provider.dart';
import 'package:provider/provider.dart';
import 'package:shimmer/shimmer.dart';

import '../../../utils/colors/colors.dart';
import '../../../utils/constant_strings.dart';
import '../../../utils/images/images.dart';
import '../../../utils/textfield_helper/app_fonts.dart';
import '../../drawer/drawer_viewmodel.dart';

class AllMeetingsInfo extends StatelessWidget {
  final String? cardName;
  final String? meetingCount;
  final String? meetingImage;
  final String? bgCards;

  const AllMeetingsInfo({
    super.key,
    required this.cardName,
    required this.meetingCount,
    required this.meetingImage,
    required this.bgCards,
  });

  @override
  Widget build(BuildContext context) {
    return Consumer<HomeScreenProvider>(
      builder: (context, homeScreenProvider, child) {
        return homeScreenProvider.getAllMeetingLoading
            ? Stack(
                children: [
                  SvgPicture.asset(AppImages.card2, fit: BoxFit.fill, width: MediaQuery.of(context).size.width),
                  Shimmer.fromColors(
                    baseColor: cardName == "Upcoming Webinars"
                        ? const Color(0xFF00D870)
                        : cardName == "Completed Webinars"
                            ? const Color(0xFFF67171)
                            : const Color(0xFF15DB9D),
                    highlightColor: Colors.white,
                    child: Padding(
                      padding: EdgeInsets.symmetric(
                        horizontal: 15.w,
                        vertical: 2.h,
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                "0",
                                style: cardName == "Recurring Webinars" ? w600_14Poppins() : w600_24Poppins(),
                              ),
                              Text("Webinar Details...", style: w400_12Poppins(color: Colors.white))
                            ],
                          ),
                          SvgPicture.asset(AppImages.recurring)
                        ],
                      ),
                    ),
                  ),
                ],
              )
            : InkWell(
                onTap: () {
                  if (cardName != "Recurring Webinars") {
                    Provider.of<DrawerViewModel>(context, listen: false).mainSelectedChange(ConstantsStrings.webinar);
                    homeScreenProvider.selectedNavigation(cardName, context);
                  } else {
                    CustomToast.showInfoToast(msg: "Coming soon...");
                  }
                },
                child: Stack(
                  children: [
                    SvgPicture.asset(bgCards!, fit: BoxFit.fill, width: MediaQuery.of(context).size.width),
                    Padding(
                      padding: EdgeInsets.symmetric(
                        horizontal: 15.w,
                        vertical: 5.h,
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Container(
                                height: 30.h,
                                alignment: Alignment.center,
                                child: Text(meetingCount.toString(),
                                    style: cardName == "Recurring Webinars"
                                        ? w600_12Poppins(color: const Color(0xFF15DB9D))
                                        : w600_20Poppins(color: cardName == "Upcoming Webinars" ? const Color(0xFF00D870) : const Color(0xFFF67171))),
                              ),
                              Text(cardName!, style: w400_12Poppins(color: Colors.white))
                            ],
                          ),
                          SvgPicture.asset(meetingImage!)
                        ],
                      ),
                    )
                  ],
                ),
              );
      },
    );
  }
}
