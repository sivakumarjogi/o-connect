import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';

import '../../../../../core/providers/library_provider.dart';
import '../../../../utils/buttons_helper/custom_botton.dart';
import '../../../../utils/buttons_helper/custom_outline_button.dart';
import '../../../../utils/colors/colors.dart';
import '../../../../utils/constant_strings.dart';
import '../../../../utils/custom_show_dialog_helper/custom_show_dialog.dart';
import '../../../../utils/textfield_helper/app_fonts.dart';

class ConfirmDeletePopup extends StatelessWidget {
  const ConfirmDeletePopup({
    super.key,
    required this.id,
  });

  final String id;

  @override
  Widget build(BuildContext context) {
    return Column(mainAxisSize: MainAxisSize.min, children: [
      height5,
      showDialogCustomHeader(context, headerTitle: "Delete"),
      height20,
      Text("Are you sure to Delete?", style: w400_14Poppins(color: Colors.blue)),
      height20,
      Text("Select file will get deleted permanently!", style: w400_14Poppins(color: Colors.white)),
      Text("Would you like to continue?", style: w400_14Poppins(color: Colors.white)),
      height20,
      Padding(
          padding: EdgeInsets.only(right: 15.w, bottom: 5.h),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              CustomOutlinedButton(
                height: 35.h,
                buttonTextStyle: w400_13Poppins(color: Colors.white),
                buttonText: ConstantsStrings.cancel,
                onTap: () {
                  Navigator.pop(context);
                },
              ),
              width10,
              CustomButton(
                width: 100.w,
                height: 35.h,
                buttonText: "Delete",
                buttonTextStyle: w500_13Poppins(color: AppColors.whiteColor),
                onTap: () async {
                  await Provider.of<LibraryProvider>(context, listen: false).deletePresentation(id,context);
                },
              )
            ],
          ))
    ]);
  }
}
