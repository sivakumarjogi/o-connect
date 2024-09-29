import 'dart:async';
import 'dart:developer';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:o_connect/ui/utils/base_urls.dart';
import 'package:o_connect/ui/views/share_files/share_files_speaker_view.dart';
import 'package:o_connect/ui/views/video_audio_player/widgets/video_player_controls.dart';
import 'package:video_player/video_player.dart';

class GuestStreamingView extends StatefulWidget {
  const GuestStreamingView({super.key, required this.meetingId});

  final String meetingId;

  @override
  State<GuestStreamingView> createState() => _GuestStreamingViewState();
}

class _GuestStreamingViewState extends State<GuestStreamingView> {
  VideoPlayerController? _controller;
  bool _streamReady = false;

  Timer? _timer;

  @override
  void initState() {
    _initializeVideo();
    super.initState();
  }

  String get videoStreamUrl => "${BaseUrls.videoStreamUrl}${widget.meetingId}.m3u8";

  Future<bool> _isStreamReady() async {            
    try {
      final streamCheck = await Dio().head(videoStreamUrl);
      print(streamCheck.statusCode);
      print(streamCheck.data);
      if (streamCheck.statusCode == 404) {
        return false;
      }
      return streamCheck.statusCode == 200;
    } on DioException {
      return false;
    } catch (e) {
      return false;
    }
  }

  Future<void> _initializeVideo() async {                                                                      
    try {
      final streamReady = await _isStreamReady();
      if (!streamReady) {
        _setupAutoRetry();
        return;
      }

      _controller = VideoPlayerController.networkUrl(
        Uri.parse(videoStreamUrl),
        formatHint: VideoFormat.hls,
      );
      await _controller?.setLooping(true);

      _controller?.initialize().then((value) async {
        await _controller?.play();
        setState(() => _streamReady = true);
      }).catchError((err) {
        print("error: $err");
        _controller?.dispose();

        _setupAutoRetry();

        setState(() {});
      });
    } catch (e, st) {
      log(e.toString(), error: e, stackTrace: st);
    }
  }

  void _setupAutoRetry() {
    _timer ??= Timer.periodic(const Duration(seconds: 10), (timer) async {
      await _initializeVideo();
      if (_controller?.value.isInitialized == true) {
        _timer?.cancel();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    if (_controller == null) {
      return const Center(child: CircularProgressIndicator());
    }

    final bool isPlaying = _controller!.value.isPlaying;

    return AspectRatio(
      aspectRatio: 16 / 9,
      child: _streamReady
          ? Stack(
              children: [
                VideoPlayer(_controller!),
                ShareFileDownloadFloadingPopUp(),
                Positioned(
                  bottom: 0,
                  left: 0,
                  right: 0,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      VideoProgressIndicator(_controller!, allowScrubbing: false),
                      // const SizedBox(height: 6),
                      // Row(
                      //   children: [
                      //     IconButton(
                      //       onPressed: _handleReplay,
                      //       icon: const Icon(Icons.replay_10),
                      //     ),
                      //     IconButton(
                      //       onPressed: _handleOnPlayPause,
                      //       icon: isPlaying ? const Icon(Icons.pause) : const Icon(Icons.play_arrow),
                      //     ),
                      //     IconButton(
                      //       onPressed: _handleFastForward,
                      //       icon: const Icon(Icons.forward_10),
                      //     ),
                      //   ],
                      // ),
                    ],
                  ),
                ),
              ],
            )
          : Container(
              color: Colors.black12,
              padding: const EdgeInsets.all(16.0),
              child: const Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.stream),
                  SizedBox(height: 12),
                  Text(
                    'Your live stream will play automatically as soon as it\'s available. Get ready to be part of the action!',
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),
    );
  }

  @override
  void dispose() {
    _controller?.dispose();
    _timer?.cancel();
    super.dispose();
  }

  void _handleOnPlayPause() async {
    if (_controller!.value.isPlaying) {
      await _controller?.pause();
    } else {
      await _controller?.play();
    }
    setState(() {});
  }

  void _handleFastForward() {
    if (_controller == null) return;

    if (_controller!.value.duration.inSeconds - _controller!.value.position.inSeconds > 10) {
      _controller!.seekTo(Duration(seconds: _controller!.value.position.inSeconds + 10));
    }
  }

  void _handleReplay() {
    if (_controller == null) return;

    if (_controller!.value.position.inSeconds > 10) {
      _controller!.seekTo(Duration(seconds: _controller!.value.position.inSeconds - 10));
    } else {
      _controller!.seekTo(const Duration(seconds: 0));
    }
  }
}
