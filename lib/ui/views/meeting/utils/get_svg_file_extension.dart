import 'package:o_connect/ui/utils/images/images.dart';

extension GetSvgFile on String {
  String get fileExtension {
    return split(".").last.toLowerCase();
  }

  bool get isImageFormat {
    String fileExt = fileExtension;

    return fileExt.startsWith("png") || fileExt.startsWith("jpg") || fileExt.startsWith("jpeg");
  }

  bool get isDocFormat {
    String fileExt = fileExtension;
    return fileExt.startsWith("csv") || fileExt.startsWith("xlsx");
  }

  bool get isPdfFormat {
    String fileExt = fileExtension;
    return fileExt.startsWith("pdf");
  }

  bool get isAudioFormat {
    String fileExt = fileExtension;
    return fileExt.startsWith("mp3") || fileExt.startsWith("wav");
  }

  bool get isVideoFormat {
    String fileExt = fileExtension;
    return fileExt.startsWith("mp4") ||
        fileExt.startsWith("mov") ||
        fileExt.startsWith("wmv") ||
        fileExt.startsWith("avi") ||
        fileExt.startsWith("avchd") ||
        fileExt.startsWith("flv") ||
        fileExt.startsWith("f4v") ||
        fileExt.startsWith("swf") ||
        fileExt.startsWith("mkv") ||
        fileExt.startsWith("mpeg-4") ||
        fileExt.startsWith("webm");
  }

  String get getSvg {
    if (isImageFormat) {
      return AppImages.photo;
    } else if (isVideoFormat) {
      return AppImages.videoIcon;
    } else if (isPdfFormat) {
      return AppImages.pdfLib;
    } else if (isAudioFormat) {
      return AppImages.musicIcon;
    }
    return AppImages.document;
  }
}
