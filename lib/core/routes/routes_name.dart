import 'package:flutter/material.dart';
import 'package:o_connect/ui/utils/common_app_bar/chatbot.dart';
import 'package:o_connect/ui/views/authentication/login_otp_screen.dart';
import 'package:o_connect/ui/views/authentication/terrms_and_policy/privacy_policy.dart';
import 'package:o_connect/ui/views/authentication/terrms_and_policy/terms_of_service.dart';
import 'package:o_connect/ui/views/chat_screen/chat_view/chat_screen.dart';
import 'package:o_connect/ui/views/drawer/library_revamp/library_revamp.dart';
import 'package:o_connect/ui/views/lobbyscreen_waiting.dart';
import 'package:o_connect/ui/views/pip_views/pip_global_navigation.dart';
import 'package:o_connect/ui/views/profile_screen/profile_view/profile_page.dart';
import '../../ui/utils/common_app_bar/FAQs.dart';
import '../../ui/views/authentication/change_password/change_password.dart';
import '../../ui/views/profile_screen/profile_view/profile_edit_screen.dart';
import '../../ui/views/authentication/forgot_reset_password/forgot_password_otp_screen.dart';
import '../../ui/views/authentication/introslider/introslider_screen.dart';
import '../../ui/views/drawer/calender/widgets/view_all_events.dart';
import '../../ui/views/drawer/contacts/contact_tab_view.dart';
import '../../ui/views/drawer/library/library.dart';
import '../../ui/views/home_screen/home_screen_view/home_screen.dart';
import '../../ui/views/lobbyscreen.dart';
import '../../ui/views/onboarding/splash_screen.dart';
import '../../ui/views/participants/all_participants.dart';
import '../../ui/views/webinar_details/webinar_details_model/meeting_details_model.dart';
import '../../ui/views/webinar_details/webinar_details_view/webinar_page.dart';
import '../../ui/views/webninar_dashboard/presentation/create_webinar/create_webinar_screen.dart';
import '../../ui/views/webninar_dashboard/presentation/webinar_dashboard.dart';
import '../../ui/views/authentication/forgot_reset_password/forgot_password_screen.dart';
import '../../ui/views/authentication/signin_signup/sign_in_screen.dart';
import '../../ui/views/authentication/signin_signup/signup_screen.dart';
import '../../ui/views/drawer/calender/calender_screen.dart';

abstract class RoutesManager {
  RoutesManager._();

  static const splashScreen = '/';
  static const addContact = '/addcontact';
  static const loginOtpScreen = '/login_otp_screen';
  static const supportScreenForgotPassword = "/supportscreenforgotpassword";
  static const autoRecorings = '/autorecordings';

  // static const presentations = '/presentations';
  static const whiteboard = '/whiteboard';
  static const qanda = '/qanda';
  static const chat = '/chat';
  static const screenCapture = '/screencapture';
  static const template = '/template';
  static const bgm = '/bgm';
  static const allContacts = '/allcontacts';
  static const groups = '/groups';
  static const webinar = '/webinar';
  static const logIn = '/login';
  static const introSlider = '/introSlider';
  static const homeScreen = '/home';
  static const meetingView = '/meetingView';
  static const dashboard = '/dashboard';
  static const customDrawer = '/custom-drawer';
  static const dashboardCompare = '/dashboard-compare';
  static const calendar = '/calendar';
  static const realTime = '/realtime';
  static const ipBlocking = '/ip-blocking';
  static const blockIp = '/block-ip';
  static const notificationSetup = '/notification-setup';
  static const settings = '/settings';
  static const reports = '/reports';
  static const analytics = '/analytics';
  static const tracingCode = '/tracking-code';
  static const createNewProject = '/create-new-project';
  static const heatmap = '/heatmap';
  static const userPath = '/user-path';
  static const acquisition = '/acquisition';
  static const geoLocation = '/geo-location';
  static const cohorts = '/cohorts';
  static const campaign = '/campaign';
  static const acquisitionCompare = '/acquisition-compare';
  static const geoLocationCompare = '/geo-location-compare';
  static const chatbot = '/chatbot';

  // static const resetForgotPasswordScreen = '/reset_forgot_password_screen';
  static const forgotPasswordScreen = '/forgot_password_screen';
  static const signupScreen = '/sign_up_screen';
  static const endPollScreen = '/end_poll_screen';
  static const lobbyScreen = '/lobbyScreen';
  static const lobbyScreenWaiting = '/lobbyScreenWaiting';
  static const allParticipantsPage = '/allParticipantsPage';
  static const webinarChatScreen = '/webinarChatScreen';
  static const changePasswordPage = '/changePasswordPage';
  static const profileScreen = '/profileScreen';
  static const profilePage = '/profilePage';

  static const faqsPage = '/faqsPage';
  static const createWebinarScreen = '/createWebinarScreen';
  static const webinarDashboard = '/webinarDashboard';
  static const enterEmailForgotPassword = '/enterEmailForgotPassword';
  static const forgotpasswordOtpScreen = '/forgotpasswordOtpScreen';
  static const viewProfile = '/viewProfile';
  static const archive = '/archive';
  static const room = '/room';
  static const termsOfService = '/terms_of_service';
  static const privacyPolicy = '/privacy_policy';
  static const presentationScreen = '/presentationScreen';
  static const library = '/library';
  static const calender = '/calender';
  static const viewAllEventsInCalender = '/viewAllEvents';

