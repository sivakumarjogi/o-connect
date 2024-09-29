import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:o_connect/ui/utils/textfield_helper/app_fonts.dart';
import 'package:o_connect/ui/views/themes/providers/webinar_themes_provider.dart';
import 'package:provider/provider.dart';

import 'colors/colors.dart';
import 'constant_strings.dart';

class CancelOkButtons extends StatelessWidget {
  const CancelOkButtons({super.key, this.okTap, this.cancelTap});

  final Function()? okTap;

  final Function()? cancelTap;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(8.sp),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          GestureDetector(
              onTap: cancelTap ??
                  () {
                    Navigator.pop(context);
                  },
              child: Text(
                ConstantsStrings.cancel,
                style: w500_16Poppins(color: Provider.of<WebinarThemesProviders>(context, listen: false).themeHighLighter != null ? Theme.of(context).hoverColor : AppColors.mainBlueColor),
              )),
          GestureDetector(
              onTap: okTap ??
                  () {
                    Navigator.pop(context);
                  },
              child: Text(
                ConstantsStrings.ok,
                style: w500_16Poppins(color: Provider.of<WebinarThemesProviders>(context, listen: false).themeHighLighter != null ? Theme.of(context).hoverColor : AppColors.mainBlueColor),
              )),
        ],
      ),
    );
  }
}
