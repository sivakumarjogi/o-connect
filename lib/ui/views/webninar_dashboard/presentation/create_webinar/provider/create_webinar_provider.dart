// ignore_for_file: use_build_context_synchronously

import 'dart:convert';
import 'dart:developer';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:o_connect/core/models/response_models/profile_response_model.dart/profile_response_model.dart';
import 'package:o_connect/core/providers/base_provider.dart';
import 'package:o_connect/core/providers/default_user_data_provider.dart';
import 'package:o_connect/core/service/api_helper/api_helper.dart';
import 'package:o_connect/my_app.dart';
import 'package:o_connect/ui/utils/base_urls.dart';
import 'package:o_connect/ui/utils/custom_show_dialog_helper/custom_show_dialog.dart';
import 'package:o_connect/ui/utils/custom_toast_helper/custom_toast.dart';
import 'package:o_connect/ui/utils/utils.dart';
import 'package:o_connect/ui/views/drawer/calender/custom_calendar_view/src/extensions.dart';
import 'package:o_connect/ui/views/home_screen/home_screen_provider/home_screen_provider.dart';
import 'package:o_connect/ui/views/meeting/utils/context_ext.dart';
import 'package:o_connect/ui/views/webninar_dashboard/presentation/create_webinar/models/create_webinar_model.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../../../../core/models/auth_models/generate_token_o_connect_model.dart';
import '../../../../../../core/models/create_webinar_model/contact_groups_model/create_webinar_all_contacts.dart';
import '../../../../../../core/models/create_webinar_model/contact_groups_model/get_all_groups_response_model.dart';
import '../../../../../../core/models/create_webinar_model/create_webinar_response_model.dart';
import '../../../../../../core/models/create_webinar_model/selected_template_model.dart';
import '../../../../../../core/models/dummy_models/dummy_model.dart';
import '../../../../../../core/repository/create_webinar_repository/create_webinar_repo.dart';
import '../../../../../../core/routes/routes_name.dart';
import '../../../../../../core/service_locator.dart';
import '../../../../../../core/user_cache_service.dart';
import '../../../../../utils/constant_strings.dart';
import '../../../../../utils/loading_helper/loading_indicator.dart';
import '../../../../authentication/Auth_providers/auth_api_provider.dart';
import '../../../../home_screen/home_repository/home_repository.dart';
import '../../../../home_screen/home_screen_models/user_subscription_model.dart';
import '../../../../home_screen/home_screen_view/widgets/check_subscription_pop_up.dart';
import '../../../../webinar_details/webinar_details_provider/webinar_details_provider.dart';
import '../widgets/conflict_alert_widget.dart';

class CreateWebinarProvider extends BaseProvider {
  CreateWebinarRepository createWebinarRepository = CreateWebinarRepository(
      ApiHelper().oConnectDio,
      baseUrl: BaseUrls.meetingBaseUrl);
  CreateWebinarRepository trimUrlsRepo = CreateWebinarRepository(
      ApiHelper().oesDio,
      baseUrl: BaseUrls.trimUrlsBaseUrl);
  CreateWebinarRepository createWebinarContactsRepository =
      CreateWebinarRepository(ApiHelper().oesDio, baseUrl: BaseUrls.baseUrl);
  CreateWebinarRepository createWebinarGetTemplateRepository =
      CreateWebinarRepository(ApiHelper().oConnectDio,
          baseUrl: BaseUrls.templateBaseUrl);

  ///contacts
  bool isContactsLoading = false;
  bool isGroupsLoading = false;
  List<AllContactsResponseModelBody> getAllContactsBody = [];
  List<AllContactsResponseModelBody> finalUpdatedAllContactsBody = [];
  List<AllContactsResponseModelBody> filteredFinalUpdatedAllContactsBody = [];
  List selectedGroupsToInvite = [];
  List selectedContactsToInvite = [];
  List<Record> groupsRecords = [];
  List<Record> finalUpdatedGroupsRecords = [];
  List<int> selectedContactsIndexList = [];
  List<int> selectedGroupsIndexList = [];
  List<Record> finalUpdatedAllGroups = [];

  String selectedTime = "";
  List<String> minutesList = [
    "5 mins",
    "10 mins",
    "15 mins",
    "20 mins",
    "25mins"
  ];

  List<SelectedTemplateDatum> selectedTemplateList = [];
  int eventRadio = 0;
  List<RadioGroupWidget> radioListTile = [
    RadioGroupWidget(name: "Auto Generated"),
    RadioGroupWidget(name: "Personal Id"),
  ];
  List<RadioGroupWidget> webinarTypeRadioListTile = [
    RadioGroupWidget(name: "Conference"),
    RadioGroupWidget(name: "Webinar"),
  ];
  int hoursCount = 0;
  int durationHoursCount = 1;
  int durationHoursCountForRefValue = 0;
  int durationMintsValueForRef = 0;
  int durationMintsCount = 0;
  int mintsCount = 0;
  String selectedTimeZone = "Asia/Calcutta (UTC +05:30)";
  String selectedTemplate = "";
  bool isSelect = false;
  bool isGroupsSelect = false;
  late String selectedDate;
  String meetingCountFormat = DateTime.now().meetingCountFormat;
  int selectedRadioId = 0;

  // int selectedWebinarType = 0;
  bool isTimeDuration = false;

