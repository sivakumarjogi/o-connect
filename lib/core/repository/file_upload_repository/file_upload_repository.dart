import 'dart:developer';
import 'dart:io';
import 'dart:typed_data';

import 'package:dio/dio.dart';
import 'package:o_connect/core/file_encryption_helper.dart';
import 'package:o_connect/core/models/library_model/presentation_upload_files_model.dart';
import 'package:o_connect/ui/utils/custom_toast_helper/custom_toast.dart';

class FileUploadRepository {
  Dio dio;
  String baseUrl;

  FileUploadRepository({
    required this.baseUrl,
    required this.dio,
  });
  static String getFileHeader(File file) {
    Uint8List fileContent = file.readAsBytesSync();
    List<int> arr = fileContent.toList().sublist(0, 20);
    String header = "";
    for (int index = 0; index < arr.length; index++) {
      header += arr[index].toRadixString(16);
    }
    String bits = header.toUpperCase().substring(0, 16);
    String fileHeader = FileEncryptionHelper.encryptAESCryptoJS(bits);
    return fileHeader;
  }

  Future<PresentationUploadFilesModel?> uploadFile({
    required File file,
    required String userId,
    String? userInfo,
    required String purpose,
    required String meetingId,
    required String contentType,
    String? category,
  }) async {
    String fileName = file.path.split(Platform.pathSeparator).last;
    final formData = FormData.fromMap({
      "userId": userId,
      if (userInfo != null) "userInfo": userInfo,
      "purpose": purpose,
      "meetingId": meetingId,
      "contentType": contentType,
      "filesize": file.readAsBytesSync().length,
      "filename": fileName,
      if (category != null && category.isNotEmpty) "category": category
    });

    final result = await dio.post(
      "$baseUrl/file-info/uploadFiles",
      options: Options(
        contentType: 'multipart/form-data',
      ),
      data: formData,
    );
    final value = PresentationUploadFilesModel.fromJson(result.data!);

    if (value.status == true) {
      final uploadRes = await Dio().put(
        value.data?.url ?? "",
        data: file.readAsBytesSync(),
        options: Options(
          headers: {"Content-Type": contentType},
        ),
      );

      if (uploadRes.statusCode != 200) {
        return null;
      }
    }
    return value;
  }

  Future createFolder({
    required String userId,
    required String userEmail,
    required String purpose,
    required String folderName,
    required String type,
  }) async {
    final formData = FormData.fromMap({
      "userId": userId,
      "purpose": purpose,
      "user_email": userEmail,
      "type": type,
      "folderName": folderName,
    });
    try {
      final result = await dio.post(
        "$baseUrl/file-info/uploadFiles",
        options: Options(
          contentType: 'multipart/form-data',
        ),
        data: formData,
      );
      if (result.statusCode == 200) {
        await CustomToast.showSuccessToast(msg: "Folder created successfully");
        return true;
      }
    } on DioException catch (e) {
      await CustomToast.showErrorToast(
        msg: (e.response?.data["error"] ?? "Failed to create folder"),
      );
      return false;
    }
  }

  Future<bool> uploadLibraryFile({
    required String userId,
    required String userEmail,
    required String purpose,
    required File file,
    required String contentType,
    required String filesize,
    String? userInfo,
    String? folderName,
  }) async {
    String fileName = file.path.split(Platform.pathSeparator).last;

    final formData = FormData.fromMap({
      "userId": userId,
      "purpose": purpose,
      "user_email": userEmail,
      "contentType": contentType,
      "filename": fileName,
      "filesize": filesize,
      if (folderName != null && folderName.isNotEmpty) "folderName": folderName,
      if (userInfo != null) "userInfo": userInfo,
    });
    try {
      final result = await dio.post(
        "$baseUrl/file-info/uploadFiles",
        options: Options(
          contentType: 'multipart/form-data',
        ),
        data: formData,
      );
      if (result.statusCode == 200) {
        final value = PresentationUploadFilesModel.fromJson(
          result.data!,
        );
        if (value.status == true) {
          final uploadRes = await Dio().put(
            value.data?.url ?? "",
            data: file.readAsBytesSync(),
            options: Options(
              headers: {"Content-Type": contentType},
            ),
          );
          if (uploadRes.statusCode != 200) {
            return false;
          }
        }
        await CustomToast.showSuccessToast(msg: "File uploaded successfully");
        return true;
      }
    } on DioException catch (e) {
      await CustomToast.showErrorToast(
        msg: (e.response?.data["error"] ?? "Failed to upload file"),
      );
      return false;
    }
    return false;
  }

  Future deleteFileOrFolder({
    required List<String> fileOrFolderIds,
  }) async {
    try {
      final result = await dio.post(
        "$baseUrl/file-info/delete",
        data: {
          "FileIds": fileOrFolderIds,
        },
      );
      if (result.statusCode == 200) {
        await CustomToast.showSuccessToast(
          msg: "Deleted successfully",
        );
        return true;
      }
    } on DioException catch (e) {
      await CustomToast.showErrorToast(
        msg: (e.response?.data["error"] ?? "Failed to delete"),
      );
      return false;
    }
  }
}
