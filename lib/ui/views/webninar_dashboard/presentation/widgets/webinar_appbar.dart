import 'package:fl_pip/fl_pip.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:o_connect/core/providers/app_global_state_provider.dart';
import 'package:o_connect/core/routes/routes_name.dart';
import 'package:o_connect/ui/utils/custom_show_dialog_helper/custom_show_dialog.dart';
import 'package:o_connect/ui/utils/images/images.dart';
import 'package:o_connect/ui/utils/textfield_helper/app_fonts.dart';
import 'package:o_connect/ui/views/meeting/model/model.dart';
import 'package:o_connect/ui/views/meeting/providers/meeting_room_provider.dart';
import 'package:o_connect/ui/views/meeting/providers/participants_provider.dart';
import 'package:o_connect/ui/views/themes/providers/webinar_themes_provider.dart';
import 'package:o_connect/ui/views/webinar_details/webinar_details_provider/webinar_provider.dart';
import 'package:o_connect/ui/views/webninar_dashboard/presentation/widgets/meeting_timer.dart';
import 'package:provider/provider.dart';

import '../../../home_screen/home_screen_provider/home_screen_provider.dart';
import 'break_time_popup.dart';
import 'end_btn.dart';
import 'meeting_lock_icon.dart';

class WebinarAppbar extends StatelessWidget implements PreferredSizeWidget {
  const WebinarAppbar({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<WebinarProvider>(builder: (_, provider, __) {
      if (provider.isExpandedWebinarScreen) {
        return const SizedBox(height: kTextTabBarHeight);
      }

      return AppBar(
        elevation: 0,
        leadingWidth: MediaQuery.of(context).size.width,
        backgroundColor: const Color(0xff16181A),
        leading: const Row(
          children: [
            _BackButton(),
            // _AllParticipantsWidget(),
            Expanded(child: _MeetingName()),
            MeetingCountdownTimerWidget(),
            SizedBox(width: 6),
            // _BreakTimeIcon(),
            // SizedBox(width: 6),
            // MeetingLockIcon(),
            // SizedBox(width: 12),

            EndMeetingButton(),
            SizedBox(width: 12),
          ],
        ),
      );
    });
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}

class _AppbarBackground extends StatelessWidget {
  const _AppbarBackground();

  @override
  Widget build(BuildContext context) {
    return Consumer<WebinarThemesProviders>(
      builder: (_, themeProvider, child) {
        return SizedBox(
          width: MediaQuery.of(context).size.width,
          height: double.infinity,
          child: themeProvider.selectedWebinarTheme?.backgroundImageUrl != null && themeProvider.selectedWebinarTheme!.backgroundImageUrl!.isNotEmpty
              ? Image.network(
                  Provider.of<WebinarThemesProviders>(
                    context,
                    listen: false,
                  ).selectedWebinarTheme!.backgroundImageUrl!,
                  fit: BoxFit.cover,
                )
              : const SizedBox.shrink(),
        );
      },
    );
  }
}

class _BackButton extends StatelessWidget {
  const _BackButton();

  @override
  Widget build(BuildContext context) {
    return IconButton(
      icon: const Center(
        child: Icon(
          Icons.chevron_left_outlined,
          size: 24,
          color: Color(0xff8F93A3),
        ),
      ),
      onPressed: () {

        // PIPView.of(context)?.presentBelow(const WebinarDetails());
        // Provider.of<HomeScreenProvider>(context, listen: false).getMeetings(context, searchHistory: "", selectedValue: "upcoming");
        context.read<AppGlobalStateProvider>().isPIPEnable(context);
        // FlPiP().disable();
      },
    );
  }
}

class _AllParticipantsWidget extends StatelessWidget {
  const _AllParticipantsWidget();

  @override
  Widget build(BuildContext context) {
    return InkWell(
      child: CircleAvatar(
        radius: 20,
        backgroundColor: context.watch<WebinarThemesProviders>().colors.headerColor,
        child: const Center(
          child: Icon(Icons.group, size: 18),
        ),
      ),
      onTap: () {
        Navigator.pushNamed(context, RoutesManager.allParticipantsPage);
      },
    );
  }
}

class _BreakTimeIcon extends StatelessWidget {
  const _BreakTimeIcon();

  @override
  Widget build(BuildContext context) {
    return Consumer<ParticipantsProvider>(builder: (_, provider, __) {
      if (![UserRole.host, UserRole.activeHost].contains(provider.myRole)) return const SizedBox(width: 0);

      return InkWell(
        child: CircleAvatar(
          radius: 20,
          backgroundColor: context.watch<WebinarThemesProviders>().colors.headerColor,
          child: SvgPicture.asset(
            AppImages.breakTimeIcon,
            width: 18,
            height: 18,
          ),
        ),
        onTap: () {
          customShowDialog(context, const BreakTimePopup(), height: MediaQuery.of(context).size.height * 0.3);
        },
      );
    });
  }
}

class _MeetingName extends StatelessWidget {
  const _MeetingName();

  @override
  Widget build(BuildContext context) {
    return Consumer<MeetingRoomProvider>(
      builder: (_, provider, __) {
        return SizedBox(
          width: 125,
          child: Text(provider.meeting.meetingName ?? "", overflow: TextOverflow.ellipsis, style: w400_12Poppins(color: Colors.white)
              //w400_12Poppins(color: Theme.of(context).primaryColorLight),
              ),
        );
      },
    );
  }
}