  String meetingId = "";
  CreateWebinarResponseData? eventDetailsResponse;
  List<Map<String, dynamic>> selectedContactsList = [];
  List<Map<String, dynamic>> selectedGroupList = [];
  String hoursValue = DateTime.now().hour.toString(),
      mintsValue = DateTime.now().minute.toString().length == 1
          ? "0${DateTime.now().minute.toString()}"
          : DateTime.now().minute.toString(),
      durationHoursValue = '01',
      durationMintsValue = "00";
  bool isConflict = false;
  HomeApiRepository oesRequest =
      HomeApiRepository(ApiHelper().oesDio, baseUrl: BaseUrls.baseUrl);
  bool showSetAsDefault = false;
  bool setAsDefaultStatus = false;
  bool isEVentRemainderChecked = false;

//
  int isSelectedWebinarType = 0;

  List<AllContactsResponseModelBody>? finalUpdatedAllContactSelected = [];

  set toggleSetAsDefault(bool status) {
    showSetAsDefault = status;
    notifyListeners();
  }

  void isSelectedWebinarMethod(int status) {
    isSelectedWebinarType = status;
    notifyListeners();
  }

  Future<void> toggleSetAsDefaultStatus({
    required bool status,
    required bool callApi,
    required String url,
  }) async {
    // Tuple - status,url,callApi
    setAsDefaultStatus = status;
    if (callApi) {
      navigationKey.currentContext!
          .read<DefaultUserDataProvider>()
          .changeDefaultExitUrl(defaultExitUrl: url);
    }
    notifyListeners();
  }

  void toggleEventRemainder(bool isChecked) {
    isEVentRemainderChecked = isChecked;
    notifyListeners();
  }

  void resetContactsInivtationDetails() {
    selectedGroupsToInvite = [];
    finalUpdatedAllContactSelected = [];
    selectedContactsIndexList = [];
    selectedGroupsIndexList = [];
    selectedContactsToInvite = [];
    // notifyListeners();
  }

  set changeMeetingCountDateFormat(String dateTime) {
    meetingCountFormat = dateTime;
    notifyListeners();
  }

  set setCreateWebinarResponseData(CreateWebinarResponseData? res) {
    eventDetailsResponse = res;
    notifyListeners();
  }

  Future<Response?> getMeetingCountData(BuildContext context) async {
    String? userData =
        await serviceLocator<UserCacheService>().getUserData('userData');
    if (userData != null) {
      var payload = {
        "userId": jsonDecode(userData)["id"],
        "hostEmail": Provider.of<AuthApiProvider>(context, listen: false)
            .profileData!
            .data!
            .emailId!,
        "meetingType": isSelectedWebinarType == 0 ? "conference" : "webinar",
        "userType": getUserType(context),
      };
      return await ApiHelper().oConnectDio.post(
            '${BaseUrls.meetingCountUrl}getMeetingCountByUserId',
            data: payload,
          );
    } else {
      return null;
    }
  }

  String getUserType(BuildContext context) {
    List<SubscribedProduct> subscribedProducts =
        (Provider.of<AuthApiProvider>(context, listen: false)
                .profileData
                ?.data
                ?.subscribedProducts ??
            []);
    bool isPaid = subscribedProducts.indexWhere((element) =>
            (element.isTrial == "paid" &&
                element.productName == 'O-Connect')) !=
        -1;
    if (subscribedProducts.isEmpty || isPaid) {
      return "Paid";
    }
    return "FREE";
  }

  void clearValues() {
    durationHoursCount = 1;
    durationMintsCount = 0;
    durationHoursValue = '01';
    durationMintsValue = "00";
    setAsDefaultStatus = false;
    finalUpdatedAllContactSelected = [];

    notifyListeners();
  }

  increaseHoursCount() {
    if (hoursCount < 23) {
      hoursCount = int.parse(hoursValue);
      hoursCount++;
      hoursValue =
          hoursCount.toString().length == 1 ? "0$hoursCount" : "$hoursCount";
    }
    notifyListeners();
  }

  decreaseHoursCount() {
    if (hoursCount > 0) {
      hoursCount = int.parse(hoursValue);
      hoursCount--;
      hoursValue =
          hoursCount.toString().length == 1 ? "0$hoursCount" : "$hoursCount";
    }
    notifyListeners();
  }

  increaseMintsCount() {
    if (mintsCount < 59) {
      mintsCount = int.parse(mintsValue);
      mintsCount++;
      mintsValue =
          mintsCount.toString().length == 1 ? "0$mintsCount" : "$mintsCount";
    }
    notifyListeners();
  }

  Future getCreateMeetingDetails() async {
    await Future.wait(
        [fetchSelectedTemplates(), fetchAllContacts(), fetchAllGroups()]);
  }

  decreaseMintsCount() {
    if (mintsCount > 0) {
      mintsCount = int.parse(mintsValue);
      mintsCount--;
      mintsValue =
          mintsCount.toString().length == 1 ? "0$mintsCount" : "$mintsCount";
    }
    notifyListeners();
  }

  increaseDurationHoursCount() {
    if (durationHoursCount < 23) {
      durationHoursCount++;
      durationHoursValue = (durationHoursCount.toString().length == 1
          ? "0$durationHoursCount"
          : "$durationHoursCount");
    }
    notifyListeners();
  }

  decreaseDurationHoursCount() {
    if (durationHoursCount > 0) {
      durationHoursCount--;
      durationHoursValue = (durationHoursCount.toString().length == 1
          ? "0$durationHoursCount"
          : "$durationHoursCount");
    }
    notifyListeners();
  }

