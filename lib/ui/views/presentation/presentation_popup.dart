import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:o_connect/core/screen_configs.dart';
import 'package:o_connect/ui/utils/buttons_helper/close_apply_buttons.dart';
import 'package:o_connect/ui/utils/colors/colors.dart';
import 'package:o_connect/ui/utils/constant_strings.dart';
import 'package:o_connect/ui/utils/custom_show_dialog_helper/custom_show_dialog.dart';
import 'package:o_connect/ui/views/drawer/library_revamp/library_revamp_provider.dart';
import 'package:o_connect/ui/views/drawer/library_revamp/model/library_files_model.dart';
import 'package:o_connect/ui/views/drawer/library_revamp/widgets/library_item_widget.dart';
import 'package:o_connect/ui/views/drawer/library_revamp/widgets/library_top_bar.dart';
import 'package:o_connect/ui/views/presentation/provider/presentation_popup_provider.dart';
import 'package:o_connect/ui/views/webinar_details/webinar_details_provider/webinar_provider.dart';
import 'package:oes_chatbot/utils/extensions/sizedbox_extension.dart';
import 'package:provider/provider.dart';

Future<void> showPresentationPopUp(BuildContext context) async {
  customShowDialog(
    context,
    PresentationPopUp(),
    height: ScreenConfig.height * 0.7,
  );
}

class PresentationPopUp extends StatefulWidget {
  const PresentationPopUp({Key? key}) : super(key: key);

  @override
  State<PresentationPopUp> createState() => _PresentationPopUpState();
}

class _PresentationPopUpState extends State<PresentationPopUp> {
  final refreshKey = GlobalKey<RefreshIndicatorState>();

  final TextEditingController searchController = TextEditingController();
  @override
  void initState() {
    super.initState();
    Future.delayed(Duration.zero, () {
      Provider.of<LibraryRevampProvider>(
        context,
        listen: false,
      ).getLibraryFilesData(
        context: context,
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    // Navigator.pop(context);
    return Consumer3<PresentationPopUpProvider, WebinarProvider, LibraryRevampProvider>(builder: (
      key,
      presentationProvider,
      webinarProvider,
      libraryRevampProvider,
      _,
    ) {
      return Scaffold(
        bottomNavigationBar: Padding(
          padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 15.h),
          child: CloseApplyButtons(
            closeOnTap: () {
              Navigator.pop(context);
            },
            applyOnTap: () async {
              if (libraryRevampProvider.isDeleteSelection) {
                List<String> selectedFileList = libraryRevampProvider.getSelectedPresentaionFileIds;
                await libraryRevampProvider.deleteFileFolder(
                  context: context,
                  fileOrFolderIds: selectedFileList,
                  fromPresentation: true,
                );
                return;
              }
              await libraryRevampProvider.presentSelectedFiles(context: context);
            },
            rightButtonText: libraryRevampProvider.isDeleteSelection ? ConstantsStrings.delete : ConstantsStrings.present,
            leftButtonText: ConstantsStrings.cancel,
            leftButtonBorderColor: Colors.transparent,
            width: ScreenConfig.width * 0.45,
          ),
        ),
        body: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            showDialogCustomHeader(context, headerTitle: 'Presenatation'),
            SizedBox(
              height: ScreenConfig.height * 0.45,
              child: SizedBox(
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 5.w, vertical: 2.h),
                  child: RefreshIndicator(
                    key: refreshKey,
                    onRefresh: () async {
                      await Provider.of<LibraryRevampProvider>(
                        context,
                        listen: false,
                      ).getLibraryFilesData(
                        context: context,
                      );
                    },
                    child: Padding(
                      padding: EdgeInsets.only(
                        left: 15.w,
                        right: 15.w,
                        top: 10.h,
                      ),
                      child: SizedBox(
                        height: ScreenConfig.height,
                        child: Column(
                          children: [
                            height10,
                            LibraryTopBar(
                              searchController: searchController,
                              libraryContent: libraryRevampProvider.libraryFilesModel,
                            ),
                            height10,
                            Expanded(
                              child: libraryRevampProvider.presentationData.isEmpty || libraryRevampProvider.isSearchDataEmpty
                                  ? const Center(
                                      child: Text(
                                      "No Records Found",
                                    ))
                                  : ListView.builder(
                                      shrinkWrap: true,
                                      itemCount: libraryRevampProvider.presentationData.length,
                                      itemBuilder: ((context, index) {
                                        LibraryItem libraryItem = libraryRevampProvider.presentationData[index];
                                        return (libraryItem.canShow ?? true)
                                            ? LibraryItemWidget(
                                                libraryItem: libraryItem,
                                                fromPresentation: true,
                                              )
                                            : const IgnorePointer();
                                      }),
                                    ),
                            ),
                            5.h.height,
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      );
    });
  }
}
