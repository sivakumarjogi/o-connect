import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:o_connect/core/screen_configs.dart';
import 'package:o_connect/ui/utils/constant_strings.dart';
import 'package:o_connect/ui/views/poll/provider/poll_provider.dart';
import 'package:o_connect/ui/views/poll/widgets/poll_results_bar_graph.dart';
import 'package:o_connect/ui/views/webinar_details/webinar_details_provider/webinar_provider.dart';
import 'package:provider/provider.dart';
import 'widgets/display_poll_questions.dart';

class EndPollScreen extends StatefulWidget {
  const EndPollScreen({super.key});

  @override
  State<EndPollScreen> createState() => _EndPollScreenState();
}

class _EndPollScreenState extends State<EndPollScreen> {
  WebinarProvider? webinarProvider;
  List colors = [Colors.red, Colors.green, Colors.yellow];
  Random random = Random();

  @override
  void initState() {
    webinarProvider = Provider.of<WebinarProvider>(context, listen: false);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Theme.of(context).primaryColor,
      height: 520.h,
      width: ScreenConfig.width,
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Consumer<PollProvider>(builder: (_, pollProvider, __) {
          return pollProvider.myHubInfo.isHostOrActiveHost || pollProvider.myHubInfo.isCohost
              ? Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    InkWell(
                      onTap: !pollProvider.pollListeners.resultsShared
                          ? () {
                              !pollProvider.pollListeners.pollVotingEnded ? pollProvider.endPollVotingStatusSet() : pollProvider.shareResultsGlobalSetStatus();
                            }
                          : null,
                      child: Padding(
                        padding: EdgeInsets.all(10.sp),
                        child: Container(
                            decoration: BoxDecoration(borderRadius: BorderRadius.circular(5.r), color: !pollProvider.pollListeners.resultsShared ? Colors.red : Colors.red.withOpacity(0.5)),
                            child: Padding(
                              padding: EdgeInsets.fromLTRB(12.w, 8.h, 12.w, 8.h),
                              child: Text(
                                pollProvider.pollListeners.pollVotingEnded ? "Share results" : ConstantsStrings.endVoting,
                                style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w500),
                              ),
                            )),
                      ),
                    ),
                    IconButton(
                        onPressed: () {
                          pollProvider.endPollGlobalSet();
                        },
                        icon: Icon(
                          Icons.cancel,
                          color: Colors.red,
                          size: 22.sp,
                        ))
                  ],
                )
              : const SizedBox.shrink();
        }),
        Expanded(
          child: Container(
            margin: EdgeInsets.symmetric(horizontal: 16.w, vertical: 10.h),
            decoration: BoxDecoration(borderRadius: BorderRadius.circular(5.r), color: Theme.of(context).scaffoldBackgroundColor),
            child: Padding(
              padding: EdgeInsets.all(8.0.sp),
              child: const PollResultsBarGraph(),
            ),
          ),
        ),
        Consumer<PollProvider>(builder: (context, pollProvider, child) {
          return Expanded(
            child: SingleChildScrollView(
              child: Column(
                children: List.generate(
                    pollProvider.pollListeners.pollQuestions.length,
                    (index) => PollDisplayQuestions(
                          question: pollProvider.pollListeners.pollQuestions[index].question ?? "",
                          questionIndex: index,
                        )),
              ),
            ),
          );
        }),
      ]),
    );
  }
}