  inCreaseAndDecreaseMinutesValue({bool isDecreaseTime = false}) {
    if (!isDecreaseTime) {
      if (durationMintsCount >= 0) {
        durationMintsCount++;
        if (durationMintsCount > 59) {
          durationMintsCount = 0;
        }
        durationMintsValue = durationMintsCount == 0
            ? "00"
            : durationMintsCount <= 9
                ? "0$durationMintsCount"
                : durationMintsCount.toString();
      }
    } else {
      if (durationMintsCount > 0) {
        durationMintsCount--;
        durationMintsValue = durationMintsCount == 0
            ? "00"
            : durationMintsCount <= 9
                ? "0$durationMintsCount"
                : durationMintsCount.toString();
      }
    }
    notifyListeners();
  }

  updateSelectAll() {
    isSelect = !isSelect;
    List.generate(finalUpdatedAllContactsBody.length, (index) {
      if (isSelect) {
        selectedContactsIndexList.add(index);
        finalUpdatedAllContactsBody[index].isCheck = true;

        selectedContactsToInvite.add({
          "contact_flag": 1,
          "contact_id": getAllContactsBody[index].contactId,
          "email": getAllContactsBody[index].alternateEmailId,
          "name": getAllContactsBody[index].firstName,
          "role_id": 4,
          "type": "new",
          "omailEmailId": getAllContactsBody[index].omailEmailId,
          "profile_pic": getAllContactsBody[index].contactPic,
          "firstName": getAllContactsBody[index].firstName,
          "lastName": getAllContactsBody[index].lastName
        });
      } else {
        print("is selected list file ${selectedContactsToInvite.toString()}");
        selectedContactsIndexList = [];
        // selectedContactsToInvite = [];
        finalUpdatedAllContactsBody[index].isCheck = false;
      }
    });
    /*  selectedContactsIndexList = finalUpdatedAllContactsBody.where((contact){
    return  contact.isCheck == true;
    }).cast<int>().toList();*/

    finalUpdatedAllContactSelectedEmpty();
    notifyListeners();
  }

  updateGroupsSelectAll() {
    isGroupsSelect = !isGroupsSelect;

    List.generate(finalUpdatedGroupsRecords.length, (index) {
      if (isGroupsSelect) {
        selectedGroupsIndexList.add(index);
        finalUpdatedGroupsRecords[index].isCheck = true;
      } else {
        selectedGroupsIndexList = [];
        finalUpdatedGroupsRecords[index].isCheck = false;
      }
    });

    notifyListeners();
  }

  selectedContactList() {
    List.generate(finalUpdatedAllContactsBody.length, (i) {
      ///selectedContactsList
      if (finalUpdatedAllContactsBody[i].isCheck ?? false) {
        selectedContactsList.add({
          "contact_flag": 1,
          "contact_id": getAllContactsBody[i].contactId,
          "email": getAllContactsBody[i].alternateEmailId,
          "name": getAllContactsBody[i].firstName,
          "role_id": 4,
          "type": "new",
          "omailEmailId": getAllContactsBody[i].omailEmailId,
          "profile_pic": getAllContactsBody[i].contactPic,
          "firstName": getAllContactsBody[i].firstName,
          "lastName": getAllContactsBody[i].lastName
        });
/*        {"omailEmailId":"siva999@qa.o-mailnow.net","email":"jogisivakumar.eee@gmail.com","contact_id":1717344,
      "name":"siva","type":"new","contact_flag":1,"role_id":4,
      "profile_pic":"ECOSYSTEM/QA/OES/CUSTOMER/659303/profile/1702980683820_47644ec4-e225-4104-af3f-88c8f69d9acd635366173307894592.jpg",
      "firstName":"siva","lastName":"kumar"}*/
      }
    });
    selectedContactsList.toSet().toList();
    print("dfkjdnfkjdfksfkj  ${selectedContactsList.toString()}");
    notifyListeners();
  }

  // selectedGroupsList() {
  //   List.generate(finalUpdatedGroupsRecords.length, (i) {
  //     ///selectedGroupsList
  //     if (finalUpdatedGroupsRecords[i].isCheck) {
  //       selectedGroupList.add(finalUpdatedGroupsRecords[i].toJson());
  //     }
  //   });
  //   selectedGroupList.toSet().toList();
  // }

  updateContactsSelectedParticipants(
      AllContactsResponseModelBody contactsObject, int updatedValue) {
    contactsObject.participantsValue = updatedValue;
    contactsObject.isCheck = true;
    notifyListeners();
  }

  updateRadioName(int radioId) {
    selectedRadioId = radioId;
    notifyListeners();
  }

  updateWebinarType(int webinarType) {
    isSelectedWebinarType = webinarType;
    notifyListeners();
  }

  updateDurationOfTheTime() {
    isTimeDuration = !isTimeDuration;
    notifyListeners();
  }

  updateContactsCheckValue(int index, {int? contactId}) {
    if (selectedContactsIndexList.contains(index)) {
      finalUpdatedAllContactsBody[index].isCheck = true;
      selectedContactsIndexList.remove(index);
      for (Map<String, dynamic> details in selectedContactsToInvite) {
        if (contactId != null && details.containsValue(contactId)) {
          selectedContactsToInvite.remove(details);

          notifyListeners();
          return;
        }
      }
      notifyListeners();
    } else {
      finalUpdatedAllContactsBody[index].isCheck = true;
      selectedContactsIndexList.add(index);
      selectedContactsToInvite.add({
        "contact_flag": 1,
        "contact_id": getAllContactsBody[index].contactId,
        "email": getAllContactsBody[index].alternateEmailId,
        "name": getAllContactsBody[index].firstName,
        "role_id": 4,
        "type": "new",
        "omailEmailId": getAllContactsBody[index].omailEmailId,
        "profile_pic": getAllContactsBody[index].contactPic,
        "firstName": getAllContactsBody[index].firstName,
        "lastName": getAllContactsBody[index].lastName
      });
    }
    notifyListeners();
  }

