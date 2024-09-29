import 'dart:convert';
import 'dart:developer';
import 'dart:io';
import 'dart:typed_data';
import 'dart:ui' as ui;
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:image_picker/image_picker.dart';
import 'package:o_connect/core/models/auth_models/generate_token_o_connect_model.dart';
import 'package:o_connect/core/screen_configs.dart';
import 'package:o_connect/core/service/api_helper/api_helper.dart';
import 'package:o_connect/core/service/download_files_service.dart';
import 'package:o_connect/core/service_locator.dart';
import 'package:o_connect/core/user_cache_service.dart';
import 'package:o_connect/my_app.dart';
import 'package:o_connect/ui/utils/base_urls.dart';
import 'package:o_connect/ui/utils/buttons_helper/custom_botton.dart';
import 'package:o_connect/ui/utils/custom_show_dialog_helper/custom_show_dialog.dart';
import 'package:o_connect/ui/utils/custom_toast_helper/custom_toast.dart';
import 'package:o_connect/ui/utils/whiteboard_tools_enum.dart';
import 'package:o_connect/ui/views/call_to_action/data/call_to_action_repository.dart';
import 'package:o_connect/ui/views/meeting/data/meeting_room_repository.dart';
import 'package:o_connect/ui/views/meeting/model/user_role.dart';
import 'package:o_connect/ui/views/meeting/providers/base_meeting_provider.dart';
import 'package:o_connect/ui/views/meeting/providers/meeting_room_provider.dart';
import 'package:o_connect/ui/views/meeting/providers/participants_provider.dart';
import 'package:o_connect/ui/views/meeting/signaling/hub_socket.dart';
import 'package:o_connect/ui/views/meeting/signaling/white_board_socket.dart';
import 'package:o_connect/ui/views/meeting/utils/meeting_utils_mixin.dart';
import 'package:o_connect/ui/views/themes/models/theme_color.dart';
import 'package:o_connect/ui/views/themes/providers/webinar_themes_provider.dart';
import 'package:o_connect/ui/views/whiteboard/whiteboard_webview/whiteboard_callbacks.dart';
import 'package:oes_chatbot/utils/font_styles_global.dart';
import 'package:open_file/open_file.dart';
import 'package:provider/provider.dart';
import 'package:socket_io_client/socket_io_client.dart';
import 'package:o_connect/ui/views/meeting/model/meeting_data_response/data.dart';

import '../../ui/utils/buttons_helper/custom_outline_button.dart';
import '../../ui/utils/colors/colors.dart';

class WhiteboardProvider extends BaseMeetingProvider with MeetingUtilsMixin {
  final CallToActionRepository callToActionRepo = CallToActionRepository(
    ApiHelper().oConnectDio,
    baseUrl: BaseUrls.templateBaseUrl,
  );

  @override
  final MeetingRoomRepository meetingRepo = MeetingRoomRepository(
    ApiHelper().oConnectDio,
    baseUrl: BaseUrls.globalAccessStatusSetUrl,
  );

  ImagePicker picker = ImagePicker();
  Offset? startPoint;
  InAppWebViewController? webViewController;
  dynamic receivedSocketResponse;
  dynamic canvasJson;
  CallBacks? callBacks;
  WhiteBoardToolType whiteBoardToolType = WhiteBoardToolType.POINTER;
  SelectedWhiteBoardTool selectedWhiteBoardTool = SelectedWhiteBoardTool.Pointer;
  int canvasHeight = 1032;
  int canvasWidth = 940;
  dynamic initialCanvasJson;
  bool showCloseButton = false;
  double horizontalScrollPosition = 0.0;
  final double horizontalCenter = 0.0;
  double verticalScrollPosition = 0.0;
  final double verticalCenter = 0.0;

  void onHorizontalDragUpdate(DragUpdateDetails details) {
    if (webViewController != null) {
      horizontalScrollPosition += details.delta.dx;
      webViewController?.scrollBy(x: details.delta.dx.toInt(), y: 0);
      notifyListeners();
    }
  }

  void onHorizontalDragEnd(DragEndDetails details) {
    horizontalScrollPosition = horizontalCenter;
    notifyListeners();
  }

  void onVerticalDragUpdate(DragUpdateDetails details) {
    if (webViewController != null) {
      verticalScrollPosition += details.delta.dy;
      webViewController?.scrollBy(x: 0, y: details.delta.dy.toInt());
      notifyListeners();
    }
  }

