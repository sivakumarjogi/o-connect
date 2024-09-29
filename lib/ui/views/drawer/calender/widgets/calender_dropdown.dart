import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:o_connect/core/providers/calender_provider.dart';
import 'package:o_connect/ui/utils/close_widget.dart';
import 'package:o_connect/ui/utils/colors/colors.dart';
import 'package:o_connect/ui/utils/custom_show_dialog_helper/custom_show_dialog.dart';
import 'package:o_connect/ui/utils/textfield_helper/app_fonts.dart';
import 'package:provider/provider.dart';
import '../../../../../core/models/dummy_models/dummy_model.dart';
import '../../../../utils/cancel_ok_buttons.dart';

class CalenderDropDownPopup extends StatefulWidget {
  const CalenderDropDownPopup({super.key});

  @override
  State<CalenderDropDownPopup> createState() => _CalenderDropDownPopupState();
}

class _CalenderDropDownPopupState extends State<CalenderDropDownPopup> {
  late CalenderProvider cp;

  @override
  void initState() {
    cp = Provider.of<CalenderProvider>(context, listen: false);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: true,
      onPopInvoked: (didPop) {
        cp.clearAllFields();
      },
      child: Consumer<CalenderProvider>(builder: (context, calenderProvider, child) {
        return Column(
          children: [
            showDialogCustomHeader(context, headerTitle: "Select", headerColor: AppColors.popUpBGColor),
            Column(
              children: List.generate(
                checkboxList.length,
                (index) => Container(
                  margin: EdgeInsets.symmetric(horizontal: 16.w, vertical: 2.h),
                  decoration: BoxDecoration(color: AppColors.mediumBG, borderRadius: BorderRadius.circular(3.r)),
                  child: CheckboxListTile(
                    controlAffinity: ListTileControlAffinity.leading,
                    contentPadding: EdgeInsets.zero,
                    visualDensity: const VisualDensity(horizontal: VisualDensity.minimumDensity),
                    dense: true,
                    title: Text(
                      checkboxList[index].checkboxText,
                      style: w400_14Poppins(color: Theme.of(context).primaryColorLight),
                    ),
                    checkColor: AppColors.whiteColor,
                    side: const BorderSide(color: AppColors.mainBlueColor),
                    activeColor: AppColors.mainBlueColor,
                    value: checkboxList[index].isCheck,
                    onChanged: (value) {
                      // calenderProvider.updateCheckboxListIndex(value!, index);
                      calenderProvider.updateSelectedOptions(value!, index);
                    },
                  ),
                ),
              ),
            ),
            CancelOkButtons(okTap: () async {
              calenderProvider.allowSelection();
              Navigator.pop(context);
            }, cancelTap: () async {
              calenderProvider.clearAllFields();
              Navigator.pop(context);
            }),
          ],
        );
      }),
    );
  }
}