  static Route<dynamic> generateRoute(RouteSettings setting) {
    switch (setting.name) {
      case splashScreen:
        return MaterialPageRoute(builder: (context) => const SplashScreen());
      case introSlider:
        return MaterialPageRoute(builder: (context) => const IntroSliderScreen());
      // case supportScreenForgotPassword:
      //   return MaterialPageRoute(
      //       builder: (context) => const SupportScreenForgotPassword());
      // // case addContact:
      // //   return MaterialPageRoute(builder: (context) => const AddContactPage());
      // case resetForgotPasswordScreen:
      //   return MaterialPageRoute(
      //       builder: (context) => ResetForgotPasswordScreen());
      case forgotPasswordScreen:
        return MaterialPageRoute(builder: (context) => const ForgotPasswordScreen());

      case signupScreen:
        return MaterialPageRoute(builder: (context) => const SignupScreen());
      case logIn:
        return MaterialPageRoute(builder: (context) => const SignInScreen());
      case loginOtpScreen:
        return MaterialPageRoute(builder: (context) => LoginOtpScreen(email: setting.arguments as String));
      case library:
        return MaterialPageRoute(builder: (context) => const PIPGlobalNavigation(childWidget: LibraryRevampPage()));
      case homeScreen:
        return MaterialPageRoute(builder: (context) => const PIPGlobalNavigation(childWidget: HomeScreen()));
      // case webinar:
      //   return MaterialPageRoute(
      //       builder: (context) => const PIPGlobalNavigation(
      //             childWidget: WebinarPage(),
      //           ));
      /*  case presentations:
        return MaterialPageRoute(
            builder: (context) => const PresentationsPage());*/
      case allContacts:
        return MaterialPageRoute(builder: (context) => const PIPGlobalNavigation(childWidget: AllContactsPage()));
      case lobbyScreen:
        return MaterialPageRoute(
          builder: (context) => PIPGlobalNavigation(childWidget: LobbyScreenPage(meetingId: setting.arguments.toString())),
        );
      case lobbyScreenWaiting:
        return MaterialPageRoute(
            builder: (context) => PIPGlobalNavigation(
                  childWidget: LobbyScreenWaiting(
                    meetingUrl: setting.arguments.toString(),
                  ),
                ));
      case allParticipantsPage:
        return MaterialPageRoute(builder: (context) => const PIPGlobalNavigation(childWidget: AllParticipantsPage()));
      case webinarChatScreen:
        return MaterialPageRoute(
            builder: (context) => PIPGlobalNavigation(
                  childWidget: ChatScreen(
                    isFromQAndAScreen: setting.arguments as bool,
                  ),
                ));
      case changePasswordPage:
        return MaterialPageRoute(
            builder: (context) => PIPGlobalNavigation(
                  childWidget: ChangePasswordPage(
                    data: setting.arguments as Map<String, dynamic>,
                    // data: setting.arguments as Map<String, dynamic>,
                  ),
                ));
      case profileScreen:
        return MaterialPageRoute(builder: (context) => const PIPGlobalNavigation(childWidget: ProfileEditScreen()));
      case profilePage:
        return MaterialPageRoute(builder: (context) => const ProfilePage());
      case faqsPage:
        return MaterialPageRoute(builder: (context) => const PIPGlobalNavigation(childWidget: FAQsPage()));
      case createWebinarScreen:
        MeetingDetailsModel? meetingDetailsModel = setting.arguments as MeetingDetailsModel?;
        return MaterialPageRoute(
            builder: (context) => PIPGlobalNavigation(
                    childWidget: CreateWebinarScreen(
                  meetingDetailsModel: meetingDetailsModel,
                )));
      case webinarDashboard:
        return MaterialPageRoute(
          builder: (context) => const PIPGlobalNavigation(childWidget: WebinarDashboard()),
          settings: const RouteSettings(
            name: RoutesManager.webinarDashboard,
          ),
        );
      // case enterEmailForgotPassword:
      //   return MaterialPageRoute(
      //       builder: (context) =>  EnterEmailForgotPassword());
      case forgotpasswordOtpScreen:
        return MaterialPageRoute(
          builder: (context) => ForgotPasswordOtpScreen(
            email: setting.arguments as String,
          ),
        );
      // case presentationScreen:
      //   return MaterialPageRoute(builder: (context) => const Presentation());
      case calender:
        return MaterialPageRoute(builder: (context) => const PIPGlobalNavigation(childWidget: MyCalenderScreen()));
      case viewAllEventsInCalender:
        return MaterialPageRoute(builder: (context) => const PIPGlobalNavigation(childWidget: ViewAllEventsWidget()));
      case termsOfService:
        return MaterialPageRoute(builder: (context) => const TermsOfService());
      case privacyPolicy:
        return MaterialPageRoute(builder: (context) => const PrivacyPolicy());
      case chatbot:
        return MaterialPageRoute(builder: (context) => const PIPGlobalNavigation(childWidget: ChatbotScreen()));
      default:
        throw const FormatException('Route not found! Check routes again');
    }
  }
}
