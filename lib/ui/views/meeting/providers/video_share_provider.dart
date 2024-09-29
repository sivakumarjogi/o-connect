import 'dart:convert';
import 'dart:developer';
import 'dart:io';

import 'package:chewie/chewie.dart';
import 'package:dio/dio.dart';
import 'package:file_picker/file_picker.dart';
import 'package:fl_pip/fl_pip.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:mime/mime.dart';
import 'package:o_connect/core/file_encryption_helper.dart';
import 'package:o_connect/core/models/dummy_models/dummy_model.dart';
import 'package:o_connect/core/models/library_model/presentation_upload_files_model.dart';
import 'package:o_connect/core/providers/app_global_state_provider.dart';
import 'package:o_connect/core/repository/file_upload_repository/file_upload_repository.dart';
import 'package:o_connect/core/repository/library_repository/library_repo.dart';
import 'package:o_connect/core/service/api_helper/api_helper.dart';
import 'package:o_connect/ui/utils/base_urls.dart';
import 'package:o_connect/ui/utils/custom_toast_helper/custom_toast.dart';
import 'package:o_connect/ui/views/meeting/model/meeting_global_access_status_response/local_video.dart';
import 'package:o_connect/ui/views/meeting/model/model.dart';
import 'package:o_connect/ui/views/meeting/model/user_role.dart';
import 'package:o_connect/ui/views/meeting/providers/participants_provider.dart';
import 'package:o_connect/ui/views/meeting/utils/meeting_utils_mixin.dart';
import 'package:o_connect/ui/views/meeting/utils/string_extension.dart';
import 'package:o_connect/ui/views/video_audio_player/full_screen_video_player.dart';
import 'package:o_connect/ui/views/video_audio_player/model/video_share_model.dart';
import 'package:o_connect/ui/views/webinar_details/webinar_details_provider/webinar_provider.dart';
import 'package:path_provider/path_provider.dart';
import 'package:provider/provider.dart';
import 'package:video_player/video_player.dart';
import 'package:video_thumbnail/video_thumbnail.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';

import '../../seaker_request/speacker_request_model.dart';
import 'meeting_room_provider.dart';

class VideoShareProvider extends ChangeNotifier with MeetingUtilsMixin {
  int videoPlaySelectedIndex = -1;
  bool isLocalVideo = false;

  List<VideoShareModel> videosList = [];
  TextEditingController videoUrlController = TextEditingController();

  bool isPlaying = false;
  bool isFullScreen = false;
  bool isVideoPicked = false;

  /// TODO: use this value to display who is broadcasting the video
  int? _videoBroadcastedBy;

  /// If a youtube video is beiing played, that video id
  String youtubeVideoUrlId = "";

  /// Whether the current video being played is a youtube video
  bool isYoutubeVideo = false;

  YoutubePlayerController? youtubeController;
  VideoPlayerController? videoPlayerController;
  ChewieController? chewieController;

  LibraryRepository libraryRepository = LibraryRepository(ApiHelper().oConnectDio, baseUrl: BaseUrls.libraryBaseUrl);

  bool get canHandleVideoShare => [UserRole.host, UserRole.coHost, UserRole.activeHost].contains(myRole);

  void clearSelection() {
    videoPlaySelectedIndex = -1;
    notifyListeners();
  }

  void updateRequestData(
    String id,
  ) {
    print("host cancel speaker request ${speakerRequestedList.length}");
    print("host cancel speaker request $id");

    for (int i = 0; i < speakerRequestedList.length; i++) {
      print("host cancel speaker request ${speakerRequestedList[i].id.toString()}");

      if (speakerRequestedList[i].id.toString() == id) {
        speakerRequestedList.remove(speakerRequestedList[i]);
      }
    }
    notifyListeners();
  }

  void updateSelectedGridViewIndex(int index) {
    videoPlaySelectedIndex = index;
    isPlaying = false;
    videoUrlController.text = "";
    notifyListeners();
  }

  showVideoLoader() {
    isVideoPicked = true;
    notifyListeners();
  }

  hideVideoLoader() {
    isVideoPicked = false;
    notifyListeners();
  }

  bool isGetVideoData = false;

