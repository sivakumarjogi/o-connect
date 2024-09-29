import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:o_connect/ui/utils/colors/colors.dart';
import 'package:o_connect/ui/utils/custom_show_dialog_helper/custom_show_dialog.dart';
import 'package:o_connect/ui/utils/textfield_helper/app_fonts.dart';

class MicLanguagePopUp extends StatefulWidget {
  const MicLanguagePopUp({Key? key}) : super(key: key);

  @override
  State<MicLanguagePopUp> createState() => _MicLanguagePopUpState();
}

class _MicLanguagePopUpState extends State<MicLanguagePopUp> {
  List<String> languageBots = [
    "David-US English",
    "Google Male-UK English",
    "Google-DE Deutsch",
    "Google-FR Francais",
    "Google Male-UK English",
  ];

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          showDialogCustomHeader(context, headerTitle: 'Languages'),
          Container(
              height: MediaQuery.of(context).size.height * 0.25,
              child: ListView.builder(
                  itemCount: languageBots.length,
                  itemBuilder: (context, index) {
                    return Padding(
                      padding: EdgeInsets.only(
                          left: 24.w, right: 10.w, top: 8.h, bottom: 8.h),
                      child: Container(
                        // width: MediaQuery.of(context).size.width - 30,

                        child: Text(
                          languageBots[index],
                          style: w400_14Poppins(
                              color: Theme.of(context).primaryColorLight),
                        ),
                      ),
                    );
                  })),
        ],
      ),
    );
  }
}
