import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:just_audio/just_audio.dart';
import 'package:lottie/lottie.dart';
import 'package:o_connect/ui/views/bgm/providers/bgm_provider.dart';
import 'package:o_connect/core/providers/common_provider.dart';
import 'package:o_connect/core/providers/theme_provider.dart';
import 'package:o_connect/ui/views/themes/providers/webinar_themes_provider.dart';
import 'package:provider/provider.dart';

import '../../utils/colors/colors.dart';
import '../../utils/images/images.dart';
import '../webinar_details/webinar_details_provider/webinar_provider.dart';

class BGMAudioPlayer extends StatefulWidget {
  const BGMAudioPlayer({super.key});

  @override
  State<BGMAudioPlayer> createState() => _BGMAudioPlayerState();
}

class _BGMAudioPlayerState extends State<BGMAudioPlayer> {
  @override
  Widget build(BuildContext context) {
    return Consumer4<CommonProvider, ThemeProvider, BgmProvider, WebinarThemesProviders>(builder: (context, commonProvider, themeProvider, bgmProvider, webinarThemesProviders, child) {
      return Container(
        height: 40.h,
        decoration: BoxDecoration(
          color: webinarThemesProviders.unSelectButtonsColor,
          borderRadius: BorderRadius.circular(3.r),
        ),
        alignment: Alignment.center,
        child: Row(
          children: [
            width10,
            StreamBuilder(
              stream: bgmProvider.audioPlayer.playerStateStream,
              builder: (context, snapshot) {
                final playerState = snapshot.data;
                final processingState = playerState?.processingState;
                final playing = playerState?.playing;
                if (processingState == ProcessingState.loading || processingState == ProcessingState.buffering) {
                  return SizedBox(width: 20.w, height: 20.h, child: Lottie.asset(AppImages.loadingJson, height: 40.w, width: 40.w));
                } else if (playing != true) {
                  return InkWell(
                    onTap: () {
                      bgmProvider.togglePlay(bgmProvider.currentSoundName, bgmProvider.currentSoundUrl);
                    },
                    child: SvgPicture.asset(
                      "assets/new_ui_icons/webinar_dashboard/play.svg",
                      height: 20.w,
                      width: 20.w,
                    ),

                    // Icon(
                    //   Icons.play_arrow,
                    //   size: 20.sp,
                    //   color: themeProvider.isLightTheme ? AppColors.appmainThemeColor : Theme.of(context).hintColor,
                    // ),
                  );
                } else if (processingState != ProcessingState.completed) {
                  return InkWell(
                    onTap: () {
                      bgmProvider.togglePlay(bgmProvider.currentSoundName, bgmProvider.currentSoundUrl);
                    },
                    child: Icon(
                      Icons.pause,
                      size: 20.sp,
                      color: themeProvider.isLightTheme ? AppColors.appmainThemeColor : Theme.of(context).hintColor,
                    ),
                  );
                } else {
                  return IconButton(
                    icon: Icon(
                      Icons.replay,
                      size: 20.sp,
                      color: webinarThemesProviders.hintTextColor,
                    ),
                    iconSize: 20.sp,
                    onPressed: () => commonProvider.player.seek(Duration.zero),
                  );
                }
              },
            ),
            width10,
            SvgPicture.asset(
              "assets/new_ui_icons/webinar_dashboard/speaker.svg",
              height: 20.w,
              width: 20.w,
            ),

            // Icon(
            //   Icons.volume_up,
            //   size: 20.sp,
            //   color: themeProvider.isLightTheme ? AppColors.appmainThemeColor : Theme.of(context).hintColor,
            // ),
            SliderTheme(
                data: SliderThemeData(
                  thumbShape: RoundSliderThumbShape(enabledThumbRadius: 5.r),
                  trackHeight: 5,
                  activeTrackColor: themeProvider.isLightTheme ? AppColors.drawerColor : AppColors.whiteColor,
                  inactiveTrackColor: themeProvider.isLightTheme ? AppColors.lightDarkColor : AppColors.fontBody,
                  thumbColor: AppColors.appmainThemeColor,
                ),
                child: SizedBox(
                  height: 5.h,
                  width: 180.w,
                  child: StreamBuilder<double>(
                    stream: bgmProvider.audioPlayer.volumeStream,
                    builder: (context, snapshot) => Slider(
                      divisions: 10,
                      min: 0.0,
                      max: 1.0,
                      value: bgmProvider.audioPlayer.volume,
                      onChanged: (val) {
                        bgmProvider.emitVolumeEvent(val);
                        // commonProvider.player.setVolume
                      },
                    ),
                  ),
                )),
            Spacer(),
            InkWell(
                onTap: () {
                  context.read<WebinarProvider>().disableActiveFuture();
                },
                child: SvgPicture.asset(
                  "assets/new_ui_icons/webinar_dashboard/miniView.svg",
                  height: 24.w,
                  width: 24.w,
                )),
            width10,
            InkWell(
              child: SvgPicture.asset(
                "assets/new_ui_icons/webinar_dashboard/cancel.svg",
                height: 24.w,
                width: 24.w,
              ),
              onTap: () {
                context.read<BgmProvider>().closeBackgroundMusic().then((value) => context.read<WebinarProvider>().disableActiveFuture());
              },
            ),
            width10,
          ],
        ),
      );
    });
  }
}

class PlayerState {
  final bool playing;

  final ProcessingState processingState;

  PlayerState(this.playing, this.processingState);

  @override
  String toString() => 'playing=$playing,processingState=$processingState';

  @override
  int get hashCode => Object.hash(playing, processingState);

  @override
  bool operator ==(Object other) => other.runtimeType == runtimeType && other is PlayerState && other.playing == playing && other.processingState == processingState;
}
