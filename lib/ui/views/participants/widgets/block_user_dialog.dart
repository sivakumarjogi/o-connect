import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:o_connect/ui/utils/buttons_helper/custom_botton.dart';
import 'package:o_connect/ui/utils/constant_strings.dart';
import 'package:o_connect/ui/utils/textfield_helper/app_fonts.dart';
import 'package:o_connect/ui/views/themes/providers/webinar_themes_provider.dart';
import 'package:provider/provider.dart';

class BlockUserDialog extends StatelessWidget {
  const BlockUserDialog({
    super.key,
    this.onPermanentBlock,
    this.onTemporaryBlock,
    this.isTempBlock = false,
  });

  final VoidCallback? onPermanentBlock;
  final VoidCallback? onTemporaryBlock;
  final bool isTempBlock;

  @override
  Widget build(BuildContext context) {
    return Consumer<WebinarThemesProviders>(builder: (_, webinarThemesProviders, __) {
      return Dialog(
        backgroundColor: webinarThemesProviders.colors.headerColor,
        elevation: 0,
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(
                'Are you sure you want to block attendee?',
                style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                      color: Colors.white,
                    ),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 16.h),
              if(isTempBlock == true)
              CustomButton(
                width: 150.w,
                height: 40.h,
                buttonText: ConstantsStrings.temporaryBlock,
                onTap: () {
                  onTemporaryBlock?.call();
                  Navigator.of(context).pop(true);
                },
                buttonColor: webinarThemesProviders.colors.itemColor,
              ),
              if(isTempBlock == false)
              CustomButton(
                width: 120.w,
                height: 40.h,
                borderColor: webinarThemesProviders.colors.buttonColor,
                buttonText: ConstantsStrings.permanentBlock,
                onTap: () {
                  onPermanentBlock?.call();
                  Navigator.of(context).pop(true);
                },
              ),
              CustomButton(
                width: 150.w,
                height: 40.h,
                buttonText: ConstantsStrings.cancel,
                buttonTextStyle: w500_16Poppins(color: webinarThemesProviders.colors.buttonColor),
                onTap: () {
                  Navigator.of(context).pop(false);
                },
                borderColor: webinarThemesProviders.colors.buttonColor,
                buttonColor: Colors.transparent,
              ),
            ],
          ),
        ),
      );
    });
  }
}
