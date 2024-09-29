import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:o_connect/ui/utils/textfield_helper/app_fonts.dart';
import 'package:o_connect/ui/views/themes/providers/webinar_themes_provider.dart';
import 'package:provider/provider.dart';

import 'constant_strings.dart';

class CloseWidget extends StatelessWidget {
  const CloseWidget({super.key, this.onTap, this.textColor});

  final Function()? onTap;
  final Color? textColor;

  @override
  Widget build(BuildContext context) {
    return Consumer<WebinarThemesProviders>(builder: (_, webinarThemesProviders, __) {
      return Padding(
        padding: EdgeInsets.all(8.sp),
        child: GestureDetector(
            onTap: onTap ??
                () {
                  Navigator.pop(context);
                },
            child: Text(
              ConstantsStrings.close,
              style: w500_16Poppins(color: textColor ?? webinarThemesProviders.colors.textColor),
            )),
      );
    });
  }
}
