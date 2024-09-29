import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:lottie/lottie.dart';
import 'package:o_connect/core/providers/library_provider.dart';
import 'package:o_connect/core/screen_configs.dart';
import 'package:o_connect/ui/utils/colors/colors.dart';
import 'package:o_connect/ui/utils/custom_show_dialog_helper/custom_show_dialog.dart';
import 'package:o_connect/ui/utils/custom_toast_helper/custom_toast.dart';
import 'package:o_connect/ui/utils/network_image_helpers/cached_image_validation.dart';
import 'package:o_connect/ui/utils/textfield_helper/app_fonts.dart';
import 'package:o_connect/ui/views/delete_bottom_sheet.dart';
import 'package:o_connect/ui/views/drawer/library_revamp/model/library_files_model.dart';
import 'package:o_connect/ui/views/pip_views/pip_global_navigation.dart';
import 'package:provider/provider.dart';

import '../../../../utils/images/images.dart';
import '../widgets/image_view_with_zoom.dart';
import '../widgets/network_video_player.dart';

class RecordingFilesPopup extends StatefulWidget {
  const RecordingFilesPopup({
    super.key,
    required this.presentationData,
    required this.popUpName,
    required this.meetingId,
  });

  final List<LibraryItem> presentationData;
  final String popUpName;
  final String meetingId;

  @override
  State<RecordingFilesPopup> createState() => _RecordingFilesPopupState();
}

