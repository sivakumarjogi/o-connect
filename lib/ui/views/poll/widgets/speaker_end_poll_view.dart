import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:o_connect/core/screen_configs.dart';
import 'package:o_connect/ui/utils/buttons_helper/custom_botton.dart';
import 'package:o_connect/ui/utils/colors/colors.dart';
import 'package:o_connect/ui/utils/images/images.dart';
import 'package:o_connect/ui/utils/textfield_helper/app_fonts.dart';
import 'package:o_connect/ui/utils/textfield_helper/common_textfield.dart';
import 'package:o_connect/ui/views/poll/provider/poll_provider.dart';
import 'package:provider/provider.dart';

class SpeakerEndPollView extends StatelessWidget {
  const SpeakerEndPollView({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Theme.of(context).primaryColor,
      height: 520.h,
      width: ScreenConfig.width,
      child: Builder(builder: (context) {
        bool isSubmitted = context.select<PollProvider, bool>((pollProvider) => pollProvider.pollSpeakerSocketEmitEvents.answers.isEmpty);

        return !isSubmitted 
            ? SingleChildScrollView(
                child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                  const Text("Test Poll"),
                  height5,
                  Builder(builder: (context) {
                    String totalQuestions = context.select<PollProvider, String>((pollProvider) => pollProvider.pollListeners.pollQuestions.length.toString());
                    return Text("Total Questions: $totalQuestions");
                  }),

                  Builder(builder: (context) {
                    int totalQuestions = context.select<PollProvider, int>((pollProvider) => pollProvider.pollListeners.pollQuestions.length);
                    return Column(
                      children: List.generate(
                          totalQuestions,
                          (index) => DisplayPollQuestions(
                                questionIndex: index,
                              )),
                    );
                  }),

                  Builder(builder: (context) {
                    bool submitted = context.select<PollProvider, bool>((pollProvider) => pollProvider.pollSpeakerSocketEmitEvents.submitAnswersLoading);
                    return Center(
                      child: CustomButton(
                        width: ScreenConfig.width * 0.7,
                        isLoading: submitted,
                        buttonText: "Submit",
                        onTap: () {
                          Provider.of<PollProvider>(context, listen: false).pollSpeakerSocketEmitEvents.speakerSubmitAnswersGlobalSetStatus();
                        },
                      ),
                    );
                  })
                  // const Stack(
                  //   children: [MinimizedVideoCallView()],
                  // )
                ]),
              )
            : Center(
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 50.w),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      SvgPicture.asset(AppImages.greenCheckIcon),
                      height10,
                      Consumer<PollProvider>(
                        builder: (_, pollProvider, __) {
                          return Column(
                            children: [
                              if (!pollProvider.pollListeners.pollVotingEnded) ...[
                                Text(
                                  "Thank you for your participation in the survey.",
                                  style: w400_14Poppins(color: const Color(0xff37AC00)),
                                  textAlign: TextAlign.center,
                                ),
                                height10,
                                Text(
                                  "Your answers were shared with the host.Please wait for the event to resume.",
                                  style: w400_12Poppins(color: Colors.white),
                                  textAlign: TextAlign.center,
                                )
                              ] else
                                Text(
                                  "Voting Time has Expired. Thank you for Voting",
                                  style: w400_12Poppins(color: Colors.white),
                                  textAlign: TextAlign.center,
                                )
                            ],
                          );
                        },
                      ),
                    ],
                  ),
                ),
              );
      }),
    );
  }
}

class DisplayPollQuestions extends StatelessWidget {
  const DisplayPollQuestions({super.key, required this.questionIndex});

  final int questionIndex;

  @override
  Widget build(BuildContext context) {
    return Consumer<PollProvider>(builder: (_, pollProvider, __) {
      return SingleChildScrollView(
        child: Container(
          width: ScreenConfig.width,
          margin: EdgeInsets.symmetric(horizontal: 16.w, vertical: 10.h),
          padding: EdgeInsets.symmetric(vertical: 5.h, horizontal: 15.w),
          decoration: BoxDecoration(color: Theme.of(context).scaffoldBackgroundColor, borderRadius: BorderRadius.circular(8.r)),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              height5,
              Row(
                children: [
                  CircleAvatar(
                    backgroundColor: Colors.green,
                    radius: 11.r,
                    child: Text(
                      "${questionIndex + 1}",
                      style: w400_10Poppins(color: Colors.white),
                    ),
                  ),
                  width5,
                  Builder(builder: (context) {
                    String question = context.select<PollProvider, String>((pollProvider) => pollProvider.pollListeners.pollQuestions[questionIndex].question.toString());
                    return Text(question);
                  }),
                ],
              ),
              Builder(builder: (context) {
                String questionType = context.select<PollProvider, String>((pollProvider) => pollProvider.pollListeners.pollQuestions[questionIndex].questionType.toString());
                return Column(
                  children: [
                    height5,
                    if (questionType == "single")
                      ...List.generate(
                          pollProvider.pollListeners.pollQuestions[questionIndex].options.length,
                          (optionIndex) => Row(
                                children: [
                                  Radio(
                                      materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                                      visualDensity: const VisualDensity(horizontal: 0, vertical: 0),
                                      value: pollProvider.pollListeners.pollQuestions[questionIndex].options[optionIndex].id.toString(),
                                      groupValue: pollProvider.pollSpeakerSocketEmitEvents.answers[questionIndex].optionId /*pollProvider.pollSpeakerSocketEmitEvents.answers[questionIndex].optionId*/,
                                      onChanged: (val) {
                                        print("the radio values $questionIndex $optionIndex $val");
                                        pollProvider.pollSpeakerSocketEmitEvents.updateAnswers(questionIndex, val!);
                                      }),
                                  Text(pollProvider.pollListeners.pollQuestions[questionIndex].options[optionIndex].ansOption.toString() ?? "N/A")
                                ],
                              ))
                    else ...[
                      height5,
                      CommonTextFormField(
                        style: w400_14Poppins(color: Colors.black),
                        onChanged: (String value) {
                          pollProvider.pollSpeakerSocketEmitEvents.updateAnswers(questionIndex, value);
                        },
                      ),
                      height5,
                    ]
                  ],
                );
              })
            ],
          ),
        ),
      );
    });
  }
}
