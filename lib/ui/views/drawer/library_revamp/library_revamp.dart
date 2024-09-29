import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:o_connect/core/screen_configs.dart';
import 'package:o_connect/ui/utils/buttons_helper/close_apply_buttons.dart';
import 'package:o_connect/ui/utils/custom_show_dialog_helper/custom_show_dialog.dart';
import 'package:o_connect/ui/views/drawer/drawer_viewmodel.dart';
import 'package:o_connect/ui/views/drawer/library_revamp/library_revamp_provider.dart';
import 'package:o_connect/ui/views/drawer/library_revamp/model/library_files_model.dart';
import 'package:o_connect/ui/views/drawer/library_revamp/widgets/library_item_delete_popup.dart';
import 'package:o_connect/ui/views/drawer/library_revamp/widgets/library_item_widget.dart';
import 'package:o_connect/ui/views/drawer/library_revamp/widgets/library_top_bar.dart';
import 'package:oes_chatbot/utils/extensions/sizedbox_extension.dart';
import 'package:o_connect/ui/utils/colors/colors.dart';
import 'package:o_connect/ui/utils/constant_strings.dart';
import 'package:o_connect/ui/views/drawer/custom_drawer_view.dart';
import 'package:provider/provider.dart';

class LibraryRevampPage extends StatefulWidget {
  const LibraryRevampPage({super.key});

  @override
  State<LibraryRevampPage> createState() => _LibraryRevampPageState();
}

class _LibraryRevampPageState extends State<LibraryRevampPage> {
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
      _libraryProvider.getLibraryFilesData(
        context: context,
      );
    });
    super.initState();
  }

  @override
  void dispose() {
    searchController.dispose();
    _libraryProvider.resetState();
    super.dispose();
  }

  Future _onRefresh() async {
    Completer completer = Completer();
    await Future.delayed(Duration.zero).then((value) {
      completer.complete();
      _libraryProvider.getLibraryFilesData(
        context: context,
      );
    });
    return completer.future;
  }

  onDelete(context) async {
    List<String> selectedFileList = _libraryProvider.getSelectedFileIds;
    await _libraryProvider.deleteFileFolder(
      context: context,
      fileOrFolderIds: selectedFileList,
    );
    _libraryProvider.selectedLibraryItems = [];
    Navigator.pop(context);
    return;
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<LibraryRevampProvider>(
      builder: (context, provider, child) {
        return PopScope(
          canPop: true,
          onPopInvoked: (_) async {
            Provider.of<DrawerViewModel>(
              context,
              listen: false,
            ).mainSelectedChange(
              ConstantsStrings.home,
            );
          },
          child: Scaffold(
            bottomNavigationBar:
                provider.libraryData.isEmpty || provider.isSearchDataEmpty
                    ? const SizedBox()
                    : Padding(
                        padding: EdgeInsets.symmetric(
                          horizontal: 10.w,
                        ),
                        child: CloseApplyButtons(
                          closeOnTap: () {
                            _libraryProvider.clearSelection();
                            _libraryProvider.selectedLibraryItems = [];
                          },
                          applyOnTap: () async {
                            await customShowDialog(
                              context,
                              AllItemsDeletePopup(onTap: () {
                                onDelete(context);
                              }),
                            );
                          },
                          rightButtonText: ConstantsStrings.delete,
                          leftButtonText: ConstantsStrings.cancel,
                          leftButtonBorderColor: Colors.transparent,
                          width: ScreenConfig.width * 0.45,
                        ),
                      ),
            backgroundColor: Theme.of(context).scaffoldBackgroundColor,
            resizeToAvoidBottomInset: false,
            drawer: const CustomDrawerView(),
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
                          libraryContent: provider.libraryFilesModel,
                        ),
                        height10,
                        Expanded(
                          child: provider.libraryData.isEmpty ||
                                  provider.isSearchDataEmpty
                              ? const Center(
                                  child: Text(
                                  "No Records Found",
                                ))
                              : ListView.builder(
                                  shrinkWrap: true,
                                  itemCount: provider.libraryData.length,
                                  itemBuilder: ((context, index) {
                                    LibraryItem libraryItem =
                                        provider.libraryData[index];
                                    return (libraryItem.canShow ?? true)
                                        ? LibraryItemWidget(
                                            libraryItem: libraryItem,
                                            isFolder: libraryItem.fileType ==
                                                "folder",
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
        );
      },
    );
  }
}
