import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:image_picker/image_picker.dart';
import 'package:lottie/lottie.dart';
import 'package:o_connect/core/providers/common_provider.dart';
import 'package:o_connect/ui/utils/buttons_helper/custom_botton.dart';
import 'package:o_connect/ui/utils/colors/colors.dart';
import 'package:o_connect/ui/utils/constant_strings.dart';
import 'package:o_connect/ui/utils/custom_show_dialog_helper/custom_show_dialog.dart';
import 'package:o_connect/ui/utils/images/images.dart';
import 'package:o_connect/ui/utils/network_image_helpers/cached_image_validation.dart';
import 'package:o_connect/ui/utils/textfield_helper/app_fonts.dart';
import 'package:o_connect/ui/views/themes/providers/webinar_themes_provider.dart';
import 'package:provider/provider.dart';
import '../webinar_details/webinar_details_provider/webinar_provider.dart';
import '../../utils/buttons_helper/custom_outline_button.dart';

class VirtualBGPopUp extends StatefulWidget {
  const VirtualBGPopUp({Key? key}) : super(key: key);

  @override
  State<VirtualBGPopUp> createState() => _VirtualBGPopUpState();
}

class _VirtualBGPopUpState extends State<VirtualBGPopUp> {
  CommonProvider? commonProvider;
  XFile? image;

