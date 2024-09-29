import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:o_connect/ui/utils/custom_show_dialog_helper/custom_show_dialog.dart';
import 'package:o_connect/ui/utils/textfield_helper/app_fonts.dart';

class LanguagePage extends StatefulWidget {
  const LanguagePage({super.key});

  @override
  State<LanguagePage> createState() => _LanguagePageState();
}

class _LanguagePageState extends State<LanguagePage> {
  List<String> languageList = [
    "English",
    "Telugu",
    "Hindi",
    "Punjabi",
    "Chinese",
    "Spanish",
    "Arabic",
    "French",
    "Russian",
    "Russian",
    "Russian",
    "Russian",
    "Urdu"
  ];
  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        showDialogCustomHeader(context, headerTitle: "Languages"),
        SizedBox(
          height: MediaQuery.of(context).size.height * 0.5,
          child: ListView.builder(
              shrinkWrap: true,
              itemCount: languageList.length,
              // physics: const NeverScrollableScrollPhysics(),
              itemBuilder: (context, index) {
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      child: Padding(
                        padding: EdgeInsets.symmetric(
                            horizontal: 16.w, vertical: 8.h),
                        child: Text(
                          languageList[index],
                          style: w400_15Poppins(
                              color: Theme.of(context).primaryColorLight),
                        ),
                      ),
                    ),
                  ],
                );
              }),
        ),
      ],
    );
  }
}
