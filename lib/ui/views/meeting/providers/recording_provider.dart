import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:just_audio/just_audio.dart';
import 'package:o_connect/core/enum/view_state_enum.dart';
import 'package:o_connect/core/service/api_helper/api_helper.dart';
import 'package:o_connect/ui/utils/audio/audio_files.dart';
import 'package:o_connect/ui/utils/base_urls.dart';
import 'package:o_connect/ui/utils/buttons_helper/custom_botton.dart';
import 'package:o_connect/ui/utils/buttons_helper/custom_outline_button.dart';
import 'package:o_connect/ui/utils/custom_toast_helper/custom_toast.dart';
import 'package:o_connect/ui/views/meeting/data/meeting_room_repository.dart';
import 'package:o_connect/ui/views/meeting/model/model.dart';
import 'package:o_connect/ui/views/meeting/providers/meeting_room_provider.dart';
import 'package:o_connect/ui/views/meeting/utils/meeting_utils_mixin.dart';
import 'package:o_connect/ui/views/themes/providers/webinar_themes_provider.dart';
import 'package:o_connect/ui/views/webinar_details/webinar_details_provider/webinar_provider.dart';
import 'package:provider/provider.dart';

class RecordingProvider extends ChangeNotifier with MeetingUtilsMixin {
  final MeetingRoomRepository _libraryRepo = MeetingRoomRepository(
    ApiHelper().oConnectDio,
    baseUrl: BaseUrls.libraryBaseUrl,
  );
  bool _recording = false;
  bool _isRequestInProgress = false;

  AudioPlayer player = AudioPlayer();

  void setupRoomSocketListeners() {
    player = AudioPlayer();
    roomSocket.socket?.on('notification', (res) {
      final method = res['method'];
      if (method == 'cloudRecordingStatus') {
        _recording = res['data']['status'];
        notifyListeners();

        if (res['data']['status']) {
          addTopActionToDashboard(MeetingAction.recording);

          final recordingId = res['data']['recordingId'];
          if (myHubInfo.isHostOrActiveHost) {
            _saveRecordings(recordingId);
          } else {
            _playSound(AppAudioAssets.startRecording);
            if (myRole == UserRole.speaker) askForPermission();
          }
        } else {
          if (!myHubInfo.isHostOrActiveHost) {
            _playSound(AppAudioAssets.stopRecording);
          }
          removeTopAction(MeetingAction.recording);
        }
      }
    });
  }

  void askForPermission() async {
    bool dialogClosed = false;
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        return WillPopScope(
          onWillPop: () async => false,
          child: AlertDialog(
            elevation: 0,
            backgroundColor: context.read<WebinarThemesProviders>().colors.headerColor,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12.r),
            ),
            title: const Text(
              'Host started recording this meeting',
              textAlign: TextAlign.center,
            ),
            content: const Text(
              'This session is being recorded. Click "Accept" to proceed',
              textAlign: TextAlign.center,
            ),
            actions: [
              CustomOutlinedButton(
                buttonText: 'Decline',
                onTap: () {
                  dialogClosed = true;
                  Navigator.of(context).pop();
                  context.read<MeetingRoomProvider>().leaveMeeting().then((value) {
                    Navigator.of(context).pop();
                  });
                },
              ),
              CustomButton(
                buttonText: 'Accept',
                onTap: () {
                  dialogClosed = true;
                  Navigator.of(context).pop();
                },
              ),
            ],
          ),
        );
      },
    );

    Timer(const Duration(seconds: 30), () {
      if (dialogClosed == false) {
        Navigator.of(context).pop();
      }
    });
  }

  void toggleRecording(bool isRecord, WebinarTopFutures activeFuture) async {
    print("Recording in progress  $activeFuture");
    if (_isRequestInProgress) return;

    _recording = isRecord;
    bool recording = _recording;
    _isRequestInProgress = true;
    notifyListeners();

    final res = await globalStatusRepo.updateGlobalAccessStatus({
      "key": "record",
      "roomId": meeting.id,
      "value": recording,
    });
    if (res.statusCode == 200) {
      final method = recording ? "createRecording" : "stopRecording";
      roomSocket.request(
        method,
        {
          "recordingMode": recording,
          "roomId": meeting.id,
          if (recording) "id": myHubInfo.peerId,
        },
        () {
          context.read<WebinarProvider>().setIsRecording(recording);
          refreshAllowedActionsUI();
        },
      );
    }
    _isRequestInProgress = false;

    notifyListeners();
  }

  Future<void> _saveRecordings(String recordingId) async {
    await _libraryRepo.saveReciordings({
      "url": recordingId,
      "meetingId": meeting.id,
      "userId": userData.id,
      "purpose": "Recordings",
      "file_name": "sample",
      "contentType": "video/mp4",
      "filesize": "765757",
    });
  }

  void _playSound(String assetPath) async {
    await player.setAudioSource(AudioSource.asset(assetPath));
    await player.play();
  }

  void setInitialState(bool recording) {
    _recording = recording;
    notifyListeners();
  }

  void resetState() {
    _recording = false;
    player.stop();
    player.dispose();
  }
}
