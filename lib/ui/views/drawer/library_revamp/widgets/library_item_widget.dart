import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:o_connect/core/screen_configs.dart';
import 'package:o_connect/ui/utils/images/images.dart';
import 'package:o_connect/ui/utils/textfield_helper/app_fonts.dart';
import 'package:o_connect/ui/views/drawer/library_revamp/library_revamp_provider.dart';
import 'package:o_connect/ui/views/drawer/library_revamp/model/library_files_model.dart';
import 'package:o_connect/ui/views/drawer/library_revamp/widgets/library_bottom_sheet.dart';
import 'package:o_connect/ui/views/meeting/utils/get_svg_file_extension.dart';
import 'package:oes_chatbot/utils/extensions/sizedbox_extension.dart';
import 'package:provider/provider.dart';

class LibraryItemWidget extends StatelessWidget {
  const LibraryItemWidget(
      {super.key,
      required this.libraryItem,
      this.fromPresentation = false,
      this.fromFolder,
      this.isFolder = false});
  final LibraryItem libraryItem;
  final bool fromPresentation;
  final String? fromFolder;
  final bool isFolder;
  @override
  Widget build(BuildContext context) {
    // Navigator.pop(context);
    return Consumer<LibraryRevampProvider>(builder: (
      context,
      provider,
      _,
    ) {
      return Padding(
        padding: const EdgeInsets.only(top: 4.0),
        child: Container(
          height: 60.h,
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12),
              color: Theme.of(context).cardColor),
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                if (!isFolder)
                  IconButton(
                    onPressed: () {
                      if (fromFolder != null && fromFolder!.isNotEmpty) {
                        provider.selectFolderLibraryItem = libraryItem;
                        provider.selectLibraryRecords(
                            false, provider.libraryFolderFilesModel);
                        return;
                      }
                      provider.selectLibraryItem(
                        libraryItem,
                        fromPresentation: fromPresentation,
                      );
                      provider.selectLibraryRecords(
                          isFolder, provider.libraryFilesModel);
                    },
                    icon: Icon(
                      size: 15.h,
                      (libraryItem.isSelected ?? false)
                          ? Icons.radio_button_checked_rounded
                          : Icons.radio_button_unchecked_outlined,
                    ),
                  ),
                Image.asset(
                  libraryItem.isFolder
                      ? AppImages.folder
                      : (libraryItem.fileName ?? "").getSvg,
                  height: 35.h,
                  width: 35.w,
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    InkWell(
                      onTap: () async {
                        await provider.onItemTap(
                          libraryItem: libraryItem,
                          context: context,
                          fromPresentation: fromPresentation,
                        );
                      },
                      child: SizedBox(
                        width: ScreenConfig.width * 0.55,
                        height: 38.h,
                        child: Align(
                          alignment: Alignment.centerLeft,
                          child: Text(
                            libraryItem.isFolder
                                ? libraryItem.folderName.toString()
                                : libraryItem.fileName.toString(),
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                            style: w500_14Poppins(
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ),
                    ),
                    5.h.height,
                  ],
                ),
                GestureDetector(
                  onTap: () {
                    showModalBottomSheet(
                        isScrollControlled: true,
                        isDismissible: false,
                        backgroundColor:
                            Theme.of(context).scaffoldBackgroundColor,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.only(
                            topRight: Radius.circular(24.r),
                            topLeft: Radius.circular(24.r),
                          ),
                        ),
                        context: context,
                        builder: (context) {
                          return LibraryItemBottomSheet(
                            context: context,
                            libraryItem: libraryItem,
                          );
                        });
                  },
                  child: Icon(
                    Icons.more_vert_rounded,
                    color: Theme.of(context).primaryColorLight,
                  ),
                )
              ],
            ),
          ),
        ),
      );
    });
  }
}