class _RecordingFilesPopupState extends State<RecordingFilesPopup> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Consumer<LibraryProvider>(builder: (context, libraryProvider, child) {
          return Column(
            // mainAxisSize: MainAxisSize.min,
            children: [
              // showDialogCustomHeader(context,
              //     headerTitle: returnPopUpHeaderTitleTextAndDeleteText(
              //       popUpName: widget.popUpName,
              //     )),
              Container(
                // height: 50.h,
                width: ScreenConfig.width,
                decoration: BoxDecoration(borderRadius: BorderRadius.circular(8.r), color: Theme.of(context).cardColor),
                child: Row(
                  children: [
                    IconButton(
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        icon: Icon(
                          Icons.chevron_left_outlined,
                          color: Theme.of(context).primaryColorLight,
                        )),
                    Text(
                      widget.popUpName == "ScreenShot" ? "Screen Capture" : widget.popUpName,
                      style: w400_14Poppins(color: Theme.of(context).hintColor.withOpacity(0.8)),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: EdgeInsets.all(4.sp),
                child: SizedBox(
                  height: MediaQuery.of(context).size.height * 0.89,
                  child: libraryProvider.itemLoading
                      ? Center(
                          child: Lottie.asset(
                            AppImages.loadingJson,
                            height: 40.w,
                            width: 40.w,
                          ),
                        )
                      : libraryProvider.presentationData.isEmpty
                          ? Center(
                              child: Text(
                                "No datRecordsa found...",
                                style: w400_14Poppins(color: Theme.of(context).disabledColor),
                              ),
                            )
                          : ListView.builder(
                              itemCount: libraryProvider.presentationData.length,
                              itemBuilder: (context, index) {
                                print("the file url is the ${libraryProvider.presentationData[index].url}");

                                return Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Container(
                                    decoration: BoxDecoration(borderRadius: BorderRadius.circular(8), color: Theme.of(context).cardColor),
                                    child: Padding(
                                      padding: EdgeInsets.only(right: 8.w, left: 6.w, top: 6.h, bottom: 6.h),
                                      child: Row(
                                        children: [
                                          (widget.popUpName == "Recordings")
                                              ? RecordingsWidget(libraryProvider: libraryProvider, index: index)
                                              : (widget.popUpName == "presentation")
                                                  ? PresentationWidget(libraryProvider: libraryProvider, index: index)
                                                  : (widget.popUpName == "webinar-video")
                                                      ? VideosWidget(libraryProvider: libraryProvider, index: index)
                                                      : (widget.popUpName == "Chat")
                                                          ? PresentationWidget(libraryProvider: libraryProvider, index: index)
                                                          : (widget.popUpName == "ScreenShot")
                                                              ? ScreenshotWidget(libraryProvider: libraryProvider, index: index)
                                                              : Container(),
                                          width20,
                                          Column(
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            children: [
                                              SizedBox(
                                                width: MediaQuery.of(context).size.width * 0.5,
                                                child: Text(
                                                  widget.popUpName == "Recordings"
                                                      ? "${libraryProvider.presentationData[index].url!.split("_").last}.${libraryProvider.presentationData[index].fileType!.split("/").last}"
                                                      : libraryProvider.presentationData[index].fileName ?? "test",
                                                  overflow: TextOverflow.ellipsis,
                                                  maxLines: 1,
                                                  softWrap: false,
                                                  style: w400_14Poppins(color: Theme.of(context).hintColor),
                                                ),
                                              ),
                                              height10,
                                              height5,
                                              Row(
                                                children: [
                                                  InkWell(
                                                      onTap: () {
                                                        customShowDialog(
                                                            context,
                                                            DeleteBottomSheet(
                                                              title: "Are you sure to delete this ${returnPopUpHeaderTitleTextAndDeleteText(popUpName: widget.popUpName, isDeleteText: true)}?",
                                                              titleTextColor: Colors.white,
                                                              body: "",
                                                              onTap: () async {
                                                                Navigator.pop(context);
                                                                Provider.of<LibraryProvider>(context, listen: false)
                                                                    .fileDelete(libraryProvider.presentationData[index].id!, widget.meetingId, widget.popUpName, context);
                                                              },
                                                              headerTitle: 'Delete',
                                                            ));
                                                      },
                                                      child: SizedBox(
                                                        height: 20.h,
                                                        width: 20.w,
                                                        child: SvgPicture.asset(
                                                          AppImages.delProfileIcon,
                                                          fit: BoxFit.fill,
                                                        ),
                                                      )),
                                                  width10,
                                                  InkWell(
                                                      onTap: () {
                                                        String? fileUrl;
                                                        if (widget.popUpName == "Recordings") {
                                                          fileUrl =
                                                              "https://rcrd-dev.onpassive.com/${libraryProvider.presentationData[index].meetingId}/${libraryProvider.presentationData[index].url}.${libraryProvider.presentationData[index].fileType!.split("/").last}";
                                                        }

                                                        Provider.of<LibraryProvider>(context, listen: false).fileDownloadLocal(
                                                            fileUrl ?? libraryProvider.presentationData[index].url, libraryProvider.presentationData[index].fileName ?? "test${DateTime.now()}");
                                                      },
                                                      child: SizedBox(
                                                        height: 18.h,
                                                        width: 18.w,
                                                        child: SvgPicture.asset(
                                                          AppImages.downloadIcon,
                                                          fit: BoxFit.fill,
                                                        ),
                                                      )),
                                                  width10,
                                                  InkWell(
                                                      onTap: () {
                                                        CustomToast.showSuccessToast(msg: "Coming soon...");
                                                        /* Provider.of<LibraryProvider>(context, listen: false).shareNetworkImage(
                                                        "https://rcrd-dev.onpassive.com/${libraryProvider.presentationData[index].meetingId}/${libraryProvider.presentationData[index].url}.${libraryProvider.presentationData[index].fileType!.split("/").last}",
                                                      );*/
                                                      },
                                                      child: SizedBox(
                                                        height: 18.h,
                                                        width: 18.w,
                                                        child: SvgPicture.asset(
                                                          AppImages.shareIcon,
                                                          fit: BoxFit.fill,
                                                        ),
                                                      )),
                                                ],
                                              )
                                            ],
                                          )
                                        ],
                                      ),
                                    ),
                                  ),
                                );
                              }),
                ),
              ),
              // height10,
              // const CloseWidget()
            ],
          );
        }),
      ),
    );
  }

  String returnPopUpHeaderTitleTextAndDeleteText({required String popUpName, bool isDeleteText = false}) {
    switch (popUpName) {
      case "Recordings":
        return isDeleteText ? "record" : "Recordings Files";
      case "presentation":
        return isDeleteText ? "presentation" : "Presentation Files";
      case "webinar-video":
        return isDeleteText ? "video" : "Presentation Files";
      case "Chat":
        return isDeleteText ? "chat" : "Chat Files";
      case "ScreenShot":
        return isDeleteText ? "Screen Captures" : "Screen Captures";
      default:
        "Files";
    }
    return "Files";
  }
}

class RecordingsWidget extends StatelessWidget {
  const RecordingsWidget({super.key, required this.libraryProvider, required this.index});

  final LibraryProvider libraryProvider;
  final int index;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      child: const CreateDummyThumbnailWidget(),
      onTap: () {
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => NetworkVideoPlayerWidget(
                      filename: libraryProvider.presentationData[index].fileName ?? "Text",
                      filePath: "https://rcrd-dev.onpassive.com/${libraryProvider.presentationData[index].url!.split('_').first}/${libraryProvider.presentationData[index].url}.mp4" ?? "",
                    )));
      },
    );
  }
}

class PresentationWidget extends StatelessWidget {
  const PresentationWidget({super.key, required this.libraryProvider, required this.index});

