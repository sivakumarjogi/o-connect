import 'package:flutter/material.dart';
import 'package:o_connect/ui/utils/colors/colors.dart';

// class WebinarThemeColors {
//   final Color button;
//   final Color indicatorBorder;
//   final Color indicator;
//   final Color topBg;
//   final Color popupBg;
//   final Color hover;
//   final Color participantBg;
//   final Color header;
//   final Color input;

//   WebinarThemeColors({
//     required this.button,
//     required this.indicatorBorder,
//     required this.indicator,
//     required this.topBg,
//     required this.popupBg,
//     required this.hover,
//     required this.participantBg,
//     required this.header,
//     required this.input,
//   });
// }

class WebinarThemeColors {
  final Color headerColor;
  final Color buttonColor;
  final Color bodyColor;
  final Color itemColor;
  final Color cardColor;
  final Color textColor;
  final Color calButtonColors;

  WebinarThemeColors({
    this.headerColor = const Color(0xff16181A),
    this.buttonColor = AppColors.mainBlueColor,
    this.bodyColor = const Color(0xff16181A),
    this.itemColor = const Color(0xff232547),
    this.cardColor = const Color(0xff1C1E38),
    this.textColor = const Color(0xFF6C7BAD),
    this.calButtonColors = Colors.black,
  });
}
