import 'package:chewie/chewie.dart';
import 'package:flutter/material.dart';
import 'package:o_connect/ui/views/meeting/providers/video_share_provider.dart';
import 'package:o_connect/ui/views/meeting/utils/context_ext.dart';
import 'package:o_connect/ui/views/video_audio_player/full_screen_video_player.dart';
import 'package:o_connect/ui/views/video_audio_player/widgets/video_player_controls.dart';
import 'package:o_connect/ui/views/video_audio_player/widgets/youtube_player_controls.dart';
import 'package:provider/provider.dart';
import 'package:video_player/video_player.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';

ObjectKey getYoutubeVideoKey(String videoId) => ObjectKey(videoId);

class VideoPlayerScreen extends StatelessWidget {
  const VideoPlayerScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<VideoShareProvider>(builder: (_, videoShareProvider, __) {
      bool canHandleVideoShare = videoShareProvider.canHandleVideoShare;

      return Stack(
        children: [
          if ((videoShareProvider.videoPlayerController != null && videoShareProvider.chewieController != null) || videoShareProvider.youtubeController != null)
            Align(
              alignment: Alignment.center,
              child: videoShareProvider.isYoutubeVideo
                  ? const YoutubeVideoPlayer()
                  : Chewie(
                    controller: videoShareProvider.chewieController!,
                  ),
            ),
          if (canHandleVideoShare && (videoShareProvider.videoPlayerController != null || videoShareProvider.youtubeController != null))
            const Positioned(
              bottom: 16,
              left: 0,
              right: 0,
              child: VideoPlayerControls(),
            ),
          if (canHandleVideoShare)
            Positioned(
              left: 16,
              top: 8,
              child: InkWell(
                onTap: () => videoShareProvider.stopVideoShare(),
                child: const CircleAvatar(
                  radius: 10,
                  backgroundColor: Colors.red,
                  child: Icon(Icons.close, size: 10),
                ),
              ),
            ),
          // Align(
          //   alignment: Alignment.topRight,
          //   child: IconButton(
          //     onPressed: () {
          //       context.read<VideoShareProvider>().toggleFullScreen();
          //     },
          //     icon: videoShareProvider.isFullScreen ? const Icon(Icons.fullscreen_exit) : const Icon(Icons.fullscreen),
          //   ),
          // ),
        ],
      );
    });
  }
}

class YoutubeVideoPlayer extends StatelessWidget {
  const YoutubeVideoPlayer({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<VideoShareProvider>(
      builder: (context, value, child) {
        print("building new youtube player");
        final widget = YoutubePlayer(
          key: Key(value.youtubeVideoUrlId),
          controller: value.youtubeController!,
          onReady: () => value.onYoutubePlayerReady(),
        );

        print("buildin: ${widget.hashCode}");

        return widget;
      },
    );
  }
}

class VideoPlayerControls extends StatelessWidget {
  const VideoPlayerControls({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<VideoShareProvider>(builder: (_, videoShareProvider, __) {
      return Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (videoShareProvider.isYoutubeVideo)
            YoutubeVideoProgressBar(controller: videoShareProvider.youtubeController!)
          else
            VideoPlayerProgressBar(controller: videoShareProvider.videoPlayerController!),
          Container(
            decoration: BoxDecoration(color: videoShareProvider.isFullScreen ? Colors.black.withOpacity(0.5) : Theme.of(context).primaryColor),
            padding: const EdgeInsets.all(2.0),
            child: Row(
              children: [
                IconButton(
                  onPressed: () => context.read<VideoShareProvider>().togglePlay(),
                  icon: videoShareProvider.isPlaying ? const Icon(Icons.pause) : const Icon(Icons.play_arrow),
                ),
                const SizedBox(width: 12),
                const Spacer(),
                if (videoShareProvider.isYoutubeVideo)
                  YoutubePlayerCurrentPosition(controller: videoShareProvider.youtubeController!)
                else
                  VideoPlayerCurrentPosition(controller: videoShareProvider.videoPlayerController!),
                const SizedBox(width: 12),
              ],
            ),
          ),
        ],
      );
    });
  }
}