  finalUpdatedAllContactSelectedEmpty({bool fromInitScreen = false}) {
    finalUpdatedAllContactSelected = finalUpdatedAllContactsBody
        .where((contact) => contact.isCheck == true)
        .toList();
    if (!fromInitScreen) {
      notifyListeners();
    }
  }

  updateGroupsCheckValue(int index, {int? groupId}) {
    if (selectedGroupsIndexList.contains(index)) {
      selectedGroupsIndexList.remove(index);
      notifyListeners();
    } else {
      selectedGroupsIndexList.add(index);
    }

    notifyListeners();
  }

  updateSelectedDateValue(DateTime date) {
    selectedDate = DateFormat("dd MMMM yyyy").format(date);
    notifyListeners();
  }

  updateDateView(TextEditingController dateAndTimeController) {
    dateAndTimeController.text = selectedDate;
    notifyListeners();
  }

  updateTimeView(TextEditingController timeController) {
    timeController.text = " $hoursValue:$mintsValue";
    notifyListeners();
  }

  updateTimeValue(TextEditingController timeDurationController) {
    timeDurationController.text = "$durationHoursValue:$durationMintsValue";
    notifyListeners();
  }

  updateTimeZone(String value) {
    selectedTimeZone = value;
    notifyListeners();
  }

  updateEventReminder(String value) {
    selectedTime = value;
    notifyListeners();
  }

  Future fetchSelectedTemplates() async {
    try {
      final response =
          await createWebinarGetTemplateRepository.getSelectedTemplate();
      if (response.status == true) {
        selectedTemplateList = response.data ?? [];
      }
    } on DioException catch (e) {
      debugPrint("select template DioException  ${e.response.toString()}");
    } catch (e) {
      debugPrint("select template catch  ${e.toString()}");
    }
    notifyListeners();
  }

  updateSelectedTemplateValue(
      String value,
      BuildContext context,
      TextEditingController eventNameController,
      TextEditingController agendaNameController,
      TextEditingController exitUrlController,
      TextEditingController timeDurationController,
      TextEditingController dateAndTimeController) async {
    selectedTemplate = value;
    meetingId = selectedTemplateList
        .where((element) => element.templateName == value)
        .first
        .meetingId
        .toString();
    await getEventDetailsById(
        id: meetingId,
        context: context,
        eventNameController: eventNameController,
        agendaNameController: agendaNameController,
        exitUrlController: exitUrlController,
        timeDurationController: timeDurationController,
        dateAndTimeController: dateAndTimeController);
    notifyListeners();
    eventDetailsResponse = null;
  }

  Future<CreateWebinarResponseData?> getEventDetailsid({
    required String id,
    required BuildContext context,
  }) async {
    try {
      Map<String, dynamic> payload = {"event_id": id};
      final response = await createWebinarRepository.eventDetailsById(payload);

      if (response.status == true) {
        eventDetailsResponse = response.data;
        return eventDetailsResponse;
      } else {
        return CreateWebinarResponseData();
      }
    } on DioException catch (e) {
      debugPrint("getEventDetailsById DioException  ${e.response.toString()}");
      CustomToast.showErrorToast(msg: "Data Not Found");
      return CreateWebinarResponseData();
    } catch (e, st) {
      debugPrint("getEventDetailsById catch  $e    --- $st");
      CustomToast.showErrorToast(msg: "Data Not Found");
      return CreateWebinarResponseData();
    }
  }

  Future<void> getEventDetailsById(
      {required String id,
      required BuildContext context,
      TextEditingController? eventNameController,
      TextEditingController? agendaNameController,
      TextEditingController? exitUrlController,
      TextEditingController? timeDurationController,
      TextEditingController? dateAndTimeController}) async {
    Map<String, dynamic> payload = {"event_id": id};
    print("the event details by called ");
    Loading.indicator(context);
    try {
      final response = await createWebinarRepository.eventDetailsById(payload);
      if (response.status == true) {
        if (context.mounted) {
          Navigator.pop(context);
        }
        eventDetailsResponse = response.data;
        selectedRadioId =
            eventDetailsResponse?.isAutoId.toString() == '1' ? 0 : 1;
        eventNameController?.text = eventDetailsResponse?.meetingName ?? "";
        agendaNameController?.text = eventDetailsResponse?.meetingAgenda ?? "";
        exitUrlController?.text = eventDetailsResponse?.exitUrl ?? "";
        timeDurationController?.text =
            eventDetailsResponse?.duration?.toString() ?? "00:30";
        durationHoursValue = timeDurationController!.text.isNotEmpty
            ? timeDurationController.text.split(":").first.toString()
            : "00";
        durationMintsValue = timeDurationController.text.isNotEmpty
            ? timeDurationController.text.split(":").last.toString()
            : "30";
        isSelectedWebinarType =
            eventDetailsResponse?.meetingType.toString() == "conference"
                ? 1
                : 0;

        // dateAndTimeController?.text = DateFormat("MMM dd,yyyy HH:mm").format(DateTime.parse(eventDetailsResponse?.meetingDate!.toLocal().toString() ?? DateTime.now().toString()));
        dateAndTimeController?.text = DateFormat("MMM dd,yyyy HH:mm").format(
            DateTime.parse(isBeforeDate(
                    eventDetailsResponse?.meetingDate!.toLocal() ??
                        DateTime.now().add(const Duration(minutes: 11)))
                .toString()));

        hoursValue = DateTime.parse(
                eventDetailsResponse?.meetingDate!.toLocal().toString() ??
                    DateTime.now().toString())
            .hour
            .toString();
        mintsValue = DateTime.parse(
                eventDetailsResponse?.meetingDate!.toLocal().toString() ??
                    DateTime.now().toString())
            .minute
            .toString();
        if (eventDetailsResponse!.contacts!.isNotEmpty) {
          List.generate(eventDetailsResponse!.contacts!.length, (index) {
            if (finalUpdatedAllContactsBody.isNotEmpty) {
              for (var element in finalUpdatedAllContactsBody) {
                if (element.contactId ==
                    eventDetailsResponse!.contacts![index].contactId) {
                  element.isCheck = true;
                  element.participantsValue =
                      eventDetailsResponse?.contacts?[index].roleId ?? 3;
                }
              }
            }
          });
        }
      }
    } on DioException catch (e) {
      Navigator.pop(context);
      debugPrint("getEventDetailsById DioException  ${e.response.toString()}");
      CustomToast.showErrorToast(msg: "Data Not Found");
    } catch (e) {
      Navigator.pop(context);
      debugPrint("getEventDetailsById catch  $e");
      CustomToast.showErrorToast(msg: "Data Not Found");
    }
    notifyListeners();
  }

