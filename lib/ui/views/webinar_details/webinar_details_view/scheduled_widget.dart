import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:lottie/lottie.dart';
import 'package:o_connect/core/common_functions.dart';
import 'package:o_connect/core/models/response_models/profile_response_model.dart/profile_response_model.dart';
import 'package:o_connect/core/providers/app_global_state_provider.dart';
import 'package:o_connect/ui/utils/base_urls.dart';
import 'package:o_connect/ui/utils/buttons_helper/custom_botton.dart';
import 'package:o_connect/ui/utils/buttons_helper/custom_outline_button.dart';
import 'package:o_connect/ui/utils/colors/colors.dart';
import 'package:o_connect/ui/utils/constant_strings.dart';
import 'package:o_connect/ui/utils/custom_dotted_divider.dart';
import 'package:o_connect/ui/utils/custom_show_dialog_helper/custom_show_dialog.dart';
import 'package:o_connect/ui/utils/custom_toast_helper/custom_toast.dart';
import 'package:o_connect/ui/utils/images/images.dart';
import 'package:o_connect/ui/utils/loading_helper/loading_indicator.dart';
import 'package:o_connect/ui/views/home_screen/home_screen_provider/home_screen_provider.dart';
import 'package:o_connect/ui/views/meeting_entry_point.dart';
import 'package:o_connect/ui/views/webinar_details/webinar_details_model/meeting_details_model.dart';
import 'package:o_connect/ui/views/webinar_details/webinar_details_provider/webinar_details_provider.dart';
import 'package:o_connect/ui/views/webinar_details/webinar_details_view/save_as_template.dart';
import 'package:o_connect/ui/views/webinar_details/webinar_details_view/saved_widget.dart';
import 'package:o_connect/ui/views/webinar_details/webinar_details_view/transfer_meeting.dart';
import 'package:o_connect/ui/views/webninar_dashboard/presentation/create_webinar/provider/create_webinar_provider.dart';
import 'package:oes_chatbot/utils/extensions/sizedbox_extension.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../../core/models/auth_models/generate_token_o_connect_model.dart';
import '../../../../core/service_locator.dart';
import '../../../../core/user_cache_service.dart';
import '../../../utils/textfield_helper/app_fonts.dart';
import '../../pip_views/pip_global_navigation.dart';
import '../../webninar_dashboard/presentation/create_webinar/create_webinar_screen.dart';
import 'cancel_meeting.dart';

class ScheduledWebinarWidget extends StatefulWidget {
  const ScheduledWebinarWidget({super.key});

  @override
  State<ScheduledWebinarWidget> createState() => _ScheduledWebinarWidgetState();
}

class _ScheduledWebinarWidgetState extends State<ScheduledWebinarWidget> {
  HomeScreenProvider? homeScreenProvider;
  WebinarDetailsProvider? webinarProvider;
  GetProfileResponsData? userData;

