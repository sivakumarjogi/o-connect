import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:lottie/lottie.dart';
import 'package:mediasoup_client_flutter/mediasoup_client_flutter.dart';
import 'package:o_connect/ui/utils/colors/colors.dart';
import 'package:o_connect/ui/utils/images/images.dart';
import 'package:o_connect/ui/utils/textfield_helper/app_fonts.dart';
import 'package:o_connect/ui/views/meeting/model/hub_user_data/hub_user_data.dart';
import 'package:o_connect/ui/views/meeting/model/model.dart';
import 'package:o_connect/ui/views/meeting/model/peer.dart';
import 'package:o_connect/ui/views/meeting/providers/hand_raise_provider.dart';
import 'package:o_connect/ui/views/meeting/providers/meeting_room_provider.dart';
import 'package:o_connect/ui/views/themes/providers/webinar_themes_provider.dart';
import 'package:o_connect/ui/views/webinar_details/webinar_details_provider/webinar_provider.dart';
import 'package:o_connect/ui/views/webninar_dashboard/presentation/widgets/boder_animation.dart';
import 'package:oes_chatbot/utils/extensions/sizedbox_extension.dart';
import 'package:provider/provider.dart';

import '../../../../utils/countrie_flags.dart';
import '../../../meeting/providers/participants_provider.dart';

class PeerWidget extends StatelessWidget {
  const PeerWidget({super.key, required this.peer, this.width, this.height, required this.index});

  final Peer peer;
  final int index;
  final double? height;
  final double? width;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      height: height,
      decoration: BoxDecoration(color: peer.isVideoOn ? Colors.transparent : context.watch<WebinarThemesProviders>().colors.bodyColor.withOpacity(0.5), borderRadius: BorderRadius.circular(5.r)),
      child: Stack(
        // fit: StackFit.,
        children: [
          // if (peer.isActiveSpeaker) const BorderAnimation(isBorderRadiusRequired: false, strokeWidth: 6),

          Positioned.fill(
            key: ValueKey('${peer.id}_container'),
            child: PeerVideo(
              key: ValueKey(peer.id),
              renderer: peer.video != null || peer.renderer?.srcObject != null ? peer.renderer : null,
              // mirror: true,
            ),
          ),
          if (peer.displayName.isNotEmpty)
            Align(
              alignment: Alignment.bottomCenter,
              child: Container(
                width: MediaQuery.of(context).size.width * 0.5,
                height: 35.h,
                padding: EdgeInsets.only(left: 5.w),
                // margin: EdgeInsets.only(bottom: 5.h, left: 5.w, right: 5.w),
                decoration: BoxDecoration(
                  color: Colors.black.withOpacity(0.2),
                ),
                child: Row(
                  children: [
                    // Container(
                    //   width: 20.w,
                    //   height: 20.w,
                    //   margin: EdgeInsets.only(right: 5.w, left: 10.w),
                    //   decoration: BoxDecoration(
                    //     color: Colors.purpleAccent,
                    //     borderRadius: BorderRadius.circular(10.r),
                    //   ),
                    //   child: Text(
                    //     (peer.displayName.split("").first.toString()),
                    //     style: w600_14Poppins(color: Colors.white),
                    //     textAlign: TextAlign.center,
                    //   ),
                    // ),
                    SizedBox(
                      width: 100.w,
                      height: 20.h,
                      child: Text(peer.displayName,
                          style: w400_12Poppins(
                            color: Theme.of(context).hintColor,
                          )),
                    ),
                    const Spacer(),
                    Countries(countriesFlag: peer.countryFlag),
                    Icon(
                      peer.isMicOn ? Icons.mic : Icons.mic_off,
                      size: 18.sp,
                      color: AppColors.whiteColor,
                    ),
                    SizedBox(width: 3.w),
                    Icon(
                      peer.isVideoOn ? Icons.videocam_rounded : Icons.videocam_off_rounded,
                      size: 18.sp,
                      color: AppColors.whiteColor,
                    ),
                    SizedBox(width: 3.w),
                  ],
                ),
              ),
            ),
          if (peer.displayName.isNotEmpty)
            Align(
              alignment: Alignment.topCenter,
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 5.h),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    commonWidget(peer.role),
                    if (peer.raisedHand)
                      InkWell(
                        onTap: () {
                          context.read<HandRaiseProvider>().lowerHand(peer.id);
                        },
                        child: const AnimatedHandRaise(),
                      ),
                    const Spacer(),
                  ],
                ),
              ),
            ),
          if (index == 0 && peer.isActiveSpeaker) ...[
            Padding(
              padding: EdgeInsets.only(bottom: 40.0.sp),
              child: Align(
                alignment: Alignment.bottomLeft,
                child: Container(
                  height: 30.h,
                  width: 100.w,
                  alignment: Alignment.bottomLeft,
                  padding: EdgeInsets.all(5.sp),
                  decoration: BoxDecoration(color: Colors.white70, borderRadius: BorderRadius.circular(15.r)),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Lottie.asset(AppImages.micActiveAnimation, width: 20, height: 20),
                      SizedBox(
                        width: 3.w,
                      ),
                      Lottie.asset(AppImages.greenWaveAnimation, width: 40.w, height: 20.h),
                    ],
                  ),
                ),
              ),
            ),
          ],
          if (peer.isActiveSpeaker) ...[
            Padding(
              padding: EdgeInsets.only(bottom: 40.0.sp),
              child: Align(
                alignment: Alignment.bottomLeft,
                child: Container(
                  height: 30.h,
                  width: 100.w,
                  alignment: Alignment.bottomLeft,
                  padding: EdgeInsets.all(5.sp),
                  decoration: BoxDecoration(color: Colors.white70, borderRadius: BorderRadius.circular(15.r)),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Lottie.asset(AppImages.micActiveAnimation, width: 20, height: 20),
                      SizedBox(
                        width: 3.w,
                      ),
                      Lottie.asset(AppImages.greenWaveAnimation, width: 40.w, height: 20.h),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget commonWidget(String user) {
    if (user == "Host") {
      return customUserBadge("H", Colors.deepPurpleAccent);
    }
    if (user == "Host") {
      return customUserBadge("AH", Colors.deepOrangeAccent);
    }
    if (user == "Host") {
      return customUserBadge("CH", Colors.grey);
    }

    switch (user) {
      case "user":
        return customUserBadge("U", Colors.green);
      default:
        return Container();
    }
  }

  Widget customUserBadge(String text, Color color) {
    return Container(
      width: 22.w,
      height: 22.w,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: color,
      ),
      child: Center(
          child: Text(
        text,
        style: w300_10Poppins(color: Colors.white),
      )),
    );
  }
}

class CurrentPeerWidget extends StatelessWidget {
  const CurrentPeerWidget({
    super.key,
    required this.peer,
    this.width,
    this.height,
  });

  final Peer peer;
  final double? height;
  final double? width;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      height: height,
      color: peer.isVideoOn ? Colors.transparent : context.watch<WebinarThemesProviders>().colors.cardColor.withOpacity(0.5),
      child: Stack(
        fit: StackFit.expand,
        children: [
          // if (peer.isActiveSpeaker) const BorderAnimation(isBorderRadiusRequired: false, strokeWidth: 6),
          Positioned.fill(
            key: ValueKey('${peer.id}_container'),
            child: PeerVideo(
              key: ValueKey(peer.id),
              // renderer: peer.renderer?.srcObject != null ? peer.renderer : null,
              renderer: (peer.video != null && peer.video?.paused == false) || peer.renderer?.srcObject != null ? peer.renderer : null,
              mirror: true,
            ),
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: Container(
              width: MediaQuery.of(context).size.width * .5,
              height: 35.h,
              padding: EdgeInsets.symmetric(horizontal: 5.w),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.1),
              ),
              child: Row(
                children: [
                  // Container(
                  //   width: 20.w,
                  //   height: 20.w,
                  //   margin: EdgeInsets.only(right: 5.w, left: 5.w),
                  //   decoration: BoxDecoration(
                  //     color: Colors.purpleAccent,
                  //     borderRadius: BorderRadius.circular(10.r),
                  //   ),
                  //   child: Text(
                  //     (peer.displayName.split("").first.toString()),
                  //     style: w600_14Poppins(color: Colors.white),
                  //     textAlign: TextAlign.center,
                  //   ),
                  // ),
                  Expanded(
                    child: SizedBox(
                      height: 20.h,
                      child: Text(
                        peer.displayName,
                        style: w400_12Poppins(
                          color: Theme.of(context).hintColor,
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ),
                  Countries(countriesFlag: peer.countryFlag),
                  3.width,
                  Icon(
                    context.read<MeetingRoomProvider>().isMyMicOn ? Icons.mic : Icons.mic_off,
                    size: 18.sp,
                    color: AppColors.whiteColor,
                  ),
                  SizedBox(width: 3.w),
                  Icon(
                    context.read<MeetingRoomProvider>().isMyVideoOn ? Icons.videocam_rounded : Icons.videocam_off_rounded,
                    size: 18.sp,
                    color: AppColors.whiteColor,
                  ),
                ],
              ),
            ),
          ),
          Align(
            alignment: Alignment.topCenter,
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 5.h),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      if (peer.raisedHand) const AnimatedHandRaise(),
                    ],
                  ),
                ],
              ),
            ),
          )
        ],
      ),
    );
  }
}

