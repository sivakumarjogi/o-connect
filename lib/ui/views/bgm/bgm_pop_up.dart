import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:lottie/lottie.dart';
import 'package:o_connect/core/screen_configs.dart';
import 'package:o_connect/ui/utils/buttons_helper/close_apply_buttons.dart';
import 'package:o_connect/ui/utils/buttons_helper/custom_botton.dart';
import 'package:o_connect/ui/utils/loading_helper/loading_indicator.dart';
import 'package:o_connect/ui/views/bgm/providers/bgm_provider.dart';
import 'package:o_connect/core/providers/common_provider.dart';
import 'package:o_connect/ui/utils/close_widget.dart';
import 'package:o_connect/ui/utils/constant_strings.dart';
import 'package:o_connect/ui/utils/custom_show_dialog_helper/custom_show_dialog.dart';
import 'package:o_connect/ui/utils/images/images.dart';
import 'package:o_connect/ui/utils/textfield_helper/app_fonts.dart';
import 'package:o_connect/ui/views/themes/providers/webinar_themes_provider.dart';
import 'package:provider/provider.dart';
import '../../utils/buttons_helper/custom_outline_button.dart';
import '../../utils/colors/colors.dart';

class BGMPopUp extends StatefulWidget {
  const BGMPopUp({Key? key}) : super(key: key);

  @override
  State<BGMPopUp> createState() => _BGMPopUpState();
}

class _BGMPopUpState extends State<BGMPopUp> {
  late BgmProvider bgmProvider;

  @override
  void initState() {
    // TODO: implement initState
    bgmProvider = Provider.of<BgmProvider>(context, listen: false);
    bgmProvider.getAllBGMs();
    bgmProvider.fetchBGMUploadedMp3Files();
    super.initState();
  }

  var sendBgmData;

