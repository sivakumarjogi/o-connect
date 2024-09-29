import 'dart:async';
import 'dart:convert';
import 'dart:developer';
import 'dart:io';
import 'dart:math' as math;

import 'package:dio/dio.dart';
import 'package:firebase_dynamic_links/firebase_dynamic_links.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:o_connect/core/common_functions.dart';
import 'package:o_connect/core/models/auth_models/generate_token_o_connect_model.dart';
import 'package:o_connect/core/repository/library_repository/library_repo.dart';
import 'package:o_connect/core/service_locator.dart';
import 'package:o_connect/core/user_cache_service.dart';
import 'package:o_connect/my_app.dart';
import 'package:o_connect/ui/utils/base_urls.dart';
import 'package:o_connect/ui/utils/custom_toast_helper/custom_toast.dart';
import 'package:o_connect/ui/utils/images/images.dart';
import 'package:o_connect/ui/views/authentication/Auth_providers/auth_api_provider.dart';
import 'package:o_connect/ui/views/drawer/library_revamp/library_revamp.dart';
import 'package:o_connect/ui/views/home_screen/home_screen_models/dashboard_banner_model.dart';
import 'package:o_connect/ui/views/home_screen/home_screen_models/get_meetings_info_model.dart';
import 'package:o_connect/ui/views/home_screen/home_screen_models/user_subscription_model.dart';
import 'package:o_connect/ui/views/home_screen/home_screen_view/home_screen.dart';
import 'package:o_connect/ui/views/lobbyscreen_waiting.dart';
import 'package:o_connect/ui/views/meeting_entry_point.dart';
import 'package:o_connect/ui/views/more/more_screen.dart';
import 'package:o_connect/ui/views/pip_views/pip_global_navigation.dart';
import 'package:o_connect/ui/views/webinar_details/webinar_details_model/accept_meeting.dart';
import 'package:o_connect/ui/views/webinar_details/webinar_details_model/invite_details_model.dart';
import 'package:o_connect/ui/views/webinar_details/webinar_details_model/meeting_requests_model.dart';
import 'package:o_connect/ui/views/webinar_details/webinar_details_view/webinar_details_view.dart';
import 'package:o_connect/ui/views/webninar_dashboard/presentation/create_webinar/create_webinar_screen.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:provider/provider.dart';
import 'package:screenshot/screenshot.dart';

import '../../../../core/routes/routes_name.dart';
import '../../../../core/service/api_helper/api_helper.dart';
import '../../../../core/service/download_files_service.dart';
import '../../../utils/constant_strings.dart';
import '../../webinar_details/webinar_details_model/invited_meeting_model.dart';
import '../../webinar_details/webinar_details_model/meeting_details_model.dart';
import '../../webinar_details/webinar_details_provider/webinar_details_provider.dart';
import '../home_repository/home_repository.dart';
import '../home_repository/template_repository.dart';
import '../home_screen_models/chart_webinar_data_model.dart';
import '../home_screen_models/meeting_history_model.dart';
import '../home_screen_models/webinar_paichart_model.dart';

class DashboardBottomNavigationModel {
  String icon;
  String iconTitle;

  DashboardBottomNavigationModel({required this.icon, required this.iconTitle});
}

class HomeScreenProvider extends ChangeNotifier {
  List<Widget> pages = [const DashBoardScreen(), const WebinarDetails(), const CreateWebinarScreen(), const LibraryRevampPage(), const MoreScreen()];

  List<DashboardBottomNavigationModel> bottomNavigationItems = [
    DashboardBottomNavigationModel(icon: AppImages.dashBoardIcon, iconTitle: "Dashboard"),
    DashboardBottomNavigationModel(icon: AppImages.eventsIcon, iconTitle: "Events"),
    DashboardBottomNavigationModel(icon: AppImages.createWebinarIcon, iconTitle: "Create"),
    DashboardBottomNavigationModel(icon: AppImages.libraryIcon, iconTitle: "Library"),
    DashboardBottomNavigationModel(icon: AppImages.moreHomeScreenIcon, iconTitle: "More"),
  ];

  List<DashboardBottomNavigationModel> bottomNavigationSelectedItems = [
    DashboardBottomNavigationModel(icon: AppImages.dashBoardSelectedIcon, iconTitle: "Dashboard"),
    DashboardBottomNavigationModel(icon: AppImages.eventsSelectedIcon, iconTitle: "Events"),
    DashboardBottomNavigationModel(icon: AppImages.createSelectedIcon, iconTitle: "Create"),
    DashboardBottomNavigationModel(icon: AppImages.librarySelectedIcon, iconTitle: "Library"),
    DashboardBottomNavigationModel(icon: AppImages.moreSelectedIcon, iconTitle: "More"),
  ];

  int currentPageIndex = 0;

