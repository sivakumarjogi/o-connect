import 'dart:async';

import 'package:audio_session/audio_session.dart';
import 'package:emoji_picker_flutter/src/emoji.dart';
import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart';
import 'package:o_connect/core/enum/view_state_enum.dart';
import 'package:o_connect/core/models/response_models/get_all_sounds_response_model/get_all_sounds_response_model.dart';
import 'package:o_connect/core/models/response_models/get_virtualBg_response_model/get_virtualBg_response_model.dart';

import 'package:o_connect/core/providers/base_provider.dart';
import 'package:o_connect/ui/views/webinar_details/webinar_details_provider/webinar_provider.dart';
import 'package:o_connect/core/repository/virtualBg_repository/get_virtualBg_api_repo.dart';
import 'package:o_connect/ui/utils/base_urls.dart';
import '../service/api_helper/api_helper.dart';
import '../repository/get_all_sounds_repository/get_all_sounds_api_repo.dart';

class CommonProvider extends BaseProvider {
  WebinarProvider webinarProvider = WebinarProvider();
  int selectedVirtualBg = 0;
  int selectedThemesIndex = 0;
  int resoundIndex = 0;

  bool isRecording = false;
  bool isTimer = false;
  bool isDarkTheme = false;
  bool miniAudioPlayer = false;
  bool recordingScreen = false;
  bool tickerMiniView = false;
  bool miniAudioPlayerBottom = false;
  bool emojiView = false;
  String tickerText = "hello";
  String tickerDirection = "Left";
  AudioPlayer player = AudioPlayer();
  TextEditingController emojiController = TextEditingController();
  int selectedSoundIndex = -1;

  bool showPushLink = false;
  bool showCallToActionPopUp = false;
  String? pushLinkButtonText;
  String? pushLinkURL;
  ShowFlagsOnDashBoard? selectedFlag;

  ShowFlasOnDashBoardAtTop? showFlagsOnDashBoardAtTop;
  ShowFlagOnTopHeader? showFlagOnTopHeader;

  GetAllSoundsAPI getAllSoundsAPI = GetAllSoundsAPI(ApiHelper().oConnectDio, baseUrl: BaseUrls.bgmBaseUrl);
  List<GetAllSoundsResponseModelDatum>? getAllSoundsList;
  late List<String> getAllSoundsIconsList = ['resound1','resound2','resound3','resound4','resound5','resound6','resound7','resound8','resound9','resound10',];
  late List<String> getAllBgmIconsList = ['achievements','celebrations','classical','condolence','custom',
    'general','inspirational','nature','productivity','relaxing',
    'upbeat',];

  List<String> videoStack = [];
  List<GetAllSoundsResponseModel>? dataModel;
  List<GetVirtualBgModelDatum> virtualBgModel = [];
  int selectedSubIndex = -1;

  // GetVirtualBgAPI getVirtualBgAPI = GetVirtualBgAPI(ApiHelper().dio);
  GetVirtualBgAPI getVirtualBgAPI = GetVirtualBgAPI(ApiHelper().oesDio);

  // List<GetVirtualBgModelDatum>? getVirtualBgList;

  // List<GetVirtualBgModel>? virtualBgDataModel;

  clearData() {
    isTimer = false;
    showFlagsOnDashBoardAtTop = null;
    notifyListeners();
  }

  updateResoundIndex(int index) {
    resoundIndex = index;
    selectedSubIndex = -1;
    notifyListeners();
  }

  stopRecording() {
    recordingScreen = false;
    showFlagsOnDashBoardAtTop = null;
    notifyListeners();
  }

  updateRecording() {
    isRecording = !isRecording;
    notifyListeners();
  }

  updateTimer() {
    isTimer = true;
    notifyListeners();
  }

  updateSelectedVirtualBgIndex(int index) {
    selectedVirtualBg = index;
    notifyListeners();
  }

  updateSelectedThemeIndex(int index) {
    selectedThemesIndex = index;
    notifyListeners();
  }

  /// Get Virtual
  Future<void> getVirtualBg() async {
    var urls;
    try {
      var response = await getVirtualBgAPI.getVirtualBg();
      print("virtualBG response $response");

      virtualBgModel = response.data;
      print("virtualBgModel $virtualBgModel");

      notifyListeners();
      // }
    } catch (e) {
      debugPrint("$e");
    }
  }

  Future<void> getResound() async {
    GetAllSoundsResponseModel? getAllSoundsResponseModel;
    String urls;
    try {
      var response = await getAllSoundsAPI.getAllSounds();
      if (response.status == true) {
        getAllSoundsResponseModel = response;
        getAllSoundsList = response.data;
        urls = getAllSoundsList![0].data[0].url;
        print("urls here ====> ${getAllSoundsList![0].data[0].url}");
        notifyListeners();
      }
    } catch (e) {
      debugPrint("API Error");
    }
  }

  updateCallToActionPopUp() {
    showFlagOnTopHeader = ShowFlagOnTopHeader.callToAction;
    notifyListeners();
  }

