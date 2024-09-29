import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:intl/intl.dart';
import 'package:o_connect/core/models/default_user_data_model.dart';
import 'package:o_connect/core/providers/default_user_data_provider.dart';
import 'package:o_connect/core/screen_configs.dart';
import 'package:o_connect/ui/utils/colors/colors.dart';
import 'package:o_connect/ui/utils/constant_strings.dart';
import 'package:o_connect/ui/utils/custom_toast_helper/custom_toast.dart';
import 'package:o_connect/ui/utils/images/images.dart';
import 'package:o_connect/ui/utils/textfield_helper/app_fonts.dart';
import 'package:o_connect/ui/utils/textfield_helper/common_textfield.dart';
import 'package:o_connect/ui/views/authentication/form_validations.dart';
import 'package:o_connect/ui/views/home_screen/home_screen_provider/home_screen_provider.dart';
import 'package:o_connect/ui/views/webninar_dashboard/presentation/create_webinar/create_webinar_contacts_screen.dart';
import 'package:oes_chatbot/utils/extensions/sizedbox_extension.dart';
import 'package:provider/provider.dart';

import '../../../../utils/buttons_helper/custom_botton.dart';
import '../../../themes/providers/webinar_themes_provider.dart';
import '../../../webinar_details/webinar_details_model/meeting_details_model.dart';
import 'provider/create_webinar_provider.dart';
import 'widgets/event_id_card.dart';
import 'widgets/time_schedule_zone_widget.dart';

class CreateWebinarScreen extends StatefulWidget {
  final MeetingDetailsModel? meetingDetailsModel;
  final dynamic eventModel;
  final dynamic templateObject;
  final bool isEdit;
  final String? eventId;

  const CreateWebinarScreen({Key? key, this.meetingDetailsModel, this.eventModel, this.templateObject, this.isEdit = false, this.eventId}) : super(key: key);

  @override
  State<CreateWebinarScreen> createState() => _CreateWebinarScreenState();
}

class _CreateWebinarScreenState extends State<CreateWebinarScreen> with TickerProviderStateMixin {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  TextEditingController eventNameController = TextEditingController();
  TextEditingController agendaNameController = TextEditingController();
  TextEditingController contactsSearchController = TextEditingController();
  TextEditingController groupsSearchController = TextEditingController();
  TextEditingController timeDurationController = TextEditingController(text: "01:00");
  TextEditingController exitUrlController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  late TabController _tabController;
  ScrollController mainScrollController = ScrollController();
  ScrollController contactsScrollController = ScrollController();
  TextEditingController dateAndTimeController = TextEditingController();
  TextEditingController timeController = TextEditingController();
  ScrollController groupsScrollController = ScrollController();

  final outerPhysics = const ClampingScrollPhysics();

  void innerListener(double velocity, ScrollController outerController) {
    final sim = outerPhysics.createBallisticSimulation(outerController.position, velocity);
    if (sim != null) {
      ScrollActivity test = BallisticScrollActivity(
        outerController.position.activity!.delegate,
        sim,
        this,
        true,
      );

      outerController.position.beginActivity(test);
    }
  }

  late CreateWebinarProvider createWebinarProvider;

