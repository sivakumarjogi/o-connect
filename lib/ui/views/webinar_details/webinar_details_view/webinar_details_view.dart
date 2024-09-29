import 'package:buttons_tabbar/buttons_tabbar.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:lottie/lottie.dart';
import 'package:o_connect/ui/utils/buttons_helper/custom_botton.dart';
import 'package:o_connect/ui/utils/colors/colors.dart';
import 'package:o_connect/ui/utils/custom_show_dialog_helper/custom_show_dialog.dart';
import 'package:o_connect/ui/utils/images/images.dart';
import 'package:o_connect/ui/views/drawer/webinar_drawer/widgets/webinar_search_widget.dart';
import 'package:o_connect/ui/views/webinar_details/webinar_details_provider/webinar_details_provider.dart';
import 'package:o_connect/ui/views/webinar_details/webinar_details_view/all_webinar_widget.dart';
import 'package:o_connect/ui/views/webinar_details/webinar_details_view/cancel_webinar.dart';
import 'package:o_connect/ui/views/webinar_details/webinar_details_view/declined_webinar_widget.dart';
import 'package:o_connect/ui/views/webinar_details/webinar_details_view/invited_webinar_widget.dart';
import 'package:o_connect/ui/views/webinar_details/webinar_details_view/ongoing_webinar_widget.dart';
import 'package:o_connect/ui/views/webinar_details/webinar_details_view/recurrind_widget.dart';
import 'package:o_connect/ui/views/webinar_details/webinar_details_view/saved_widget.dart';
import 'package:o_connect/ui/views/webinar_details/webinar_details_view/scheduled_widget.dart';
import 'package:oes_chatbot/utils/date_picker/date_picker.dart';
import 'package:oes_chatbot/utils/date_picker/date_picker_manager.dart';
import 'package:oes_chatbot/utils/extensions/sizedbox_extension.dart';
import 'package:o_connect/ui/views/webinar_details/webinar_details_view/past_webinars.dart';
import 'package:o_connect/ui/views/webinar_details/webinar_details_view/transfer_webinar_widget.dart';
import 'package:o_connect/ui/views/webinar_details/webinar_details_view/upcoming_webinars.dart';
import 'package:provider/provider.dart';
import '../../../utils/constant_strings.dart';
import '../../../utils/textfield_helper/app_fonts.dart';
import '../../home_screen/home_screen_provider/home_screen_provider.dart';
import '../webinar_details_model/meeting_details_model.dart';

class WebinarDetails extends StatefulWidget {
  const WebinarDetails({super.key, this.initialIndex});

  final int? initialIndex;

  @override
  State<WebinarDetails> createState() => _WebinarDetailsState();
}

class _WebinarDetailsState extends State<WebinarDetails> {
  final TextEditingController dateTimeController = TextEditingController();

  WebinarDetailsProvider? webinarProvider;
  String screenName = '';
  int initialIndex = 0;

  

  HomeScreenProvider? homeScreenProvider;

  @override
  void initState() {
    webinarProvider = Provider.of<WebinarDetailsProvider>(context, listen: false);
    homeScreenProvider = Provider.of<HomeScreenProvider>(context, listen: false);
    SchedulerBinding.instance.addPostFrameCallback((_) {
      homeScreenProvider?.searchController.clear();
    });

    // homeScreenProvider?.getMeetings(context, searchHistory: "", selectedValue: "upcoming");
    super.initState();
  }

