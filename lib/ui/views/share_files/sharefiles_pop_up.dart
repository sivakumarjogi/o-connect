import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:o_connect/core/enum/view_state_enum.dart';
import 'package:o_connect/ui/utils/buttons_helper/close_apply_buttons.dart';
import 'package:o_connect/ui/utils/colors/colors.dart';
import 'package:o_connect/ui/utils/custom_show_dialog_helper/custom_show_dialog.dart';
import 'package:o_connect/ui/utils/textfield_helper/app_fonts.dart';
import 'package:o_connect/ui/views/share_files/provider/share_files_provider.dart';
import 'package:o_connect/ui/views/themes/providers/webinar_themes_provider.dart';
import 'package:provider/provider.dart';

class ShareFilesPopUp extends StatelessWidget {
  const ShareFilesPopUp({super.key});

  @override
  Widget build(BuildContext context) {
    return PopScope(
        canPop: true,
        onPopInvoked: (didPop) {
          context.read<ShareFilesProvider>().pickedFile = null;
        },
        child: Padding(
          padding: EdgeInsets.all(8.0.sp),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              showDialogCustomHeader(context, headerTitle: "File Share", backNavigationRequired: false),
              Selector<ShareFilesProvider, ShareFilesRadioButtons>(
                selector: (ctx, provider) {
                  return provider.selectedFileType;
                },
                builder: (context, value, child) {
                  return Row(
                    children: [
                      Row(
                        children: [
                          Radio(
                            activeColor: Colors.blue,
                            visualDensity: const VisualDensity(horizontal: VisualDensity.minimumDensity, vertical: VisualDensity.minimumDensity),
                            value: ShareFilesRadioButtons.all,
                            groupValue: value,
                            onChanged: (value) {
                              context.read<ShareFilesProvider>().updateSelectedRaioButtonOption(value ?? ShareFilesRadioButtons.all);
                            },
                          ),
                          const Text("All")
                        ],
                      ),
                      width10,
                      Row(
                        children: [
                          Radio(
                            activeColor: Colors.blue,
                            visualDensity: const VisualDensity(horizontal: VisualDensity.minimumDensity, vertical: VisualDensity.minimumDensity),
                            value: ShareFilesRadioButtons.speakers,
                            groupValue: value,
                            onChanged: (value) {
                              context.read<ShareFilesProvider>().updateSelectedRaioButtonOption(value ?? ShareFilesRadioButtons.speakers);
                            },
                          ),
                          const Text("Speakers")
                        ],
                      ),
                    ],
                  );
                },
              ),
              height10,
              Text(
                "Upload Files",
                style: w400_12Poppins(color: Colors.white),
              ),
              height5,
              InkWell(
                onTap: () {
                  context.read<ShareFilesProvider>().pickFile();
                },
                child: Container(
                  height: 40.h,
                  padding: EdgeInsets.symmetric(horizontal: 10.w),
                  decoration: BoxDecoration(color: context.read<WebinarThemesProviders>().colors.itemColor, border: Border.all(color: Colors.grey, width: 1), borderRadius: BorderRadius.circular(5.r)),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Selector<ShareFilesProvider, String?>(selector: (ctx, provider) {
                        return provider.pickedFile;
                      }, builder: (_, value, __) {
                        return Text(
                          value != null && value.split("/").last.length > 40 ? "${value.split("/").last.substring(0, 40)}..." : value?.split("/").last ?? "upload here",
                          style: w400_12Poppins(color: Colors.grey[300]),
                        );
                      }),
                      const Icon(Icons.cloud_upload_outlined)
                    ],
                  ),
                ),
              ),
              height5,
              Text(
                "Maximum Upload file size: 50 MB.",
                style: w400_10Poppins(color: const Color(0xff8F93A3)),
              ),
              const Spacer(),
              CloseApplyButtons(
                leftButtonText: "Close",
                rightButtonText: "Send",
                leftButtonBorderColor: Colors.transparent,
                closeOnTap: () {
                  Navigator.pop(context);
                },
                applyOnTap: () {
                  context.read<ShareFilesProvider>().uploadFile();
                },
              )
            ],
          ),
        ));
  }
}
