import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:o_connect/core/screen_configs.dart';
import 'package:o_connect/ui/utils/buttons_helper/custom_botton.dart';
import 'package:o_connect/ui/utils/colors/colors.dart';
import 'package:o_connect/ui/utils/custom_toast_helper/custom_toast.dart';
import 'package:o_connect/ui/utils/images/images.dart';
import 'package:o_connect/ui/utils/textfield_helper/app_fonts.dart';
import 'package:o_connect/ui/views/share_files/provider/share_files_provider.dart';
import 'package:provider/provider.dart';

class DownloadShareFileDialog extends StatelessWidget {
  const DownloadShareFileDialog({super.key});

  @override
  Widget build(BuildContext context) {
    debugPrint("the link is the ${context.read<ShareFilesProvider>().shareFileDownloadUrl}");
    return Container(
      padding: EdgeInsets.symmetric(vertical: 8.h),
      decoration: BoxDecoration(color: Colors.black.withOpacity(0.2), borderRadius: BorderRadius.circular(15.r)),
      child: Row(crossAxisAlignment: CrossAxisAlignment.center, children: [
        width5,
        Selector<ShareFilesProvider, String?>(selector: (ctx, provider) {
          return provider.fileName;
        }, builder: (_, data, __) {
          return Text(
            (data != null && data.length > 25) ? "${data.substring(0, 25)}..." : data.toString(),
            style: w500_14Poppins(color: Colors.white),
          );
        }),
        const Spacer(),
        CustomButton(
          buttonText: "Download",
          width: ScreenConfig.width * 0.25,
          height: 40.h,
          onTap: () {
            if (context.read<ShareFilesProvider>().shareFileDownloadUrl != null) {
              context.read<ShareFilesProvider>().downloadSharedFile();
            } else {
              CustomToast.showErrorToast(msg: "Error while download file");
            }
          },
        ),
        width10,
        InkWell(
            onTap: () {
              context.read<ShareFilesProvider>().resetState();
            },
            child: SvgPicture.asset(
              AppImages.popUpCancelIcon,
              height: 24.w,
              width: 24.w,
            )),
      ]),
    );
  }
}

class ShareFileDownloadFloadingPopUp extends StatelessWidget {
  const ShareFileDownloadFloadingPopUp({super.key});

  @override
  Widget build(BuildContext context) {
    return Selector<ShareFilesProvider, bool>(selector: (ctx, provider) {
      return provider.showDownloadPopUp;
    }, builder: (_, data, __) {
      return data ? Align(alignment: Alignment.topCenter, child: const DownloadShareFileDialog()) : const SizedBox.shrink();
    });
  }
}
