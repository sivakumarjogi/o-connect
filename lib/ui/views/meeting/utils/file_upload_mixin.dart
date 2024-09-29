import 'dart:io';
import 'dart:typed_data';

import 'package:mime/mime.dart';
import 'package:o_connect/core/file_encryption_helper.dart';
import 'package:o_connect/core/models/library_model/presentation_upload_files_model.dart';
import 'package:o_connect/core/repository/file_upload_repository/file_upload_repository.dart';
import 'package:o_connect/core/service/api_helper/api_helper.dart';
import 'package:o_connect/ui/utils/base_urls.dart';

mixin WebinarFileUploadMixin {
  Future<PresentationUploadFilesModel?> uploadFile({
    required File file,
    required String userId,
    required String purpose,
    required String meetingId,
    String? category,
  }) async {
    String fileHeader = _getFileHeader(file);
    FileUploadRepository fileUploadRepository = FileUploadRepository(
      baseUrl: BaseUrls.libraryBaseUrl,
      dio: ApiHelper().oConnectDio,
    );

    return fileUploadRepository.uploadFile(file: file, userId: userId, userInfo: fileHeader, purpose: purpose, meetingId: meetingId, contentType: lookupMimeType(file.path)!, category: category);
  }

  String _getFileHeader(File file) {
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
}
