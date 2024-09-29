import 'dart:io';
import 'package:flutter/material.dart';
import 'package:o_connect/ui/views/meeting/providers/video_share_provider.dart';
import 'package:o_connect/ui/views/video_audio_player/video_progress_indicator.dart';
import 'package:provider/provider.dart';
import 'package:video_player/video_player.dart';

class OconnectVideoPlayer extends StatefulWidget {
  const OconnectVideoPlayer({super.key, required this.videoUri, this.isNetworkVideo = false, this.listenerForVideoPlayer});

  final String videoUri;
  final bool isNetworkVideo;
  final Function(Duration)? listenerForVideoPlayer;

  @override
  State<OconnectVideoPlayer> createState() => _OconnectVideoPlayerState();
}

class _OconnectVideoPlayerState extends State<OconnectVideoPlayer> {
  late VideoPlayerController _controller;

  @override
  void initState() {
    super.initState();
    initVideoPlayer();
  }

  initVideoPlayer() {
    _controller = widget.isNetworkVideo
        ? VideoPlayerController.networkUrl(
            Uri.parse(widget.videoUri),
          )
        : VideoPlayerController.file(
            File(widget.videoUri),
          );
    if (widget.listenerForVideoPlayer != null) {}
    _controller.addListener(
      () {},
    );

    _controller.setLooping(true);
    _controller.initialize().then((_) {});
    _controller.play();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  void deactivate() {
    _controller.pause();
    super.deactivate();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<VideoShareProvider>(builder: (key, videoShareProvider, child) {
      return Stack(
        alignment: Alignment.bottomCenter,
        children: <Widget>[
          VideoPlayer(_controller),
          ClosedCaption(text: _controller.value.caption.text),
          AnimatedSwitcher(
            duration: const Duration(milliseconds: 50),
            reverseDuration: const Duration(milliseconds: 200),
            child: Center(
              child: IconButton(
                onPressed: () {
                  videoShareProvider.updateLocalVideoPlayer(_controller);
                },
                icon: Icon(
                  _controller.value.isPlaying ? Icons.pause : Icons.play_arrow,
                  color: Colors.white,
                  size: 40.0,
                  semanticLabel: 'Pause',
                ),
              ),
            ),
          ),
          OConnectVideoProgressIndicator(
            _controller,
            allowScrubbing: true,
            onSeek: widget.listenerForVideoPlayer,
          ),
        ],
      );
    });
  }
}