  @override
  void dispose() {
    homeScreenProvider?.searchController.clear();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer2<WebinarDetailsProvider, HomeScreenProvider>(builder: (context, provider, homeScreenProvider, child) {
      return Scaffold(
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        resizeToAvoidBottomInset: false,
        body: DefaultTabController(
          initialIndex: provider.isCreated == true ? provider.initialIndex : 0,
          length: provider.isCreated == true ? 5 : 1,
          child: SingleChildScrollView(
            child: Padding(
              padding: EdgeInsets.only(right: 8.w, left: 8.w),
              child: Padding(
                padding: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
                child: Column(
                  children: [
                    height5,
                    provider.searchField
                        ? SizedBox(height: 45.h, child: SearchWidget(controller: homeScreenProvider.searchController))
                        : Row(
                            children: [
                              Radio(
                                  value: 1,
                                  activeColor: Colors.blue,
                                  groupValue: provider.selectedRadioValue,
                                  onChanged: (value) {
                                    setState(() {
                                      provider.selectedRadioValue = value!;
                                      provider.isCreated = true;
                                    });
                                  }),
                              Text(
                                "Created",
                                style: w400_14Poppins(color: Theme.of(context).primaryColorLight),
                              ),
                              5.w.width,
                              Radio(
                                  value: 2,
                                  activeColor: Colors.blue,
                                  groupValue: provider.selectedRadioValue,
                                  onChanged: (value) {
                                    setState(() {
                                      provider.selectedRadioValue = value!;
                                      provider.isCreated = false;
                                    });
                                  }),
                              Text(
                                "Received",
                                style: w400_14Poppins(color: Theme.of(context).primaryColorLight),
                              ),
                              90.w.width,
                              InkWell(
                                onTap: () {
                                  provider.searchBoxEnableDisable();
                                },
                                child: Icon(
                                  Icons.search,
                                  color: Theme.of(context).primaryColorLight,
                                ),
                              ),
                            ],
                          ),
                    Column(
                      children: [
                        // 10.h.height,
                        if (provider.isCreated == true)
                          ButtonsTabBar(
                            contentPadding: const EdgeInsets.all(7),
                            buttonMargin: const EdgeInsets.all(6),
                            borderWidth: 1,
                            unselectedBorderColor: Theme.of(context).primaryColorDark,
                            borderColor: Colors.transparent,
                            decoration: BoxDecoration(borderRadius: BorderRadius.circular(4), color: Colors.blue, border: Border.all()),
                            unselectedDecoration: BoxDecoration(borderRadius: BorderRadius.circular(4), border: Border.all(color: Colors.red), color: Colors.transparent),
                            unselectedLabelStyle: w400_14Poppins(color: Theme.of(context).primaryColorLight),
                            labelStyle: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                            onTap: (index) {
                              context.read<HomeScreenProvider>().getMeetingList.remove(MeetingDetailsModel());
                              print("tab index ${index}");
                            },
                            tabs: const [
                              Tab(text: "Scheduled"),
                              Tab(text: "Completed"),
                              Tab(text: "Transferred"),
                              Tab(text: "Cancelled"),
                              Tab(text: "Saved"),
                            ],
                          ),
                        10.h.height,
                        provider.isCreated == true
                            ? SizedBox(
                                height: 550.h,
                                child: TabBarView(
                                  physics: const NeverScrollableScrollPhysics(),
                                  children: [const ScheduledWebinarWidget(), PastWebinarsWidget(), TransferWebinarWidget(), CancelWebinarWidget(), SavedWebinarWidget()],
                                ),
                              )
                            : const InvitedWebinarWidget()
                      ],
                    )
                  ],
                ),
              ),
            ),
          ),
        ),
      );
    });
  }
}

