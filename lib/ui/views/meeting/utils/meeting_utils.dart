import 'dart:io';
import 'dart:typed_data';

import 'dart:ui' as ui;
import 'package:flutter/rendering.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:image_gallery_saver/image_gallery_saver.dart';
import 'package:path_provider/path_provider.dart';
import 'package:provider/provider.dart';
import 'package:screenshot/screenshot.dart';

import '../../../../core/service/download_files_service.dart';
import '../../webinar_details/webinar_details_provider/webinar_provider.dart';

mixin MeetingUtils {
  void captureScreenshot(BuildContext context) async {
    WebinarProvider webinarProvider = Provider.of<WebinarProvider>(context, listen: false);
    ScreenshotController screenshotController = ScreenshotController();
    // Directory? directory = await getExternalStorageDirectory();
    // print("Path is ===========");
    // print(directory?.path);
    // String? screenShotFile = await screenshotController.captureAndSave(
    //   directory!.path,
    //   fileName: "${DateTime.now()}.png",
    // );
    // Uint8List? imageBytes = await screenshotController.capture();
    // print("show $screenShotFile");
    // if (imageBytes != null) {
    //   final result = await ImageGallerySaver.saveImage(imageBytes);
    //   if (result['isSuccess']) {
    //     print("Screenshot saved to gallery");
    //   } else {
    //     print("Failed to save screenshot: ${result['errorMessage']}");
    //   }
    // }
    // RenderRepaintBoundary? boundary = Provider.of<WebinarProvider>(context, listen: false).previewContainer.currentContext!
    //               .findRenderObject() as RenderRepaintBoundary?;
    //           ui.Image image = await boundary!.toImage();
    //           print("the image is the $image");
    //           final directory =await createFolder();//(await getApplicationDocumentsDirectory()).path;
    //           ByteData? byteData =
    //               await image.toByteData(format: ui.ImageByteFormat.png);
    //           Uint8List? pngBytes = byteData?.buffer.asUint8List();
    //           File imgFile =  File('$directory/${DateTime.now()}.png');
    //           imgFile.writeAsBytes(pngBytes!);
    //           imgFile.createSync(recursive: true);
    //           // imagePaths.add(imgFile.path);
    //           print(imgFile.path);

    //   List<int> fileBytes = await imgFile.readAsBytes();
    //   final result = await ImageGallerySaver.saveImage(pngBytes );
    //   if (result['isSuccess']) {
    //     print("Screenshot saved to gallery");
    //     // we can call our API here
    //   } else {
    //     print("Failed to save screenshot: ${result['errorMessage']}");
    //   }

    Future.delayed(Duration(seconds: 3), () async {
      await webinarProvider.screenshotController.capture().then((capturedImage) async {
        // _saved(capturedImage!);
        //  captureImage();
        //           RenderRepaintBoundary? boundary = Provider.of<WebinarProvider>(context, listen: false).previewContainer.currentContext
        //     ?.findRenderObject() as RenderRepaintBoundary?;
        // ui.Image image = await boundary!.toImage();
        // print("the image is the $image");
        final directory = await createFolder(); //(await getApplicationDocumentsDirectory()).path;
        // ByteData? byteData =
        //     await image.toByteData(format: ui.ImageByteFormat.png);
        // Uint8List? pngBytes = byteData?.buffer.asUint8List();

        File imgFile = File('$directory/${DateTime.now()}.png');
        await imgFile.writeAsBytes(capturedImage!);
        // imgFile.createSync(recursive: true);
        // imagePaths.add(imgFile.path);
        print(imgFile.path);

        List<int> fileBytes = await imgFile.readAsBytes();
        final result = await ImageGallerySaver.saveImage(capturedImage);
        if (result['isSuccess']) {
          print("Screenshot saved to gallery");
          // we can call our API here
        } else {
          print("Failed to save screenshot: ${result['errorMessage']}");
        }
      }).catchError((onError, sss) {
        print(onError);
        print(sss.toString());
      });
    });
  }
}
