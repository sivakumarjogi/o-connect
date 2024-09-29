import 'dart:io';

import 'package:file_picker/file_picker.dart';

extension PlatFormFileExtension on List<PlatformFile> {
  String get fileType {
    return first.path.toString().toLowerCase().split(".").last;
  }

  bool get isImage {
    return fileType == "png" || fileType == "jpg" || fileType == "jpeg";
  }

  bool get isPdf {
    return fileType == "pdf";
  }

  bool get isAudio {
    return fileType == "mp3";
  }

  bool get isVideo {
    return fileType == "mp4";
  }

  bool get isDocx {
    return fileType == "doc" || fileType == "docx" || fileType == "xlsx" || fileType == "csv";
  }

  List<File> get pdfFiles {
    return where((element) => [element].isPdf).map((e) => File(e.path ?? "")).toList();
  }

  List<File> get imageFiles {
    return where((element) => [element].isImage).map((e) => File(e.path ?? "")).toList();
  }

  List<File> get docFiles {
    return where((element) => [element].isDocx).map((e) => File(e.path ?? "")).toList();
  }
}

extension FileExtension on File {
  String get fileName {
    return path.split("/").last;
  }
}