class PeerVideo extends StatelessWidget {
  const PeerVideo({
    super.key,
    required this.renderer,
    this.mirror = false,
    this.objectFit = RTCVideoViewObjectFit.RTCVideoViewObjectFitCover,
  });

  final RTCVideoRenderer? renderer;
  final bool mirror;
  final RTCVideoViewObjectFit? objectFit;

  @override
  Widget build(BuildContext context) {
    if (renderer != null) {
      return SizedBox(
        child: Transform.rotate(
          angle:  2 * 2.1415926535897932 / 2,
          filterQuality: FilterQuality.high,
          //Convert degrees to radians
          child: RTCVideoView(
            renderer!,
            objectFit: objectFit!,
            mirror: mirror,
            placeholderBuilder: (context) => const Center(child: CircularProgressIndicator()),
          ),
        )


      );
    } else {
      return const FittedBox(
        fit: BoxFit.contain,
        child: Icon(Icons.person),
      );
    }
  }
}

class AnimatedHandRaise extends StatefulWidget {
  const AnimatedHandRaise({super.key});

  @override
  State<AnimatedHandRaise> createState() => _AnimatedHandRaiseState();
}

class _AnimatedHandRaiseState extends State<AnimatedHandRaise> with SingleTickerProviderStateMixin {
  late final AnimationController _controller = AnimationController(
    duration: const Duration(seconds: 2),
    vsync: this,
  )..repeat(reverse: true);
  late final Animation<double> _animation = CurvedAnimation(
    parent: _controller,
    curve: Curves.fastOutSlowIn,
  );

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ScaleTransition(
      scale: _animation,
      child: Text(
        "✋",
        style: w400_12Poppins(),
      ),
    );
  }
}