  @override
  void initState() {
    commonProvider = Provider.of<CommonProvider>(context, listen: false);
    SchedulerBinding.instance.addPostFrameCallback((timeStamp) {
      Provider.of<CommonProvider>(context, listen: false).getVirtualBg();
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer3<CommonProvider, WebinarThemesProviders, WebinarProvider>(builder: (context, commonProvider, webinarThemesProvider, webinarProvider, child) {
      return Container(
        decoration: BoxDecoration(
            border: Border.all(
              color: webinarThemesProvider.colors.headerColor,
            ),
            borderRadius: BorderRadius.only(topRight: Radius.circular(20.r), topLeft: Radius.circular(20.r)),
            color: webinarThemesProvider.colors.bodyColor ?? Theme.of(context).scaffoldBackgroundColor),
        child: Column(
          children: [
            showDialogCustomHeader(context, headerTitle: ConstantsStrings.virtualBG),
            Expanded(
                child: commonProvider.virtualBgModel.isNotEmpty
                    ? Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          SizedBox(
                            height: 120.h,
                            child: ListView.builder(
                              itemCount: commonProvider.virtualBgModel.length,
                              scrollDirection: Axis.horizontal,
                              shrinkWrap: true,
                              itemBuilder: (context, idx) {
                                return GestureDetector(
                                  onTap: () {
                                    commonProvider.updateSelectedVirtualBgIndex(idx);
                                    commonProvider.getVirtualBg();
                                  },
                                  child: Padding(
                                    padding: EdgeInsets.all(12.0.sp),
                                    child: Container(
                                      height: 80.w,
                                      width: 80.w,
                                      decoration: BoxDecoration(
                                          border: Border.all(
                                            color: webinarThemesProvider.colors.headerColor,
                                          ),
                                          borderRadius: BorderRadius.all(Radius.circular(10.r)),
                                          color: webinarThemesProvider.colors.itemColor ?? Theme.of(context).scaffoldBackgroundColor),
                                      child: Column(
                                        mainAxisAlignment: MainAxisAlignment.center,
                                        crossAxisAlignment: CrossAxisAlignment.center,
                                        children: [
                                          SvgPicture.asset(
                                            AppImages.bgm,
                                            height: 50.w,
                                            width: 50.w,
                                          ),
                                          // CachedNetworkImage(
                                          //   imageUrl: AppImages.achievement_icon,
                                          //   height: 60.h,
                                          //   width: 79.w,
                                          //   placeholder: (context, url) => Center(
                                          //     child: SizedBox(
                                          //       height: 20.h,
                                          //       width: 20.w,
                                          //       child: CircularProgressIndicator(
                                          //         strokeWidth: 2,
                                          //         color: Colors.white,
                                          //       ),
                                          //     ),
                                          //   ),
                                          //   errorWidget: (context, url, error) =>
                                          //       Icon(Icons.error),
                                          // ),
                                          height5,
                                          Text(
                                            commonProvider.virtualBgModel[idx].category,
                                            style: w400_12Poppins(color: webinarThemesProvider.colors.textColor != null ? Colors.white : Theme.of(context).disabledColor),
                                            overflow: TextOverflow.ellipsis,
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                );
                              },
                            ),
                          ),
                          height10,
                          Expanded(
                            child: ListView.builder(
                              itemCount: commonProvider.virtualBgModel[commonProvider.selectedVirtualBg].data.length,
                              /* commonProvider.getVirtualBgList!.length,*/
                              shrinkWrap: true,
                              scrollDirection: Axis.vertical,
                              itemBuilder: (context, index) {
                                return GestureDetector(
                                    onTap: () async {
                                      commonProvider.getVirtualBg();
                                    },
                                    child: Padding(
                                      padding: const EdgeInsets.all(4.0),
                                      child: Container(
                                        decoration: BoxDecoration(borderRadius: BorderRadius.circular(8), color: webinarThemesProvider.colors.cardColor ?? Theme.of(context).primaryColor),
                                        child: Theme(
                                            data: Theme.of(context).copyWith(dividerColor: Colors.transparent),
                                            child: ExpansionTile(
                                              collapsedIconColor: webinarThemesProvider.themeBackGroundColor != null ? Colors.white : Theme.of(context).disabledColor,
                                              iconColor: webinarThemesProvider.themeBackGroundColor != null ? Colors.white : Theme.of(context).disabledColor,
                                              textColor: webinarThemesProvider.themeBackGroundColor != null ? Colors.white : Theme.of(context).primaryColorLight,
                                              title: Text(
                                                commonProvider.virtualBgModel[commonProvider.selectedVirtualBg].data[index].subCategory,
                                                style: w400_15Poppins(color: webinarThemesProvider.colors.textColor != null ? Colors.white : Theme.of(context).disabledColor),
                                              ),
                                              children: [
                                                ListView.builder(
                                                    itemCount: commonProvider.virtualBgModel[commonProvider.selectedVirtualBg].data[index].data.length,
                                                    shrinkWrap: true,
                                                    physics: const NeverScrollableScrollPhysics(),
                                                    scrollDirection: Axis.vertical,
                                                    itemBuilder: (context, i) {
                                                      return Padding(
                                                        padding: EdgeInsets.all(4.0.sp),
                                                        child: Container(
                                                          decoration: BoxDecoration(
                                                            borderRadius: BorderRadius.circular(8.r),
                                                            color: webinarThemesProvider.colors.itemColor ?? Theme.of(context).cardColor,
                                                          ),
                                                          margin: EdgeInsets.only(left: 4.w, right: 4.w, bottom: 4.h),
                                                          child: Row(
                                                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                            children: [
                                                              SizedBox(
                                                                height: 50.w,
                                                                width: 50.w,
                                                                child: Padding(
                                                                  padding: EdgeInsets.all(6.0.sp),
                                                                  child: ImageServiceWidget(
                                                                    networkImgUrl: commonProvider.virtualBgModel[commonProvider.selectedVirtualBg].data[index].data[i].url,
                                                                  ),
                                                                ),
                                                              ),
                                                              Text(
                                                                commonProvider.virtualBgModel[commonProvider.selectedVirtualBg].data[index].data[i].name,
                                                                style: w400_15Poppins(color: Theme.of(context).primaryColorLight),
                                                              ),
                                                              Padding(
                                                                padding: EdgeInsets.only(right: 8.w),
                                                                child: CustomOutlinedButton(
                                                                  outLineBorderColor: webinarThemesProvider.colors.buttonColor,
                                                                  height: 35.h,
                                                                  buttonTextStyle: w400_13Poppins(color: Colors.white),
                                                                  buttonText: ConstantsStrings.apply,
                                                                  onTap: () {
                                                                    Future.delayed(const Duration(seconds: 5), () {
                                                                      Navigator.pop(context);
                                                                    });
                                                                  },
                                                                ),
                                                              ),
                                                            ],
                                                          ),
                                                        ),
                                                      );
                                                    })
                                              ],
                                            )),
                                      ),
                                    ));
                              },
                            ),
                          ),
                        ],
                      )
                    : Center(child: Lottie.asset(AppImages.loadingJson, height: 40.w, width: 40.w))),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                CustomButton(
                  width: 100.w,
                  buttonText: "Cancel",
                  buttonColor: webinarThemesProvider.colors.cardColor,
                  borderColor: webinarThemesProvider.colors.buttonColor,
                  textColor: Colors.white,
                  buttonTextStyle: w500_14Poppins(color: Colors.white),
                  onTap: () {
                    Navigator.pop(context);
                  },
                ),
                width10,
                CustomButton(
                  width: 100.w,
                  buttonText: "Upload",
                  buttonColor: webinarThemesProvider.colors.buttonColor ?? Colors.blue,
                  textColor: Colors.white,
                  onTap: () {
                    // TODO(appal): start upload
                  },
                ),
                width10
              ],
            )
          ],
        ),
      );
    });
  }

  showAlertDialog(BuildContext context, WebinarProvider webinarProvider, CommonProvider commonProvider, String text) {
    Widget cancelButton = TextButton(
      child: Text(
        "Cancel",
        style: w500_14Poppins(color: Colors.blueAccent),
      ),
      onPressed: () {
        Navigator.pop(context);
      },
    );
    Widget continueButton = TextButton(
      child: Text(
        "Continue",
        style: w500_14Poppins(color: Colors.blueAccent),
      ),
      onPressed: () {
        Navigator.pop(context);
        Navigator.pop(context);
      },
    );
    // set up the AlertDialog
    AlertDialog alert = AlertDialog(
      shape: const RoundedRectangleBorder(side: BorderSide(color: Colors.black)),
      content: Text(
        text,
        style: w400_14Poppins(),
      ),
      actions: [
        cancelButton,
        continueButton,
      ],
    );

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }

  imagepickerbottomsheet() {
    showModalBottomSheet(
        context: context,
        shape: const RoundedRectangleBorder(borderRadius: BorderRadius.only(topLeft: Radius.circular(10), topRight: Radius.circular(10))),
        builder: (BuildContext context) {
          return Container(
            decoration: BoxDecoration(color: Theme.of(context).primaryColor, borderRadius: const BorderRadius.only(topLeft: Radius.circular(10), topRight: Radius.circular(10))),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                ListTile(
                    leading: Icon(Icons.camera, color: Theme.of(context).primaryColorLight),
                    title: Text(
                      'Camera',
                      style: TextStyle(color: Theme.of(context).primaryColorLight),
                    ),
                    onTap: () {
                      Navigator.of(context).pop();
                      getFromCamera();
                    }),
                ListTile(
                    leading: Icon(Icons.image, color: Theme.of(context).primaryColorLight),
                    title: Text(
                      'Gallery',
                      style: TextStyle(color: Theme.of(context).primaryColorLight),
                    ),
                    onTap: () {
                      Navigator.of(context).pop();
                      getFromGallery();
                    }),
              ],
            ),
          );
        });
  }

  /// Get Image From Gallery
  Future<void> getFromGallery() async {
    XFile? pickedFile = await ImagePicker().pickImage(
      source: ImageSource.gallery,
    );
    if (pickedFile != null) {
      setState(() {
        image = File(pickedFile.path) as XFile?;
      });
    }
  }

  /// Get from Camera
  Future<void> getFromCamera() async {
    XFile? pickedFile = await ImagePicker().pickImage(
      source: ImageSource.camera,
      maxWidth: 1800,
      maxHeight: 1800,
    );
    if (pickedFile != null) {
      setState(() {
        image = File(pickedFile.path) as XFile?;
      });
    }
  }
}
