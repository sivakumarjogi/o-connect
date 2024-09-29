import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:lottie/lottie.dart';
import 'package:o_connect/core/screen_configs.dart';
import 'package:o_connect/ui/utils/images/images.dart';
import 'package:o_connect/ui/views/poll/provider/poll_provider.dart';
import 'package:o_connect/ui/utils/colors/colors.dart';
import 'package:o_connect/ui/utils/constant_strings.dart';
import 'package:o_connect/ui/utils/custom_show_dialog_helper/custom_show_dialog.dart';
import 'package:o_connect/ui/utils/textfield_helper/app_fonts.dart';
import 'package:o_connect/ui/utils/textfield_helper/common_textfield.dart';
import 'package:o_connect/ui/views/poll/create_poll.dart';
import 'package:o_connect/ui/views/poll/widgets/recent_polls_card.dart';
import 'package:o_connect/ui/views/themes/providers/webinar_themes_provider.dart';
import 'package:provider/provider.dart';
import '../../utils/buttons_helper/custom_botton.dart';
import '../../utils/buttons_helper/custom_outline_button.dart';

class PollScreen extends StatefulWidget {
  const PollScreen({super.key});

  @override
  State<PollScreen> createState() => _PollScreenState();
}

class _PollScreenState extends State<PollScreen> {
  final TextEditingController _searchController = TextEditingController();

  late PollProvider pollProvider;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    pollProvider = Provider.of<PollProvider>(context, listen: false);
    pollProvider.fetchAllPreviousPollQuestionFiles();
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer2<PollProvider, WebinarThemesProviders>(builder: (context, pollProviderData, webinarThemesProviders, child) {
      return Container(
          decoration: BoxDecoration(
              border: Border.all(
                color: webinarThemesProviders.colors.headerColor,
              ),
              color: webinarThemesProviders.colors.bodyColor,
              borderRadius: BorderRadius.only(topLeft: Radius.circular(24.r), topRight: Radius.circular(24.r))),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Expanded(
                child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                  showDialogCustomHeader(context, headerTitle: ConstantsStrings.poll),
                  height10,
                  Padding(
                    padding: EdgeInsets.only(left: 14.w, right: 14.w),
                    child: SizedBox(
                      height: 40.h,
                      child: CommonTextFormField(
                          fillColor: webinarThemesProviders.headerNotchColor,
                          controller: _searchController,
                          suffixIcon: Icon(
                            Icons.search,
                            size: 16.sp,
                            color: webinarThemesProviders.hintTextColor,
                          ),
                          onChanged: ((value) {
                            pollProvider.searchRecentPolls(value);
                          }),
                          hintText: ConstantsStrings.search,
                          hintStyle: w400_13Poppins(color: webinarThemesProviders.hintTextColor),
                          keyboardType: TextInputType.text,
                          inputAction: TextInputAction.done),
                    ),
                  ),
                  height15,
                  Padding(
                    padding: EdgeInsets.only(left: 20.w, bottom: 10.h),
                    child: Text(
                      ConstantsStrings.recentPolls,
                      style: w400_14Poppins(color: Theme.of(context).primaryColorLight),
                    ),
                  ),
                  !pollProvider.createPollLoading
                      ? pollProviderData.searchedRecentPollsList.isNotEmpty
                          ? Expanded(
                              child: ListView.builder(
                                  shrinkWrap: true,
                                  itemBuilder: (context, index) {
                                    return RecentPollsCard(
                                      cardColor: webinarThemesProviders.colors.cardColor,
                                      index: index,
                                    );
                                  },
                                  itemCount: pollProviderData.searchedRecentPollsList.length),
                            )
                          : SizedBox(height: ScreenConfig.height * 0.35, child: const Center(child: Text("No Recent Polls")))
                      : Align(
                          alignment: Alignment.center,
                          child: Column(
                            children: [
                              SizedBox(
                                height: ScreenConfig.height * 0.15,
                              ),
                              Lottie.asset(AppImages.loadingJson, width: 100.w, height: 100.w)
                            ],
                          ),
                        )
                ]),
              ),
              Align(
                alignment: Alignment.bottomCenter,
                child: Padding(
                  padding: EdgeInsets.all(10.sp),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      CustomOutlinedButton(
                        height: 35.h,
                        width: MediaQuery.of(context).size.width/2-30.sp,
                        outLineBorderColor: webinarThemesProviders.unSelectButtonsColor,
                        buttonTextStyle: w400_13Poppins(color: Colors.white),
                        buttonText: ConstantsStrings.cancel,
                        color: webinarThemesProviders.unSelectButtonsColor,
                        onTap: () {
                          Navigator.pop(context);
                        },
                      ),
                      width10,
                      CustomButton(
                        width: MediaQuery.of(context).size.width/2-30.sp,
                        height: 35.h,
                        buttonColor: webinarThemesProviders.colors.buttonColor,
                        buttonText: ConstantsStrings.createPoll,
                        buttonTextStyle: w500_13Poppins(color: AppColors.whiteColor),
                        onTap: () {
                          customShowDialog(color: Theme.of(context).cardColor, context, const CreatePollScreen(), height: MediaQuery.of(context).size.height * 0.7);
                        },
                      )
                    ],
                  ),
                ),
              ),
            ],
          ));
    });
  }
}


