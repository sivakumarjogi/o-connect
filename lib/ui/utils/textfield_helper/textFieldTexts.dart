import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:o_connect/ui/utils/constant_strings.dart';
import 'package:o_connect/ui/views/themes/providers/webinar_themes_provider.dart';
import 'package:provider/provider.dart';

import 'app_fonts.dart';

class TextFieldTexts extends StatelessWidget {
  const TextFieldTexts({required this.name, this.isRequired = false, this.textColor, Key? key}) : super(key: key);
  final String? name;
  final bool isRequired;
  final Color? textColor;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Padding(
          padding: EdgeInsets.symmetric(vertical: 5.h),
          child: Text(
            name!,
            style: w400_12Poppins(color: Provider.of<WebinarThemesProviders>(context).themeHighLighter != null ? Colors.white : textColor ?? Theme.of(context).primaryColorLight),
          ),
        ),
        isRequired
            ? Text(
                ConstantsStrings.star,
                style: TextStyle(
                  fontSize: 18.sp,
                  fontWeight: FontWeight.bold,
                  color: Colors.red,
                ),
              )
            : const Text('')
      ],
    );
  }
}
