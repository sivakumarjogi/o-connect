import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:o_connect/core/providers/common_provider.dart';
import 'package:o_connect/core/providers/theme_provider.dart';
import 'package:o_connect/core/screen_configs.dart';
import 'package:o_connect/core/service_locator.dart';
import 'package:o_connect/core/user_cache_service.dart';
import 'package:o_connect/my_app.dart';
import 'package:o_connect/ui/utils/base_urls.dart';
import 'package:o_connect/ui/utils/colors/colors.dart';
import 'package:o_connect/ui/utils/constant_strings.dart';
import 'package:o_connect/ui/utils/custom_switch_helper/custom_switch_helper.dart';
import 'package:o_connect/ui/utils/images/images.dart';
import 'package:o_connect/ui/utils/textfield_helper/app_fonts.dart';
import 'package:o_connect/ui/views/authentication/Auth_providers/auth_api_provider.dart';
import 'package:o_connect/ui/views/drawer/contacts/contact_tab_view.dart';
import 'package:o_connect/ui/views/drawer/custom_drawer_view.dart';
import 'package:o_connect/ui/views/more/archive_screen.dart';
import 'package:o_connect/ui/views/new_calandar/presentation/new_calander.dart';
import 'package:oes_chatbot/oes_chatbot.dart';
import 'package:provider/provider.dart';

import '../profile_screen/profile_provider/profile_api_provider.dart';

class MoreScreen extends StatefulWidget {
  const MoreScreen({super.key});

  @override
  State<MoreScreen> createState() => _MoreScreenState();
}

class _MoreScreenState extends State<MoreScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(body: Consumer<ThemeProvider>(builder: (context, themeProvider, child) {
      return Padding(
        padding: EdgeInsets.all(10.0.sp),
        child: Column(
          children: [
            SingleChildScrollView(
              scrollDirection: Axis.vertical,
              child: Column(
                children: [
                  GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) {
                              return const AllContactsPage();
                            },
                          ),
                        );
                      },
                      child: Container(
                          height: 50.h,
                          width: ScreenConfig.width * 0.94,
                          decoration: BoxDecoration(color: Theme.of(context).cardColor),
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Row(
                              children: [
                                SvgPicture.asset(AppImages.moreContactsIcon),
                                const Text(" Contacts"),
                              ],
                            ),
                          ))),
                  height10,
                  GestureDetector(
                      onTap: () {
                        Navigator.push(
                          navigationKey.currentState!.context,
                          MaterialPageRoute(
                            builder: (context) {
                              //   return const MyCalenderScreen();
                              return const NewCalendar();
                            },
                          ),
                        );
                      },
                      child: Container(
                          height: 50.h,
                          width: ScreenConfig.width * 0.94,
                          decoration: BoxDecoration(color: Theme.of(context).cardColor),
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Row(
                              children: [
                                SvgPicture.asset(AppImages.moreCalendarIcon),
                                const Text(" Calendar"),
                              ],
                            ),
                          ))),
                  height10,
                  GestureDetector(
                      onTap: () {
                        // CustomToast.showInfoToast(msg: "Coming soon...");
                        Navigator.push(context, MaterialPageRoute(builder: (context) {
                          return const ArchiveScreen();
                        }));
                      },
                      child: Container(
                          height: 50.h,
                          width: ScreenConfig.width * 0.94,
                          decoration: BoxDecoration(color: Theme.of(context).cardColor),
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Row(
                              children: [
                                SvgPicture.asset(AppImages.moreArchiveIcon),
                                const Text(" Archive"),
                              ],
                            ),
                          ))),
                ],
              ),
            ),
            const Spacer(),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  width: ScreenConfig.width * 0.42,
                  padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 6.h),
                  decoration: ShapeDecoration(
                    color: Theme.of(context).cardColor,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                  ),
                  child: Row(
                    children: [
                      // themeProvider.isLightTheme
                      //     ? Container(
                      //         height: 24.h,
                      //         width: 24.w,
                      //         padding: const EdgeInsets.symmetric(horizontal: 3, vertical: 4),
                      //         decoration: ShapeDecoration(
                      //           color: const Color(0xFFEEF0FF),
                      //           shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
                      //         ),
                      //         child: SvgPicture.asset(AppIcons.drawerSun))
                      //     : SvgPicture.asset(AppImages.darkTheme),
                      // width30,
                      Text(
                        themeProvider.isLightTheme ? ConstantsStrings.light : ConstantsStrings.dark,
                        style: w500_13Poppins(color: Theme.of(context).primaryColorLight),
                      ),
                      const Spacer(),
                      Consumer<CommonProvider>(builder: (context, data, child) {
                        return CustomSwitch(
                            value: data.isDarkTheme,
                            onChanged: (val) {
                              // themeProvider.selectedTheme(val);
                            });
                      }),
                    ],
                  ),
                ),
                SizedBox(
                  width: ScreenConfig.width * 0.42,
                  child: Padding(
                    padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 6.h),
                    child: Builder(builder: (parentContext) {
                      return InkWell(
                        onTap: () async {
                          print(BaseUrls.flavor);
                          final String? token = await serviceLocator<UserCacheService>().getToken();
                          Map<String, dynamic>? headerJson = parentContext.read<AuthApiProvider>().profileData?.data?.toJson();
                          String? mobileNumber = parentContext.read<ProfileScreenProvider>().profileInfoData?.mobileNumber;
                          if (headerJson != null && mobileNumber != null) {
                            headerJson["mobileNumber"] = mobileNumber;
                            await SetUpEnv.setDevEnvironment(
                              flavor: BaseUrls.flavor,
                              oesToken: token ?? "",
                              serviceLocator: serviceLocator,
                              headerData: headerJson,
                              navigatorKeyContext: navigationKey.currentContext,
                            );
                            // ignore: use_build_context_synchronously
                            Navigator.push(
                              parentContext,
                              MaterialPageRoute(
                                builder: (context) {
                                  return const ChatBotWidget();
                                },
                              ),
                            );
                          }
                        },
                        child: Container(
                          padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 6.h),
                          decoration: ShapeDecoration(
                            color: Theme.of(context).cardColor,
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8.r)),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                ConstantsStrings.OChatbot,
                                style: w500_13Poppins(color: Theme.of(context).primaryColorLight),
                              ),
                              width20,
                              SvgPicture.asset(
                                AppImages.botIcon,
                                width: 24.w,
                                height: 24.w,
                              )
                            ],
                          ),
                        ),
                      );
                    }),
                  ),
                ),
              ],
            ),
            height10,
            Text(
              "Version:1.0.2+20",
              style: w400_12Poppins(color: Colors.white),
            )
          ],
        ),
      );
    }));
  }
}