  // void emojiAnimation(Emoji emoji, BuildContext context) {
  //   debugPrint("Siva Kumar Emojis Start");
  //   Navigator.pop(context);
  //   emojiController.text = emoji.emoji;
  //   emojiView = true;
  //   selectedFlag = ShowFlagsOnDashBoard.emoji;
  //   notifyListeners();
  //   Future.delayed(const Duration(seconds: 1), () {
  //     emojiController.text = '';
  //   });
  //   notifyListeners();
  // }
  void emojiAnimation(Emoji emoji, BuildContext context) {
    debugPrint("Siva Kumar Emojis Start");
    Navigator.pop(context);
    emojiController.text = emoji.emoji;
    emojiView = !emojiView;
    notifyListeners();
    selectedFlag = ShowFlagsOnDashBoard.emoji;
    notifyListeners();
    Future.delayed(const Duration(seconds: 1), () {
      emojiController.text = '';
    });
    notifyListeners();
  }

  var xAli = Alignment.topLeft;
  var yAli = Alignment.bottomLeft;

  void emojiAnimationEnd() {
    emojiView = false;
    selectedFlag = null;
    xAli = Alignment.topLeft;
    yAli = Alignment.bottomLeft;
    notifyListeners();
  }

  emojiAnimationTap() {
    emojiView ? xAli : yAli;
    // emojiView = !emojiView;
    notifyListeners();
  }

  updateSelectedSound(GetAllSoundsResponseModelDatum dataObj, int index) {
    selectedSubIndex = index;
    notifyListeners();
  }

  void playerVisible(String className, BuildContext context) {
    if (className == "Resound") {
      tickerMiniView = false;
      miniAudioPlayerBottom = true;
      recordingScreen = false;
      miniAudioPlayer = false;

      selectedFlag = ShowFlagsOnDashBoard.resound;
      if (showFlagsOnDashBoardAtTop == ShowFlasOnDashBoardAtTop.bgm) {
        showFlagsOnDashBoardAtTop = null;
      }
      notifyListeners();
    } else if (className == "BGM") {
      miniAudioPlayer = true;
      recordingScreen = false;
      miniAudioPlayerBottom = false;
      showFlagsOnDashBoardAtTop = ShowFlasOnDashBoardAtTop.bgm;
      selectedFlag = null;
      notifyListeners();
    } else if (className == "Record") {
      recordingScreen = true;
      miniAudioPlayerBottom = false;
      selectedFlag = null;
      miniAudioPlayer = false;
      showFlagsOnDashBoardAtTop = ShowFlasOnDashBoardAtTop.recordScreen;
      miniAudioPlayer = false;
      notifyListeners();
    }
  }

  showPushLinkMethod() {
    videoStack.add("link");
    showPushLink = true;
    /*  pushLinkButtonText = pushLinkButtonController.text;
    pushLinkURL = pushLinkController.text;*/
    notifyListeners();
  }

  void showCallToActionPopUpAtDashBoard() {
    videoStack.add("call");
    showCallToActionPopUp = true;
    notifyListeners();
  }

  removeIndexLinks(String s) {
    if (s == "call") {
      videoStack.remove("call");
      showCallToActionPopUp = false;
      print(videoStack.length);
      notifyListeners();
    } else if (s == "link") {
      videoStack.remove("link");
      showPushLink = true;
      print(videoStack.length);
      notifyListeners();
    }
  }

  Future miniPlayerController() async {
    debugPrint("hello audio siva kumar ");
    miniAudioPlayer = false;
    miniAudioPlayerBottom = false;
    selectedFlag = null;
    player.stop();
    showFlagsOnDashBoardAtTop = null;
    notifyListeners();
  }

  void removeTicker() {
    tickerMiniView = false;
    miniAudioPlayerBottom = false;
    emojiView = false;
    selectedFlag = null;
    notifyListeners();
  }

  void tickerStop() {
    tickerText = "";
    selectedFlag = null;
    tickerMiniView = false;
    notifyListeners();
  }

  void tickerPublish(tickerTextView, tickerItemType, BuildContext context) {
    print("siva kumar $tickerTextView");
    miniAudioPlayerBottom = true;
    tickerMiniView = true;
    tickerDirection = tickerItemType;
    tickerText = (tickerTextView == "" || tickerTextView == null) ? "Test Application" : tickerTextView;
    tickerText.replaceAll("<p>", "").replaceAll("<", "").replaceAll("/p>", "");
    selectedFlag = ShowFlagsOnDashBoard.ticker;
    notifyListeners();
    Navigator.pop(context);
  }

  void showTicker() {
    tickerMiniView = true;
    selectedFlag = ShowFlagsOnDashBoard.ticker;
    notifyListeners();
  }

  void hideTicker() {
    tickerMiniView = false;
    selectedFlag = null;
    notifyListeners();
  }

  void switchAppThemes(bool val) {
    isDarkTheme = !isDarkTheme;
  }
}