  DateTime isBeforeDate(DateTime comparedDate) {
    String mydate = '';
    if (eventDetailsResponse!.meetingDate!.isBefore(DateTime.now())) {
      print("Compared date is less than the current date.");
      // print("Displaying the current date: $currentDate");
      print(DateTime.now());
      return DateTime.now().add(const Duration(minutes: 10)).toLocal();
    } else {
      print("Compared date is equal to or greater than the current date.");
      print(mydate);
      return eventDetailsResponse!.meetingDate!.toLocal();
    }
  }

  Future fetchAllContacts() async {
    isContactsLoading = true;
    try {
      final response = await createWebinarContactsRepository.getAllContacts();
      if (response.statusCode == 200) {
        isContactsLoading = false;
        getAllContactsBody = response.body ?? [];
        finalUpdatedAllContactsBody = getAllContactsBody;
      }
    } on DioException catch (e) {
      isContactsLoading = false;
      debugPrint("get AlContacts DioException  ${e.response.toString()}");
    } catch (e) {
      isContactsLoading = false;
      debugPrint("get AlContacts catch  ${e.toString()}");
    }
    notifyListeners();
  }

  ///All contacts Search
  void localSearchForAllContacts(String searchedText) {
    finalUpdatedAllContactsBody = [];
    if (searchedText.length > 3) {
      finalUpdatedAllContactsBody.addAll(getAllContactsBody
          .where((element) =>
              element.firstName.toString().toLowerCase() == searchedText)
          .toList());
      notifyListeners();
      return;
    }
    if (searchedText.isEmpty) {
      finalUpdatedAllContactsBody = getAllContactsBody;
      notifyListeners();
      return;
    }
    if (searchedText.isNotEmpty) {
      finalUpdatedAllContactsBody = getAllContactsBody;
      notifyListeners();
      return;
    }
  }

  Future fetchAllGroups() async {
    Map<String, dynamic> payload = {
      "pageNumber": 0,
      "pageSize": 10,
      "searchKey": "",
      "trashStatus": 0
    };
    isGroupsLoading = true;

    try {
      final response =
          await createWebinarContactsRepository.getAllGroupsInWebinar(payload);
      if (response.statusCode == 200) {
        isGroupsLoading = false;
        groupsRecords = response.data?.records ?? [];
        finalUpdatedGroupsRecords = groupsRecords;
      }
    } on DioException catch (e) {
      isGroupsLoading = false;
      debugPrint("get AllGroups DioException  ${e.response.toString()}");
    } catch (e) {
      isGroupsLoading = false;
      debugPrint("get AlGroups catch  ${e.toString()}");
    }
    notifyListeners();
  }

  ///All Groups Search
  void localSearchForAllGroups(String searchedText) {
    finalUpdatedGroupsRecords = [];
    if (searchedText.length > 3) {
      finalUpdatedGroupsRecords.addAll(groupsRecords
          .where((element) =>
              element.groupName.toString().toLowerCase() == searchedText)
          .toList());
      notifyListeners();
      return;
    }
    if (searchedText.isEmpty) {
      finalUpdatedGroupsRecords = groupsRecords;
      notifyListeners();
      return;
    }
    if (searchedText.isNotEmpty) {
      finalUpdatedGroupsRecords = groupsRecords;
      notifyListeners();
      return;
    }
  }

  updateConflictMeeting() {
    isConflict = true;
    notifyListeners();
  }

  Future<bool> checkUserSubscribedContacts(BuildContext context) async {
    try {
      String customerId = Provider.of<AuthApiProvider>(context, listen: false)
          .profileData!
          .data!
          .customerAccounts!
          .first
          .custAffId
          .toString();

      final response = await oesRequest.checkSubscribedProducts(customerId);
      UserSubscriptionModel? userSubscriptionModel = response;
      userSubscriptionModel = response;

      if (userSubscriptionModel.body!.isEmpty) {
        if (context.mounted) {
          showDialog(
              context: context,
              builder: (context) => const CheckSubscriptionPopUp());
        }
        return false;
      }
      return true;
    } on DioException catch (e) {
      CustomToast.showErrorToast(msg: e.message);
    } catch (e) {
      CustomToast.showErrorToast(msg: e.toString());
    }
    return false;
  }

