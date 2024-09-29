import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:o_connect/ui/views/themes/providers/webinar_themes_provider.dart';
import 'package:provider/provider.dart';

class RecordScreenWidget extends StatelessWidget {
  const RecordScreenWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 40.h,
      width: 150.w,
      alignment: Alignment.center,
      margin: EdgeInsets.only(right: 20.w),
      padding: const EdgeInsets.symmetric(horizontal: 4.0),
      decoration: BoxDecoration(
        color: context.watch<WebinarThemesProviders>().colors.buttonColor,
        borderRadius: BorderRadius.circular(5.r),
      ),
      child: Row(
        children: [
          const Icon(Icons.record_voice_over_rounded, color: Colors.red),
          SizedBox(width: 6.w),
          const Text('Recording'),
        ],
      ),
    );
  }
}
