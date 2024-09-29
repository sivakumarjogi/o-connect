import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:o_connect/core/screen_configs.dart';
import 'package:o_connect/ui/utils/images/images.dart';
import 'package:o_connect/ui/utils/textfield_helper/app_fonts.dart';
import 'package:o_connect/ui/views/drawer/library_revamp/library_revamp_provider.dart';
import 'package:o_connect/ui/views/drawer/library_revamp/model/library_files_model.dart';
import 'package:oes_chatbot/utils/extensions/sizedbox_extension.dart';
import 'package:provider/provider.dart';

class FileSelectDropDown extends StatelessWidget {
  LibraryFilesModel libraryContent;
  String? folderName;
  FileSelectDropDown(
      {super.key, required this.libraryContent, this.folderName});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Align(
            alignment: Alignment.center,
            child: Container(
              height: 5.h,
              width: 100.w,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20.r),
                color: Color(0xff202223),
              ),
            ),
          ),
          25.h.height,
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "Select File",
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
                      size: 12,
                      color: Theme.of(context).scaffoldBackgroundColor,
                    ),
                  ),
                ),
              ),
            ],
          ),
          const Divider(),
          Consumer<LibraryRevampProvider>(
            builder: (context, provider, _) {
              return Padding(
                padding: const EdgeInsets.all(8.0),
                child: SizedBox(
                  width: ScreenConfig.width,
                  child: Column(
                    children: [
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          fileTypeWidget(
                            icon: AppImages.docIcon,
                            onTap: () {
                              provider.onPickFile(
                                  context: context,
                                  type: "doc",
                                  libraryContent: libraryContent,
                                  folderNam: folderName);
                            },
                            type: "Documents",
                          ),
                          fileTypeWidget(
                            icon: AppImages.camIcon,
                            onTap: () {
                              provider.onPickFile(
                                  context: context,
                                  type: "cam",
                                  libraryContent: libraryContent,
                                  folderNam: folderName);
                            },
                            type: "Camera",
                          ),
                          fileTypeWidget(
                            icon: AppImages.galleryIcon,
                            onTap: () {
                              provider.onPickFile(
                                  context: context,
                                  type: "gallery",
                                  libraryContent: libraryContent,
                                  folderNam: folderName);
                            },
                            type: "Gallery",
                          ),

                        ],
                      ),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [

                          ///TO DO HANDLE THIS IN FUTURE
                          // fileTypeWidget(
                          //   icon: AppImages.musicIcon,
                          //   onTap: () {
                          //     provider.onPickFile(
                          //         context: context,
                          //         type: "audio",
                          //         libraryContent: libraryContent,
                          //         folderNam: folderName);
                          //   },
                          //   type: "Music",
                          // ),
                          fileTypeWidget(
                            icon: AppImages.videoIcon,
                            onTap: () {
                              provider.onPickFile(
                                  context: context,
                                  type: "video",
                                  libraryContent: libraryContent,
                                  folderNam: folderName);
                            },
                            type: "Video",
                          ),
                          Container(),
                          Container(),
                        ],
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        ],
      ),
    );
  }

  Widget fileTypeWidget({
    required String type,
    required String icon,
    required VoidCallback onTap,
  }) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          Consumer<LibraryRevampProvider>(
            builder: (context, provider, _) {
              return GestureDetector(
                onTap: onTap,
                child: Image.asset(
                  icon,
                  height: ScreenConfig.height * 0.05,
                ),
              );
            },
          ),
          5.h.height,
          Text(type,style: w400_14Poppins(color: Colors.white),)
        ],
      ),
    );
  }
}