  Future<void> updateSelectedGroupToInvite(String groupId) async {
    for (Map checkGroupId in selectedGroupsToInvite) {
      if (groupId.isNotEmpty && checkGroupId.containsValue(groupId)) {
        selectedGroupsToInvite.remove(checkGroupId);
        debugPrint(
            "the selected group Details are the 1 $selectedGroupsToInvite");
        return;
      }
    }

    try {
      Response res =
          await createWebinarContactsRepository.getGroupDetailsById(groupId);
      if (res.data["statusCode"] == 200) {
        List contactDetails = [];

        for (var contactsDetails in res.data["data"]["contacts"]) {
          contactDetails.add({
            "name":
                "${contactsDetails["firstName"]} ${contactsDetails["lastName"]}",
            "omailEmailId": contactsDetails["omailEmailId"],
            "email": contactsDetails["alternateEmailId"],
            "profile_pic": contactsDetails["contactPic"]
          });
        }

        Map<String, dynamic> groupDetails = {
          "group_id": groupId,
          "role": 4,
          "type": "new",
          "members": contactDetails
        };

        selectedGroupsToInvite.add(groupDetails);

        debugPrint(
            "the selected group Details are the $selectedGroupsToInvite");
      }
    } on DioException catch (e, st) {
      debugPrint("the error while selecting group ${e.error} && ${e.response}");
    }
  }

  Future sendCreateWebinarData(
      {required String name,
      required String agenda,
      required String exitURl,
      required String password,
      required BuildContext context,
      required String duration,
      required DateTime dateTime,
      bool isEventEdited = false,
      CreateWebinarResponseData? editedDataInUpcoming,
      dynamic editedDataInCalender,
      bool isFromConflictsPopUp = false}) async {
    Loading.indicator(context);
    Response? meetingCountResponse;
    try {
      meetingCountResponse = await getMeetingCountData(context);
    } catch (e) {
      log(e.toString());
      await CustomToast.showErrorToast(msg: "Something went wrong");
      context.hideLoading();
      return;
    }
    if (meetingCountResponse == null &&
            meetingCountResponse?.statusCode != 200 ||
        meetingCountResponse?.data['statusCode'] == 401) {
      await CustomToast.showErrorToast(
          msg: "Something went wrong, Logout and Again Login");
      context.hideLoading();
      return;
    } else {
      int selectedHour = int.parse(duration.split(":").first);
      int selectedMin = int.parse(duration.split(":").last);
      int overAllTimeInMin = (selectedHour * 60 + selectedMin);

      int maxTimeLimitInMin = int.parse((meetingCountResponse?.data["data"]
                  ["meetingDurationInMin"]
              .toString()) ??
          '0');
      if (overAllTimeInMin > maxTimeLimitInMin) {
        await CustomToast.showErrorToast(
            msg:
                "Your meeting time limit is exceeded than ${(maxTimeLimitInMin ~/ 60)} hour");
        context.hideLoading();
        return;
      }
    }

    final String? userDataString =
        await serviceLocator<UserCacheService>().getUserData("userData");
    GenerateTokenUser userData =
        GenerateTokenUser.fromJson(jsonDecode(userDataString!));
    debugPrint("the meeting date is the =>$dateTime ");
    // DateTime inputDate;
    // try {
    //   inputDate = DateFormat("dd MMMM yyyy HH:mm").parse(dateTime.trim());
    // } catch (e) {
    //   inputDate = DateFormat().parse(dateTime.trim());
    // }

    DateTime utcDate = dateTime.add(const Duration(minutes: 10)).toUtc();
    // String formattedMeetingUtcDate = DateFormat("yyyy-MM-dd'T'HH:mm:ss.SSS'Z'").format(utcDate);
    debugPrint(
        "the meeting date is the ${utcDate.toString()} && ${utcDate.toLocal()}");
    exitURl = normalizeExitUrl(exitURl);

    // String dateFormatting = DateTime.parse(DateFormat("yyyy-MM-dd HH:mm").format(DateTime.parse(DateFormat("MMM dd,yyyy HH:mm").parse(dateTime).toString()))).toUtc().toString();
    final payload = CreateWebinarModel(
        allowToJoin: "0",
        autoGeneratedId: "0",
        comments: agenda,
        contacts: selectedContactsToInvite,
        duration: CreateWebinarModelDuration(
            hour: int.parse(
                duration.isEmpty ? "00" : duration.split(":").first.toString()),
            minute: int.parse(
                duration.isEmpty ? "30" : duration.split(":").last.toString())),
        emails: /* selectedContactsList */ [],
        exitUrl: exitURl,
        getDate: "",
        getTime: CreateWebinarModelDuration(
            hour: int.parse(hoursValue), minute: int.parse(mintsValue)),
        groups: selectedGroupsToInvite,
        guestKey: "guest",
        isAutoId: selectedRadioId == 0 ? "1" : "0",
        isEventReminder: "0",
        meetingConflict: isConflict,
        meetingDate: utcDate.toString(),
        meetingType: isSelectedWebinarType == 0 ? "conference" : "webinar",
        name: name,
        password: "",
        recordAuto: "0",
        recordToLocal: "0",
        reminderTime: "5",
        roomCategory: "meeting",
        roomType: "time_schedule",
        timezone: selectedTimeZone.split(" ").first,
        userInfo: CreateWebinarModelUserInfo(
            name: "${userData.userFirstName}",
            userEmail: "${userData.userEmail}",
            userName: "${userData.userName}",
            profilePic: null),
        userId: int.parse(userData.id.toString()),
        country: "India");

    print("the sending payload is the ${payload.toJson().toString()}");

    try {
      if (context.mounted) {
        if (editedDataInUpcoming != null) {
          payload.meetingId = editedDataInUpcoming.id;
          payload.autoGeneratedId = editedDataInUpcoming.autoGeneratedId;
          await updatedPayloadResponse(
              payload.toJson(),
              context,
              userData,
              isEventEdited,
              isSelectedWebinarType == 0 ? "conference" : "webinar");
        } else if (editedDataInCalender != null) {
          payload.meetingId = editedDataInCalender.id;
          payload.autoGeneratedId = selectedRadioId.toString();
          await updatedPayloadResponse(
              payload.toJson(),
              context,
              userData,
              isEventEdited,
              isSelectedWebinarType == 0 ? "conference" : "webinar");
        } else {
          payload.autoGeneratedId = selectedRadioId.toString();
          await createdPayloadResponse(
              selectedWebinarType:
                  isSelectedWebinarType == 0 ? "conference" : "webinar",
              payload: payload.toJson(),
              context: context,
              userData: userData,
              isFromConflictsPopup: isFromConflictsPopUp);
        }
      }
    } on DioException catch (e) {
      debugPrint(
          "Create Webinar in DioException ${e.response.toString()} && ${e.error}");
      if (context.mounted) {
        Navigator.pop(context);
        if (e.response?.statusCode == 500) {
          CustomToast.showErrorToast(msg: "Something went wrong...");
          return;
        } else if (e.response?.statusCode == 400) {
          customShowDialog(
              navigationKey.currentState!.context,
              ConflictAlertPopup(
                name: name,
                agenda: agenda,
                exitURl: exitURl,
                password: password,
                context: navigationKey.currentState!.context,
                duration: duration,
                dateTime: dateTime,
                editedDataInUpcoming: editedDataInUpcoming,
                editedDataInCalender: editedDataInCalender,
              ),
              height: MediaQuery.of(navigationKey.currentState!.context)
                      .size
                      .height *
                  0.3);
        } else {
          CustomToast.showErrorToast(msg: e.response!.data["error"]);
        }
      }
    } catch (e, st) {
      if (context.mounted) {
        CustomToast.showErrorToast(msg: "Failed To Create Webinar");
        Navigator.pop(context);
      }
      debugPrint("Create Webinar ${e.toString()} && $st");
    }
    notifyListeners();
  }

