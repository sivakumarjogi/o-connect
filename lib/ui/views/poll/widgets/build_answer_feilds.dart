import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:o_connect/ui/utils/images/images.dart';
import 'package:o_connect/ui/views/poll/provider/poll_provider.dart';
import 'package:o_connect/ui/views/poll/widgets/dynamic_textfield.dart';
import 'package:o_connect/ui/views/themes/providers/webinar_themes_provider.dart';
import 'package:provider/provider.dart';

class BuildAnswerFields extends StatelessWidget {
  const BuildAnswerFields({
    super.key,
    required this.answerIndex,
    required this.questionIndex,
  });

  final int questionIndex;
  final int answerIndex;

  @override
  Widget build(BuildContext context) {
    return Consumer2<PollProvider, WebinarThemesProviders>(builder: (context, pollProvider, webinarThemesProviders, child) {
      return Padding(
        padding: EdgeInsets.symmetric(vertical: 5.h),
        child: DynamicTextField(
          controller: pollProvider.answerControllersList[questionIndex][answerIndex],
          icon: (answerIndex == 0 || answerIndex == 1)
              ? const SizedBox()
              : GestureDetector(
                  onTap: () {
                    pollProvider.removeAnswersFields(
                      answerIndex: answerIndex,
                      questionIndex: questionIndex,
                    );
                  },
                  child: Padding(
                    padding: EdgeInsets.all(14.sp),
                    child: SvgPicture.asset(
                      AppImages.delete,
                      color: context.watch<WebinarThemesProviders>().colors.textColor,
                    ),
                  ),
                ),
          hintText: 'Answer ${answerIndex + 1}',
          fillColor: webinarThemesProviders.colors.itemColor,
        ),
      );
    });
  }
}