  final LibraryProvider libraryProvider;
  final int index;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(8.sp),
      decoration: BoxDecoration(borderRadius: BorderRadius.circular(8), color: Theme.of(context).primaryColor),
      child: libraryProvider.presentationData[index].readUrl!.contains(".pdf")
          ? GestureDetector(
              onTap: () {
                libraryProvider.openFileWithUrl(libraryProvider.presentationData[index].readUrl ?? "");
              },
              child: SvgPicture.asset(
                AppImages.pdfPresentationIcon,
                height: 70.h,
                width: 100.w,
              ),
            )
          : libraryProvider.presentationData[index].readUrl!.contains(".xls")
              ? GestureDetector(
                  onTap: () {
                    libraryProvider.openFileWithUrl(libraryProvider.presentationData[index].readUrl ?? "");
                  },
                  child: SvgPicture.asset(
                    AppImages.xlsPresentationIcon,
                    height: 60.h,
                    width: 100.w,
                  ),
                )
              : libraryProvider.presentationData[index].readUrl!.contains(".doc")
                  ? GestureDetector(
                      onTap: () {
                        libraryProvider.openFileWithUrl(libraryProvider.presentationData[index].readUrl ?? "");
                      },
                      child: SvgPicture.asset(
                        AppImages.docPresentationIcon,
                        height: 60.h,
                        width: 100.w,
                      ),
                    )
                  : libraryProvider.presentationData[index].readUrl!.contains(".txt")
                      ? GestureDetector(
                          onTap: () {
                            libraryProvider.openFileWithUrl(libraryProvider.presentationData[index].readUrl ?? "");
                          },
                          child: SvgPicture.asset(
                            AppImages.textPresentationIcon,
                            height: 60.h,
                            width: 100.w,
                          ),
                        )
                      : libraryProvider.presentationData[index].readUrl!.contains(".pptx")
                          ? GestureDetector(
                              onTap: () {
                                libraryProvider.openFileWithUrl(libraryProvider.presentationData[index].readUrl ?? "");
                              },
                              child: SvgPicture.asset(
                                AppImages.pptPresentationIcon,
                                height: 60.h,
                                width: 100.w,
                              ),
                            )
                          : InkWell(
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(5),
                                child: Image.network(
                                  libraryProvider.presentationData[index].readUrl ?? "",
                                  height: 70.h,
                                  width: 80.w,
                                  fit: BoxFit.fill,
                                ),
                              ),
                              onTap: () {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => PIPGlobalNavigation(
                                                childWidget: ImageViewWidget(
                                              imagePath: libraryProvider.presentationData[index].readUrl! ?? "",
                                              fileName: libraryProvider.presentationData[index].fileName ?? "",
                                            ))));
                              },
                            ),
    );
  }
}

class VideosWidget extends StatelessWidget {
  const VideosWidget({super.key, required this.libraryProvider, required this.index});

  final LibraryProvider libraryProvider;
  final int index;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      child: const CreateDummyThumbnailWidget(),
      onTap: () {
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => NetworkVideoPlayerWidget(filename: libraryProvider.presentationData[index].fileName ?? "Test", filePath: libraryProvider.presentationData[index].url ?? "")));
      },
    );
  }
}

class ScreenshotWidget extends StatelessWidget {
  const ScreenshotWidget({super.key, required this.libraryProvider, required this.index});

  final LibraryProvider libraryProvider;
  final int index;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      child: SizedBox(
        height: 80.h,
        width: 120.w,
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: ImageServiceWidget(
            networkImgUrl: libraryProvider.presentationData[index].readUrl ?? "https://lh3.googleusercontent.com/p/AF1QipOd7Oab9RkyLX-E7YWYDdYr4dwTWkYZaEpHsnRW=w1080-h608-p-no-v0",
          ),
        ),
      ),
      onTap: () {
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) =>
                    PIPGlobalNavigation(childWidget: ImageViewWidget(imagePath: libraryProvider.presentationData[index].url ?? "", fileName: libraryProvider.presentationData[index].fileName ?? ""))));
      },
    );
  }
}

class CreateDummyThumbnailWidget extends StatelessWidget {
  const CreateDummyThumbnailWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: AlignmentDirectional.center,
      children: [
        Container(
          height: 80.h,
          width: 120.w,
          color: Colors.black54,
          margin: EdgeInsets.symmetric(vertical: 10.h, horizontal: 5.w),
          // decoration: const BoxDecoration(color: Colors.black38),
        ),
        const Icon(
          Icons.play_circle_outline,
          size: 20,
          color: AppColors.whiteColor,
        ),
      ],
    );
  }
}
