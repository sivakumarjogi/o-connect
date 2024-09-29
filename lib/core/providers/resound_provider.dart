import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart';
import 'package:o_connect/ui/views/meeting/utils/meeting_utils_mixin.dart';

class ResoundProvider extends ChangeNotifier with MeetingUtilsMixin {
  AudioPlayer audioPlayer = AudioPlayer();
  String currentSoundUrl = '';

  void setupListeners() {
    hubSocket.socket?.on('panalResponse', (res) {
      final parsed = jsonDecode(res);
      final data = parsed['data'];
      final command = data['command'];
      final value = data['value'];

      if (command == 'AccessRestriction' && value == 'resounds') {
        if (data['feature']['action'] == 'opened') {
          // Host has opened the resounds window
        } else if (data['feature']['action'] == 'removed') {
          // Host has closed the resounds window
        }
      }
    });

    hubSocket.socket?.on('entResponse', (res) {
      final parsed = jsonDecode(res);
      final data = parsed['data'];
      final command = data['command'];
      final value = data['value'];

      if (command == 'resound') {
        if (value == null || value.toString().isEmpty) {
          _stopSound();
        } else {
          final url = value['url'];
          if (data['isPaused'] == false && data['isSelected'] == true) {
            _playSound(url, parsed['from']);
          } else if (data['isPaused'] == true && data['isSelected'] == false) {
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
          "command": "resound",
          "value": {"name": name, "url": url, "isPlaying": true},
          "isPaused": false,
          "isSelected": true,
          "isButton": false
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
          "command": "resound",
          "value": {"name": name, "url": url, "isPlaying": true},
          "isPaused": true,
          "isSelected": false,
          "isButton": false
        }
      }),
    );
  }

  void emitPlayCompletedEvent() {
    hubSocket.socket?.emitWithAck(
      'onEntCommand',
      jsonEncode({
        "uid": "ALL",
        "data": {"command": "resound", "value": null, "isPaused": true, "isSelected": false, "isButton": false}
      }),
    );
  }

  /// Should be called whenever the resound window is open
  void setResoundWindowIsOpen() => _setResoundWindowStatus(open: true);

  /// Should be called whenever the resound window is closed
  void setResoundWindowIsClosed() => _setResoundWindowStatus(open: false);

  void _setResoundWindowStatus({required bool open}) async {
    final response = await globalStatusRepo.setGlobalAccess({
      "action": open ? "open" : "close",
      "feature": "resounds",
      "meetingId": meeting.id,
      "role": 1,
      "type": "sounds",
      "userId": attendee.userId,
    });

    if (response.status == true && response.data?.permission == true) {
      // If we are trying to close
      if (open == false) {
        // stop playing any ongoing resounds
        hubSocket.socket?.emitWithAck(
          'onEntCommand',
          jsonEncode({
            "uid": "ALL",
            "data": {"command": "resound", "value": "", "isPaused": false, "isSelected": true, "isButton": false}
          }),
        );

        hubSocket.socket?.emitWithAck(
          'onPanalCommand',
          jsonEncode({
            "uid": "ALL",
            "data": {
              "command": "AccessRestriction",
              "feature": {
                "action": "removed",
                "user": {"feature": "resounds", "userId": userData.id, "isAccessing": true, "userName": userData.userEmail}
              },
              "value": "resounds",
              "ou": userData.id,
              "on": userData.userEmail
            }
          }),
        );
      } else {
        hubSocket.socket?.emitWithAck(
          'onPanalCommand',
          jsonEncode({
            "from": attendee.userId.toString(),
            "roomId": meeting.id,
            "data": {
              "command": "AccessRestriction",
              "feature": {"message": "opened", "action": "opened"},
              "value": "resounds",
              "ou": attendee.userId,
              "on": userData.userEmail,
              "soundType": "resounds"
            }
          }),
        );
      }
    }
  }

  void _playSound(String url, String from) async {
    try {
      try {
        if (audioPlayer.playing) {
          await audioPlayer.dispose();
          audioPlayer = AudioPlayer();
        }
      } catch (e) {}

      currentSoundUrl = url;
      await audioPlayer.setUrl(url);
      notifyListeners();
      await audioPlayer.play();

      if (from == userData.id.toString()) {
        emitPlayCompletedEvent();
      }
    } catch (e, st) {
      debugPrint("Unable to play: $e $st");
    }
  }

  void _pauseSound() async {
    try {
      if (audioPlayer.playing) {
        await audioPlayer.pause();
      }
      currentSoundUrl = '';
    } catch (e, st) {
      debugPrint("Unable to play: $e $st");
    }
  }

  void _stopSound() async {
    try {
      currentSoundUrl = '';
      notifyListeners();
      await audioPlayer.stop();
    } catch (e, st) {
      debugPrint("Unable to play: $e $st");
    }
  }

  Future<void> resetState() async {
    try {
      await audioPlayer.stop();
      await audioPlayer.dispose();
    } catch (e, st) {
      print("unable to dispose the audio player");
    } finally {
      audioPlayer = AudioPlayer();
    }
  }

  void togglePlay(String name, String url) async {
    if (audioPlayer.playing && currentSoundUrl == url) {
      emitPauseEvent(name, url);
    } else {
      emitPlayEvent(name, url);
    }
  }
}