  void onVerticalDragEnd(DragEndDetails details) {
    verticalScrollPosition = verticalCenter;
    notifyListeners();
  }

  set setWhiteBoardToolType(WhiteBoardToolType toolType) {
    whiteBoardToolType = toolType;
    notifyListeners();
  }

  bool get canDraw {
    var currentRoleOfMe = context.read<ParticipantsProvider>().myRole;
    log("whiteboard roles $currentRoleOfMe");

    return currentRoleOfMe == UserRole.host || currentRoleOfMe == UserRole.coHost;
  }

  void updateSelectedWBTool(SelectedWhiteBoardTool selectedIcon) {
    selectedWhiteBoardTool = selectedIcon;
    notifyListeners();
  }

  Future getInitialCanvasData() async {
    await initializeWhiteBoard(userData: userData, meeting: meeting);

    String? oConnectTkn = await serviceLocator<UserCacheService>().getOConnectToken();

    Response wbInitialResponse = await Dio().get("https://wb-qa.onpassive.com/currentstate/${meeting.id.toString()}", options: Options(headers: {"Authorization": oConnectTkn}));
    if (wbInitialResponse.statusCode == 200 && wbInitialResponse.data["data"]["command"] == "CANVASDATA") {
      initialCanvasJson = (wbInitialResponse.data["data"]["data"]);
      dynamic measurementsData = wbInitialResponse.data["measurements"];
      if (measurementsData != null) {
        canvasHeight = measurementsData["data"]["height"];
        canvasWidth = measurementsData["data"]["width"];
      }
      notifyListeners();
    }
  }

