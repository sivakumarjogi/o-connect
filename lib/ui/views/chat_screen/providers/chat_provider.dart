import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'dart:math';

import 'package:dio/dio.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';
import 'package:o_connect/core/enum/view_state_enum.dart';
import 'package:o_connect/core/models/auth_models/generate_token_o_connect_model.dart';
import 'package:o_connect/core/providers/base_provider.dart';
import 'package:o_connect/my_app.dart';
import 'package:o_connect/ui/utils/base_urls.dart';
import 'package:o_connect/ui/utils/custom_toast_helper/custom_toast.dart';
import 'package:o_connect/ui/views/chat_screen/chat_model/chat_model.dart';
import 'package:o_connect/ui/views/chat_screen/chat_repo/chat_repository.dart';
import 'package:o_connect/ui/views/chat_screen/chat_view/q_and_a_screen.dart';
import 'package:o_connect/ui/views/meeting/model/model.dart';
import 'package:o_connect/ui/views/meeting/providers/meeting_room_provider.dart';
import 'package:o_connect/ui/views/meeting/signaling/chat_socket.dart';
import 'package:o_connect/ui/views/meeting/signaling/hub_socket.dart';
import 'package:o_connect/ui/views/pip_views/pip_global_navigation.dart';
import 'package:o_connect/ui/views/webinar_details/webinar_details_provider/webinar_provider.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:provider/provider.dart';
import 'package:speech_to_text/speech_recognition_result.dart';
import 'package:speech_to_text/speech_to_text.dart';

import '../../../../core/file_encryption_helper.dart';
import '../../../../core/models/chat_model/chat_model.dart';
import '../../../../core/repository/file_upload_repository/file_upload_repository.dart';
import '../../../../core/service/api_helper/api_helper.dart';
import '../../../utils/images/images.dart';
import '../../meeting/providers/participants_provider.dart';
import '../../meeting/utils/meeting_utils_mixin.dart';

class ChatProvider extends BaseProvider with MeetingUtilsMixin {
  ChatApiRepository getChatDataRepository =
      ChatApiRepository(ApiHelper().oConnectDio, baseUrl: BaseUrls.chatBaseUrl);
  ChatApiRepository globalAccessForQAndARepository = ChatApiRepository(
      ApiHelper().oConnectDio,
      baseUrl: BaseUrls.globalAccessSetUrl);

  final SpeechToText speechToText = SpeechToText();

  List<ChatModel> listOfMessages = [];
  List<ChatModel> listOfQAndAMessages = [];
  List<ChatModel> listOfMessagesPrivate = [];
  List<ChatModel> listOfSelectedQAndAMessages = [];
  List<ChatModel> webinarQAndAMessagesList = [];
  List<ChatMessageModel> messagesList = [];
  List<HubUserData> participantsList = [];

  ChatMessageFlag chatMessageFlag = ChatMessageFlag.initial;
  ChatTabDataFlag chatTabDataFlag = ChatTabDataFlag.Group;

  bool isQAEnabled = false;
  bool isGroupChat = false;
  bool isQAndAChat = false;
  bool speechTextEnabled = false;
  bool speechIconActive = false;
  bool isReply = false;
  bool isAttach = false;
  bool isChatSpeakerList = false;

  int globalChatCount = 0;

  ChatModel? chatModel;
  late ChatSocket chatData;

  ScrollController? scrollController;
  TextEditingController textController = TextEditingController();
  TextEditingController searchControllerForSpeaker = TextEditingController();
  TextEditingController searchControllerForSpeakerChat =
      TextEditingController();

  String? isReplyMessage;
  String? isReplyMessageID;
  String? isEditMessageID;
  String? isEditReplyMessageID;
  String? chatSpeakerListId;
  int privateChatUserId = 0;

  int getGroupChatCount = 0;
  Map<String, dynamic>? getAllUsersCount;

  File? fileData;
  String? fileName;
  Completer<XFile?> completer = Completer<XFile?>();

  void clearData() async {
    chatMessageFlag = ChatMessageFlag.initial;
    chatTabDataFlag = ChatTabDataFlag.Other;
    textController.text = "";
    searchControllerForSpeaker.text = "";
    isAttach = false;
    isReply = false;
    isReplyMessageID = "";
    isReplyMessage = "";
    fileData = null;
    fileName = null;
    listOfMessages = [];
    listOfQAndAMessages = [];
    listOfMessagesPrivate = [];
    listOfSelectedQAndAMessages = [];
    // webinarQAndAMessagesList = [];
    messagesList = [];
    getGroupChatCount = 0;
    privateChatUserId = 0;
    speechIconActive = false;
    await speechToText.stop();
    // notifyListeners();
  }

  String fileType = "";

  String fileTypeUpdate(String? fileName) {
    fileName.toString().endsWith(".pdf")
        ? fileType = AppImages.pdf
        : fileName.toString().endsWith(".pptx")
            ? fileType = AppImages.ppt
            : fileName.toString().endsWith(".txt")
                ? fileType = AppImages.txt
                : fileName.toString().endsWith(".xls")
                    ? fileType = AppImages.xsl
                    : fileName.toString().endsWith(".xlsx")
                        ? fileType = AppImages.xsl
                        : fileType = AppImages.pdf;
    // notifyListeners();
    return fileType;
  }

  void listenForPermissions() async {
    final status = await Permission.microphone.status;
    switch (status) {
      case PermissionStatus.denied:
        requestForPermission();
        break;
      case PermissionStatus.granted:
        break;
      case PermissionStatus.limited:
        break;
      case PermissionStatus.permanentlyDenied:
        break;
      case PermissionStatus.restricted:
        break;
    }
  }

  Future<void> requestForPermission() async {
    await Permission.microphone.request();
  }

  void startSpeech() async {
    speechTextEnabled = await speechToText.initialize();
  }

  /// start speech
  void startListening() async {
    speechIconActive = true;
    notifyListeners();
    await speechToText.listen(
      onResult: onSpeechResult,
      // listenFor: const Duration(seconds: 5),
      localeId: "en_En",
      cancelOnError: true,
      partialResults: false,
      listenMode: ListenMode.confirmation,
    );
    notifyListeners();
  }

  /// stop speech
  void stopListening() async {
    speechIconActive = false;
    await speechToText.stop();
    notifyListeners();
  }

