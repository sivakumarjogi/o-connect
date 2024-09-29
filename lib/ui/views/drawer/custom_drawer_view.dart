import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:o_connect/core/providers/common_provider.dart';
import 'package:o_connect/core/routes/routes_name.dart';
import 'package:o_connect/core/service_locator.dart';
import 'package:o_connect/core/user_cache_service.dart';
import 'package:o_connect/my_app.dart';
import 'package:o_connect/ui/utils/base_urls.dart';
import 'package:o_connect/ui/utils/colors/colors.dart';
import 'package:o_connect/ui/utils/constant_strings.dart';
import 'package:o_connect/ui/utils/custom_switch_helper/custom_switch_helper.dart';
import 'package:o_connect/ui/utils/custom_toast_helper/custom_toast.dart';
import 'package:o_connect/ui/utils/icon_constants/icon_constant.dart';
import 'package:o_connect/ui/utils/images/images.dart';
import 'package:o_connect/ui/views/authentication/Auth_providers/auth_api_provider.dart';
import 'package:o_connect/ui/views/home_screen/home_screen_provider/home_screen_provider.dart';
import 'package:o_connect/ui/views/home_screen/home_screen_view/home_screen.dart';
import 'package:o_connect/ui/views/profile_screen/profile_provider/profile_api_provider.dart';
import 'package:oes_chatbot/chat_bot/bloc/chat_bot_bloc/chat_bot_bloc.dart';
import 'package:oes_chatbot/oes_chatbot.dart';
import 'package:oes_chatbot/ticket_status/bloc/ticket_count_bloc/ticket_count_bloc.dart';
import 'package:oes_chatbot/ticket_status/bloc/ticket_details_bloc/ticket_details_bloc.dart';
import 'package:oes_chatbot/ticket_status/bloc/ticket_details_by_id_bloc/ticket_details_by_id_bloc.dart';
import 'package:oes_chatbot/ticket_status/presentation/ticket_status_screen.dart';
import 'package:provider/provider.dart';

import '../../../core/providers/theme_provider.dart';
import '../../utils/textfield_helper/app_fonts.dart';
import '../pip_views/pip_global_navigation.dart';
import '../webinar_details/webinar_details_provider/webinar_details_provider.dart';
import 'drawer_viewmodel.dart';