  void updateCurrentPage(int index) async {
    if (index == 2) {
      bool canCreate = await checkUserSubScription(checkNoOfDays: true);

      if (canCreate) {
        currentPageIndex = index;
        notifyListeners();
        return;
      }
      return;
    }

    currentPageIndex = index;
    notifyListeners();
  }

  HomeApiRepository apiRepository = HomeApiRepository(ApiHelper().oConnectDio, baseUrl: BaseUrls.meetingBaseUrl);
  HomeApiRepository apiUpdateRepository = HomeApiRepository(ApiHelper().oConnectDio, baseUrl: BaseUrls.getMeetingCountUrl);
  HomeApiRepository apiBannerRepository = HomeApiRepository(ApiHelper().oConnectDio, baseUrl: BaseUrls.libraryBaseUrl);

  HomeApiRepository oesRequest = HomeApiRepository(ApiHelper().oesDio, baseUrl: BaseUrls.baseUrl);
  HomeApiRepository meetingHistoryRepository = HomeApiRepository(ApiHelper().oConnectDio, baseUrl: BaseUrls.libraryBaseUrl);
  TemplateRepository templateRepository = TemplateRepository(ApiHelper().oConnectDio, baseUrl: BaseUrls.templateBaseUrl);
  LibraryRepository libraryRepository = LibraryRepository(ApiHelper().oConnectDio, baseUrl: BaseUrls.libraryBaseUrl);

  GetMeetingsInfoModel? getAllMeetingInfoData;
  ChartWebinarData? chartWebinarData;
  List<ChartDatas> chartWebinarDataList = [];
  List<MeetingHistoryModel> getMeetingHistoryList = [];
  List<MeetingDetailsModel> getMeetingList = [];
  List<InviteMeetingDetails> inviteMeetingList = [];
  List<InvitedMeetings> getInviteMeetingList = [];
  DashboardBannerModel dashboardBannerModel = DashboardBannerModel(status: false, data: []);

  List<AcceptMeetingDetailsModel> acceptMeetingList = [];
  List<MeetingRequestsDetailsModel> meetingRequestList = [];
  List<MeetingRequestsDetailsModel> finalUpdatedMeetingRequestList = [];
  int lastStatisticValue = 0;
  double? lastStatisticValueDiv;
  bool statisticsLoading = false;
  bool cancelMeeting = false;
  bool getAllMeetingLoading = false;
  bool getInviteMeetingLoading = false;
  bool getAcceptMeetingLoading = false;
  bool getMeetingRequestLoading = false;
  bool getAllMeetingChartLoading = false;
  bool getAllMeetingHistoryLoading = false;
  bool saveTemplate = false;
  bool isMeetingTransfer = false;
  bool isMeetingAccepted = false;
  bool isAudio = false;
  bool isVideo = false;
  bool isValidOMailIdToTransfer = false;

  setIsValidOMailIdToTransfer(bool value) {
    isValidOMailIdToTransfer = value;
    notifyListeners();
  }

  setAudioValue(bool value) {
    isAudio = value;
    notifyListeners();
  }

  setVideoValue(bool value) {
    isVideo = value;
    notifyListeners();
  }

  String? selectedValue = "Scheduled";

  UserSubscriptionModel? userSubscriptionModel;
  final TextEditingController searchController = TextEditingController();

  List<ChartData> chartData = [];

  Future<void> createDynamicLink(dataUrl) async {
    FirebaseDynamicLinks dynamicLinks = FirebaseDynamicLinks.instance;

    final DynamicLinkParameters parameters = DynamicLinkParameters(
      uriPrefix: 'https://oconnnectofficial.page.link',
      link: Uri.parse("https://example.page/link/${dataUrl.toString()}"),
      androidParameters: const AndroidParameters(packageName: 'com.onpassive.oconnect', minimumVersion: 0),
      iosParameters: const IOSParameters(
        bundleId: 'com.onpassive.oconnect',
      ),
    );

    var shortLink = await dynamicLinks.buildLink(parameters);
    Uri url = shortLink;
    Clipboard.setData(ClipboardData(text: url.toString()));
  }

  Future getDynamicLink(context) async {
    final PendingDynamicLinkData? initialLink = await FirebaseDynamicLinks.instance.getInitialLink();
    debugPrint("Dynamic Link Data ==>> ${initialLink.toString()}");
    if (initialLink != null) {
      CustomToast.showErrorToast(msg: 'Pending link ${initialLink.link}');

      String getLinkData = initialLink.link.path;
      if (context.mounted && getLinkData.isNotEmpty) {
        Navigator.push(navigationKey.currentState!.context, MaterialPageRoute(builder: (context) => LobbyScreenWaiting(meetingUrl: getLinkData)));
      }
    } else {
      Navigator.push(navigationKey.currentState!.context, MaterialPageRoute(builder: (_) => const PIPGlobalNavigation(childWidget: HomeScreen())));
    }
  }