  /// speech end
  void onSpeechResult(SpeechRecognitionResult result) {
    speechIconActive = false;
    // getLastWords = result.recognizedWords ;

    print("kjgkjgjk ${result.recognizedWords}");
    textController.text = result.recognizedWords;
    notifyListeners();
  }

  void clearChatData() {
    speechIconActive = false;
    notifyListeners();
  }

  ///Save Chat Template
  Future<void> saveChatTemplate(String? messageType) async {
    try {
      var body = {"meeting_id": meeting.id, "type": messageType, "offset": 0};
      print("chat body ========${body}");
      var saveData = await getChatDataRepository.saveChatData(body);
      if (saveData['status'] == true) {
        print("========${saveData["data"]['url']}");
        if (saveData["data"]['url'] != null) {
          downloadAndSaveFile(saveData["data"]['url']);
        }
      }
    } on DioException {
      CustomToast.showErrorToast(msg: "Something went wrong");
    } catch (e) {
      CustomToast.showErrorToast(msg: "Something went wrong");
    }
  }

  Future<void> downloadAndSaveFile(String url) async {
    final response = await http.get(Uri.parse(url));

    if (response.statusCode == 200) {
      final directory = await getExternalStorageDirectory();
      final filePath = '${directory!.path}/file_${DateTime.now}.txt';

      File file = File(filePath);
      await file.writeAsBytes(response.bodyBytes);

      // Display a message or open the file manager
      // You can use plugins like `open_file` to open the file manager
      // or show a message using a SnackBar
      CustomToast.showSuccessToast(msg: "Chat data downloaded Successfully...");
      print('File downloaded and saved to: $filePath');
    } else {
      // Handle the error if the request fails
      print('Failed to download file. Status code: ${response.statusCode}');
      CustomToast.showErrorToast(msg: "Failed to download file");
    }
  }

  ///File up load
  Future<void> fileUpload(BuildContext context) async {
    isAttach = true;
    notifyListeners();
    FilePickerResult? result = await FilePicker.platform
        .pickFiles(type: FileType.any, allowMultiple: false);

    File originalVideoFile;

    if (result != null && result.files.isNotEmpty) {
      originalVideoFile = File(result.files.single.path!);

      int sizeInBytes = originalVideoFile.lengthSync();
      double sizeInMb = sizeInBytes / (1024 * 1024);
      if (sizeInMb > 5) {
        // This file is Longer than 5 mb so we are restricting
        CustomToast.showErrorToast(msg: "File is larger than 5 MB");
      } else {
        fileName = result.files.first.name;
        fileData = originalVideoFile;
      }

      notifyListeners();
    }
  }

  Future fileUploadService(File file, context, names, String message,
      String messageCommand, String? messageType) async {
    var getOesUserDetails =
        Provider.of<MeetingRoomProvider>(context, listen: false).userHeaderInfo;
    String? contentType;
    print("doifhsduffhifds $names");
    if (names.toString().endsWith(".pdf")) {
      contentType = "application/pdf";
    } else if (names.toString().endsWith(".txt")) {
      contentType = "text/plain";
    } else if (names.toString().endsWith(".png")) {
      contentType = "image/png";
    } else if (names.toString().endsWith(".webp")) {
      contentType = "image/webp";
    } else if (names.toString().endsWith(".jpeg")) {
      contentType = "image/jpeg";
    } else if (names.toString().endsWith(".pptx")) {
      contentType =
          "application/vnd.openxmlformats-officedocument.presentationml.presentation";
    } else if (names.toString().endsWith(".xls")) {
      contentType = "application/vnd.ms-excel";
    } else if (names.toString().endsWith(".xlsx")) {
      contentType =
          "application/vnd.openxmlformats-officedocument.spreadsheetml.sheet";
    } else {
      contentType = "image/jpeg";
    }

    String fileHeader = getFileHeader(file);

    var meetingId = meeting.id.toString();
    var userId = userData.id.toString();
    try {
      FileUploadRepository fileUploadRepository = FileUploadRepository(
        baseUrl: BaseUrls.libraryBaseUrl,
        dio: ApiHelper().oConnectDio,
      );
      var uploadFilesModel = await fileUploadRepository.uploadFile(
          file: file,
          userId: userId,
          userInfo: fileHeader,
          purpose: "Chat",
          meetingId: meetingId,
          contentType: contentType);

      if (uploadFilesModel?.status == false) return;

      var body = {
        "from_user": userData.userFirstName,
        "from_user_id": userData.id,
        "message": message,
        "meeting_id": meetingId,
        "is_chat_active": 1,
        "ppic": "${BaseUrls.imageUrl}${getOesUserDetails.data?.profilePic}",
        "type": messageType,
        "message_type": "file",
        "reply_chat_id": null,
        "roleType": myHubInfo.role,
        "file_name": names.toString(),
        "file_size": uploadFilesModel!.data?.fileSize.toString(),
        "file_type": uploadFilesModel.data?.fileType.toString(),
        "url": uploadFilesModel.data?.readUrl.toString()
      };
      var chatResponse = await getChatDataRepository.createChat(
        body,
      );
      Map<String, dynamic> privateMessage = {
        "from_user": userData.userFirstName,
        "from_user_id": userData.id,
        "message": message,
        "meeting_id": meetingId,
        "to_user_id": privateChatUserId,
        "message_from": chatResponse['data']['roleType'],
        "read": false,
        "is_chat_active": 1,
        "ppic": "${BaseUrls.imageUrl}${getOesUserDetails.data?.profilePic}",
        "type": chatResponse['data']['type'],
        "message_type": chatResponse['data']['message_type'],
        "reply_chat_id": chatResponse['data']['reply_chat_id'],
        "roleType": myHubInfo.role,
        "file_name": chatResponse['data']['file_name'],
        "file_size": chatResponse['data']['file_size'],
        "file_type": chatResponse['data']['file_type'],
        "url": chatResponse['data']['url'],
        "_id": chatResponse['data']['_id'],
        "created_on": chatResponse['data']['created_on'],
        "updated_on": chatResponse['data']['updated_on'],
        "command": messageCommand
      };
      var socketBody = messageCommand == "Private"
          ? {"uid": privateChatUserId.toString(), "data": privateMessage}
          : {
              "uid": "ALL",
              "data": {
                "from_user": userData.userFirstName,
                "from_user_id": userData.id,
                "message": message,
                "meeting_id": meetingId,
                "is_chat_active": 1,
                "ppic":
                    "${BaseUrls.imageUrl}${getOesUserDetails.data!.profilePic}",
                "type": chatResponse['data']['type'],
                "message_type": chatResponse['data']['message_type'],
                "reply_chat_id": chatResponse['data']['reply_chat_id'],
                "roleType": myHubInfo.role,
                "file_name": chatResponse['data']['file_name'],
                "file_size": chatResponse['data']['file_size'],
                "file_type": chatResponse['data']['file_type'],
                "url": chatResponse['data']['url'],
                "_id": chatResponse['data']['_id'],
                "created_on": chatResponse['data']['created_on'],
                "updated_on": chatResponse['data']['updated_on'],
                "command": messageCommand
              }
            };
      if (chatResponse != null) {
        chatData.socket?.emitWithAck(
          "onChatCommand",
          jsonEncode(socketBody),
        );

        if (messageCommand == "Private") {
          chatModel = ChatModel.fromJson(privateMessage);
          listOfMessagesPrivate.add(chatModel!);
        }

        fileData = null;
        fileName = "";
        isAttach = false;
        textController.clear();
        isReply = false;
        isReplyMessageID = null;
        isReplyMessage = "";
        notifyListeners();
      }
    } on DioException catch (e) {
      CustomToast.showErrorToast(msg: "Invalid File Format");
      if (e.response?.data['status'] == false) {
        fileData = null;
        fileName = "";
        isAttach = false;
        textController.clear();
        isReply = false;
        isReplyMessageID = null;
        isReplyMessage = "";
        notifyListeners();
      }
      print("Error came ${e.response.toString()}");
    } catch (e, st) {
      print("Error came $st");
      print("Error came $e");
      CustomToast.showErrorToast(msg: "File upload failed");
    }
  }