  void fetchVideoList({bool forceRefresh = false}) async {
    videosList = [];
    isGetVideoData = true;
    if (videosList.isEmpty || forceRefresh) {
      final res = await libraryRepository.fetchLibraryData(int.parse(userData.id.toString()), 'webinar-video');
      print("siva video kumar ${res.data}");
      if (res.status == true) {
        for (var item in res.data) {
          if (item.purpose == "webinar-video") {
            print("siva video kumar ${item.fileName}");
            videosList.add(VideoShareModel(id: item.id!, fileName: item.fileName!, url: item.url!, thumbnail: '', fileSize: item.fileSize, createdDate: item.createdOn));
          }
        }
        // videosList = await Future.wait(res.data!.map(
        //   (e) async {
        //
        //     return VideoShareModel(id: e.id!, fileName: e.fileName!, url: e.url!, thumbnail: '');
        //   },
        // ).toList());
        // notifyListeners();
      } else {
        videosList = [];
      }
      isGetVideoData = false;
      notifyListeners();
    }
  }

  List<SpeakerRequestModel> speakerRequestedList = [];

  void setupHubsocketListeners() {
    hubSocket.socket?.on('commandResponse', (res) async {
      final parsed = jsonDecode(res);
      final data = parsed['data'];
      final command = data['command'];
      if (command == "globalAccess" && data['type'] == 'globalSpeakerAccess') {
        context.read<ParticipantsProvider>().isSpeakerRequest = data['value'];
        print("globalSpeakerAccess new testing ${data['value']} ----${context.read<ParticipantsProvider>().myRole}");
        if (context.read<ParticipantsProvider>().myRole == UserRole.guest) {
          context.read<WebinarProvider>().updateNewBottomBarAllowedActions(UserRole.guest, from: "globalSpeakerAccess");
        }
        notifyListeners();
      } else if (command == "speakerAccess") {
        if (data['value']['type'] == "removeSpeakerAccessAtLeaveMeeting") {
          print("remove speaker request and leave meeting");
        } else if (data['value']['type'] == "declined") {
          print("remove speaker request ${speakerRequestedList.length}");
        } else {
          print(" speaker request for host");
          speakerRequestedList.add(SpeakerRequestModel(
            profilePic: data['value']['profilePic'],
            name: data['value']['name'].toString(),
            email: data['value']['email'],
            id: data['value']['id'],
          ));
        }

        notifyListeners();
      } else if (command == 'globalAccess' && data['type'] == 'activePage') {
        if (!(data['value'] == 'youTubeVideo' || data['value'] == 'LocalVideo')) return;

        final url = data['event']['url'].toString();

        _videoBroadcastedBy = data['event']['userId'];
        if (data['value'] == 'youTubeVideo' && url.isValidYoutubeUrl) {
          isYoutubeVideo = true;
          isLocalVideo = false;
          _setupYoutubePlayer(url);
        } else {
          isYoutubeVideo = false;
          isLocalVideo = true;
          _setupVideoPlayer(url).then((_) async {
            isPlaying = true;
            await chewieController?.play();
            notifyListeners();
          });
        }
        notifyListeners();
      } else if (data['type'] == 'BroadcastYTEvent') {
        if (command == 'youtubePlayerEvent') {
          final value = data['value'];
          final seekTo = data['seekTo'];

          if (value == 1) {
            isPlaying = true;
            if (isYoutubeVideo) {
              if (!youtubeController!.value.isPlaying) {
                youtubeController?.play();
                youtubeController?.seekTo(Duration(seconds: double.parse(seekTo.toString()).toInt()));
              }
            } else {
              if (!videoPlayerController!.value.isPlaying) {
                await chewieController?.play();
                await chewieController?.seekTo(Duration(seconds: double.parse(seekTo.toString()).toInt()));
              }
            }
            notifyListeners();
          } else if (value == 2) {
            isPlaying = false;
            if (isYoutubeVideo) {
              youtubeController?.pause();
            } else {
              chewieController?.pause();
            }
            notifyListeners();
          }
        } else if (command == 'VideoBroadCast') {
          final seekTo = data['currentTime'];
          bool isFirstTime = videoPlayerController == null;

          if (videoPlayerController == null) {
            await _setupVideoPlayer(data['video_url']);
          }

          if (videoPlayerController!.value.isPlaying && !isFirstTime) {
            await chewieController?.pause();
            isPlaying = false;
            notifyListeners();
          } else {
            isPlaying = true;
            await chewieController?.seekTo(Duration(seconds: double.parse(seekTo.toString()).toInt()));
            await chewieController?.play();
            notifyListeners();
          }
        }
      }
    });

    hubSocket.socket?.on('panalResponse', (res) {
      final parsed = jsonDecode(res);
      final data = parsed['data'];
      final command = data['command'];

      if (command == 'AccessRestriction') {
        final value = data['value'];
        final action = data['feature']['action'];

        if ((action == 'removed' || action == 'remove') && value == 'video') {
          isPlaying = false;
          videoPlaySelectedIndex = -1;

          if (isYoutubeVideo) {
            if (!context.read<AppGlobalStateProvider>().isPIPEnabled) {
              print("it reached here dispose method");
              youtubeController?.dispose();
            }
            youtubeController = null;
          } else {
            chewieController?.dispose();
            chewieController = null;
            videoPlayerController?.dispose();
            videoPlayerController = null;
          }
        }
      }
    });
  }

