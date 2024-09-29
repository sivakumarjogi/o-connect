import 'dart:developer';
import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:o_connect/core/screen_configs.dart';
import 'package:o_connect/ui/utils/colors/colors.dart';
import 'package:o_connect/ui/utils/custom_show_dialog_helper/custom_show_dialog.dart';
import 'package:o_connect/ui/utils/images/images.dart';
import 'package:o_connect/ui/views/meeting/model/user_role.dart';
import 'package:o_connect/ui/views/meeting/providers/participants_provider.dart';
import 'package:o_connect/ui/views/presentation/presentation_whiteboard/presentation_whiteboard_provider.dart';
import 'package:o_connect/ui/views/webinar_details/webinar_details_provider/webinar_provider.dart';
import 'package:o_connect/ui/views/whiteboard/presentation/widgets/wb_confirmatiom_pop_up.dart';
import 'package:o_connect/ui/views/whiteboard/presentation/widgets/whiteboard_default_actions.dart';
import 'package:provider/provider.dart';

class PresentationWhiteboardScreen extends StatefulWidget {
  const PresentationWhiteboardScreen({
    Key? key,
    required this.height,
  }) : super(key: key);
  final double height;

  @override
  State<PresentationWhiteboardScreen> createState() => _PresentationWhiteboardScreenState();
}

class _PresentationWhiteboardScreenState extends State<PresentationWhiteboardScreen> {
  late PresentationWhiteBoardProvider _presentationWhiteBoardProvider;

  @override
  void initState() {
    super.initState();
    _presentationWhiteBoardProvider = Provider.of<PresentationWhiteBoardProvider>(
      context,
      listen: false,
    );
  }

  @override
  void dispose() {
    _presentationWhiteBoardProvider.presentationWebViewController?.clearCache();
    _presentationWhiteBoardProvider.presentationWebViewController?.removeAllUserScripts();
    log("Called");
    super.dispose();
  }

