import 'package:chewie/chewie.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:lottie/lottie.dart';
import 'package:video_player/video_player.dart';

import '../../../../utils/images/images.dart';
import '../../../../utils/textfield_helper/app_fonts.dart';

class NetworkVideoPlayerWidget extends StatefulWidget {
  const NetworkVideoPlayerWidget(
      {Key? key, required this.filename, required this.filePath})
      : super(key: key);

  final String filename;
  final String filePath;

  @override
  State<StatefulWidget> createState() {
    return _NetworkVideoPlayerWidgetState();
  }
}

class _NetworkVideoPlayerWidgetState extends State<NetworkVideoPlayerWidget> {
  late VideoPlayerController _videoPlayerController;
  ChewieController? _chewieController;
  int? bufferDelay;

  @override
  void initState() {
    super.initState();
    initializePlayer();
  }

  @override
  void dispose() {
    _videoPlayerController.dispose();
    _chewieController?.dispose();
    super.dispose();
  }

  Future<void> initializePlayer() async {
    _videoPlayerController =
        VideoPlayerController.networkUrl(Uri.parse(widget.filePath));
    await Future.wait([_videoPlayerController.initialize()]);
    _createChewieController();
    setState(() {});
  }

  void _createChewieController() {
    _chewieController = ChewieController(
      videoPlayerController: _videoPlayerController,
      autoPlay: true,
      looping: true,
      progressIndicatorDelay:
          bufferDelay != null ? Duration(milliseconds: bufferDelay!) : null,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        title: Text(
          widget.filename,
          style: w500_15Poppins(color: Theme.of(context).disabledColor),
        ),
        leading: Row(
          children: [
            IconButton(
              icon: Icon(
                Icons.arrow_back_ios_rounded,
                color: Theme.of(context).disabledColor,
                size: 20,
              ),
              onPressed: () => Navigator.of(context).pop(),
            ),
          ],
        ),
      ),
      body: Column(
        children: <Widget>[
          Expanded(
            child: Center(
              child: _chewieController != null &&
                      _chewieController!
                          .videoPlayerController.value.isInitialized
                  ? Chewie(
                      controller: _chewieController!,
                    )
                  :  Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Lottie.asset(AppImages.loadingJson, height: 40.w, width: 40.w),
                        const SizedBox(height: 20),
                      ],
                    ),
            ),
          ),
        ],
      ),
    );
  }
}