  var initialLink;
  String? getMeetingKey;

  void initDynamicLinks(BuildContext context, link) {
    debugPrint("the link data is the 2  $link");
    debugPrint("the link data is the 1  ");

    if (link == null) {
      sendNavigation(context);

      // FirebaseDynamicLinks.instance.onLink.listen((dynamicLinkData) {
      //   debugPrint("Dynamic Link Data ==>> ${dynamicLinkData.link.path}");
      //   initialLink = dynamicLinkData.link.path;
      //   getMeetingKey = initialLink.split("/")[10].toString();
      //   if (context.mounted && initialLink.isNotEmpty) {
      //     tryJoinMeeting(
      //       context,
      //       meetingUrl: initialLink,
      //       fromUrl: true,
      //     );
      //   }
      // });
    } else {
      initialLink = link.path;
      getMeetingKey = initialLink.split("/")[10].toString();
      if (context.mounted && initialLink.isNotEmpty) {
        tryJoinMeeting(
          context,
          meetingUrl: initialLink,
          fromUrl: true,
        );
      }
    }
  }

  void checkForPendingLinks(BuildContext context) async {
    // context.read<HomeScreenProvider>().initDynamicLinks(context);
    // final PendingDynamicLinkData? initialLink = await FirebaseDynamicLinks.instance.getInitialLink();
    // if (initialLink?.link != null ) {
    //   tryJoinMeeting(context, meetingUrl: initialLink?.link.path.toString());
    // }
  }

  updateWebinars(String updatedValue, BuildContext context) {
    if (updatedValue == ConstantsStrings.upcomingWebinars) {
      selectedValue = "upcoming";
    } else if (updatedValue == ConstantsStrings.pastWebinars) {
      selectedValue = "past";
    } else if (updatedValue == ConstantsStrings.transferWebinars) {
      selectedValue = "transferred";
    } else {
      selectedValue = "cancel";
    }
    getMeetings(context);
    notifyListeners();
  }

  Future<void> getHomePageData() async {
    await Future.wait([
      getMeetingStatisticsInfo(DateFormat("yyyy-M-d").format(DateTime.now().subtract(const Duration(days: 365))), DateFormat("yyyy-M-d").format(DateTime.now())),
      getAllMeetingInfo(),
    ]);
    notifyListeners();
  }

  List webinarData = [];
  List<ChartDatas> chartWebinarDataListData = [];

  Future getMeetingStatisticsInfo(String startDate, String endDate) async {
    chartWebinarDataList = [];
    webinarData = [];
    statisticsLoading = true;
    notifyListeners();
    try {
      var res = await apiRepository.getMeetingStatistics(startDate, endDate);
      // List getStatisticsData = [{"_id":"123", "value": 0, "attendees": "0", "name": ""}];
      List getStatisticsData = res.data['data'];
      print("jhgkjdhgdkhkdf ");

      // if(getStatisticsData.length==1){
      //   getStatisticsData.insert(0, {"_id":"123", "value": 0, "attendees": 0, "name": "Dec"});
      // }
      getStatisticsData.map((e) => {webinarData.add(e["month"].toString().split("-").first)}).toList();

      // print(webinarData);

      if (getStatisticsData.isNotEmpty) {
        chartWebinarDataListData = [];
        for (int i = 0; i < getStatisticsData.length; i++) {
          print("webinarData month   ${getStatisticsData[i]['month']}");
          print("webinarData   ${getStatisticsData[i]['meetings_count']}");
          print("webinarData   ${getStatisticsData[i]['attendees_count']}");

          chartWebinarDataListData.add(
            ChartDatas(
              eventName: getStatisticsData[i]['month'],
              eventValue: getStatisticsData[i]['meetings_count'] ?? 00,
              numberOfParticipants: getStatisticsData[i]['attendees_count'],
            ),
          );

          // chartWebinarDataListData.add(
          //   ChartWebinarData(
          //     getStatisticsData[i]['month'].split("-").last.toString(),
          //     getStatisticsData[i]['meetings_count'] ?? 00,
          //     getStatisticsData[i]['attendees_count'] == 0 ? 1 : getStatisticsData[i]['attendees_count'],
          //   ),
          // );

          // if (i < getStatisticsData.length) {
          //   if (webinarData[i].toString().toLowerCase() == getStatisticsData[i]['name'].split("-").first.toString().toLowerCase()) {
          //     } else {
          //     chartWebinarDataListData.add(ChartWebinarData(webinarData[i].toString().toLowerCase(), 00, 00));
          //   }
          // } else {
          //   chartWebinarDataListData.add(ChartWebinarData(webinarData[i].toString().toLowerCase(), 00, 00));
          // }
        }
      } else {
        chartWebinarDataListData = [];
      }

      log("Stat data ${chartWebinarDataListData.length}");
      final monthOrder = {
        'jan': 1,
        'feb': 2,
        'mar': 3,
        'apr': 4,
        'may': 5,
        'jun': 6,
        'jul': 7,
        'aug': 8,
        'sep': 9,
        'oct': 10,
        'nov': 11,
        'dec': 12,
      };
      chartWebinarDataListData.sort((a, b) {
        final aMonth = monthOrder[a.eventName]!;
        final bMonth = monthOrder[b.eventName]!;
        return aMonth.compareTo(bMonth);
      });
      chartWebinarDataList.addAll(chartWebinarDataListData);

      lastStatisticValue = chartWebinarDataList.map((element) => element.numberOfParticipants).reduce(math.max);
      lastStatisticValue = lastStatisticValue > 5 ? lastStatisticValue + 20 : lastStatisticValue + 1;
      // if ((lastStatisticValue % 2) != 0) {
      //   lastStatisticValue = lastStatisticValue + 1;
      // }
      lastStatisticValueDiv = (double.parse((lastStatisticValue / chartWebinarDataList.length).toString().split(".").first));
      lastStatisticValueDiv = lastStatisticValueDiv != 0 ? lastStatisticValueDiv : 1.0;
      print("vjsdsssfs  ${chartWebinarDataList[0].numberOfParticipants}");
      print("vjsdsssfs  ${chartWebinarDataList[0].eventValue}");
      print("vjsdsssfs  ${chartWebinarDataList[0].eventName}");
      statisticsLoading = false;
    } on DioException catch (e) {
      print("print data ${e.toString()}");
      statisticsLoading = false;
    } catch (e) {
      print("eror $e");
      statisticsLoading = false;
    }
    notifyListeners();
  }

