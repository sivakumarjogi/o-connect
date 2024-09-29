import 'package:flutter/material.dart';
import 'package:o_connect/ui/utils/buttons_helper/custom_botton.dart';
import 'package:o_connect/ui/utils/textfield_helper/app_fonts.dart';
import 'package:o_connect/ui/views/themes/providers/webinar_themes_provider.dart';
import 'package:provider/provider.dart';

class ConfirmationDialog {
  static Future<dynamic> showConfirmationDialog(
    BuildContext context,
    String title, {
    String? cancelText,
    String? okText,
  }) {
    return showDialog(
      context: context,
      builder: (_) => Consumer<WebinarThemesProviders>(builder: (___, webinarThemesProviders, __) {
        return AlertDialog(
          elevation: 0,
          backgroundColor: webinarThemesProviders.bgColor,
          title: const Icon(Icons.warning_rounded, color: Colors.white),
          content: Text(
            title,
            textAlign: TextAlign.center,
            style: w400_14Poppins(color: Colors.white),
          ),
          actions: [
            CustomButton(
              buttonText: cancelText ?? 'Cancel',
              onTap: () => Navigator.of(context).pop(false),
              buttonColor: Colors.transparent,
              buttonTextStyle: w400_14Poppins(color: Colors.white),
              borderColor: Theme.of(context).primaryColor,
            ),
            CustomButton(
              buttonText: okText ?? 'Proceed',
              buttonTextStyle: w400_14Poppins(color: Colors.white),
              buttonColor: webinarThemesProviders.colors.buttonColor,
              onTap: () => Navigator.of(context).pop(true),
            ),
          ],
        );
      }),
    );
  }
}