  Future<void> generateTrimUrls(
    BuildContext context,
    body,
    GenerateTokenUser userDatas,
    String? selectedWebinarType,
    responseData,
    payload,
  ) async {
    String hostUrl = "";
    String participantsUrl = "";
    String guestUrl = "";
    SharedPreferences preferences = await SharedPreferences.getInstance();
    try {
      final String? userDataString = preferences.getString("saveProfileData");
      print(
          "Profile data is called ${preferences.getString("saveProfileData").toString()}");
      GetProfileResponsData? userData =
          GetProfileResponsData.fromJson(jsonDecode(userDataString!));

      final res = await trimUrlsRepo.generateTrimUrls(body);
      print("the trim urls length ${payload}");

      if (res.statusCode == 200) {
        for (var item in res.data["result"]) {
          if (item["inserted_row"]["url"].contains(responseData.hostKey)) {
            hostUrl = item["inserted_row"]["trimurl"];
          } else if (item["inserted_row"]["url"]
              .contains(responseData.participantKey)) {
            participantsUrl = item["inserted_row"]["trimurl"];
          }
          if (selectedWebinarType == "webinar") {
            if (item["inserted_row"]["url"].contains(responseData.guestKey)) {
              guestUrl = item["inserted_row"]["trimurl"];
            }
          }
        }
        debugPrint("trim urls generated ${res.data}");
        sendInvitationToEmails(
          context: context,
          userData: userDatas,
          meetingId: responseData.id ?? "",
          hostUrl: hostUrl,
          participantUrl: participantsUrl,
          payload: payload,
          guestUrl: guestUrl,
        );
      }
    } on DioException catch (e, st) {
      debugPrint(
          "the dio exception while trim urls ${e.response}&& $st && ${e.error} ");
    } catch (e, st) {
      debugPrint("the exception while trim urls ${e.toString()} && $st");
    }
  }

  Future sendInvitationToEmails(
      {required BuildContext context,
      required GenerateTokenUser userData,
      required String meetingId,
      required String hostUrl,
      required String participantUrl,
      required payload,
      String? guestUrl}) async {
    Map<String, dynamic> payloads = {
      "contacts": payload['contacts'] ?? [],
      "emails": [],
      "groups": selectedGroupList ?? [],
      "guest_url": guestUrl,
      "host_url": hostUrl,
      "participant_url": participantUrl,
      "meeting_id": meetingId,
      "userInfo": {
        "name": "${userData.userFirstName}",
        "userName": "${userData.userName}",
        "userEmail": "${userData.userEmail}",
      },
    };
    try {
      final response = await createWebinarRepository.sendInvitation(payloads);
      debugPrint("sendInvitation response ${response.toString()}");

      if (context.mounted) {
        await context
            .read<HomeScreenProvider>()
            .getMeetings(context, selectedValue: "upcoming", searchHistory: "");
      }
    } on DioException catch (e) {
      debugPrint(
          "sendInvitationToEmails in DioException ${e.response.toString()}");
      if (context.mounted) {
        CustomToast.showErrorToast(msg: e.response!.data["error"]);
      }
    } catch (e) {
      if (context.mounted) {
        CustomToast.showErrorToast(msg: "Failed To Send Invitation");
      }
      debugPrint("Send invitation in Create Webinar ${e.toString()}");
    }
    notifyListeners();
  }

