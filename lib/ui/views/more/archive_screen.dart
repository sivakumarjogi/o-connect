import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:o_connect/core/providers/library_provider.dart';
import 'package:o_connect/core/screen_configs.dart';
import 'package:o_connect/ui/utils/colors/colors.dart';
import 'package:o_connect/ui/utils/constant_strings.dart';
import 'package:o_connect/ui/utils/images/images.dart';
import 'package:o_connect/ui/utils/textfield_helper/app_fonts.dart';
import 'package:o_connect/ui/utils/textfield_helper/common_textfield.dart';
import 'package:o_connect/ui/views/drawer/library/presentation_files/presentation_files.dart';
import 'package:o_connect/ui/views/drawer/library/template/library_templates.dart';
import 'package:o_connect/ui/views/more/archive_history.dart';
import 'package:provider/provider.dart';

class ArchiveScreen extends StatefulWidget {
  const ArchiveScreen({super.key});

  @override
  State<ArchiveScreen> createState() => _ArchiveScreenState();
}

class _ArchiveScreenState extends State<ArchiveScreen> {
  @override
  void initState() {
    // TODO: implement initState
    context.read<LibraryProvider>().fetchMeetingHistoryLoadMore();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        resizeToAvoidBottomInset: false,
        body: SafeArea(child: Consumer<LibraryProvider>(builder: (context, provider, child) {
          return Column(
            children: [
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
                      "Archive",
                      style: w400_14Poppins(color: Theme.of(context).hintColor.withOpacity(0.8)),
                    ),
                  ],
                ),
              ),
              height15,
              Padding(
                padding: EdgeInsets.all(10.0.sp),
                child: SizedBox(
                    height: 40.w,
                    child: CommonTextFormField(
                        fillColor: Theme.of(context).scaffoldBackgroundColor,
                        // controller: getAllContactsProvider.contactSearchController,
                        borderColor: Theme.of(context).primaryColorLight,
                        controller: provider.searchController,
                        // prefixIcon: Icon(
                        //   Icons.search,
                        //   color: Theme.of(context).disabledColor,
                        // ),
                        hintText: "Search",
                        onChanged: (value) {
                          provider.updateSearchResults(value);
                        },
                        hintStyle: w300_14Poppins(color: Theme.of(context).primaryColorLight),
                        suffixIcon: Padding(
                            padding: EdgeInsets.all(8.0.sp),
                            child: SvgPicture.asset(
                              AppImages.searchIcon,
                              // width: 10.w,
                              // height: 10.h,
                            )))),
              ),
              // height10,
              SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    if (provider.libraryDropdownSelectedItem != ConstantsStrings.presentationFiles) height10,
                    provider.libraryDropdownSelectedItem == ConstantsStrings.template
                        ? LibraryTemplates(provider: provider)
                        : provider.libraryDropdownSelectedItem == ConstantsStrings.presentationFiles
                            ? PresentationFiles(provider: provider)
                            : ArchiveHistory(),
                    height10,
                  ],
                ),
              ),
            ],
          );
        })));
  }
}