  void selectedNavigation(String? cardName, BuildContext context) {
    var webinarDetailsProvider = Provider.of<WebinarDetailsProvider>(context, listen: false);
    switch (cardName) {
      case "Upcoming Webinars":
        webinarDetailsProvider.selectedValue = ConstantsStrings.upcomingWebinars;
        notifyListeners();
        break;
      case "Cancelled Webinars":
        webinarDetailsProvider.selectedValue = ConstantsStrings.cancelledWebinars;
        notifyListeners();

        break;
      case "Completed Webinars":
        webinarDetailsProvider.selectedValue = ConstantsStrings.pastWebinars;
        notifyListeners();
        break;
      case "Transfer Webinars":
        webinarDetailsProvider.selectedValue = ConstantsStrings.transferWebinars;
        notifyListeners();

        break;
    }
    updateWebinars(webinarDetailsProvider.selectedValue, context);
    if (context.mounted) {
      Navigator.pushNamed(context, RoutesManager.webinar);
    }
  }

  Future getAllMeetingInfo() async {
    chartData = [];
    getAllMeetingChartLoading = true;
    SchedulerBinding.instance.addPostFrameCallback((timeStamp) {
      notifyListeners();
    });
    try {
      final String? userDataString = await serviceLocator<UserCacheService>().getUserData("userData");

      GenerateTokenUser userData = GenerateTokenUser.fromJson(jsonDecode(userDataString!));
      var body = {"userEmail": userData.userEmail, "userId": userData.id};
      var res = await apiUpdateRepository.getAllMeetingInfo(
        body,
      );

      print("data response ${res.data}");
      if (res.statusCode != 200) {
        chartData = [];

        getAllMeetingInfoData = null;
      } else {
        getAllMeetingInfoData = GetMeetingsInfoModel.fromJson(res.data);

        if (getAllMeetingInfoData!.meetingsCount!.first.createdMeetingCount != 0) {
          chartData.add(ChartData(eventName: "Upcoming", eventValue: getAllMeetingInfoData!.meetingsCount!.first.createdMeetingCount!.toDouble(), eventColor: const Color(0xff22B07D)));
        }

        if (getAllMeetingInfoData!.meetingsCount?.first.transferredMeetingCount != 0) {
          chartData.add(ChartData(eventName: "Transferred", eventValue: getAllMeetingInfoData!.meetingsCount!.first.transferredMeetingCount!.toDouble(), eventColor: const Color(0xff22B07D)));
        }

        if (getAllMeetingInfoData!.meetingsCount!.first.attendedMeetingCount != 0) {
          chartData.add(ChartData(eventName: "Past", eventValue: getAllMeetingInfoData!.meetingsCount!.first.attendedMeetingCount!.toDouble(), eventColor: const Color(0xff12CDD9)));
        }

        if (getAllMeetingInfoData!.meetingsCount!.first.cancelledMeetingCount != 0) {
          chartData.add(ChartData(eventName: "Cancelled", eventValue: getAllMeetingInfoData!.meetingsCount!.first.cancelledMeetingCount!.toDouble(), eventColor: const Color(0xffF67171)));
        }
        if (getAllMeetingInfoData!.meetingsCount!.first.invitedMeetingsCount != 0) {
          chartData.add(ChartData(eventName: "Cancelled", eventValue: getAllMeetingInfoData!.meetingsCount!.first.invitedMeetingsCount!.toDouble(), eventColor: const Color(0xffF67171)));
        }
      }

      getAllMeetingChartLoading = false;
    } on DioException catch (e) {
      getAllMeetingChartLoading = false;
      debugPrint("the dio error is the ${e.response}");
    } catch (e) {
      getAllMeetingChartLoading = false;
    }
    notifyListeners();
  }

