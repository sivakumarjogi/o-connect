import 'dart:convert';
import 'dart:developer';
import 'dart:io';
import 'dart:typed_data';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:image_picker/image_picker.dart';
import 'package:o_connect/core/models/auth_models/generate_token_o_connect_model.dart';
import 'package:o_connect/core/models/library_model/presentation_data_model.dart';
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
import 'package:o_connect/ui/views/meeting/model/user_role.dart';
import 'package:o_connect/ui/views/meeting/providers/base_meeting_provider.dart';
import 'package:o_connect/ui/views/meeting/providers/meeting_provider_mixin.dart';
import 'package:o_connect/ui/views/meeting/providers/meeting_room_provider.dart';
import 'package:o_connect/ui/views/meeting/providers/participants_provider.dart';
import 'package:o_connect/ui/views/meeting/signaling/hub_socket.dart';
import 'package:o_connect/ui/views/meeting/signaling/presentation_whiteboard_socket.dart';
import 'package:o_connect/ui/views/meeting/signaling/white_board_socket.dart';
import 'package:o_connect/ui/views/meeting/utils/context_ext.dart';
import 'package:o_connect/ui/views/meeting/utils/meeting_utils_mixin.dart';
// import 'package:o_connect/ui/views/presentation/model/converted_files.dart';
import 'package:o_connect/ui/views/presentation/provider/presentation_popup_provider.dart';
import 'package:o_connect/ui/views/themes/models/theme_color.dart';
import 'package:o_connect/ui/views/themes/providers/webinar_themes_provider.dart';
import 'package:o_connect/ui/views/whiteboard/whiteboard_webview/whiteboard_callbacks.dart';
import 'package:open_file/open_file.dart';
import 'package:provider/provider.dart';
import 'package:socket_io_client/socket_io_client.dart';
import 'package:o_connect/ui/views/meeting/model/meeting_data_response/data.dart';

class PresentationWhiteBoardProvider extends BaseMeetingProvider with MeetingUtilsMixin {
  List selectedConvertedDocList = [];
  final CallToActionRepository callToActionRepo = CallToActionRepository(
    ApiHelper().oConnectDio,
    baseUrl: BaseUrls.templateBaseUrl,
  );

  ImagePicker picker = ImagePicker();
  Offset? startPoint;
  InAppWebViewController? presentationWebViewController;
  dynamic receivedSocketResponse;
  dynamic canvasJson;
  CallBacks? callBacks;
  WhiteBoardToolType whiteBoardToolType = WhiteBoardToolType.POINTER;
  int canvasHeight = 1032;
  int canvasWidth = 940;
  dynamic initialCanvasJson;
  SelectedWhiteBoardTool selectedPresentationWhiteBoardTool = SelectedWhiteBoardTool.Pointer;
  String speakerImageUrl = '';

  double horizontalScrollPosition = 0.0;
  final double horizontalCenter = 0.0;
  double verticalScrollPosition = 0.0;
  final double verticalCenter = 0.0;

  void onHorizontalDragUpdate(DragUpdateDetails details) {
    if (presentationWebViewController != null) {
      horizontalScrollPosition += details.delta.dx;
      presentationWebViewController?.scrollBy(x: details.delta.dx.toInt(), y: 0);
      notifyListeners();
    }
  }

  void onHorizontalDragEnd(DragEndDetails details) {
    horizontalScrollPosition = horizontalCenter;
    notifyListeners();
  }

  void onVerticalDragUpdate(DragUpdateDetails details) {
    if (presentationWebViewController != null) {
      verticalScrollPosition += details.delta.dy;
      presentationWebViewController?.scrollBy(x: 0, y: details.delta.dy.toInt());
      notifyListeners();
    }
  }

  void onVerticalDragEnd(DragEndDetails details) {
    verticalScrollPosition = verticalCenter;
    notifyListeners();
  }

