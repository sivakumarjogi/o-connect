import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:lottie/lottie.dart';
import 'package:o_connect/core/providers/my_contacts_provider.dart';
import 'package:o_connect/core/screen_configs.dart';
import 'package:o_connect/ui/utils/colors/colors.dart';
import 'package:o_connect/ui/utils/custom_show_dialog_helper/custom_show_dialog.dart';
import 'package:o_connect/ui/utils/images/images.dart';
import 'package:o_connect/ui/utils/textfield_helper/app_fonts.dart';
import 'package:o_connect/ui/views/home_screen/home_screen_provider/home_screen_provider.dart';
import 'package:provider/provider.dart';

import '../utils/buttons_helper/custom_botton.dart';

class DeleteBottomSheet extends StatelessWidget {
  const DeleteBottomSheet({required this.onTap, Key? key, this.text, this.textColor, required this.title, required this.body, required this.headerTitle, this.titleTextColor = Colors.blue})
      : super(key: key);
  final VoidCallback onTap;
  final String? text;
  final String title;
  final String body;
  final String headerTitle;
  final Color titleTextColor;
  final Color? textColor;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        height5,
        showDialogCustomHeader(context, headerTitle: headerTitle, headerColor: Theme.of(context).scaffoldBackgroundColor),
        height15,
        Text(
          title,
          textAlign: TextAlign.center,
          style: w500_14Poppins(color: titleTextColor),
        ),
        Text(
          body ?? " ",
          textAlign: TextAlign.center,
          style: w400_14Poppins(color: textColor ?? Theme.of(context).hintColor),
        ),
        height20,
        Consumer<MyContactsProvider>(builder: (context, myContactsProvider, child) {
          return myContactsProvider.deleteContactsLoading
              ? Center(
                  child: SizedBox(width: 20.w, height: 20.w, child: Lottie.asset(AppImages.loadingJson)),
                )
              : Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    CustomButton(
                      buttonText: 'Cancel',
                      buttonColor: Colors.blue.withOpacity(0.08),
                      buttonTextStyle: w500_14Poppins(color: Colors.white),
                      width: ScreenConfig.width * 0.42,
                      onTap: () {
                        Navigator.pop(context);
                      },
                    ),
                    width10,
                    CustomButton(
                      buttonText: headerTitle,
                      width: ScreenConfig.width * 0.42,
                      onTap: onTap,
                      buttonColor: const Color(0xff0E78F9),
                      buttonTextStyle: w400_14Poppins(color: Colors.white),
                    ),
                    width10,
                  ],
                );
        }),
        height15,
      ],
    );
  }
}
