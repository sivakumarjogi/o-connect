import 'dart:async';
import 'package:dio/dio.dart';
import 'package:intl/intl.dart';
import 'package:o_connect/core/models/calender_model/day_model.dart';
import 'package:o_connect/core/models/dummy_models/dummy_model.dart';
import 'package:o_connect/core/providers/base_provider.dart';
import 'package:o_connect/core/repository/calender_repository/calender_api_repo.dart';
import 'package:o_connect/core/service/api_helper/api_helper.dart';
import 'package:o_connect/my_app.dart';
import 'package:o_connect/ui/utils/custom_toast_helper/custom_toast.dart';
import 'package:o_connect/ui/views/authentication/Auth_providers/auth_api_provider.dart';
import 'package:o_connect/ui/views/drawer/calender/custom_calendar_view/src/calendar_event_data.dart';
import 'package:o_connect/ui/views/drawer/calender/custom_calendar_view/src/event_controller.dart';
import 'package:provider/provider.dart';
import '../../ui/utils/base_urls.dart';

class CalenderProvider extends BaseProvider {
  CalenderApiRepository apiRepository =
      CalenderApiRepository(ApiHelper().oesDio, baseUrl: BaseUrls.baseUrl);

  int categorySelected = 0;
  List<String> tabsList = ["Day", "Week", "Month"];
  int selectedEvents = 0;
  List<String> eventsList = ["Upcoming", "Completed", "Cancelled"];
  List<String> eventsListGetIndex = ["all","upcoming", "completed", "cancelled"];
  String checkboxSelectedText = checkboxList.first.checkboxText;
  String onPageChangeDate = DateTime.now().toString();
  String? startDate;
  String? endDate;
  List multipleSelected = [];
  List multipleSelectedEvent = [];
  List<Event> events = [];
  List<Event> filteredEvents = [];
  List<Event> updatedList = [];
  CalenderDayModel? calenderMonthEvent;
  bool? isLoadingDataCale = false;
  bool? noDataFound = false;

  EventController dayController = EventController();

  bool isSelected=false;

  void setSelectedItem(index, {bool fromInitState = false}) {
    categorySelected = index;
    if (!fromInitState) {
      notifyListeners();
    }
  }

  isSelectedMethod(bool vales) {
    isSelected=vales;
    notifyListeners();
  }
  isSelectedMethodInit(bool vales) {
    isSelected=vales;

  }

  //To allow selected optins in popup on tap of ok button
  allowSelection() {
    updateEventsOnCheckBox();
    notifyListeners();
  }

  updateSelectedOptions(bool isChecked, int index) {
    if (index == 0) {
      //for select all
      checkboxList[0].isCheck = isChecked;
      checkboxSelectedText = checkboxList.first.checkboxText;
      multipleSelectedEvent = [];
      for (CheckboxModel element in checkboxList) {
        element.isCheck = isChecked;
      }
      multipleSelectedEvent.add(checkboxList.first.checkboxText);
      notifyListeners();
    } else {
      checkboxList.first.isCheck = false;
      updateCheckboxListIndex(isChecked, index);
    }
    notifyListeners();
  }

// event type


  updateSelectedOptionsEvent(bool isChecked, int index) {
    if (index == 0) {
      //for select all
      checkboxListEvent[0].isCheck = isChecked;
      checkboxSelectedText = checkboxListEvent.first.checkboxText;
      multipleSelectedEvent = [];
      for (CheckboxModel element in checkboxListEvent) {
        element.isCheck = isChecked;
      }
      multipleSelectedEvent.add(checkboxListEvent.first.checkboxText);
      notifyListeners();
    } else {
      checkboxListEvent.first.isCheck = false;
      updateCheckboxListIndexEvent(isChecked, index);
    }
    notifyListeners();
  }


  updateCheckboxListIndexEvent(bool isChecked, int index) {
    if (checkboxListEvent[0].isCheck) {
      checkboxListEvent[0].isCheck = false;
    }
    checkboxListEvent[index].isCheck = isChecked;
    if (multipleSelectedEvent.contains(checkboxListEvent[index].checkboxText)) {
      multipleSelectedEvent.remove(checkboxListEvent[index].checkboxText);
    } else {
      multipleSelectedEvent.add(checkboxListEvent[index].checkboxText);
    }
    if (checkboxListEvent[1].isCheck &&
        checkboxListEvent[2].isCheck &&
        checkboxListEvent[3].isCheck) {
      checkboxListEvent[0].isCheck = true;
    } // updateEventsOnCheckBox();

    notifyListeners();
  }