  Future getMeetings(
    BuildContext context, {
    String searchHistory = "",
    String selectedValue = "",
  }) async {
    getAllMeetingLoading = true;
    getMeetingList.clear();
    notifyListeners();
    final String? userDataString = await serviceLocator<UserCacheService>().getUserData("userData");

    GenerateTokenUser userData = GenerateTokenUser.fromJson(jsonDecode(userDataString!));
    try {
      var body = {
        "ItemsPerPage": 1000,
        "currentPage": 1,
        "durationType": selectedValue,
        "eventCategory": "meeting",
        "filterFlag": "asc",
        "searchText": searchHistory,
        "limit": 1000,
        "userEmail": userData.userEmail
      };
      print("upcoming meetings body    $body");

      Response res = await apiRepository.getMeetings(body);
      print("upcoming meetings response    ${res.data}");

      List data = res.data['data'].first;
      if (data.isEmpty) {
        getMeetingList.remove(MeetingDetailsModel());
      } else {
        getMeetingList = data.reversed.map((e) => MeetingDetailsModel.fromJson(e)).toList();
      }

      getAllMeetingLoading = false;
      notifyListeners();
    } on DioException catch (e, st) {
      debugPrint("the error is the ${e.response.toString()} && ${e.error} && $st");
      getAllMeetingLoading = false;
      getMeetingList = [];
    } catch (e) {
      getAllMeetingLoading = false;
      getMeetingList = [];
    }
    notifyListeners();
  }

  bool isInvitedMeetings = false;

  Future<void> invitedMeetings(BuildContext context, String meetingID, int isInviteAccepted) async {
    getInviteMeetingList = [];
    isInvitedMeetings = true;
    final String? userDataString = await serviceLocator<UserCacheService>().getUserData("userData");

    GenerateTokenUser userData = GenerateTokenUser.fromJson(jsonDecode(userDataString!));

    var body = {"userEmail": userData.userEmail.toString(), "isInviteAccepted": isInviteAccepted};

    print("invited meeting body ${body.toString()}");
    try {
      Response res = await apiUpdateRepository.inviteMeetings(body);
      print("invited meeting data ${getInviteMeetingList.toString()}");

      List getMeetingList = res.data['data'];

      for (int i = 0; i < getMeetingList.length; i++) {
        if (getMeetingList[i]['is_invitation_accepted'] != 2) {
          getInviteMeetingList.add(InvitedMeetings.fromJson(getMeetingList[i]));
        }
      }
      isInvitedMeetings = false;
      notifyListeners();
    } on DioException catch (e) {
      print("invited meeting dio error ${e.response?.data.toString()}");
      isInvitedMeetings = false;
    } catch (e) {
      print("invited meeting error ${e.toString()}");
      isInvitedMeetings = false;
    }
    notifyListeners();
  }

  Future<void> invitedUpDataMeetings(BuildContext context, String meetingID, int isInviteAccepted, {bool isReceived = false}) async {
    isInvitedMeetings = true;
    final String? userDataString = await serviceLocator<UserCacheService>().getUserData("userData");

    GenerateTokenUser userData = GenerateTokenUser.fromJson(jsonDecode(userDataString!));

    var body = {"meetingId": meetingID, "userEmail": userData.userEmail.toString(), "isInviteAccepted": isInviteAccepted};

    print("invited meeting body ${body.toString()}");
    try {
      Response res = await apiUpdateRepository.invitePutMeetings(body);
      print("invited meeting data ${getInviteMeetingList.toString()}");

      if (meetingID != "" && !isReceived) {
        invitedMeetings(context, "", 0);
        CustomToast.showSuccessToast(msg: res.data['message']);
      } else {
        getMeetingRequests();
        CustomToast.showSuccessToast(msg: res.data['message']);
      }
      isInvitedMeetings = false;
      notifyListeners();
    } on DioException catch (e) {
      print("invited meeting dio error ${e.response?.data.toString()}");
      isInvitedMeetings = false;
    } catch (e) {
      print("invited meeting error ${e.toString()}");
      isInvitedMeetings = false;
    }
    notifyListeners();
  }

