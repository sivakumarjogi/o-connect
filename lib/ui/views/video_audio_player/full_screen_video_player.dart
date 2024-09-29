import 'package:chewie/chewie.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:o_connect/core/screen_configs.dart';
import 'package:o_connect/ui/views/meeting/providers/video_share_provider.dart';
import 'package:o_connect/ui/views/video_audio_player/video_player.dart';
import 'package:provider/provider.dart';
import 'package:video_player/video_player.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';

class FullscreenVideoPlayer extends StatefulWidget {
  const FullscreenVideoPlayer({super.key});

  @override
  State<FullscreenVideoPlayer> createState() => _FullscreenVideoPlayerState();
}

class _FullscreenVideoPlayerState extends State<FullscreenVideoPlayer> {
  bool showControls = true;
  YoutubePlayerController? youtubePlayerController;

  void _toggleShowControls() => setState(() => showControls = !showControls);

  @override
  void initState() {
    super.initState();
    final videoShareProvider = context.read<VideoShareProvider>();
    if (videoShareProvider.isYoutubeVideo) {
      youtubePlayerController = YoutubePlayerController(
        initialVideoId: videoShareProvider.youtubeVideoUrlId,
        flags: YoutubePlayerFlags(
          hideControls: true,
          startAt: videoShareProvider.youtubeController?.value.position.inSeconds ?? 0,
          enableCaption: false,
          controlsVisibleAtStart: false,
        ),
      );
      youtubePlayerController?.toggleFullScreenMode();
    }
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {});
  }

  @override
  void dispose() {
    youtubePlayerController?.toggleFullScreenMode();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Consumer<VideoShareProvider>(builder: (_, videoShareProvider, child) {
          return Stack(
            children: [
              InkWell(
                onTap: _toggleShowControls,
                child: videoShareProvider.isYoutubeVideo
                    ? YoutubePlayer(
                        controller: youtubePlayerController!,
                        onReady: () {},
                        // aspectRatio: 16 / 8,
                      )
                    : Chewie(
                        controller: videoShareProvider.chewieController!,
                      ),
              ),
              if (showControls)
                const AnimatedPositioned(
                  duration: Duration(milliseconds: 600),
                  bottom: 0,
                  left: 0,
                  right: 0,
                  child: VideoPlayerControls(),
                ),
              Align(
                alignment: Alignment.topRight,
                child: IconButton(
                  onPressed: () {
                    context.read<VideoShareProvider>().toggleFullScreen();
                  },
                  icon: videoShareProvider.isFullScreen ? const Icon(Icons.fullscreen_exit) : const Icon(Icons.fullscreen),
                ),
              ),
            ],
          );
        }),
      ),
    );
  }
}