  void _setupYoutubePlayer(
    String url,
  ) {
    youtubeVideoUrlId = convertUrlToId(url).toString();
    youtubeController = YoutubePlayerController(
      initialVideoId: '',
      flags: const YoutubePlayerFlags(hideControls: true),
    );
    notifyListeners();
  }

  /// Converts fully qualified YouTube Url to video id.
  /// Taken from the youtube_video_player package
  ///
  /// If videoId is passed as url then no conversion is done.
  static String? convertUrlToId(String url, {bool trimWhitespaces = true}) {
    if (!url.contains("http") && (url.length == 11)) return url;
    if (trimWhitespaces) url = url.trim();

    for (var exp in [
      RegExp(r"^https:\/\/(?:www\.|m\.)?youtube\.com\/watch\?v=([_\-a-zA-Z0-9]{11}).*$"),
      RegExp(r"^https:\/\/(?:music\.)?youtube\.com\/watch\?v=([_\-a-zA-Z0-9]{11}).*$"),
      RegExp(r"^https:\/\/(?:www\.|m\.)?youtube\.com\/shorts\/([_\-a-zA-Z0-9]{11}).*$"),
      RegExp(r"^https:\/\/(?:www\.|m\.)?youtube(?:-nocookie)?\.com\/embed\/([_\-a-zA-Z0-9]{11}).*$"),
      RegExp(r"^https:\/\/youtu\.be\/([_\-a-zA-Z0-9]{11}).*$"),
      RegExp(r"^https:\/\/(?:www\.|m\.)?youtube\.com\/live\/([_\-a-zA-Z0-9]{11}).*$"),
    ]) {
      Match? match = exp.firstMatch(url);
      if (match != null && match.groupCount >= 1) return match.group(1);
    }

    return null;
  }

  void onYoutubePlayerReady() {
    print("on player ready: $youtubeVideoUrlId");
    try {
      if (youtubeController!.metadata.videoId != youtubeVideoUrlId) {
        youtubeController!.load(youtubeVideoUrlId);
        isPlaying = true;
        notifyListeners();
      } else {
        youtubeController!.load(youtubeVideoUrlId, startAt: youtubeController!.value.position.inSeconds);
      }
    } on PlatformException catch (e, st) {
      log(e.toString(), error: e, stackTrace: st);
      CustomToast.showErrorToast(msg: 'Unable to play the youtube video');
      stopVideoShare();
    }
  }

  Future<void> _setupVideoPlayer(String url) async {
    try {
      videoPlayerController = VideoPlayerController.networkUrl(Uri.parse(url));
      await videoPlayerController!.initialize();

      chewieController = ChewieController(
        videoPlayerController: videoPlayerController!,
        autoPlay: false,
        showControls: false,
      );

      videoPlayerController?.addListener(() {
        print("VALUE: ${videoPlayerController?.value.isCompleted}");
        if (videoPlayerController?.value.isCompleted == true) {
          isPlaying = false;
          notifyListeners();
        }
      });
    } on PlatformException catch (e) {
      print("the platForm error ${e.message}");
      if (e.message!.contains("Source error")) {
        ///show source error messagge
      }
      CustomToast.showErrorToast(msg: 'Unable to play local video');
      stopVideoShare();
    } catch (e, st) {
      CustomToast.showErrorToast(msg: 'Unable to play local video');
      print("the video share catched error is ${e.toString()} && $st");
      stopVideoShare();
    }
  }