  Future getInviteMeetings() async {
    getInviteMeetingLoading = true;
    inviteMeetingList = [];
    inviteMeetingList.remove(InviteMeetingDetails());

    try {
      final String? userDataString = await serviceLocator<UserCacheService>().getUserData("userData");

      GenerateTokenUser userData = GenerateTokenUser.fromJson(jsonDecode(userDataString!));
      var body = {"ItemsPerPage": 50, "currentPage": 1, "durationType": selectedValue, "eventCategory": "meeting", "filterFlag": "asc", "isInviteAccepted": 1, "userEmail": userData.userEmail};
      print("request meetings data    $body");

      Response res = await apiUpdateRepository.getInviteMeetings(body);
      print("request meetings data    ${res.data}");

      List data = res.data['data'];
      try {
        inviteMeetingList = data.reversed.map((e) => InviteMeetingDetails.fromJson(e)).toList();
      } catch (e, st) {
        print("the error is the ${e.toString()} && $st");
      }

      getInviteMeetingLoading = false;
    } on DioException catch (e) {
      getInviteMeetingLoading = false;
    } catch (e) {
      getInviteMeetingLoading = false;
    }
    notifyListeners();
  }

  List<DashboardBannerModelData> dashboardBannerModelData = [];

  Future getAllBanners() async {
    try {
      final String? userDataString = await serviceLocator<UserCacheService>().getUserData("userData");

      GenerateTokenUser userData = GenerateTokenUser.fromJson(jsonDecode(userDataString!));
      var body = {"user_id": userData.id, "purpose": "Banner"};
      print("sdnjfdjfbjhdb $body");

      Response res = await apiBannerRepository.getAllBanners("${userData.id}", "Banner");

      List data = res.data['data'] ?? [];
      dashboardBannerModelData = data
          .map(
            (e) => DashboardBannerModelData.fromJson(e),
          )
          .toList();
      print("request meetings data    $data");
    } on DioException catch (e) {
      print("the error is the ${e.toString()}");
    } catch (e) {
      print("the error is the ${e.toString()}");
    }
    notifyListeners();
  }

  Future acceptMeeting({required String meetingId, required BuildContext context, required int inviteAccepted}) async {
    isMeetingAccepted = true;
    getAcceptMeetingLoading = true;
    acceptMeetingList = [];
    acceptMeetingList.remove(AcceptMeetingDetailsModel());

    try {
      final String? userDataString = await serviceLocator<UserCacheService>().getUserData("userData");

      GenerateTokenUser userData = GenerateTokenUser.fromJson(jsonDecode(userDataString!));
      var body = {
        "userEmail": userData.userEmail,
        "isInviteAccepted": inviteAccepted,
        "meetingId": meetingId,
      };
      print("response ids the resoinbe    $body");
      Response res = await ApiHelper().oConnectDio.put(
            '${BaseUrls.meetingRequests}/userData/update-invite-status',
            data: body,
          );

      print("response ids the resoinbe    ${res.data}");

      print("shjhdjh ${res.data}");
      if (res.data['status'] == true) {
        if (context.mounted) {
          isMeetingAccepted = false;
          CustomToast.showSuccessToast(msg: res.data["message"]);
          getMeetingRequests();
          getInviteMeetings();
        }
      }

      getAcceptMeetingLoading = false;
    } on DioException catch (e) {
      print("gndfgfdhgogo  ${e.response?.toString()}");
      CustomToast.showErrorToast(msg: e.response?.data['data'].toString());
      isMeetingAccepted = false;
    } catch (e) {
      print("rgidrhgirehgr   ${e.toString()}");

      CustomToast.showErrorToast(msg: e.toString());
      isMeetingTransfer = false;
    }
    notifyListeners();
  }

  Future getMeetingRequests() async {
    getMeetingRequestLoading = true;
    meetingRequestList = [];
    meetingRequestList.remove(MeetingRequestsDetailsModel());
    print("response ids the response  ");
    try {
      final String? userDataString = await serviceLocator<UserCacheService>().getUserData("userData");

      GenerateTokenUser userData = GenerateTokenUser.fromJson(jsonDecode(userDataString!));
      var body = {"userEmail": userData.userEmail.toString(), "ItemsPerPage": 10, "currentPage": 1, "filterFlag": "asc", "isInviteAccepted": 1};
      print("response ids the response    $body");
      Response res = await apiUpdateRepository.getMeetingRequests(body);

      print("response ids the response  sampada  ${res.data}");

      List data = (res.data['data'] as Map)['meetings'];
      print('sampada.... $data');
      meetingRequestList = data.reversed.map((e) => MeetingRequestsDetailsModel.fromJson(e)).toList();

      getMeetingRequestLoading = false;
    } on DioException catch (e) {
      getMeetingRequestLoading = false;
      print('sampada.... ${e.response!.data.toString()}');
    } catch (e) {
      getMeetingRequestLoading = false;
      print('sampada.... ${e.toString()}');
    }
    notifyListeners();
  }

