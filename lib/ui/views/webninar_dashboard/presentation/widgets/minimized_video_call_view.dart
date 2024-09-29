import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:o_connect/ui/views/meeting/model/user_role.dart';
import 'package:o_connect/ui/views/meeting/providers/meeting_room_provider.dart';
import 'package:o_connect/ui/views/meeting/providers/participants_provider.dart';
import 'package:o_connect/ui/views/webinar_details/webinar_details_provider/webinar_provider.dart';
import 'package:o_connect/ui/views/webninar_dashboard/presentation/widgets/peer_widget.dart';
import 'package:provider/provider.dart';

class MinimizedVideoCallView extends StatefulWidget {
  const MinimizedVideoCallView({Key? key}) : super(key: key);

  @override
  State<MinimizedVideoCallView> createState() => _MinimizedVideoCallViewState();
}

class _MinimizedVideoCallViewState extends State<MinimizedVideoCallView> {
  @override
  Widget build(BuildContext context) {
    return Consumer3<MeetingRoomProvider, ParticipantsProvider, WebinarProvider>(
      builder: (context, mProvider, participantProvider, webinarProvider, child) {
        if (participantProvider.myRole == UserRole.unknown || participantProvider.myRole == UserRole.guest) return const SizedBox.shrink();
        final peer = mProvider.peer;
        return Padding(
          padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 50.h),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(6.r),
            child: CurrentPeerWidget(
              peer: peer,
              height: 200.h,
              width: 150.w,
            ),
          ),
        );
      },
    );
  }
}
