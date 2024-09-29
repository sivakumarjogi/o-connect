import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:lottie/lottie.dart';
import 'package:mediasoup_client_flutter/mediasoup_client_flutter.dart' as mediasoup;
import 'package:o_connect/ui/utils/countrie_flags.dart';
import 'package:o_connect/ui/utils/colors/colors.dart';
import 'package:o_connect/ui/utils/images/images.dart';
import 'package:o_connect/ui/utils/textfield_helper/app_fonts.dart';
import 'package:o_connect/ui/views/meeting/providers/meeting_room_provider.dart';
import 'package:o_connect/ui/views/meeting/providers/participants_provider.dart';
import 'package:o_connect/ui/views/meeting/providers/peers_provider.dart';
import 'package:o_connect/ui/views/themes/providers/webinar_themes_provider.dart';
import 'package:provider/provider.dart';

import 'peer_widget.dart';
import 'package:o_connect/ui/views/ticker/provider/ticker_provider.dart' as ticker;
class SpotlightWidget extends StatelessWidget {
  const SpotlightWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer4<MeetingRoomProvider, PeersProvider, ParticipantsProvider, WebinarThemesProviders>(builder: (_, meetingProvider, peersProvider, participantsProvider, webinarThemesProviders, __) {
      final hasPeers = peersProvider.peers.isNotEmpty;
      Widget spotlightVideo = const SizedBox();
      bool showActiveSpeakerAnimation = false;
      String peerDisplayName = '';
      String displayBadge = "";
      String countryFlag = "in";
      bool isPeerVideoOn = false;
      bool isPeerAudioOn = false;

      print(hasPeers);

      if (hasPeers) {
        final screenShares = peersProvider.peers.where((p) => p.isScreenshareOn).toList();

        if (screenShares.isNotEmpty) {
          spotlightVideo = PeerVideo(
            renderer: screenShares.first.screenRenderer,
            mirror: false,
            objectFit: mediasoup.RTCVideoViewObjectFit.RTCVideoViewObjectFitContain,
          );
          isPeerVideoOn = screenShares.first.isVideoOn;
          isPeerAudioOn = screenShares.first.isMicOn;
          peerDisplayName = screenShares.first.displayName;
          displayBadge = screenShares.first.role;
        } else {
          final activeSpeakers = peersProvider.peers.where((p) => p.isActiveSpeaker).toList();
          final activeVideos = peersProvider.peers.where((p) => p.video != null && p.renderer?.srcObject != null).toList();
          if (activeSpeakers.isNotEmpty) {
            spotlightVideo = PeerVideo(
              renderer: activeSpeakers.first.renderer,
              mirror: false,
            );
            showActiveSpeakerAnimation = true;
            isPeerVideoOn = activeSpeakers.first.isVideoOn;
            isPeerAudioOn = activeSpeakers.first.isMicOn;
            peerDisplayName = activeSpeakers.first.displayName;
            displayBadge = activeSpeakers.first.role;
          } else if (activeVideos.isNotEmpty) {
            spotlightVideo = PeerVideo(
              renderer: activeVideos.first.renderer,
              mirror: false,
            );
            showActiveSpeakerAnimation = false;
            isPeerVideoOn = activeVideos.first.isVideoOn;
            isPeerAudioOn = activeVideos.first.isMicOn;
            peerDisplayName = activeVideos.first.displayName;
            displayBadge = activeVideos.first.role;
          } else {
            spotlightVideo = PeerVideo(
              renderer: peersProvider.peers.first.renderer,
              mirror: false,
            );
            isPeerVideoOn = peersProvider.peers.first.isVideoOn;
            isPeerAudioOn = peersProvider.peers.first.isMicOn;
            peerDisplayName = peersProvider.peers.first.displayName;
            displayBadge = peersProvider.peers.first.role;
          }
        }
      } else {
        spotlightVideo = const PeerVideo(
          renderer: null,
          mirror: true,
        );
        // isPeerVideoOn = meetingProvider.isMyVideoOn;
        // isPeerAudioOn = meetingProvider.isMyMicOn;
        // peerDisplayName = participantsProvider.myHubInfo.displayName ?? "";
      }

      return Stack(
        children: [
          if (hasPeers)
            InkWell(
              onTap: () {
                // context.read<WebinarProvider>().toggleExpandedFullScreenVideoCall();
              },
              child: SizedBox(
                height: MediaQuery.of(context).size.height,
                width: MediaQuery.of(context).size.width,
                child: spotlightVideo,
              ),
            ),

          if (displayBadge.isNotEmpty)
            Container(
              width: 20.w,
              height: 20.w,
              decoration: BoxDecoration(color: Colors.purple, borderRadius: BorderRadius.circular(50.r)),
              child: Center(
                child: Text(
                  displayBadge.isEmpty ? "" : displayBadge.toString().characters.first,
                  style: w400_10Poppins(color: Colors.white),
                ),
              ),
            ),
          if (showActiveSpeakerAnimation) ...[
            Positioned(
              left: 5.w,
              bottom: 50.h,
              child: Container(
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
            )
          ],

          if (peerDisplayName.isNotEmpty)
            Positioned(
              left: 0,
              bottom:context.read<ticker.MeetingTickerProvider>().displayTicker? 50.h:12.h,
              child: Consumer<MeetingRoomProvider>(builder: (_, provider, __) {
                return Container(
                  alignment: Alignment.center,
                  padding: EdgeInsets.all(5.sp),
                  width: MediaQuery.of(context).size.width,
                  decoration: BoxDecoration(border: Border.all(color: Theme.of(context).primaryColor), color: Theme.of(context).primaryColor),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      if (peerDisplayName.isNotEmpty) ...[
                        // Container(
                        //   width: 15.w,
                        //   height: 15.w,
                        //   decoration: BoxDecoration(color: Colors.purple, borderRadius: BorderRadius.circular(50.r)),
                        //   child: Center(
                        //     child: Text(
                        //       peerDisplayName.isEmpty ? "" : peerDisplayName.toString().characters.first,
                        //       style: w400_10Poppins(color: Colors.white),
                        //     ),
                        //   ),
                        // ),
                        SizedBox(width: 8.w),
                        Text(
                          peerDisplayName.toString(),
                          style: w400_12Poppins(color: Colors.white),
                        ),
                        const Spacer(),
                        Countries(countriesFlag: peersProvider.peers.first.countryFlag),
                        width5,
                        Icon(
                          isPeerAudioOn ? Icons.mic : Icons.mic_off,
                          color: Colors.white,
                          size: 16.sp,
                        ),
                        SizedBox(width: 8.w),
                        Icon(
                          isPeerVideoOn ? Icons.videocam : Icons.videocam_off,
                          color: Colors.white,
                          size: 16.sp,
                        ),
                        SizedBox(width: 8.w),
                      ],
                    ],
                  ),
                );
              }),
            ),

          ///border gradiant animation
          // if (showActiveSpeakerAnimation)
          //   SizedBox(
          //     width: ScreenConfig.width,
          //     height: ScreenConfig.height,
          //     child: const BorderAnimation(
          //       isBorderRadiusRequired: false,
          //     ),
          //   ),
        ],
      );
    });
  }
}