  selectALlProducts(
    bool isChecked,
  ) {
    for (int i = 0; i < checkboxList.length; i++) {
      checkboxList[i].isCheck = isChecked;
      if (multipleSelected.contains(checkboxList[i].checkboxText)) {
        multipleSelected.remove(checkboxList[i].checkboxText);
      } else {
        multipleSelected.add(checkboxList[i].checkboxText);
      }
    }
    checkboxSelectedText = multipleSelected.isNotEmpty
        ? multipleSelected.contains(checkboxList.first.checkboxText)
            ? checkboxList.first.checkboxText
            : checkboxSelectedText
        : checkboxList.first.checkboxText;
    notifyListeners();
  }



  selectALlProductsEvent(
      bool isChecked,
      ) {
    for (int i = 0; i < checkboxListEvent.length; i++) {
      checkboxListEvent[i].isCheck = isChecked;
      if (multipleSelectedEvent.contains(checkboxListEvent[i].checkboxText)) {
        multipleSelectedEvent.remove(checkboxListEvent[i].checkboxText);
      } else {
        multipleSelectedEvent.add(checkboxListEvent[i].checkboxText);
      }
    }
    checkboxSelectedText = multipleSelectedEvent.isNotEmpty
        ? multipleSelectedEvent.contains(checkboxListEvent.first.checkboxText)
            ? checkboxListEvent.first.checkboxText
            : checkboxSelectedText
        : checkboxListEvent.first.checkboxText;
    notifyListeners();
  }

  void setSelectedEventsItem(index, context) {
    updatedList = [];
    selectedEvents = index;
    updatedList.addAll(events.where((element) {
      // print(element.status);
      return (eventsList[selectedEvents].toLowerCase() == element.status);
    }).toList());
    notifyListeners();
  }

  updateCheckboxListIndex(bool isChecked, int index) {
    if (checkboxList[0].isCheck) {
      checkboxList[0].isCheck = false;
    }
    checkboxList[index].isCheck = isChecked;
    if (multipleSelected.contains(checkboxList[index].checkboxText)) {
      multipleSelected.remove(checkboxList[index].checkboxText);
    } else {
      multipleSelected.add(checkboxList[index].checkboxText);
    }
    if (checkboxList[1].isCheck && checkboxList[2].isCheck && checkboxList[3].isCheck) {
      checkboxList[0].isCheck = true;
    } // updateEventsOnCheckBox();

    notifyListeners();
  }

  checkALlProducts(
    bool isChecked,
  ) {
    for (int i = 0; i < checkboxList.length; i++) {
      checkboxList[i].isCheck = isChecked;
      if (multipleSelected.contains(checkboxList[i].checkboxText)) {
        multipleSelected.remove(checkboxList[i].checkboxText);
      } else {
        multipleSelected.add(checkboxList[i].checkboxText);
      }
    }
    checkboxSelectedText = multipleSelected.isNotEmpty
        ? multipleSelected.contains(checkboxList.first.checkboxText)
            ? checkboxList.first.checkboxText
            : checkboxSelectedText
        : checkboxList.first.checkboxText;
    notifyListeners();
  }

  updateEventsOnCheckBox() {
    filteredEvents = [];
    multipleSelected = [];
    List<CheckboxModel> filteredCheckboxList = checkboxList.where((element) => element.isCheck).toList();
    if (checkboxList[0].isCheck) {
      multipleSelected.add(checkboxList[0].checkboxText);
    } else {
      for (CheckboxModel element in filteredCheckboxList) {
        multipleSelected.add(element.checkboxText);
      }
    }

    if (multipleSelected.isNotEmpty && multipleSelected.length <= 2) {
      filteredEvents = events.where((object) {
        return multipleSelected.contains(object.productName);
      }).toList();
      dayController = EventController();
      dayController.addAll(getCalendarEventDataList(filteredEvents));
    } else if (multipleSelected.isEmpty || multipleSelected.contains(checkboxList.first.checkboxText)) {
      dayController = EventController();
      dayController.addAll(getCalendarEventDataList(events));
    }
    checkboxSelectedText = multipleSelected.isNotEmpty
        ? multipleSelected.length == 3
            ? checkboxList.first.checkboxText
            : multipleSelected
                .toString()
                .replaceAll("[", "")
                .replaceAll("]", "")
        : checkboxList.first.checkboxText;
    notifyListeners();
  }

