import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:lottie/lottie.dart';
import 'package:o_connect/ui/views/home_screen/home_screen_provider/home_screen_provider.dart';
import 'package:provider/provider.dart';
import '../../../../core/providers/calender_provider.dart';
import '../../../utils/buttons_helper/custom_botton.dart';
import '../../../utils/buttons_helper/custom_outline_button.dart';
import '../../../utils/colors/colors.dart';
import '../../../utils/constant_strings.dart';
import '../../../utils/custom_show_dialog_helper/custom_show_dialog.dart';
import '../../../utils/images/images.dart';
import '../../../utils/textfield_helper/app_fonts.dart';
import '../../../utils/textfield_helper/common_textfield.dart';
import '../../authentication/form_validations.dart';

class NewCalendarCancelMeetingPopup extends StatefulWidget {
  const NewCalendarCancelMeetingPopup({super.key,required this.meetingId,required this.userName,required this.emailId});

  final String meetingId;
  final String emailId;
  final String userName;

  @override
  State<NewCalendarCancelMeetingPopup> createState() => _NewCalanderCancelMeetingPopupState();
}

class _NewCalanderCancelMeetingPopupState extends State<NewCalendarCancelMeetingPopup> {
  TextEditingController cancelMeetingController = TextEditingController();
  final GlobalKey<FormState> _key = GlobalKey<FormState>();

  @override
  void dispose() {
    cancelMeetingController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<HomeScreenProvider>(builder: (context, homeScreenProvider, child) {
      return Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.only(topRight: Radius.circular(24.r), topLeft: Radius.circular(24.r)),
          color:
          Theme.of(context).cardColor,),
        child: Form(
          key: _key,
          autovalidateMode: AutovalidateMode.onUserInteraction,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              showDialogCustomHeader(context, headerTitle: ConstantsStrings.cancelMeeting,headerColor:const Color(0xff202223),),
              Padding(
                padding: EdgeInsets.all(10.sp),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    height10,
                    Text(
                      ConstantsStrings.cancelMeetingText,
                      style: w400_14Poppins(color:const Color(0xffC7C9D1)),
                    ),
                    height10,
                    CommonTextFormField(
                      controller: cancelMeetingController,
                      hintText: "Cancel reason",
                      maxLines: 3,
                      numberOfchars: 50,
                      maxLength: 50,
                      validator: (val, String? fieldName) {
                        return FormValidations.requiredFieldValidationInCreateWithMinimumCharecters(val, "Cancel reason");
                      },
                      style: w400_14Poppins(color: Colors.white),
                      keyboardType: TextInputType.text,
                      fillColor: Theme.of(context).scaffoldBackgroundColor,
                    ),
                    height20,
                    homeScreenProvider.cancelMeeting
                        ? Padding(
                      padding: EdgeInsets.only(bottom: 10.h),
                      child:  Center(child:Lottie.asset(AppImages.loadingJson, height: 40.w, width: 40.w)),
                    )
                        : Padding(
                      padding: EdgeInsets.only(right: 10.w, bottom: 5.h),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          CustomOutlinedButton(
                            height: 35.h,
                            width: MediaQuery.of(context).size.width/2-30.sp,
                            buttonTextStyle: w400_13Poppins(color: AppColors.mainBlueColor),
                            buttonText: ConstantsStrings.cancel,
                            onTap: () {
                              Navigator.pop(context);
                            },
                          ),
                          width20,
                          CustomButton(
                              width: MediaQuery.of(context).size.width/2-30.sp,
                              height: 35.h,
                              buttonText: ConstantsStrings.ok,
                              buttonTextStyle: w500_13Poppins(color: AppColors.whiteColor),
                              onTap: () {
                                FocusNode().unfocus();
                                if (_key.currentState!.validate()) {
                                  homeScreenProvider.deleteMeeting(
                                      meetingId: widget.meetingId,userName: widget.userName, emailId: widget.emailId, reason: cancelMeetingController.text, context: context).then((value) {

                                    CalenderProvider      cp = Provider.of<CalenderProvider>(context, listen: false);

                                    cp.fetchEventsAccordingToDate(context,
                                        startTime: DateTime(cp.selectedDay.year, cp.selectedDay.month, 1),
                                        endTime: DateTime(cp.selectedDay.year, cp.selectedDay.month + 1, 0),
                                        multipleSelectedCon: cp.multipleSelected,
                                        filterApplyEvent: cp.multipleSelectedEvent) ;

                                  }
                                  );
                                  // Navigator.pop(context);
                                }
                                //
                              })
                        ],
                      ),
                    )
                  ],
                ),
              ),

            ],
          ),
        ),
      );
    });
  }
}