//  SizedBox(
//                 width: ScreenConfig.width,
//                 child: CustomButton(
//                   height: 45.h,
//                   buttonText: ConstantsStrings.createWebinar,
//                   onTap: () async {
//                     // tryJoinMeeting(context);
//                     if (kDebugMode) {
//                       tryJoinMeeting(context);
//                     } else {
//                       bool canCreate = await checkUserSubScription();
//                       if (canCreate) {
//                         Navigator.pushNamed(context, RoutesManager.createWebinarScreen);
//                       }
//                     }
//                   },
//                 )),
//             height5,
//             height10,
//             Visibility(
//               visible: provider.isShowDateRangePicker ? false : true,
//               child: SizedBox(
//                 height: 45.h,
//                 child: DropdownButtonHideUnderline(
//                   child: DropdownButton2(
//                     style: w400_14Poppins(color: Colors.red),
//                     buttonStyleData: ButtonStyleData(decoration: BoxDecoration(borderRadius: BorderRadius.all(Radius.circular(5.r)), color: Theme.of(context).primaryColor)),
//                     dropdownStyleData: DropdownStyleData(
//                       decoration: BoxDecoration(
//                         borderRadius: BorderRadius.all(Radius.circular(5.r)),
//                         color: Theme.of(context).highlightColor,
//                       ),
//                     ),
//                     isExpanded: true,
//                     iconStyleData: IconStyleData(
//                         icon: Padding(
//                           padding: EdgeInsets.symmetric(horizontal: 8.0.w),
//                           child: SvgPicture.asset(
//                             AppImages.webinarDropdown,
//                           ),
//                         ),
//                         iconSize: 24.sp),
//                     underline: const SizedBox.shrink(),
//                     disabledHint: Padding(
//                       padding: EdgeInsets.all(8.0.sp),
//                       child: const Text(
//                         ConstantsStrings.upcomingWebinars,
//                         style: TextStyle(color: Colors.red),
//                       ),
//                     ),
//                     value: provider.selectedValue,
//                     items: dropdownItems,
//                     onChanged: (String? newValue) {
//                       homeScreenProvider.searchController.text = "";
//                       provider.updateWebinars(newValue!);
// homeScreenProvider.updateWebinars(newValue, context);
//                     },
//                   ),
//                 ),
//               ),
//             ),
//             height10,
//             Expanded(
//               child: Column(
//                 children: [
//                   Expanded(
//                     child: homeScreenProvider.getAllMeetingLoading
//                         ? Center(
//                             child: Lottie.asset(AppImages.loadingJson, height: 50.w, width: 50.w),
//                           )
//                         : homeScreenProvider.getMeetingList.isEmpty
//                             ? Center(
//                                 child: Text(
//                                   "No Records Found",
//                                   style: w500_18Poppins(color: Theme.of(context).primaryColorLight),
//                                 ),
//                               )
//                             : ListView.separated(
//                                 shrinkWrap: true,
//                                 itemCount: homeScreenProvider.getMeetingList.length,
//                                 itemBuilder: (context, index) {
//                                   var cDate = DateTime.parse(homeScreenProvider.getMeetingList[index].meetingDate.toString());
//                                   var fDate = DateFormat("MMM dd, yyyy HH:mm").format(cDate.toLocal());
//                                   return provider.selectedValue == ConstantsStrings.upcomingWebinars
//                                       ? UpcomingWebinarsWidget(
//                                           /* dataList: homeScreenProvider.getMeetingList[index], finalDate: fDate.toString() */ index: index,
//                                         )
//                                       : provider.selectedValue == ConstantsStrings.pastWebinars
// ? PastWebinarsWidget(dataList: homeScreenProvider.getMeetingList[index], finalDate: fDate.toString())
//                                           : provider.selectedValue == ConstantsStrings.transferWebinars
//                                               ? TransferWebinarWidget(dataList: homeScreenProvider.getMeetingList[index], finalDate: fDate.toString())
//                                               : CancelWebinarWidget(dataList: homeScreenProvider.getMeetingList[index], finalDate: fDate.toString());
//                                 },
//                                 separatorBuilder: (BuildContext context, int index) => height15,
//                               ),
//                   ),
//                   // when the loadMore function is running
//                   if (provider.isLoadMoreRunning == true)
//                     Padding(
//                       padding: const EdgeInsets.only(top: 10, bottom: 40),
//                       child: Center(child: Lottie.asset(AppImages.loadingJson, height: 40.w, width: 40.w)),
//                     ),
//                   height15
//                   // When nothing else to load
//                   /*  if (widget.provider.hasNextPage == false)
//                       Container(
//                         padding: const EdgeInsets.only(top: 10, bottom: 10),
//                         color: Colors.amber,
//                         child: const Center(
//                           child: Text('You have fetched all of the content'),
//                         ),
//                       ),*/
//                 ],
//               ),
//             ),
