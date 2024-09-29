import 'dart:io';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';

Future<String> createFolder() async {
  var status = await Permission.manageExternalStorage.status;
  var status1 = Permission.storage;

  if (status.isDenied || status.isPermanentlyDenied) {
    PermissionStatus status = await Permission.manageExternalStorage.request();
    if (status == PermissionStatus.denied) {
      return "";
    }
  }
  if (await status1.isDenied) {
    await Permission.storage.request();
  }
  String newPath = await shareAppDirectory();
  String path = newPath;
  debugPrint(path);
  Directory folderDirectory = Directory(path);
  if ((await folderDirectory.exists())) {
    debugPrint('exists');
    return folderDirectory.path;
  } else {
    debugPrint('does not exists');
    await folderDirectory.create(recursive: true);
    return folderDirectory.path;
  }
}

Future<String> shareAppDirectory() async {
  Directory directory = (Platform.isAndroid
      ? await getExternalStorageDirectory() //FOR ANDROID
      : await getApplicationDocumentsDirectory())!;

  String newPath = "";
  if (Platform.isAndroid) {
    List<String> paths = directory.path.split("/");
    for (int x = 1; x < paths.length; x++) {
      String folder = paths[x];
      if (folder != "Android") {
        newPath += "/$folder";
      } else {
        break;
      }
    }
    newPath = "$newPath/OCONNECT";
  } else {
    newPath = "${directory.path}/OCONNECT";
  }
  return newPath;
}