  @override
  void initState() {
    context.read<WebinarThemesProviders>().setupDefaultColors();
    _tabController = TabController(vsync: this, length: 2);
    createWebinarProvider = Provider.of<CreateWebinarProvider>(context, listen: false);
    createWebinarProvider.selectedTemplate = "";
    createWebinarProvider.isSelect = false;
    createWebinarProvider.selectedContactsToInvite = [];
    createWebinarProvider.selectedGroupsIndexList = [];
    createWebinarProvider.isGroupsSelect = false;
    createWebinarProvider.selectedRadioId = 0;
    createWebinarProvider.selectedDate = DateFormat("MMM dd,yyyy").format(DateTime.now());
    dateAndTimeController.text = DateFormat("dd MMMM yyyy").format(DateTime.now().add(const Duration(minutes: 10)));
    createWebinarProvider.hoursValue = DateTime.now().add(const Duration(minutes: 10)).hour.toString();
    createWebinarProvider.mintsValue = DateTime.now().add(const Duration(minutes: 10)).minute.toString().length == 1
        ? "0${DateTime.now().add(const Duration(minutes: 10)).minute}"
        : (DateTime.now().add(const Duration(minutes: 10)).minute).toString();
    createWebinarProvider.getCreateMeetingDetails();
    // WidgetsBinding.instance.addPostFrameCallback((_) {
    //   if (widget.meetingDetailsModel != null) {
    //     eventDetailsInit();
    //   }
    // });
    if (widget.meetingDetailsModel != null) {
      createWebinarProvider.isSelectedWebinarType = widget.meetingDetailsModel!.meetingType == "conference" ? 0 : 1;
      eventNameController.text = widget.meetingDetailsModel?.meetingName ?? "";
      agendaNameController.text = widget.meetingDetailsModel?.meetingAgenda ?? "";
    }
    if (widget.eventModel != null) {
      eventNameController.text = widget.eventModel?.name ?? "";
      agendaNameController.text = widget.eventModel?.description ?? "";
      Duration? duration = widget.eventModel!.endTime!.difference(widget.eventModel!.startTime!);
      timeDurationController.text = "${duration?.inHours.toString().length == 1 ? "0${duration?.inHours}" : duration?.inHours} : "
          "${(duration!.inMinutes % 60).toString().length == 1 ? "0${duration.inMinutes % 60}" : duration.inMinutes % 60}";
      createWebinarProvider.durationHoursValue = timeDurationController.text.isNotEmpty ? timeDurationController.text.split(":").first.toString() : "00";
      createWebinarProvider.durationMintsValue = timeDurationController.text.isNotEmpty ? timeDurationController.text.split(":").last.toString() : "30";
      exitUrlController.text = "";
      createWebinarProvider.selectedRadioId = 0;
      dateAndTimeController.text = DateFormat("dd MMMM yyyy").format(widget.eventModel!.startTime!);
      createWebinarProvider.hoursValue = widget.eventModel!.startTime!.hour.toString();
      createWebinarProvider.mintsValue = widget.eventModel!.startTime!.minute.toString();
    } else if (widget.eventId != null && widget.eventId != "") {
      createWebinarProvider.getEventDetailsid(id: widget.eventId ?? '', context: context).then((value) {
        print("sdjskjksskfsk    ${value?.meetingType.toString() == "conference"}");
        createWebinarProvider.isSelectedWebinarType = value?.meetingType.toString() == "conference" ? 0 : 1;
        List.generate(value!.contacts!.length, (index) {
          if (createWebinarProvider.finalUpdatedAllContactsBody.isNotEmpty) {
            for (var element in createWebinarProvider.finalUpdatedAllContactsBody) {
              if (element.contactId == value.contacts![index].contactId) {
                element.isCheck = true;
                element.participantsValue = value.contacts?[index].roleId ?? 3;
              }
            }
          }
        });
        print(value);
        eventNameController.text = value.meetingName ?? '';
        agendaNameController.text = value.meetingAgenda ?? "";
        exitUrlController.text = value.exitUrl ?? '';
        timeDurationController.text = value.duration?.toString() ?? "00:30";
        setState(() {});
      });
    }
    _tabController.addListener(() {
      if (_tabController.index == 0) {
        contactsSearchController.text = "";
        createWebinarProvider.localSearchForAllContacts(contactsSearchController.text);
      } else {
        groupsSearchController.text = "";
        createWebinarProvider.localSearchForAllGroups(groupsSearchController.text);
      }
    });
    Future.delayed(
      Duration.zero,
      () {
        DefaultUserDataModel? defaultUserDataModel = context.read<DefaultUserDataProvider>().defaultUserDataModel;
        if (defaultUserDataModel != null && defaultUserDataModel.data!.exitUrl != null && defaultUserDataModel.data!.exitUrl!.isNotEmpty) {
          exitUrlController.text = defaultUserDataModel.data!.exitUrl!;
          createWebinarProvider.toggleSetAsDefaultStatus(status: true, callApi: false, url: defaultUserDataModel.data!.exitUrl!);
        } else {
          createWebinarProvider.toggleSetAsDefault = false;
        }

        //   createWebinarProvider.finalUpdatedAllContactSelectedEmpty(fromInitScreen: true);
      },
    );

    super.initState();
  }