  String getFileHeader(File file) {
    Uint8List fileContent = file.readAsBytesSync();
    print(fileContent.toString());
    List<int> arr = fileContent.toList().sublist(0, 20);
    print(arr.toString());
    String header = "";
    for (int index = 0; index < arr.length; index++) {
      header += arr[index].toRadixString(16);
    }
    String bits = header.toUpperCase().substring(0, 16);
    String fileHeader = FileEncryptionHelper.encryptAESCryptoJS(bits);
    return fileHeader;
  }

  static Future<XFile?> getImage(ImageSource source) async {
    XFile? pickedFile = await ImagePicker().pickImage(
      source: source,
    );
    if (pickedFile != null) {
      XFile imageFile = pickedFile;
      return imageFile;
      // return pickedFile.path;
    }
    return null;
  }

  /// selected Q and A Message
  Future<void> selectedMessages(ChatModel messageDetails) async {
    if (listOfSelectedQAndAMessages
        .any((element) => element.id == messageDetails.id)) {
      listOfSelectedQAndAMessages
          .removeWhere((element) => element.id == messageDetails.id);
    } else {
      listOfSelectedQAndAMessages.add(messageDetails);
      if (listOfSelectedQAndAMessages.length > 5) {
        // listOfSelectedQAndAMessages.removeLast();
        CustomToast.showErrorToast(msg: "You can select max up to five");
      }
    }
    notifyListeners();
  }

  Future<void> chatMessageFilter(String val) async {
    listOfMessages = listOfMessages.where((element) {
      return element.message
          .toString()
          .toLowerCase()
          .contains(val.toString().toLowerCase());
    }).toList();
    notifyListeners();
  }

  Future<void> chatParticipantsFilter(String val, BuildContext context) async {
    print("displayname ${val}");
    participantsList = participantsList.where((element) {
      print("displayname ${element.displayName}");
      return element.displayName
          .toString()
          .toLowerCase()
          .contains(val.toString().toLowerCase());
    }).toList();
    notifyListeners();
  }

  void getParticipantsList() {
    var getUser = context.read<MeetingRoomProvider>().userData;
    participantsList = context
        .read<ParticipantsProvider>()
        .speakers
        .where((element) => element.id != getUser.id)
        .toList();
  }

  Future<void> chatSpeakerMessageFilter(String val) async {
    listOfMessagesPrivate = listOfMessagesPrivate.where((element) {
      return element.message
          .toString()
          .toLowerCase()
          .contains(val.toString().toLowerCase());
    }).toList();
    notifyListeners();
  }

  Future<void> qAndAMessageFilter(String val) async {
    listOfQAndAMessages = listOfQAndAMessages.where((element) {
      return element.message
          .toString()
          .toLowerCase()
          .contains(val.toString().toLowerCase());
    }).toList();
    notifyListeners();
  }

  String oldMessageId = "";