class CustomDrawerView extends StatelessWidget {
  const CustomDrawerView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final controller = Provider.of<DrawerViewModel>(context);
    final theme = Theme.of(context);
    return SafeArea(
      child: Consumer<ThemeProvider>(builder: (context, themeProvider, child) {
        return SizedBox(
            width: 250.w,
            child: Drawer(
              backgroundColor: Theme.of(context).scaffoldBackgroundColor,
              shadowColor: AppColors.scaffoldBackGroundDarkColor,
              child: Column(
                children: [
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 10.h),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        SvgPicture.asset(
                          AppImages.drawerLogo,
                        ),
                        const Spacer(),
                        Text(
                          "v1.0.0+36",
                          style: w400_12Poppins(color: Theme.of(context).disabledColor),
                        )
                      ],
                    ),
                  ),
                  SizedBox(
                    height: 2.5.h,
                  ),
                  mainOption(ConstantsStrings.home, AppImages.homeIcon, AppIcons.drawerHomeblue, themeProvider, RoutesManager.homeScreen, context, controller),
                  mainOption(ConstantsStrings.webinar, AppImages.webinarIcon, AppIcons.drawerWebinarblue, themeProvider, RoutesManager.webinar, context, controller),
                  // mainOption(ConstantsStrings.library, AppImages.libraryIcon, AppIcons.drawerLibraryblue, themeProvider, RoutesManager.library, context, controller),
                  // library(theme, controller, context),
                  mainOption(ConstantsStrings.myContacts, AppImages.contactIcon, AppIcons.drawerContactblue, themeProvider, RoutesManager.allContacts, context, controller),
                  mainOption(ConstantsStrings.archive, AppImages.archiveIcon, AppImages.archiveIconBlue, themeProvider, RoutesManager.archive, context, controller),
                  mainOption(ConstantsStrings.calender, AppImages.calendarIconDrawer, AppImages.calendarDrawerIconBlue, themeProvider, RoutesManager.calender, context, controller),
                  mainOption(ConstantsStrings.settings, AppImages.settingsIcon, AppIcons.drawerSettingsblue, themeProvider, RoutesManager.settings, context, controller),
                  // const Spacer(),
                ],
              ),
            ));
      }),
    );
  }

  mainOption(
    String value,
    String icon,
    String selectedIcon,
    themeProvider,
    String page,
    BuildContext context,
    DrawerViewModel controller,
  ) {
    return InkWell(
      onTap: () {
        controller.expandableSelectedChange('');
        controller.mainSelectedChange(value);
        print(page);
        if (page == "/home" || page == "/library" || page == "/allcontacts" || page == '/calender') {
          if (page == "/home") {
            pushNamedAndRemoveUntil(context, const HomeScreen());
            // Navigator.pushNamedAndRemoveUntil(context, '/home', (route) => false);
          } else {
            Navigator.pushNamed(context, page);
          }
        } else if (page == "/webinar") {
          Provider.of<HomeScreenProvider>(context, listen: false).selectedValue = "upcoming";
          Provider.of<WebinarDetailsProvider>(context, listen: false).selectedValue = ConstantsStrings.upcomingWebinars;
          Navigator.pushNamed(context, page);
        } else {
          CustomToast.showInfoToast(msg: "Coming Soon...");
        }
        if (Scaffold.of(context).isDrawerOpen) {
          Scaffold.of(context).closeDrawer();
        }
      },
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 12.h),
        child: Row(
          children: [
            SvgPicture.asset(
              controller.mainSelected == value ? selectedIcon : icon,
              width: 24.w,
              height: 24.w,
            ),
            width10,
            Text(
              value,
              style: w500_14Poppins(
                color: Theme.of(context).primaryColorLight,
              ),
            ),
          ],
        ),
      ),
    );
  }

  mainInnerOption(String value, String icon, String selectedIcon, themeProvider, String page, BuildContext context, DrawerViewModel controller) {
    var themeData = themeProvider.isLightTheme ? AppColors.scaffoldBackGroundLightColor : AppColors.scaffoldBackGroundDarkColor;

    return InkWell(
      onTap: () {
        // Get.offNamed(page);
        Navigator.pushNamed(context, page);
      },
      child: Container(
        color: controller.mainSelected == value ? AppColors.blackColor : themeData,
        height: 36.h,
        child: Row(
          children: [
            SizedBox(
              width: 72.w,
              height: 48.h,
              child: Align(
                alignment: Alignment.centerRight,
                child: SvgPicture.asset(controller.mainSelected == value ? selectedIcon : icon, width: 24.w, height: 24.w),
              ),
            ),
            SizedBox(
              width: 12.w,
            ),
            Text(value,
                style: w500_14Poppins(
                  color: themeProvider.isLightTheme ? AppColors.lightBlackColor : AppColors.darkWhiteColor,
                )),
          ],
        ),
      ),
    );
  }

  /* library(themeProvider, DrawerViewModel controller, BuildContext context) {
    var themeData = themeProvider.isLightTheme ? AppColors.scaffoldBackGroundLightColor : AppColors.scaffoldBackGroundDarkColor;
    return controller.expandableSelected == ConstantsStrings.library
        ? Column(
            children: [
              expandedOption(ConstantsStrings.library, AppIcons.drawerLibraryblue, themeProvider, controller, context),
              mainInnerOption(ConstantsStrings.autoRecordings, AppIcons.drawerAutorecording, AppIcons.drawerAutorecordingblue, themeProvider, RoutesManager.autoRecorings, context, controller),
              // mainInnerOption(ConstantsStrings.presentations, AppIcons.drawerPresentations, AppIcons.drawerPresentationsblue, themeProvider, RoutesManager.presentations, context, controller),
              mainInnerOption(ConstantsStrings.whiteboard, AppIcons.drawerWhiteboard, AppIcons.drawerWebinarblue, themeProvider, RoutesManager.whiteboard, context, controller),
              mainInnerOption(ConstantsStrings.qa, AppIcons.drawerQa, AppIcons.drawerQablue, themeProvider, RoutesManager.qanda, context, controller),
              mainInnerOption(ConstantsStrings.chat, AppIcons.drawerChat, AppIcons.drawerChatblue, themeProvider, RoutesManager.chat, context, controller),
              mainInnerOption(ConstantsStrings.screenCaptures, AppIcons.drawerScreencapture, AppIcons.drawerScreencapblue, themeProvider, RoutesManager.screenCapture, context, controller),
              mainInnerOption(ConstantsStrings.template, AppIcons.drawerTemplate, AppIcons.drawerTemplateblue, themeProvider, RoutesManager.template, context, controller),
              mainInnerOption(ConstantsStrings.bgm, AppIcons.drawerBgm, AppIcons.drawerBgmblue, themeProvider, RoutesManager.bgm, context, controller),
            ],
          )
        : expandableOption(ConstantsStrings.library, AppIcons.drawerLibrary, themeProvider, controller);
  }*/

  InkWell expandedOption(String title, String icon, themeProvider, DrawerViewModel controller, BuildContext context) {
    var themeProvider = Provider.of<ThemeProvider>(context, listen: false);
    return InkWell(
      onTap: () {
        controller.expandableSelectedChange(title);
      },
      child: Container(
        color: themeProvider.isLightTheme ? AppColors.scaffoldBackGroundLightColor : AppColors.scaffoldBackGroundDarkColor,
        height: 48.h,
        child: Row(
          children: [
            SizedBox(
                width: 40.w,
                height: 48.h,
                child: Align(
                    alignment: Alignment.centerRight,
                    child: SvgPicture.asset(
                      icon,
                      width: 24.w,
                      height: 24.w,
                    ))),
            SizedBox(
              width: 12.w,
            ),
            SizedBox(
              width: 166.w,
              child: Text(
                title,
                style: w500_14Poppins(
                  color: themeProvider.isLightTheme ? AppColors.textFieldBackGroundLightColor : AppColors.textFieldBackGroundDarkColor,
                ),
              ),
            ),
            SizedBox(
              width: 13.w,
            ),
            SvgPicture.asset(
              AppIcons.drawerArrowup,
              width: 24.w,
              height: 24.w,
            ),
          ],
        ),
      ),
    );
  }

  InkWell expandableOption(String title, String icon, themeProvider, DrawerViewModel controller) {
    var themeData = themeProvider.isLightTheme ? AppColors.scaffoldBackGroundLightColor : AppColors.scaffoldBackGroundDarkColor;
    return InkWell(
      onTap: () {
        controller.expandableSelectedChange(title);
        controller.mainSelectedChange(title);
      },
      child: Container(
        color: themeData,
        height: 48.h,
        child: Row(
          children: [
            SizedBox(
                height: 48.h,
                width: 40.w,
                child: Align(
                    alignment: Alignment.centerRight,
                    child: SvgPicture.asset(
                      icon,
                      width: 24.w,
                      height: 24.w,
                    ))),
            SizedBox(
              width: 12.w,
            ),
            SizedBox(
              width: 165.w,
              child: Text(
                title,
                style: w500_14Poppins(
                  color: themeProvider.isLightTheme ? AppColors.lightBlackColor : AppColors.darkWhiteColor,
                ),
              ),
            ),
            SizedBox(
              width: 13.w,
            ),
            SvgPicture.asset(
              AppIcons.drawerArrowdown,
              width: 24.w,
              height: 24.w,
            ),
          ],
        ),
      ),
    );
  }

  contacts(themeProvider, DrawerViewModel controller, BuildContext context) {
    return controller.expandableSelected == ConstantsStrings.contacts
        ? Container(
            child: Column(
              children: [
                expandedOption(ConstantsStrings.contacts, AppIcons.drawerContactblue, themeProvider, controller, context),
                mainInnerOption(ConstantsStrings.allContacts, AppIcons.drawerAllcontacts, AppIcons.drawerContactblue, themeProvider, RoutesManager.allContacts, context, controller),
                mainInnerOption(ConstantsStrings.groups, AppIcons.drawerGroup, AppIcons.drawerGroupblue, themeProvider, RoutesManager.groups, context, controller),
              ],
            ),
          )
        : expandableOption(ConstantsStrings.contacts, AppIcons.drawerContact, themeProvider, controller);
  }

  archives(themeProvider, DrawerViewModel controller, BuildContext context) {
    return controller.expandableSelected == ConstantsStrings.archive
        ? Column(
            children: [
              expandedOption(ConstantsStrings.archive, AppIcons.drawerArchive, themeProvider, controller, context),
              mainInnerOption(ConstantsStrings.archiveSetup, AppIcons.drawerArchive, AppIcons.drawerBgmblue, themeProvider, RoutesManager.dashboard, context, controller),
              mainInnerOption(ConstantsStrings.analytics, AppIcons.drawerArchive, AppIcons.drawerBgmblue, themeProvider, RoutesManager.analytics, context, controller),
            ],
          )
        : expandableOption(ConstantsStrings.archive, AppIcons.drawerArchive, themeProvider, controller);
  }
}

