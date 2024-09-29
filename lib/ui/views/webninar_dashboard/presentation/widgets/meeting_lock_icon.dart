import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:o_connect/ui/utils/custom_toast_helper/custom_toast.dart';
import 'package:o_connect/ui/views/meeting/model/model.dart';
import 'package:o_connect/ui/views/meeting/providers/meeting_room_provider.dart';
import 'package:o_connect/ui/views/meeting/providers/participants_provider.dart';
import 'package:provider/provider.dart';

class MeetingLockIcon extends StatelessWidget {
  const MeetingLockIcon({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer2<ParticipantsProvider, MeetingRoomProvider>(
      builder: (_, provider, mp, __) {
        final bool isLocked = mp.meeting.isMeetingLocked == true;

        return InkWell(
          onTap: () {
            if ([UserRole.host].contains(provider.myRole)) {
              mp.toggleMeetingLockStatus();
            } else {
              CustomToast.showErrorToast(msg: "Only Host can lock the meeting");
            }
          },
          child: SvgPicture.asset(
            width: 50.sp,
            height: 50.sp,
            isLocked ? "assets/new_ui_icons/all_participants_icons/lock_on.svg" : "assets/new_ui_icons/all_participants_icons/lock_off.svg",
          ),
        );
      },
    );
  }
}
