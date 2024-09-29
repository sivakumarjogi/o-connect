import 'dart:io';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:image_gallery_saver/image_gallery_saver.dart';
import 'package:o_connect/ui/utils/custom_toast_helper/custom_toast.dart';
import 'package:o_connect/ui/views/meeting/utils/file_upload_mixin.dart';
import 'package:o_connect/ui/views/webinar_details/webinar_details_provider/webinar_provider.dart';
import 'package:open_file/open_file.dart';
import 'package:path_provider/path_provider.dart';
import 'package:screenshot/screenshot.dart';

class ScreenShotService with WebinarFileUploadMixin {
  final WebinarProvider _webinarProvider;
  ScreenShotService(this._webinarProvider);

  void captureScreenshot(ScreenshotController controller) async {
    Directory? directory = (Platform.isAndroid
        ? await getExternalStorageDirectory() //FOR ANDROID
        : await getApplicationDocumentsDirectory());
    String? screenShotFile = await controller.captureAndSave(
      directory!.path,
      fileName: "${DateTime.now().microsecondsSinceEpoch}.png",
    );
    Uint8List? imageBytes = await controller.capture();
    print("show $screenShotFile   }");
    if (imageBytes != null) {
      uploadScreenShot(file: File(screenShotFile.toString())).then((value) async {
        final result = await ImageGallerySaver.saveImage(imageBytes);
        if (result['isSuccess']) {
          print("Screenshot saved to gallery");
          CustomToast.showDownloadToast(
            msg: "Screen Captured",
            onTap: () {
              OpenFile.open(screenShotFile);
            },
          );
        } else {
          print("Failed to save screenshot: ${result['errorMessage']}");
        }
      });
    }
  }

  Future<void> uploadScreenShot({
    required File file,
  }) async {
    try {
      await uploadFile(file: file, userId: _webinarProvider.myHubInfo.id.toString(), purpose: "ScreenShot", meetingId: _webinarProvider.meeting.id.toString());
    } on DioException catch (e) {
      print("the dio exception in the screen shot ${e.error}&& ${e.response}");
    } catch (e, st) {
      print("the  exception is the screen shot ${e.toString()}&& $st");
    }
  }
}
