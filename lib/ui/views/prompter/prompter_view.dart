import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:html_editor_enhanced/html_editor.dart';
import 'package:o_connect/core/providers/prompter_provider.dart';
import 'package:o_connect/core/screen_configs.dart';
import 'package:o_connect/ui/utils/close_widget.dart';
import 'package:o_connect/ui/utils/constant_strings.dart';
import 'package:o_connect/ui/views/meeting/utils/context_ext.dart';
import 'package:o_connect/ui/views/prompter/prompter_menu.dart';
import 'package:o_connect/ui/views/themes/providers/webinar_themes_provider.dart';
import 'package:oes_chatbot/utils/extensions/sizedbox_extension.dart';
import 'package:provider/provider.dart';

import '../../utils/colors/colors.dart';
import '../../utils/textfield_helper/app_fonts.dart';

class PrompterPopUp extends StatefulWidget {
  const PrompterPopUp({super.key});

  @override
  State<PrompterPopUp> createState() => _PrompterPopUpState();
}

class _PrompterPopUpState extends State<PrompterPopUp> {
  // String result = '';
  late PrompterProvider prompterProvider;

  @override
  void initState() {
    super.initState();
    prompterProvider = Provider.of<PrompterProvider>(context, listen: false);
    prompterProvider.fileEmpty(isFromInitState: true);
    Future.delayed(
      Duration.zero,
      () {
        context.showLoading();
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Consumer2<PrompterProvider, WebinarThemesProviders>(builder: (
        context,
        prompterProvider,
        webinarThemesProviders,
        child,
      ) {
        return PopScope(
          canPop: true,
          onPopInvoked: (didPop) async {
            await prompterProvider.storePrompterData();
          },
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  decoration: BoxDecoration(
                    border: Border.all(
                      color: webinarThemesProviders.colors.headerColor,
                    ),
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(15.r),
                      topRight: Radius.circular(15.r),
                    ),
                    color: webinarThemesProviders.colors.headerColor,
                  ),
                  alignment: Alignment.center,
                  child: Padding(
                    padding: EdgeInsets.symmetric(horizontal: 8.w),
                    child: Column(
                      children: [
                        10.height,
                        Container(
                          width: ScreenConfig.width * 0.2,
                          height: 3,
                          color: Colors.grey.shade800,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Align(
                              alignment: Alignment.centerLeft,
                              child: Padding(
                                padding: const EdgeInsets.only(left: 12),
                                child: Text(
                                  ConstantsStrings.prompter,
                                  textAlign: TextAlign.left,
                                  style: w500_14Poppins(color: Theme.of(context).hintColor),
                                ),
                              ),
                            ),
                            const PrompterMenu(),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 5.h),
                  child: SizedBox(
                    child: prompterProvider.file != ""
                        ? Stack(
                            alignment: Alignment.topLeft,
                            children: [
                              ClipRRect(
                                  borderRadius: BorderRadius.circular(15.r),
                                  child: Image.file(
                                    File(prompterProvider.file.toString()),
                                  )),
                              Container(
                                alignment: Alignment.topRight,
                                child: InkWell(
                                  onTap: () {
                                    prompterProvider.fileEmpty();
                                  },
                                  child: const Icon(Icons.cancel, color: Colors.red),
                                ),
                              )
                            ],
                          )
                        : Column(
                            children: [
                              const Divider(
                                height: 2,
                              ),
                              HtmlEditor(
                                controller: prompterProvider.controller,
                                htmlEditorOptions: const HtmlEditorOptions(
                                  hint: ConstantsStrings.yourTextHere,
                                  inputType: HtmlInputType.text,
                                  shouldEnsureVisible: true,
                                  autoAdjustHeight: true,
                                  spellCheck: true,
                                  darkMode: true,
                                ),
                                htmlToolbarOptions: const HtmlToolbarOptions(
                                  toolbarItemHeight: 0,
                                  toolbarPosition: ToolbarPosition.custom,
                                ),
                                otherOptions: OtherOptions(
                                  decoration: BoxDecoration(
                                    border: Border.all(),
                                    color: webinarThemesProviders.colors.headerColor,
                                  ),
                                  height:  ScreenConfig.height * .3 ,
                                ),
                                onHtmlEditorInitialized: () {
                                  context.hideLoading();
                                  prompterProvider.setPrompterData();
                                },
                              ),
                              Container(
                                color: webinarThemesProviders.colors.headerColor,
                                child: ToolbarWidget(
                                  controller: prompterProvider.controller,
                                  callbacks: null,
                                  htmlToolbarOptions: HtmlToolbarOptions(
                                      renderBorder: false,
                                      buttonFillColor: webinarThemesProviders.colors.headerColor,
                                      dropdownBoxDecoration: BoxDecoration(
                                        color: webinarThemesProviders.colors.buttonColor,
                                      ),
                                      dropdownBackgroundColor: webinarThemesProviders.colors.headerColor,
                                      toolbarPosition: ToolbarPosition.belowEditor,
                                      buttonSelectedColor: webinarThemesProviders.colors.textColor,
                                      toolbarItemHeight: 30.h,
                                      buttonColor: webinarThemesProviders.colors.textColor,
                                      //Theme.of(context).hintColor,
                                      defaultToolbarButtons: [
                                        const FontSettingButtons(),
                                        const FontButtons(
                                          subscript: false,
                                          clearAll: false,
                                          superscript: false,
                                        ),
                                        const ColorButtons(),
                                        // const FontSettingButtons(),
                                        const ParagraphButtons(
                                          lineHeight: false,
                                          caseConverter: false,
                                          decreaseIndent: false,
                                          increaseIndent: false,
                                          textDirection: false,
                                        ),
                                        const InsertButtons(
                                          audio: false,
                                          video: false,
                                          table: false,
                                          hr: false,
                                          link: false,
                                        )
                                      ],
                                      textStyle: w500_14Poppins(
                                        color: Colors.white,
                                      )),
                                ),
                              )
                            ],
                          ),
                  ),
                ),
                // Container(
                //   padding: EdgeInsets.only(
                //     right: ScreenConfig.width * 0.08,
                //   ),
                //   alignment: Alignment.bottomRight,
                //   child: CloseWidget(
                //     textColor: webinarThemesProviders.selectButtonsColor,
                //     onTap: () async {
                //       await prompterProvider.storePrompterData();
                //       Navigator.pop(context);
                //     },
                //   ),
                // ),
                height10
              ],
            ),
          ),
        );
      }),
    );
  }
}
