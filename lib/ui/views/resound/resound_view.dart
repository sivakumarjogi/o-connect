import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:lottie/lottie.dart';
import 'package:o_connect/core/providers/common_provider.dart';
import 'package:o_connect/core/providers/resound_provider.dart';
import 'package:o_connect/ui/utils/colors/colors.dart';
import 'package:o_connect/ui/utils/constant_strings.dart';
import 'package:o_connect/ui/utils/custom_show_dialog_helper/custom_show_dialog.dart';
import 'package:o_connect/ui/utils/images/images.dart';
import 'package:o_connect/ui/views/themes/providers/webinar_themes_provider.dart';
import 'package:provider/provider.dart';
import '../../utils/close_widget.dart';
import '../../utils/textfield_helper/app_fonts.dart';

class Resound extends StatefulWidget {
  const Resound({super.key});

  @override
  State<Resound> createState() => _ResoundState();
}

class _ResoundState extends State<Resound> {
  late CommonProvider commonProvider;
  late ResoundProvider resoundProvider;

  @override
  void initState() {
    commonProvider = Provider.of<CommonProvider>(context, listen: false);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return
      // PopScope(
      //   canPop: true,
      //   onPopInvoked: (didPop) {
      //     resoundProvider.setResoundWindowIsClosed();
      //     commonProvider.player.stop();
      //     Navigator.pop(context);
      //   },
      //   child:
            Consumer3<WebinarThemesProviders, CommonProvider, ResoundProvider>(
                builder: (context, webinarThemesProvider, commonProvider,
                    resoundProvider, child) {
          return Container(
              decoration: BoxDecoration(
                  border: Border.all(
                      color: webinarThemesProvider.colors.headerColor,
                      width: 4.w),
                  color: webinarThemesProvider.bgColor,
                  borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(25.r),
                      topRight: Radius.circular(25.r))),
              width: MediaQuery.of(context).size.width,
              child: commonProvider.getAllSoundsList != null
                  ? Container(
                      decoration: BoxDecoration(
                          color: webinarThemesProvider.colors.bodyColor ??
                              Theme.of(context).scaffoldBackgroundColor,
                          borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(25.r),
                              topRight: Radius.circular(25.r))),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Container(
                            decoration: BoxDecoration(
                              // color: headerColor ?? webinarThemesProviders.colors.headerColor,
                                borderRadius: BorderRadius.only(
                                  topRight: Radius.circular(20.r),
                                  topLeft: Radius.circular(20.r),
                                )),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                height20,
                                Align(
                                  alignment: Alignment.center,
                                  child: Container(
                                    height: 5.h,
                                    width: 100.w,
                                    decoration: BoxDecoration(borderRadius: BorderRadius.circular(20.r), color: const Color(0xff202223)),
                                  ),
                                ),
                                height10,
                                Padding(
                                  padding: EdgeInsets.all(8.0.sp),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(
                                        ConstantsStrings.resound,
                                        style: w500_14Poppins(color: Theme.of(context).hoverColor),
                                      ),
                                      Row(
                                        children: [
                                          // InkWell(
                                          //   onTap: () {
                                          //     bgmProvider.uploadmp3Files();
                                          //   },
                                          //   child: SvgPicture.asset(
                                          //     "assets/new_ui_icons/bgm/upload.svg",
                                          //     height: 25.w,
                                          //     width: 25.w,
                                          //     fit: BoxFit.fill,
                                          //   ),
                                          // ),
                                          width20,
                                          GestureDetector(
                                            onTap: () async{
                                              Navigator.pop(context);
                                            },
                                            child: Container(
                                              decoration: BoxDecoration(
                                                shape: BoxShape.circle,
                                                color: Theme.of(context).primaryColorLight,
                                              ),
                                              child: Padding(
                                                padding: EdgeInsets.all(4.0.sp),
                                                child: Icon(
                                                  Icons.close,
                                                  size: 16.sp,
                                                  color: Theme.of(context).scaffoldBackgroundColor,
                                                ),
                                              ),
                                            ),
                                          ),
                                        ],
                                      )
                                    ],
                                  ),
                                ),
                                const Divider(),
                              ],
                            ),
                          ),
                          // showDialogCustomHeader(context,
                          //     headerTitle: ConstantsStrings.resound,
                          //     backNavigationRequired: true),
                          Expanded(
                            child: Column(
                              children: [
                                height10,
                                SizedBox(
                                  height: 115.h,
                                  child: ListView.builder(
                                    itemCount:
                                        commonProvider.getAllSoundsList!.length,
                                    scrollDirection: Axis.horizontal,
                                    // shrinkWrap: true,
                                    itemBuilder: (context, idx) {
                                      return GestureDetector(
                                        onTap: () {
                                          commonProvider
                                              .updateResoundIndex(idx);
                                        },
                                        child: Padding(
                                          padding: EdgeInsets.all(8.0.sp),
                                          child: Container(
                                            decoration: BoxDecoration(
                                                color: commonProvider
                                                            .resoundIndex ==
                                                        idx
                                                    ? const Color(0xff0E78F9)
                                                        .withOpacity(0.3)
                                                    : webinarThemesProvider
                                                        .unSelectButtonsColor,
                                                borderRadius: BorderRadius.all(
                                                    Radius.circular(4.r))),
                                            height: 120.h,
                                            width: MediaQuery.of(context)
                                                    .size
                                                    .width /
                                                3,
                                            child: Column(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.center,
                                              children: [
                                                SvgPicture.asset(
                                                  "assets/new_ui_icons/resound/${commonProvider.getAllSoundsIconsList[idx].toString()}.svg",
                                                  height: 40.w,
                                                  width: 40.w,
                                                  fit: BoxFit.fill,
                                                ),
                                                height10,
                                                Text(
                                                  commonProvider
                                                      .getAllSoundsList![idx]
                                                      .category,
                                                  style: w400_14Poppins(
                                                      color: Theme.of(context)
                                                          .primaryColorLight),
                                                ),
                                                //0E78F9
                                              ],
                                            ),
                                          ),
                                        ),
                                      );
                                    },
                                  ),
                                ),
                                height10,
                                Expanded(
                                  child: ListView.builder(
                                    itemCount: commonProvider
                                        .getAllSoundsList![
                                            commonProvider.resoundIndex]
                                        .data
                                        .length,
                                    shrinkWrap: true,
                                    scrollDirection: Axis.vertical,
                                    itemBuilder: (context, index) {
                                      final soundUrl = commonProvider
                                          .getAllSoundsList![
                                              commonProvider.resoundIndex]
                                          .data[index]
                                          .url;

                                      return InkWell(
                                        onTap: () async {
                                          commonProvider.updateSelectedSound(
                                              commonProvider.getAllSoundsList![
                                                  commonProvider.resoundIndex],
                                              index);
                                          commonProvider.selectedSoundIndex ==
                                                  index
                                              ? commonProvider.player.play()
                                              : commonProvider.player.stop();

                                          var data2 = commonProvider
                                              .getAllSoundsList![
                                                  commonProvider.resoundIndex]
                                              .data[index];
                                          // commonProvider.publishAudio(data2.url);

                                          context
                                              .read<ResoundProvider>()
                                              .togglePlay(
                                                  data2.name, data2.url);
                                        },
                                        child: Padding(
                                          padding: EdgeInsets.symmetric(
                                              horizontal: 8.w, vertical: 3.h),
                                          child: Container(
                                            decoration: BoxDecoration(
                                                borderRadius:
                                                    BorderRadius.circular(8.r),
                                                color: resoundProvider
                                                            .currentSoundUrl !=
                                                        soundUrl
                                                    ? webinarThemesProvider
                                                        .unSelectButtonsColor
                                                        .withOpacity(0.2)
                                                    : Colors.blue),
                                            child: Padding(
                                              padding: EdgeInsets.all(10.sp),
                                              child: Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.start,
                                                children: [
                                                  SvgPicture.asset(resoundProvider
                                                              .currentSoundUrl !=
                                                          soundUrl
                                                      ? AppImages
                                                          .resoundPlayIcon
                                                      : AppImages
                                                          .resoundPauseIcon),
                                                  height10,
                                                  Padding(
                                                    padding: EdgeInsets.only(
                                                        top: 5.h, left: 10.w),
                                                    child: Text(
                                                      commonProvider
                                                          .getAllSoundsList![
                                                              commonProvider
                                                                  .resoundIndex]
                                                          .data[index]
                                                          .name,
                                                      style: w300_14Poppins(
                                                          color: Colors.white),
                                                    ),
                                                  ),
                                                  const Spacer(),
                                                  SvgPicture.asset(resoundProvider
                                                              .currentSoundUrl !=
                                                          soundUrl
                                                      ? "assets/new_ui_icons/resound/waves.svg"
                                                      : "assets/new_ui_icons/resound/waves_play.svg"),
                                                ],
                                              ),
                                            ),
                                          ),
                                        ),
                                      );
                                    },
                                  ),
                                ),
                              ],
                            ),
                          ),
                          // CloseWidget(
                          //   textColor: webinarThemesProvider.hintTextColor,
                          //   onTap: () {
                          //     resoundProvider.setResoundWindowIsClosed();
                          //     commonProvider.player.stop();
                          //     Navigator.pop(context);
                          //   },
                          // )
                          /*      Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        CustomButton(
                          width: 100.w,
                          borderColor: AppColors.mainBlueColor,
                          buttonColor: Colors.transparent,
                          onTap: () {
                            commonProvider.player.stop();
                            Navigator.pop(context);
                          },
                          buttonText: ConstantsStrings.cancel,
                          buttonTextStyle:
                              w600_16Poppins(color: AppColors.mainBlueColor),
                        ),
                        width20,
                        Padding(
                          padding: EdgeInsets.only(right: 20.w),
                          child: CustomButton(
                            width: 100.w,
                            buttonColor: AppColors.mainBlueColor,
                            onTap: () {
                              commonProvider.playerVisible("Resound", context);
                              commonProvider.updateSelectedSound(
                                  commonProvider.selectedSoundIndex);

                              Navigator.pop(context);
                            },
                            buttonText: ConstantsStrings.setBGM,
                            buttonTextStyle:
                                w600_16Poppins(color: AppColors.whiteColor),
                          ),
                        )
                      ],
                    )*/
                        ],
                      ),
                    )
                  : Center(
                      child: Lottie.asset(AppImages.loadingJson,
                          height: 40.w, width: 40.w)));
        }
        // )
    );
  }
}