  Future createdPayloadResponse(
      {String? selectedWebinarType,
      required Map<String, dynamic> payload,
      required BuildContext context,
      required GenerateTokenUser userData,
      bool isFromConflictsPopup = false}) async {
    CreateWebinarResponseModel response =
        await createWebinarRepository.createWebinarData(payload);
    Navigator.pop(navigationKey.currentState!.context);
    if (response.status == true) {
      if (context.mounted) {
        FocusNode().unfocus();
        context.read<WebinarDetailsProvider>().selectedValue =
            ConstantsStrings.upcomingWebinars;
        context.read<HomeScreenProvider>().selectedValue = "upcoming";

        CustomToast.showSuccessToast(
                msg: "$selectedWebinarType Created Successfully")
            .then((value) async {
          SharedPreferences preferences = await SharedPreferences.getInstance();
          final String? userDataString =
              preferences.getString("saveProfileData");
          GetProfileResponsData? userDatas =
              GetProfileResponsData.fromJson(jsonDecode(userDataString!));
          await generateTrimUrls(
              context,
              {
                "inpurlList": [
                  "${BaseUrls.webinarCopyLinkBaseUrl}/o-connect/webinar/meeting/${response.data!.id}/${response.data!.autoGeneratedId}/${response.data!.hostKey.toString()}/${userData.customerId}/${userDatas.customerAccounts!.first.custAffId}",
                  "${BaseUrls.webinarCopyLinkBaseUrl}/o-connect/webinar/meeting/${response.data!.id}/${response.data!.autoGeneratedId}/${response.data!.participantKey.toString()}/${userData.customerId}/${userDatas.customerAccounts!.first.custAffId}",
                  if (selectedWebinarType == "webinar")
                    "${BaseUrls.webinarCopyLinkBaseUrl}/o-connect/webinar/meeting/${response.data!.id}/${response.data!.autoGeneratedId}/${response.data!.guestKey.toString()}/${userData.customerId}/${userDatas.customerAccounts!.first.custAffId}"
                ]
              },
              userData,
              selectedWebinarType,
              response.data,
              payload);
          if (isFromConflictsPopup) {
            Navigator.pop(navigationKey.currentState!.context);
            // Navigator.pushNamed(navigationKey.currentState!.context, RoutesManager.webinar);
          } else {}
        });
      }
    }
  }

  Future updatedPayloadResponse(
      Map<String, dynamic> payload,
      BuildContext context,
      GenerateTokenUser userData,
      bool isEventEdited,
      String selectedWebinarType) async {
    final response = await createWebinarRepository.updateWebinarData(payload);
    if (response.status == true) {
      if (context.mounted) {
        SharedPreferences preferences = await SharedPreferences.getInstance();
        final String? userDataString = preferences.getString("saveProfileData");
        GetProfileResponsData? userDatas =
            GetProfileResponsData.fromJson(jsonDecode(userDataString!));
        await generateTrimUrls(
            context,
            {
              "inpurlList": [
                "${BaseUrls.webinarCopyLinkBaseUrl}/o-connect/webinar/meeting/${response.data!.id}/${response.data!.autoGeneratedId}/${response.data!.hostKey.toString()}/${userData.customerId}/${userDatas.customerAccounts!.first.custAffId}",
                "${BaseUrls.webinarCopyLinkBaseUrl}/o-connect/webinar/meeting/${response.data!.id}/${response.data!.autoGeneratedId}/${response.data!.participantKey.toString()}/${userData.customerId}/${userDatas.customerAccounts!.first.custAffId}",
                if (selectedWebinarType == "webinar")
                  "${BaseUrls.webinarCopyLinkBaseUrl}/o-connect/webinar/meeting/${response.data!.id}/${response.data!.autoGeneratedId}/${response.data!.guestKey.toString()}/${userData.customerId}/${userDatas.customerAccounts!.first.custAffId}"
              ]
            },
            userData,
            selectedWebinarType,
            response.data,
            payload);

        await CustomToast.showSuccessToast(
                msg: isEventEdited
                    ? "Webinar Updated Successfully"
                    : "Webinar Created Successfully")
            .then((value) {
          if (isEventEdited) {
            Provider.of<HomeScreenProvider>(context, listen: false)
                .updateCurrentPage(2);
            Navigator.pushNamed(context, RoutesManager.homeScreen);

            /*   Navigator.pop(context);
            Navigator.pop(context);
            Navigator.pop(context);*/
          } else {}
        });
        await sendInvitationToEmails(
            context: context,
            userData: userData,
            meetingId: response.data?.id ?? "",
            hostUrl: response.data!.hostUrl.toString(),
            participantUrl: response.data!.participantUrl.toString(),
            payload: payload,
            guestUrl: response.data!.guestUrl ?? "");
        await Provider.of<HomeScreenProvider>(context, listen: false)
            .getMeetings(context, selectedValue: "upcoming", searchHistory: "");
      }
    }
  }
}