  @override
  Widget build(BuildContext context) {
    return Consumer3<WebinarThemesProviders, BgmProvider, CommonProvider>(builder: (context, webinarThemesProviders, bgmProvider, commonProvider, child) {
      return Container(
        decoration: BoxDecoration(
            border: Border.all(color: webinarThemesProviders.colors.headerColor, width: 4.w),
            color: webinarThemesProviders.colors.bodyColor ?? Theme.of(context).scaffoldBackgroundColor,
            borderRadius: BorderRadius.only(topLeft: Radius.circular(25.r), topRight: Radius.circular(25.r))),
        height: MediaQuery.of(context).size.height * 0.71,
        child: Column(
          mainAxisSize: MainAxisSize.min,
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
                          ConstantsStrings.bgm,
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
                              onTap: () async {
                                print("zfkjhkjhfksahfsaff");
                                // await bgmProvider.localPlayer.pause();
                                await bgmProvider.localPlayer.stop();
                                bgmProvider.currentBgmUrl = null;
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
            // showDialogCustomHeader(context, headerTitle: ConstantsStrings.bgm),
            Expanded(
              // height: 440.h,
              child: bgmProvider.isBgmLoading
                  ? Center(child: Lottie.asset(AppImages.loadingJson, height: 40.w, width: 40.w))
                  : Column(
                      children: [
                        SizedBox(
                            height: 120.h,
                            child: _BgmCategories(
                              bgmProvider: bgmProvider,
                              webinarThemesProviders: webinarThemesProviders,
                              commonProvider: commonProvider,
                            )),
                        if (bgmProvider.bgmIndex < bgmProvider.getAllBgmListData.length && bgmProvider.getAllBgmListData[bgmProvider.bgmIndex].data.isNotEmpty)
                          Expanded(
                            // height: 320.h,
                            child: ListView.builder(
                                itemCount: bgmProvider.getAllBgmListData[bgmProvider.bgmIndex].data.length,
                                shrinkWrap: true,
                                itemBuilder: (context, index) {
                                  return ListView.builder(
                                    physics: const NeverScrollableScrollPhysics(),
                                    itemCount: bgmProvider.getAllBgmListData[bgmProvider.bgmIndex].data[index].data.length,
                                    shrinkWrap: true,
                                    scrollDirection: Axis.vertical,
                                    itemBuilder: (context, i) {
                                      var bgmData = bgmProvider.getAllBgmListData[bgmProvider.bgmIndex].data[index].data[i];
                                      return Container(
                                        decoration: BoxDecoration(
                                          color: bgmProvider.currentBgmUrl == bgmData.url ? Colors.blue : webinarThemesProviders.colors.itemColor,
                                          borderRadius: BorderRadius.circular(5.r),
                                        ),
                                        margin: EdgeInsets.only(left: 8.w, right: 8.w, top: 8.h),
                                        child: Padding(
                                          padding: EdgeInsets.all(8.sp),
                                          child: Row(
                                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                                            children: [
                                              GestureDetector(
                                                  onTap: () {
                                                    sendBgmData = bgmProvider.getAllBgmListData[bgmProvider.bgmIndex].data[index].data[i];
                                                    // bgmProvider.updateSelectedBgmIndex(/* bgmProvider.getAllBgmListData[bgmProvider.bgmIndex], */ i);
                                                    // bgmProvider.selectedBGMIndex == i ? bgmProvider.player.play() : bgmProvider.player.stop();
                                                    bgmProvider.publishAudio(urlTrack: bgmProvider.getAllBgmListData[bgmProvider.bgmIndex].data[index].data[i].url);
                                                    setState(() {});
                                                  },
                                                  child: Container(
                                                    decoration: BoxDecoration(
                                                        color: webinarThemesProviders.colors.headerColor,
                                                        borderRadius: BorderRadius.circular(5.r),
                                                        border: Border.all(
                                                            color: /*webinarThemesProviders.selectedWebinarTheme != null ? webinarThemesProviders.themeHighLighter! : Colors.blue*/
                                                                webinarThemesProviders.colors.bodyColor)),
                                                    child: Icon(
                                                      bgmProvider.currentBgmUrl == bgmData.url ? Icons.pause : Icons.play_arrow,
                                                      color: webinarThemesProviders
                                                          .colors.buttonColor, //webinarThemesProviders.selectedWebinarTheme != null ? webinarThemesProviders.themeHighLighter : Colors.white,
                                                    ),
                                                  )),
                                              width10,
                                              SizedBox(
                                                width: MediaQuery.of(context).size.width / 3,
                                                child: Text(
                                                  maxLines: 1,
                                                  bgmProvider.getAllBgmListData[bgmProvider.bgmIndex].data[index].data[i].name,
                                                  style: w400_15Poppins(color: Theme.of(context).primaryColorLight),
                                                  overflow: TextOverflow.ellipsis,
                                                ),
                                              ),
                                              Padding(
                                                padding: EdgeInsets.only(right: 8.w),
                                                child:
                                                    SvgPicture.asset(bgmProvider.currentBgmUrl != bgmData.url ? "assets/new_ui_icons/resound/waves.svg" : "assets/new_ui_icons/resound/waves_play.svg"),
                                              ),
                                            ],
                                          ),
                                        ),
                                      );
                                    },
                                  );
                                }),
                          )
                        else
                          Expanded(
                            child: bgmProvider.uploadedMp3Files.isEmpty
                                ? const Center(child: Text('No custom data found'))
                                : ListView.builder(
                                    physics: const NeverScrollableScrollPhysics(),
                                    itemCount: bgmProvider.uploadedMp3Files.length,
                                    shrinkWrap: true,
                                    scrollDirection: Axis.vertical,
                                    itemBuilder: (context, fileIndex) {
                                      return Container(
                                        margin: EdgeInsets.only(left: 8.w, right: 8.w, top: 8.h),
                                        decoration: BoxDecoration(
                                            color: bgmProvider.selectedBGMIndex == fileIndex ? Colors.blue : webinarThemesProviders.colors.itemColor,
                                            borderRadius: BorderRadius.circular(2.r),
                                            border: Border.all(
                                              color: bgmProvider.selectedBGMIndex == fileIndex ? Colors.blue : webinarThemesProviders.colors.itemColor,
                                            )),
                                        child: Padding(
                                          padding: EdgeInsets.all(8.sp),
                                          child: Row(
                                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                            children: [
                                              GestureDetector(
                                                  onTap: () {
                                                    // bgmProvider.updateSelectedBgmIndex(/* bgmProvider.getAllBgmListData[bgmProvider.bgmIndex], */ fileIndex);
                                                    // bgmProvider.selectedBGMIndex == fileIndex ? bgmProvider.player.play() : bgmProvider.player.stop();
                                                    bgmProvider.publishAudio(urlTrack: bgmProvider.uploadedMp3Files[fileIndex].url.toString(), isPlaying: bgmProvider.selectedBGMIndex == fileIndex);
                                                  },
                                                  child: Container(
                                                    decoration: BoxDecoration(
                                                        color: webinarThemesProviders.colors.headerColor,
                                                        borderRadius: BorderRadius.circular(2.r),
                                                        border: Border.all(
                                                          color: webinarThemesProviders.colors.headerColor,
                                                        )),
                                                    child: Icon(
                                                      bgmProvider.currentBgmUrl == bgmProvider.uploadedMp3Files[fileIndex].url ? Icons.pause : Icons.play_arrow,
                                                      color: webinarThemesProviders
                                                          .colors.buttonColor, //webinarThemesProviders.selectedWebinarTheme != null ? webinarThemesProviders.themeHighLighter : Colors.white,
                                                    ),
                                                  )),
                                              width10,
                                              Expanded(
                                                  child: Text(
                                                bgmProvider.uploadedMp3Files[fileIndex].fileName ?? "N/A",
                                                overflow: TextOverflow.ellipsis,
                                                style: w400_15Poppins(color: Theme.of(context).primaryColorLight),
                                              )),
                                              InkWell(
                                                onTap: () {
                                                  bgmProvider.deleteUploadedMp3File(bgmProvider.uploadedMp3Files[fileIndex].id.toString());
                                                },
                                                child: Padding(
                                                    padding: EdgeInsets.symmetric(horizontal: 10.sp),
                                                    child: SvgPicture.asset(
                                                      "assets/new_ui_icons/chat_icons/delete.svg",
                                                      color: webinarThemesProviders.hintTextColor,
                                                      height: 18.w,
                                                      width: 18.w,
                                                    )),
                                              ),
                                            ],
                                          ),
                                        ),
                                      );
                                    },
                                  ),
                          ),
                        /* const Text("No Data"), */
                        Padding(
                          padding: EdgeInsets.only(right: 8.w),
                          child: CustomOutlinedButton(
                            outLineBorderColor: Colors.blue,
                            height: 35.h,
                            width: ScreenConfig.width * 4,
                            color: Colors.blue,
                            buttonTextStyle: w500_13Poppins(color: Colors.white),
                            buttonText: ConstantsStrings.apply,
                            onTap: () {
                              // bgmProvider.updateSelectedBgmIndex(/* bgmProvider.getAllBgmListData[bgmProvider.bgmIndex], */ i);
                              bgmProvider.applyBackgroundMusic(name: sendBgmData.name, url: sendBgmData.url);
                              Navigator.of(context).pop();
                              // bgmProvider.publishAudio(bgmData.url);
                            },
                          ),
                        ),
                      ],
                    ),
            ),

            // !bgmProvider.customFileUploadLoading
            //     ? Padding(
            //         padding: EdgeInsets.only(right: 10.w, bottom: 10.h),
            //         child: Row(
            //           mainAxisAlignment: MainAxisAlignment.end,
            //           children: [
            //             CustomOutlinedButton(
            //               outLineBorderColor: Provider.of<WebinarThemesProviders>(context).colors.buttonColor,
            //               height: 35.h,
            //               width: 200,
            //               buttonTextStyle: w400_13Poppins(color: Provider.of<WebinarThemesProviders>(context).colors.buttonColor),
            //               buttonText: ConstantsStrings.cancel,
            //               onTap: () {
            //                 Navigator.pop(context);
            //               },
            //             ),
            //             // width10,
            //             // CustomButton(
            //             //   width: 80.w,
            //             //   height: 35.h,
            //             //   buttonText: "Upload",
            //             //   buttonColor: context.watch<WebinarThemesProviders>().colors.buttonColor ?? AppColors.mainBlueColor,
            //             //   buttonTextStyle: w500_13Poppins(color: AppColors.whiteColor),
            //             //   onTap: () {
            //             //     bgmProvider.uploadmp3Files();
            //             //   },
            //             // )
            //           ],
            //         ),
            //       )
            //     : const CustomLoadingIndicator(),
          ],
        ),
      );
    });
  }
}