  void localSearchForMeetingRequest(String searchedText) {
    print(searchedText);
    finalUpdatedMeetingRequestList = [];
    if (searchedText.length > 2) {
      finalUpdatedMeetingRequestList.addAll(meetingRequestList.where((element) => element.meetingName!.toLowerCase().toString().contains(searchedText.toLowerCase())).toList());
      notifyListeners();
      return;
    }
    if (searchedText.isEmpty) {
      finalUpdatedMeetingRequestList = meetingRequestList;
      notifyListeners();
      return;
    }
    if (searchedText.isNotEmpty) {
      finalUpdatedMeetingRequestList = meetingRequestList;
      notifyListeners();
      return;
    }
  }

  Future deleteMeeting({required String meetingId, String? emailId, required String userName, required String reason, bool fromCalender = false, required BuildContext context}) async {
    cancelMeeting = true;
    notifyListeners();
    try {
      var body = {"meeting_id": meetingId, "reason": reason, "userName": userName, "user_email": emailId};
      Response res = await apiRepository.deleteMeeting(body);
      if (res.data['status'] == true) {
        if (context.mounted) {
          getMeetings(context, searchHistory: "", selectedValue: "upcoming");
          Navigator.pop(context);
          Navigator.pop(context);
          if (fromCalender) {
            Navigator.pop(context, true);
          }
          CustomToast.showSuccessToast(msg: "Meeting Cancel Successfully");
        }
      }
      cancelMeeting = false;
    } on DioException catch (e) {
      cancelMeeting = false;
      Navigator.pop(context);
      CustomToast.showErrorToast(msg: e.response?.data['error'].toString());
    } catch (e) {
      cancelMeeting = false;
      Navigator.pop(context);
    }
    notifyListeners();
  }

  Future deletePastMeeting({
    required String meetingId,
    required BuildContext context,
    required String meetingType,
  }) async {
    cancelMeeting = true;
    notifyListeners();
    try {
      var body = {
        "meeting_id": meetingId,
      };
      print("mneeeee  $body - $meetingType");
      Response res = await apiRepository.deletePastMeeting(body);
      print(res.data.toString());
      if (res.data['status'] == true) {
        if (context.mounted) {
          getMeetings(context, selectedValue: meetingType);
          Navigator.pop(context);
          Navigator.pop(context);
          CustomToast.showSuccessToast(msg: "Webinar deleted successfully");
        }
      }
      cancelMeeting = false;
    } on DioException catch (e) {
      cancelMeeting = false;
      Navigator.pop(context);
      CustomToast.showErrorToast(msg: e.response?.data['error'].toString());
    } catch (e) {
      cancelMeeting = false;
      Navigator.pop(context);
    }
    notifyListeners();
  }

  Future saveMeetingTemplate(MeetingDetailsModel dataList, String templateName, BuildContext context) async {
    saveTemplate = true;
    notifyListeners();
    try {
      var body = {"meeting_id": dataList.id.toString(), "name": templateName, "meeting_type": dataList.meetingType, "meeting_name": dataList.meetingName};

      final res = await templateRepository.createTemplate(body);
      if (res.data['status'] == true) {
        if (context.mounted) {
          saveTemplate = false;
          Navigator.pop(context);
          Navigator.pop(context);
          CustomToast.showSuccessToast(msg: "The template was saved successfully");
        }
      }
    } on DioException catch (e) {
      CustomToast.showErrorToast(msg: e.response?.data['error'].toString());
      saveTemplate = false;
    } catch (e) {
      CustomToast.showErrorToast(msg: e.toString());
      saveTemplate = false;
    }
    notifyListeners();
  }

  Future transferMeetingData(MeetingDetailsModel dataList, String oMailId, BuildContext context) async {
    isMeetingTransfer = true;

    print(dataList.id);
    print(dataList.userId);
    print(dataList.userEmail);
    notifyListeners();
    try {
      var body = {"_id": dataList.id.toString(), "userEmail": dataList.userEmail.toString(), "userId": dataList.userId.toString(), "selectedUserEmail": oMailId};
      print(body.toString());

      final res = await apiRepository.transferMeeting(body);
      print(res.data.toString());
      if (res.data['status'] == true) {
        if (context.mounted) {
          isMeetingTransfer = false;
          getMeetings(context);
          Navigator.pop(context);
          Navigator.pop(context);
          CustomToast.showSuccessToast(msg: "Meeting Transfer Successfully");
        }
      }
    } on DioException catch (e) {
      print("gndfgfdhgogo  ${e.response?.toString()}");
      CustomToast.showErrorToast(msg: e.response?.data['data'].toString());
      isMeetingTransfer = false;
    } catch (e) {
      print("rgidrhgirehgr   ${e.toString()}");

      CustomToast.showErrorToast(msg: e.toString());
      isMeetingTransfer = false;
    }
    notifyListeners();
  }

