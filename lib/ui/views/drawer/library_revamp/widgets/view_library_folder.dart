import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:o_connect/core/screen_configs.dart';
import 'package:o_connect/ui/utils/colors/colors.dart';
import 'package:o_connect/ui/views/drawer/library_revamp/library_revamp_provider.dart';
import 'package:o_connect/ui/views/drawer/library_revamp/model/library_files_model.dart';
import 'package:o_connect/ui/views/drawer/library_revamp/widgets/library_item_widget.dart';
import 'package:o_connect/ui/views/drawer/library_revamp/widgets/library_top_bar.dart';
import 'package:oes_chatbot/utils/extensions/sizedbox_extension.dart';
import 'package:provider/provider.dart';

class ViewLibraryFolder extends StatefulWidget {
  ViewLibraryFolder({super.key});

  @override
  State<ViewLibraryFolder> createState() => _ViewLibraryFolderState();
}

class _ViewLibraryFolderState extends State<ViewLibraryFolder> {
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

  var searchController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Consumer<LibraryRevampProvider>(
      builder: (context, provider, child) {
        return PopScope(
          child: Scaffold(
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
