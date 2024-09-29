import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:o_connect/ui/utils/colors/colors.dart';
import 'package:o_connect/ui/utils/constant_strings.dart';
import 'package:o_connect/ui/utils/custom_show_dialog_helper/custom_show_dialog.dart';
import 'package:o_connect/ui/utils/textfield_helper/app_fonts.dart';
import 'package:o_connect/ui/utils/textfield_helper/common_textfield.dart';
import 'package:o_connect/ui/views/authentication/form_validations.dart';
import 'package:o_connect/ui/views/meeting/utils/context_ext.dart';
import 'package:o_connect/ui/views/poll/provider/poll_provider.dart';
import 'package:o_connect/ui/views/themes/providers/webinar_themes_provider.dart';
import 'package:o_connect/ui/views/webinar_details/webinar_details_provider/webinar_provider.dart';
import 'package:provider/provider.dart';

import '../../utils/buttons_helper/custom_botton.dart';
import '../../utils/buttons_helper/custom_outline_button.dart';
import '../../utils/images/images.dart';
import 'widgets/multiple_questions_Widget.dart';

class CreatePollScreen extends StatefulWidget {
  const CreatePollScreen({super.key, this.isEdit = false, this.index});

  final bool isEdit;
  final int? index;

  @override
  State<CreatePollScreen> createState() => _CreatePollScreenState();
}

class _CreatePollScreenState extends State<CreatePollScreen> {
  late WebinarProvider webinarProvider;
  late PollProvider pollProvider;

  final GlobalKey<FormState> _formKey = GlobalKey();

  @override
  void initState() {
    webinarProvider = Provider.of<WebinarProvider>(context, listen: false);
    pollProvider = Provider.of<PollProvider>(context, listen: false);
    if (widget.isEdit) {
      pollProvider.setInitialValuesForEditPoll(widget.index ?? 0);
    } else {
      pollProvider.addQuestionField();
    }

    super.initState();
  }

