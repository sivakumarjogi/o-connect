import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:o_connect/core/providers/common_provider.dart';
import 'package:o_connect/core/providers/emoji_provider.dart';
import 'package:o_connect/ui/utils/close_widget.dart';
import 'package:o_connect/ui/views/themes/providers/webinar_themes_provider.dart';
import 'package:provider/provider.dart';

import '../../../core/screen_configs.dart';
import '../../utils/constant_strings.dart';
import '../../utils/custom_show_dialog_helper/custom_show_dialog.dart';

class Emojis extends StatefulWidget {
  const Emojis({super.key});

  @override
  State<Emojis> createState() => _EmojisState();
}

class _EmojisState extends State<Emojis> {
  final TextEditingController controller = TextEditingController();
  bool emojiShowing = false;

  @override
  void dispose() {
    // TODO: implement dispose
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer3<WebinarThemesProviders, CommonProvider, MeetingEmojiProvider>(builder: (context, webinarThemesProvider, commonProvider, meetingEmojiProvider, child) {
      return Container(
        height: ScreenConfig.height * 0.62,
        decoration: BoxDecoration(
            border: Border.all(color: webinarThemesProvider.colors.headerColor, width: 4.w),
            color: webinarThemesProvider.colors.bodyColor,
            borderRadius: BorderRadius.only(topLeft: Radius.circular(25.r), topRight: Radius.circular(25.r))),
        child: Column(
          children: [
            showDialogCustomHeader(context, headerTitle: ConstantsStrings.emoji),
            Container(
              height: 370.h,
              color: webinarThemesProvider.colors.bodyColor ?? Theme.of(context).primaryColor,
              child: ClipRRect(
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(24.r),
                  topRight: Radius.circular(24.r),
                ),
                child: GridView.builder(
                  itemCount: meetingEmojiProvider.emojiFiles.length,
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 6),
                  itemBuilder: (context, index) {
                    final emojiFile = meetingEmojiProvider.emojiFiles[index];
                    return InkWell(
                      onTap: () {
                        meetingEmojiProvider.sendEmoji(emojiFile);
                        Navigator.of(context).pop();
                      },
                      child: Image.asset('assets/emoji/$emojiFile'),
                    );
                  },
                ),
              ),
            ),
            CloseWidget(
              textColor: webinarThemesProvider.colors.textColor,
              onTap: () {
                Navigator.of(context).pop();
              },
            )
          ],
        ),
      );
    });
  }
}
