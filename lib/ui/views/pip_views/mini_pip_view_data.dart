import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:o_connect/ui/utils/colors/colors.dart';
import 'package:provider/provider.dart';

import '../meeting/model/user_role.dart';
import '../meeting/providers/participants_provider.dart';
import '../meeting/providers/peers_provider.dart';
import '../meeting/utils/meeting_utils_mixin.dart';
import '../webninar_dashboard/presentation/widgets/guest_streaming_view.dart';
import '../webninar_dashboard/presentation/widgets/peer_widget.dart';

class MiniPIPViewDataClass extends StatefulWidget {

   MiniPIPViewDataClass({super.key});

  @override
  State<MiniPIPViewDataClass> createState() => _MiniPIPViewDataClassState();
}

class _MiniPIPViewDataClassState extends State<MiniPIPViewDataClass> with MeetingUtilsMixin{
  @override
  Widget build(BuildContext context) {
    return Consumer<PeersProvider>(
      builder: (context, provider, child) {
        final videoPeers = provider.peers.where((v) => v.isActiveSpeaker == true || v.video?.paused == false);
        if (videoPeers.isNotEmpty) {
          return Padding(
            padding: const EdgeInsets.all(8.0),
            child: Stack(
              alignment: Alignment.center,
              children: [
                Positioned.fill(
                  key: ValueKey('${videoPeers.first.id}_container'),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(12.r),
                    child: SizedBox(
                      height: 190,
                      width: 140,
                      child: PeerVideo(
                        key: ValueKey(videoPeers.first.id),
                        renderer: videoPeers.first.video != null && videoPeers.first.video?.paused == false ? videoPeers.first.renderer : null,
                      ),
                    ),
                  ),
                ),
                // const SizedBox(
                //   height: 200,
                //   width: 150,
                //   child: BorderAnimation(
                //     isBorderRadiusRequired: true,
                //     strokeWidth: 4,
                //     borderRadius: 12,
                //   ),
                // ),
              ],
            ),
          );
        }

        return Stack(
          alignment: Alignment.center,
          children: [
            if(myRole == UserRole.guest)
              Container(
                  decoration: BoxDecoration(color: Theme.of(context).scaffoldBackgroundColor, borderRadius: BorderRadius.circular(5.r), border: Border.all(color: AppColors.appmainThemeColor, width: 2)),
                  height: 190.h,
                  width: 140.w,
                  child: GuestStreamingView(meetingId: context.read<ParticipantsProvider>().meeting.id!))
            else
            ClipRRect(
              borderRadius: BorderRadius.circular(2.r),
              child: Container(
                decoration: BoxDecoration(color: Theme.of(context).scaffoldBackgroundColor, borderRadius: BorderRadius.circular(5.r), border: Border.all(color: AppColors.appmainThemeColor, width: 2)),
                height: 190.h,
                width: 140.w,
                child: const Icon(Icons.person),
              ),
            ),
            // SizedBox(
            //   height: 200.h,
            //   width: 150.w,
            //   child: const BorderAnimation(
            //     isBorderRadiusRequired: true,
            //     strokeWidth: 10,
            //     borderRadius: 10,
            //   ),
            // ),
          ],
        );
      },
    );
  }
}