  @override
  void initState() {
    webinarProvider = Provider.of<WebinarDetailsProvider>(context, listen: false);
    homeScreenProvider = Provider.of<HomeScreenProvider>(context, listen: false);

    SchedulerBinding.instance.addPostFrameCallback((_) async {
      homeScreenProvider?.reSetData(context, "upcoming");
      userData = await webinarProvider!.getHeaderInfoDetails();
    });

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer3<WebinarDetailsProvider, HomeScreenProvider, AppGlobalStateProvider>(builder: (context, provider, homeScreenProvider, appGlobalStateProvider, child) {
      return SizedBox(
        height: MediaQuery.of(context).size.height - 100.sp,
        child: homeScreenProvider.getAllMeetingLoading
            ? Center(
                child: Lottie.asset(AppImages.loadingJson, height: 50.w, width: 50.w),
              )
            : homeScreenProvider.getMeetingList.isEmpty
                ? Center(
                    child: Text(
                    "No records found",
                    style: w400_14Poppins(color: Colors.white),
                  ))
                : ListView.builder(
                    shrinkWrap: true,
                    itemCount: homeScreenProvider.getMeetingList.length,
                    physics: const BouncingScrollPhysics(),
                    itemBuilder: (context, i) {
                      return Padding(
                        padding: EdgeInsets.all(8.0.sp),
                        child: Container(
                          padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 10.h),
                          decoration: BoxDecoration(borderRadius: BorderRadius.circular(6), color: Theme.of(context).cardColor),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              10.h.height,
                              Container(
                                decoration: BoxDecoration(borderRadius: BorderRadius.circular(6.r), color: const Color(0xff06C270).withOpacity(0.2)),
                                child: Padding(
                                  padding: EdgeInsets.all(6.0.sp),
                                  child: Text(
                                    homeScreenProvider.getMeetingList[i].isStarted == 1 ? "In progress" : "Scheduled",
                                    style: w500_10Poppins(color: const Color(0xff06C270)),
                                  ),
                                ),
                              ),
                              5.h.height,
                              Text(
                                homeScreenProvider.getMeetingList[i].meetingName!,
                                style: w500_14Poppins(color: Theme.of(context).hintColor),
                              ),
                              5.h.height,
                              Text(
                                homeScreenProvider.getMeetingList[i].autoGeneratedId.toString(),
                                style: w400_13Poppins(color: Theme.of(context).primaryColorLight),
                              ),
                              5.h.height,
                              Row(
                                children: [
                                  SvgPicture.asset(AppImages.profileIcon),
                                  10.w.width,
                                  Text(
                                    homeScreenProvider.getMeetingList[i].username!.split("@").first,
                                    style: w400_13Poppins(color: Theme.of(context).primaryColorLight),
                                  )
                                ],
                              ),
                              10.h.height,
                              Row(
                                children: [
                                  SvgPicture.asset(AppImages.calendarEvent),
                                  10.w.width,
                                  Text(
                                    "${homeScreenProvider.getMeetingList[i].meetingDate.toString().toCustomDateFormat("MMM dd, yyyy HH:mm").toString()} - ${homeScreenProvider.getMeetingList[i].endDate.toString().toCustomDateFormat("MMM dd yyyy,HH:mm").split(",").last.toString()}",
                                    style: w400_13Poppins(color: Theme.of(context).primaryColorLight),
                                  )
                                ],
                              ),
                              10.h.height,
                              GestureDetector(
                                onTap: () => showMeetingUrls(context, homeScreenProvider.getMeetingList[i]),
                                child: Row(
                                  children: [
                                    SvgPicture.asset(AppImages.linkIconEvent),
                                    10.w.width,
                                    Text(
                                      "Invite Link",
                                      style: w400_13Poppins(color: Colors.blue),
                                    )
                                  ],
                                ),
                              ),
                              5.h.height,
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Flexible(
                                    flex: 1,
                                    child: InkWell(
                                      onTap: () => detailsView(context, homeScreenProvider.getMeetingList[i]),
                                      child: Container(
                                        // width: 80.w,
                                        height: 40.h,
                                        decoration: BoxDecoration(borderRadius: BorderRadius.circular(8), color: const Color(0xff1B2632)),
                                        child: Center(
                                          child: Text(
                                            "Details",
                                            style: w400_14Poppins(color: Colors.white),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                  width10,
                                  Flexible(
                                    flex: 1,
                                    child: CustomButton(
                                      height: 40.h,
                                      buttonColor: const Color(0xff0E78F9),
                                      buttonText: homeScreenProvider.getMeetingList[i].isStarted == 1 ? "In progress" : "Start",
                                      onTap: () {
                                        if (homeScreenProvider.getMeetingList[i].isStarted == 1 && context.read<AppGlobalStateProvider>().meetingId == homeScreenProvider.getMeetingList[i].id) {
                                          CustomToast.showErrorToast(msg: "You are already in an another meeting.");
                                        } else {
                                          tryJoinMeeting(context, isHostJoing: true, meetingId: homeScreenProvider.getMeetingList[i].id, fromUrl: false);
                                        }
                                      },
                                    ),
                                  )
                                ],
                              ),
                            ],
                          ),
                        ),
                      );
                    }),
      );
    });
  }