  Future<void> startVideoShare({required String videoUrl}) async {
    var meetingId = meeting.id.toString();
    var userId = userData.id;
    var userName = userData.userFirstName.toString();
    isYoutubeVideo = videoUrl.isValidYoutubeUrl;

    notifyListeners();

    if (!isYoutubeVideo) {
      final response = await Dio().head(videoUrl);
      final acceptedFormats = ['video/mp4', 'video/webm'];
      if (response.statusCode != 200 || !response.headers.map.containsKey('Content-Type') || !response.headers.map['Content-Type']!.any((f) => acceptedFormats.contains(f))) {
        CustomToast.showErrorToast(msg: 'Unsupported/invalid video url');
        return;
      }
    }

    var body = {
      "type": "pvwpqs",
      "feature": "video",
      "action": "open",
      "meetingId": meetingId,
      "userId": userId,
      "role": 1,
    };
    await gloablSetRepo.setGlobalAccess(body);

    body = {
      "roomId": meetingId,
      "key": isLocalVideo ? "LocalVideo" : "youTubeVideo",
      "value": {
        "broadcastBy": userId,
        "playBackRate": 1,
        'url': videoUrl,
      }
    };
    await globalStatusRepo.updateGlobalAccessStatus(body);

    body = {
      "key": "activePage",
      "roomId": meetingId,
      "value": isLocalVideo ? "LocalVideo" : "youTubeVideo",
    };
    await globalStatusRepo.updateGlobalAccessStatus(body);

    hubSocket.socket?.emitWithAck(
      "onPanalCommand",
      jsonEncode({
        "uid": "ALL",
        "data": {
          "command": "AccessRestriction",
          "feature": {"message": "opened", "action": "opened"},
          "value": "video",
          "ou": userId,
          "on": userName,
          "roleType": myHubInfo.role,
        }
      }),
    );

    hubSocket.socket?.emitWithAck(
      "onCommand",
      jsonEncode({
        "uid": "ALL",
        "data": {
          "command": "globalAccess",
          "type": "activePage",
          "value": isLocalVideo ? "LocalVideo" : "youTubeVideo",
          "event": {
            "activePage": isLocalVideo ? "LocalVideo" : "youTubeVideo",
            "url": videoUrl,
            "broadcastBy": userId,
            "value": 1,
            "seekTo": 0,
            "playBackRate": 1,
          }
        }
      }),
    );
  }

  void stopVideoShare() async {
    var userId = userData.id;
    var userName = userData.userName.toString();
    print("the user id are the from user Id $userId && to userId $_videoBroadcastedBy ");
    if (_videoBroadcastedBy != null && _videoBroadcastedBy.toString() != userId.toString()) {
      print("it reached here video stop ");
      return;
    }

    hubSocket.socket!.emitWithAck(
      "onCommand",
      jsonEncode({
        "uid": "ALL",
        "data": {
          "command": "globalAccess",
          "type": "activePage",
          "value": "av",
          "ou": userId,
        }
      }),
    );
    hubSocket.socket!.emitWithAck(
      "onPanalCommand",
      jsonEncode({
        "uid": "ALL",
        "data": {
          "command": "AccessRestriction",
          "feature": {
            "action": "removed",
            "user": {
              "role": myHubInfo.role,
              "feature": "video",
              "userId": userId,
              "isAccessing": true,
              "userName": userName,
            }
          },
          "value": "video",
          "ou": userId
        }
      }),
    );

    var meetingId = meeting.id.toString();
    var body = {
      "type": "pvwpqs",
      "feature": "video",
      "action": "close",
      "meetingId": meetingId,
      "userId": userId,
      "role": 1,
    };
    await gloablSetRepo.setGlobalAccess(body);

    body = {
      "roomId": meetingId,
      "key": "remove",
      "value": [
        if (isYoutubeVideo) ...[
          "youTubeVideo",
          "youTubeVideoState",
        ],
        if (isLocalVideo) ...[
          "LocalVideo",
          "localVideoState",
        ],
        "fullscreen",
      ]
    };

    await globalStatusRepo.updateGlobalAccessStatus(body);
    isPlaying = false;
    youtubeVideoUrlId = "";
    videoUrlController.text = "";
    videoPlaySelectedIndex = -1;
    resetState();
    notifyListeners();
  }

