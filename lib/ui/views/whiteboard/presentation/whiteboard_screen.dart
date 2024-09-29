import 'dart:developer';

import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:o_connect/core/screen_configs.dart';
import 'package:o_connect/ui/utils/custom_show_dialog_helper/custom_show_dialog.dart';
import 'package:o_connect/ui/views/meeting/model/user_role.dart';
import 'package:o_connect/ui/views/meeting/providers/participants_provider.dart';
import 'package:o_connect/ui/views/presentation/presentation_whiteboard/presentation_whiteboard_provider.dart';
import 'package:o_connect/ui/views/whiteboard/presentation/widgets/whiteboard_default_actions.dart';
import 'package:provider/provider.dart';
import '../../../../core/providers/whiteboard_provider.dart';
import 'widgets/wb_confirmatiom_pop_up.dart';

class WhiteboardScreen extends StatefulWidget {
  const WhiteboardScreen({Key? key, required this.height}) : super(key: key);
  final double height;

  @override
  State<WhiteboardScreen> createState() => _WhiteboardScreenState();
}

class _WhiteboardScreenState extends State<WhiteboardScreen> {
  late WhiteboardProvider _whiteboardProvider;

  @override
  void initState() {
    super.initState();
    _whiteboardProvider = Provider.of<WhiteboardProvider>(
      context,
      listen: false,
    );
    _whiteboardProvider.getInitialCanvasData();
  }

  @override
  void dispose() {
    _whiteboardProvider.webViewController?.clearCache();
    _whiteboardProvider.webViewController?.removeAllUserScripts();
    log("Called");
    super.dispose();
  }

  TextEditingController textEditingController = TextEditingController();
  final ScrollController _scrollController = ScrollController();

  @override
  Widget build(BuildContext context) {
    // print(_whiteboardProvider.callBacks);
    return SizedBox(
      child: Column(
        children: [
          Expanded(
            child: Scrollbar(
              thickness: 100,
              radius: Radius.circular(20),
              controller: _scrollController,
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
                        await _whiteboardProvider.onWebViewCreated(controller);
                        setState(() {});
                      },
                      initialOptions: InAppWebViewGroupOptions(
                        crossPlatform: InAppWebViewOptions(
                            javaScriptEnabled: true,
                            transparentBackground: true,
                            useShouldOverrideUrlLoading: true,
                            supportZoom: true,
                            verticalScrollBarEnabled: false,
                            horizontalScrollBarEnabled: false),
                        ios: IOSInAppWebViewOptions(),
                        android: AndroidInAppWebViewOptions(
                          displayZoomControls: true,
                          useHybridComposition: true,
                          loadWithOverviewMode: true,
                          builtInZoomControls: true,
                        ),
                      ),
                      shouldOverrideUrlLoading: (controller, action) async {
                        return NavigationActionPolicy.ALLOW;
                      },
                      onConsoleMessage: (controller, message) {
                        log(message.message);
                      },
                      onLoadStop: (InAppWebViewController controller, Uri? uri) async {
                        _whiteboardProvider.onWebViewLoadStop(controller);
                        controller.addJavaScriptHandler(
                          handlerName: 'canvasJsonData',
                          callback: (contents) {
                            print("Got the call back ");
                            var receivedData = contents.first;
                            _whiteboardProvider.sendCanvasEvent(
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
                              _whiteboardProvider.downloadCanvasImage(
                                canvasByteData: receivedData.toString(),
                              );
                            }
                          },
                        );
                      },
                    ),
                    if (context.read<ParticipantsProvider>().myRole == UserRole.host)
                      Align(
                        alignment: Alignment.topLeft,
                        child: IconButton(
                            onPressed: () async {
                              await context.read<WhiteboardProvider>().closeWhiteBoard();
                            },
                            icon: CircleAvatar(
                              radius: 10.r,
                              backgroundColor: Colors.red,
                              child: Center(
                                child: Icon(
                                  Icons.close_rounded,
                                  color: Colors.white,
                                  size: 14.sp,
                                ),
                              ),
                            )),
                      ),
                    Consumer<WhiteboardProvider>(builder: (context, provider, child) {
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
                    Consumer<WhiteboardProvider>(builder: (context, provider, child) {
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
                    // const ExpandButton(),
                  ],
                ),
              ),
            ),
          ),
          _whiteboardProvider.callBacks != null
              ? WhiteBoardTapActions(
                  callBacks: _whiteboardProvider.callBacks!,
                )
              : const IgnorePointer(),
        ],
      ),
    );
  }
}
