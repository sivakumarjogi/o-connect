import 'dart:async';
import 'dart:math';
import 'package:firebase_dynamic_links/firebase_dynamic_links.dart';
import 'package:flutter/material.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_session_jwt/flutter_session_jwt.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_svg/svg.dart';
import 'package:o_connect/core/common_functions.dart';
import 'package:o_connect/core/providers/app_global_state_provider.dart';
import 'package:o_connect/core/providers/default_user_data_provider.dart';
import 'package:o_connect/core/screen_configs.dart';
import 'package:o_connect/core/service/api_helper/api_helper.dart';
import 'package:o_connect/core/service_locator.dart';
import 'package:o_connect/core/user_cache_service.dart';
import 'package:o_connect/ui/utils/buttons_helper/custom_botton.dart';
import 'package:o_connect/ui/utils/colors/colors.dart';
import 'package:o_connect/ui/utils/common_app_bar/common_appbar.dart';
import 'package:o_connect/ui/utils/constant_strings.dart';
import 'package:o_connect/ui/utils/custom_show_dialog_helper/custom_show_dialog.dart';
import 'package:o_connect/ui/utils/textfield_helper/app_fonts.dart';
import 'package:o_connect/ui/utils/textfield_helper/common_textfield.dart';
import 'package:o_connect/ui/views/authentication/Auth_providers/auth_api_provider.dart';
import 'package:o_connect/ui/views/home_screen/home_screen_provider/home_screen_provider.dart';
import 'package:o_connect/ui/views/home_screen/home_screen_view/webinar_pai_chart_view.dart';
import 'package:o_connect/ui/views/home_screen/home_screen_view/webinar_statistics_view.dart';
import 'package:o_connect/ui/views/profile_screen/profile_provider/profile_api_provider.dart';
import 'package:o_connect/ui/views/webinar_details/webinar_details_provider/webinar_details_provider.dart';
import 'package:o_connect/ui/views/webninar_dashboard/presentation/create_webinar/provider/create_webinar_provider.dart';
import 'package:oes_chatbot/utils/extensions/sizedbox_extension.dart';
import 'package:provider/provider.dart';

