import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:o_connect/ui/utils/custom_show_dialog_helper/custom_show_dialog.dart';
import 'package:o_connect/ui/views/webninar_dashboard/presentation/create_webinar/provider/create_webinar_provider.dart';
import 'package:provider/provider.dart';

import '../../../../../../core/models/create_webinar_model/create_webinar_response_model.dart';
import '../../../../../utils/buttons_helper/custom_botton.dart';
import '../../../../../utils/buttons_helper/custom_outline_button.dart';
import '../../../../../utils/colors/colors.dart';
import '../../../../../utils/constant_strings.dart';
import '../../../../../utils/textfield_helper/app_fonts.dart';

class ConflictAlertPopup extends StatelessWidget {
  const ConflictAlertPopup(
      {super.key,
      required this.name,
      required this.agenda,
      required this.exitURl,
      required this.password,
      required this.duration,
      required this.dateTime,
      required this.context,
      this.editedDataInUpcoming,
      this.editedDataInCalender});

  final String name;
  final String agenda;
  final String exitURl;
  final String password;
  final BuildContext context;
  final String duration;
  final DateTime dateTime;

  final CreateWebinarResponseData? editedDataInUpcoming;
  final dynamic editedDataInCalender;

  @override
  Widget build(BuildContext context) {
    return Column(children: [
      showDialogCustomHeader(context, headerTitle: "Meeting Conflict Alert"),
      height20,
      Text(
          "This meeting time is conflicting with other meeting \n             Do you want to process?",
          style: w400_14Poppins(color: Theme.of(context).primaryColorLight)),
      height20,
      Padding(
          padding: EdgeInsets.only(right: 15.w, top: 5.h, bottom: 5.h),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              CustomOutlinedButton(
                height: 35.h,
                width: 100.w,
                buttonTextStyle: w400_13Poppins(color: AppColors.mainBlueColor),
                buttonText: ConstantsStrings.cancel,
                onTap: () {
                  Navigator.pop(context);
                },
              ),
              width10,
              CustomButton(
                width: 80.w,
                height: 35.h,
                buttonText: "Ok",
                buttonTextStyle: w500_13Poppins(color: AppColors.whiteColor),
                onTap: () {
                  context.read<CreateWebinarProvider>().updateConflictMeeting();
                  context.read<CreateWebinarProvider>().sendCreateWebinarData(
                      name: name,
                      agenda: agenda,
                      exitURl: exitURl,
                      context: context,
                      password: password,
                      duration: duration,
                      dateTime: dateTime,
                      editedDataInCalender: editedDataInCalender,
                      editedDataInUpcoming: editedDataInUpcoming,
                      isFromConflictsPopUp: true);
                },
              )
            ],
          ))
    ]);
  }
}
