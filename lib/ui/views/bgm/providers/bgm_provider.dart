import 'dart:convert';
import 'dart:developer';
import 'dart:io';
import 'package:dio/dio.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart';
import 'package:o_connect/core/models/response_models/get_all_bgms_response_model/get_bgm_response_model.dart';
import 'package:o_connect/core/providers/common_provider.dart';
import 'package:o_connect/core/repository/webinar_dashboard_repository/theme_repository.dart';
import 'package:o_connect/core/service/api_helper/api_helper.dart';
import 'package:o_connect/ui/utils/base_urls.dart';
import 'package:o_connect/ui/utils/custom_toast_helper/custom_toast.dart';
import 'package:o_connect/ui/views/bgm/model/custom_mp3_files_model.dart';
import 'package:o_connect/ui/views/meeting/data/meeting_room_repository.dart';
import 'package:o_connect/ui/views/meeting/model/meeting_actions.dart';
import 'package:o_connect/ui/views/meeting/utils/file_upload_mixin.dart';
import 'package:o_connect/ui/views/meeting/utils/meeting_utils_mixin.dart';
import 'package:provider/provider.dart';
import '../../../../core/repository/library_repository/library_repo.dart';

class BgmProvider extends ChangeNotifier with MeetingUtilsMixin, WebinarFileUploadMixin {
  AudioPlayer audioPlayer = AudioPlayer();
  String currentSoundUrl = '';
  String currentSoundName = '';
  double currentVolume = 0.3;
  int selectedBgmIndex = -1;
  int bgmIndex = 0;
  int selectedBGMIndex = -1;
  String? currentBgmUrl;

  MeetingRoomRepository meetingRepo = MeetingRoomRepository(ApiHelper().oConnectDio, baseUrl: BaseUrls.libraryBaseUrl);

  LibraryRepository libraryRepo = LibraryRepository(ApiHelper().oConnectDio, baseUrl: BaseUrls.libraryBaseUrl);

  List<GetBgmResponseModelDatum> getAllBgmListData = [];
  List<CustomMp3FilesModel> uploadedMp3Files = [];

  AudioPlayer localPlayer = AudioPlayer();
  bool isBgmLoading = false;
  bool customFileUploadLoading = false;
  final ThemeRepository _bgmRepository = ThemeRepository(ApiHelper().oesDio, baseUrl: BaseUrls.bgmBaseUrl);

  updateBGmIndex(int index) {
    bgmIndex = index;
    selectedBgmIndex = -1;
    notifyListeners();
  }

  // updateSelectedBgmIndex(/* GetBgmResponseModelDatum dataOb, */ int index) {
  //   selectedBgmIndex = index;
  //   notifyListeners();
  // }

  Future<void> publishAudio({String? urlTrack, bool isPlaying = false}) async {
    print("urltracker ===> $urlTrack && $currentBgmUrl");
    String? selectedUrl;

    if (audioPlayer.playing) {
      CustomToast.showErrorToast(msg: "Please close existing BGM");
      return;
    }

    selectedUrl = urlTrack;
    localPlayer.playbackEventStream.listen((event) {
      print("the listening event is the $event  ${event.processingState}");

      if (event.processingState == ProcessingState.completed) {
        currentBgmUrl = null;
        notifyListeners();
      }
    }, onError: (Object e, StackTrace st) {
      if (e is PlayerException) {
        print('Error code: ${e.code}');
        print('Error message: ${e.message}');
      } else {
        print('An error occurred: $e');
      }
    });
    if (currentBgmUrl == urlTrack) {
      print("the playing playing  ${localPlayer.playerState.playing}");
      if (localPlayer.playerState.playing) {
        localPlayer.stop();
        currentBgmUrl = null;
      } else {
        localPlayer.play();
        print("it played here");
        currentBgmUrl = null;
      }
      notifyListeners();
      return;
    }

    print("the values $urlTrack && $selectedUrl ${selectedUrl != urlTrack}");
    if (selectedUrl == null || selectedUrl.isEmpty || selectedUrl != currentBgmUrl) {
      print("it reched");
      localPlayer.dispose();
      localPlayer = AudioPlayer();
      currentBgmUrl = urlTrack;
      notifyListeners();
      await localPlayer.setUrl(selectedUrl!);
      await localPlayer.play();
    }

    // selectedBGMIndex = -1;
    // Future.delayed(const Duration(seconds: 1), () {

    //   // selectedSubIndex = -1;

    // });

    notifyListeners();
  }

