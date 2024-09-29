import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:o_connect/core/screen_configs.dart';
import 'package:o_connect/ui/views/poll/provider/poll_provider.dart';
import 'package:percent_indicator/percent_indicator.dart';
import 'package:provider/provider.dart';

import '../../../utils/colors/colors.dart';
import '../../../utils/textfield_helper/app_fonts.dart';

class PollDisplayQuestions extends StatelessWidget {
  const PollDisplayQuestions({super.key, required this.question, required this.questionIndex});
  final String question;
  final int questionIndex;
  @override
  Widget build(BuildContext context) {
    return Consumer<PollProvider>(builder: (context, pollProvider, child) {
      return Padding(
        padding: EdgeInsets.symmetric(horizontal: 15.w, vertical: 4.h),
        child: Container(
            decoration: BoxDecoration(borderRadius: BorderRadius.circular(5.r), color: Theme.of(context).scaffoldBackgroundColor),
            width: ScreenConfig.width - 25.w,
            // height: 160.h,
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Align(
                        alignment: Alignment.topLeft,
                        child: RichText(
                          text: TextSpan(children: [
                            TextSpan(
                              text: question,
                              style: w500_12Poppins(color: AppColors.mainBlueColor),
                            ),
                            TextSpan(
                                text: pollProvider.pollListeners.pollQuestions[questionIndex].questionType.toString() != "single"
                                    ? "  (${pollProvider.pollListeners.pollResults[pollProvider.pollListeners.pollQuestions[questionIndex].id]?["questionTotal"] ?? "0"})"
                                    : ""),
                          ]),
                        ),
                      ),
                      ...List.generate(
                        pollProvider.pollListeners.pollQuestions[questionIndex].options.length ?? 0,
                        (optionIndex) {
                          return Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Padding(
                                padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 2.0),
                                child: Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      pollProvider.pollListeners.pollQuestions[questionIndex].options[optionIndex].ansOption ?? "",
                                      style: w400_10Poppins(color: Theme.of(context).primaryColorLight),
                                    ),
                                    Text(
                                      "${calculatePercentage(questionIndex, optionIndex, pollProvider) == 0 ? "" : "${calculatePercentage(questionIndex, optionIndex, pollProvider).toString()}%"}${"(${checkOptionCount(questionIndex, optionIndex, pollProvider).toString()} votes)"}",
                                      style: w400_10Poppins(color: Theme.of(context).disabledColor),
                                    ),
                                  ],
                                ),
                              ),
                              LinearPercentIndicator(
                                animation: true,
                                lineHeight: 6.0,
                                animationDuration: 2000,
                                percent: calculatePercentage(questionIndex, optionIndex, pollProvider) / 100,
                                barRadius: Radius.circular(10.r),
                                linearStrokeCap: LinearStrokeCap.roundAll,
                                progressColor: const Color.fromARGB(255, 126, 226, 107),
                              ),
                              height10
                            ],
                          );
                        },
                      )
                    ],
                  ),
                ],
              ),
            )),
      );
    });
  }

  String checkOptionCount(int questionIndex, int optionIndex, PollProvider pollProvider) {
    var optionMap;
    if (pollProvider.pollListeners.pollResults.isNotEmpty) {
      if (pollProvider.pollListeners.pollResults.containsKey(pollProvider.pollListeners.pollQuestions[questionIndex].id)) {
        optionMap = pollProvider.pollListeners.pollResults[pollProvider.pollListeners.pollQuestions[questionIndex].id][pollProvider.pollListeners.pollQuestions[questionIndex].options[optionIndex].id];
      }
    }

    if (optionMap != null) {
      return optionMap["total"].toString();
    }
    return "";
  }

  double calculatePercentage(int questionIndex, int optionIndex, PollProvider pollProvider) {
    var optionMap;
    if (pollProvider.pollListeners.pollResults.isNotEmpty) {
      if (pollProvider.pollListeners.pollResults.containsKey(pollProvider.pollListeners.pollQuestions[questionIndex].id)) {
        optionMap = pollProvider.pollListeners.pollResults[pollProvider.pollListeners.pollQuestions[questionIndex].id][pollProvider.pollListeners.pollQuestions[questionIndex].options[optionIndex].id];
      }
    }

    if (optionMap != null) {
      var percentage = optionMap["total"] / pollProvider.pollListeners.pollResults[pollProvider.pollListeners.pollQuestions[questionIndex].id]["questionTotal"] * 100;
      if (percentage.isNaN) {
        return 0;
      }
      return percentage;
    }
    return 0;
  }
}