  Future getPdfStatistics(BuildContext context, ScreenshotController screenshotController) async {
    screenshotController.capture(delay: const Duration(milliseconds: 10)).then((capturedImage) async {
      getPdf(capturedImage!);
    }).catchError((onError) {});
  }

  Future getPdf(Uint8List screenShot) async {
    final image = pw.MemoryImage(screenShot);

    final pdf = pw.Document();
    pdf.addPage(pw.Page(
        pageFormat: PdfPageFormat.a4,
        build: (pw.Context context) {
          return pw.Center(child: pw.Image(image));
        }));
    try {
      final dirPath = await createFolder();
      final file = File('$dirPath/webinar_statistics${DateTime.now().millisecond}.pdf');
      final val = await file.writeAsBytes(await pdf.save());
      CustomToast.showSuccessToast(msg: "Successfully Downloaded");
    } catch (e) {}
  }

  Future<int?> getSubScriptionEndDate(BuildContext context) async {
    try {
      String emailId = Provider.of<AuthApiProvider>(context, listen: false).profileData!.data!.emailId.toString();
      String customerId = Provider.of<AuthApiProvider>(context, listen: false).profileData!.data!.customerAccounts!.first.custAffId.toString();
      serviceLocator<UserCacheService>().saveCustomerAccounntId(customerId);
      Response response = await oesRequest.getOconnectSubscriptionDetails(emailId);
      UserSubscriptionModel res = await oesRequest.checkSubscribedProducts(customerId);
      userSubscriptionModel = res;
      debugPrint("the user o_mail is the $emailId && ${response.data} ");
      if (response.data["emailExists"]) {
        if (response.data["subcriptionDetails"] is List) {
          DateTime subEndDate = DateTime.parse(response.data["subcriptionDetails"].first["subs_end_date"]);
          int noOfDays = subEndDate.difference(DateTime.now()).inDays;
          return noOfDays;
        } else {
          return null;
        }
        // if (context.mounted) {
        //   showDialog(context: context, builder: (context) => const CheckSubscriptionPopUp());
        // }
      }
    } on DioException catch (e) {
      debugPrint("the dio error is the ${e.error} && ${e.response}");
      return null;
      // CustomToast.showErrorToast(msg: e.response);
    } catch (e) {
      return null;
      // CustomToast.showErrorToast(msg: e.toString());
    }
    return null;
  }

  Future<void> joinMeetingById(String meetingId, BuildContext context) async {
    try {
      final body = {"auto_generated_id": meetingId};
      print("jkkjsdkjhfksd $body");
      Response response = await apiRepository.joinMeetingById(body);
      print('response ----- ${response.data}');
      if (response.data["status"]) {
        tryJoinMeeting(navigationKey.currentContext!, meetingId: response.data["data"]["_id"], fromUrl: false);
      } else {
        if (response.data['error'] == 'meetingExpired') {
          CustomToast.showErrorToast(msg: "Invalid Event ID");
        }
      }
    } on DioException catch (e, st) {
      CustomToast.showErrorToast(msg: e.response!.data['error']);
      debugPrint("Error while join meeting by Id ${e.error} && ${e.response}");
    }
  }

  void cleanData() {
    getAllMeetingInfoData = null;
    getMeetingHistoryList.isEmpty;
    chartWebinarDataList.isEmpty;
    chartData.isEmpty;
  }

  void reSetData(context, String selectedTabData) {
    searchController.clear();
    getMeetingList.remove(MeetingDetailsModel());
    getMeetingList = [];
    getAllMeetingLoading = true;

    print("jdhfjshfgsjfsjfjfdsjffgdsj  $selectedTabData");
    getMeetings(context, searchHistory: "", selectedValue: selectedTabData);
    notifyListeners();
  }

  Future sendNavigation(BuildContext context) async {
    var data = FirebaseDynamicLinks.instance.getInitialLink();
    var dynamicLinkData = await data.then(
          (value) => value,
    );
    print("sskdfdskjksfskfdf ${dynamicLinkData?.link}");
    print("sskdfdskjksfskfdf ${dynamicLinkData?.link.path}");
    initialLink = dynamicLinkData?.link.path;

    print("sskdfdskjksfskfdf $initialLink");

    getMeetingKey = initialLink?.split("/")[10].toString();
    if (context.mounted && initialLink != null && initialLink?.isNotEmpty) {
      if (initialLink == null) {
        return;
      }
      getMeetingKey = initialLink.split("/")[10].toString();
      if (context.mounted && initialLink.isNotEmpty) {
        tryJoinMeeting(
          context,
          meetingUrl: initialLink ?? "",
          fromUrl: true,
        );
      }
    }
  }
}
