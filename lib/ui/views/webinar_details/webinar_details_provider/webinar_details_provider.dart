import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:intl/intl.dart';
import 'package:o_connect/core/models/response_models/profile_response_model.dart/profile_response_model.dart';
import 'package:o_connect/core/service_locator.dart';
import 'package:o_connect/core/user_cache_service.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:syncfusion_flutter_datepicker/datepicker.dart';

import '../../../utils/constant_strings.dart';

class WebinarDetailsProvider extends ChangeNotifier {
  int page = 0;
  final int limit = 10;
  int selectedRadioValue = 1;
  String startEndDate = DateFormat("yyyy-MM-dd")
      .format(DateTime.now().subtract(const Duration(days: 365)))
      .toString();
  // DateFormat("yyyy-MM-dd").format(DateTime.now())
  TextEditingController dateController = TextEditingController();
  String startEndDateStatics = DateFormat("yyyy-MM-dd").format(DateTime.now()).toString();
  bool isCreated = true;
  bool hasNextPage = true;
  bool isFirstLoadRunning = false;
  bool isLoadMoreRunning = false;
  int initialIndex = 0;
  PickerDateRange? calendarDateRange;
  bool isShowDateRangePicker = false;
  bool isShowDateRangePickerInStatistics = false;
  ScrollController controller = ScrollController();
  late TooltipBehavior tooltipBehavior;
  String selectedValue = ConstantsStrings.upcomingWebinars;
  String webinarDropDownMenuSelectedItem = ConstantsStrings.upcomingWebinars;
  final TextEditingController webinarStatisticsCalender = TextEditingController();
  bool searchField = false;

  Future<GetProfileResponsData?> getHeaderInfoDetails() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    print("Profile data is called");
    try {
      final String? userDataString = preferences.getString("saveProfileData");
      print("Profile data is called ${preferences.getString("saveProfileData").toString()}");
      GetProfileResponsData? userData = GetProfileResponsData.fromJson(jsonDecode(userDataString!));

      return userData;
    } catch (e, st) {
      print("the model errors are the ${e.toString()}, $st");
    }
    return null;
  }

  void updateSelectedWebinarMenu(String selectedValue) {
    webinarDropDownMenuSelectedItem = selectedValue;
    notifyListeners();
  }

  void searchBoxEnableDisable() {
    searchField = !searchField;
    notifyListeners();
  }

  void updateInitialIndex(int value) {
    initialIndex = value;
    notifyListeners();
  }

  updateRadioButtonIndex(int index) {
    selectedRadioValue == index;
    notifyListeners();
  }

  updateRadioButtonValue(bool isCreated) {
    isCreated == isCreated;
    notifyListeners();
  }

  void setDates() {
    eData = DateFormat("MMM dd yyyy").format(DateTime.now().subtract(const Duration(days: 364)));
    sData = DateFormat("MMM dd yyyy").format(DateTime.now());
    startEndDate = "$eData - $sData";

    webinarStatisticsCalender.text = startEndDate;
    print(startEndDate.toString());
    startEndDateStatics = "$eData - $sData";
    notifyListeners();
  }

  updateWebinars(String updatedValue) {
    selectedValue = updatedValue;
    notifyListeners();
  }

  updateDateRangePickerValue() {
    isShowDateRangePicker = !isShowDateRangePicker;
    notifyListeners();
  }

  upDateInStatisticsCalenderView() {
    isShowDateRangePickerInStatistics = !isShowDateRangePickerInStatistics;
    notifyListeners();
  }

  upDateInStatisticsCalenderViewReset() {
    isShowDateRangePickerInStatistics = false;
    notifyListeners();
  }

  String updateStartAndEndDates({DateTime? startedDate, DateTime? endedDate}) {
    if (startedDate != null && endedDate != null) {
      String startDate = DateFormat('dd MMM yyyy').format(startedDate);
      String endDate = DateFormat('dd MMM yyyy').format(endedDate);
      print(endDate);
      startEndDate = "$startDate - ${endDate ?? startDate}";
    }
    notifyListeners();
    return startEndDate;
  }

  var sData;
  var eData;

  updateStartAndEndDatesStastics({DateTime? startedDate, DateTime? endedDate}) {
    if (startedDate != null && endedDate != null) {
      sData = DateFormat("MMM dd yyyy").format(startedDate);
      eData = DateFormat("MMM dd yyyy").format(endedDate);

      startEndDateStatics = "$sData - ${eData ?? sData}";
      print(startEndDateStatics);
      webinarStatisticsCalender.text = startEndDateStatics;
    }
    notifyListeners();
    return startEndDateStatics;
  }

  void upcomingLoadMore() async {
    if (hasNextPage == true && isFirstLoadRunning == false && isLoadMoreRunning == false && controller.position.extentAfter < 300) {
      isLoadMoreRunning = true; // Display a progress indicator at the bottom
      page += 1;
      print(page); // Increase _page by 1
      try {
        // List<UpcomingWebinars> fetchedList = addedUpcomingWebinarsList;
        // if (fetchedList.isNotEmpty && page == 1) {
        //   totalUpcomingList.addAll(fetchedList);
        // } else {
        //   hasNextPage = false;
        // }
      } catch (err) {
        if (kDebugMode) {
          print('Something went wrong!');
        }
      }
      isLoadMoreRunning = false;
    }
    notifyListeners();
  }

  void upcomingFirstLoad() async {
    isFirstLoadRunning = true;
    try {
      // totalUpcomingList = upcomingWebinarsList;
    } catch (err) {
      if (kDebugMode) {
        print('Something went wrong');
      }
    }
    isFirstLoadRunning = false;
  }
}
