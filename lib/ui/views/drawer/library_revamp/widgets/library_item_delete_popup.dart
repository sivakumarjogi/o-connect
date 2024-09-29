import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:o_connect/ui/utils/buttons_helper/custom_botton.dart';
import 'package:o_connect/ui/utils/colors/colors.dart';
import 'package:o_connect/ui/utils/custom_show_dialog_helper/custom_show_dialog.dart';
import 'package:o_connect/ui/utils/textfield_helper/app_fonts.dart';
import 'package:o_connect/ui/views/drawer/library_revamp/library_revamp_provider.dart';
import 'package:o_connect/ui/views/drawer/library_revamp/model/library_files_model.dart';
import 'package:provider/provider.dart';

class LibraryItemDeletePopup extends StatelessWidget {
  const LibraryItemDeletePopup({
    super.key,
    required this.libraryItem,
  });
  final LibraryItem libraryItem;
  @override
  Widget build(BuildContext context) {
    return Consumer<LibraryRevampProvider>(builder: (_, provider, wi) {
      return Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          height10,
          showDialogCustomHeader(context, headerTitle: "Delete"),
          SafeArea(
            minimum: EdgeInsets.all(16.sp),
            child: Column(
              children: [
                Center(
                  child: RichText(
                      textAlign: TextAlign.center,
                      text: TextSpan(children: [
                        TextSpan(
                            text: "Are you sure to delete this file? ",
                            style: w500_14Poppins(color: Colors.white)),
                        TextSpan(
                            text:
                                "${libraryItem.isFolder ? '"${libraryItem.folderName}" folder' : '${libraryItem.fileName}file'} ",
                            style: w500_14Poppins(color: Colors.blue)),
                        TextSpan(
                            text:
                                "will get deleted permanently! Would you like to continue? ",
                            style: w500_14Poppins(color: Colors.white)),
                      ])),
                ),
                height20,
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    CustomButton(
                      buttonText: "Cancel",
                      buttonColor: const Color(0xff1B2632),
                      buttonTextStyle: w400_14Poppins(
                        color: AppColors.whiteColor,
                      ),
                      width: MediaQuery.of(context).size.width / 2 - 50.sp,
                      height: 32.h,
                      onTap: () {
                        Navigator.pop(context, false);
                      },
                    ),
                    width15,
                    CustomButton(
                      buttonText: "Delete",
                      width: MediaQuery.of(context).size.width / 2 - 50.sp,
                      height: 32.h,
                      buttonTextStyle: w400_14Poppins(color: Colors.white),
                      onTap: () async {
                        await provider.deleteFileFolder(
                          context: context,
                          fileOrFolderIds: [libraryItem.id ?? ""],
                        );
                        Navigator.pop(context);
                      },
                    )
                  ],
                ),
              ],
            ),
          ),
        ],
      );
    });
  }
}

class AllItemsDeletePopup extends StatelessWidget {
  final Function onTap;
  const AllItemsDeletePopup({super.key, required this.onTap});
  @override
  Widget build(BuildContext context) {
    return Consumer<LibraryRevampProvider>(builder: (_, provider, wi) {
      return Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          height10,
          showDialogCustomHeader(context, headerTitle: "Delete"),
          SafeArea(
            minimum: EdgeInsets.all(16.sp),
            child: Column(
              children: [
                Center(
                  child: RichText(
                      textAlign: TextAlign.center,
                      text: TextSpan(children: [
                        TextSpan(
                            text: "Are you sure to delete this file? ",
                            style: w500_14Poppins(color: Colors.white)),
                        TextSpan(
                            text:
                                "will get deleted permanently! Would you like to continue? ",
                            style: w500_14Poppins(color: Colors.white)),
                      ])),
                ),
                height20,
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    CustomButton(
                      buttonText: "Cancel",
                      buttonColor: const Color(0xff1B2632),
                      buttonTextStyle: w400_14Poppins(
                        color: AppColors.whiteColor,
                      ),
                      width: MediaQuery.of(context).size.width / 2 - 50.sp,
                      height: 32.h,
                      onTap: () {
                        Navigator.pop(context, false);
                      },
                    ),
                    width15,
                    CustomButton(
                        buttonText: "Delete",
                        width: MediaQuery.of(context).size.width / 2 - 50.sp,
                        height: 32.h,
                        buttonTextStyle: w400_14Poppins(color: Colors.white),
                        onTap: () {
                          onTap();
                        })
                  ],
                ),
              ],
            ),
          ),
        ],
      );
    });
  }
}