class _BgmCategories extends StatelessWidget {
  const _BgmCategories({
    required this.commonProvider,
    required this.bgmProvider,
    required this.webinarThemesProviders,
  });

  final CommonProvider commonProvider;
  final BgmProvider bgmProvider;
  final WebinarThemesProviders webinarThemesProviders;

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
        itemCount: bgmProvider.getAllBgmListData.length + 1,
        scrollDirection: Axis.horizontal,
        shrinkWrap: true,
        itemBuilder: (context, idx) => idx != bgmProvider.getAllBgmListData.length
            ? GestureDetector(
                onTap: () {
                  bgmProvider.updateBGmIndex(idx);
                  // bgmProvider.getAllBGMs();
                },
                child: Container(
                  padding: EdgeInsets.all(8.0.sp),
                  margin: EdgeInsets.all(8.sp),
                  height: 100.w,
                  width: 120.w,
                  decoration:
                      BoxDecoration(color: idx == bgmProvider.bgmIndex ? webinarThemesProviders.selectButtonsColor : webinarThemesProviders.colors.itemColor, borderRadius: BorderRadius.circular(5.r)),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      SvgPicture.asset(
                        "assets/new_ui_icons/bgm/${commonProvider.getAllBgmIconsList[idx].toString()}.svg",
                        height: 40.w,
                        width: 40.w,
                        fit: BoxFit.fill,
                      ),
                      height5,
                      Text(
                        bgmProvider.getAllBgmListData[idx].category,
                        style: w400_12Poppins(color: Colors.white),
                      )
                    ],
                  ),
                ),
              )
            : GestureDetector(
                onTap: () {
                  bgmProvider.updateBGmIndex(idx);
                  // bgmProvider.getAllBGMs();
                },
                child: Container(
                  padding: EdgeInsets.all(8.0.sp),
                  margin: EdgeInsets.all(8.sp),
                  height: 100.w,
                  width: 120.w,
                  decoration:
                      BoxDecoration(color: idx == bgmProvider.bgmIndex ? webinarThemesProviders.selectButtonsColor : webinarThemesProviders.colors.itemColor, borderRadius: BorderRadius.circular(5.r)),
                  child: Column(
                    children: [
                      Image.asset(
                        AppImages.bgmicon,
                        height: 65.h,
                        width: 68.w,
                        fit: BoxFit.fill,
                      ),
                      height5,
                      Expanded(
                        child: Text(
                          "Custom",
                          style: w400_12Poppins(color: Colors.white),
                        ),
                      )
                    ],
                  ),
                ),
              ));
  }
}