  Future<void> changePlaybackTime(Duration duration) async {
    var meetingId = meeting.id.toString();
    var userId = userData.id.toString();
    Map<String, dynamic> apiBody = {
      "roomId": meetingId,
      "key": isLocalVideo ? "localVideoState" : "youTubeVideoState",
      "value": {
        "broadcastBy": userId,
        if (isYoutubeVideo) "playerState": 1,
        if (isLocalVideo) "playerState": "play",
        "playBackRate": 1,
        "playerTime": duration.inSeconds,
      }
    };
    await context.read<MeetingRoomProvider>().globalStatusRepo.updateGlobalAccessStatus(apiBody);

    Map body = isLocalVideo
        ? {
            "uid": "ALL",
            "data": {
              "command": "VideoBroadCast",
              "type": "BroadcastYTEvent",
              "action": "play",
              "currentTime": duration.inSeconds,
              "video_url": videoUrlController.text,
            }
          }
        : {
            "uid": "ALL",
            "data": {
              "command": "youtubePlayerEvent",
              "type": "BroadcastYTEvent",
              "value": 1,
              "playBackRate": 1,
              "seekTo": duration.inSeconds,
            },
          };
    hubSocket.socket!.emitWithAck(
      "onCommand",
      jsonEncode(body),
    );
  }

  Future<void> togglePlay() async {
    var userId = context.read<MeetingRoomProvider>().userData.id.toString();
    bool isPlay = !(isYoutubeVideo ? youtubeController!.value.isPlaying : videoPlayerController!.value.isPlaying);
    int timeData = isYoutubeVideo ? youtubeController!.value.position.inSeconds : videoPlayerController!.value.position.inSeconds;

    Map<String, dynamic> playPauseBody = {
      "roomId": meeting.id,
      "key": isLocalVideo ? "localVideoState" : "youTubeVideoState",
      "value": {
        "broadcastBy": userId,
        if (isYoutubeVideo) "playerState": isPlay ? 1 : 2,
        if (isLocalVideo) "playerState": isPlay ? "play" : "pause",
        "playBackRate": 1,
        "playerTime": timeData,
      }
    };
    context.read<MeetingRoomProvider>().globalStatusRepo.updateGlobalAccessStatus(playPauseBody);

    hubSocket.socket!.emitWithAck(
      "onCommand",
      jsonEncode(isLocalVideo
          ? {
              "uid": "ALL",
              "data": {
                "command": "VideoBroadCast",
                "type": "BroadcastYTEvent",
                "action": isPlay ? "play" : "pause",
                "currentTime": timeData,
                "video_url": videoUrlController.text,
              }
            }
          : {
              "uid": "ALL",
              "data": {
                "command": "youtubePlayerEvent",
                "type": "BroadcastYTEvent",
                "value": isPlay ? 1 : 2,
                "playBackRate": 1,
                "seekTo": timeData,
                "breakTime": {
                  "isTrusted": true,
                }
              }
            }),
    );
  }

  updateLocalVideoPlayer(VideoPlayerController controller) {
    controller.value.isPlaying ? controller.pause() : controller.play();
    // togglePlay(
    //   isPlay: controller.value.isPlaying,
    //   timeData: controller.value.position.inSeconds,
    // );
    notifyListeners();
  }

