import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:o_connect/core/providers/theme_provider.dart';
import 'package:o_connect/ui/utils/colors/colors.dart';
import 'package:o_connect/ui/utils/constant_strings.dart';
import 'package:o_connect/ui/utils/images/images.dart';
import 'package:o_connect/ui/utils/textfield_helper/app_fonts.dart';

import 'package:provider/provider.dart';

class ChatbotScreen extends StatefulWidget {
  const ChatbotScreen({super.key});

  @override
  State<ChatbotScreen> createState() => _ChatbotScreenState();
}

class _ChatbotScreenState extends State<ChatbotScreen> {
  TextEditingController textController = TextEditingController();
  ScrollController scrollController = ScrollController();

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: Theme.of(context).primaryColor,
        resizeToAvoidBottomInset: true,
        body: Consumer<ThemeProvider>(builder: (context, themeProvider, child) {
          return SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(10.0),
              child: Column(
                children: [
                  Container(
                    height: 47.h,
                    width: MediaQuery.of(context).size.width,
                    decoration: BoxDecoration(
                      color: Theme.of(context).scaffoldBackgroundColor,
                      borderRadius: BorderRadius.circular(4.0.r),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(4.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          IconButton(
                              padding: EdgeInsets.zero,
                              onPressed: () {
                                Navigator.pop(context);
                              },
                              icon: Icon(
                                Icons.chevron_left_outlined,
                                color: Theme.of(context).primaryColorLight,
                              )),
                          width5,
                          Text(
                            ConstantsStrings.chatbot,
                            style: w500_16Poppins(
                                color: Theme.of(context).primaryColorLight),
                          ),
                        ],
                      ),
                    ),
                  ),
                  SizedBox(
                    height: MediaQuery.of(context).size.height * 0.69,
                  ),
                  Align(
                    alignment: Alignment.bottomCenter,
                    child: Container(
                      width: MediaQuery.of(context).size.width,
                      margin: EdgeInsets.symmetric(
                          horizontal: 10.w, vertical: 10.h),
                      // height: 55.h,
                      decoration: BoxDecoration(
                        color: Theme.of(context).scaffoldBackgroundColor,
                        borderRadius: BorderRadius.circular(8.r),
                      ),
                      child: Row(
                        children: [
                          width5,
                          Icon(
                            Icons.emoji_emotions_outlined,
                            color: themeProvider.isLightTheme
                                ? AppColors.paragraphColor
                                : AppColors.whiteColor,
                            size: 16.sp,
                          ),
                          width5,
                          Transform.rotate(
                              angle: 120.0,
                              child: Icon(
                                Icons.attach_file_outlined,
                                size: 16.sp,
                                color: themeProvider.isLightTheme
                                    ? AppColors.paragraphColor
                                    : AppColors.whiteColor,
                              )),
                          width5,
                          Expanded(
                            child: TextField(
                              controller: textController,
                              style: w400_14Poppins(
                                  color: Theme.of(context).hintColor),
                              decoration: InputDecoration(
                                  border: InputBorder.none,
                                  hintText: ConstantsStrings.enterYourMessage,
                                  helperStyle: w400_14Poppins()),
                            ),
                          ),
                          Padding(
                            padding: EdgeInsets.only(right: 5.w),
                            child: InkWell(
                                onTap: () {
                                  textController.text;
                                },
                                child: SvgPicture.asset(
                                  AppImages.send_message_icon,
                                  width: 24.w,
                                  height: 24.w,
                                )),
                          ),
                        ],
                      ),
                    ),
                  ),
                  height10,
                  Row(
                    children: [
                      width10,
                      SvgPicture.asset(AppImages.allProducts),
                      width10,
                      Icon(
                        Icons.emoji_emotions_outlined,
                        color: Theme.of(context).primaryColorLight,
                      ),
                      width10,
                      Icon(
                        Icons.attachment_outlined,
                        color: Theme.of(context).primaryColorLight,
                      ),
                      width10,
                      Icon(
                        Icons.keyboard_alt_outlined,
                        color: Theme.of(context).primaryColorLight,
                        size: 24,
                      ),
                    ],
                  )
                ],
              ),
            ),
          );
        }),
      ),
    );
  }
}
