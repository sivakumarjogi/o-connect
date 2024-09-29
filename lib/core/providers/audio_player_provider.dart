import 'package:audio_session/audio_session.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart';

class AudioPlayerProvider extends ChangeNotifier {
  bool? miniAudioPlayer;
  String tickerText = "hello";
  String tickerDirection = "Left";
  AudioPlayer player = AudioPlayer();

  Future miniPlayerController() async {
    debugPrint("hello audio siva kumar ");
    player.stop();
    player.dispose();
    miniAudioPlayer = false;
    notifyListeners();
  }

  void tickerPublish(tickerTextView, tickerItemType, BuildContext context) {
    print("siva kumar ${tickerTextView}");
    miniAudioPlayer = true;
    tickerDirection = tickerItemType;
    tickerText = (tickerTextView == "" || tickerTextView == null)
        ? "Test Application"
        : tickerTextView;
    notifyListeners();
    Navigator.pop(context);
  }

  Future<void> publishAudio(String urlTrack) async {
    final session = await AudioSession.instance;
    await session.configure(const AudioSessionConfiguration.speech());
    player.playbackEventStream.listen((event) {},
        onError: (Object e, StackTrace stackTrace) {
      print('A stream error occurred: $e');
    });
    try {
      await player
          .setAudioSource(AudioSource.asset("assets/audio/nachavu.mp3"));
      Future.delayed(Duration(seconds: 1), () {
        player.play();
      });
    } catch (e) {
      print("Error loading audio source: $e");
    }
  }
}
