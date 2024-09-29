import 'package:flutter/services.dart';
import 'package:o_connect/ui/utils/images/images.dart';

extension StringCasingExtension on String {
  String toCapitalized() => length > 0 ? '${this[0].toUpperCase()}${substring(1).toLowerCase()}' : '';
  String toTitleCase() => replaceAll(RegExp(' +'), ' ').split(' ').map((str) => str.toCapitalized()).join(' ');
}

extension StringX on String {
  Future<void> copyToClipboard() async {
    Clipboard.setData(ClipboardData(text: (this)));
  }

  String get productNameUpperCase {
    return replaceAll("-", "").toUpperCase();
  }

  String get productNameCamelCase {
    return replaceAll("_", " ").toTitleCase();
  }

  String get fileName {
    return split("/").last;
  }

  String get getProductLogo {
    switch (this) {
      case "O-Mail":
        return AppImages.omailIcon;

      case "O-Tracker":
        return AppImages.otrackerIcon;
      case "O-Net":
        return AppImages.onetIcon;
      case "O-Trim":
        return AppImages.otrimIcon;
      default:
        return AppImages.oesIcon;
    }
  }
}

extension NullableStringX on String? {
  bool get isEmptyValue => this == null || this!.trim().isEmpty || this == "null";
  String get emptyIfNull => isEmptyValue ? "" : this!;
}

extension IsOconnectX on String? {
  bool get isOconnect => this!.replaceAll('-', '').toLowerCase() == 'oconnect';
}
