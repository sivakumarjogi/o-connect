import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:o_connect/ui/utils/base_urls.dart';
import 'package:o_connect/ui/utils/common_app_bar/all_products.dart';
import 'package:o_connect/ui/utils/common_app_bar/notifications.dart';
import 'package:o_connect/ui/utils/custom_toast_helper/custom_toast.dart';
import 'package:o_connect/ui/utils/images/images.dart';
import 'package:o_connect/ui/utils/network_image_helpers/cached_image_validation.dart';

import 'package:o_connect/ui/views/authentication/Auth_providers/auth_api_provider.dart';
import 'package:o_connect/ui/views/home_screen/home_screen_provider/home_screen_provider.dart';
import 'package:o_connect/ui/views/notification_screen/notification_screen.dart';

import 'package:o_connect/ui/views/pip_views/pip_global_navigation.dart';
import 'package:oes_chatbot/utils/extensions/sizedbox_extension.dart';
import 'package:provider/provider.dart';

import '../../views/profile_screen/profile_view/profile_page.dart';

AppBar commonAppBar(BuildContext context, {bool showPopUp = true, String? titleName, bool logoNotVisible = false}) {
  return AppBar(
    toolbarHeight: 50.h,
    iconTheme: IconThemeData(color: Theme.of(context).disabledColor, size: 22.sp),
    elevation: 0,
    titleSpacing: 0,
    automaticallyImplyLeading: logoNotVisible != null && logoNotVisible! ? false : true,
    title: logoNotVisible != null && logoNotVisible!
        ? Padding(
            padding: EdgeInsets.only(left: 8.0.sp),
            child: GestureDetector(
              onTap: () {
                Navigator.pop(context);
              },
              child: Padding(
                padding: EdgeInsets.only(left: 20.w, right: 5.w),
                child: SvgPicture.asset(
                  AppImages.backIcon,
                  width: 24.w,
                  height: 24.h,
                ),
              ),
            ),
          )
        : Padding(
            padding: EdgeInsets.only(left: 8.0.sp),
            child: SvgPicture.asset(
              AppImages.logo,
              width: 24.w,
              height: 24.h,
            ),
          ),
    backgroundColor: Theme.of(context).cardColor,
    actions: [
      // GestureDetector(
      // onTap: () {
      //   // CustomToast.showInfoToast(msg: "Coming Soon...");

      //   customShowDialog(context, const JoinWithMeetingId());
      // },
      // child: Padding(
      //   padding: EdgeInsets.symmetric(horizontal: 5.w),
      //   child: SvgPicture.asset(
      //     AppImages.comments,
      //     height: 20.w,
      //     width: 20.w,
      //   ),
      // )),
      GestureDetector(
          onTap: () {
            // CustomToast.showInfoToast(msg: "Coming Soon...");

            // customShowDialog(context, const NotificationScreen());
            Navigator.push(context, MaterialPageRoute(builder: (context) => const PIPGlobalNavigation(childWidget: NotificationsScreen())));
          },
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 4.w),
            child: Consumer<HomeScreenProvider>(builder: (context, homeScreenProvider, data) {
              return Stack(
                children: [
                  // Positioned(
                  //     left: 15,
                  //     child: Container(
                  //       height: 7.h,
                  //       width: 6.w,
                  //       decoration: BoxDecoration(shape: BoxShape.circle, color: Colors.red),
                  //     )),
                  SvgPicture.asset(
                    AppImages.notificationIcon,
                    height: 20.w,
                    width: 20.w,
                  ),
                ],
              );
            }),
          )),
      5.w.width,
      GestureDetector(
          onTap: () {
            // CustomToast.showInfoToast(msg: "Coming Soon...");
            // customShowDialog(context, const AllproductsScreen(),
            //     height: MediaQuery.of(context).size.height * 0.7);
            Navigator.push(context, MaterialPageRoute(builder: (context) => const PIPGlobalNavigation(childWidget: AllProductsScreen())));
          },
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 5.w),
            child: SvgPicture.asset(
              AppImages.categoryIcon,
              height: 22.w,
              width: 22.w,
            ),
          )),
      5.w.width,

      Consumer<AuthApiProvider>(builder: (context, authProvider, child) {
        return GestureDetector(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 5.w, vertical: 12.h),
            child: Container(
              decoration: BoxDecoration(
                border: Border.all(color: Colors.white24),
                borderRadius: BorderRadius.circular(50.r),
              ),
              height: 25.h,
              width: 25.w,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(50.r),
                child: ImageServiceWidget(networkImgUrl: "${BaseUrls.imageUrl}${authProvider.profileData?.data!.profilePic}"),
              ),
            ),
          ),
          onTap: () {
            if (showPopUp) {
              // showDialog(
              //   context: context,
              //   useRootNavigator: false,
              //   builder: (context) {
              //     return const AccountLogoutPage();
              //   },
              // );
              Navigator.push(context, MaterialPageRoute(builder: (context) => const ProfilePage()));
              return;
            } else {
              Navigator.pop(context);
              return;
            }
          },
        );
      })
    ],
  );
}