  void updateSelectedWBTool(SelectedWhiteBoardTool selectedIcon) {
    selectedPresentationWhiteBoardTool = selectedIcon;
    notifyListeners();
  }

  set setWhiteBoardToolType(WhiteBoardToolType toolType) {
    whiteBoardToolType = toolType;
    notifyListeners();
  }

  int pageNumber = 0;

  bool get canDraw {
    var currentRoleOfMe = context.read<ParticipantsProvider>().myRole;
    log("Presetnation whiteboard roles $currentRoleOfMe");
    return currentRoleOfMe == UserRole.host || currentRoleOfMe == UserRole.coHost;
  }

  Future getInitialCanvasData() async {
    String? oConnectTkn = await serviceLocator<UserCacheService>().getOConnectToken();

    Response wbInitialResponse = await Dio().get(
      "https://wb-qa.onpassive.com/currentstate/${meeting.id.toString()}?pId=${pageNumber + 1}",
      options: Options(
        headers: {
          "Authorization": oConnectTkn,
        },
      ),
    );
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

  Future<void> initalizeSpeakerConnection() async {
    if (!canDraw) {
      await initializeWhiteBoard(userData: userData, meeting: meeting);
      if (speakerImageUrl.isNotEmpty) {
        await drawBackgroundImage(backgroundImage: speakerImageUrl);
      }
    }
  }

  Future<void> onPageChange({String backgroundImageUrl = ""}) async {}
  Future<void> showTextEnterDialog() async {
    TextEditingController controller = TextEditingController();
    WebinarThemeColors colors = context.read<WebinarThemesProviders>().colors;
    return customShowDialog(
        context,
        Scaffold(
          resizeToAvoidBottomInset: false,
          body: Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(
                  "Text",
                  style: TextStyle(
                    fontSize: 30,
                    fontWeight: FontWeight.w600,
                    color: Theme.of(context).hintColor,
                  ),
                ),
                Container(
                  width: ScreenConfig.width * 0.9,
                  decoration: BoxDecoration(
                      border: Border.all(color: Theme.of(context).hintColor.withOpacity(0.4)),
                      borderRadius: const BorderRadius.all(
                        Radius.circular(10),
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
              ],
            ),
          ),
          bottomNavigationBar: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              TextButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: Text(
                    "Cancel",
                    style: TextStyle(color: colors.textColor),
                  )),
              CustomButton(
                width: ScreenConfig.width * 0.3,
                buttonText: "Enter text",
                onTap: () {
                  if (controller.text.isNotEmpty) {
                    context.read<PresentationWhiteBoardProvider>().callBacks!.drawText(textToEnter: controller.text.trim());
                  } else {
                    CustomToast.showErrorToast(msg: "Please enter the text!");
                  }
                  Navigator.pop(context);
                },
              )
            ],
          ),
        ),
        height: ScreenConfig.height * 0.3);
  }

  Future<void> initializeWhiteBoard({
    required GenerateTokenUser userData,
    required MeetingData meeting,
  }) async {
    WhiteBoardSocket.instance.close();
    notifyListeners();
    PresentationWhiteBoardSocket.instance.init(context.read<MeetingRoomProvider>().hubSocketInput, meeting.token!);
    PresentationWhiteBoardSocket.instance.socket?.onConnect((data) {
      log("White Board Connection Data $data");
    });

    PresentationWhiteBoardSocket.instance.socket?.on("commandResponse", (data) async {
      // receivedSocketResponse = data;
      dynamic receivedData = json.decode(data);
      dynamic canvasJson = receivedData["data"]["data"];
      String canvasCommand = receivedData["data"]["command"].toString();
      var currentRoleOfMe = context.read<ParticipantsProvider>().myRole;
      if (canvasCommand == "CANVASDATA" && currentRoleOfMe != UserRole.host) {
        await setCanvasData(canvasJson);
      }
      if (canvasCommand == 'WBCDATA' && canvasJson['type'] == 'presentation') {
        speakerImageUrl = canvasJson['url'];
        notifyListeners();
        await drawBackgroundImage(backgroundImage: speakerImageUrl);
      }
      // if (canvasCommand == "cursorPosition" && !isHost) {
      //   if (presentationWebViewController != null) {
      //     dynamic cursorData = receivedData["data"]["value"];
      //     if (cursorData["x"] != null && cursorData["y"] != null) {
      //       int x = (double.parse(cursorData["x"].toString()).toInt());
      //       int y = (double.parse(cursorData["y"].toString()).toInt());

      //       await presentationWebViewController!.scrollTo(
      //         x: x,
      //         y: y,
      //         animated: true,
      //       );
      //       await presentationWebViewController!.scrollBy(
      //         x: x,
      //         y: y,
      //         animated: true,
      //       );
      //     }
      //   }
      // }
      if (canvasCommand == "onClearCanvas") {
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
    PresentationWhiteBoardSocket.instance.connect();
  }

  Future<void> addHubSocketListeners() async {
    hubSocket.socket!.on('commandResponse', (data) async {
      dynamic receivedData = json.decode(data);
      dynamic canvasJson = receivedData["data"];
      String value = canvasJson["value"].toString();
      String command = canvasJson["command"].toString();
      if (value == 'presentationView' && command == 'globalAccess') {
        String url = canvasJson['data']['data'].first['Url'];
        speakerImageUrl = url;
      }
    });
  }

  Future<void> setCanvasData(dynamic canvasData) async {
    if (presentationWebViewController != null) {
      await drawFromObjectData(objectData: canvasData);
    }
  }

  Future<void> closeWhiteBoard() async {
    Map body = {
      "type": "pvwpqs",
      "action": "close",
      "feature": "presentation",
      "role": 1,
      "roomId": meeting.id,
      "value": userData.id,
    };
    Map body2 = {
      "roomId": meeting.id,
      "key": "remove",
      "value": ["presentationData", "activePage", "fullscreen"]
    };
    await ApiHelper().oConnectDio.post(
          ("${BaseUrls.globalAccessSetUrl}/global-access/set"),
          data: body,
        );

    await ApiHelper().oConnectDio.post(
          ("${BaseUrls.globalAccessStatusSetUrl}/global-access/status/set"),
          data: body2,
        );
    PresentationWhiteBoardSocket.instance.socket?.emitWithAck(
      "onCommand",
      jsonEncode({
        "uid": "ALL",
        "data": {
          "command": "onClearCanvas",
          "ou": userData.id,
        }
      }),
    );
    HubSocket.instance.socket?.emitWithAck(
      'onCommand',
      jsonEncode({
        "uid": "ALL",
        "data": {
          "command": "closePresentation",
          "value": "",
          "ou": userData.id,
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
          "value": "presentationView",
          "ou": userData.id,
        }
      }),
    );
  }

  Future<void> drawFromObjectData({required dynamic objectData}) async {
    log(objectData.toString());
    String drawingJs = '''
        var cursorPos=null;
        canvas.__eventListeners = {};
        var parsedCanvasData = JSON.parse(JSON.stringify($objectData));
        console.log("parsedCanvasData - ",parsedCanvasData);
        parsedCanvasData.objects.unshift(imgData.objects[0]);
        var canvasResponse = parsedCanvasData.objects.map(each => {
          if (each.type === 'image') {
            return each;
          }
          return ({
            ...each
          })
        })
        parsedCanvasData['objects'] = canvasResponse;
        var newObjects = JSON.stringify(parsedCanvasData);
        canvas.loadFromJSON(newObjects, () => {
          canvas.forEachObject((object) => {
              object.set({
                selectable: $canDraw,
              });
          });
          canvas.renderAll();
        });
      ''';
    await presentationWebViewController!.evaluateJavascript(
      source: drawingJs,
    );
  }

  Future<void> handleTapEvents({
    bool canTap = false,
  }) async {
    String drawingJs = '''
        canvas.selection = $canTap;
      ''';
    await presentationWebViewController!.evaluateJavascript(
      source: drawingJs,
    );
  }

  Future<void> clearSpeakerCanvas() async {
    String clearCanvas = '''
          canvas.clear();
          ''';
    await presentationWebViewController!.evaluateJavascript(
      source: clearCanvas,
    );
    await drawBackgroundImage(backgroundImage: speakerImageUrl);
  }

  Future changePageNumber({
    bool isIncrement = false,
  }) async {
    // context.showLoading();
    int noOfPages = (context.read<PresentationPopUpProvider>().selectedPresentationFiles?.presentationImages ?? []).length;

    if (pageNumber == 0 && !isIncrement) {
      await CustomToast.showInfoToast(
        msg: "You've reached First Page",
      );
      // context.hideLoading();
      return;
    } else if (pageNumber == (noOfPages - 1) && isIncrement) {
      await CustomToast.showInfoToast(
        msg: "You've reached Last Page",
      );
      // context.hideLoading();
      return;
    }
    if (pageNumber <= noOfPages) {
      if (isIncrement) {
        pageNumber += 1;
      } else {
        pageNumber -= 1;
      }
      notifyListeners();
      await presentationWhiteBoardConnectionEstablish();
    }
  }

  bool get showBackArrow {
    int noOfPages = (context.read<PresentationPopUpProvider>().selectedPresentationFiles?.presentationImages ?? []).length;
    return pageNumber <= noOfPages;
  }

  bool get showFrontArrow {
    return pageNumber > 0 && showBackArrow;
  }

  resetPageNo() {
    pageNumber = 0;
    notifyListeners();
  }

  Future<void> presentationWhiteBoardConnectionEstablish({
    bool sendConvertedImagesList = false,
  }) async {
    // WhiteBoardSocket.instance.close();
    await callPresentationWhiteBoardApis(sendConvertedImagesList: sendConvertedImagesList);
    emitPresentationWhiteBoardSocketData(sendConvertedImagesList: sendConvertedImagesList);
    // ignore: use_build_context_synchronously
    // context.hideLoading();
  }

  void emitPresentationWhiteBoardSocketData({
    bool sendConvertedImagesList = false,
  }) {
    PresentationImage? selectedPresentationImage;
    PresentationDataModel? selectedFileModel = context.read<PresentationPopUpProvider>().selectedPresentationFiles;
    if (selectedFileModel != null) {
      if ((selectedFileModel.presentationImages ?? []).isNotEmpty) {
        selectedPresentationImage = (selectedFileModel.presentationImages)[pageNumber];
      }
      List selectedImagesList = (selectedFileModel.presentationImages).map((e) => e.toJson()).toList();
      Map onHubCommand = {
        "uid": "ALL",
        "data": {
          "command": "globalAccess",
          "type": "activePage",
          "value": "presentationView",
          "ou": userData.id,
          "data": {
            "data": selectedImagesList,
            "ou": userData.id,
            "on": userData.userEmail,
            "presentationUrl": selectedPresentationImage?.url ?? selectedFileModel.presentationUrl,
            "file_name": selectedFileModel.fileName,
            "fileType": selectedFileModel.fileType,
            "pId": (pageNumber),
          }
        },
      };
      if (sendConvertedImagesList) {
        HubSocket.instance.socket?.emitWithAck(
          'onCommand',
          jsonEncode(onHubCommand),
        );
      }
      if (sendConvertedImagesList) {
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
                  'value': 'presentationView',
                  'ou': userData.id!,
                  'roleType': attendee.roleType ?? "Host",
                  'on': userData.userFirstName,
                }
              }),
            );
          },
        );
      }

      Future.delayed(
        const Duration(milliseconds: 300),
        () {
          final initialCanvasJson = {
            "uid": "ALL",
            "data": {"command": "presentPage", "value": (pageNumber + 1)}
          };
          PresentationWhiteBoardSocket.instance.socket?.emitWithAck(
            "onCommand",
            jsonEncode(initialCanvasJson),
          );
        },
      );
      Future.delayed(
        const Duration(milliseconds: 300),
        () {
          final initialCanvasJson = {
            "uid": "ALL",
            "data": {
              "command": "WBCDATA",
              "data": {
                "type": "presentation",
                "url": selectedPresentationImage?.url ?? selectedFileModel.presentationUrl,
                "id": "id0",
                "pId": (pageNumber + 1),
                "width": selectedFileModel.width,
                "height": selectedFileModel.height,
              },
              "ou": userData.id!
            }
          };
          PresentationWhiteBoardSocket.instance.socket?.emitWithAck(
            "onCommand",
            jsonEncode(initialCanvasJson),
          );
        },
      );
    }
  }

  Future callPresentationWhiteBoardApis({
    bool sendConvertedImagesList = false,
  }) async {
    PresentationImage? selectedPresentationImage;
    PresentationDataModel? selectedFileModel = context.read<PresentationPopUpProvider>().selectedPresentationFiles;
    await initializeWhiteBoard(userData: userData, meeting: meeting);
    if ((selectedFileModel?.presentationImages ?? []).isNotEmpty) {
      selectedPresentationImage = selectedFileModel?.presentationImages[pageNumber];
    }
    List selectedImagesList = (selectedFileModel?.presentationImages ?? []).map((e) => e.toJson()).toList();

    Map globalAccessSet1 = {
      "type": "pvwpqs",
      "feature": "presentationView",
      "action": "open",
      "meetingId": meeting.id,
      "userId": userData.id,
      "role": 1,
    };
    if (sendConvertedImagesList) {
      await ApiHelper().oConnectDio.post(
            ("${BaseUrls.globalAccessSetUrl}/global-access/set"),
            data: globalAccessSet1,
          );
    }

    Map globalAccessSet2 = {
      "roomId": meeting.id,
      "key": "activePage",
      "value": "presentationView",
    };
    if (sendConvertedImagesList) {
      await ApiHelper().oConnectDio.post(
            ("${BaseUrls.globalAccessStatusSetUrl}/global-access/status/set"),
            data: globalAccessSet2,
          );
    }

    Map globalAccessSet3 = {
      "roomId": meeting.id,
      "key": "presentationData",
      "value": {
        "presentationUrl": selectedPresentationImage?.url ?? selectedFileModel?.presentationUrl,
        "file_name": selectedFileModel?.fileName,
        "fileType": selectedFileModel?.fileType,
        "data": selectedImagesList,
        "ou": userData.id,
        "width": selectedFileModel?.width,
        "height": selectedFileModel?.height,
        "pId": (pageNumber),
      }
    };

    await ApiHelper().oConnectDio.post(
          ("${BaseUrls.globalAccessStatusSetUrl}/global-access/status/set"),
          data: globalAccessSet3,
        );
    await getInitialCanvasData();
    if (!sendConvertedImagesList) {
      await drawBackgroundImage(
        backgroundImage: selectedPresentationImage?.url ?? selectedFileModel?.presentationUrl ?? "",
      );
    }
  }

  Future<void> clearCanvas() async {
    final meetingRoomProvider = navigationKey.currentContext!.read<MeetingRoomProvider>();

    PresentationWhiteBoardSocket.instance.socket?.emitWithAck(
      "onCommand",
      "{\"uid\":\"ALL\",\"data\":{\"command\":\"onClearCanvas\",\"ou\":${meetingRoomProvider.userData.id}}}",
    );
    PresentationDataModel? selectedFileModel = context.read<PresentationPopUpProvider>().selectedPresentationFiles;

    if (selectedFileModel != null) {
      String bgUrl = selectedFileModel.presentationImages[pageNumber].url;
      await drawBackgroundImage(
        backgroundImage: bgUrl,
      );
    }
  }

  Future<void> downloadCanvasImage({
    String canvasByteData = "",
  }) async {
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
    await presentationWebViewController!.evaluateJavascript(
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
      await presentationWebViewController!.evaluateJavascript(
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
      PresentationWhiteBoardSocket.instance.socket?.emitWithAck(
        "onCommand",
        sendCanvasData,
      );
    }
  }

  Future<void> onWebViewCreated(
    InAppWebViewController controller,
  ) async {
    presentationWebViewController = controller;
    await loadWebView();
    updateCallBacks(controller);
    notifyListeners();
  }

  Future<void> updateCallBacks(
    InAppWebViewController controller, {
    bool makeNull = false,
  }) async {
    if (canDraw) {
      callBacks = makeNull ? null : CallBacks(controller: controller);
      handleTapEvents(canTap: !makeNull);
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
    initialCanvasJson = {};
    if (presentationWebViewController == null) {
      return;
    }
    await presentationWebViewController!.loadFile(
      assetFilePath: "assets/whiteboard_webview/canvas.html",
    );
    await setCanvasDimensions();
    presentationWebViewController!.addJavaScriptHandler(
      handlerName: 'getCanvasJson',
      callback: (contents) {
        canvasJson = contents.first;
        notifyListeners();
      },
    );
  }

  Future<void> onWebViewLoadStop(InAppWebViewController controller) async {
    PresentationDataModel? selectedFileModel = context.read<PresentationPopUpProvider>().selectedPresentationFiles;

    await setCanvasDimensions(
      height: canvasHeight,
      width: canvasWidth,
    );
    await setCanvasInitialData();
    if (selectedFileModel != null && selectedFileModel.presentationImages.isNotEmpty) {
      String bgUrl = selectedFileModel.presentationImages[pageNumber].url;
      await drawBackgroundImage(backgroundImage: bgUrl);
    }

    if (!canDraw) {
      await handleTapEvents();
    }
  }

  Future drawBackgroundImage({String backgroundImage = ""}) async {
    String imageCode = '''
      var imgElement = new Image();
      var imgData = null;

      // Set the crossOrigin property
      imgElement.crossOrigin = 'anonymous';

      // Set up the Fabric.js Image object
      fabric.Image.fromURL('$backgroundImage', function(img) {
          // Set the properties to make the image non-erasable
          img.set({
              selectable: false,
              evented: false,
              left: 0,
              top: 0,
              erasable: false,
              scaleX: canvas.width / img.width,
              scaleY: canvas.height / img.height
          });
        canvas.allowTouchScrolling = true;
        canvas.add(img);
        canvas.renderAll();
          // // Add the image to the canvas
          // canvas.setBackgroundImage(img, canvas.renderAll.bind(canvas), {
          //     scaleX: canvas.width / img.width,
          //     scaleY: canvas.height / img.height
          // });
      }, {element: imgElement});
      var jsonData = JSON.stringify(canvas);
      imgData = JSON.parse(jsonData);
      ''';
    try {
      await presentationWebViewController!.evaluateJavascript(
        source: imageCode,
      );
    } catch (e) {
      log("Error in drawBackgroundImage: $e", stackTrace: StackTrace.current);
    }
  }

  Future selectImageFromGallery() async {
    XFile? image = await picker.pickImage(
      source: ImageSource.gallery,
      imageQuality: 60,
    );
    if (image == null) {
      await CustomToast.showInfoToast(msg: "Please select image to draw");
    } else {
      if (callBacks != null) {
        String base64Data = base64Encode(await image.readAsBytes());
        await callBacks!.drawImage(base64Data: base64Data);
      }
    }
    notifyListeners();
  }
}
