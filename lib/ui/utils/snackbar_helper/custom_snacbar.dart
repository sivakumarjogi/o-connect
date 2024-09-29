// import 'package:flutter/material.dart';
// import 'package:o_connect/ui/utils/naviagtion_helper/navigation_service.dart';
//
// class SnackBarService extends NavigationService {
//   static void showSnackBar(String message) {
//     final scaffoldMessenger =
//         ScaffoldMessenger.of(NavigationService.navigatorKey.currentContext!);
//     scaffoldMessenger.showSnackBar(
//       SnackBar(
//         behavior: SnackBarBehavior.floating,
//         content: Text(message),
//       ),
//     );
//   }
// }
//
// showSnackBar(
//     {required BuildContext context, required String mag, Color? color}) {
//   ScaffoldMessenger.of(context).showSnackBar(SnackBar(
//     behavior: SnackBarBehavior.floating,
//     content: Text(mag),
//     backgroundColor: color ?? Colors.grey.shade300,
//   ));
// }
