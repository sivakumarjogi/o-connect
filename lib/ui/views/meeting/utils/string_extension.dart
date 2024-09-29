import 'package:o_connect/ui/views/meeting/providers/video_share_provider.dart';
import 'package:flutter/material.dart';

extension StringExt on String? {
  bool get isHost => this?.toLowerCase() == 'Host'.toLowerCase();
  bool get isAttendee => this == 'Attendee';
  bool get isCohost => this?.toLowerCase() == 'Co-host'.toLowerCase();
  bool get isPresenter => this == 'Presenter';
  bool get isGuest => this == 'Guest';
}

extension StringExtension on String {
  Color get hexToColor {
    String hexColor = replaceAll("#", "");
    int intValue = int.parse(hexColor, radix: 16);
    return Color(intValue);
  }

  bool get isValidUrl {
    RegExp regExp = RegExp(
      r'^(?:(?:https?|ftp):\/\/)?' // http://, https:// or ftp://
      r'(?:(?:[A-Z0-9-]+\.)+[A-Z]{2,}(?::\d+)?(?:\/?|[\/?]\S+))$', // domain...
      caseSensitive: false,
    );
    return regExp.hasMatch(this);
  }

  bool get isValidYoutubeUrl {
    RegExp shortYoutubeRegex = RegExp(
      r'^https:\/\/youtu\.be\/([a-zA-Z0-9_-]{11})(\?[^\s]*)?$',
    );
    RegExp youtubeUrlRegex = RegExp(
      r'^https:\/\/www\.youtube\.com\/watch\?v=([a-zA-Z0-9_-]{11}).*$',
    );
    return shortYoutubeRegex.hasMatch(this) || youtubeUrlRegex.hasMatch(this) || VideoShareProvider.convertUrlToId(this) != null;
  }

  bool get isEmailValid {
    return RegExp(r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$').hasMatch(this ?? "");
  }
}
