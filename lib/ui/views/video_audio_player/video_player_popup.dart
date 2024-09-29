import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:intl/intl.dart';
import 'package:lottie/lottie.dart';
import 'package:o_connect/core/screen_configs.dart';
import 'package:o_connect/ui/utils/colors/colors.dart';
import 'package:o_connect/ui/utils/constant_strings.dart';
import 'package:o_connect/ui/utils/custom_toast_helper/custom_toast.dart';
import 'package:o_connect/ui/views/chat_screen/providers/chat_provider.dart';
import 'package:o_connect/ui/views/meeting/providers/video_share_provider.dart';
import 'package:o_connect/ui/views/meeting/utils/string_extension.dart';
import 'package:o_connect/ui/views/themes/providers/webinar_themes_provider.dart';
import 'package:o_connect/ui/views/video_audio_player/model/video_share_model.dart';
import 'package:oes_chatbot/core/size_config.dart';
import 'package:provider/provider.dart';

import '../../utils/buttons_helper/custom_botton.dart';
import '../../utils/buttons_helper/custom_outline_button.dart';
import '../../utils/images/images.dart';
import '../../utils/textfield_helper/app_fonts.dart';
import '../../utils/textfield_helper/common_textfield.dart';

class VideoPlayerPopUpScreen extends StatefulWidget {
  const VideoPlayerPopUpScreen({super.key});

  @override
  State<VideoPlayerPopUpScreen> createState() => _VideoPlayerPopUpScreenState();
}

