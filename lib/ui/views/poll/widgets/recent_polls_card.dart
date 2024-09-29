import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:o_connect/core/common_functions.dart';
import 'package:o_connect/ui/utils/colors/colors.dart';
import 'package:o_connect/ui/utils/custom_show_dialog_helper/custom_show_dialog.dart';
import 'package:o_connect/ui/utils/textfield_helper/app_fonts.dart';
import 'package:o_connect/ui/views/poll/create_poll.dart';
import 'package:o_connect/ui/views/poll/provider/poll_provider.dart';
import 'package:o_connect/ui/views/themes/providers/webinar_themes_provider.dart';
import 'package:provider/provider.dart';

import '../../../utils/images/images.dart';
import 'delete_confirmation_pop_up.dart';

class RecentPollsCard extends StatelessWidget {
  final Color? cardColor;
  final int index;

  const RecentPollsCard({super.key, this.cardColor, required this.index});

  @override
  Widget build(BuildContext context) {
    return Consumer2<PollProvider, WebinarThemesProviders>(builder: (context, pollProvider, webinarThemesProviders, child) {
      return Padding(
        padding: EdgeInsets.only(left: 8.w, right: 7.w, top: 1.h, bottom: 1.h),
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 8.w),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  GestureDetector(
                    onTap: () {
                      pollProvider.startPollGlobalSet(pollProvider.searchedRecentPollsList[index]);
                    },
                    child: SvgPicture.asset("assets/new_ui_icons/poll/poll_file.svg"),
                  ),
                  width20,
                  Padding(
                    padding: const EdgeInsets.only(bottom: 5.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: EdgeInsets.only(top: 8.h),
                          child: Text(
                            pollProvider.searchedRecentPollsList[index].surveyName ?? "Previous Survey - 12",
                            style: w400_15Poppins(color: Colors.white),
                          ),
                        ),
                        height10,
                        Row(
                          children: [
                            Text(
                              "${pollProvider.searchedRecentPollsList[index].questions?.length ?? 0}",
                              style: w400_12Poppins(color: webinarThemesProviders.hintTextColor),
                            ),
                            width5,
                            Text(
                              "${pollProvider.searchedRecentPollsList[index].createdOn?.toString().toCustomDateFormat("MMM dd, yyyy hh:mm a") ?? "May 7 2022,12.30PM"} ",
                              style: w400_12Poppins(color: webinarThemesProviders.hintTextColor),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              Row(
                children: [
                  GestureDetector(
                    onTap: () {
                      pollProvider.createDuplicatePollSurveyQuestionFile(pollProvider.searchedRecentPollsList[index].id ?? "");
                    },
                    child: SvgPicture.asset(
                      AppImages.pollCopyIcon,
                    ),
                  ),
                  width5,
                  GestureDetector(
                    onTap: () {
                      Navigator.pop(context);
                      customShowDialog(
                          color: Theme.of(context).cardColor,
                          context,
                          CreatePollScreen(
                            index: index,
                            isEdit: true,
                          ),
                          height: MediaQuery.of(context).size.height * 0.7);
                    },
                    child: SvgPicture.asset(
                      AppImages.edit,
                    ),
                  ),
                  width5,
                  GestureDetector(
                    onTap: () {
                      customShowDialog(context, DeleteConfirmationPopUp(
                        onTap: () {
                          Navigator.pop(context);
                          pollProvider.deleteRecentPollRecode(pollProvider.searchedRecentPollsList[index].id ?? "", pollProvider.searchedRecentPollsList[index].fromUserId);
                        },
                      ));
                    },
                    child: SvgPicture.asset(
                      AppImages.delete,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      );
    });
  }
}
