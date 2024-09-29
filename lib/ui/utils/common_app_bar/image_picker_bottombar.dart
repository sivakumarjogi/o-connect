import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:o_connect/ui/utils/colors/colors.dart';
import 'dart:async';

import 'package:o_connect/ui/utils/custom_show_dialog_helper/custom_show_dialog.dart';
import 'package:o_connect/ui/utils/textfield_helper/app_fonts.dart';
import 'package:o_connect/ui/views/themes/providers/webinar_themes_provider.dart';
import 'package:provider/provider.dart';

class ImagePickerService {
  static Future<XFile?> imagePickerBottomSheet(BuildContext context) async {
    Completer<XFile?> completer = Completer<XFile?>(); // Create a Completer

    Widget cameraOptionCard({required VoidCallback onTap, bool isCamera = true}) {
      return GestureDetector(
        onTap: onTap,
        child: Container(
          margin: EdgeInsets.symmetric(horizontal: 16.w, vertical: 5.h),
          padding: EdgeInsets.symmetric(vertical: 8.h, horizontal: 15.w),
          decoration: BoxDecoration(color: AppColors.mediumBG, borderRadius: BorderRadius.circular(5.r)),
          child: Row(
            children: [
            
              Icon(isCamera ? Icons.camera_alt : Icons.image, color: Colors.white),
              width15,
              Text(
                isCamera ? 'Camera' : 'Gallery',
                style: w400_14Poppins(color: Colors.white),
              )
            ],
          ),
        ),
      );
    }

    showModalBottomSheet(
      context: context,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.only(topLeft: Radius.circular(25.r), topRight: Radius.circular(25.r))),
      builder: (BuildContext context) {
        context.read<WebinarThemesProviders>().setupDefaultColors();
        return Container(
          decoration: BoxDecoration(color: context.read<WebinarThemesProviders>().colors.headerColor, borderRadius: BorderRadius.only(topLeft: Radius.circular(25.r), topRight: Radius.circular(25.r))),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              showDialogCustomHeader(context, headerTitle: "Profile Image", removeDivider: true),
              height10,
              cameraOptionCard(onTap: () async {
                Navigator.of(context).pop();
                XFile? imageFile = await getImage(ImageSource.camera);
                completer.complete(imageFile);
              }),
              cameraOptionCard(
                  isCamera: false,
                  onTap: () async {
                    Navigator.of(context).pop();
                    XFile? imageFile = await getImage(ImageSource.gallery);
                    completer.complete(imageFile);
                  }),
              TextButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: Text(
                    "Close",
                    style: w400_14Poppins(color: Colors.blue),
                  ))
            ],
          ),
        );
      },
    );

    XFile? selectedImage = await completer.future; // Wait for the Future to complete
    return selectedImage;
  }

  static Future<XFile?> getImage(ImageSource source) async {
    XFile? pickedFile = await ImagePicker().pickImage(
      source: source,
    );
    if (pickedFile != null) {
      final croppedFile = await ImageCropper().cropImage(
        sourcePath: pickedFile.path,
        compressFormat: ImageCompressFormat.jpg,
        compressQuality: 100,
        uiSettings: [
          AndroidUiSettings(
              toolbarTitle: 'Crop Image',
              toolbarColor: AppColors.popUpBGColor,
              toolbarWidgetColor: Colors.white,
              initAspectRatio: CropAspectRatioPreset.original,
              lockAspectRatio: false),
          IOSUiSettings(
            title: 'Crop Image',
          ),
        ],
      );
      
      XFile imageFile = croppedFile != null ?  XFile(croppedFile.path) : pickedFile;
      // XFile imageFile = pickedFile;
      return imageFile;
      // return pickedFile.path;
    }
    return null;
  }
}
