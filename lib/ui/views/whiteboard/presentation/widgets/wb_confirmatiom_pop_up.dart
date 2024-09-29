import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:o_connect/core/providers/whiteboard_provider.dart';
import 'package:o_connect/core/screen_configs.dart';
import 'package:o_connect/ui/utils/buttons_helper/custom_botton.dart';
import 'package:o_connect/ui/utils/custom_show_dialog_helper/custom_show_dialog.dart';
import 'package:o_connect/ui/views/presentation/presentation_whiteboard/presentation_whiteboard_provider.dart';
import 'package:o_connect/ui/views/themes/providers/webinar_themes_provider.dart';
import 'package:provider/provider.dart';
import '../../../../utils/buttons_helper/custom_outline_button.dart';
import '../../../../utils/colors/colors.dart';
import '../../../../utils/constant_strings.dart';
import '../../../../utils/textfield_helper/app_fonts.dart';

class WBCloseConfirmationWidget extends StatelessWidget {
  const WBCloseConfirmationWidget({
    super.key,
    this.fromPresentation = false,
  });

  final bool fromPresentation;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: ScreenConfig.height * 0.25,
      child: Column(crossAxisAlignment: CrossAxisAlignment.center, children: [
        showDialogCustomHeader(context, headerTitle: "Save Whiteboard Data", removeDivider: false),
        height10,
        const Text("Would you like to save this as filebgm"),
        height10,
        Consumer<WebinarThemesProviders>(builder: (context, webinarThemesProvider, child) {
          return Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              CustomOutlinedButton(
                outLineBorderColor: Provider.of<WebinarThemesProviders>(context).colors.textColor,
                height: 35.h,
                width: 80.w,
                buttonTextStyle: w400_13Poppins(color: Provider.of<WebinarThemesProviders>(context).colors.textColor),
                buttonText: "No",
                onTap: () {
                  Navigator.pop(context);
                  context.read<WhiteboardProvider>().closeWhiteBoard();
                },
              ),
              width10,
              CustomButton(
                buttonColor: webinarThemesProvider.colors.buttonColor ?? AppColors.mainBlueColor,
                width: 70.w,
                height: 35.h,
                buttonText: "yes",
                buttonTextStyle: w500_13Poppins(color: Provider.of<WebinarThemesProviders>(context).colors.textColor),
                onTap: () async {
                  Navigator.pop(context);
                  // if (fromPresentation) {
                  //   if (context.read<PresentationWhiteBoardProvider>().callBacks != null) {
                  //     await context.read<PresentationWhiteBoardProvider>().callBacks?.downloadCanvasAsImage();
                  //     await context.read<PresentationWhiteBoardProvider>().closeWhiteBoard();
                  //   }
                  // } else {
                  //   if (context.read<WhiteboardProvider>().callBacks != null) {
                  //     await context.read<WhiteboardProvider>().callBacks?.downloadCanvasAsImage();
                  //     await context.read<WhiteboardProvider>().closeWhiteBoard();
                  //   }
                  // }
                },
              )
            ],
          );
        })
      ]),
    );
  }
}
