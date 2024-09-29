import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:o_connect/core/screen_configs.dart';
import 'package:o_connect/ui/utils/buttons_helper/close_apply_buttons.dart';
import 'package:o_connect/ui/utils/colors/colors.dart';
import 'package:o_connect/ui/utils/constant_strings.dart';
import 'package:o_connect/ui/utils/custom_show_dialog_helper/custom_show_dialog.dart';
import 'package:o_connect/ui/utils/textfield_helper/app_fonts.dart';
import 'package:o_connect/ui/views/drawer/custom_drawer_view.dart';
import 'package:o_connect/ui/views/drawer/library_revamp/model/library_files_model.dart';
import 'package:o_connect/ui/views/drawer/library_revamp/widgets/library_item_delete_popup.dart';
import 'package:o_connect/ui/views/drawer/library_revamp/widgets/library_item_widget.dart';
import 'package:o_connect/ui/views/drawer/library_revamp/widgets/library_top_bar.dart';
import 'package:oes_chatbot/utils/extensions/sizedbox_extension.dart';
import 'package:provider/provider.dart';

import '../library_revamp_provider.dart';

class FolderWidgetPage extends StatefulWidget {
  final String folderName;
  final bool fromPresentation;
  const FolderWidgetPage({
    super.key,
    required this.folderName,
    this.fromPresentation = false,
  });

  @override
  State<FolderWidgetPage> createState() => _FolderWidgetPageState();
}

class _FolderWidgetPageState extends State<FolderWidgetPage> {
  final TextEditingController searchController = TextEditingController();
  var refreshKey = GlobalKey<RefreshIndicatorState>();
  late LibraryRevampProvider _libraryProvider;

  @override
  void initState() {
    _libraryProvider = Provider.of<LibraryRevampProvider>(
      context,
      listen: false,
    );
    Future.delayed(Duration.zero, () {
      _libraryProvider.getFolderFilesData(
        context: context,
        folderName: widget.folderName,
      );
    });

    super.initState();
  }

  @override
  void dispose() {
    searchController.dispose();
    super.dispose();
  }

  Future _onRefresh() async {
    Completer completer = Completer();
    await Future.delayed(Duration.zero).then((value) {
      completer.complete();
      _libraryProvider.getFolderFilesData(
        context: context,
        folderName: widget.folderName,
      );
    });
    return completer.future;
  }

  onDelete() async {
    if (_libraryProvider.isDeleteSelection) {
      List<String> selectedFileList = widget.folderName.isNotEmpty
          ? _libraryProvider.getSelectedFolderFileIds
          : _libraryProvider.getSelectedFileIds;
      await _libraryProvider.deleteFileFolder(
        context: context,
        fileOrFolderIds: selectedFileList,
        fromPresentation: widget.fromPresentation,
        folderName: widget.folderName,
      );
      return;
    }
    await _libraryProvider.presentSelectedFiles(
      context: context,
      fromFolderView: widget.folderName.isNotEmpty,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<LibraryRevampProvider>(
      builder: (context, provider, child) {
        List<LibraryItem> folderFileItems = widget.fromPresentation
            ? provider.libraryFolderData
            : provider.presentationFolderData;
        return Scaffold(
          bottomNavigationBar: (folderFileItems.isEmpty ||
                  provider.isSearchDataEmpty)
              ? const SizedBox()
              : Padding(
                  padding:
                      EdgeInsets.symmetric(horizontal: 10.w, vertical: 20.h),
                  child: CloseApplyButtons(
                    closeOnTap: () {
                      if (widget.fromPresentation) {
                        Navigator.pop(context);
                      } else {
                        _libraryProvider.clearSelection(
                          fromFolder: widget.folderName.isNotEmpty,
                        );
                        _libraryProvider.selectedLibraryItems = [];
                      }
                    },
                    applyOnTap: () async {
                      await customShowDialog(
                        context,
                        AllItemsDeletePopup(onTap: () {
                          Navigator.pop(context);
                          onDelete();
                        }),
                      );
                    },
                    rightButtonText: (_libraryProvider.isDeleteSelection ||
                            !widget.fromPresentation)
                        ? ConstantsStrings.delete
                        : ConstantsStrings.present,
                    leftButtonText: ConstantsStrings.cancel,
                    leftButtonBorderColor: Colors.transparent,
                    width: ScreenConfig.width * 0.45,
                  ),
                ),
          backgroundColor: Theme.of(context).scaffoldBackgroundColor,
          resizeToAvoidBottomInset: false,
          drawer: widget.fromPresentation ? null : const CustomDrawerView(),
          appBar: AppBar(
            backgroundColor: Theme.of(context).cardColor,
            leading: IconButton(
                onPressed: () {
                  Navigator.pop(context);
                  provider.selectedLibraryItems = [];
                },
                icon: Icon(
                  Icons.chevron_left_outlined,
                  color: Theme.of(context).primaryColorLight,
                )),
            title: Text(
              widget.folderName,
              style: w400_14Poppins(
                  color: Theme.of(context).hintColor.withOpacity(0.8)),
            ),
          ),
          body: SafeArea(
            child: RefreshIndicator(
              key: refreshKey,
              onRefresh: _onRefresh,
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
                          showCreateIcon: false,
                          libraryContent: provider.libraryFolderFilesModel,
                          folderName: widget.folderName,
                          showUploadIcon:
                              !(provider.selectedLibraryItems.isNotEmpty)),
                      height10,
                      Expanded(
                        child: (folderFileItems.isEmpty ||
                                provider.isSearchDataEmpty)
                            ? const Center(
                                child: Text(
                                "No Records Found",
                              ))
                            : ListView.builder(
                                shrinkWrap: true,
                                itemCount: folderFileItems.length,
                                itemBuilder: ((context, index) {
                                  LibraryItem libraryItem =
                                      folderFileItems[index];
                                  return (libraryItem.canShow ?? true)
                                      ? LibraryItemWidget(
                                          fromFolder: widget.folderName,
                                          libraryItem: libraryItem,
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
        );
      },
    );
  }
}