  Future<void> uploadmp3Files() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(type: FileType.custom, allowedExtensions: ["mp3"]);
    if (result != null && result.files.isNotEmpty) {
      customFileUploadLoading = true;
      notifyListeners();
      File selectedAudioFile = File(result.files.single.path!);
      print("the ficked file is the $selectedAudioFile");
      try {
        await uploadFile(file: selectedAudioFile, meetingId: meeting.id.toString(), purpose: "BGM", userId: myHubInfo.id.toString(), category: "Custom");

        CustomToast.showSuccessToast(msg: "File uploaded Successfully");
        await fetchBGMUploadedMp3Files();
      } on DioException catch (e) {
        print("the dio exception in the upload BGM ${e.error} && ${e.response}");
      } catch (e, st) {
        print("the  exception is the upload BGM ${e.toString()} && $st");
      }
      customFileUploadLoading = false;
      notifyListeners();
    }
  }

  Future<void> fetchBGMUploadedMp3Files() async {
    try {
      uploadedMp3Files = await meetingRepo.fetchMp3Files(myHubInfo.id.toString(), "BGM", "Custom");
    } on DioException catch (e, st) {
      print("error while Dio fetching uploaded mp3 files ${e.error} && ${e.response} && $st");
    } catch (e, st) {
      print("error while fetching uploaded mp3 files ${e.toString()} && $st");
    }
  }

  Future<void> deleteUploadedMp3File(String itemId) async {
    try {

      final payload = {
        "FileIds": [itemId]
      };
      final res = await libraryRepo.deleteVideoShareVideoFile(payload);

      if (res.statusCode == 200) {
        await fetchBGMUploadedMp3Files();
        CustomToast.showSuccessToast(msg: "File Deleted Successfully");
      }
    } on DioException catch (e, st) {
      print("Error Dio while delete BGM Mp3 File $st ${e.error} ${e.response}");
    } catch (e) {
      print("Error  while delete BGM Mp3 File ${e.toString()}");
    }
    notifyListeners();
  }

  Future<void> getAllBGMs() async {
    isBgmLoading = true;
    print("bgm called");
    try {
      isBgmLoading = true;
      final response = await _bgmRepository.getAllBGMs();
      if (response.status) {
        print("Response Get All BGMs ====>>  ${response.toJson()}");
        getAllBgmListData = response.data;
        notifyListeners();
      }
      isBgmLoading = false;
    } catch (e) {
      isBgmLoading = false;
      debugPrint("API Error $e");
    }
  }

  void setupListeners() {
    hubSocket.socket?.on('panalResponse', (res) {
      final parsed = jsonDecode(res);
      final data = parsed['data'];
      final command = data['command'];
      final value = data['value'];

      if (command == 'AccessRestriction' && value == 'bgm' && data['ou'] == userData.id) {
        if (data['feature']['action'] == 'opened') {
          // Host has opened the bgm window
          context.read<CommonProvider>().playerVisible('BGM', context);
        } else if (data['feature']['action'] == 'removed') {
          // Host has closed the bgm window
          context.read<CommonProvider>().miniPlayerController();
        }
      }
    });

    hubSocket.socket?.on('entResponse', (res) {
      final parsed = jsonDecode(res);
      final data = parsed['data'];
      final command = data['command'];
      final value = data['value'];

      if (command == 'bgm') {
        if (data['closeAll'] == true) {
          stopSound();
        } else {
          final url = value['url'];
          if (value['isPaused'] == false && value['isSelected'] == true) {
            _playSound(url, parsed['from'], double.tryParse(value['volume'].toString()));
          } else if (value['isPaused'] == true && value['isSelected'] == false) {
            _pauseSound();
          }
        }
      }
    });
  }

  void emitPlayEvent(String name, String url) {
    hubSocket.socket?.emitWithAck(
      'onEntCommand',
      jsonEncode({
        "uid": "ALL",
        "data": {
          "command": "bgm",
          "value": {
            "name": name,
            "url": url,
            "isPlaying": false,
            "isPaused": false,
            "isSelected": true,
            "isButton": false,
            "volume": currentVolume,
          },
          "ou": userData.id
        }
      }),
    );
  }

  void emitPauseEvent(String name, String url) {
    hubSocket.socket?.emitWithAck(
      'onEntCommand',
      jsonEncode({
        "uid": "ALL",
        "data": {
          "command": "bgm",
          "value": {
            "name": name,
            "url": url,
            "isPlaying": false,
            "isPaused": true,
            "isSelected": false,
            "isButton": false,
            "volume": currentVolume,
          },
          "ou": userData.id
        }
      }),
    );
  }

  void emitPlayCompletedEvent() {
    hubSocket.socket?.emitWithAck(
      'onEntCommand',
      jsonEncode({
        "uid": "ALL",
        "data": {
          "command": "bgm",
          "value": {"isPaused": true, "isSelected": false, "isbutton": false},
          "closeAll": true
        }
      }),
    );
  }

  /// Should be called whenever the bgm window is applied
  void applyBackgroundMusic({
    required String name,
    required String url,
    double volume = 0.3,
  }) async {
    try {
      localPlayer.stop();
      localPlayer = AudioPlayer();
    } finally {
      currentBgmUrl = null;
      notifyListeners();
    }

    addTopActionToDashboard(MeetingAction.bgm);

    currentVolume = volume;
    final response = await gloablSetRepo.setGlobalAccess({
      "action": "open",
      "feature": "bgm",
      "meetingId": meeting.id,
      "role": 1,
      "type": "sounds",
      "userId": userData.id,
      "selectedAudio": {
        "name": name,
        "url": url,
        "isPlaying": false,
      }
    });

    if (response.status == true && response.data?.permission == true) {
      hubSocket.socket?.emitWithAck(
        'onPanalCommand',
        jsonEncode({
          "uid": "ALL",
          "data": {
            "command": "AccessRestriction",
            "feature": {"action": "opened"},
            "value": "bgm",
            "ou": userData.id,
            "on": userData.userName,
            "soundType": "bgm"
          }
        }),
      );

      hubSocket.socket?.emitWithAck(
        'onEntCommand',
        jsonEncode({
          "uid": "ALL",
          "data": {
            "command": "bgm",
            "value": {
              "name": name,
              "url": url,
              "isPlaying": false,
              "isPaused": false,
              "isSelected": true,
              "isButton": false,
              "volume": volume,
            },
            "ou": userData.id
          }
        }),
      );
    } else if (response.data?.permission == false && response.data?.reason != null) {
      showWarningPopUpDialog(description: "You are already accessing Background Music.");
      // CustomToast.showErrorToast(msg: response.data?.reason ?? 'Something went wrong');
    }
  }

  /// Should be called whenever the host wants to stop bgm
  Future closeBackgroundMusic() async {
    removeTopAction(MeetingAction.bgm);

    final response = await gloablSetRepo.setGlobalAccess(
      {
        "action": "close",
        "feature": "bgm",
        "meetingId": meeting.id,
        "role": 1,
        "type": "sounds",
        "userId": userData.id,
      },
    );

    if (response.status == true && response.data?.permission == true) {
      hubSocket.socket?.emitWithAck(
        'onPanalCommand',
        jsonEncode({
          "uid": "ALL",
          "data": {
            "command": "AccessRestriction",
            "feature": {
              "action": "removed",
              "user": {
                "role": myHubInfo.role,
                "feature": "bgm",
                "userId": userData.id,
                "isAccessing": true,
              }
            },
            "value": "bgm",
            "ou": userData.id,
          }
        }),
      );

      hubSocket.socket?.emitWithAck(
        'onEntCommand',
        jsonEncode({
          "uid": "ALL",
          "data": {
            "command": "bgm",
            "value": {"isPaused": true, "isSelected": false, "isbutton": false},
            "closeAll": true
          }
        }),
      );
    }
  }

  void emitVolumeEvent(double volume) {
    currentVolume = volume;
    hubSocket.socket?.emitWithAck(
      'onEntCommand',
      jsonEncode({
        "uid": "ALL",
        "data": {
          "command": "bgm",
          "value": {
            "name": currentSoundName,
            "url": currentSoundUrl,
            "isPlaying": false,
            "isPaused": false,
            "isSelected": true,
            "isButton": false,
            "volume": volume.toString(),
          },
          "ou": userData.id
        }
      }),
    );
  }

  void _playSound(String url, String from, [double? volume]) async {
    try {
      try {
        if (audioPlayer.playing) {
          print("audio player is playing");
          if (url != currentSoundUrl) {
            await audioPlayer.dispose();
            audioPlayer = AudioPlayer();
          } else if (volume != null && url == currentSoundUrl) {
            await audioPlayer.setVolume(volume);
            return;
          }
        }
      } catch (e, st) {
        log(e.toString(), error: e, stackTrace: st);
      }

      currentSoundUrl = url;
      notifyListeners();
      print("trying to play audio");
      await audioPlayer.setUrl(url);
      if (volume != null) await audioPlayer.setVolume(volume);
      await audioPlayer.play();
      print("completed");
    } catch (e, st) {
      debugPrint("Unable to play: $e $st");
    }
  }

  void _pauseSound() async {
    try {
      if (audioPlayer.playing) {
        await audioPlayer.pause();
      }
    } catch (e, st) {
      debugPrint("Unable to play: $e $st");
    }
  }

  void stopSound() async {
    try {
      currentSoundUrl = '';
      notifyListeners();
      await audioPlayer.stop();
    } catch (e, st) {
      debugPrint("Unable to play: $e $st");
    }
  }

  void togglePlay(String name, String url) async {
    currentSoundName = name;
    if (audioPlayer.playing && currentSoundUrl == url) {
      emitPauseEvent(name, url);
    } else {
      emitPlayEvent(name, url);
    }
  }

  Future<void> resetState() async {
    try {
      currentSoundUrl = '';
      currentSoundName = '';
      await audioPlayer.dispose();
    } finally {
      audioPlayer = AudioPlayer();
      localPlayer = AudioPlayer();
    }
  }
}