  void applyFilter() {
    multipleSelected = [];
    List<CheckboxModel> filteredCheckboxList =
        checkboxList.where((element) => element.isCheck).toList();
    if (checkboxList[0].isCheck) {
      for (int a = 1; a < checkboxList.length; a++) {
        multipleSelected.add(checkboxList[a].checkboxText);
      }
    } else {
      for (CheckboxModel element in filteredCheckboxList) {
        multipleSelected.add(element.checkboxText);
      }
    }
    multipleSelectedEvent = [];

    if (checkboxListEvent[0].isCheck) {
      multipleSelectedEvent.add(eventsListGetIndex[0]);
    } else {
      for (int a = 1; a < checkboxListEvent.length; a++) {
        if (checkboxListEvent[a].isCheck) {
          multipleSelectedEvent.add(eventsListGetIndex[a]);
        }
      }
    }

    fetchEventsAccordingToDate(navigationKey.currentState!.context,
        startTime: DateTime(selectedMonth.year, selectedMonth.month, 1),
        endTime: DateTime(selectedMonth.year, selectedMonth.month + 1, 0),
        multipleSelectedCon: multipleSelected,
        filterApplyEvent: multipleSelectedEvent);
  }

  // updateEventsOnCheckBox() {
  //   filteredEvents = [];
  //   if (multipleSelected.isNotEmpty && multipleSelected.length <= 2) {
  //     filteredEvents = events.where((object) {
  //       return multipleSelected.contains(object.productName);
  //     }).toList();
  //     dayController = EventController();
  //     dayController.addAll(getCalendarEventDataList(filteredEvents));

  //   } else if (multipleSelected.isEmpty || multipleSelected.contains(checkboxList.first.checkboxText)) {
  //     dayController = EventController();
  //     dayController.addAll(getCalendarEventDataList(events));
  //   }
  //   checkboxSelectedText = multipleSelected.isNotEmpty
  //       ? multipleSelected.length == 3
  //           ? checkboxList.first.checkboxText
  //           : multipleSelected.toString().replaceAll("[", "").replaceAll("]", "")
  //       : checkboxList.first.checkboxText;
  //       notifyListeners();
  // }

  clearAllFields() {
    for (CheckboxModel element in checkboxList) {
      element.isCheck = false;
    }

    for (CheckboxModel element in checkboxListEvent) {
      element.isCheck = false;
    }
    checkboxSelectedText = checkboxList.first.checkboxText;
    notifyListeners();
  }

  clearAllFieldsInit() {
    for (CheckboxModel element in checkboxList) {
      element.isCheck = false;
    }

    for (CheckboxModel element in checkboxListEvent) {
      element.isCheck = false;
    }
    checkboxSelectedText = checkboxList.first.checkboxText;

  }

  setStartEnd() {
    startDate = onPageChangeDate != null
        ? DateTime(DateTime.parse(onPageChangeDate).year, DateTime.parse(onPageChangeDate).month, 01, 18, 30, 0).toIso8601String()
        : DateTime(DateTime.now().year, DateTime.now().month, 01, 18, 30, 0).toIso8601String();
    startDate = "${startDate}Z";
    endDate = onPageChangeDate != null
        ? DateTime(DateTime.parse(onPageChangeDate).year, DateTime.parse(onPageChangeDate).month, getLastDayOfMonth(DateTime.parse(onPageChangeDate).year, DateTime.parse(onPageChangeDate).month), 18,
                30, 0)
            .toIso8601String()
        : DateTime(DateTime.now().year, DateTime.now().month, getLastDayOfMonth(DateTime.now().year, DateTime.now().month), 18, 30, 0).toIso8601String();
    endDate = "${endDate}Z";
    notifyListeners();
  }

  int getLastDayOfMonth(year, month) {
    // Add one month to the current date and subtract one day to get the last day of the selected month.
    DateTime lastDayOfMonth = DateTime(year, month + 1, 0);
    return lastDayOfMonth.day;
  }

  Future fetchEventsInDay(context, {bool isCalendar = true, bool isFromInitState = false}) async {
    print(startDate);
    Map<String, dynamic> payload = {
      "emailId": Provider.of<AuthApiProvider>(context, listen: false).profileData!.data!.emailId!,
      "fromDate": startDate ?? "${DateTime(DateTime.parse(onPageChangeDate).year, DateTime.parse(onPageChangeDate).month, 01, 18, 30, 0).toIso8601String()}Z",
      // "pageNo": 1000,
      // "pageSize": null,
      // "products": checkboxSelectedText,
      "status": "all",
      "toDate": endDate ??
          "${DateTime(DateTime.parse(onPageChangeDate).year, DateTime.parse(onPageChangeDate).month, getLastDayOfMonth(DateTime.parse(onPageChangeDate).year, DateTime.parse(onPageChangeDate).month), 18, 30, 0).toIso8601String()}Z",
    };
    try {
      final response = await apiRepository.dayCalender(payload);
      if (response.events!.isNotEmpty) {
        events = [];
        dayController = EventController();
        events = response.events!;
        dayController.addAll(getCalendarEventDataList(events));
        if (!isFromInitState) {
          notifyListeners();
        }
      }
    } on DioException catch (e) {
      CustomToast.showErrorToast(msg: e.toString());
      print("DioException $e");
    } catch (e, st) {
      print(st);
      CustomToast.showErrorToast(msg: e.toString());
    }
  }