import '../../../utils/custom_toast_helper/custom_toast.dart';
import '../../../utils/images/images.dart';
import '../../drawer/drawer_viewmodel.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  ApiHelper apiHelper = ApiHelper();
  late HomeScreenProvider homeScreenProvider;
  StreamSubscription<PendingDynamicLinkData>? _dynamicLinkStream;

  @override
  void initState() {
    //  Provider.of<DrawerViewModel>(context, listen: false)
    //         .mainSelectedChange(ConstantsStrings.home);
    homeScreenProvider =
        Provider.of<HomeScreenProvider>(context, listen: false);
    homeScreenProvider.cleanData();

    Future.delayed(Duration.zero).then((value) {
      homeScreenProvider.getHomePageData();
    });

    context
        .read<DrawerViewModel>()
        .mainSelectedChange(ConstantsStrings.home, fromInitState: true);
    apiHelper.updateAuthorization().then((value) async {
      final oconnectToken =
          await serviceLocator<UserCacheService>().getOConnectToken();
      await FlutterSessionJwt.saveToken(oconnectToken.toString());
      final res = await FlutterSessionJwt.getExpirationDateTime();

      Provider.of<AuthApiProvider>(context, listen: false)
          .getProfile()
          .then((value) async {
        var data = FirebaseDynamicLinks.instance.getInitialLink();
        var dynamicLinkData = await data.then(
          (value) => value,
        );

        if (dynamicLinkData == null) {
          debugPrint("the link data is the null  $dynamicLinkData ");
          await checkUserSubScription(checkNoOfDays: true);
        } else {
          debugPrint("the link data is the ${dynamicLinkData.link}");
          homeScreenProvider.initDynamicLinks(context, dynamicLinkData.link);
        }
      });

      debugPrint("the expire token time is the $res ${res.runtimeType}");
      // Provider.of<LibraryProvider>(context, listen: false).fetchMeetingHistoryFirstLoading(body: true);
      Provider.of<WebinarDetailsProvider>(context, listen: false).setDates();
      context.read<ProfileScreenProvider>().getProfileInfo();
      Provider.of<DefaultUserDataProvider>(context, listen: false)
          .getSetAsDefaultData(context: context);
    });

    // homeScreenProvider?.initDynamicLinks(context);

    super.initState();
  }

  @override
  void dispose() {
    // Provider.of<WebinarDetailsProvider>(context, listen: false).clearDates();
    _dynamicLinkStream?.cancel();
/*    homeScreenProvider?.cleanData();
    meetingHistoryController.dispose();
    mainController.dispose();*/
    super.dispose();
  }

  DateTime? currentBackPressTime;

  Future<bool> onWillPop() {
    if (homeScreenProvider.currentPageIndex != 0) {
      homeScreenProvider.updateCurrentPage(0);
      return Future.value(false);
    }
    DateTime now = DateTime.now();
    if (currentBackPressTime == null ||
        now.difference(currentBackPressTime!) > const Duration(seconds: 2)) {
      currentBackPressTime = now;
      CustomToast.showInfoToast(
          msg: "back again to exit", duration: const Duration(seconds: 1));
      return Future.value(false);
    }
    return Future.value(true);
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
        onWillPop: onWillPop,
        child: Consumer3<HomeScreenProvider, WebinarDetailsProvider,AppGlobalStateProvider>(
            builder: (context, value, provider,appGlobalStateProvider, child) => AbsorbPointer(
              absorbing: !appGlobalStateProvider.isConnected,
              child: Scaffold(
                    bottomNavigationBar: BottomNavigationBar(
                      selectedItemColor: Colors.blue,
                      items: List.generate(
                        value.bottomNavigationItems.length,
                        (index) {
                          return BottomNavigationBarItem(
                            backgroundColor:
                                Theme.of(context).scaffoldBackgroundColor,
                            icon: Padding(
                              padding: EdgeInsets.all(4.0.sp),
                              child: SvgPicture.asset(
                                value.currentPageIndex == index
                                    ? value
                                        .bottomNavigationSelectedItems[index].icon
                                    : value.bottomNavigationItems[index].icon,
                                color: value.currentPageIndex == index
                                    ? Colors.blue
                                    : const Color(0xff8F93A3),
                                height: 25.h,
                              ),
                            ),
                            label: value.currentPageIndex == index
                                ? value.bottomNavigationSelectedItems[index]
                                    .iconTitle
                                : value.bottomNavigationItems[index].iconTitle,
                            // activeIcon: SvgPicture.asset(value.bottomNavigationSelectedItems[index].icon,
                            //     color:  Colors.blue ),
                          );
                        },
                      ),
                      currentIndex: value.currentPageIndex,
                      unselectedItemColor: const Color(0xff8F93A3),
                      unselectedFontSize: 12,
                      unselectedLabelStyle: w400_10Poppins(
                          color: Theme.of(context).primaryColorLight),
                      selectedLabelStyle:
                          w400_10Poppins(color: AppColors.mainBlueColor),
                      showUnselectedLabels: true,
                      onTap: (int index) {
                        print("object $index ");
                        homeScreenProvider.updateCurrentPage(index);
                        provider.searchField = false;
                        Provider.of<CreateWebinarProvider>(context, listen: false)
                            .toggleEventRemainder(false);
                        Provider.of<CreateWebinarProvider>(context, listen: false)
                            .selectedTime = '';

                        ///Todo, not a
                        setState(() {
                          provider.selectedRadioValue = 1;
                          provider.isCreated = true;
                          provider.initialIndex = 0;
                        });
                        print("jdhsg ${provider.isCreated}");
                      },
                    ),
                    resizeToAvoidBottomInset: false,
                    body: SafeArea(
                        child: Scaffold(
                            backgroundColor:
                                Theme.of(context).scaffoldBackgroundColor,
                            drawerEnableOpenDragGesture: false,
                            appBar: commonAppBar(context),
                            body: value.pages[value.currentPageIndex])),
                  ),
            )));
  }
}

class DashBoardScreen extends StatefulWidget {
  const DashBoardScreen({super.key});

  @override
  State<DashBoardScreen> createState() => _DashBoardScreenState();
}

class _DashBoardScreenState extends State<DashBoardScreen> {
  ScrollController mainController = ScrollController();
  ScrollController meetingHistoryController = ScrollController();