  Future<void> showTextEnterDialog() async {
    TextEditingController controller = TextEditingController();
    WebinarThemeColors colors = context.read<WebinarThemesProviders>().colors;
    return customShowDialog(
        context,
        SizedBox(
          height: ScreenConfig.height * 0.25,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              showDialogCustomHeader(context, headerTitle: "Text", removeDivider: true),
              height10,
              Container(
                width: ScreenConfig.width * 0.9,
                decoration: BoxDecoration(
                    border: Border.all(color: colors.buttonColor),
                    borderRadius: BorderRadius.all(
                      Radius.circular(10.r),
                    )),
                child: TextFormField(
                  controller: controller,
                  maxLines: 2,
                  decoration: InputDecoration(
                    counterText: "",
                    hintText: "Please enter text",
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10.r),
                    ),
                    contentPadding: EdgeInsets.all(10.sp),
                  ),
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  CustomOutlinedButton(
                    outLineBorderColor: colors.buttonColor,
                    height: 35.h,
                    width: 80.w,
                    buttonTextStyle: w400_13Poppins(color: colors.textColor),
                    buttonText: "Cancel",
                    onTap: () {
                      Navigator.pop(context);
                    },
                  ),
                  width15,
                  CustomButton(
                    height: 35.h,
                    width: 80.w,
                    buttonColor: colors.buttonColor,
                    buttonText: "Add text",
                    onTap: () async {
                      if (controller.text.isNotEmpty) {
                        context.read<WhiteboardProvider>().callBacks!.drawText(textToEnter: controller.text.trim());
                      } else {
                        await CustomToast.showErrorToast(msg: "Please enter the text!");
                      }
                      Navigator.pop(context);
                    },
                  ),
                  width15,
                ],
              ),
            ],
          ),
        ),
        height: ScreenConfig.height * 0.3);
  }

  Future<void> initializeWhiteBoard({
    required GenerateTokenUser userData,
    required MeetingData meeting,
  }) async {
    WhiteBoardSocket.instance.init(
      context.read<MeetingRoomProvider>().hubSocketInput,
      meeting.token!,
    );
    WhiteBoardSocket.instance.socket?.onConnect((data) {
      log("White Board Connection Data $data");
    });
    WhiteBoardSocket.instance.socket?.on("commandResponse", (data) async {
      // receivedSocketResponse = data;
      dynamic receivedData = json.decode(data);
      dynamic canvasJson = receivedData["data"]["data"];
      String canvasCommand = receivedData["data"]["command"].toString();
      var currentRoleOfMe = context.read<ParticipantsProvider>().myRole;

      if (canvasCommand == "CANVASDATA" && currentRoleOfMe != UserRole.host) {
        await setCanvasData(canvasJson);
      }
      // if (canvasCommand == "cursorPosition" && !isHost) {
      //   if (webViewController != null) {
      //     dynamic cursorData = receivedData["data"]["value"];
      //     if (cursorData["x"] != null && cursorData["y"] != null) {
      //       int x = (double.parse(cursorData["x"].toString()).toInt());
      //       int y = (double.parse(cursorData["y"].toString()).toInt());

      //       await webViewController!.scrollTo(
      //         x: x,
      //         y: y,
      //         animated: true,
      //       );
      //       await webViewController!.scrollBy(
      //         x: x,
      //         y: y,
      //         animated: true,
      //       );
      //     }
      //   }
      // }
      if (canvasCommand == "onClearCanvas" && !canDraw) {
        await clearSpeakerCanvas();
      }
      if (canvasCommand == "measurements" && !canDraw) {
        if (canvasJson["height"] != null) {
          canvasHeight = (canvasJson["height"]) ?? canvasHeight;
        }
        if (canvasJson["width"] != null) {
          canvasWidth = (canvasJson["width"]) ?? canvasWidth;
        }
        notifyListeners();
      }
    });
    WhiteBoardSocket.instance.connect();
    whiteBoardConnectionEstablish(context: context);
  }

  Future<void> setCanvasData(dynamic canvasData) async {
    if (webViewController != null) {
      await drawFromObjectData(objectData: canvasData);
    }
  }

  Future<void> closeWhiteBoard() async {
    MeetingRoomProvider meetingData = context.read<MeetingRoomProvider>();
    canvasJson = null;
    Map body = {
      "type": "pvwpqs",
      "action": "close",
      "feature": "whiteboard",
      "role": 1,
      "roomId": meetingData.meeting.id,
      "value": meetingData.userData.id,
    };
    Map body2 = {
      "roomId": meetingData.meeting.id,
      "key": "remove",
      "value": ["LAWBU", "activePage", "fullscreen"]
    };
    await ApiHelper().oConnectDio.post(
          ("${BaseUrls.globalAccessSetUrl}/global-access/set"),
          data: body,
        );

    await ApiHelper().oConnectDio.post(
          ("${BaseUrls.globalAccessStatusSetUrl}/global-access/status/set"),
          data: body2,
        );
    WhiteBoardSocket.instance.socket?.emitWithAck(
      "onCommand",
      jsonEncode({
        "uid": "ALL",
        "data": {
          "command": "onClearCanvas",
          "ou": meetingData.userData.id,
        }
      }),
    );
    HubSocket.instance.socket?.emitWithAck(
      'onCommand',
      jsonEncode({
        "uid": "ALL",
        "data": {
          "command": "closeWhiteboard",
          "value": "",
          "ou": meetingData.userData.id,
        }
      }),
    );
    HubSocket.instance.socket?.emitWithAck(
      'onPanalCommand',
      jsonEncode({
        "uid": "ALL",
        "data": {
          "command": "AccessRestriction",
          "feature": {"action": "remove"},
          "value": "whiteboard",
          "ou": meetingData.userData.id,
        }
      }),
    );
    WhiteBoardSocket.instance.close();
  }

  Future<void> drawFromObjectData({required dynamic objectData}) async {
    String drawingJs = '''
        var cursorPos=null;
        canvas.__eventListeners = {};
        console.log(canvas);
      	canvas.loadFromJSON(JSON.stringify($objectData), function() {
         canvas.forEachObject(function (obj) {
            obj.selectable = $canDraw;
          });
        canvas.renderAll();
        var canvasJson = JSON.stringify(canvas);
        console.log("canvas after data",canvasJson);
        });
      ''';
    try {
      await webViewController!.evaluateJavascript(
        source: drawingJs,
      );
    } catch (e) {
      log("Canvas loading failed $e");
    }
  }

  Future<void> handleTapEvents({
    bool canTap = false,
  }) async {
    String drawingJs = '''
        canvas.selection = $canTap;
      ''';
    await webViewController!.evaluateJavascript(
      source: drawingJs,
    );
  }

  Future<void> clearSpeakerCanvas() async {
    String clearCanvas = '''
          canvas.clear();
          ''';
    await webViewController!.evaluateJavascript(
      source: clearCanvas,
    );
  }

  Future<void> whiteBoardConnectionEstablish({
    required BuildContext context,
  }) async {
    MeetingRoomProvider meetingData = context.read<MeetingRoomProvider>();

    Map globalAccessSet2 = {
      "roomId": meetingData.meeting.id,
      "key": "activePage",
      "value": "Whiteboard",
    };
    await ApiHelper().oConnectDio.post(
          ("${BaseUrls.globalAccessStatusSetUrl}/global-access/status/set"),
          data: globalAccessSet2,
        );

    Map globalAccessSet3 = {
      "roomId": meetingData.meeting.id,
      "key": "LAWBU",
      "value": meetingData.userData.id,
    };
    await ApiHelper().oConnectDio.post(
          ("${BaseUrls.globalAccessStatusSetUrl}/global-access/status/set"),
          data: globalAccessSet3,
        );

    Map onHubCommand = {
      "uid": "ALL",
      "data": {
        "command": "globalAccess",
        "type": "activePage",
        "value": "Whiteboard",
        "ou": meetingData.userData.id,
      }
    };
    HubSocket.instance.socket?.emitWithAck(
      'onCommand',
      jsonEncode(onHubCommand),
    );

    Future.delayed(
      const Duration(milliseconds: 300),
      () {
        HubSocket.instance.socket?.emitWithAck(
          'onPanalCommand',
          jsonEncode({
            'uid': 'ALL',
            'data': {
              'command': 'AccessRestriction',
              'feature': {
                'message': 'opened',
                'action': 'opened',
              },
              'value': 'whiteboard',
              'ou': meetingData.userData.id!,
              'roleType': meetingData.attendee.roleType ?? "Host",
              'on': meetingData.userData.userFirstName,
            }
          }),
        );
      },
    );
    Map globalAccessSet1 = {
      "type": "pvwpqs",
      "feature": "whiteboard",
      "action": "open",
      "meetingId": meetingData.meeting.id,
      "userId": meetingData.userData.id,
      "role": 1,
    };
    await ApiHelper().oConnectDio.post(
          ("${BaseUrls.globalAccessSetUrl}/global-access/set"),
          data: globalAccessSet1,
        );
    await Future.delayed(
      const Duration(seconds: 1),
      () {
        final initialCanvasJson = {
          "uid": "ALL",
          "data": {
            "command": "measurements",
            "data": {"type": "measures", "width": 940, "height": 1032},
            "ou": meetingData.userData.id!
          }
        };
        WhiteBoardSocket.instance.socket?.emitWithAck(
          "onCommand",
          jsonEncode(initialCanvasJson),
        );
      },
    );
    await Future.delayed(
      const Duration(milliseconds: 600),
      () {
        sendCanvasEvent();
      },
    );
  }

  void clearCanvas() {
    final meetingRoomProvider = navigationKey.currentContext!.read<MeetingRoomProvider>();

    WhiteBoardSocket.instance.socket?.emitWithAck(
      "onCommand",
      "{\"uid\":\"ALL\",\"data\":{\"command\":\"onClearCanvas\",\"ou\":${meetingRoomProvider.userData.id}}}",
    );
  }

  Future<void> downloadCanvasImage({String canvasByteData = ""}) async {
    canvasByteData = canvasByteData.replaceAll("data:image/png;base64,", "");
    Uint8List byteStream = base64Decode(canvasByteData);
    String downloadsFilePath = await createFolder();
    if (downloadsFilePath.isNotEmpty) {
      try {
        File imageFile = File("$downloadsFilePath/O-connect-canvas.png");
        imageFile.writeAsBytesSync(byteStream);
        await CustomToast.showDownloadToast(
          msg: "Canvas Downloaded Successfully",
          onTap: () async {
            await OpenFile.open(imageFile.path);
          },
        );
      } catch (e) {
        await CustomToast.showErrorToast(msg: "Canvas Download failed");
      }
    }
  }

  Future<void> setCanvasDimensions({int? height = 1032, int? width = 940}) async {
    String drawingJs = '''
       canvas.setDimensions({width:${width ?? 940}, height:${height ?? 1032}});
      ''';
    await webViewController!.evaluateJavascript(
      source: drawingJs,
    );
  }

  Future<void> setCanvasInitialData() async {
    if (initialCanvasJson != null) {
      String drawingJs = '''
        var cursorPos=null;
        canvas.__eventListeners = {};
      	canvas.loadFromJSON($initialCanvasJson, function() {
          canvas.renderAll();
        });
      ''';
      await webViewController!.evaluateJavascript(
        source: drawingJs,
      );
      initialCanvasJson = null;
      notifyListeners();
    }
  }

  void sendCanvasEvent({
    dynamic canvasData,
    dynamic cursorData,
    dynamic toolData,
  }) {
    final meetingRoomProvider = navigationKey.currentContext!.read<MeetingRoomProvider>();

    if (cursorData != null) {
      HubSocket.instance.socket?.emitWithAck(
        'onCommand',
        '{"uid":"ALL","data":{"command":"cursorPosition","value":{"x":${cursorData['x']},"y":${cursorData['y']},"userId":${meetingRoomProvider.userData.id}}}}',
      );
    }
    if (toolData != null) {
      HubSocket.instance.socket?.emitWithAck(
        'onCommand',
        '''{"uid":"ALL",
          "data":{"command":"whiteBoardId",
          "value":{"userId":${meetingRoomProvider.userData.id},
          "details":{"isDrawingMode":false,"tool":${whiteBoardToolType.text}}
            }
          }
        }''',
      );
    }
    if (canvasData != null) {
      String encodedCanvas = (canvasData.toString().replaceAll('"', '\\"'));
      // log(encodedCanvas);
      String sendCanvasData = '{"uid":"ALL","data":{"command":"CANVASDATA","data":"$encodedCanvas","ou":${meetingRoomProvider.userData.id}}}';
      log(sendCanvasData);
      WhiteBoardSocket.instance.socket?.emitWithAck(
        "onCommand",
        sendCanvasData,
      );
    }
  }

  Future<void> onWebViewCreated(
    InAppWebViewController controller,
  ) async {
    webViewController = controller;
    await loadWebView();
    updateCallBacks(controller);
  }

  Future<void> updateCallBacks(
    InAppWebViewController controller, {
    bool makeNull = false,
  }) async {
    if (canDraw) {
      callBacks = makeNull ? null : CallBacks(controller: controller);
      log("myroleeeeeeeeeeeeeeeeeeeeeeeeeeeeeeee: $callBacks makenull $makeNull");
      await handleTapEvents(canTap: !makeNull);
      notifyListeners();
    } else {
      callBacks = null;
      await handleTapEvents(canTap: !makeNull);
      notifyListeners();
    }
  }

  updatePointerDown(PointerDownEvent pointerDownValue) {
    startPoint = pointerDownValue.localPosition;
    notifyListeners();
  }

  Future<void> loadWebView() async {
    if (webViewController == null) {
      return;
    }
    await webViewController!.loadFile(
      assetFilePath: "assets/whiteboard_webview/canvas.html",
    );
    // await setCanvasDimensions();
    webViewController!.addJavaScriptHandler(
      handlerName: 'getCanvasJson',
      callback: (contents) {
        canvasJson = contents.first;
        notifyListeners();
      },
    );
  }

  Future<void> onWebViewLoadStop(InAppWebViewController controller) async {
    controller.addJavaScriptHandler(
      handlerName: 'getCanvasJson',
      callback: (contents) {
        print(contents.first);
      },
    );
    await setCanvasDimensions(
      height: canvasHeight,
      width: canvasWidth,
    );
    await setCanvasInitialData();
    if (!canDraw) {
      await handleTapEvents();
    }
  }

  Future selectImageFromGallery() async {
    XFile? image = await picker.pickImage(source: ImageSource.gallery);
    if (image == null) {
      CustomToast.showInfoToast(msg: "Please select image to draw");
    } else {
      if (callBacks != null) {
        String base64Data = base64Encode(await image.readAsBytes());
        await callBacks!.drawImage(base64Data: base64Data);
      }
    }
    notifyListeners();
  }

  Future<ui.Image> loadImage(String filePath) async {
    final Uint8List data = await File(filePath).readAsBytes();
    final codec = await ui.instantiateImageCodec(
      data,
      targetHeight: 150,
      targetWidth: 150,
    );
    var frame = await codec.getNextFrame();
    return frame.image;
  }

  updateUi() {
    notifyListeners();
  }
}
