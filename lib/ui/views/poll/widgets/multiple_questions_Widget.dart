import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:o_connect/ui/utils/colors/colors.dart';
import 'package:o_connect/ui/utils/images/images.dart';
import 'package:o_connect/ui/views/poll/provider/poll_provider.dart';
import 'package:o_connect/ui/views/poll/widgets/build_answer_feilds.dart';
import 'package:o_connect/ui/views/themes/providers/webinar_themes_provider.dart';
import 'package:provider/provider.dart';
import '../../../utils/constant_strings.dart';
import '../../../utils/textfield_helper/app_fonts.dart';
import 'dynamic_textfield.dart';

class MultipleQuestionsTextField extends StatefulWidget {
  const MultipleQuestionsTextField({super.key});

  @override
  State<MultipleQuestionsTextField> createState() => _MultipleQuestionsTextFieldState();
}

class _MultipleQuestionsTextFieldState extends State<MultipleQuestionsTextField> {
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Consumer2<PollProvider, WebinarThemesProviders>(builder: (context, pollProvider, webinarThemesProvider, child) {
        return Column(
          children: List.generate(pollProvider.questionWidgets.length, (index) => QuestionsField(questionIndex: index)),
        );
      }),
    );
  }
}

class QuestionsField extends StatelessWidget {
  const QuestionsField({super.key, required this.questionIndex});

  final int questionIndex;

  @override
  Widget build(BuildContext context) {
    return Consumer2<PollProvider, WebinarThemesProviders>(builder: (context, pollProvider, webinarThemesProviders, child) {
      return Container(
        padding: EdgeInsets.symmetric(horizontal: 16.w),
        margin: EdgeInsets.only(bottom: 5.h),
        decoration: BoxDecoration(color: webinarThemesProviders.colors.bodyColor, borderRadius: BorderRadius.circular(5.r)),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            height10,
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "Question-${questionIndex + 1}",
                  style: w400_12Poppins(color: Theme.of(context).primaryColorLight),
                ),
                if (pollProvider.questionWidgets.length > 1)
                  InkWell(
                    onTap: () {
                      pollProvider.removeQuestion(questionIndex);
                    },
                    borderRadius: BorderRadius.circular(15),
                    child: SvgPicture.asset(
                      AppImages.delete,
                      color: context.watch<WebinarThemesProviders>().colors.textColor,
                    ),
                  )
              ],
            ),
            height5,
            DynamicTextField(
              icon: const SizedBox(),
              controller: pollProvider.questionControllers[questionIndex],
              hintText: ConstantsStrings.typeQuestion,
              fillColor: webinarThemesProviders.colors.itemColor,
            ),
            height5,
            Row(
              children: [
                Radio(
                  value: pollProvider.radioButtonValue[questionIndex].multiPleChoice,
                  activeColor: context.watch<WebinarThemesProviders>().colors.buttonColor,
                  groupValue: pollProvider.radioButtonGroupValues[questionIndex],
                  onChanged: (val) {
                    pollProvider.toggleRadioButton(questionIndex, val!);
                  },
                ),
                Text(
                  ConstantsStrings.multipleChoice,
                  style: w400_12Poppins(color: Theme.of(context).primaryColorLight),
                ),
                height15,
                Radio(
                  value: pollProvider.radioButtonValue[questionIndex].open,
                  activeColor: context.watch<WebinarThemesProviders>().colors.buttonColor,
                  groupValue: pollProvider.radioButtonGroupValues[questionIndex],
                  onChanged: (val) {
                    pollProvider.toggleRadioButton(questionIndex, val!);
                  },
                ),
                Text(
                  ConstantsStrings.open,
                  style: w400_12Poppins(color: Theme.of(context).primaryColorLight),
                ),
              ],
            ),
            Visibility(
              visible: pollProvider.radioButtonGroupValues[questionIndex].contains("multipleChoice"),
              child: Column(
                children: [
                  /* ...pollProvider.answerWidgetsList[index],*/
                  Wrap(
                    spacing: 8.0,
                    runSpacing: 8.0,
                    children: List.generate(
                      pollProvider.answerWidgetsList[questionIndex].length,
                      (answerIndex) => BuildAnswerFields(questionIndex: questionIndex, answerIndex: answerIndex),
                    ),
                  ),
                  height10,
                  GestureDetector(
                      onTap: () {
                        pollProvider.addAnswerField(questionIndex);
                      },
                      child: addAnswerWidget()),
                  height10,
                ],
              ),
            ),
          ],
        ),
      );
    });
  }

  Widget addAnswerWidget() {
    return Align(
      alignment: Alignment.center,
      child: Container(
        width: 120.w,
        height: 30.h,
        decoration: BoxDecoration(
          color: const Color(0x3303BAF5),
          borderRadius: BorderRadius.circular(5.r),
        ),
        child: Center(
            child: RichText(
                text: TextSpan(text: ConstantsStrings.addAnswer, style: w400_14Poppins(color: AppColors.mainBlueColor), children: [
          TextSpan(
            text: ConstantsStrings.plus,
            style: w500_16Poppins(
              color: Colors.grey,
            ),
          )
        ]))),
      ),
    );
  }
}