  Future<void> showFilePicker() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(type: FileType.video, allowMultiple: false);
    if (result != null && result.files.isNotEmpty) {
      File originalVideoFile = File(result.files.single.path!);
      await fileUploadService(originalVideoFile);
      CustomToast.showSuccessToast(msg: "File uploaded Successfully");
    } else {
      hideVideoLoader();
    }
  }

  Future<void> fileUploadService(File videoFile) async {
    String fileHeader = FileUploadRepository.getFileHeader(videoFile);

    var meetingId = meeting.id.toString();
    var userId = userData.id.toString();
    try {
      FileUploadRepository fileUploadRepository = FileUploadRepository(
        baseUrl: BaseUrls.libraryBaseUrl,
        dio: ApiHelper().oConnectDio,
      );
      PresentationUploadFilesModel? uploadFilesModel = await fileUploadRepository.uploadFile(
        file: videoFile,
        userId: userId,
        userInfo: fileHeader,
        purpose: "webinar-video",
        meetingId: meetingId,
        contentType: lookupMimeType(videoFile.path) ?? 'video/mp4',
      );
      if (uploadFilesModel != null) {
        fetchVideoList(forceRefresh: true);
      } else {
        CustomToast.showErrorToast(msg: "File upload failed");
      }
      hideVideoLoader();
    } catch (e) {
      log("Error came $e");
      CustomToast.showErrorToast(msg: "File upload failed");
    }
  }

  Future<File?> genThumbnailFile(String path) async {
    final fileName = await VideoThumbnail.thumbnailFile(
      video: path,
      thumbnailPath: (await getTemporaryDirectory()).path,
      imageFormat: ImageFormat.PNG,
      maxHeight: 64,
      quality: 75,
    );
    if (fileName == null) return null;
    File file = File(fileName);
    notifyListeners();
    return file;
  }

  void toggleFullScreen() {
    isFullScreen = !isFullScreen;
    notifyListeners();

    if (isYoutubeVideo) {
      youtubeController?.toggleFullScreenMode();
    } else {
      if (isFullScreen) {
        chewieController?.enterFullScreen();
      } else {
        chewieController?.exitFullScreen();
      }
    }

    if (!isFullScreen) Navigator.of(context).pop();

    notifyListeners();

    if (isFullScreen) {
      showDialog(
        context: context,
        builder: (context) => const FullscreenVideoPlayer(),
      );
    }
  }

  /// This method will be called when video share is active when we have joined the meeting
  void setInitialVideoState(VideoShareData videoShareData, VideoShareState videoShareState, bool isLocalVideo) {
    isYoutubeVideo = videoShareData.url.isValidYoutubeUrl;
    this.isLocalVideo = isLocalVideo;
    _videoBroadcastedBy = videoShareData.broadcastedBy;
    //TODO: handle initial play and pause also
    if (isYoutubeVideo) {
      _setupYoutubePlayer(videoShareData.url);
    } else {
      _setupVideoPlayer(videoShareData.url).then((_) async {
        isPlaying = true;
        await chewieController?.play();
        notifyListeners();
      });
    }
  }

  void resetState() {
    if (chewieController?.isPlaying == true) {
      chewieController?.dispose();
    }
    if (youtubeController?.value.isPlaying == true) {
      youtubeController?.dispose();
    }
    videoPlaySelectedIndex = -1;
    isFullScreen = false;
    isLocalVideo = false;
    videoPlayerController = null;
    youtubeController = null;
    chewieController = null;
    videoUrlController.clear();
    _videoBroadcastedBy = null;
    youtubeVideoUrlId = '';
    isYoutubeVideo = false;
    speakerRequestedList = [];
  }

  bool isDeleteItem = false;

  Future videoDelete(String id, context) async {

    try {
      isDeleteItem = true;
      // var res = await libraryRepository.deleteFile(id);
      final payload = {
        "FileIds": [id]
      };
      print("deleted idssssssssssss  $payload");

      final res = await libraryRepository.deleteVideoShareVideoFile(payload);
      if (res.statusCode == 200) {
        fetchVideoList(forceRefresh: true);
        CustomToast.showSuccessToast(msg: "File successfully deleted").then((value) {
          Navigator.pop(context);
        });
      }
      debugPrint("delete delete ${res.toString()}");
      isDeleteItem = false;
      notifyListeners();
    } on DioException catch (e) {
      CustomToast.showErrorToast(msg: "Video delete fail...");
      debugPrint("dio exception ${e.error} && ${e.response.toString()} ");
    } catch (e) {
      debugPrint("dio exception ${e.toString()}");
    }
    notifyListeners();
  }
}