  TextEditingController textEditingController = TextEditingController();
  double _currentZoom = 1.0;
  @override
  Widget build(BuildContext context) {
    // Navigator.pop(context);
    return SizedBox(
      child: Column(
        children: [
          Expanded(
            child: Container(
              width: ScreenConfig.width * 0.92,
              color: Colors.white,
              child: Stack(
                children: [
                  InAppWebView(
                    gestureRecognizers: <Factory<OneSequenceGestureRecognizer>>{
                      Factory<OneSequenceGestureRecognizer>(
                        () => EagerGestureRecognizer(),
                      ),
                    },
                    onWebViewCreated: (InAppWebViewController controller) async {
                      await _presentationWhiteBoardProvider.onWebViewCreated(controller);
                      setState(() {});
                    },
                    initialOptions: InAppWebViewGroupOptions(
                      crossPlatform: InAppWebViewOptions(
                        javaScriptEnabled: true,
                        transparentBackground: true,
                        useShouldOverrideUrlLoading: true,
                        horizontalScrollBarEnabled: true,
                        verticalScrollBarEnabled: true,
                        supportZoom: true,
                      ),
                      android: AndroidInAppWebViewOptions(
                        displayZoomControls: true,
                        useHybridComposition: true,
                        loadWithOverviewMode: true,
                        scrollbarFadingEnabled: false,
                        scrollBarStyle: AndroidScrollBarStyle.SCROLLBARS_OUTSIDE_OVERLAY,
                        overScrollMode: AndroidOverScrollMode.OVER_SCROLL_ALWAYS,
                        horizontalScrollbarThumbColor: Colors.blueGrey,
                        verticalScrollbarThumbColor: Colors.blueGrey,
                        builtInZoomControls: true,
                      ),
                    ),
                    shouldOverrideUrlLoading: (controller, action) async {
                      return NavigationActionPolicy.ALLOW;
                    },
                    onProgressChanged: (controller, progress) {
                      if (progress == 100) {
                        controller.getZoomScale().then((zoom) {
                          setState(() {
                            _currentZoom = zoom ?? 0;
                          });
                        });
                      }
                    },
                    onConsoleMessage: (controller, message) {
                      log(message.message, stackTrace: StackTrace.current);
                    },
                    onLoadStop: (InAppWebViewController controller, Uri? uri) async {
                      _presentationWhiteBoardProvider.onWebViewLoadStop(controller);
                      controller.addJavaScriptHandler(
                        handlerName: 'canvasJsonData',
                        callback: (contents) {
                          var receivedData = contents.first;
                          _presentationWhiteBoardProvider.sendCanvasEvent(
                            canvasData: receivedData["canvasData"],
                            cursorData: receivedData["cursorData"],
                          );
                        },
                      );
                      controller.addJavaScriptHandler(
                        handlerName: 'canvasImageStream',
                        callback: (contents) {
                          var receivedData = contents.first;
                          if (receivedData != null) {
                            _presentationWhiteBoardProvider.downloadCanvasImage(
                              canvasByteData: receivedData.toString(),
                            );
                          }
                        },
                      );
                      await _presentationWhiteBoardProvider.presentationWhiteBoardConnectionEstablish(
                        sendConvertedImagesList: true,
                      );

                      await Future.delayed(
                        Duration.zero,
                        () {
                          _presentationWhiteBoardProvider.initalizeSpeakerConnection();
                        },
                      );
                    },
                  ),
                  if (context.read<ParticipantsProvider>().myRole == UserRole.host)
                    Align(
                      alignment: Alignment.topLeft,
                      child: IconButton(
                          onPressed: () async {
                            await context.read<PresentationWhiteBoardProvider>().closeWhiteBoard();
                          },
                          icon: CircleAvatar(
                            radius: 10.r,
                            backgroundColor: Colors.red,
                            child: Center(
                              child: Icon(
                                Icons.close_rounded,
                                color: Colors.white,
                                size: 16.r,
                              ),
                            ),
                          )),
                    ),
                  const ExpandButton(),
                  Consumer<PresentationWhiteBoardProvider>(builder: (context, provider, child) {
                    return AnimatedContainer(
                      duration: const Duration(milliseconds: 200),
                      transform: Matrix4.translationValues(
                        provider.horizontalScrollPosition,
                        0,
                        0,
                      ),
                      child: Align(
                        alignment: Alignment.bottomCenter,
                        child: GestureDetector(
                          onHorizontalDragUpdate: provider.onHorizontalDragUpdate,
                          onHorizontalDragEnd: provider.onHorizontalDragEnd,
                          child: Padding(
                            padding: const EdgeInsets.only(bottom: 5),
                            child: Container(
                              height: 10,
                              width: 100,
                              decoration: BoxDecoration(
                                color: Colors.blue,
                                borderRadius: BorderRadius.circular(25),
                              ),
                            ),
                          ),
                        ),
                      ),
                    );
                  }),
                  Consumer<PresentationWhiteBoardProvider>(builder: (context, provider, child) {
                    return AnimatedContainer(
                      duration: const Duration(milliseconds: 200),
                      transform: Matrix4.translationValues(
                        0,
                        provider.verticalScrollPosition,
                        0,
                      ),
                      child: Align(
                        alignment: Alignment.centerRight,
                        child: GestureDetector(
                          onVerticalDragUpdate: provider.onVerticalDragUpdate,
                          onVerticalDragEnd: provider.onVerticalDragEnd,
                          child: Padding(
                            padding: const EdgeInsets.only(right: 5),
                            child: Container(
                              height: 100,
                              width: 10,
                              decoration: BoxDecoration(
                                color: Colors.blue,
                                borderRadius: BorderRadius.circular(25),
                              ),
                            ),
                          ),
                        ),
                      ),
                    );
                  }),
                ],
              ),
            ),
          ),
          _presentationWhiteBoardProvider.callBacks != null
              ? WhiteBoardTapActions(
                  callBacks: _presentationWhiteBoardProvider.callBacks!,
                  fromPresentation: true,
                )
              : const IgnorePointer(),
        ],
      ),
    );
  }
}

class ExpandButton extends StatelessWidget {
  const ExpandButton({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Consumer<WebinarProvider>(builder: (
      context,
      provider,
      _,
    ) {
      return Align(
        alignment: Alignment.topRight,
        child: IconButton(
          onPressed: () {
            provider.toggleExpandedFullScreenVideoCall();
          },
          icon: CircleAvatar(
            radius: 18.r,
            backgroundColor: AppColors.blackColor.withOpacity(0.4),
            child: Padding(
              padding: const EdgeInsets.all(7.0),
              child: Center(
                child: Image.asset(
                  provider.isExpandedWebinarScreen ? AppImages.close_fullscreen_icon : AppImages.open_fullscreen_icon,
                  color: Colors.white,
                  // size: 16.sp,
                ),
              ),
            ),
          ),
        ),
      );
    });
  }
}