  Future<void> chatSocketConnect(
      GenerateTokenUser userData, String meetingId, meeting) async {
    final chatBody = ChatSocketConnectionData(
      uid: userData.id!.toString(),
      roomId: meetingId,
    );
    chatData = ChatSocket(url: BaseUrls.chatSocketUrl);

    chatData.init(chatBody, meeting.token!);

    chatData.socket?.on("chatResponse", (data) {
      print("chatResponseeeee ${jsonDecode(data)['data']['from_user_id']}");
      chatModel = ChatModel.fromJson(jsonDecode(data)['data']);
      if (oldMessageId == jsonDecode(data)['data']['from_user_id'].toString() ||
          oldMessageId == "") {
        chatModel?.copyWith(isContinue: true);
      } else {
        chatModel?.copyWith(isContinue: false);
      }
      var isEdit = jsonDecode(data)['data']['is_edit'] ?? false;

      print("hello siva kumatr $chatTabDataFlag");

      if (jsonDecode(data)['data']['from_user_id'] != userData.id) {
        getGroupChatCount = getGroupChatCount + 1;
        print("message count $getGroupChatCount");
      } else {
        getGroupChatCount = 0;
      }
      notifyListeners();

      if (chatTabDataFlag != ChatTabDataFlag.QA &&
          chatModel!.type.toString() == "delete") {
        var id = jsonDecode(data)['data']['id'];

        chatTabDataFlag == ChatTabDataFlag.Group
            ? listOfMessages.removeWhere((element) {
                return element.id.toString() == id;
              })
            : listOfMessagesPrivate.removeWhere((element) {
                return element.id.toString() == id;
              });
      } else if (isEdit == true) {
        if (chatTabDataFlag == ChatTabDataFlag.QA) {
          listOfQAndAMessages = listOfQAndAMessages.map((element) {
            if (element.id.toString() == jsonDecode(data)['data']['_id']) {
              return element.copyWith(
                  message: chatModel!.message, isContinue: true);
            } else {
              return element;
            }
          }).toList();
        } else if (chatTabDataFlag == ChatTabDataFlag.Group) {
          listOfMessages = listOfMessages.map((element) {
            if (element.id.toString() == chatModel!.id.toString()) {
              return element.copyWith(message: chatModel!.message);
            } else {
              return element;
            }
          }).toList();
          notifyListeners();
        } else {
          listOfMessagesPrivate = listOfMessagesPrivate.map((element) {
            if (element.id.toString() == chatModel!.id.toString()) {
              return element.copyWith(
                message: chatModel!.message,
                replyChatId: chatModel!.replyChatId,
              );
            } else {
              return element;
            }
          }).toList();
          notifyListeners();
        }
      } else {
        var getQAndAMessage = jsonDecode(data)['data']['command'] ?? "";
        if (getQAndAMessage.toString().toLowerCase() == "group" &&
            jsonDecode(data)['data']['type'] == "groupChat") {
          // getGroupChatCount = getGroupChatCount + 1;
          listOfMessages.add(chatModel!);
          notifyListeners();
        } else if (getQAndAMessage.toString().toLowerCase() == "private" &&
            jsonDecode(data)['data']['type'] == "privateChat") {
          listOfMessagesPrivate.add(chatModel!);
        } else if (getQAndAMessage == "QAChat" ||
            getQAndAMessage == "UnPublishMsg" ||
            getQAndAMessage == "PublishMsg") {
          if (getQAndAMessage == "QAChat" &&
              jsonDecode(data)['data']['type'] == "questions") {
            listOfQAndAMessages.add(chatModel!);
          } else if (chatTabDataFlag == ChatTabDataFlag.QA &&
              getQAndAMessage == "QAChat" &&
              jsonDecode(data)['data']['type'] == "delete") {
            listOfQAndAMessages.removeWhere(
              (element) => element.id == jsonDecode(data)['data']['id'],
            );
          } else if (jsonDecode(data)['data']['command'] == "UnPublishMsg") {
            webinarQAndAMessagesList.removeWhere((element) {
              return element.chatId == jsonDecode(data)['data']['value']['id'];
            });
          } else if (jsonDecode(data)['data']['command'] == "PublishMsg" &&
              jsonDecode(data)['data']['value'] is Map) {
            if (webinarQAndAMessagesList.length >= 5) {
              webinarQAndAMessagesList.removeAt(0);
              webinarQAndAMessagesList
                  .add(ChatModel.fromJson(jsonDecode(data)['data']['value']));
            } else {
              webinarQAndAMessagesList
                  .add(ChatModel.fromJson(jsonDecode(data)['data']['value']));
            }
          } else {
            webinarQAndAMessagesList =
                (jsonDecode(data)['data']['value'] as List<dynamic>).map((e) {
              return ChatModel.fromJson(e);
            }).toList();
          }
        }
        oldMessageId = jsonDecode(data)['data']['from_user_id'].toString();
        notifyListeners();
      }

      if (chatTabDataFlag != ChatTabDataFlag.QA) {
        Timer(
            const Duration(milliseconds: 100),
            () => scrollController!
                .jumpTo(scrollController!.position.maxScrollExtent));
      }

      // if (scrollController!.hasClients) {
      //   scrollController!.animateTo(scrollController!.position.maxScrollExtent, duration: const Duration(milliseconds: 1), curve: Curves.fastOutSlowIn);
      // }

      notifyListeners();
    });

    chatData.connect();
  }

