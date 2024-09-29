import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:o_connect/ui/utils/colors/colors.dart';
import 'package:o_connect/ui/utils/textfield_helper/app_fonts.dart';
import 'package:o_connect/ui/views/push_link/provider/push_link_provider.dart';
import 'package:o_connect/ui/views/themes/providers/webinar_themes_provider.dart';
import 'package:o_connect/ui/views/webinar_details/webinar_details_provider/webinar_provider.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';

class PushLinkFloatingPopUp extends StatelessWidget {
  const PushLinkFloatingPopUp({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<PushLinkProvider>(builder: (context, pushLinkProvider, child) {
      return Container(
        height: 40.h,
        alignment: Alignment.center,
        // width: MediaQuery.of(context).size.width,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(5.r),
          color: context.read<WebinarThemesProviders>().unSelectButtonsColor,
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            GestureDetector(
              onTap: () async {
                String? finalUrl = pushLinkProvider.url!.startsWith("https") ? pushLinkProvider.url : "https://${pushLinkProvider.url}";
                await launchUrl(
                  Uri.parse(finalUrl ?? "https://www.onpassive.com/"),
                );
              },
              child: Text(
                pushLinkProvider.url ?? "",
                style: w500_14Poppins(color: AppColors.whiteColor),
              ),
            ),
            width10,
            Padding(
              padding: EdgeInsets.all(2.0.sp),
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 5.w, vertical: 5.h),
                decoration: BoxDecoration(borderRadius: BorderRadius.circular(5.r), color: context.watch<WebinarThemesProviders>().colors.buttonColor),
                child: GestureDetector(
                  onTap: () async {
                    String? finalUrl = pushLinkProvider.url!.startsWith("https") ? pushLinkProvider.url : "https://${pushLinkProvider.url}";
                    await launchUrl(
                      Uri.parse(finalUrl ?? "https://www.onpassive.com/"),
                    );
                  },
                  child: Text(
                    pushLinkProvider.title ?? "",
                    style: w500_14Poppins(color: AppColors.whiteColor),
                  ),
                ),
              ),
            ),
            width10,
            InkWell(
              child: SvgPicture.asset(
                "assets/new_ui_icons/webinar_dashboard/miniView.svg",
                height: 24.w,
                width: 24.w,
              ),
              onTap: () {
                context.read<WebinarProvider>().disableActiveFuture();
              },
            ),
            width10,
            if (pushLinkProvider.myHubInfo.isHostOrActiveHost || pushLinkProvider.myHubInfo.isCohost)
              InkWell(
                child: SvgPicture.asset(
                  "assets/new_ui_icons/webinar_dashboard/cancel.svg",
                  height: 24.w,
                  width: 24.w,
                ),
                onTap: () {
                  pushLinkProvider.removePushLink(context).then((value) => context.read<WebinarProvider>().disableActiveFuture());
                },
              ),
            width5
          ],
        ),
      );
    });
  }
}
