import 'dart:convert';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:o_connect/core/providers/base_provider.dart';
import 'package:o_connect/core/service/download_files_service.dart';
import 'package:o_connect/ui/views/drawer/library_revamp/model/library_completed_files.dart';
import 'package:o_connect/ui/views/drawer/library_revamp/model/library_files_model.dart';
import 'package:o_connect/ui/views/meeting/utils/file_upload_mixin.dart';
import 'package:share_plus/share_plus.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:video_player/video_player.dart';

import '../../ui/utils/base_urls.dart';
import '../../ui/utils/custom_toast_helper/custom_toast.dart';
import '../../ui/views/drawer/library/meeting_history/recorded_files_popup.dart';
import '../models/auth_models/generate_token_o_connect_model.dart';
import '../models/library_model/library_meeting_history_model.dart';
import '../repository/library_repository/library_repo.dart';
import '../service/api_helper/api_helper.dart';
import '../service_locator.dart';
import '../user_cache_service.dart';

class LibraryProvider extends BaseProvider with WebinarFileUploadMixin {
  LibraryRepository libraryRepository = LibraryRepository(
      ApiHelper().oConnectDio,
      baseUrl: BaseUrls.libraryBaseUrl);
  LibraryRepository libraryTemplateRepo = LibraryRepository(
      ApiHelper().oConnectDio,
      baseUrl: BaseUrls.templateBaseUrl);
  LibraryRepository libraryTemplateSaved = LibraryRepository(
      ApiHelper().oConnectDio,
      baseUrl: BaseUrls.savedTemplate);

  List<LibraryMeetingHistoryDatum> finalUpdatedMeetingHistoryList = [];

  List<dynamic> finalUpdatedTemplateData = [];

  List<LibraryCompletedFilesModel> completedFiles = [];

  List<LibraryItem> presentationData = [];
  List<LibraryItem> presentationDataList = [];
  List<LibraryItem> finalUpdatedPresentationData = [];

  String recordingCount = "0";
  String presentationCount = "0";
  String videosCount = "0";
  String attachmentCount = "0";
  String screenShotCount = "0";
  bool isUpdateTemplateLoading = false;
  bool itemLoading = false;
  int selectRadioGroup = 1;
  String searchedTextValue = "";
  String startDate = DateFormat('dd MMM yyyy')
      .format(DateTime(
          DateTime.now().year, DateTime.now().month - 1, DateTime.now().day))
      .toString();
  String endDate = DateFormat('dd MMM yyyy').format(DateTime.now()).toString();
  DateTime? startPickedDate;
  String libraryDropdownSelectedItem = "Meeting History";
  int meetingHistoryPage = 1;
  int templatesPageNo = 1;
  String userId = "";
  bool hasTemplateNextPage = true;
  bool hasMeetingHistoryNextPage = true;

  bool isTemplateFirstLoadRunning = false;
  bool isPresentation = false;
  bool isMeetingHistoryFirstLoadRunning = false;
  VideoPlayerController? videoPlayerController;
  bool isTemplateLoadMoreRunning = false;
  bool isMeetingHistoryLoadMoreRunning = false;
  File? thumbnailConvertedFile;
  ScrollController meetingHistoryScrollController = ScrollController();
  ScrollController templatesScrollController = ScrollController();

  ///All initial fetch methods
  Future getLibraryHistoryDetails() async {
    await Future.wait([
      fetchMeetingHistoryFirstLoading(body: false),
      fetchTemplateFirstLoadRunning(),
      fetchPresentationDataDetails()
    ]);
  }

  updateSearchTextValue(String searchedValue) {
    searchedTextValue = searchedValue;
    notifyListeners();
  }

  TextEditingController searchController = TextEditingController();

  ///update library menu selected item
  updateLibraryDropdownItem(
      String newItem, TextEditingController searchController) {
    libraryDropdownSelectedItem = newItem;
    searchController.text = "";
    searchedTextValue = searchController.text;
    fetchMeetingHistoryFirstLoading(body: false);
    fetchTemplateFirstLoadRunning();
    notifyListeners();
  }

  openFileWithUrl(String path) async {
    await launchUrl(
      Uri.parse(path),
      mode: LaunchMode.externalNonBrowserApplication,
    );
  }