  void setupHubSocketListeners(BuildContext context) {
    final userData =
        navigationKey.currentContext!.read<MeetingRoomProvider>().userData;

    HubSocket.instance.socket?.on('commandResponse', (res) {
      final parsed = jsonDecode(res);
      final data = parsed['data'];

      if (data['command'] == 'globalAccess' &&
          data['type'] == 'activePage' &&
          data['value'] == 'QA' &&
          data['ou'] != userData.id &&
          myRole == UserRole.guest) {
        isQAEnabled = false;
        notifyListeners();
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (_) =>
                    const PIPGlobalNavigation(childWidget: QAndAScreen())));
      }
    });

    HubSocket.instance.socket?.on('panalResponse', (res) {
      final parsed = jsonDecode(res);
      final data = parsed['data'];

      if (data['command'] == 'AccessRestriction' && data['value'] == 'qna') {
        final action = data['feature']['action'];
        if (action == 'opened') {

          navigationKey.currentContext!
              .read<WebinarProvider>()
              .setActivePage(ActivePage.qna);
          navigationKey.currentContext!.read<WebinarProvider>().callNotify();
          isQAEnabled = true;
          Navigator.push(
              navigationKey.currentState!.context,
              MaterialPageRoute(
                  builder: (_) =>
                      const PIPGlobalNavigation(childWidget: QAndAScreen())));
          notifyListeners();
        } else if (action == 'removed') {
          navigationKey.currentContext!
              .read<WebinarProvider>()
              .setActivePage(ActivePage.audioVideo);
          navigationKey.currentContext!.read<WebinarProvider>().callNotify();
          isQAEnabled = false;
          notifyListeners();
        }
      }
    });
  }

  chatUpdate(updateData, index) {
    chatTabDataFlag = updateData;
    notifyListeners();
  }

  void setInitialQAList(List<ChatModel> l) {
    webinarQAndAMessagesList = [...l];
    isQAEnabled = true;
    notifyListeners();
  }

  Future<void> getQAndAHistoryData(context, String chatType) async {
    listOfQAndAMessages = [];
    isQAndAChat = true;
    var getMeetingDetails =
        Provider.of<MeetingRoomProvider>(context, listen: false).meeting;
    try {
      Response chatHistoryData = await getChatDataRepository.getChatHistory(
          getMeetingDetails.id.toString(), "questions", userData.id.toString());
      List chatData = chatHistoryData.data['data'];
      listOfQAndAMessages = chatData.map((e) => ChatModel.fromJson(e)).toList();
      isQAndAChat = false;
      notifyListeners();
    } on DioException {
      isQAndAChat = false;
      notifyListeners();
    } catch (e) {
      isQAndAChat = false;
      notifyListeners();
    }
  }

  Future<void> getChatHistoryData(context, String chatType) async {
    listOfMessages = [];
    isGroupChat = true;
    var getMeetingDetails =
        Provider.of<MeetingRoomProvider>(context, listen: false).meeting;
    try {
      Response chatHistoryData = await getChatDataRepository.getChatHistory(
          getMeetingDetails.id.toString(), chatType, userData.id.toString());
      print("chat data check ${chatHistoryData.data.toString()}");

      List chatData = chatHistoryData.data['data'];
      listOfMessages = chatData.map((e) => ChatModel.fromJson(e)).toList();
      scrollController!.animateTo(scrollController!.position.maxScrollExtent,
          duration: const Duration(milliseconds: 1),
          curve: Curves.fastOutSlowIn);

      isGroupChat = false;
      notifyListeners();
    } on DioException catch (err, st) {
      print("chat data check dio error ${err.toString()} --- ${st.toString()}");
      isGroupChat = false;
      notifyListeners();
    } catch (e) {
      isGroupChat = false;
      print("chat data check error ${e.toString()}");
      notifyListeners();
    }
  }

  /// Edit message
  Future editMessage(message) async {
    textController.text = message!.message;
    isEditMessageID = message!.id;
    isEditReplyMessageID = message!.replyChatId;
    notifyListeners();
  }

  Future chatMessageFlagUpdate(flagMessage) async {
    chatMessageFlag = flagMessage!;
    notifyListeners();
  }

  Future chatMessageTabUpdate(flagMessage) async {
    chatTabDataFlag = flagMessage!;
    notifyListeners();
  }

  Future<void> deleteChatMessage({
    required BuildContext context,
    required String messageId,
    required int fromUserId,
    required String meetingId,
    required int chatId,
  }) async {
    var body = {
      "_id": messageId,
      "from_user_id": fromUserId,
      "meeting_id": meetingId,
      "chat_id": chatId
    };

    try {
      var chatDeleteData = await getChatDataRepository.deleteChatMessage(body);
      if (chatDeleteData["status"] == true) {
        var deleteObject = {
          "uid": "ALL",
          "data": {
            "command": chatTabDataFlag == ChatTabDataFlag.Group
                ? "Group"
                : chatTabDataFlag == ChatTabDataFlag.Private
                    ? "Private"
                    : "QAChat",
            "type": "delete",
            "id": messageId.toString()
          }
        };

        chatData.socket?.emit(
          "onChatCommand",
          jsonEncode(deleteObject),
        );

        listOfMessages.removeWhere((element) {
          return element.id.toString() == messageId.toString();
        });
        notifyListeners();
      }
    } on DioException {}
  }

  void isChatLayoutChange(String speakerID, bool isChatSpeaker) {
    isChatSpeakerList = isChatSpeaker;
    chatSpeakerListId = speakerID;
    notifyListeners();
  }

  Future<void> updateChatStatus(context, currentUserId, chatUserId) async {
    var getMeetingDetails =
        Provider.of<MeetingRoomProvider>(context, listen: false).meeting;

    var body = {
      "to_user_id": chatUserId,
      "meeting_id": getMeetingDetails.id.toString(),
      "from_user_id": currentUserId
    };

    try {
      var chatHistoryData = await getChatDataRepository.updateChatStatus(body);
    } on DioException {}
  }

  var privateChatUserInfo;

  Future<void> getPrivateChatHistoryData(
      context, chatUserId, privateChatUserInfos) async {
    if (privateChatUserInfos != "") {
      privateChatUserInfo = privateChatUserInfos;
    }
    listOfMessagesPrivate = [];
    getAllUsersCount = null;
    privateChatUserId = int.parse(chatUserId);
    notifyListeners();
    var getMeetingDetails =
        Provider.of<MeetingRoomProvider>(context, listen: false).meeting;
    var getCurrentUserDetails =
        Provider.of<MeetingRoomProvider>(context, listen: false).userData;
    print(
        "dgjksdguihuidfh ${getCurrentUserDetails.id.toString()}  ${getMeetingDetails.id.toString()}   ${chatUserId}");
    try {
      Response chatHistoryData =
          await getChatDataRepository.getPrivateChatHistory(
        getCurrentUserDetails.id.toString(),
        getMeetingDetails.id.toString(),
        chatUserId.toString(),
      );

      print("dgjksdguihuidfh ${chatHistoryData.data.toString()}");
      List chatData = chatHistoryData.data['data'];

      listOfMessagesPrivate =
          chatData.map((e) => ChatModel.fromJson(e)).toList();
      notifyListeners();
    } on DioException catch (e) {
      print("dgjksdguihuidfh error dio${e.response.toString()}");
    } catch (e) {
      print("dgjksdguihuidfh error${e.toString()}");
    }
    notifyListeners();
  }

  Future<void> resetMessage(BuildContext context) async {
    isAttach = false;
    isReply = false;
    isReplyMessageID = "";
    isReplyMessage = "";
    fileData = null;
    notifyListeners();
  }

  Future<void> getChatCountsByMeetingId(
      context, String chatUserId, meetingId) async {
    try {
      var getUnReadCount = await getChatDataRepository.getChatCountsByMeetingId(
        meetingId,
        chatUserId,
        "privateChat",
      );

      getAllUsersCount = getUnReadCount.data["data"];

      notifyListeners();
    } on DioException {}
  }

  String formatBytes(bytes, int decimals) {
    int bytesData = bytes.toInt();
    if (bytesData <= 0) return "0 B";
    const suffixes = ["B", "KB", "MB", "GB", "TB", "PB", "EB", "ZB", "YB"];
    var i = (log(bytesData) / log(1024)).floor();
    return '${(bytesData / pow(1024, i)).toStringAsFixed(decimals)} ${suffixes[i]}';
  }

  String getVideoSizeFromBytes(String bytes, int decimals) {
    int bytesData = int.parse(bytes);
    if (bytesData <= 0) return "0 B";
    const suffixes = ["B", "KB", "MB", "GB", "TB", "PB", "EB", "ZB", "YB"];
    var i = (log(bytesData) / log(1024)).floor();
    return '${(bytesData / pow(1024, i)).toStringAsFixed(decimals)} ${suffixes[i]}';
  }

  messageHitMethod(
    chatType,
    BuildContext context,
    String? messageType,
  ) async {
    if (chatType == ChatTabDataFlag.Group &&
        chatMessageFlag == ChatMessageFlag.edit) {
      debugPrint("group and edit message ");
      await editChatMessage(
              context, messageType, isEditMessageID, textController.text)
          .then((value) {
        textController.text = "";
        chatMessageFlag = ChatMessageFlag.initial;
        chatTabDataFlag = ChatTabDataFlag.Group;
        notifyListeners();
      });
    } else if (chatType == ChatTabDataFlag.Group) {
      debugPrint("group message");
      isAttach
          ? await fileUploadService(
              fileData!,
              context,
              fileName,
              textController.text.trim(),
              "Group",
              messageType,
            ).then((value) {
              textController.text = "";
              isEditMessageID = "";
              fileData = null;
              fileName = "";
              chatMessageFlag = ChatMessageFlag.initial;
              notifyListeners();
            })
          : await sendMessageGroup(textController.text.trim(), context,
              isReplyMessageID, messageType, "Group");
      textController.text = "";
      chatTabDataFlag = ChatTabDataFlag.Group;
    } else if (chatType == ChatTabDataFlag.Private &&
        chatMessageFlag == ChatMessageFlag.edit) {
      debugPrint("Private and edit message");
      await editChatMessage(
              context, messageType, isEditMessageID, textController.text)
          .then((value) {
        textController.text = "";
        chatMessageFlag = ChatMessageFlag.initial;
        isEditMessageID = "";
        chatTabDataFlag = ChatTabDataFlag.Private;
        notifyListeners();
      });
    } else if (chatType == ChatTabDataFlag.Private) {
      debugPrint("Private  message $messageType");
      isAttach
          ? await fileUploadService(
              fileData!,
              context,
              fileName,
              textController.text.trim(),
              "Private",
              messageType,
            ).then((value) {
              textController.text = "";
              isEditMessageID = "";
              fileData = null;
              fileName = "";
              chatMessageFlag = ChatMessageFlag.initial;
              chatTabDataFlag = ChatTabDataFlag.Private;
              notifyListeners();
            })
          : await sendMessagePrivate(textController.text.trim(), context,
              isReplyMessageID, messageType, "Private");
      textController.text = "";
    } else if (chatType == ChatTabDataFlag.QA &&
        chatMessageFlag != ChatMessageFlag.edit) {
      await sendMessageQAndA(textController.text.trim(), context, "questions")
          .then((value) {
        textController.text = "";
        chatMessageFlag = ChatMessageFlag.initial;
        isEditMessageID = "";
        chatTabDataFlag = ChatTabDataFlag.QA;
        notifyListeners();
      });
    } else if (chatType == ChatTabDataFlag.QA &&
        chatMessageFlag == ChatMessageFlag.edit) {
      debugPrint("Q And A and edit message");
      await editChatMessage(
              context, messageType, isEditMessageID, textController.text)
          .then((value) {
        textController.text = "";
        chatMessageFlag = ChatMessageFlag.initial;
        isEditMessageID = "";
        chatTabDataFlag = ChatTabDataFlag.QA;
        notifyListeners();
      });
    }
  }

  Future<void> sendMessageGroup(
    String text,
    BuildContext context,
    replyChatId,
    String? messageType,
    String? messageCommand,
  ) async {
    var getMeetingDetails = context.read<MeetingRoomProvider>().meeting;
    var getUserDetails = context.read<MeetingRoomProvider>().userData;
    var getOesUserDetails = context.read<MeetingRoomProvider>().userHeaderInfo;
    var getRoleType = context.read<MeetingRoomProvider>().attendee;
    notifyListeners();
    var body = {
      "from_user": getUserDetails.userFirstName,
      "from_user_id": getUserDetails.id,
      "message": text.toString(),
      "meeting_id": getMeetingDetails.id.toString(),
      "is_chat_active": 1,
      "ppic": "${BaseUrls.imageUrl}${getOesUserDetails.data?.profilePic}",
      "type": messageType,
      "message_type": "text",
      "reply_chat_id": replyChatId,
      "roleType": getRoleType.roleType.toString(),
    };

    try {
      var chatResponse = await getChatDataRepository.createChat(
        body,
      );

      var groupMessage = {
        "from_user": chatResponse['data']['from_user'],
        "from_user_id": chatResponse['data']['from_user_id'],
        "message": text.toString(),
        "meeting_id": getMeetingDetails.id.toString(),
        "is_chat_active": 1,
        "ppic": "${BaseUrls.imageUrl}${getOesUserDetails.data?.profilePic}",
        "type": chatResponse['data']['type'],
        "message_type": "text",
        "reply_chat_id": chatResponse['data']['reply_chat_id'],
        "roleType": getRoleType.roleType.toString(),
        "created_on": chatResponse['data']['created_on'],
        "_id": chatResponse['data']['_id'],
        "command": messageCommand
        // "command": chatResponse['data']['command']
      };
      if (chatResponse != null) {
        var dataChatObject = {"uid": "ALL", "data": groupMessage};
        chatData.socket?.emitWithAck(
          "onChatCommand",
          jsonEncode(dataChatObject),
        );
        textController.clear();
        isReply = false;
        isReplyMessageID = null;
        isReplyMessage = "";
        notifyListeners();
      }
    } on DioException catch (e) {
      print(e.response.toString());
    } catch (e) {
      print(e.toString());
    }

    notifyListeners();
  }

  Future<void> sendMessagePrivate(
    String text,
    BuildContext context,
    replyChatId,
    String? messageType,
    String? messageCommand,
  ) async {
    var getMeetingDetails = context.read<MeetingRoomProvider>().meeting;
    var getUserDetails = context.read<MeetingRoomProvider>().userData;
    var getOesUserDetails = context.read<MeetingRoomProvider>().userHeaderInfo;
    var getRoleType = context.read<MeetingRoomProvider>().attendee;
    var body = {
      "from_user": getUserDetails.userFirstName,
      "from_user_id": getUserDetails.id,
      "message": text.toString(),
      "meeting_id": getMeetingDetails.id.toString(),
      "is_chat_active": 1,
      "index": listOfMessagesPrivate.length,
      "ppic": "${BaseUrls.imageUrl}${getOesUserDetails.data?.profilePic}",
      "type": messageType,
      "message_type": "text",
      "reply_chat_id": isReplyMessageID.toString(),
      "roleType": getRoleType.roleType.toString(),
      "to_user_id": int.parse(privateChatUserId.toString()),
      "read": false,
      "message_from": getRoleType.roleType.toString().toLowerCase(),
    };

    try {
      var chatResponse = await getChatDataRepository.createChat(
        body,
      );

      var privateMessage = {
        "from_user": chatResponse['data']['from_user'],
        "from_user_id": chatResponse['data']['from_user_id'],
        "message": text.toString(),
        "meeting_id": getMeetingDetails.id.toString(),
        "is_chat_active": 1,
        "ppic": "${BaseUrls.imageUrl}${getOesUserDetails.data?.profilePic}",
        "type": chatResponse['data']['type'],
        "message_type": "text",
        "reply_chat_id": chatResponse['data']['reply_chat_id'],
        "roleType": getRoleType.roleType.toString(),
        "created_on": chatResponse['data']['created_on'],
        "updated_on": chatResponse['data']['updated_on'],
        "to_user_id": int.parse(privateChatUserId.toString()),
        "read": false,
        "message_from": getRoleType.roleType.toString(),
        "_id": chatResponse['data']['_id'],
        "command": messageCommand,
      };
      if (chatResponse != null) {
        var dataChatObject = {
          "uid": privateChatUserId,
          "data": privateMessage,
        };
        chatData.socket?.emitWithAck(
          "onChatCommand",
          jsonEncode(dataChatObject),
        );
        chatModel = ChatModel.fromJson(privateMessage);

        // if(chatMessageFlag== ChatMessageFlag.edit){
        //   listOfMessagesPrivate.map((e) {
        //     if(e.id.toString() == chatResponse['data']['_id'].toString()){
        //       return chatModel.co
        //     }
        //   });
        //
        // }else{
        listOfMessagesPrivate.add(chatModel!);

        // }
        textController.clear();
        isReply = false;
        isReplyMessageID = null;
        isReplyMessage = "";
        Timer(
            Duration(milliseconds: 100),
            () => scrollController!
                .jumpTo(scrollController!.position.maxScrollExtent));
        notifyListeners();
      }
    } on DioException catch (e) {
      print(e.response.toString());
    } catch (e) {
      print(e.toString());
    }

    notifyListeners();
  }

  Future<void> sendMessageQAndA(
    String text,
    BuildContext context,
    String? messageType,
  ) async {
    var getMeetingDetails = context.read<MeetingRoomProvider>().meeting;
    var getUserDetails = context.read<MeetingRoomProvider>().userData;
    var getOesUserDetails = context.read<MeetingRoomProvider>().userHeaderInfo;
    var getRoleType = context.read<MeetingRoomProvider>().attendee;
    notifyListeners();
    var body = {
      "from_user": getUserDetails.userFirstName,
      "from_user_id": getUserDetails.id,
      "message": text.toString(),
      "meeting_id": getMeetingDetails.id.toString(),
      "is_chat_active": 1,
      "ppic": "${BaseUrls.imageUrl}${getOesUserDetails.data?.profilePic}",
      "type": messageType,
      "message_type": "text",
      "reply_chat_id": null,
      "roleType": getRoleType.roleType.toString(),
    };

    try {
      var chatResponse = await getChatDataRepository.createChat(
        body,
      );

      var groupMessage = {
        "from_user": chatResponse['data']['from_user'],
        "from_user_id": chatResponse['data']['from_user_id'],
        "message": text.toString(),
        "meeting_id": getMeetingDetails.id.toString(),
        "is_chat_active": 1,
        "ppic": "${BaseUrls.imageUrl}${getOesUserDetails.data?.profilePic}",
        "type": chatResponse['data']['type'],
        "message_type": "text",
        "reply_chat_id": null,
        "roleType": getRoleType.roleType.toString(),
        "created_on": chatResponse['data']['created_on'],
        "_id": chatResponse['data']['_id'],
        "command": "QAChat"
        // "command": chatResponse['data']['command']
      };
      if (chatResponse != null) {
        var dataChatObject = {"uid": "ALL", "data": groupMessage};
        chatData.socket?.emitWithAck(
          "onChatCommand",
          jsonEncode(dataChatObject),
        );
        textController.clear();
        isReply = false;
        isReplyMessageID = null;
        isReplyMessage = "";
        notifyListeners();
      }
    } on DioException catch (e) {
      print(e.response.toString());
    } catch (e) {
      print(e.toString());
    }

    notifyListeners();
  }

  Future<void> publishQAndA(BuildContext context, message) async {
    var meetingData = context.read<MeetingRoomProvider>().meeting;
    var getOesUserDetails = context.read<MeetingRoomProvider>().userHeaderInfo;
    var getUserDetails = context.read<MeetingRoomProvider>().userData;

    List selectedData = listOfSelectedQAndAMessages.map((e) {
      return {
        "id": e.id,
        "message": e.message,
        "userName": getUserDetails.userFirstName,
        "publish": true,
        "roleType": meetingData.roomType,
        "userProfile":
            "${BaseUrls.imageUrl}${getOesUserDetails.data?.profilePic}"
      };
    }).toList();

    var body = {
      "uid": "ALL",
      "data": {
        "command": "PublishMsg",
        "value": message == "" || message == null
            ? selectedData
            : {
                "id": message.id,
                "message": message.message.toString(),
                "userName": getUserDetails.userFirstName,
                "publish": true,
                "roleType": meetingData.roomType,
                "userProfile":
                    "${BaseUrls.imageUrl}${getOesUserDetails.data?.profilePic}"
              },
        "meeting_id": meetingData.id,
        "user_id": getUserDetails.id
      }
    };
    chatData.socket?.emitWithAck(
      "onChatCommand",
      jsonEncode(body),
    );
    // webinarQAndAMessagesList.isEmpty?:

    // webinarQAndAMessagesList.any((element) => element.chatId == message.id)?
    // chatData.socket?.emitWithAck(
    //   "onChatCommand",
    //   jsonEncode(body),
    // ):CustomToast.showErrorToast(msg: "odlkjhfjhlkfhljhjlh");

    notifyListeners();
  }

  Future<void> editChatMessage(BuildContext context, String? messageType,
      messageId, String message) async {
    var body = {
      "is_edit": true,
      "message": message,
      "reply_chat_id": isEditReplyMessageID,
      "meeting_id": meeting.id.toString(),
      "type": messageType,
      "_id": messageId
    };
    print("iofvhivijhighdkghk  $body");

    try {
      var editResponse = await getChatDataRepository.updateChat(body);

      print("iofvhivijhighdkghk  ${editResponse.toString()}");

      var socketBody = {
        "uid": "ALL",
        "data": {
          "_id": messageId,
          "message": message,
          "is_edit": true,
          "reply_chat_id": isEditReplyMessageID,
          "type": messageType,
          "command": chatTabDataFlag == ChatTabDataFlag.Group
              ? "Group"
              : chatTabDataFlag == ChatTabDataFlag.Private
                  ? "Private"
                  : "QAChat"
        }
      };
      textController.text = "";
      print("dfgdujffdsufddfhgsfiu $socketBody");
      chatData.socket?.emitWithAck(
        "onChatCommand",
        jsonEncode(socketBody),
      );

      textController.text = "";
      notifyListeners();
    } on DioException catch (e) {
      debugPrint("edit chat message error DioException ${e.response} ");
    } catch (e) {
      debugPrint("edit chat message error  catch$e ");
    }
  }

  Future<void> reSendMessage(
    BuildContext context,
    messageDetails,
  ) async {
    isReply = true;
    isReplyMessage = messageDetails.messageType == "file"
        ? messageDetails.fileName.toString()
        : messageDetails.message.toString();
    isReplyMessageID = messageDetails.id;

    notifyListeners();
  }

  Future<void> questionAndAnsMethod(BuildContext context) async {
    var meetingId = context.read<MeetingRoomProvider>().meeting.id.toString();
    var userId = context.read<MeetingRoomProvider>().userData.id.toString();
    var body = {
      "type": "pvwpqs",
      "feature": "qna",
      "action": "open",
      "meetingId": meetingId,
      "userId": userId,
      "role": 1
    };
    try {
      var questionAndAns =
          await globalAccessForQAndARepository.questionAndAnsSet(body);
      print("Q and A response ${body.toString()}");
      print("Q and A response ${questionAndAns['data'].toString()}");
      if (questionAndAns['data']['permission'] == true) {
        var body = {"roomId": meetingId, "key": "activePage", "value": "QA"};
        await context
            .read<MeetingRoomProvider>()
            .globalStatusRepo
            .updateGlobalAccessStatus(body);
        emitQAEnableOrDisableEvent(enable: true);
      }
    } on DioException catch (e) {
      debugPrint("Question and Ans Set Dio Error ${e.response.toString()}");
    } catch (e) {
      debugPrint("Question and Ans Set Error ${e.toString()}");
    }
  }

  void emitQAEnableOrDisableEvent({required bool enable}) {
    final meetingRoomProvider =
        navigationKey.currentContext!.read<MeetingRoomProvider>();
    final participantsProvider =
        navigationKey.currentContext!.read<ParticipantsProvider>();

    HubSocket.instance.socket?.emitWithAck(
      'onCommand',
      jsonEncode({
        'uid': 'ALL',
        'data': {
          'command': 'globalAccess',
          'type': 'activePage',
          'value': enable ? 'QA' : '',
          'ou': meetingRoomProvider.userData.id,
          'on': meetingRoomProvider.userData.userEmail,
        }
      }),
    );

    HubSocket.instance.socket?.emitWithAck(
      'onPanalCommand',
      jsonEncode({
        'uid': 'ALL',
        'data': {
          'command': 'AccessRestriction',
          'feature': {
            'message': enable ? 'opened' : 'removed',
            'action': enable ? 'opened' : 'removed',
          },
          'value': 'qna',
          'ou': meetingRoomProvider.userData.id,
          'on': meetingRoomProvider.userData.userEmail,
          'roleType': participantsProvider.myHubInfo.role,
        }
      }),
    );
  }

  Future<void> deleteQAnsAMessageDelete(
      BuildContext context, messageData) async {
    var userData = context.read<MeetingRoomProvider>().userData;
    var meetingData = context.read<MeetingRoomProvider>().meeting;
    var body = {
      "uid": "ALL",
      "data": {
        "command": "UnPublishMsg",
        "value": {"publish": false, "id": messageData},
        "meeting_id": meetingData.id,
        "user_id": userData.id
      }
    };
    chatData.socket?.emitWithAck(
      "onChatCommand",
      jsonEncode(body),
    );
    webinarQAndAMessagesList.removeWhere((element) {
      return element.chatId == messageData;
    });
    notifyListeners();
  }

  Future<void> questionAndAnsClose(BuildContext context) async {
    var meetingId = context.read<MeetingRoomProvider>().meeting.id.toString();
    var userId = context.read<MeetingRoomProvider>().userData.id.toString();
    var body = {
      "type": "pvwpqs",
      "feature": "qna",
      "action": "close",
      "meetingId": meetingId,
      "userId": userId,
      "role": 1
    };
    try {
      var questionAndAns =
          await globalAccessForQAndARepository.questionAndAnsSet(body);
      if (questionAndAns['status'] == true) {
        var body = {
          "key": "remove",
          "roomId": meetingId,
          "value": ["QAList"]
        };
        await context
            .read<MeetingRoomProvider>()
            .globalStatusRepo
            .updateGlobalAccessStatus(body);
        emitQAEnableOrDisableEvent(enable: false);
        webinarQAndAMessagesList = [];
      }
      notifyListeners();
    } on DioException catch (e) {
      debugPrint(
          "Question and Ans set close Dio Error ${e.response.toString()}");
    } catch (e) {
      debugPrint("Question and Ans set close Error ${e.toString()}");
    }
  }
}

class MessageModel {
  String message;
  bool isLeft;

  MessageModel(this.message, this.isLeft);
}
