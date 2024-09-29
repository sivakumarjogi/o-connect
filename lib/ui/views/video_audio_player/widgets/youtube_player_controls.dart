import 'package:flutter/material.dart';
import 'package:o_connect/ui/views/meeting/providers/video_share_provider.dart';
import 'package:o_connect/ui/views/video_audio_player/widgets/video_current_position.dart';
import 'package:o_connect/ui/views/video_audio_player/widgets/video_progress_bar.dart';
import 'package:provider/provider.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';

class YoutubeVideoProgressBar extends StatelessWidget {
  const YoutubeVideoProgressBar({super.key, required this.controller});

  final YoutubePlayerController controller;

  @override
  Widget build(BuildContext context) {
    return OConnectVideoProgressBar(
      controller: controller,
      onSeekToRelativePosition: (relativePosition, {required bool allowSeekAhead}) {
        controller.seekTo(relativePosition, allowSeekAhead: allowSeekAhead);

        if (allowSeekAhead) {
          context.read<VideoShareProvider>().changePlaybackTime(relativePosition);
          controller.play();
        }
      },
      getTotalDurationInMillis: () => controller.metadata.duration.inMilliseconds.toDouble(),
      getTotalDuration: () => controller.metadata.duration,
      getPlayedValue: () => controller.value.position.inMilliseconds / controller.metadata.duration.inMilliseconds,
      getBufferedValue: () => controller.value.buffered,
    );
  }
}

class YoutubePlayerCurrentPosition extends StatelessWidget {
  const YoutubePlayerCurrentPosition({super.key, required this.controller});

  final YoutubePlayerController controller;

  @override
  Widget build(BuildContext context) {
    return OConnectCurrentVideoPosition(
      controller: controller,
      getCurrentPosition: () => controller.value.position.inMilliseconds,
      getTotalDuration: () => controller.value.metaData.duration.inMilliseconds,
    );
  }
}