  Future getItemDetails(
      String nameOfEvent, String? meetingId, BuildContext context) async {
    presentationData = [];

    try {
      final String? userDataString =
          await serviceLocator<UserCacheService>().getUserData("userData");

      GenerateTokenUser userData =
          GenerateTokenUser.fromJson(jsonDecode(userDataString!));

      final response =
          await libraryRepository.fetchPresentation(meetingId!, nameOfEvent);
      // print(response.presentationData?.length);
      presentationData = response.data ?? [];
      if (context.mounted) {
        presentationData.isEmpty
            ? CustomToast.showErrorToast(msg: "No Records Found")
            : Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => RecordingFilesPopup(
                        presentationData: presentationData,
                        popUpName: nameOfEvent,
                        meetingId: meetingId)));
        // customShowDialog(context,
        //  RecordingFilesPopup(presentationData: presentationData, popUpName: nameOfEvent, meetingId: meetingId)
        //  );
      }
    } on DioException catch (e) {
      debugPrint("DioException ex    ${e.response.toString()}");
    } catch (e) {
      debugPrint("catch ex    ${e.toString()}");
    }
  }

  Future getCompletedItemDetails(
      {String? meetingId, required BuildContext context}) async {
    completedFiles = [];

    try {
      final String? userDataString =
          await serviceLocator<UserCacheService>().getUserData("userData");

      GenerateTokenUser userData =
          GenerateTokenUser.fromJson(jsonDecode(userDataString!));
      Map<String, dynamic> body = {
        "user_id": userData.id,
        "meeting_id": meetingId
      };
      print("completed files $body");
      String? oConnectToken =
          await serviceLocator<UserCacheService>().getOConnectToken();
      Map<String, dynamic> headers = {
        "Authorization": oConnectToken,
        "User-agent":
            "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/123.0.0.0 Safari/537.36"
      };
      final response = await libraryRepository.getCompletedItemDetails(
          meetingId!, userData.id!, headers);
      completedFiles = response.data as List<LibraryCompletedFilesModel>;
      print("kdhjjhfjh $completedFiles");

      if (context.mounted) {
        // presentationData.isEmpty
        //     ? CustomToast.showErrorToast(msg: "No Records Found")
        //     : Navigator.push(context, MaterialPageRoute(builder: (context) => RecordingFilesPopup(presentationData: presentationData, popUpName: nameOfEvent, meetingId: meetingId)));
        // customShowDialog(context,
        //  RecordingFilesPopup(presentationData: presentationData, popUpName: nameOfEvent, meetingId: meetingId)
        //  );
      }
    } on DioException catch (e, st) {
      debugPrint("DioException ex    ${e.response.toString()}");
      debugPrint("DioException ex    ${st.toString()}");
    } catch (e, st) {
      debugPrint("catch ex    ${e.toString()}");
      debugPrint("catch ex    ${st.toString()}");
    }
  }

  void shareNetworkImage(String url) async {
    Share.share(url);
  }

  Future<String> fileDownloadLocal(
    url,
    name,
  ) async {
    HttpClient httpClient = HttpClient();
    File file;
    String filePath = '';
    String myUrl = '';

    print(url.toString());
    final getPath = await createFolder();
    var nameEnd = url.split(".").last;

    print(nameEnd.toString());
    try {
      myUrl = url;
      // final excelFile = await Dio().download(myUrl, getPath);
      print("the url is the $myUrl");
      var request = await httpClient.getUrl(Uri.parse(url));

      var response = await request.close();
      print(response);
      if (response.statusCode == 200) {
        var bytes = await consolidateHttpClientResponseBytes(
          response,
          onBytesReceived: (cumulative, total) {
            if (total != null) {
              /*  var progress = cumulative / total;
              var actualProgress = (progress * 100).toInt();
              print("the progress $actualProgress"); */
            }
          },
        );

        filePath = '$getPath/$name.$nameEnd';
        file = File(filePath);
        file.writeAsBytes(bytes);
        CustomToast.showSuccessToast(msg: "File downloaded successfully");
      } else {
        filePath = 'Error code: ${response.statusCode}';
      }
    } catch (ex, st) {
      print("the error $ex && $st");
      CustomToast.showErrorToast(msg: "File format not supported");
      filePath = 'Can not fetch url';
    }

    return filePath;
  }

  Future fileDelete(String id, meetingId, nameOfEvent, context) async {
    itemLoading = true;
    notifyListeners();
    try {
      var res = await libraryRepository.deleteFile(id);
      if (res.statusCode == 200) {
        final response =
            await libraryRepository.fetchPresentation(meetingId!, nameOfEvent);

        presentationData = response.data ?? [];
        updateDeleteItemCount(nameOfEvent, presentationData.length);
        CustomToast.showSuccessToast(msg: "File successfully deleted");
        itemLoading = false;
      }
      debugPrint("ressssssss exception ${res.toString()}");
    } on DioException catch (e) {
      itemLoading = false;
      CustomToast.showErrorToast(msg: "File delete failed");
      debugPrint("dio exception ${e.response.toString()}");
    } catch (e) {
      itemLoading = false;
      debugPrint("dio exception ${e.toString()}");
    }
    notifyListeners();
  }

  updateDeleteItemCount(nameOfEvent, int length) {
    switch (nameOfEvent) {
      case "ScreenShot":
        screenShotCount = length.toString();
        notifyListeners();
        break;
      case "Chat":
        attachmentCount = length.toString();
        break;
      case "webinar-video":
        videosCount = length.toString();
        break;
      case "presentation":
        presentationCount = length.toString();
        break;
      case "Recordings":
        recordingCount = length.toString();
        break;
      default:
        screenShotCount = length.toString();
        notifyListeners();
    }
    notifyListeners();
  }

  updatePlayState(VideoPlayerController controller) {
    controller.value.isPlaying ? controller.pause() : controller.play();
    notifyListeners();
  }

  /// update radiobutton in share files
  updateRadioGroupValue(int value) {
    selectRadioGroup = value;
    notifyListeners();
  }

  updateStartDate(DateTime pickedDate) {
    startPickedDate = pickedDate;
    startDate = DateFormat('dd MMM yyyy').format(pickedDate).toString();
    getLibraryHistoryDetails();
    notifyListeners();
  }

  updateEndDate(DateTime pickedDate) {
    endDate = DateFormat('dd MMM yyyy').format(pickedDate).toString();
    getLibraryHistoryDetails();
    notifyListeners();
  }

  clearDates() {
    startDate = DateFormat('dd MMM yyyy')
        .format(DateTime(
            DateTime.now().year, DateTime.now().month - 1, DateTime.now().day))
        .toString();
    endDate = DateFormat('dd MMM yyyy').format(DateTime.now()).toString();
    startPickedDate = null;
  }

  updateSearchResults(String search) {
    fetchMeetingHistoryFirstLoading(body: false, searchedTextValue: search);
    fetchTemplateFirstLoadRunning();
    notifyListeners();
  }

  ///fetch meeting history with first page
  Future fetchMeetingHistoryFirstLoading(
      {required bool body,
      meetingHistoryPage = 1,
      isMeetingHistoryFirstLoadRunning = true,
      hasMeetingHistoryNextPage = true,
      String? searchedTextValue}) async {
    final String? userDataString =
        await serviceLocator<UserCacheService>().getUserData("userData");
    GenerateTokenUser userData =
        GenerateTokenUser.fromJson(jsonDecode(userDataString!));

    Map<String, dynamic> payload = body
        ? {
            "userId": userData.id,
            "itemsPerPage": 5,
            "page": 1,
          }
        : {
            "fromDate": DateFormat("yyyy-MM-dd")
                .format(DateTime.parse(
                    DateFormat("dd MMM yyyy").parse(startDate).toString()))
                .toString(),
            "itemsPerPage": 10,
            "page": meetingHistoryPage,
            "search": searchedTextValue,
            "toDate": DateFormat("yyyy-MM-dd")
                .format(DateTime.parse(
                    DateFormat("dd MMM yyyy").parse(endDate).toString()))
                .toString(),
            "userId": userData.id
          };
    try {
      final response = await libraryRepository.meetingHistory(payload);

      if (response.status == true) {
        isMeetingHistoryFirstLoadRunning = false;
        finalUpdatedMeetingHistoryList =
            response.libraryMeetingHistoryData ?? [];
      }
    } on DioException catch (e) {
      isMeetingHistoryFirstLoadRunning = false;
      debugPrint("fetchMeetingHistory DioException  ${e.response.toString()}");
    } catch (e, st) {
      isMeetingHistoryFirstLoadRunning = false;
      debugPrint("fetchMeetingHistory catch  ${e.toString()}");
      debugPrint("fetchMeetingHistory catch  ${st.toString()}");
    }
    notifyListeners();
  }

  ///fetch meeting history with load more pages
  Future fetchMeetingHistoryLoadMore() async {
    final String? userDataString =
        await serviceLocator<UserCacheService>().getUserData("userData");

    GenerateTokenUser userData =
        GenerateTokenUser.fromJson(jsonDecode(userDataString!));
    // if (hasMeetingHistoryNextPage == true && isMeetingHistoryFirstLoadRunning == false && isMeetingHistoryLoadMoreRunning == false && meetingHistoryScrollController.position.extentAfter < 300) {
    isMeetingHistoryLoadMoreRunning = true;
    // meetingHistoryPage += 1;
    Map<String, dynamic> payload = {
      "fromDate": DateFormat("yyyy-MM-dd")
          .format(DateTime.parse(
              DateFormat("dd MMM yyyy").parse(startDate).toString()))
          .toString(),
      "itemsPerPage": 10,
      "page": 1,
      "search": searchedTextValue,
      "toDate": DateFormat("yyyy-MM-dd")
          .format(DateTime.parse(
              DateFormat("dd MMM yyyy").parse(endDate).toString()))
          .toString(),
      "userId": userData.id
    };

    print("gygidufygidufyid $payload");
    try {
      final response = await libraryRepository.meetingHistory(payload);
      if (response.status == true) {
        isMeetingHistoryLoadMoreRunning = false;
        List<LibraryMeetingHistoryDatum> listData =
            response.libraryMeetingHistoryData ?? [];

        if (listData.isNotEmpty) {
          finalUpdatedMeetingHistoryList.addAll(listData);
        } else {
          hasMeetingHistoryNextPage = false;
        }
      }
    } on DioException catch (e) {
      isMeetingHistoryLoadMoreRunning = false;
      debugPrint(
          "fetchMeetingHistoryLoadMore DioException  ${e.response.toString()}");
    } catch (e) {
      isMeetingHistoryLoadMoreRunning = false;
      debugPrint("fetchMeetingHistoryLoadMore catch  ${e.toString()}");
    }
    notifyListeners();
    // }
  }

  ///fetch templates with first page
  Future fetchTemplateFirstLoadRunning({
    String searchedTextValue = '',
  }) async {
    templatesPageNo = 1;
    isTemplateFirstLoadRunning = true;
    hasTemplateNextPage = true;

    try {
      final response = await libraryTemplateSaved.fetchAllTemplates(
          templatesPageNo,
          10,
          searchedTextValue,
          DateFormat("yyyy-MM-dd")
              .format(DateTime.parse(
                  DateFormat("dd MMM yyyy").parse(startDate).toString()))
              .toString(),
          DateFormat('EEE, d MMM yyyy HH:mm:ss')
              .format(DateTime.parse(
                      DateFormat("dd MMM yyyy").parse(endDate).toString())
                  .add(const Duration(days: 1)))
              .toString());
      if (response.status == true) {
        isTemplateFirstLoadRunning = false;
        finalUpdatedTemplateData = response.data?[0] ?? [];
        print("res ponsjjn data $finalUpdatedTemplateData");
      }
    } on DioException catch (e) {
      isTemplateFirstLoadRunning = false;
      debugPrint(
          "fetchTemplateFirstLoadRunning DioException  ${e.response.toString()}");
    } catch (e) {
      isTemplateFirstLoadRunning = false;
      debugPrint("fetchTemplateFirstLoadRunning catch  ${e.toString()}");
    }
    notifyListeners();
  }

  ///fetch templates with load more pages
  Future fetchTemplateLoadMoreRunning() async {
    if (hasTemplateNextPage == true &&
        isTemplateFirstLoadRunning == false &&
        isTemplateLoadMoreRunning == false &&
        templatesScrollController.position.extentAfter < 300) {
      isTemplateLoadMoreRunning = true;
      templatesPageNo += 1;
      try {
        final response = await libraryTemplateRepo.fetchAllTemplates(
            templatesPageNo,
            10,
            searchedTextValue,
            DateFormat("yyyy-MM-dd")
                .format(DateTime.parse(
                    DateFormat("dd MMM yyyy").parse(startDate).toString()))
                .toString(),
            DateFormat('EEE, d MMM yyyy HH:mm:ss')
                .format(DateTime.parse(
                        DateFormat("dd MMM yyyy").parse(endDate).toString())
                    .add(const Duration(days: 1)))
                .toString());
        if (response.status == true) {
          isTemplateLoadMoreRunning = false;
          List<dynamic> templateDataList = response.data?[0] ?? [];
          if (templateDataList.isNotEmpty) {
            finalUpdatedTemplateData.addAll(templateDataList);
          } else {
            hasTemplateNextPage = false;
          }
        }
      } on DioException catch (e) {
        isTemplateLoadMoreRunning = false;
        debugPrint(
            "fetchTemplateLoadMoreRunning DioException  ${e.response.toString()}");
      } catch (e) {
        isTemplateLoadMoreRunning = false;
        debugPrint("fetchTemplateLoadMoreRunning catch  ${e.toString()}");
      }
      notifyListeners();
    }
  }

  ///Fetch presentation details
  Future fetchPresentationDataDetails() async {
    isPresentation = true;
    final String? userDataString =
        await serviceLocator<UserCacheService>().getUserData("userData");

    GenerateTokenUser userData =
        GenerateTokenUser.fromJson(jsonDecode(userDataString!));
    try {
      final response = await libraryRepository.fetchPresentation(
          "${userData.id ?? 0}", "presentation");
      if (response.status == true) {
        isPresentation = false;
        presentationDataList = response.data ?? [];
        finalUpdatedPresentationData = presentationDataList;
      }
    } on DioException catch (e) {
      isPresentation = false;
      debugPrint(
          "fetchPresentationFirstLoadRunning DioException  ${e.response.toString()}");
    } catch (e) {
      isPresentation = false;
      debugPrint("fetchPresentationFirstLoadRunning catch  ${e.toString()}");
    }
    notifyListeners();
  }

  ///Presentation File Picker
  Future filePicker() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      allowedExtensions: [
        "png",
        "jpeg",
        "jpg",
        "pdf",
        "txt",
        "doc",
        "docx",
        "xsl",
        "ppt",
        "xlsx",
        "pptx"
      ],
      type: FileType.custom,
      allowMultiple: false,
    );

    if (result != null) {
      print(
          "the results are the ${result.files.first.path} && ${result.files.first.name}");

      for (LibraryItem element in finalUpdatedPresentationData) {
        if (result.files.first.name == element.fileName) {
          CustomToast.showErrorToast(
              msg: "Duplicate file names are not allowed");
          return;
        }

        List imageFiles = finalUpdatedPresentationData
            .where((e) =>
                e.fileName!.endsWith(".png") ||
                e.fileName!.endsWith(".jpg") ||
                e.fileName!.endsWith(".jpeg"))
            .toList();
        if (imageFiles.length >= 5) {
          CustomToast.showErrorToast(
              msg:
                  "You can upload upto maximum five files and 50MB of Size for each type");
          return;
        }

        List pdfFiles = finalUpdatedPresentationData
            .where((e) => e.fileName!.endsWith("pdf"))
            .toList();
        if (pdfFiles.length >= 5) {
          CustomToast.showErrorToast(
              msg:
                  "You can upload upto maximum five files and 50MB of Size for each type");
          return;
        }
        List docxList = finalUpdatedPresentationData
            .where((e) =>
                e.fileName!.endsWith(".docx") || e.fileName!.endsWith(".doc"))
            .toList();
        if (docxList.length >= 5) {
          CustomToast.showErrorToast(
              msg:
                  "You can upload upto maximum five files and 50MB of Size for each type");
          return;
        }
        List pptList = finalUpdatedPresentationData
            .where((e) =>
                e.fileName!.endsWith(".pptx") || e.fileName!.endsWith(".ppt"))
            .toList();
        if (pptList.length >= 5) {
          CustomToast.showErrorToast(
              msg:
                  "You can upload upto maximum five files and 50MB of Size for each type");
          return;
        }
        List textFiles = finalUpdatedPresentationData
            .where((e) => e.fileName!.endsWith(".txt"))
            .toList();
        if (textFiles.length >= 5) {
          CustomToast.showErrorToast(
              msg:
                  "You can upload upto maximum five files and 50MB of Size for each type");
          return;
        }
      }

      try {
        final String? userDataString =
            await serviceLocator<UserCacheService>().getUserData("userData");
        GenerateTokenUser userData =
            GenerateTokenUser.fromJson(jsonDecode(userDataString!));

        final response = await uploadFile(
          file: File(result.files.first.path!),
          userId: userData.id.toString(),
          purpose: "presentation",
          meetingId: '',
        );
        if (response?.status == true) {
          fetchPresentationDataDetails();
          CustomToast.showSuccessToast(msg: "File Uploaded Successfully");
        }
      } on DioException catch (e) {
        CustomToast.showErrorToast(msg: "${e.response!.data['error']}");
        debugPrint("file uploading DioException  ${e.response.toString()}");
      } catch (e) {
        debugPrint("file uploading catch  ${e.toString()}");
      }
    }
    notifyListeners();
  }

  ///Delete presentation
  Future deletePresentation(String id, BuildContext context) async {
    try {
      final response = await libraryRepository.deletePresentationItem(id);
      if (response.status == true) {
        Navigator.pop(context);
        CustomToast.showSuccessToast(msg: "File deleted successfully");
        fetchPresentationDataDetails();
      }
    } on DioException catch (e) {
      Navigator.pop(context);
      CustomToast.showSuccessToast(msg: "File not deleted");
      debugPrint("deletePresentation DioException  ${e.response.toString()}");
    } catch (e) {
      Navigator.pop(context);
      debugPrint("deletePresentation catch  ${e.toString()}");
    }
    notifyListeners();
  }

  ///Update template Name (Edit)
  Future updateTemplate(
      {required String templateName,
      required String templateID,
      required BuildContext context}) async {
    // isUpdateTemplateLoading = true;
    final String? userDataString =
        await serviceLocator<UserCacheService>().getUserData("userData");

    GenerateTokenUser userData =
        GenerateTokenUser.fromJson(jsonDecode(userDataString!));
    Map<String, dynamic> payload = {
      "name": templateName,
      "template_id": templateID,
      "user_id": userData.id
    };
    try {
      final response = await libraryTemplateRepo.updateTemplateName(payload);
      if (response.status == true) {
        // isUpdateTemplateLoading = false;
        if (context.mounted) {
          Navigator.pop(context);
        }
        fetchTemplateFirstLoadRunning();
        CustomToast.showSuccessToast(
            msg: "Template Details Updated Successfully");
      }
    } on DioException catch (e) {
      // isUpdateTemplateLoading = false;
      CustomToast.showErrorToast(msg: "${e.response!.data['message']}");
      debugPrint("updateTemplate DioException  ${e.response.toString()}");
    } catch (e) {
      // isUpdateTemplateLoading = false;
      debugPrint("updateTemplate catch  ${e.toString()}");
    }
    notifyListeners();
  }

  ///Delete template
  Future deleteParticularTemplate(
      {required String templateID,
      required BuildContext context,
      required int userId}) async {
    Map<String, dynamic> payload = {
      "from_user_id": userId,
      "template_delete_flag": 0,
      "template_id": templateID
    };
    try {
      final response = await libraryTemplateRepo.deleteTemplate(payload);
      if (response.status == true) {
        CustomToast.showSuccessToast(msg: "Template Deleted Successfully")
            .then((value) {
          if (context.mounted) {
            Navigator.pop(context);
            Navigator.pop(context);
          }
          return fetchTemplateFirstLoadRunning();
        });
      }
    } on DioException catch (e) {
      debugPrint("Delete template DioException  ${e.response.toString()}");
    } catch (e) {
      debugPrint("Delete template catch  ${e.toString()}");
    }
    notifyListeners();
  }

  ///Presentation Search
  localSearchForPresentation(String searchedText) {
    finalUpdatedPresentationData = [];
    if (searchedText.length > 2) {
      for (var element in presentationDataList) {
        if (element.fileName!.toLowerCase().contains(searchedText)) {
          finalUpdatedPresentationData.add(element);
        }
      }
      // finalUpdatedPresentationData.addAll(presentationDataList.where((element) => element.fileName.toString().toLowerCase() == searchedText).toList());
      notifyListeners();
      return;
    }
    if (searchedText.isEmpty) {
      finalUpdatedPresentationData = presentationDataList;
      notifyListeners();
      return;
    }
    if (searchedText.isNotEmpty) {
      finalUpdatedPresentationData = presentationDataList;
      notifyListeners();
      return;
    }
  }
}

class LibraryWidget {
  String? name;
  String? image;

  LibraryWidget({this.image, this.name});
}
