import 'dart:convert';
import 'dart:io';
import 'package:dio/dio.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:mime/mime.dart';
import 'package:o_connect/core/enum/view_state_enum.dart';
import 'package:o_connect/core/models/library_model/presentation_upload_files_model.dart';
import 'package:o_connect/core/providers/base_provider.dart';
import 'package:o_connect/core/repository/file_upload_repository/file_upload_repository.dart';
import 'package:o_connect/core/service/api_helper/api_helper.dart';
import 'package:o_connect/core/service/download_files_service.dart';
import 'package:o_connect/ui/utils/base_urls.dart';
import 'package:o_connect/ui/utils/custom_toast_helper/custom_toast.dart';
import 'package:o_connect/ui/utils/loading_helper/loading_indicator.dart';
import 'package:o_connect/ui/views/drawer/library_revamp/library_revamp_provider.dart';
import 'package:o_connect/ui/views/meeting/utils/meeting_utils_mixin.dart';
import 'package:o_connect/ui/views/share_files/share_files_speaker_view.dart';
import 'package:open_file/open_file.dart';
import 'package:provider/provider.dart';

class ShareFilesProvider extends BaseProvider with MeetingUtilsMixin {
  ShareFilesRadioButtons selectedFileType = ShareFilesRadioButtons.all;
  String? pickedFile;
  String? shareFileDownloadUrl;
  bool showDownloadPopUp = false;
  String? fileName;

  void updateSelectedRaioButtonOption(ShareFilesRadioButtons fileType) {
    selectedFileType = fileType;
    notifyListeners();
  }

  Future<String?> pickFile() async {
    List<PlatformFile>? files;
    XFile? imageFile;
    files = await context.read<LibraryRevampProvider>().getFile(allowedExtension: ["pdf", "docx", "doc", "pptx", "xlsx", "png", "jpg", "jpeg", "webp"]);

    if (files.isNotEmpty) {
      debugPrint("the file size is the ${files.first.size} && ${files.first.size / (1024 * 1024)}");
      double fileSizeInMb = files.first.size / (1024 * 1024);
      if (fileSizeInMb > 50) {
        CustomToast.showErrorToast(msg: "The maximum file size is 50 MB");
        return null;
      } else {
        pickedFile = files.first.path!;
        notifyListeners();
        return files.first.path;
      }
    } else {
      await CustomToast.showInfoToast(msg: "Please select file");
    }
    return null;
  }

  void setShareFilesSocketListners() {
    hubSocket.socket!.on("commandResponse", (res) {
      final data = jsonDecode(res) as Map<String, dynamic>;
      final value = data['data']['value'];
      final command = data['data']['command'];

      if (command == "FileDownload") {
        if (myHubInfo.id.toString() != value["user_id"].toString()) {
          shareFileDownloadUrl = value["readUrl"];
          debugPrint("the download link is the $value");
          fileName = value["file_name"];
          showDownloadPopUp = true;
          notifyListeners();
        }
      }
    });

    hubSocket.socket!.on("panalResponse", (res) {
      final data = jsonDecode(res) as Map<String, dynamic>;
      final value = data['data']['value'];
      final command = data['data']['command'];

      if (command == "FileDownload") {
        if (myHubInfo.id.toString() != value["user_id"].toString()) {
          shareFileDownloadUrl = value["readUrl"];
          fileName = value["file_name"];
          showDownloadPopUp = true;
          notifyListeners();
        }
      }
    });
  }

  void showDownloadProgress(received, total) {
    if (total != -1) {
      debugPrint((received / total * 100).toStringAsFixed(0) + "% completed");
    }
  }

  void downloadSharedFile() async {
    String downloadPath = await createFolder();
    // await Dio().downloadUri(Uri.parse(shareFileDownloadUrl.toString()), downloadPath);
    debugPrint("the file url is the $shareFileDownloadUrl");
    Response response = await Dio().get(
      shareFileDownloadUrl.toString(),
      onReceiveProgress: showDownloadProgress,
      options: Options(
        responseType: ResponseType.bytes,
        followRedirects: false,
      ),
    );

    String fileName = shareFileDownloadUrl?.split("/").last ?? "";
    print(response.headers);
    File file = File(downloadPath + fileName);
    file.writeAsBytes(response.data);
    resetState();
    CustomToast.showDownloadToast(
      msg: "File download successfully",
      onTap: () {
        OpenFile.open(file.path, type: response.headers.map["content-type"]?.first);
      },
    );
  }

  void uploadFile() async {
    try {
      if (pickedFile != null) {
        File selectedFile = File(pickedFile!);
        String fileSize = (selectedFile.readAsBytesSync().length).toString();
        FileUploadRepository fileUploadRepository = FileUploadRepository(
          baseUrl: BaseUrls.libraryBaseUrl,
          dio: ApiHelper().oConnectDio,
        );
        Loading.indicator(context);
        String fileHeader = FileUploadRepository.getFileHeader(selectedFile);
        PresentationUploadFilesModel? filedata = await fileUploadRepository.uploadFile(
          userId: (userData.id ?? 0).toString(),
          meetingId: meeting.id.toString(),
          purpose: "promtfile",
          file: selectedFile,
          contentType: lookupMimeType(pickedFile!) ?? "",
          userInfo: fileHeader,
        );
        if (filedata?.status ?? false) {
          _emitCommandEvent(filedata!);
          CustomToast.showSuccessToast(msg: "File shared successflly").then((value) {
            Navigator.pop(context);
            Navigator.pop(context);
          });
        }
      } else {
        CustomToast.showErrorToast(msg: "Selecte File");
      }
    } on DioException catch (e, st) {
      Navigator.pop(context);
      CustomToast.showErrorToast(msg: "Error while share file");
      debugPrint("the Dio error while upload file ${e.error} && ${e.response} && $st");
    } catch (e, st) {
      Navigator.pop(context);
      CustomToast.showErrorToast(msg: "Error while share file");
      debugPrint("the error while upload file ${e.toString()} && $st");
    }
  }

  void _emitCommandEvent(PresentationUploadFilesModel fileData) {
    final data = {
      "uid": "ALL",
      "data": {
        "command": "FileDownload",
        "value": {
          "user_id": fileData.data?.userId.toString(),
          "purpose": "promtfile",
          "file_size": fileData.data?.fileSize.toString(),
          "created_on": fileData.data?.createdOn.toString(),
          "created_by": 1,
          "updated_on": fileData.data?.updatedOn.toString(),
          "updated_by": 1,
          "is_deleted": 0,
          "meeting_id": meeting.id.toString(),
          "file_name": fileData.data?.fileName.toString(),
          "file_type": fileData.data?.fileType.toString(),
          "url": fileData.data?.url.toString(),
          "readUrl": fileData.data?.readUrl.toString(),
          "record_flag": 0,
          "_id": fileData.data?.id.toString()
        }
      }
    };
    hubSocket.socket?.emitWithAck(selectedFileType == ShareFilesRadioButtons.all ? "onCommand" : "onPanalCommand", jsonEncode(data), ack: () {
      debugPrint("shared");
    });
  }

  void resetState({bool fromInitState = false}) {
    pickedFile == null;
    fileName == null;
    shareFileDownloadUrl == null;
    showDownloadPopUp = false;
    if (!fromInitState) {
      notifyListeners();
    }
  }
}
