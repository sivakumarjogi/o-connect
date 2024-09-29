import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:o_connect/ui/utils/constant_strings.dart';
import 'package:o_connect/ui/utils/images/images.dart';
import 'package:o_connect/ui/utils/textfield_helper/app_fonts.dart';
import 'package:o_connect/ui/utils/textfield_helper/common_textfield.dart';
import 'package:o_connect/ui/views/drawer/library_revamp/library_file_select.dart';
import 'package:o_connect/ui/views/drawer/library_revamp/library_revamp_provider.dart';
import 'package:o_connect/ui/views/drawer/library_revamp/model/library_files_model.dart';
import 'package:o_connect/ui/views/drawer/library_revamp/widgets/create_folder_popup.dart';
import 'package:provider/provider.dart';

class LibraryTopBar extends StatelessWidget {
  final bool showCreateIcon;
  final LibraryFilesModel libraryContent;
  final String? folderName;
  final bool showUploadIcon;

  const LibraryTopBar(
      {super.key,
      required this.searchController,
      this.showCreateIcon = true,
      this.showUploadIcon = true,
      required this.libraryContent,
      this.folderName});

  final TextEditingController searchController;

  @override
  Widget build(BuildContext context) {
    return Consumer<LibraryRevampProvider>(builder: (context, provider, _) {
      return Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          SizedBox(
            width: MediaQuery.of(context).size.width * 0.7,
            height: 40.h,
            child: CommonTextFormField(
              fillColor: Theme.of(context).scaffoldBackgroundColor,
              borderColor: Theme.of(context).primaryColorDark,
              controller: searchController,
              onChanged: (searchedText) async {
                if (folderName != null && folderName!.isNotEmpty) {
                  provider.onSearchFolders(
                    searchValue: searchedText,
                  );
                } else {
                  provider.onSearch(
                    searchValue: searchedText,
                  );
                }
              },
              keyboardType: TextInputType.text,
              hintText: ConstantsStrings.search,
              hintStyle:
                  w400_14Poppins(color: Theme.of(context).primaryColorLight),
              suffixIcon: InkWell(
                onTap: () {
                  searchController.clear();
                  provider.onSearch(
                    searchValue: "",
                  );
                  provider.onSearchFolders(
                    searchValue: "",
                  );
                  provider.searching = false;
                },
                child: Icon(
                  provider.searching ? Icons.close : Icons.search,
                  size: 16.sp,
                  color: Theme.of(context).primaryColorLight,
                ),
              ),
              inputAction: TextInputAction.next,
            ),
          ),
          provider.selectedLibraryItems.isNotEmpty
              ? GestureDetector(
                  onTap: () async {
                    await provider.multipleDownloadRecord();
                  },
                  child: Icon(
                    Icons.file_download_outlined,
                    color: Theme.of(context).primaryColorLight,
                    size: 30,
                  ),
                )
              : const IgnorePointer(),
          provider.selectedLibraryItems.isNotEmpty
              ? const IgnorePointer()
              : Row(
                  children: [
                    showCreateIcon
                        ? GestureDetector(
                            onTap: () async {
                              await showCreateFolder(context);
                            },
                            child: SvgPicture.asset(
                              AppImages.createFolderIcon,
                            ),
                          )
                        : const IgnorePointer(),
                    const SizedBox(
                      width: 20,
                    ),
                    showUploadIcon
                        ? GestureDetector(
                            onTap: () async {
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
                                  return FileSelectDropDown(
                                    libraryContent: libraryContent,
                                    folderName: folderName,
                                  );
                                },
                              );
                            },
                            child: SvgPicture.asset(AppImages.uploadIcon),
                          )
                        : const IgnorePointer(),
                  ],
                )
        ],
      );
    });
  }
}