  late final AnimationController animationController = AnimationController(
    duration: const Duration(microseconds: 500),
    vsync: this,
  );
  late final Animation<double> animation = CurvedAnimation(
    parent: animationController,
    curve: Curves.fastOutSlowIn,
  );
  late final AnimationController animationDateTimeController = AnimationController(
    duration: const Duration(milliseconds: 500),
    vsync: this,
  );

  late final AnimationController animationtimeController = AnimationController(
    duration: const Duration(milliseconds: 500),
    vsync: this,
  );
  late final Animation<double> animationDateTime = CurvedAnimation(
    parent: animationDateTimeController,
    curve: Curves.fastOutSlowIn,
  );
  late final Animation<double> animationTime = CurvedAnimation(
    parent: animationtimeController,
    curve: Curves.fastOutSlowIn,
  );

  @override
  void dispose() {
    eventNameController.dispose();
    agendaNameController.dispose();
    contactsSearchController.dispose();
    groupsSearchController.dispose();
    timeDurationController.dispose();
    animationController.dispose();
    animationDateTimeController.dispose();
    dateAndTimeController.dispose();
    createWebinarProvider.resetContactsInivtationDetails();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: true,
      onPopInvoked: (didPop) {
        if (didPop) {
          debugPrint("the create webinar screen Pop");
          createWebinarProvider.clearValues();
          return;
        }
      },
      child: Scaffold(
          backgroundColor: Theme.of(context).scaffoldBackgroundColor,
          drawerEnableOpenDragGesture: false,
          body: SafeArea(
            child: Form(
              key: _formKey,
              child: Consumer<CreateWebinarProvider>(builder: (_, createWebinar, __) {
                return Padding(
                  padding: EdgeInsets.only(left: 10.w, right: 10.w, bottom: 10.h),
                  child: SingleChildScrollView(
                    controller: mainScrollController,
                    child: Column(
                      children: [
                        height10,
                        Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10.sp),
                              color: Theme.of(context).cardColor,
                            ),
                            child: Padding(
                                padding: EdgeInsets.symmetric(horizontal: 10.sp, vertical: 8.sp),
                                child: Column(crossAxisAlignment: CrossAxisAlignment.start, mainAxisAlignment: MainAxisAlignment.start, children: [
                                  SizedBox(
                                    height: 55.h,
                                    width: ScreenConfig.width * 0.9,
                                    child: ListView.builder(
                                        shrinkWrap: true,
                                        scrollDirection: Axis.horizontal,
                                        padding: EdgeInsets.zero,
                                        itemCount: createWebinar.webinarTypeRadioListTile.length,
                                        itemBuilder: (context, index) {
                                          return Padding(
                                            padding: const EdgeInsets.all(8.0),
                                            child: SizedBox(
                                              height: 43.h,
                                              width: MediaQuery.of(context).size.width * 0.41,
                                              child: Theme(
                                                data: Theme.of(context).copyWith(
                                                  unselectedWidgetColor: Theme.of(context).cardColor,
                                                  disabledColor: Theme.of(context).indicatorColor,
                                                  colorScheme: ThemeData().colorScheme.copyWith(
                                                        onPrimary: Theme.of(context).indicatorColor,
                                                      ),
                                                ),
                                                child: GestureDetector(
                                                  onTap: () {
                                                    createWebinarProvider.isSelectedWebinarMethod(index);

                                                    /*  setState(() {
                                                      isSelected = index;
                                                    });*/
                                                  },
                                                  child: Container(
                                                    height: 37.h,
                                                    decoration: BoxDecoration(
                                                        color: createWebinar.isSelectedWebinarType == index ? AppColors.mainBlueColor : Colors.transparent, borderRadius: BorderRadius.circular(6)),
                                                    child: Padding(
                                                      padding: const EdgeInsets.all(8.0),
                                                      child: Center(
                                                        child: Text(
                                                          createWebinar.webinarTypeRadioListTile[index].name,
                                                          style: w400_14Poppins(color: createWebinar.isSelectedWebinarType == index ? Colors.white : Theme.of(context).primaryColorLight),
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                              ),
                                            ),
                                          );
                                        }),
                                  ),
                                ]))),
                        height10,
                        Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10.sp),
                            color: Theme.of(context).cardColor,
                          ),
                          child: Padding(
                            padding: EdgeInsets.symmetric(horizontal: 10.sp, vertical: 15.sp),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                RichText(
                                    text: TextSpan(children: [
                                  TextSpan(text: "Title", style: w500_13Poppins(color: Theme.of(context).hintColor)),
                                  TextSpan(
                                    text: "*",
                                    style: w500_13Poppins(color: Colors.red),
                                  ),
                                  WidgetSpan(child: width10),
                                  // TextSpan(text: "Min 3 - Max 50", style: w400_12Poppins(color: Theme.of(context).hintColor))
                                ])),
                                height5,
                                CommonTextFormField(
                                  validator: (val, String? fieldName) {
                                    return FormValidations.requiredFieldValidationInCreateWithMinimumCharecters(val, "Event name");
                                  },
                                  maxLength: 50,
                                  fillColor: Theme.of(context).cardColor,
                                  borderColor: Theme.of(context).primaryColorDark,
                                  controller: eventNameController,
                                  hintText: createWebinar.isSelectedWebinarType == 0 ? "Enter Conference Name" : ConstantsStrings.enterEventName,
                                ),
                                height10,
                                RichText(
                                    text: TextSpan(children: [
                                  TextSpan(text: ConstantsStrings.yourAgenda, style: w500_13Poppins(color: Theme.of(context).hintColor)),
                                  TextSpan(
                                    text: "*",
                                    style: w500_13Poppins(color: Colors.red),
                                  ),
                                  WidgetSpan(child: width10),
                                  // TextSpan(text: "Min 3 - Max 50", style: w400_12Poppins(color: Theme.of(context).hintColor))
                                ])),
                                height5,
                                CommonTextFormField(
                                  validator: (val, String? fieldName) {
                                    return FormValidations.requiredFieldValidationInCreateWithMinimumCharecters(val, "Your agenda");
                                  },
                                  fillColor: Theme.of(context).cardColor,
                                  maxLength: 50,
                                  borderColor: Theme.of(context).primaryColorDark,
                                  controller: agendaNameController,
                                  hintText: createWebinar.isSelectedWebinarType == 0 ? "Enter Conference Agenda" : ConstantsStrings.enterYourAgenda,
                                ),
                              ],
                            ),
                          ),
                        ),

                        // Container(
                        //     decoration: BoxDecoration(
                        //       borderRadius: BorderRadius.circular(10.h),
                        //       color: Theme.of(context).cardColor,
                        //     ),
                        //     child: Padding(
                        //       padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 15.h),
                        //       child: Column(
                        //         crossAxisAlignment: CrossAxisAlignment.start,
                        //         children: [
                        //           if (createWebinar.selectedTemplateList.isNotEmpty) ...[
                        //             const TextFieldTexts(name: ConstantsStrings.savedTemplates, isRequired: false),
                        //             Container(
                        //               decoration: BoxDecoration(
                        //                 color: Theme.of(context).primaryColor,
                        //                 borderRadius: BorderRadius.circular(5.sp),
                        //               ),
                        //               child: DropdownButton2(
                        //                 style: TextStyle(color: Theme.of(context).disabledColor),
                        //                 dropdownStyleData: DropdownStyleData(decoration: BoxDecoration(color: Theme.of(context).primaryColor)),
                        //                 buttonStyleData: ButtonStyleData(decoration: BoxDecoration(color: Theme.of(context).primaryColor)),
                        //                 isExpanded: true,
                        //                 iconStyleData: IconStyleData(
                        //                   icon: Padding(
                        //                     padding: EdgeInsets.symmetric(horizontal: 8.0.w),
                        //                     child: SvgPicture.asset(AppImages.webinarDropdown),
                        //                   ),
                        //                   iconSize: 30,
                        //                 ),
                        //                 hint: Text('Select Template', style: w400_13Poppins(color: Theme.of(context).disabledColor)),
                        //                 underline: const SizedBox(),
                        //                 disabledHint: Padding(
                        //                   padding: EdgeInsets.all(5.0.r),
                        //                   child: Text("Select Template", style: w400_13Poppins(color: Theme.of(context).disabledColor)),
                        //                 ),
                        //                 value: createWebinar.selectedTemplate.isEmpty ? null : createWebinar.selectedTemplate,
                        //                 items: createWebinar.selectedTemplateList.map(
                        //                   (value) {
                        //                     return DropdownMenuItem<String>(
                        //                       value: value.templateName ?? "",
                        //                       child: Text(
                        //                         value.templateName ?? "",
                        //                         style: w400_14Poppins(color: Theme.of(context).hintColor),
                        //                       ),
                        //                     );
                        //                   },
                        //                 ).toList(),
                        //                 onChanged: (value) {
                        //                   createWebinar.updateSelectedTemplateValue(
                        //                       value!, context, eventNameController, agendaNameController, exitUrlController, timeDurationController, dateAndTimeController);
                        //                   createWebinarProvider.setCreateWebinarResponseData = null;
                        //                 },
                        //               ),
                        //             ),
                        //             height10,
                        // ],
                        // const TextFieldTexts(
                        //   name: ConstantsStrings.exitUrl,
                        //   isRequired: false,
                        // ),
                        // CommonTextFormField(
                        //   fillColor: Theme.of(context).primaryColor,
                        //   controller: exitUrlController,
                        //   validator: (val, String? fieldName) {
                        //     return FormValidations.urlValidation(val.toString(), isRequiredFeild: false);
                        //   },
                        //   onChanged: (value) {
                        //     createWebinarProvider.toggleSetAsDefault = value.isValidUrl;
                        //   },
                        //   hintText: ConstantsStrings.enterExitUrl,
                        // ),
                        // SetAsDefault(
                        //   showSetAsDefault: createWebinarProvider.showSetAsDefault,
                        //   status: createWebinarProvider.setAsDefaultStatus,
                        //   onChanged: (bool? status) async {
                        //     bool feildStatus = status ?? false;
                        //     await createWebinarProvider.toggleSetAsDefaultStatus(
                        //       status: feildStatus,
                        //       callApi: true,
                        //       url: feildStatus ? exitUrlController.text : "",
                        //     );
                        //   },
                        // )
                        //     ],
                        //   ),
                        // )),
                        // height10,
                        // Container(
                        //   decoration: BoxDecoration(
                        //     color: Theme.of(context).cardColor,
                        //     borderRadius: BorderRadius.circular(10.sp),
                        //   ),
                        //   child: Column(
                        //     children: [
                        //       Padding(
                        //         padding: EdgeInsets.symmetric(horizontal: 10.w),
                        //         child: TabBar(
                        //           labelColor: Colors.blue,
                        //           labelStyle: w400_12Poppins(color: Colors.blue),
                        //           indicatorColor: Theme.of(context).focusColor,
                        //           unselectedLabelStyle: w400_12Poppins(color: Theme.of(context).hintColor),
                        //           unselectedLabelColor: Theme.of(context).hintColor,
                        //           controller: _tabController,
                        //           tabs: [
                        //             Tab(
                        //                 child: Text(
                        //               ConstantsStrings.contacts,
                        //               style: TextStyle(fontSize: 14.sp, fontWeight: FontWeight.w400, fontFamily: poppins),
                        //             )),
                        //             Tab(
                        //               child: Text(ConstantsStrings.groups, style: TextStyle(fontSize: 14.sp, fontWeight: FontWeight.w400, fontFamily: poppins)),
                        //             ),
                        //           ],
                        //         ),
                        //       ),
                        //       SizedBox(
                        //         height: 350.h,
                        //         child: TabBarView(controller: _tabController, children: [
                        //           createWebinar.isContactsLoading
                        //               ? Lottie.asset(AppImages.loadingJson, width: 40.w, height: 40.w)
                        //               : ContactsTabWidget(
                        //                   controller: contactsSearchController,
                        //                   scrollController: contactsScrollController,
                        //                   formKey: _formKey,
                        //                   outerController: (vel, isMin) => innerListener(vel, mainScrollController)),
                        //           createWebinar.isGroupsLoading
                        //               ? Center(
                        //                   child: Lottie.asset(AppImages.loadingJson, height: 40.w, width: 40.w),
                        //                 )
                        //               : GroupsTabWidget(
                        //                   context: context,
                        //                   createWebinar: createWebinar,
                        //                   controller: groupsSearchController,
                        //                   scrollController: groupsScrollController,
                        //                   outerController: (vel, isMin) => innerListener(vel, mainScrollController))
                        //         ]),
                        //       )
                        //     ],
                        //   ),
                        // ),
                        height10,

                        TimeScheduleZoneWidget(
                            isEdit: widget.isEdit,
                            urlShow: widget.isEdit ? "" : "",
                            timeDateController: timeController,
                            timeAnimationController: animationtimeController,
                            controller: timeDurationController,
                            animation: animation,
                            timeAnimation: animationTime,
                            animationController: animationController,
                            dateTimeAnimation: animationDateTime,
                            dateTimeAnimationController: animationDateTimeController,
                            dateController: dateAndTimeController),
                        height10,
                        const EventIdCard(),
                        height10,
                        Container(
                          height: 80.h,
                          decoration: BoxDecoration(color: Theme.of(context).cardColor, borderRadius: BorderRadius.circular(8)),
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  "Select Contacts",
                                  style: w400_14Poppins(color: Colors.white),
                                ),
                                5.h.height,
                                GestureDetector(
                                  onTap: () {
                                    Navigator.push(context, MaterialPageRoute(builder: (context) => const CreateWebinarContacts()));
                                  },
                                  child: Container(
                                    height: 35.h,
                                    decoration: BoxDecoration(color: const Color(0xff202223), borderRadius: BorderRadius.circular(8)),
                                    child: Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Row(
                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                        children: [
                                          // here 0 is showing
                                          createWebinarProvider.selectedContactsIndexList.isNotEmpty
                                              ? Text(
                                                  "${createWebinarProvider.selectedContactsIndexList.length} selected Group",
                                                  style: w400_13Poppins(color: Theme.of(context).primaryColorLight),
                                                )
                                              : Text(
                                                  "${createWebinarProvider.selectedGroupsIndexList.length} selected contacts",
                                                  style: w400_13Poppins(color: Theme.of(context).primaryColorLight),
                                                ),
                                          SvgPicture.asset(AppImages.contactsIcon, color: Theme.of(context).primaryColorLight)
                                        ],
                                      ),
                                    ),
                                  ),
                                )
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              }),
            ),
          ),
          bottomNavigationBar: Consumer2<CreateWebinarProvider, HomeScreenProvider>(builder: (_, createWebinar, homeScreenProvider, __) {
            return Row(mainAxisAlignment: MainAxisAlignment.end, children: [
              CustomButton(
                height: 35.h,
                width: 180.w,
                buttonColor: const Color(0xff1B2632),
                onTap: () {
                  if (widget.isEdit) {
                    Navigator.pop(context);
                  } else {
                    createWebinarProvider.clearValues();
                    Provider.of<HomeScreenProvider>(context, listen: false).updateCurrentPage(1);
                  }
                },
                buttonText: ConstantsStrings.cancel,
                buttonTextStyle: w400_14Poppins(color: Colors.white),
              ),
              width10,
              CustomButton(
                width: 180.w,
                height: 35.h,
                buttonColor: Colors.blue,
                buttonText: widget.isEdit ? "Update Event" : ConstantsStrings.createEvent,
                onTap: () async {
                  if (_formKey.currentState!.validate()) {
                    var maximumDurationHours = int.parse(timeDurationController.text.split(":").first);
                    var maximumDurationMinutes = int.parse(timeDurationController.text.split(":").last);

                    if (maximumDurationHours >= 6) {
                      if (maximumDurationMinutes > 0) {
                        CustomToast.showErrorToast(msg: "webinar duration cannot exceed 6 hours");
                        return;
                      }
                    } else if (maximumDurationHours == 0 && maximumDurationMinutes < 5) {
                      CustomToast.showErrorToast(msg: "The Min duration is 5min.");
                      return;
                    } else if (RegExp(r'^[0-9]+$').hasMatch(exitUrlController.text) ||
                        RegExp(r'^[!@#\$%^&*(),.?":{}|<>]+$').hasMatch(exitUrlController.text) ||
                        RegExp(r'^[a-zA-Z]+$').hasMatch(exitUrlController.text)) {
                      CustomToast.showErrorToast(msg: "Invalid Exit URL");
                      return;
                    }

                    DateFormat dateFormat = DateFormat('d MMMM yyyy');
                    DateFormat timeFormat = DateFormat('HH:mm');
                    DateTime chosenDate = dateFormat.parse(dateAndTimeController.text);
                    DateTime chosenTime = timeFormat.parse(timeController.text.trim());
                    DateTime chosenDateTime = DateTime(chosenDate.year, chosenDate.month, chosenDate.day, chosenTime.hour, chosenTime.minute);
                    debugPrint('qqqqqqqqq ----> ${chosenDateTime.toString()}');
                    if (chosenDateTime.isBefore(DateTime.now().copyWith(minute: DateTime.now().minute - 1))) {
                      CustomToast.showErrorToast(msg: 'Time Should not be past');
                      return;
                    }
                    createWebinar.checkUserSubscribedContacts(context).then((value) async {
                      if (value) {
                        await createWebinar
                            .sendCreateWebinarData(
                                name: eventNameController.text.toString(),
                                agenda: agendaNameController.text.toString(),
                                exitURl: exitUrlController.text.toString(),
                                password: passwordController.text.toString(),
                                duration: timeDurationController.text.toString(),
                                dateTime: chosenDateTime,
                                context: context,
                                isEventEdited: widget.isEdit,
                                editedDataInUpcoming: createWebinarProvider.eventDetailsResponse,
                                editedDataInCalender: widget.eventModel)
                            .then((value) {
                          createWebinarProvider.clearValues();
                          if (FocusManager.instance.primaryFocus != null) {
                            FocusManager.instance.primaryFocus!.unfocus();
                          }

                          homeScreenProvider.updateCurrentPage(1);

                          //  eventNameController.clear();
                          //  agendaNameController.clear();
                          /* exitUrlController.clear();
                          passwordController.clear();
                          timeDurationController.clear();
                          dateAndTimeController.clear();
*/
                          //   Navigator.push(context, MaterialPageRoute(builder: (context) => const WebinarPage()));

                          /*  Navigator.pushReplacement(context, newRoute)
                          WebinarDetails*/
                          // WebinarDetails
                          // new to remove this
                          // Navigator.pushReplacementNamed(context, RoutesManager.webinar);
                        });
                      }
                    });
                  } else {
                    print("vdfb");
                    mainScrollController.animateTo(0, duration: const Duration(milliseconds: 400), curve: Curves.fastOutSlowIn);
                  }
                },
              )
            ]);
          })),
    );
  }
}