  @override
  Widget build(BuildContext context) {
    return Consumer2<HomeScreenProvider, AppGlobalStateProvider>(
        builder: (context, homeScreenProvider, appGlobalStateProvider, child) {
      return Padding(
        padding: EdgeInsets.all(10.0.sp),
        child: SingleChildScrollView(
          controller: mainController,
          scrollDirection: Axis.vertical,
          child: Wrap(
            spacing: 10,
            runSpacing: 10,
            children: [
              Consumer<HomeScreenProvider>(
                  builder: (context, homeScreenProvider, child) {
                return SizedBox(
                  height: 130.h,
                  child: ListView.builder(
                      itemCount: 1,
                      shrinkWrap: true,
                      scrollDirection: Axis.horizontal,
                      itemBuilder: (context, i) {
                        return Row(
                          children: [
                            GestureDetector(
                              onTap: () {
                                homeScreenProvider.updateCurrentPage(1);
                              },
                              child: Padding(
                                padding: const EdgeInsets.all(4.0),
                                child: webinarsRowItem(
                                  backgroundColor:
                                      const Color(0xff0E78F9).withOpacity(.2),
                                  iconName: AppImages.createdIcon,
                                  textTile: "Created",
                                  titleTxtColor: Colors.blue,
                                  value: homeScreenProvider
                                              .getAllMeetingInfoData !=
                                          null
                                      ? "${homeScreenProvider.getAllMeetingInfoData!.meetingsCount!.isNotEmpty ? homeScreenProvider.getAllMeetingInfoData?.meetingsCount?.first.createdMeetingCount : 0}"
                                      : "0",
                                ),
                              ),
                            ),
                            GestureDetector(
                              onTap: () {
                                CustomToast.showInfoToast(
                                    msg: "Coming soon....");
                              },
                              child: Padding(
                                padding: const EdgeInsets.all(4.0),
                                child: webinarsRowItem(
                                  backgroundColor:
                                      const Color(0xffBA26FF).withOpacity(.12),
                                  iconName: AppImages.recurringIcon,
                                  textTile: "Recurring",
                                  titleTxtColor: Colors.purple,
                                  value: "Coming soon",
                                ),
                              ),
                            ),
                            GestureDetector(
                                onTap: () {
                                  homeScreenProvider.updateCurrentPage(1);
                                  Provider.of<WebinarDetailsProvider>(context,
                                          listen: false)
                                      .updateInitialIndex(2);
                                },
                                child: Padding(
                                  padding: const EdgeInsets.all(4.0),
                                  child: webinarsRowItem(
                                    backgroundColor: const Color(0xffED9D03)
                                        .withOpacity(0.2),
                                    iconName: AppImages.transferredIcon,
                                    textTile: "Transferred",
                                    titleTxtColor: Colors.orange,
                                    value: homeScreenProvider
                                                    .getAllMeetingInfoData !=
                                                null &&
                                            homeScreenProvider
                                                    .getAllMeetingInfoData!
                                                    .meetingsCount !=
                                                null
                                        ? (homeScreenProvider
                                                .getAllMeetingInfoData!
                                                .meetingsCount!
                                                .isNotEmpty
                                            ? homeScreenProvider
                                                .getAllMeetingInfoData!
                                                .meetingsCount!
                                                .first
                                                .transferredMeetingCount
                                                .toString()
                                            : "0")
                                        : "0",
                                  ),
                                )),
                            GestureDetector(
                              onTap: () {
                                homeScreenProvider.updateCurrentPage(1);
                                Provider.of<WebinarDetailsProvider>(context,
                                        listen: false)
                                    .updateInitialIndex(1);
                              },
                              child: Padding(
                                padding: const EdgeInsets.all(4.0),
                                child: webinarsRowItem(
                                  backgroundColor:
                                      const Color(0xff00B775).withOpacity(0.2),
                                  iconName: AppImages.completedIcon,
                                  textTile: "Completed",
                                  titleTxtColor: Colors.green,
                                  value: homeScreenProvider
                                              .getAllMeetingInfoData !=
                                          null
                                      ? (homeScreenProvider
                                                      .getAllMeetingInfoData!
                                                      .meetingsCount !=
                                                  null &&
                                              homeScreenProvider
                                                  .getAllMeetingInfoData!
                                                  .meetingsCount!
                                                  .isNotEmpty
                                          ? homeScreenProvider
                                              .getAllMeetingInfoData!
                                              .meetingsCount!
                                              .first
                                              .attendedMeetingCount
                                              .toString()
                                          : "0")
                                      : "0",
                                ),
                              ),
                            ),
                            GestureDetector(
                                onTap: () {
                                  homeScreenProvider.updateCurrentPage(1);
                                  Provider.of<WebinarDetailsProvider>(context,
                                          listen: false)
                                      .updateInitialIndex(3);
                                },
                                child: Padding(
                                  padding: const EdgeInsets.all(4.0),
                                  child: webinarsRowItem(
                                    backgroundColor: const Color(0xffE84622)
                                        .withOpacity(0.2),
                                    iconName: AppImages.cancelledIcon,
                                    textTile: "Cancelled",
                                    titleTxtColor: Colors.red,
                                    value: homeScreenProvider
                                                .getAllMeetingInfoData !=
                                            null
                                        ? (homeScreenProvider
                                                        .getAllMeetingInfoData!
                                                        .meetingsCount !=
                                                    null &&
                                                homeScreenProvider
                                                    .getAllMeetingInfoData!
                                                    .meetingsCount!
                                                    .isNotEmpty
                                            ? homeScreenProvider
                                                .getAllMeetingInfoData!
                                                .meetingsCount!
                                                .first
                                                .cancelledMeetingCount
                                                .toString()
                                            : "0")
                                        : "0",
                                  ),
                                )),
                            GestureDetector(
                              onTap: () {
                                homeScreenProvider.updateCurrentPage(1);
                                Provider.of<WebinarDetailsProvider>(context,
                                        listen: false)
                                    .selectedRadioValue = 2;
                                Provider.of<WebinarDetailsProvider>(context,
                                        listen: false)
                                    .isCreated = false;
                              },
                              child: Padding(
                                padding: const EdgeInsets.all(4.0),
                                child: webinarsRowItem(
                                  backgroundColor:
                                      const Color(0xff00ABF4).withOpacity(0.2),
                                  iconName: AppImages.invitedIcon,
                                  textTile: "Invited",
                                  titleTxtColor: Colors.blue,
                                  value: homeScreenProvider
                                              .getAllMeetingInfoData !=
                                          null
                                      ? (homeScreenProvider
                                                      .getAllMeetingInfoData!
                                                      .meetingsCount !=
                                                  null &&
                                              homeScreenProvider
                                                  .getAllMeetingInfoData!
                                                  .meetingsCount!
                                                  .isNotEmpty
                                          ? homeScreenProvider
                                              .getAllMeetingInfoData!
                                              .meetingsCount!
                                              .first
                                              .invitedMeetingsCount
                                              .toString()
                                          : "0")
                                      : "0",
                                ),
                              ),
                            ),
                          ],
                        );
                      }),
                );
              }),

              Consumer<HomeScreenProvider>(
                  builder: (context, homeScreenProvider, child) {
                return Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    GestureDetector(
                      onTap: () {
                        homeScreenProvider.updateCurrentPage(1);
                      },
                      child: Container(
                        height: 50.h,
                        width: ScreenConfig.width *0.4,
                        padding: EdgeInsets.all(8.0.sp),
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(4),
                            color: const Color(0xff6A24FF)),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            SvgPicture.asset(
                              AppImages.calendarEvent,
                              color: Colors.white,
                              height: 34.h,
                              width: 34.w,
                            ),
                            Text(
                              "Upcoming",
                              style: w500_14Poppins(color: Colors.white),
                            )
                          ],
                        ),
                      ),
                    ),
                    10.w.width,
                    GestureDetector(
                      onTap: () {
                        customShowDialog(
                          context,
                          joinNowBottomSheet(context),
                        );
                      },
                      child: Container(
                        width: ScreenConfig.width *0.4,
                        height: 50.h,
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(4),
                            color: const Color(0xff03AF8B)),
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              SvgPicture.asset(
                                AppImages.cam_icon,
                                color: Colors.white,
                                height: 34.h,
                                width: 34.w,
                              ),
                              4.w.width,
                              Text(
                                "Join Now",
                                style: w500_14Poppins(color: Colors.white),
                              )
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                );
              }),

              SizedBox(
                height: 225.h,
                child: const RequestedMeetings(),
              ),
              InkWell(
                onTap: () async {
                  // print("Clear Cache in O-Connect application 1 ");
                  // var tempDir = await getTemporaryDirectory();
                  //
                  // if (tempDir.existsSync()) {
                  //   tempDir.deleteSync(recursive: true);
                  // }
                  print("Clear Cache in O-Connect application 2");
                  await DefaultCacheManager().emptyCache();
                },
                child: Container(
                  height: 100.h,
                  width: MediaQuery.of(context).size.width * 1,
                  decoration: BoxDecoration(
                    image: const DecorationImage(
                        image: AssetImage(
                          AppImages.dashboardCard,
                        ),
                        fit: BoxFit.fill),
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
              ),

              const WebinarStatistics(),

              // Visibility(
              //   visible: Provider.of<LibraryProvider>(context, listen: false).finalUpdatedMeetingHistoryList.isNotEmpty ? true : false,
              //   child: MeetingsHistory(
              //     controller: meetingHistoryController,
              //   ),
              // ),
            ],
          ),
        ),
      );
    });
  }

  TextEditingController eventIdController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  joinNowBottomSheet(BuildContext context) {
    return Consumer<HomeScreenProvider>(builder: (context, provider, child) {
      return Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Align(
              alignment: Alignment.center,
              child: Container(
                height: 5.h,
                width: 100.w,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20.r),
                    color: const Color(0xff202223)),
              ),
            ),
            25.h.height,
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "Join Webinar",
                  style: w500_14Poppins(color: Colors.white),
                ),
                GestureDetector(
                  onTap: () {
                    Navigator.pop(context);
                  },
                  child: Container(
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: Theme.of(context).primaryColorLight,
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(4.0),
                      child: Icon(
                        Icons.close,
                        size: 14,
                        color: Theme.of(context).scaffoldBackgroundColor,
                      ),
                    ),
                  ),
                ),
              ],
            ),
            const Divider(),
            Text(
              "Event ID",
              style: w400_12Poppins(color: Theme.of(context).primaryColorLight),
            ),
            5.h.height,
            CommonTextFormField(
              controller: eventIdController,
              fillColor: Colors.transparent,
              borderColor: Theme.of(context).primaryColorDark,
              hintText: "Enter Event Id",
            ),
            10.h.height,
            Row(
              children: [
                CustomButton(
                  width: 170.w,
                  height: 40.h,
                  buttonText: "Close",
                  buttonColor: const Color(0xff1C2632),
                  onTap: () {
                    Navigator.pop(context);
                  },
                ),
                10.w.width,
                CustomButton(
                  width: 170.w,
                  height: 40.h,
                  buttonText: "Join",
                  onTap: () {
                    provider.joinMeetingById(eventIdController.text,context);

                    Navigator.pop(context);
                  },
                )
              ],
            )
          ],
        ),
      );
    });
  }

  Widget webinarsRowItem(
      {required String value,
      required String textTile,
      required String iconName,
      required Color backgroundColor,
      required Color titleTxtColor}) {
    return Container(
      width: 150.w,
      height: 120.h,
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(8.r),
      ),
      child: Padding(
        padding: EdgeInsets.symmetric(vertical: 10.h, horizontal: 10.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SvgPicture.asset(
              iconName,
            ),
            Padding(
              padding: EdgeInsets.symmetric(vertical: 8.h),
              child: Text(
                value,
                style: w600_18Poppins(color: Colors.white),
              ),
            ),
            Text(
              textTile,
              style: w400_12Poppins(color: titleTxtColor),
              textAlign: TextAlign.center,
            )
          ],
        ),
      ),
    );
  }

  Widget hexagonbutton(
      {required String titleTxt,
      required IconData icon,
      required Color backgroundColor,
      required Color iconBackgroundColor}) {
    return Container(
      width: MediaQuery.of(context).size.width / 2 - 20,
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Padding(
            padding: EdgeInsets.only(right: 8.w),
            child: CustomPaint(
              painter: HexagonPainter(iconBackgroundColor),
              child: Padding(
                padding: EdgeInsets.all(15.0.sp),
                child: Icon(
                  icon,
                  size: 20.sp,
                ),
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.symmetric(vertical: 8.0.h),
            child: Text(
              titleTxt,
              style: w400_14Poppins(color: Colors.white),
              textAlign: TextAlign.center,
            ),
          ),
        ],
      ),
    );
  }
}

class HexagonPainter extends CustomPainter {
  final Color? iconBackgroundColor;

  HexagonPainter(this.iconBackgroundColor);

  @override
  void paint(Canvas canvas, Size size) {
    Paint paint = Paint()
      ..color = iconBackgroundColor!
      ..style = PaintingStyle.fill;

    double centerX = size.width / 2;
    double centerY = size.height / 2;
    double radius = size.width / 2;

    Path hexagonPath = Path();

    for (int i = 0; i < 6; i++) {
      double angle = (pi / 3) * i;
      double x = centerX + radius * cos(angle);
      double y = centerY + radius * sin(angle);

      if (i == 0) {
        hexagonPath.moveTo(x, y);
      } else {
        hexagonPath.lineTo(x, y);
      }
    }

    hexagonPath.close();

    canvas.drawPath(hexagonPath, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return false;
  }
}