  @override
  void dispose() {
    pollProvider.disposeControllers();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        pollProvider.clearData();
        return true;
      },
      child: Consumer2<PollProvider, WebinarThemesProviders>(builder: (key, pollProvider, webinarThemesProvider, child) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Expanded(
              child: Form(
                key: _formKey,
                child: Column(children: [
                  showDialogCustomHeader(context, headerTitle: "New Poll ", backButtonFuc: () {
                    pollProvider.clearData();
                    Navigator.pop(context);
                  }),
                  Padding(
                    padding: EdgeInsets.only(top: 10.h, left: 16.w, right: 10.w),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Title",
                          style: w400_14Poppins(color: webinarThemesProvider.colors.textColor),
                        ),
                        height5,
                        CommonTextFormField(
                            fillColor: webinarThemesProvider.headerNotchColor,
                            controller: pollProvider.surveyController,
                            hintText: ConstantsStrings.typeSurveyName,
                            allowSpace: true,
                            validator: (val, String? f) {
                              return FormValidations.requiredFieldValidation(val, "This field is required");
                            },
                            keyboardType: TextInputType.text,
                            inputAction: TextInputAction.next),
                        height15,
                        Container(
                          decoration: BoxDecoration(
                              color: webinarThemesProvider.headerNotchColor,
                              border: Border.all(width: 1, color: webinarThemesProvider.hintTextColor),
                              borderRadius: BorderRadius.all(
                                Radius.circular(4.r),
                              )),
                          child: Padding(
                            padding: EdgeInsets.all(10.0.sp),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  "${pollProvider.surveyTime.toString()} mins",
                                  style: w400_14Poppins(color: Colors.white),
                                ),
                                PopupMenuButton<int>(
                                  shadowColor: Colors.red,
                                  itemBuilder: (context) => [
                                    PopupMenuItem(
                                      onTap: () {
                                        pollProvider.pollTime(5);
                                      },
                                      value: 1,
                                      child: Text("5 mins", style: w400_14Poppins(color: Colors.white)),
                                    ),
                                    // popupmenu item 2
                                    PopupMenuItem(
                                      onTap: () {
                                        pollProvider.pollTime(10);
                                      },
                                      value: 2,
                                      child: Text("10 mins", style: w400_14Poppins(color: Colors.white)),
                                    ),
                                    PopupMenuItem(
                                      onTap: () {
                                        pollProvider.pollTime(15);
                                      },
                                      value: 3,
                                      child: Text("15 mins", style: w400_14Poppins(color: Colors.white)),
                                    ),
                                    PopupMenuItem(
                                      onTap: () {
                                        pollProvider.pollTime(20);
                                      },
                                      value: 4,
                                      child: Text("20 mins", style: w400_14Poppins(color: Colors.white)),
                                    ),
                                    PopupMenuItem(
                                      onTap: () {
                                        pollProvider.pollTime(25);
                                      },
                                      value: 5,
                                      child: Text("25 mins", style: w400_14Poppins(color: Colors.white)),
                                    ),
                                    PopupMenuItem(
                                      onTap: () {
                                        pollProvider.pollTime(30);
                                      },
                                      value: 6,
                                      child: Text(
                                        "30 mins",
                                        style: w400_14Poppins(color: Colors.white),
                                      ),
                                    ),
                                  ],
                                  offset: const Offset(0, 40),
                                  color: Colors.grey,
                                  elevation: 2,
                                  child: Icon(
                                    Icons.watch_later_outlined,
                                    color: webinarThemesProvider.hintTextColor,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        )
                      ],
                    ),
                  ),
                  height15,
                  Expanded(
                    child: Padding(
                      padding: EdgeInsets.symmetric(horizontal: 16.w),
                      child: const MultipleQuestionsTextField(),
                    ),
                  ),
                  height15,
                ]),
              ),
            ),
            !pollProvider.createPollLoading
                ? Padding(
                    padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 5.h),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        GestureDetector(
                          onTap: () {
                            pollProvider.addQuestions(pollProvider.questionControllers.length);
                          },
                          child: Container(
                            width: 130.w,
                            height: 35.h,
                            decoration: BoxDecoration(
                              color: webinarThemesProvider.themeHighLighter?.withOpacity(0.1) ?? const Color(0x3303BAF5),
                              borderRadius: BorderRadius.circular(3.r),
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(ConstantsStrings.addQuestion,
                                    style: w400_13Poppins(
                                      color: webinarThemesProvider.themeHighLighter != null ? Theme.of(context).primaryColorLight : AppColors.mainBlueColor,
                                    )),
                                Icon(
                                  Icons.add,
                                  color: webinarThemesProvider.themeHighLighter != null ? Theme.of(context).primaryColorLight : AppColors.mainBlueColor,
                                )
                              ],
                            ),
                          ),
                        ),
                        Row(
                          children: [
                            CustomOutlinedButton(
                              outLineBorderColor: webinarThemesProvider.colors.textColor,
                              height: 35.h,
                              width: 100.w,
                              buttonTextStyle: w400_13Poppins(color: webinarThemesProvider.colors.textColor),
                              buttonText: ConstantsStrings.cancel,
                              onTap: () {
                                pollProvider.clearData();
                                Navigator.pop(context);
                              },
                            ),
                            width10,
                            Consumer<WebinarProvider>(builder: (context, provider, child) {
                              return CustomButton(
                                buttonColor: webinarThemesProvider.colors.buttonColor,
                                width: 80.w,
                                height: 35.h,
                                buttonText: widget.isEdit ? "Update" : ConstantsStrings.create,
                                buttonTextStyle: w500_13Poppins(color: AppColors.whiteColor),
                                onTap: () {
                                  if (_formKey.currentState!.validate()) {
                                    pollProvider.createOrEditPoll(isEdit: widget.isEdit);
                                  }
                                  FocusScope.of(context).unfocus();
                                },
                              );
                            }),
                          ],
                        ),
                      ],
                    ),
                  )
                : SizedBox(
                    height: 20.w,
                    width: 20.w,
                    child: const CircularProgressIndicator(
                      color: Colors.white,
                    ),
                  ),
          ],
        );
      }),
    );
  }
}
