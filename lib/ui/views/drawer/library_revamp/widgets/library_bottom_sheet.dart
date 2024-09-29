import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:o_connect/core/screen_configs.dart';
import 'package:o_connect/ui/utils/custom_show_dialog_helper/custom_show_dialog.dart';
import 'package:o_connect/ui/utils/images/images.dart';
import 'package:o_connect/ui/utils/textfield_helper/app_fonts.dart';
import 'package:o_connect/ui/views/drawer/library_revamp/library_revamp_provider.dart';
import 'package:o_connect/ui/views/drawer/library_revamp/model/library_files_model.dart';
import 'package:o_connect/ui/views/drawer/library_revamp/widgets/library_item_delete_popup.dart';
import 'package:o_connect/ui/views/meeting/utils/get_svg_file_extension.dart';
import 'package:oes_chatbot/utils/extensions/datetime_extensions.dart';
import 'package:oes_chatbot/utils/extensions/sizedbox_extension.dart';
import 'package:provider/provider.dart';

class LibraryItemBottomSheet extends StatelessWidget {
  const LibraryItemBottomSheet({
    super.key,
    required this.context,
    required this.libraryItem,
  });

  final BuildContext context;
  final LibraryItem libraryItem;
  @override
  Widget build(BuildContext context) {
    String fileName = libraryItem.isFolder
        ? (libraryItem.folderName ?? "")
        : libraryItem.fileName ?? "";
    return Consumer<LibraryRevampProvider>(builder: (con, provider, _) {
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
                  color: const Color(0xff202223),
                ),
              ),
            ),
            25.h.height,
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                SizedBox(
                  width: ScreenConfig.width * 0.75,
                  child: Text(
                    "Details",
                    style: w500_14Poppins(color: Colors.white),
                  ),
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
            Row(
              children: [
                Image.asset(
                  libraryItem.isFolder
                      ? AppImages.folder
                      : (libraryItem.fileName ?? "").getSvg,
                  height: 55.h,
                  width: 55.w,
                ),
                5.w.width,
                SizedBox(width: 290.w, child: Text(fileName))
              ],
            ),
            10.h.height,
            Row(
              children: [
                libraryItem.isFolder
                    ? const IgnorePointer()
                    : InkWell(
                        onTap: () async {
                          await provider.onItemTap(
                            libraryItem: libraryItem,
                            context: context,
                            toView: false,
                          );
                        },
                        child: Container(
                          width: 175.w,
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(8),
                              color: const Color(0xff202223)),
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Row(
                              children: [
                                Icon(Icons.file_download_outlined,
                                    color: Theme.of(context).primaryColorLight),
                                4.w.width,
                                Text(
                                  "Download",
                                  style: w400_12Poppins(
                                    color: Theme.of(context).primaryColorLight,
                                  ),
                                )
                              ],
                            ),
                          ),
                        ),
                      ),
                8.w.width,
                InkWell(
                  onTap: () async {
                    Navigator.pop(context);
                    await customShowDialog(
                      context,
                      LibraryItemDeletePopup(
                        libraryItem: libraryItem,
                      ),
                    );
                  },
                  child: Container(
                    width: 175.w,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(8),
                        color: const Color(0xff202223)),
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Row(
                        children: [
                          Icon(Icons.delete_outline_outlined,
                              color: Theme.of(context).primaryColorLight),
                          4.w.width,
                          Text(
                            "Delete",
                            style: w400_12Poppins(
                                color: Theme.of(context).primaryColorLight),
                          )
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
            5.h.height,
            const Divider(),
            Text(
              "Type",
              style: w400_12Poppins(color: Theme.of(context).primaryColorLight),
            ),
            5.h.height,
            Text(
              libraryItem.fileType ?? "",
              style: w400_14Poppins(color: Theme.of(context).hintColor),
            ),
            10.h.height,
            Text(
              "Size",
              style: w400_12Poppins(color: Theme.of(context).primaryColorLight),
            ),
            5.h.height,
            Text(
              libraryItem.isFolder
                  ? libraryItem.folderSize.toString()
                  : bytesToMb(int.parse(libraryItem.fileSize)).toString(),
              style: w400_14Poppins(color: Theme.of(context).hintColor),
            ),
            10.h.height,
            Text(
              "Date Created",
              style: w400_12Poppins(color: Theme.of(context).primaryColorLight),
            ),
            5.h.height,
            Text(
              (libraryItem.createdOn ?? DateTime.now()).getInvitesFormat(),
              style: w400_13Poppins(color: Theme.of(context).hintColor),
            ),
            10.h.height,
            Text(
              "Date Modified",
              style: w400_12Poppins(color: Theme.of(context).primaryColorLight),
            ),
            5.h.height,
            Text(
              (libraryItem.updatedOn ?? DateTime.now()).getInvitesFormat(),
              style: w400_13Poppins(color: Theme.of(context).hintColor),
            ),
            30.h.height,
          ],
        ),
      );
    });
  }

  String bytesToMb(int bytes) {
    double mb = bytes / (1024 * 1024);
    return mb.toStringAsFixed(2) + " MB"; // Formatting to 2 decimal places
  }
}
