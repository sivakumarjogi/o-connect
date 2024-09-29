import 'package:flutter/material.dart';
import 'package:o_connect/ui/views/meeting/providers/video_share_provider.dart';
import 'package:o_connect/ui/views/video_audio_player/widgets/video_progress_bar.dart';
import 'package:provider/provider.dart';
import 'package:video_player/video_player.dart';

import 'video_current_position.dart';

class VideoPlayerProgressBar extends StatelessWidget {
  const VideoPlayerProgressBar({super.key, required this.controller});

  final VideoPlayerController controller;

  @override
  Widget build(BuildContext context) {
    return OConnectVideoProgressBar(
      controller: controller,
      onSeekToRelativePosition: (relativePosition, {required bool allowSeekAhead}) {
        controller.seekTo(relativePosition);

        if (allowSeekAhead) {
          context.read<VideoShareProvider>().changePlaybackTime(relativePosition);
          controller.play();
        }
      },
      getTotalDurationInMillis: () => controller.value.duration.inMilliseconds.toDouble(),
      getTotalDuration: () => controller.value.duration,
      getPlayedValue: () => controller.value.position.inMilliseconds / controller.value.duration.inMilliseconds,
      getBufferedValue: () => controller.value.buffered.isNotEmpty ? controller.value.buffered.first.end.inMilliseconds.toDouble() : 0.0,
    );
  }
}

class VideoPlayerCurrentPosition extends StatelessWidget {
  const VideoPlayerCurrentPosition({super.key, required this.controller});

  final VideoPlayerController controller;

  @override
  Widget build(BuildContext context) {
    return OConnectCurrentVideoPosition(
      controller: controller,
      getCurrentPosition: () => controller.value.position.inMilliseconds,
      getTotalDuration: () => controller.value.duration.inMilliseconds,
    );
  }
}
