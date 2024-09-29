import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:lottie/lottie.dart';
import 'package:o_connect/core/providers/library_provider.dart';
import 'package:o_connect/ui/utils/custom_show_dialog_helper/custom_show_dialog.dart';
import 'package:o_connect/ui/utils/images/images.dart';
import 'package:o_connect/ui/views/home_screen/home_screen_provider/home_screen_provider.dart';
import 'package:o_connect/ui/views/webinar_details/webinar_details_model/meeting_details_model.dart';
import 'package:o_connect/ui/views/webinar_details/webinar_details_view/past_webinars.dart';
import 'package:o_connect/ui/views/webninar_dashboard/presentation/create_webinar/provider/create_webinar_provider.dart';
import 'package:oes_chatbot/utils/extensions/sizedbox_extension.dart';
import 'package:provider/provider.dart';

import '../../../../core/common_functions.dart';
import '../../../utils/textfield_helper/app_fonts.dart';
import '../../pip_views/pip_global_navigation.dart';
import '../../webninar_dashboard/presentation/create_webinar/create_webinar_screen.dart';

class SavedWebinarWidget extends StatefulWidget {
  SavedWebinarWidget({super.key});

  @override
  State<SavedWebinarWidget> createState() => _SavedWebinarWidgetState();
}

class _SavedWebinarWidgetState extends State<SavedWebinarWidget> {
  LibraryProvider? provider;

  @override
  void initState() {
    provider = Provider.of<LibraryProvider>(context, listen: false);

    SchedulerBinding.instance.addPostFrameCallback((_) {
      provider?.fetchTemplateFirstLoadRunning();
    });

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer2<LibraryProvider, HomeScreenProvider>(
        builder: (context, provider, homeScreenProvider, child) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          provider.isTemplateFirstLoadRunning
              ? Center(
                  child: Lottie.asset(AppImages.loadingJson,
                      height: 50.w, width: 50.w),
                )
              : provider.finalUpdatedTemplateData.isEmpty
                  ? Center(
                      child: Text(
                      "No records found",
                      style: w400_14Poppins(color: Colors.white),
                    ))
                  : Expanded(
                      child: ListView.builder(
                          controller: provider.templatesScrollController,
                          shrinkWrap: true,
                          itemCount: provider.finalUpdatedTemplateData.length,
                          physics: const BouncingScrollPhysics(),
                          itemBuilder: (context, i) {
                            return Padding(
                              padding: EdgeInsets.all(8.0.sp),
                              child: Container(
                                padding: EdgeInsets.symmetric(
                                    horizontal: 20.w, vertical: 10.h),
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(6.r),
                                    color: Theme.of(context).cardColor),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    5.h.height,
                                    Container(
                                      decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(6),
                                          color: const Color(0xff143227)),
                                      child: Padding(
                                        padding: const EdgeInsets.all(6.0),
                                        child: Text(
                                          "SAVED",
                                          style: w500_10Poppins(
                                              color: Colors.green),
                                        ),
                                      ),
                                    ),
                                    5.h.height,
                                    Text(
                                      provider.finalUpdatedTemplateData[i]
                                              ["template_name"] ??
                                          "",
                                      style: w500_14Poppins(
                                          color: Theme.of(context).hintColor),
                                    ),
                                    5.h.height,
                                    Row(
                                      children: [
                                        SvgPicture.asset(AppImages.profileIcon),
                                        10.w.width,
                                        Text(
                                          provider.finalUpdatedTemplateData[i]
                                                  ["template_name"] ??
                                              "",
                                          style: w400_13Poppins(
                                              color: Theme.of(context)
                                                  .primaryColorLight),
                                        )
                                      ],
                                    ),
                                    5.h.height,
                                    Row(
                                      children: [
                                        SvgPicture.asset(
                                            AppImages.webinarImage),
                                        10.w.width,
                                        Text(
                                          provider.finalUpdatedTemplateData[i]
                                                  ["meeting_type"] ??
                                              "",
                                          style: w400_13Poppins(
                                              color: Theme.of(context)
                                                  .primaryColorLight),
                                        )
                                      ],
                                    ),
                                    5.h.height,
                                    InkWell(
                                      onTap: () {
                                        showModalBottomSheet(
                                            isScrollControlled: true,
                                            isDismissible: false,
                                            backgroundColor: Theme.of(context)
                                                .scaffoldBackgroundColor,
                                            shape: RoundedRectangleBorder(
                                                borderRadius: BorderRadius.only(
                                                    topRight:
                                                        Radius.circular(24.r),
                                                    topLeft:
                                                        Radius.circular(24.r))),
                                            context: context,
                                            builder: (context) {
                                              return detailsView(
                                                  context, provider, i);
                                            });
                                      },
                                      child: Container(
                                        // width: 80.w,
                                        height: 40.h,
                                        decoration: BoxDecoration(
                                            borderRadius:
                                                BorderRadius.circular(3),
                                            color: const Color(0xff1B2632)),
                                        child: Center(
                                          child: Text(
                                            "View",
                                            style: w400_14Poppins(
                                                color: Colors.white),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            );
                          }),
                    )
        ],
      );
    });
  }

