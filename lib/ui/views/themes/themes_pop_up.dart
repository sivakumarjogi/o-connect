import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:lottie/lottie.dart';
import 'package:o_connect/core/screen_configs.dart';
import 'package:o_connect/ui/utils/buttons_helper/close_apply_buttons.dart';
import 'package:o_connect/ui/utils/close_widget.dart';
import 'package:o_connect/ui/utils/colors/colors.dart';
import 'package:o_connect/ui/utils/constant_strings.dart';
import 'package:o_connect/ui/utils/custom_show_dialog_helper/custom_show_dialog.dart';
import 'package:o_connect/ui/utils/custom_toast_helper/custom_toast.dart';
import 'package:o_connect/ui/utils/images/images.dart';
import 'package:o_connect/ui/utils/network_image_helpers/cached_image_validation.dart';
import 'package:o_connect/ui/utils/textfield_helper/app_fonts.dart';
import 'package:o_connect/ui/views/themes/providers/webinar_themes_provider.dart';
import 'package:provider/provider.dart';
import '../../utils/buttons_helper/custom_outline_button.dart';

class ThemesPopUp extends StatefulWidget {
  const ThemesPopUp({super.key});

  @override
  State<ThemesPopUp> createState() => _ThemesPopUpState();
}

class _ThemesPopUpState extends State<ThemesPopUp> {
  late WebinarThemesProviders webinarThemes;

  @override
  void initState() {
    // TODO: implement initState
    webinarThemes = Provider.of<WebinarThemesProviders>(context, listen: false);
    webinarThemes.getThemes();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<WebinarThemesProviders>(builder: (context, webinarThemesProviders, child) {
      // debugPrint("the bgm url ")
      return webinarThemesProviders.themesDataModel == null || webinarThemesProviders.themesDataModel == []
          ? Center(child: Lottie.asset(AppImages.loadingJson, height: 40.w, width: 40.w))
          : Container(
              decoration: BoxDecoration(
                  border: Border.all(color: webinarThemesProviders.colors.headerColor, width: 4.w),
                  borderRadius: BorderRadius.only(topLeft: Radius.circular(25.r), topRight: Radius.circular(25.r)),
                  color: webinarThemesProviders.colors.bodyColor ?? Theme.of(context).scaffoldBackgroundColor),
              child: Column(
                children: [
                  showDialogCustomHeader(context, headerTitle: ConstantsStrings.themes),
                  Expanded(
                    child: Padding(
                      padding: EdgeInsets.only(left: 8.w, right: 8.w),
                      child: Column(
                        children: [
                          webinarThemesProviders.loadingThemes
                              ? Column(
                                  children: [
                                    SizedBox(
                                      height: ScreenConfig.height * 0.15,
                                    ),
                                    Lottie.asset(AppImages.loadingJson, width: 100.w, height: 100.w)
                                  ],
                                )
                              : Expanded(
                                  child: GridView.builder(
                                      itemCount: webinarThemesProviders.themesDataModel!.length,
                                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 3, mainAxisSpacing: 10.w, crossAxisSpacing: 10.w, childAspectRatio: 1.2),
                                      /* webinarThemesProviders.themesDataModel!.length, */
                                      itemBuilder: (context, index) => InkWell(
                                            onTap: () {
                                              // webinarThemesProviders.getThemes();
                                              webinarThemesProviders.selectedThemeUpdate(webinarThemesProviders.themesDataModel![index]);
                                            },
                                            child: Container(
                                              decoration: BoxDecoration(
                                                  borderRadius: BorderRadius.circular(5.r),
                                                  color: webinarThemesProviders.colors.itemColor,
                                                  border: webinarThemesProviders.selectedWebinarTheme != null &&
                                                          webinarThemesProviders.themesDataModel![index].fileName == webinarThemesProviders.selectedWebinarTheme!.fileName.toString()
                                                      ? Border.all(color: Colors.blue, width: 2)
                                                      : null),
                                              child: Stack(
                                                fit: StackFit.expand,
                                                children: [
                                                  ImageServiceWidget(
                                                    networkImgUrl: webinarThemesProviders.themesDataModel![index].backgroundImageUrl ?? "",
                                                  ),
                                                  width10,
                                                  Align(
                                                    alignment: Alignment.bottomCenter,
                                                    child: Container(
                                                      height: 25.h,
                                                      width: double.infinity,
                                                      alignment: Alignment.center,
                                                      decoration: BoxDecoration(
                                                        color: Colors.black.withOpacity(0.1),
                                                      ),
                                                      child: Text(
                                                        webinarThemesProviders.themesDataModel![index].fileName ?? "NA",
                                                        style: w500_12Poppins(color: Theme.of(context).primaryColorLight),
                                                      ),
                                                    ),
                                                  ),
                                                  // Expanded(
                                                  //   child: Text(
                                                  //     webinarThemesProviders.themesDataModel![index].fileName ?? "NA",
                                                  //     style: w400_16Poppins(color: Theme.of(context).primaryColorLight),
                                                  //   ),
                                                  // ),
                                                  // Padding(
                                                  //   padding: EdgeInsets.only(right: 8.w),
                                                  //   child: CustomOutlinedButton(
                                                  //     outLineBorderColor: webinarThemesProviders.colors.textColor,
                                                  //     color: webinarThemesProviders.colors.headerColor,
                                                  //     height: 35.h,
                                                  //     width: 100.w,
                                                  //     buttonTextStyle: w400_13Poppins(color: webinarThemesProviders.colors.textColor),
                                                  //     buttonText: ConstantsStrings.apply,
                                                  //     onTap: () async {
                                                  //       webinarThemesProviders.emitNewTheme(webinarThemesProviders.themesDataModel![index]);

                                                  //       /// Select Theme Provider
                                                  //       // onSelectTheme(webinarThemesProviders.selectedWebinarTheme!.name);
                                                  //       debugPrint("Color Here ==>> ${webinarThemesProviders.colors.headerColor}");
                                                  //       Navigator.pop(context);
                                                  //     },
                                                  //   ),
                                                  // ),
                                                ],
                                              ),
                                            ),
                                          )),
                                ),
                        ],
                      ),
                    ),
                  ),
                  CloseApplyButtons(
                    closeOnTap: () {
                      Navigator.pop(context);
                    },
                    applyOnTap: () {
                      if (webinarThemesProviders.selectedWebinarTheme != null) {
                        webinarThemesProviders.emitNewTheme(webinarThemesProviders.selectedWebinarTheme!);
                        Navigator.pop(context);
                      } else {
                        CustomToast.showErrorToast(msg: "PLease select any Theme");
                      }
                    },
                  )
                  // CloseWidget(
                  //   textColor: context.watch<WebinarThemesProviders>().colors.textColor,
                  // )
                ],
              ),
            );
    });
  }
}