  List<CalendarEventData> getCalendarEventDataList(List<Event> calendarEvents) {
    return calendarEvents
        .map((e) => CalendarEventData(
              id: e.id,
              name: e.name,
              date: e.startTime,
              startTime: e.startTime,
              endTime: e.endTime,
              description: e.description,
              status: e.status,
              image: e.image,
              event: e,
            ))
        .toList();
  }

  callNotify() {
    notifyListeners();
  }

  // savita data here

  DateTime selectedMonth = DateTime.now();
  DateTime selectedDay = DateTime.now();

  bool isWeekView = false;

  String selectedItem = '';

  void changeMonth(int offset) {
    selectedMonth = DateTime(
      selectedMonth.year,
      selectedMonth.month + offset,
      selectedMonth.day,
    );
    selectedDay = selectedMonth;
    notifyListeners();

    fetchEventsAccordingToDate(navigationKey.currentState!.context,
        startTime: DateTime(selectedMonth.year, selectedMonth.month, 1),
        endTime: DateTime(selectedMonth.year, selectedMonth.month + 1, 0),
        multipleSelectedCon: [],
        filterApplyEvent: []);
  }

  void clearOldSelected() {
    selectedMonth = DateTime(
      DateTime.now().year,
      DateTime.now().month,
      DateTime.now().day,
    );
    selectedDay = selectedMonth;
//    notifyListeners();
  }

  void changeDay(int offset) {
    selectedDay = DateTime(
      selectedDay.year,
      selectedDay.month,
      selectedDay.day + offset,
    );
    selectedMonth = selectedDay;
    notifyListeners();

    print("selectedDay.day ${selectedDay.day}");

    fetchEventsAccordingToDate(navigationKey.currentState!.context,
        startTime:
            DateTime(selectedDay.year, selectedDay.month, selectedDay.day),
        endTime: DateTime(selectedDay.year, selectedDay.month, selectedDay.day),
        multipleSelectedCon: [],
        filterApplyEvent: []);
  }

  void isCalendarViewChanges(bool offset) {
    isWeekView = offset;
    notifyListeners();
  }

  void isCalendarViewChangesInit(bool offset) {
    isWeekView = offset;
   // notifyListeners();
  }

  String formatMonthYear(DateTime dateTime) {
    print("dshfc ${dateTime.toString()}");
    return DateFormat('MMMM yyyy').format(dateTime);
  }

  // call api

  Future fetchEventsAccordingToDate(context,
      {DateTime? startTime,
      DateTime? endTime,
      List? multipleSelectedCon,
      List? filterApplyEvent}) async {
    print(startDate);

    isLoadingDataCale = true;

    notifyListeners();
    Map<String, dynamic> payload = {
      "emailId": Provider.of<AuthApiProvider>(context, listen: false)
          .profileData!
          .data!
          .emailId!,
      "fromDate": "${startTime!.toIso8601String()}Z" ??
          "${DateTime(DateTime.parse(onPageChangeDate).year, DateTime.parse(onPageChangeDate).month, 01, 18, 30, 0).toIso8601String()}Z",
      // "pageNo": 1000,
      // "pageSize": null,
      "products": multipleSelectedCon != null && multipleSelectedCon.isNotEmpty
          ? multipleSelectedCon!.join(",")
          : "O-Mail,O-Net,O-Connect",
      "status": filterApplyEvent != null && filterApplyEvent.isNotEmpty
          ? filterApplyEvent!.join(",")
          : "all",
      "toDate": "${endTime!.toIso8601String()}Z" ??
          "${DateTime(DateTime.parse(onPageChangeDate).year, DateTime.parse(onPageChangeDate).month, getLastDayOfMonth(DateTime.parse(onPageChangeDate).year, DateTime.parse(onPageChangeDate).month), 18, 30, 0).toIso8601String()}Z",
    };


    try {
      final response = await apiRepository.dayCalender(payload);

      isLoadingDataCale = false;
      if (response.events !=null && response.events!.isNotEmpty) {
        noDataFound = false;
        calenderMonthEvent = response;
        notifyListeners();
      } else {
        noDataFound = true;
        calenderMonthEvent = null;
      }

      print("response.events ${response.events?.length}");
    } on DioException catch (e) {
      noDataFound = true;
      CustomToast.showErrorToast(msg: e.toString());
      print("DioException $e");
    } catch (e, st) {
      noDataFound = true;
      print(st);
      CustomToast.showErrorToast(msg: e.toString());
    } finally {
      isLoadingDataCale = false;
      notifyListeners();
    }
  }
}