class ChatBotWidget extends StatelessWidget {
  const ChatBotWidget({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) => createChatbotProductsCubit(),
        ),
        BlocProvider(
          create: (context) {
            return ChatBotBloc();
          },
        ),
        BlocProvider(create: (_) => createChatbotProductsCubit()..request()),
      ],
      child: Theme(
        data: Theme.of(context).brightness == Brightness.light ? ChatBotAppTheme.lightTheme : ChatBotAppTheme.darkTheme,
        child: ChatBotScreen(
          parentContext: context,
          onTicketStatusTap: () {
            Navigator.push(context, MaterialPageRoute(
              builder: (context) {
                return MultiBlocProvider(
                  providers: [
                    BlocProvider(
                      create: (context) {
                        return TicketCountBloc();
                      },
                    ),
                    BlocProvider(
                      create: (context) {
                        return TicketDetailsBloc();
                      },
                    ),
                    BlocProvider(
                      create: (context) {
                        return TicketDetailsByIdBloc();
                      },
                    ),
                  ],
                  child: Theme(
                    data: Theme.of(context).brightness == Brightness.light ? ChatBotAppTheme.lightTheme : ChatBotAppTheme.darkTheme,
                    child: const TicketStatusScreen(),
                  ),
                );
              },
            ));
          },
          showTicketStatusButton: true,
        ),
      ),
    );
  }
}
