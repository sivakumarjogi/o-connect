import 'package:flutter/material.dart';
import 'package:o_connect/core/providers/all_participants_provider.dart';
import 'package:o_connect/core/providers/all_products_provider.dart';
import 'package:o_connect/core/providers/app_global_state_provider.dart';
import 'package:o_connect/core/providers/base_provider.dart';
import 'package:o_connect/core/providers/default_user_data_provider.dart';
import 'package:o_connect/ui/views/bgm/providers/bgm_provider.dart';
import 'package:o_connect/core/providers/calculator_provider.dart';
import 'package:o_connect/core/providers/calender_provider.dart';
import 'package:o_connect/core/providers/common_provider.dart';
import 'package:o_connect/core/providers/create_contact_provider.dart';
import 'package:o_connect/core/providers/emoji_provider.dart';
import 'package:o_connect/core/providers/resound_provider.dart';
import 'package:o_connect/ui/views/call_to_action/providers/dashboard_call_to_action_provider.dart';
import 'package:o_connect/core/providers/forgot_password_provider.dart';
import 'package:o_connect/core/providers/library_provider.dart';
import 'package:o_connect/core/providers/localization_provider.dart';
import 'package:o_connect/ui/views/drawer/library_revamp/library_revamp_provider.dart';
import 'package:o_connect/ui/views/meeting/providers/recording_provider.dart';
import 'package:o_connect/ui/views/poll/provider/poll_provider.dart';
import 'package:o_connect/core/providers/my_contacts_provider.dart';
import 'package:o_connect/core/providers/prompter_provider.dart';
import 'package:o_connect/core/providers/theme_provider.dart';
import 'package:o_connect/ui/views/meeting/providers/hand_raise_provider.dart';
import 'package:o_connect/ui/views/meeting/providers/video_share_provider.dart';
import 'package:o_connect/ui/views/presentation/presentation_whiteboard/presentation_whiteboard_provider.dart';
import 'package:o_connect/ui/views/presentation/provider/presentation_popup_provider.dart';
import 'package:o_connect/ui/views/share_files/provider/share_files_provider.dart';
import 'package:o_connect/ui/views/ticker/provider/ticker_provider.dart';
import 'package:o_connect/core/providers/whiteboard_provider.dart';
import 'package:o_connect/ui/views/authentication/Auth_providers/auth_api_provider.dart';
import 'package:o_connect/ui/views/chat_screen/providers/chat_provider.dart';
import 'package:o_connect/ui/views/drawer/drawer_viewmodel.dart';
import 'package:o_connect/ui/views/meeting/providers/media_devices_provider.dart';
import 'package:o_connect/ui/views/meeting/providers/meeting_room_provider.dart';
import 'package:o_connect/ui/views/meeting/providers/meeting_timer_provider.dart';
import 'package:o_connect/ui/views/meeting/providers/participants_provider.dart';
import 'package:o_connect/ui/views/meeting/providers/peers_provider.dart';
import 'package:o_connect/ui/views/profile_screen/profile_provider/profile_api_provider.dart';
import 'package:o_connect/ui/views/push_link/provider/push_link_provider.dart';
import 'package:o_connect/ui/views/themes/providers/webinar_themes_provider.dart';
import 'package:o_connect/ui/views/timer/provider/timer_provider.dart';
import 'package:o_connect/ui/views/webinar_details/webinar_details_provider/webinar_details_provider.dart';
import 'package:o_connect/ui/views/webinar_details/webinar_details_provider/webinar_provider.dart';
import 'package:o_connect/ui/views/home_screen/home_screen_provider/home_screen_provider.dart';
import 'package:o_connect/ui/views/invite/provider/invite_pop_up_provider.dart';
import 'package:provider/provider.dart';
import 'package:provider/single_child_widget.dart';
import '../ui/views/webninar_dashboard/presentation/create_webinar/provider/create_webinar_provider.dart';

