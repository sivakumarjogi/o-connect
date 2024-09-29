import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:o_connect/core/common_functions.dart';
import 'package:o_connect/ui/utils/close_widget.dart';
import 'package:o_connect/ui/utils/custom_show_dialog_helper/custom_show_dialog.dart';
import 'package:o_connect/ui/utils/custom_toast_helper/custom_toast.dart';
import 'package:o_connect/ui/views/pip_views/pip_global_navigation.dart';
import 'package:o_connect/ui/views/webinar_details/webinar_details_view/save_as_template.dart';
import 'package:o_connect/ui/views/webinar_details/webinar_details_view/transfer_meeting.dart';
import 'package:o_connect/ui/views/webninar_dashboard/presentation/create_webinar/create_webinar_screen.dart';
import 'package:provider/provider.dart';
import '../../../../core/providers/app_global_state_provider.dart';
import '../../../utils/colors/colors.dart';
import '../../../utils/images/images.dart';
import '../../../utils/textfield_helper/app_fonts.dart';
import '../webinar_details_model/meeting_details_model.dart';
import 'cancel_meeting.dart';

class UpcomingMoreButton extends StatelessWidget {
  final MeetingDetailsModel? dataList;

  const UpcomingMoreButton({super.key, required this.dataList});

  @override
  Widget build(BuildContext context) {
    final meetingDate = DateTime.tryParse(dataList!.meetingDate.toString());
    final pastMeetingTime = meetingDate != null && DateTime.now().isAfter(meetingDate);

    return Consumer<AppGlobalStateProvider>(builder: (context, appGlobalStateProvider, __) {
      return Column(
        children: [
          showDialogCustomHeader(context, headerTitle: "More"),
          Expanded(
            child: Padding(
              padding: EdgeInsets.only(left: 20.w, right: 20.w, top: 10.h),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  (!pastMeetingTime && (dataList?.isStarted != null && (dataList?.isStarted == 1 || dataList?.isStarted == 2)))
                      ? const SizedBox.shrink()
                      : BuildRowWidget(
                          text: "Edit",
                          imagepath: AppImages.editIcon,
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
                                              meetingDetailsModel: dataList,
                                              isEdit: true,
                                              eventId: dataList?.id ?? "",
                                            ))));
                              }
                            }
                          },
                        ),
                  BuildRowWidget(
                      text: "Save as template",
                      imagepath: AppImages.saveAsTemplateIcon,
                      onTap: () {
                        Navigator.pop(context);
                        customShowDialog(
                          context,
                          SaveAsTemplate(dataList: dataList!),
                        );
                      }),
                  (!pastMeetingTime && (dataList?.isStarted != null && (dataList?.isStarted == 1 || dataList?.isStarted == 2)))
                      ? const SizedBox.shrink()
                      : BuildRowWidget(
                          text: "Transfer",
                          imagepath: AppImages.trasferIcon,
                          onTap: () {
                            // CustomToast.showInfoToast(msg: "Coming soon...");
                            Navigator.pop(context);
                            customShowDialog(
                              context,
                              TransferPopup(
                                dataList: dataList!,
                              ),
                            );
                          }),
                  (!pastMeetingTime && (dataList?.isStarted != null && (dataList?.isStarted == 1 || dataList?.isStarted == 2)))
                      ? const SizedBox.shrink()
                      : BuildRowWidget(
                          text: "Cancel",
                          imagepath: AppImages.deleteImage,
                          onTap: () {
                            Navigator.pop(context);
                            customShowDialog(
                              context,
                              CancelMeetingPopup(dataList: dataList!),
                            );
                          }),
                ],
              ),
            ),
          ),
          const CloseWidget()
        ],
      );
    });
  }
}

class BuildRowWidget extends StatelessWidget {
  const BuildRowWidget({super.key, required this.text, required this.imagepath, this.onTap});

  final String text;
  final String imagepath;
  final Function()? onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: SizedBox(
        width: MediaQuery.of(context).size.width * 1,
        height: 40.h,
        child: Row(
          children: [
            SizedBox(
              height: 20.w,
              width: 20.w,
              child: SvgPicture.asset(
                imagepath,
                color: const Color(0xff8186B3),
              ),
            ),
            width20,
            Text(
              text,
              style: w400_14Poppins(color: Theme.of(context).primaryColorLight),
            ),
          ],
        ),
      ),
    );
  }
}