  Future showMeetingUrls(BuildContext context, MeetingDetailsModel meetingList) {
    return showModalBottomSheet(
        isScrollControlled: true,
        isDismissible: false,
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.only(topRight: Radius.circular(24.r), topLeft: Radius.circular(24.r))),
        context: context,
        builder: (context) {
          return Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.only(topRight: Radius.circular(24.r), topLeft: Radius.circular(24.r)),
              color: Theme.of(context).cardColor,
            ),
            child: Padding(
                padding: EdgeInsets.all(10.0.sp),
                child: Column(mainAxisSize: MainAxisSize.min, crossAxisAlignment: CrossAxisAlignment.start, children: [
                  Align(
                    alignment: Alignment.center,
                    child: Container(
                      height: 5.h,
                      width: 100.w,
                      decoration: BoxDecoration(borderRadius: BorderRadius.circular(20.r), color: const Color(0xff202223)),
                    ),
                  ),
                  25.h.height,
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "Select Link",
                        style: w500_14Poppins(color: Colors.white),
                      ),
                      GestureDetector(
                        onTap: () {
                          Navigator.pop(context);
                        },
                        child: Padding(
                          padding: EdgeInsets.all(4.0.sp),
                          child: Icon(
                            Icons.cancel,
                            size: 24.sp,
                            color: const Color(0xff5E6272),
                          ),
                        ),
                      ),
                    ],
                  ),
                  const Divider(),
                  if (meetingList.meetingType != "conference") 10.h.height,
                  if (meetingList.meetingType != "conference")
                    Text(
                      "Attendee URL",
                      style: w400_13Poppins(color: Theme.of(context).primaryColorLight),
                    ),
                  if (meetingList.meetingType != "conference") 5.h.height,
                  if (meetingList.meetingType != "conference")
                    Container(
                      decoration: BoxDecoration(color: Theme.of(context).primaryColor, borderRadius: BorderRadius.circular(4.r)),
                      child: Padding(
                        padding: EdgeInsets.all(8.0.sp),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            SizedBox(
                                width: 280.w,
                                height: 20.h,
                                child: Text(
                                  "${BaseUrls.webinarCopyLinkBaseUrl}/o-connect/webinar/meeting/${meetingList.id}/${meetingList.autoGeneratedId}/${meetingList.guestKey.toString()}/${userData?.customerId}/${userData?.customerAccounts?.first.custAffId}" ??
                                      "",
                                  style: w400_13Poppins(color: Colors.white),
                                  overflow: TextOverflow.ellipsis,
                                  maxLines: 1,
                                )),
                            UrlWithCopyButton(
                                url:
                                    "${BaseUrls.webinarCopyLinkBaseUrl}/o-connect/webinar/meeting/${meetingList.id}/${meetingList.autoGeneratedId}/${meetingList.guestKey.toString()}/${userData?.customerId}/${userData?.customerAccounts?.first.custAffId}" ??
                                        "")
                          ],
                        ),
                      ),
                    ),
                  if (meetingList.meetingType != "conference") 10.h.height,
                  if (meetingList.meetingType != "conference")
                    Text(
                      "Attendee Trimmed URL",
                      style: w400_13Poppins(color: Theme.of(context).primaryColorLight),
                    ),
                  if (meetingList.meetingType != "conference") 5.h.height,
                  if (meetingList.meetingType != "conference")
                    Container(
                      decoration: BoxDecoration(color: Theme.of(context).primaryColor, borderRadius: BorderRadius.circular(4)),
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            SizedBox(
                                width: 280.w,
                                height: 20.h,
                                child: Text(
                                  meetingList.guestUrl ?? "N/A",
                                  style: w400_13Poppins(color: Colors.white),
                                  overflow: TextOverflow.ellipsis,
                                  maxLines: 1,
                                )),
                            if (meetingList.guestUrl != null) UrlWithCopyButton(url: meetingList.guestUrl.toString())
                          ],
                        ),
                      ),
                    ),
                  10.h.height,
                  Text(
                    "Speaker URL",
                    style: w400_13Poppins(color: Theme.of(context).primaryColorLight),
                  ),
                  5.h.height,
                  Container(
                    decoration: BoxDecoration(color: Theme.of(context).primaryColor, borderRadius: BorderRadius.circular(4)),
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          SizedBox(
                              width: 280.w,
                              height: 20.h,
                              child: Text(
                                // "${BaseUrls.webinarCopyLinkBaseUrl}/o-connect/webinar/meeting/${meetingList.id}/${meetingList.autoGeneratedId}/${meetingList.participantKey.toString()}/${userData?.data?.customerId}/${userData?.data?.customerAccounts?.first.custAffId}" ??
                                "${BaseUrls.webinarCopyLinkBaseUrl}/o-connect/webinar/meeting/${meetingList.id}/${meetingList.autoGeneratedId}/${meetingList.participantKey.toString()}/${userData?.customerId}/${userData?.customerAccounts?.first.custAffId}" ??
                                    "",
                                style: w400_13Poppins(color: Colors.white),
                                overflow: TextOverflow.ellipsis,
                                maxLines: 1,
                              )),
                          UrlWithCopyButton(
                              url:
                                  // "${BaseUrls.webinarCopyLinkBaseUrl}/o-connect/webinar/meeting/${meetingList.id}/${meetingList.autoGeneratedId}/${meetingList.participantKey.toString()}/${userData?.data?.customerId}/${userData?.data?.customerAccounts?.first.custAffId}" ??
                                  "${BaseUrls.webinarCopyLinkBaseUrl}/o-connect/webinar/meeting/${meetingList.id}/${meetingList.autoGeneratedId}/${meetingList.participantKey.toString()}/${userData?.customerId}/${userData?.customerAccounts?.first.custAffId}" ??
                                      "")
                        ],
                      ),
                    ),
                  ),
                  10.h.height,
                  Text(
                    "Speaker Trimmed URL",
                    style: w400_13Poppins(color: Theme.of(context).primaryColorLight),
                  ),
                  5.h.height,
                  Container(
                    decoration: BoxDecoration(color: Theme.of(context).primaryColor, borderRadius: BorderRadius.circular(4)),
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          SizedBox(
                              width: 280.w,
                              height: 20.h,
                              child: Text(
                                meetingList.participantUrl ?? "N/A",
                                style: w400_13Poppins(color: Colors.white),
                                overflow: TextOverflow.ellipsis,
                                maxLines: 1,
                              )),
                          if (meetingList.participantKey != null) UrlWithCopyButton(url: meetingList.participantUrl.toString())
                        ],
                      ),
                    ),
                  ),
                  10.h.height,
                  if (meetingList.participantUrl == null)
                    CustomOutlinedButton(
                      outLineBorderColor: Colors.transparent,
                      color: const Color(0xff1B2632),
                      height: 35.h,
                      width: MediaQuery.of(context).size.width,
                      buttonTextStyle: w400_13Poppins(color: Colors.white),
                      buttonText: ConstantsStrings.generatedTrimUrl,
                      onTap: () async {
                        Loading.indicator(context);
                        SharedPreferences preferences = await SharedPreferences.getInstance();
                        final String? userDataString = await serviceLocator<UserCacheService>().getUserData("userData");
                        GenerateTokenUser userData = GenerateTokenUser.fromJson(jsonDecode(userDataString!));
                        final String? userDataStrings = preferences.getString("saveProfileData");
                        GetProfileResponsData? userDatas = GetProfileResponsData.fromJson(jsonDecode(userDataStrings!));
                        if (context.mounted) {
                          context
                              .read<CreateWebinarProvider>()
                              .generateTrimUrls(
                                  context,
                                  {
                                    "inpurlList": [
                                      "${BaseUrls.webinarCopyLinkBaseUrl}/o-connect/webinar/meeting/${meetingList.id}/${meetingList.autoGeneratedId}/${meetingList.hostKey.toString()}/${userDatas.customerId}/${userDatas.customerAccounts!.first.custAffId}",
                                      "${BaseUrls.webinarCopyLinkBaseUrl}/o-connect/webinar/meeting/${meetingList.id}/${meetingList.autoGeneratedId}/${meetingList.participantKey.toString()}/${userDatas.customerId}/${userDatas.customerAccounts!.first.custAffId}",
                                      if (meetingList.meetingType == "webinar")
                                        "${BaseUrls.webinarCopyLinkBaseUrl}/o-connect/webinar/meeting/${meetingList.id}/${meetingList.autoGeneratedId}/${meetingList.guestKey.toString()}/${userDatas.customerId}/${userDatas.customerAccounts!.first.custAffId}"
                                    ]
                                  },
                                  userData,
                                  meetingList.meetingType,
                                  meetingList,
                                  {})
                              .then((value) async {
                            Navigator.pop(context);
                            Navigator.pop(context);
                            await context.read<HomeScreenProvider>().getMeetings(context, selectedValue: "upcoming", searchHistory: "");
                            CustomToast.showSuccessToast(msg: "Successfully trim url is generated");
                          });
                        }
                      },
                    ),
                  5.h.height,
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      CustomOutlinedButton(
                        outLineBorderColor: Colors.transparent,
                        color: const Color(0xff1B2632),
                        height: 35.h,
                        width: MediaQuery.of(context).size.width / 2 - 25.sp,
                        buttonTextStyle: w400_13Poppins(color: Colors.white),
                        buttonText: ConstantsStrings.cancel,
                        onTap: () {
                          Navigator.pop(context);
                        },
                      ),
                      width10,
                      CustomButton(
                        height: 35.h,
                        width: MediaQuery.of(context).size.width / 2 - 25.sp,
                        buttonText: "Copy Event Invitation",
                        buttonTextStyle: w500_13Poppins(color: AppColors.whiteColor),
                        onTap: () {
                          String copiedText = """
                          Start OCONNECT Event
                          Event Name: ${meetingList.meetingName.toString()}
                          Date & Time: ${meetingList.meetingDate.toString().toCustomDateFormat("MMM dd yyyy HH:mm a")} ${meetingList.timezone.toString()} 
                          Host: ${meetingList.username.toString()}
                          Attendee: ${meetingList.guestUrl ?? ""}
                          Speaker: ${meetingList.participantUrl ?? ""}
                          Event ID: ${meetingList.autoGeneratedId.toString()}
                          """;
                          Clipboard.setData(ClipboardData(text: copiedText));
                          CustomToast.showSuccessToast(msg: "Link Copied");
                        },
                      )
                    ],
                  ),
                ])),
          );
        });
  }

  Future detailsView(BuildContext context, MeetingDetailsModel meetingList) {
    return showModalBottomSheet(
        isScrollControlled: true,
        isDismissible: false,
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.only(topRight: Radius.circular(24.r), topLeft: Radius.circular(24.r))),
        context: context,
        builder: (context) {
          return Padding(
            padding: EdgeInsets.symmetric(horizontal: 15.0.w, vertical: 10.h),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Align(
                  alignment: Alignment.center,
                  child: Container(
                    height: 5.h,
                    width: 100.w,
                    decoration: BoxDecoration(borderRadius: BorderRadius.circular(20.r), color: const Color(0xff202223)),
                  ),
                ),
                25.h.height,
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    TextDarkField(
                      name: "Details",
                    ),
                    Row(
                      children: [
                        InkWell(
                          onTap: () {
                            customShowDialog(
                                context,
                                SaveAsTemplate(
                                  dataList: meetingList,
                                ));
                          },
                          child: SvgPicture.asset(
                            AppImages.saveTemplate,
                          ),
                        ),
                        10.w.width,
                        InkWell(
                            onTap: () async {
                              bool canEdit = await checkUserSubScription();
                              if (context.mounted) {
                                Navigator.pop(context);
                                if (canEdit) {
                                  if (meetingList.meetingType == "conference") {
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) => PIPGlobalNavigation(
                                                    childWidget: CreateWebinarScreen(
                                                  meetingDetailsModel: meetingList,
                                                  isEdit: true,
                                                  eventId: meetingList.id ?? "",
                                                ))));

                                    Provider.of<CreateWebinarProvider>(context, listen: false).isSelectedWebinarMethod(0);
                                  } else {
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) => PIPGlobalNavigation(
                                                    childWidget: CreateWebinarScreen(
                                                  meetingDetailsModel: meetingList,
                                                  isEdit: true,
                                                  eventId: meetingList.id ?? "",
                                                ))));

                                    Provider.of<CreateWebinarProvider>(context, listen: false).isSelectedWebinarMethod(1);
                                  }
                                }
                              }
                            },
                            child: (meetingList.isStarted != null && meetingList.isStarted == 1)
                                ? const IgnorePointer()
                                : Icon(
                                    Icons.edit,
                                    color: Theme.of(context).primaryColorLight,
                                  )),
                        10.w.width,
                        GestureDetector(
                          onTap: () {
                            Navigator.pop(context);
                          },
                          child: Icon(
                            Icons.cancel,
                            size: 24.sp,
                            color: const Color(0xff5E6272),
                          ),
                        )
                      ],
                    ),
                  ],
                ),
                const Divider(),
                10.h.height,
                Consumer<AppGlobalStateProvider>(builder: (_, appGlobalStateProvider, __) {
                  return Container(
                    decoration: BoxDecoration(borderRadius: BorderRadius.circular(6), color: const Color(0xff152E3C)),
                    child: Padding(
                      padding: const EdgeInsets.all(6.0),
                      child: Text(
                        appGlobalStateProvider.isMeetingInProgress ? "In progress" : "SCHEDULED",
                        style: w500_10Poppins(color: Colors.blue),
                      ),
                    ),
                  );
                }),
                5.h.height,
                TextDarkField(
                  name: meetingList.meetingName!,
                ),
                5.h.height,
                TextLightField(
                  name: meetingList.autoGeneratedId.toString(),
                ),
                10.h.height,
                TextLightField(name: "Host"),
                5.h.height,
                TextDarkField(
                  name: meetingList.username!.split("@").first,
                ),
                10.h.height,
                TextLightField(
                  name: "Date & Time",
                ),
                5.h.height,
                TextDarkField(
                  name:
                      "${meetingList.meetingDate.toString().toCustomDateFormat("MMM dd, yyyy HH:mm").toString()} - ${meetingList.endDate.toString().toCustomDateFormat("MMM dd yyyy,HH:mm").split(",").last.toString()}",
                ),
                10.h.height,
                TextLightField(name: "Event Type"),
                5.h.height,
                TextDarkField(
                  name: meetingList.meetingType!,
                ),
                15.h.height,
                const CustomDottedDivider(),
                15.h.height,
                Text(
                  "Passcode",
                  style: w400_12Poppins(color: Theme.of(context).primaryColorLight),
                ),
                5.h.height,
                Container(
                  decoration: BoxDecoration(borderRadius: BorderRadius.circular(4), color: Theme.of(context).secondaryHeaderColor),
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          meetingList.meetingPassword == "" ? "--" : meetingList.meetingPassword.toString(),
                          style: w400_14Poppins(color: Colors.white),
                        ),
                        if (meetingList.meetingPassword != "") const Icon(Icons.link)
                      ],
                    ),
                  ),
                ),
                30.h.height,
                (meetingList.isStarted != null && meetingList.isStarted == 1)
                    ? const IgnorePointer()
                    : Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Flexible(
                            flex: 1,
                            child: InkWell(
                              onTap: () {
                                customShowDialog(
                                    context,
                                    CancelMeetingPopup(
                                      dataList: meetingList,
                                    ));
                              },
                              child: Container(
                                // width: 80.w,
                                height: 40.h,
                                decoration: BoxDecoration(borderRadius: BorderRadius.circular(3), color: const Color(0xff1B2632)),
                                child: Center(
                                  child: Text(
                                    "Cancel Meeting",
                                    style: w400_14Poppins(color: Colors.white),
                                  ),
                                ),
                              ),
                            ),
                          ),
                          width10,
                          Flexible(
                            flex: 1,
                            child: InkWell(
                              onTap: () {
                                customShowDialog(
                                    context,
                                    TransferPopup(
                                      dataList: meetingList,
                                    ));
                              },
                              child: Container(
                                  // width: 100.w,
                                  height: 40.h,
                                  decoration: BoxDecoration(borderRadius: BorderRadius.circular(3), color: Colors.blue),
                                  child: Center(
                                    child: Text(
                                      "Transfer",
                                      style: w400_14Poppins(color: Colors.white),
                                    ),
                                  )),
                            ),
                          )
                        ],
                      ),
              ],
            ),
          );
        });
  }
}

class UrlWithCopyButton extends StatelessWidget {
  const UrlWithCopyButton({super.key, required this.url});

  final String url;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        InkWell(
          onTap: () {
            print("the speaker url: $url");
            Clipboard.setData(ClipboardData(text: url));
            CustomToast.showSuccessToast(msg: "Link Copied");
          },
          child: Container(
            height: 32.w,
            width: 32.w,
            alignment: Alignment.center,
            child: const Icon(Icons.link),
          ),
        ),
      ],
    );
  }
}