class RegisterProviders {
  ///Register all providers used in the application here
  //////hi
  static List<SingleChildWidget> providers(BuildContext context) {
    return [
      ChangeNotifierProvider<AppGlobalStateProvider>(create: (context) => AppGlobalStateProvider()),
      ChangeNotifierProvider<HomeScreenProvider>(create: (context) => HomeScreenProvider()),
      ChangeNotifierProvider<BaseProvider>(create: (context) => BaseProvider()),
      ChangeNotifierProvider<CreateContactProvider>(create: (context) => CreateContactProvider()),
      ChangeNotifierProvider<ThemeProvider>(create: (context) => ThemeProvider(), lazy: false),
      ChangeNotifierProvider<WebinarThemesProviders>(create: (context) => WebinarThemesProviders(), lazy: false),
      ChangeNotifierProvider<WebinarProvider>(create: (context) => WebinarProvider()),
      ChangeNotifierProvider<AllParticipantProvider>(create: (context) => AllParticipantProvider()),
      ChangeNotifierProvider<AllProductsProvider>(create: (context) => AllProductsProvider()),
      ChangeNotifierProvider<ChatProvider>(create: (context) => ChatProvider()),
      ChangeNotifierProvider<DrawerViewModel>(create: (context) => DrawerViewModel()),
      ChangeNotifierProvider<PrompterProvider>(create: (context) => PrompterProvider()),
      ChangeNotifierProvider<WhiteboardProvider>(create: (context) => WhiteboardProvider()),
      ChangeNotifierProvider<MeetingTickerProvider>(create: (context) => MeetingTickerProvider()),
      ChangeNotifierProvider<CommonProvider>(create: (context) => CommonProvider()),
      ChangeNotifierProvider<LocalizationProvider>(create: (context) => LocalizationProvider()),
      ChangeNotifierProvider<CreateWebinarProvider>(create: (context) => CreateWebinarProvider()),
      ChangeNotifierProvider<PresentationPopUpProvider>(create: (context) => PresentationPopUpProvider()),
      ChangeNotifierProvider<AuthApiProvider>(create: (context) => AuthApiProvider()),
      ChangeNotifierProvider<ProfileScreenProvider>(create: (context) => ProfileScreenProvider()),
      ChangeNotifierProvider<MyContactsProvider>(create: (context) => MyContactsProvider()),
      ChangeNotifierProvider<PollProvider>(create: (context) => PollProvider()),
      ChangeNotifierProvider<CalenderProvider>(create: (context) => CalenderProvider()),
      ChangeNotifierProvider<LibraryProvider>(create: (context) => LibraryProvider()),
      ChangeNotifierProvider<DashBoardCallToActionProvider>(create: (context) => DashBoardCallToActionProvider()),
      ChangeNotifierProvider<InvitePopupProvider>(create: (context) => InvitePopupProvider()),
      ChangeNotifierProvider<WebinarDetailsProvider>(create: (context) => WebinarDetailsProvider()),
      ChangeNotifierProvider<MeetingRoomProvider>(create: (context) => MeetingRoomProvider()),
      ChangeNotifierProvider<MediaDevicesProvider>(create: (context) => MediaDevicesProvider()),
      ChangeNotifierProvider<PeersProvider>(create: (context) => PeersProvider()),
      ChangeNotifierProvider<ParticipantsProvider>(create: (context) => ParticipantsProvider()),
      ChangeNotifierProvider<MeetingTimerProvider>(create: (context) => MeetingTimerProvider()),
      ChangeNotifierProvider<ResoundProvider>(create: (context) => ResoundProvider()),
      ChangeNotifierProvider(create: (context) => BgmProvider()),
      ChangeNotifierProvider(create: (context) => MeetingEmojiProvider()),
      ChangeNotifierProvider(create: (context) => PushLinkProvider()),
      ChangeNotifierProvider(create: (context) => CalculatorProvider()),
      ChangeNotifierProvider(create: (context) => TimerProvider()),
      ChangeNotifierProvider(create: (context) => HandRaiseProvider()),
      ChangeNotifierProvider(create: (context) => RecordingProvider()),
      ChangeNotifierProvider(create: (context) => VideoShareProvider()),
      ChangeNotifierProvider(create: (context) => PresentationWhiteBoardProvider()),
      ChangeNotifierProvider(create: (context) => DefaultUserDataProvider()),
      ChangeNotifierProvider(create: (context) => LibraryRevampProvider()),
      ChangeNotifierProvider(create: (context) => ShareFilesProvider()),
    ];
  }
}