class _VideoPlayerPopUpScreenState extends State<VideoPlayerPopUpScreen> {
  final _Key = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    context.read<VideoShareProvider>().isVideoPicked = false;
    context.read<VideoShareProvider>().fetchVideoList();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer2<VideoShareProvider, WebinarThemesProviders>(builder: (context, videoShareProvider, webinarThemeProvider, child) {
      return RefreshIndicator(
          onRefresh: () async {
            context.read<VideoShareProvider>().fetchVideoList(forceRefresh: true);
          },
          child: Form(
            key: _Key,
            child: Container(
              decoration: BoxDecoration(
                color: webinarThemeProvider.themeBackGroundColor ?? Theme.of(context).scaffoldBackgroundColor,
                borderRadius: const BorderRadius.only(topLeft: Radius.circular(20), topRight: Radius.circular(20)),
              ),
              height: ScreenConfig.height * 0.7,
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
                                ConstantsStrings.videoShare,
                                style: w500_14Poppins(color: Theme.of(context).hoverColor),
                              ),
                              Row(
                                children: [
                                  videoShareProvider.isVideoPicked
                                      ? UploadBtn(
                                          color: webinarThemeProvider.themeHighLighter,
                                        )
                                      : InkWell(
                                          onTap: () {
                                            videoShareProvider.showVideoLoader();
                                            videoShareProvider.showFilePicker();
                                          },
                                          child: SvgPicture.asset(
                                            "assets/new_ui_icons/bgm/upload.svg",
                                            height: 25.w,
                                            width: 25.w,
                                            fit: BoxFit.fill,
                                          ),
                                        ),
                                  width20,
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
                  // showDialogCustomHeader(context, headerTitle: ConstantsStrings.videoShare),

                  /// Videos

                  Expanded(
                    child: context.read<VideoShareProvider>().isDeleteItem
                        ? Center(child: Lottie.asset(AppImages.loadingJson, height: 40.w, width: 40.w))
                        : videoShareProvider.videosList.isEmpty
                            ? Center(
                                child: Text(
                                "No Items Found ...",
                                style: w400_14Poppins(color: Colors.white),
                              ))
                            : _VideosGrid(
                                selectedVideoIndx: videoShareProvider.videoPlaySelectedIndex,
                                videoList: videoShareProvider.videosList,
                                color: webinarThemeProvider.themeHighLighter,
                              ),
                  ),
                  SizedBox(
                    height: 80.h,
                    child: Padding(
                      padding: EdgeInsets.symmetric(
                        horizontal: 20.w,
                        vertical: 8.h,
                      ),
                      child: SizedBox(
                        height: 40.h,
                        child: CommonTextFormField(
                          // validator: (val, String? f) {
                          //   return FormValidations.requiredFieldValidation(val, "URL");
                          // },
                          onTap: () {
                            videoShareProvider.clearSelection();
                          },

                          controller: videoShareProvider.videoUrlController,
                          hintText: ConstantsStrings.pasteVideoUrl,
                          fillColor: webinarThemeProvider.colors.itemColor,
                          keyboardType: TextInputType.text,
                          inputAction: TextInputAction.done,
                        ),
                      ),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.all(10.sp),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        width10,
                        CustomOutlinedButton(
                          outLineBorderColor: webinarThemeProvider.colors.textColor,
                          height: 35.h,
                          width: 100.w,
                          buttonTextStyle: w400_13Poppins(color: Provider.of<WebinarThemesProviders>(context).colors.textColor),
                          buttonText: ConstantsStrings.cancel,
                          onTap: () => Navigator.pop(context),
                        ),
                        width10,
                        CustomButton(
                          buttonColor: webinarThemeProvider.themeHighLighter ?? AppColors.mainBlueColor,
                          width: 100.w,
                          height: 35.h,
                          buttonText: ConstantsStrings.play,
                          buttonTextStyle: w500_13Poppins(color: AppColors.whiteColor),
                          onTap: () async {
                            final provider = context.read<VideoShareProvider>();
                            final selectedVideoIdx = provider.videoPlaySelectedIndex;
                            final url = provider.videoUrlController.text;

                            if (provider.videoPlaySelectedIndex != -1) {
                              videoShareProvider.startVideoShare(videoUrl: provider.videosList[selectedVideoIdx].url);
                              Navigator.pop(context);
                            } else if (url.isNotEmpty && url.isValidUrl) {
                              videoShareProvider.startVideoShare(videoUrl: url);
                              Navigator.pop(context);
                            } else {
                              CustomToast.showErrorToast(msg: "Please provide a valid URL or select a video to share");
                            }
                          },
                        )
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ));
    });
  }
}

class UploadBtn extends StatelessWidget {
  const UploadBtn({super.key, this.color});

  final Color? color;

  @override
  Widget build(BuildContext context) {
    return Container(
        width: 80.w,
        height: 35.h,
        decoration: BoxDecoration(border: Border.all(color: AppColors.mainBlueColor), color: color ?? const Color(0xff0381F5).withOpacity(0.2), borderRadius: BorderRadius.circular(5.r)),
        child: const Center(
            child: SizedBox(
                width: 20,
                height: 20,
                child: CircularProgressIndicator(
                  strokeWidth: 1,
                ))));
  }
}

class _VideosGrid extends StatelessWidget {
  const _VideosGrid({
    required this.videoList,
    this.color,
    required this.selectedVideoIndx,
  });

  final List<VideoShareModel> videoList;
  final Color? color;
  final int selectedVideoIndx;

  @override
  Widget build(BuildContext context) {
    void showVideoShareDeleteOrViewAlertBox({required WebinarThemesProviders webinarThemesProviders, required int index}) {
      showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            backgroundColor: Theme.of(context).scaffoldBackgroundColor,
            titlePadding: EdgeInsets.zero,
            contentPadding: EdgeInsets.zero,
            content: Stack(
              alignment: Alignment.center,
              children: [
                Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                      padding: EdgeInsets.symmetric(horizontal: 15.sp, vertical: 10.sp),
                      decoration: BoxDecoration(
                        color: Theme.of(context).hintColor.withOpacity(0.05),
                        borderRadius: BorderRadius.only(topRight: Radius.circular(10.r), topLeft: Radius.circular(10.r)),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Details',
                            style: w400_14Poppins(color: Colors.white),
                          ),
                          IconButton(
                            onPressed: () {
                              Navigator.pop(context);
                            },
                            icon: const Icon(Icons.cancel),
                          )
                        ],
                      ),
                    ),
                    width20,
                    Padding(
                      padding: const EdgeInsets.all(15.0),
                      child: Column(
                        children: [
                          Row(
                            children: [
                              Stack(
                                children: [
                                  SizedBox(
                                    width: 50,
                                    height: 50,
                                    child: Container(
                                      decoration: BoxDecoration(
                                        color: webinarThemesProviders.colors.itemColor,
                                        borderRadius: BorderRadius.circular(5.r),
                                        border: Border.all(color: Colors.white24, width: 2),
                                      ),
                                      child: ClipRRect(
                                        borderRadius: BorderRadius.circular(10),
                                        child: const Icon(
                                          Icons.play_arrow,
                                          size: 20,
                                          color: AppColors.whiteColor,
                                        ),
                                        // child: Image.network(videoList[index].url, fit: BoxFit.fill),
                                      ),
                                    ),
                                  ),
                                  // Center(
                                  //   child: Container(
                                  //     decoration: BoxDecoration(
                                  //       borderRadius: BorderRadius.circular(5),
                                  //       color: color ?? Colors.blue,
                                  //       border: Border.all(
                                  //         color: color ?? Colors.blue,
                                  //       ),
                                  //     ),
                                  //     child: ClipRRect(
                                  //       borderRadius: BorderRadius.circular(5),
                                  //       child: const Icon(
                                  //         Icons.play_arrow,
                                  //         size: 20,
                                  //         color: AppColors.whiteColor,
                                  //       ),
                                  //     ),
                                  //   ),
                                  // ),
                                ],
                              ),
                              width15,
                              Expanded(
                                child: Text(
                                  videoList[index].fileName,
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis,
                                  style: w400_14Poppins(color: Colors.white),
                                ),
                              ),
                            ],
                          ),
                          height20,
                          Row(
                            children: [
                              Expanded(
                                child: context.read<VideoShareProvider>().isDeleteItem
                                    ? Center(child: Lottie.asset(AppImages.loadingJson, height: 40.w, width: 40.w))
                                    : CustomOutlinedButton(
                                        leadingIcon: Icon(
                                          Icons.delete_outlined,
                                          size: 18.sp,
                                        ),
                                        buttonText: 'Delete',
                                        buttonTextStyle: w400_14Poppins(color: Colors.white),
                                        color: Theme.of(context).hintColor.withOpacity(0.05),
                                        onTap: () {

                                          context.read<VideoShareProvider>().videoDelete(videoList[index].id, context);
                                        },
                                        outLineBorderColor: Colors.transparent,
                                      ),
                              ),
                            ],
                          ),
                          height20,
                          Row(
                            children: [
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'Size',
                                    style: TextStyle(color: Theme.of(context).hintColor.withOpacity(0.5), fontSize: getFontSize(14)),
                                  ),
                                  Text(
                                    context.read<ChatProvider>().getVideoSizeFromBytes(videoList[index].fileSize ?? '0', 2),
                                    style: TextStyle(fontSize: getFontSize(16)),
                                  ),
                                ],
                              ),
                              width20,
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'Date Created',
                                    style: TextStyle(color: Theme.of(context).hintColor.withOpacity(0.5), fontSize: getFontSize(14)),
                                  ),
                                  Text(
                                    videoList[index].createdDate != null ? DateFormat('dd MMM yyyy, hh:mm a').format(videoList[index].createdDate ?? DateTime.now()).toString() : "",
                                    style: TextStyle(fontSize: getFontSize(16)),
                                  ),
                                ],
                              )
                            ],
                          )
                        ],
                      ),
                    )
                  ],
                )
              ],
            ),
          );
        },
      );
    }

    return Consumer<WebinarThemesProviders>(builder: (_, webinarThemesProviders, __) {
      return Padding(
        padding: EdgeInsets.only(left: 15.sp, right: 15.sp),
        child: ListView.builder(
          itemCount: videoList.length,
          itemBuilder: (context, index) => Padding(
            padding: EdgeInsets.all(5.sp),
            child: Container(
              decoration: BoxDecoration(color: webinarThemesProviders.unSelectButtonsColor, borderRadius: const BorderRadius.all(Radius.circular(5))),
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 10.0.sp, vertical: 5.sp),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    SizedBox(
                      height: 50.w,
                      width: 50.w,
                      child: GestureDetector(
                        onTap: () {
                          context.read<VideoShareProvider>().updateSelectedGridViewIndex(index);
                        },
                        child: Stack(
                          children: [
                            SizedBox(
                              width: MediaQuery.of(context).size.width,
                              height: MediaQuery.of(context).size.height,
                              child: Container(
                                decoration: BoxDecoration(
                                  color: webinarThemesProviders.colors.itemColor,
                                  borderRadius: BorderRadius.circular(10),
                                  border: Border.all(color: (selectedVideoIndx == index) ? Colors.blue : Colors.white24, width: 2),
                                ),
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(10),
                                  // child: Image.network(videoList[index].url, fit: BoxFit.fill),
                                ),
                              ),
                            ),
                            Center(
                              child: Container(
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(5),
                                  color: color ?? Colors.blue,
                                  border: Border.all(
                                    color: color ?? Colors.blue,
                                  ),
                                ),
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(5),
                                  child: const Icon(
                                    Icons.play_arrow,
                                    size: 20,
                                    color: AppColors.whiteColor,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 10.0.sp),
                      child: Container(
                        width: MediaQuery.of(context).size.width * 0.55,
                        alignment: Alignment.centerLeft,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              videoList[index].fileName,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: w400_14Poppins(color: Colors.white),
                            ),
                            height5,
                            Text(
                              "File size : ${context.read<ChatProvider>().getVideoSizeFromBytes(videoList[index].fileSize ?? '0', 2)}",
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: w300_12Poppins(color: webinarThemesProviders.hintTextColor),
                            ),
                          ],
                        ),
                      ),
                    ),
                    GestureDetector(
                      onTap: () {
                        showVideoShareDeleteOrViewAlertBox(webinarThemesProviders: webinarThemesProviders, index: index);
                      },
                      child: const Icon(
                        Icons.more_vert,
                        // color: Colors.red,
                        size: 25,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      );
    });
  }
}