  Padding detailsView(BuildContext context, LibraryProvider provider, int i) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 15.0.w, vertical: 10.0.h),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Align(
            alignment: Alignment.center,
            child: Container(
              height: 5.h,
              width: 100.w,
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20.r),
                  color: const Color(0xff202223)),
            ),
          ),
          25.h.height,
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "Details",
                style: w500_14Poppins(color: Colors.white),
              ),
              Row(
                children: [
                  10.w.width,
                  // InkWell(
                  //   onTap: () async {
                  //     bool canEdit = await checkUserSubScription();
                  //     if (context.mounted) {
                  //       Navigator.pop(context);
                  //       if (canEdit) {
                  //         Navigator.push(
                  //             context,
                  //             MaterialPageRoute(
                  //                 builder: (context) => PIPGlobalNavigation(
                  //                         childWidget: CreateWebinarScreen(
                  //                       meetingDetailsModel: MeetingDetailsModel
                  //                           .fromJson(provider
                  //                               .finalUpdatedTemplateData[i]),
                  //                       isEdit: true,
                  //                       eventId:
                  //                           provider.finalUpdatedTemplateData[i]
                  //                                   ['id'] ??
                  //                               "",
                  //                     ))));
                  //       }
                  //     }
                  //   },
                  //   child: SvgPicture.asset(
                  //     width: 20.w,
                  //     height: 20.w,
                  //     AppImages.edit,
                  //   ),
                  // ),
                  10.w.width,
                  GestureDetector(
                    onTap: () {
                      Navigator.pop(context);
                    },
                    child: const Icon(
                      Icons.cancel,
                      size: 24,
                      color: Color(0xff5E6272),
                    ),
                  )
                ],
              ),
            ],
          ),
          const Divider(),
          10.h.height,
          Container(
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(6),
                color: const Color(0xff143227)),
            child: Padding(
              padding: EdgeInsets.all(6.0.sp),
              child: Text(
                "SAVED",
                style: w500_10Poppins(color: Colors.green),
              ),
            ),
          ),
          5.h.height,
          TextDarkField(
              name:
                  provider.finalUpdatedTemplateData[i]["template_name"] ?? ""),
          15.h.height,
          TextLightField(name: "Start Date & Time"),
          5.h.height,
          TextDarkField(
              name: provider.finalUpdatedTemplateData[i]["created_on"] ?? ""),
          15.h.height,
          TextLightField(name: "Meeting Name"),
          5.h.height,
          TextDarkField(
              name: provider.finalUpdatedTemplateData[i]["meeting_name"] ?? ""),
          15.h.height,
          TextLightField(name: "Event Type"),
          5.h.height,
          TextDarkField(
              name: provider.finalUpdatedTemplateData[i]["meeting_type"] ?? ""),
          15.h.height,
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Flexible(
                flex: 1,
                child: InkWell(
                  onTap: () {
                    customShowDialog(context,
                        DeleteBottomSheetForPastEvent(onTap: () {
                      provider.deleteParticularTemplate(
                        templateID: provider.finalUpdatedTemplateData[i]["_id"],
                        userId: provider.finalUpdatedTemplateData[i]["user_id"],
                        context: context,
                      );
                    }));
                  },
                  child: Container(
                    // width: 80.w,
                    height: 40.h,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(3),
                        color: const Color(0xff1B2632)),
                    child: Center(
                      child: Text(
                        "Delete",
                        style: w400_14Poppins(color: Colors.white),
                      ),
                    ),
                  ),
                ),
              ),
              SizedBox(
                width: 10.w,
              ),
              Flexible(
                flex: 1,
                child: InkWell(
                  onTap: () async {
                    bool canEdit = await checkUserSubScription();
                    if (context.mounted) {
                      Navigator.pop(context);
                      if (canEdit) {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => PIPGlobalNavigation(
                                        childWidget: CreateWebinarScreen(
                                      meetingDetailsModel:
                                          MeetingDetailsModel.fromJson(provider
                                              .finalUpdatedTemplateData[i]),
                                      isEdit: true,
                                      eventId:
                                          provider.finalUpdatedTemplateData[i]
                                                  ["_id"] ??
                                              "",
                                    ))));

                        Provider.of<CreateWebinarProvider>(context,
                                listen: false)
                            .isSelectedWebinarMethod(0);
                      }
                    }
                  },
                  child: Container(
                      // width: 100.w,
                      height: 40.h,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(3),
                          color: Colors.blue),
                      child: Center(
                        child: Text(
                          "Apply to",
                          style: w400_14Poppins(color: Colors.white),
                        ),
                      )),
                ),
              )
            ],
          ),
        ],
      ),
    );
  }
}

class TextDarkField extends StatelessWidget {
  TextDarkField({super.key, required this.name});
  String name;
  @override
  Widget build(BuildContext context) {
    return Text(
      name,
      style: w500_14Poppins(color: Theme.of(context).hintColor),
    );
  }
}

class TextLightField extends StatelessWidget {
  TextLightField({super.key, required this.name});
  String name;
  @override
  Widget build(BuildContext context) {
    return Text(
      name,
      style: w400_13Poppins(color: const Color(0xff8F93A3)),
    );
  }
}
