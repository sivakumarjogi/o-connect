import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';
import 'package:lottie/lottie.dart';
import 'package:o_connect/core/providers/library_provider.dart';
import 'package:o_connect/core/screen_configs.dart';
import '../../../../utils/custom_show_dialog_helper/custom_show_dialog.dart';
import 'package:o_connect/ui/utils/images/images.dart';
import '../../../../utils/colors/colors.dart';
import '../../../../utils/textfield_helper/app_fonts.dart';
import 'templete_popup.dart';

class LibraryTemplates extends StatelessWidget {
  const LibraryTemplates({super.key, required this.provider});

  final LibraryProvider provider;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        provider.isTemplateFirstLoadRunning
            ? SizedBox(
                height: MediaQuery.of(context).size.height * 0.5,
                width: MediaQuery.of(context).size.width,
                child: Center(
                  child: Lottie.asset(AppImages.loadingJson, height: 70.h, width: 100.w),
                ),
              )
            : provider.finalUpdatedTemplateData.isNotEmpty
                ? SizedBox(
                    height: ScreenConfig.height * 0.66,
                    child: ListView.builder(
                      controller: provider.templatesScrollController,
                      itemCount: provider.finalUpdatedTemplateData.length,
                      shrinkWrap: true,
                      itemBuilder: (context, i) {
                        return GestureDetector(
                          onTap: () {
                            customShowDialog(context, TemplatePopUp(templateObject: provider.finalUpdatedTemplateData[i], provider: provider));
                          },
                          child: Container(
                            margin: EdgeInsets.only(bottom: 8.h),
                            decoration: BoxDecoration(borderRadius: BorderRadius.circular(8), color: Theme.of(context).cardColor),
                            child: Padding(
                              padding: EdgeInsets.all(8.sp),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    provider.finalUpdatedTemplateData[i]["meeting_name"] ?? "",
                                    style: w400_14Poppins(color: Theme.of(context).primaryColorLight),
                                  ),
                                  height5,
                                  Row(
                                    children: [
                                      SizedBox(
                                        width: ScreenConfig.width * 0.35,
                                        child: Text(
                                          provider.finalUpdatedTemplateData[i]["template_name"] ?? "",
                                          overflow: TextOverflow.ellipsis,
                                          style: w300_12Poppins(color: Theme.of(context).disabledColor),
                                        ),
                                      ),
                                      width10,
                                      Text(
                                        DateFormat("MMM dd, yyyy HH:mm").format(DateFormat("yyyy-MM-ddTHH:mm:ss").parse(provider.finalUpdatedTemplateData[i]["created_on"])).toString(),
                                        style: w300_12Poppins(color: Theme.of(context).disabledColor),
                                      ),
                                      width10,
                                      Text(
                                        provider.finalUpdatedTemplateData[i]["meeting_type"] ?? "",
                                        style: w300_12Poppins(color: Theme.of(context).disabledColor),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                  )
                : SizedBox(
                    height: MediaQuery.of(context).size.height * 0.5,
                    child: Center(
                      child: Text(
                        "No Records Found",
                        style: w400_15Poppins(color: Theme.of(context).hintColor),
                      ),
                    )),
        // when the loadMore function is running
        provider.isTemplateLoadMoreRunning
            ? Padding(
                padding: const EdgeInsets.only(top: 10, bottom: 40),
                child: Center(child: Lottie.asset(AppImages.loadingJson, height: 40.w, width: 40.w)),
              )
            : const SizedBox.shrink(),

        // When nothing else to load
        /*   if (provider.hasTemplateNextPage == false)
          Container(
            padding: const EdgeInsets.only(top: 10, bottom: 10),
            color: Colors.amber,
            child: const Center(
              child: Text('You have fetched all of the content'),
            ),
          ),*/
      ],
    );
  }
}
