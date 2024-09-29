import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:o_connect/my_app.dart';
import 'package:o_connect/ui/utils/images/images.dart';
import 'package:o_connect/ui/views/home_screen/home_screen_view/widgets/check_subscription_pop_up.dart';
import 'package:provider/provider.dart';

import '../ui/views/home_screen/home_screen_models/user_subscription_model.dart';
import '../ui/views/home_screen/home_screen_provider/home_screen_provider.dart';

bool checkStringValue(String? value) {
  if (value != null && value.isNotEmpty) {
    return true;
  }
  return false;
}

String getSvgProductLogoPath(int badgeId) {
  ///id badId is null then all contacts
  ///
  switch (badgeId) {
    case 0:
      return AppImages.oesIcon;
    case 2:
      return AppImages.oMailIcon;
    case 4:
      return AppImages.oConnectIcon1;
    default:
      return AppImages.oConnectIcon1;
  }
}

String getSvgProductLogoFromName(String name) {
  switch (name) {
    case 'O-Net':
      // TODO: Chnage this later to O-Net icon
      return AppImages.oesIcon;
    case 'O-Connect':
      return AppImages.oConnectIcon1;
    case 'O-Mail':
      return AppImages.oMailIcon;
    default:
      return AppImages.oConnectIcon1;
  }
}

String getCurrentUtcTime() {
  DateTime now = DateTime.now().toUtc(); // Get the current time in UTC
  String formattedTime = now.toIso8601String();

  return formattedTime;
}

extension ColorToHexColor on Color {
  String toHex() {
    return '#${value.toRadixString(16).substring(2).toUpperCase()}';
  }
}

extension HexColorToColor on String {
  Color toColor() {
    if (isEmpty) {
      return Colors.transparent;
    }
    return Color(int.parse(replaceFirst('#', ''), radix: 16) + 0xFF000000);
  }
}

extension DateFormatExtension on String {
  String toCustomDateFormat(String format) {
    final dateTime = DateTime.parse(this).toLocal(); // Convert string to DateTime
    final formattedDate = DateFormat(format).format(dateTime); // Apply the desired format
    return formattedDate;
  }
}

extension DateParsing on String {
  DateTime toConvertedDateTime() {
    final months = {'Jan': 1, 'Feb': 2, 'Mar': 3, 'Apr': 4, 'May': 5, 'Jun': 6, 'Jul': 7, 'Aug': 8, 'Sep': 9, 'Oct': 10, 'Nov': 11, 'Dec': 12};
    final parts = split(' ');

    final day = int.parse(parts[0]);
    final month = months[parts[1]]!;
    final year = int.parse(parts[2]);

    return DateTime(year, month, day);
  }
}

Future<bool> checkUserSubScription({bool checkNoOfDays = false}) async {
  int? noOfDays = await navigationKey.currentContext!.read<HomeScreenProvider>().getSubScriptionEndDate(navigationKey.currentContext!);

  if (noOfDays != null && noOfDays == 0) {
    await showDialog(context: navigationKey.currentContext!, builder: (context) => const SubscriptionExpirePopUp());
    return false;
  } else if (checkNoOfDays && noOfDays != null && noOfDays >= 0 && noOfDays < 7) {
    await showDialog(context: navigationKey.currentContext!, builder: (context) => SubScriptionEndsInDays(noOfDays: noOfDays));
    return false;
  } else if (noOfDays != null && noOfDays < 0) {
    await showDialog(context: navigationKey.currentContext!, builder: (context) => const SubscriptionExpirePopUp());
    return false;
  } else if (noOfDays == null) {
    await showDialog(context: navigationKey.currentContext!, builder: (context) => const SubscriptionExpirePopUp());
    return false;
  }
  // UserSubscriptionModel? userSubscriptionModel = navigationKey.currentContext!.read<HomeScreenProvider>().userSubscriptionModel;
  // if (userSubscriptionModel!.body!.isNotEmpty) {
  //   for (var subscription in userSubscriptionModel.body!) {
  //     if (subscription.productId == 272 && subscription.productName == "O-Connect") {
  //       if (noOfDays != null && noOfDays == 0) {
  //         await showDialog(context: navigationKey.currentContext!, builder: (context) => const SubscriptionExpirePopUp());
  //         return false;
  //       } else if (checkNoOfDays && subscription.noOfDays != null && subscription.noOfDays! < 7) {
  //         await showDialog(barrierDismissible: false, context: navigationKey.currentContext!, builder: (context) => SubScriptionEndsInDays(noOfDays: subscription.noOfDays ?? 0));
  //         return false;
  //       }
  //     }
  //   }
  // }
  return true;
}
