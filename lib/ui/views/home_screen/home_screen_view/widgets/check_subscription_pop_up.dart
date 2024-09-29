import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:lottie/lottie.dart';
import 'package:o_connect/core/screen_configs.dart';
import 'package:o_connect/ui/utils/buttons_helper/custom_botton.dart';
import 'package:o_connect/ui/utils/colors/colors.dart';
import 'package:o_connect/ui/utils/common_app_bar/account_logout_page.dart';
import 'package:o_connect/ui/utils/images/images.dart';
import 'package:o_connect/ui/utils/textfield_helper/app_fonts.dart';
import 'package:url_launcher/url_launcher.dart';

class CheckSubscriptionPopUp extends StatelessWidget {
  const CheckSubscriptionPopUp({super.key, this.fromLogin = false});

  final bool fromLogin;

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
        child: AlertDialog(
          backgroundColor: Theme.of(context).cardColor,
          elevation: 0,
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Align(
                alignment: Alignment.topRight,
                child: GestureDetector(
                  onTap: () {
                    Navigator.pop(context);
                  },
                  child: Transform.rotate(
                      angle: 40,
                      child: Icon(
                        Icons.add,
                        color: Colors.white,
                        size: 20.sp,
                      )),
                ),
              ),
              Text(
                "SUBSCRIBE",
                style: w500_18Poppins(color: Colors.blue),
              ),
              height15,
              Text(
                "You haven't subscribed OCONNECT product.Please subscribe the product to continue",
                style: w400_14Poppins(color: Theme.of(context).primaryColorLight),
                textAlign: TextAlign.center,
              ),
            ],
          ),
          actions: [
            if (!fromLogin)
              TextButton(
                  onPressed: () {
                    logOut(context);
                  },
                  child: Text(
                    "Logout",
                    style: w400_14Poppins(color: Colors.blue),
                  )),
            Center(
              child: CustomButton(
                width: ScreenConfig.width * 0.4,
                height: 35.h,
                buttonColor: Colors.blue,
                onTap: () async {
                  await launchUrl(
                    Uri.parse("https://obs-qa.onpassive.com/"),
                  );
                },
                buttonText: "Subscribe",
              ),
            ),
            height10
          ],
        ),
        onWillPop: () async => true);
  }
}

class SubscriptionExpirePopUp extends StatelessWidget {
  const SubscriptionExpirePopUp({super.key});

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      elevation: 0,
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          SizedBox(width: 100.w, height: 100.w, child: Lottie.asset(AppImages.splashImage)),
          Text(
            "Your subscription completed.Please renew your subscription",
            textAlign: TextAlign.center,
            style: w500_14Poppins(color: Theme.of(context).hintColor),
          ),
        ],
      ),
      actions: [
        GestureDetector(
            onTap: () async {
              print("clicked");
              await launchUrl(
                Uri.parse("https://obs-qa.onpassive.com/"),
              );
            },
            child: Text("Subscribe", style: w400_14Poppins(color: Colors.blue)))
      ],
    );
  }
}

class SubScriptionEndsInDays extends StatelessWidget {
  const SubScriptionEndsInDays({super.key, required this.noOfDays});
  final int noOfDays;

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      elevation: 0,
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          SizedBox(width: 100.w, height: 100.w, child: Lottie.asset(AppImages.splashImage)),
          Text(
            "Renew your OCONNECT subscription early for a seamless experience",
            textAlign: TextAlign.center,
            style: w500_14Poppins(color: Theme.of(context).hintColor),
          ),
          height10,
          Text("Expires in $noOfDays Days"),
          height5,
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              CustomButton(
                width: 100.w,
                height: 35.h,
                buttonColor: Colors.transparent,
                buttonTextStyle: w500_14Poppins(color: Colors.blue),
                borderColor: Colors.blue,
                buttonText: "Later",
                onTap: (() {
                  Navigator.pop(context, true);
                }),
              ),
              width10,
              CustomButton(
                width: 100.w,
                height: 35.h,
                buttonText: "Renew",
                buttonColor: AppColors.calendarIconColor,
                onTap: () async {
                  await launchUrl(
                    Uri.parse("https://obs-qa.onpassive.com/"),
                  );
                },
              )
            ],
          )
        ],
      ),
      /*      actions: [
        GestureDetector(
            onTap: () async {
              /*   print("clicked");
              await launchUrl(
                Uri.parse("https://obs-qa.onpassive.com/"),
              ); */
            },
            child: Text("Subscribe", style: w400_14Poppins(color: Colors.blue)))
      ], */
    );
  }
}
