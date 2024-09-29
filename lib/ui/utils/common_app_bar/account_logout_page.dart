import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:o_connect/core/providers/app_global_state_provider.dart';
import 'package:o_connect/core/providers/theme_provider.dart';
import 'package:o_connect/core/routes/routes_name.dart';
import 'package:o_connect/core/service/api_helper/api_helper.dart';
import 'package:o_connect/my_app.dart';
import 'package:o_connect/ui/utils/base_urls.dart';
import 'package:o_connect/ui/utils/buttons_helper/custom_botton.dart';
import 'package:o_connect/ui/utils/colors/colors.dart';
import 'package:o_connect/ui/utils/common_app_bar/common_appbar.dart';
import 'package:o_connect/ui/utils/constant_strings.dart';
import 'package:o_connect/ui/utils/custom_toast_helper/custom_toast.dart';
import 'package:o_connect/ui/utils/icon_constants/icon_constant.dart';
import 'package:o_connect/ui/utils/images/images.dart';
import 'package:o_connect/ui/utils/network_image_helpers/cached_image_validation.dart';
import 'package:o_connect/ui/views/authentication/Auth_providers/auth_api_provider.dart';
import 'package:o_connect/ui/views/drawer/custom_drawer_view.dart';
import 'package:o_connect/ui/views/meeting/providers/meeting_room_provider.dart';
import 'package:o_connect/ui/views/pip_views/pip_global_navigation.dart';
import 'package:o_connect/ui/views/profile_screen/profile_provider/profile_api_provider.dart';
import 'package:oes_chatbot/chat_bot/bloc/chat_bot_bloc/chat_bot_bloc.dart';
import 'package:oes_chatbot/config/setup_env.dart';
import 'package:oes_chatbot/oes_chatbot.dart';
import 'package:oes_chatbot/ticket_status/bloc/ticket_count_bloc/ticket_count_bloc.dart';
import 'package:oes_chatbot/ticket_status/bloc/ticket_details_bloc/ticket_details_bloc.dart';
import 'package:oes_chatbot/ticket_status/bloc/ticket_details_by_id_bloc/ticket_details_by_id_bloc.dart';
import 'package:oes_chatbot/ticket_status/presentation/ticket_status_screen.dart';
import 'package:provider/provider.dart';
import '../../../core/providers/create_contact_provider.dart';
import '../../../core/service_locator.dart';
import '../../../core/user_cache_service.dart';
import '../textfield_helper/app_fonts.dart';
import 'FAQs.dart';

class AccountLogoutPage extends StatefulWidget {
  const AccountLogoutPage({super.key});

  @override
  State<AccountLogoutPage> createState() => _AccountLogoutPageState();
}

class _AccountLogoutPageState extends State<AccountLogoutPage> {
  late AuthApiProvider authProvider;
  ApiHelper apiHelper = ApiHelper();

  @override
  void initState() {
    authProvider = Provider.of<AuthApiProvider>(context, listen: false);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        // authProvider.getProfile();
        // Navigator.pop(context);
      },
      child: Scaffold(
        backgroundColor: Colors.transparent,
        drawer: const CustomDrawerView(),
        appBar: commonAppBar(
          context,
          showPopUp: false,
        ),
        body: Container(
          padding: EdgeInsets.only(left: 8.0.w, right: 8.w, bottom: 8.h),
          decoration: BoxDecoration(
            color: Theme.of(context).primaryColor,
            borderRadius: BorderRadius.only(
              bottomLeft: Radius.circular(10.r),
              bottomRight: Radius.circular(10.r),
            ),
          ),
          child: Material(
            color: Theme.of(context).primaryColor,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const UserDetailsCard(),
                height10,
                const LanguageCard(),
                SizedBox(
                  height: 2.h,
                ),
                const CreditsWidget(),
                SizedBox(
                  height: 2.h,
                ),
                const ReferralLink(),
                SizedBox(
                  height: 2.h,
                ),
                const OESId(),
                SizedBox(
                  height: 2.h,
                ),
                const FAQWidget(),
                SizedBox(
                  height: 2.h,
                ),
                const TutorialCard(),
                SizedBox(
                  height: 2.h,
                ),
                const ChatbotCard(),
                height10,
                LogoutButton(),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class TutorialCard extends StatelessWidget {
  const TutorialCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 40.h,
      padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 6.h),
      decoration: ShapeDecoration(
        color: Theme.of(context).highlightColor,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8.r)),
      ),
      child: Row(
        children: [
          Container(
              height: 24.h,
              width: 24.w,
              padding: const EdgeInsets.symmetric(horizontal: 3, vertical: 4),
              decoration: ShapeDecoration(
                color: Theme.of(context).scaffoldBackgroundColor,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
              ),
              child: SvgPicture.asset(
                AppImages.tutorialIcon,
                width: 24.w,
                height: 24.w,
              )),
          width20,
          Text(
            ConstantsStrings.tutorials,
            style: w500_13Poppins(color: Theme.of(context).primaryColorLight),
          )
        ],
      ),
    );
  }
}

class ChatbotCard extends StatelessWidget {
  const ChatbotCard({super.key});

  @override
  Widget build(BuildContext parentContext) {
    return GestureDetector(
      onTap: () async {},
      child: Container(
        height: 40.h,
        padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 6.h),
        decoration: ShapeDecoration(
          color: Theme.of(parentContext).highlightColor,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8.r)),
        ),
        child: Row(
          children: [
            Container(
                height: 24.h,
                width: 24.w,
                padding: const EdgeInsets.symmetric(horizontal: 3, vertical: 4),
                decoration: ShapeDecoration(
                  color: Theme.of(parentContext).scaffoldBackgroundColor,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
                ),
                child: SvgPicture.asset(
                  AppIcons.drawerChatbot,
                  width: 24.w,
                  height: 24.w,
                )),
            width20,
            Text(
              ConstantsStrings.OChatbot,
              style: w500_13Poppins(color: Theme.of(parentContext).primaryColorLight),
            )
          ],
        ),
      ),
    );
  }
}

class CloseIconWidget extends StatelessWidget {
  const CloseIconWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.pop(context);
      },
      child: Padding(
        padding: EdgeInsets.only(bottom: 10.h),
        child: Icon(
          Icons.close,
          color: Theme.of(context).hintColor,
        ),
      ),
    );
  }
}

class UserDetailsCard extends StatelessWidget {
  const UserDetailsCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<ProfileScreenProvider>(builder: (context, profileScreenProvider, build) {
      return GestureDetector(
        child: Padding(
          padding: EdgeInsets.all(5.0.sp),
          child: Row(
            children: [
              Container(
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.white24),
                    borderRadius: BorderRadius.circular(50.r),
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(50.r),
                    child: SizedBox(
                      width: 40.w,
                      height: 40.w,
                      child: ImageServiceWidget(
                        networkImgUrl: '${BaseUrls.imageUrl}${profileScreenProvider.profileInfoData?.profilePic ?? ""}',
                      ),
                    ),
                  )),
              width10,
              Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    profileScreenProvider.profileInfoData?.name ?? "Test User",
                    style: w500_14Poppins(color: Theme.of(context).hintColor),
                  ),
                  Text(
                    profileScreenProvider.profileInfoData?.emailId ?? "test@onpassive.com",
                    style: w400_12Poppins(color: Theme.of(context).disabledColor),
                  ),
                ],
              ),
              const Spacer(),
              Column(
                children: [
                  GestureDetector(
                    onTap: () {
                      Navigator.pop(context);
                    },
                    child: Icon(
                      Icons.close,
                      size: 14.sp,
                      color: Theme.of(context).hintColor,
                    ),
                  ),
                  height5,
                  GestureDetector(
                    onTap: () {
                      Clipboard.setData(ClipboardData(text: profileScreenProvider.profileInfoData?.emailId ?? ""));
                      CustomToast.showSuccessToast(msg: "Copied Successfully");
                    },
                    child: SvgPicture.asset(
                      AppImages.copyIcon,
                      width: 16.w,
                      height: 16.w,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
        onTap: () async {
          //  CustomToast.showInfoToast(msg: "Coming soon...");
          await Provider.of<CreateContactProvider>(context, listen: false).getCountries();
          if (context.mounted) {
            Navigator.pushNamed(context, RoutesManager.profileScreen);
          }
        },
      );
    });
  }
}

class LanguageCard extends StatelessWidget {
  const LanguageCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer2<AuthApiProvider, ThemeProvider>(builder: (context, authProvider, themeProvider, child) {
      return GestureDetector(
        onTap: () {
          // customShowDialog(context, LanguagePage());
          CustomToast.showInfoToast(msg: "Coming Soon...");
        },
        child: Container(
          decoration: BoxDecoration(borderRadius: BorderRadius.circular(6.r), color: Theme.of(context).highlightColor),
          child: Padding(
            padding: EdgeInsets.all(8.0.sp),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    SizedBox(
                        height: 27.w,
                        width: 27.w,
                        child: SvgPicture.asset(
                          AppImages.language,
                          fit: BoxFit.fill,
                        )),
                    width10,
                    RichText(text: TextSpan(children: [TextSpan(text: "Language", style: w500_12Poppins(color: Theme.of(context).primaryColorLight))])),
                  ],
                ),
                width10,
              ],
            ),
          ),
        ),
      );
    });
  }
}

class CreditsWidget extends StatelessWidget {
  const CreditsWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer2<AuthApiProvider, ThemeProvider>(builder: (context, authProvider, themeProvider, child) {
      return GestureDetector(
        onTap: () {},
        child: Container(
          decoration: BoxDecoration(borderRadius: BorderRadius.circular(6.r), color: Theme.of(context).highlightColor),
          child: Padding(
            padding: EdgeInsets.all(8.0.sp),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    SizedBox(
                        height: 27.w,
                        width: 27.w,
                        child: SvgPicture.asset(
                          AppImages.walletIcon,
                          fit: BoxFit.fill,
                        )),
                    width10,
                    RichText(
                        text: TextSpan(children: [
                      TextSpan(
                        text: authProvider.profileData?.data?.customerAccounts?.first.balance.toString() ?? "0.00",
                        style: w500_12Poppins(color: AppColors.mainBlueColor),
                      ),
                      TextSpan(text: "  Credits", style: w500_12Poppins(color: Theme.of(context).primaryColorLight))
                    ])),
                  ],
                ),
                width10,
              ],
            ),
          ),
        ),
      );
    });
  }
}

class ReferralLink extends StatelessWidget {
  const ReferralLink({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<AuthApiProvider>(builder: (context, authApiProvider, child) {
      return GestureDetector(
        onTap: () {},
        child: Container(
          decoration: BoxDecoration(borderRadius: BorderRadius.circular(6.r), color: Theme.of(context).highlightColor),
          child: Padding(
            padding: EdgeInsets.all(8.0.sp),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    SizedBox(
                        height: 27.w,
                        width: 27.w,
                        child: SvgPicture.asset(
                          AppImages.link_icondark,
                        )),
                    width10,
                    RichText(
                        text: TextSpan(children: [
                      TextSpan(
                        text: "Referral Code  ",
                        style: w500_12Poppins(color: Theme.of(context).primaryColorLight),
                      ),
                      TextSpan(text: authApiProvider.profileData?.data?.referenceCode ?? "-", style: w500_12Poppins(color: Colors.blue))
                    ])),
                  ],
                ),
                width10,
                GestureDetector(
                    onTap: () {
                      Clipboard.setData(ClipboardData(text: "${authApiProvider.profileData?.data?.referenceCode}"));
                      CustomToast.showSuccessToast(msg: "Copied Successfully");
                    },
                    child: SvgPicture.asset(AppImages.copyIcon)),
              ],
            ),
          ),
        ),
      );
    });
  }
}

class OESId extends StatelessWidget {
  const OESId({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<AuthApiProvider>(builder: (context, authProvider, child) {
      return Container(
        decoration: BoxDecoration(borderRadius: BorderRadius.circular(6.r), color: Theme.of(context).highlightColor),
        child: Padding(
          padding: EdgeInsets.all(8.0.sp),
          child: Row(
            children: [
              SizedBox(height: 27.w, width: 27.w, child: SvgPicture.asset(AppImages.userIdIcon)),
              width10,
              RichText(
                  text: TextSpan(children: [
                TextSpan(
                  text: "ID: OES - ",
                  style: w500_12Poppins(color: Colors.white),
                ),
                TextSpan(text: authProvider.profileData?.data!.customerAccounts!.first.custAffId.toString() ?? "0000", style: w500_12Poppins(color: Colors.blue))
              ])),
            ],
          ),
        ),
      );
    });
  }
}

class FAQWidget extends StatelessWidget {
  const FAQWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(context, MaterialPageRoute(builder: (context) => const PIPGlobalNavigation(childWidget: FAQsPage())));
        // CustomToast.showInfoToast(msg: "Coming Soon...");
      },
      child: Container(
        decoration: BoxDecoration(borderRadius: BorderRadius.circular(6.r), color: Theme.of(context).highlightColor),
        child: Padding(
          padding: EdgeInsets.all(8.0.sp),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  SizedBox(
                      height: 28.w,
                      width: 28.w,
                      child: SvgPicture.asset(
                        AppImages.FAQ_dark,
                        fit: BoxFit.fill,
                      )),
                  width10,
                  Text(
                    "FAQs",
                    style: w500_12Poppins(color: Theme.of(context).primaryColorLight),
                  ),
                ],
              ),
              width10,
              Icon(
                Icons.chevron_right_outlined,
                size: 16.sp,
                color: Theme.of(context).disabledColor,
              )
            ],
          ),
        ),
      ),
    );
  }
}

class LogoutButton extends StatelessWidget {
  LogoutButton({super.key});

  final ApiHelper apiHelper = ApiHelper();

  @override
  Widget build(BuildContext context) {
    return Container(
        height: 45.h,
        width: double.infinity,
        decoration: BoxDecoration(borderRadius: BorderRadius.circular(5.r), color: AppColors.mainBlueColor),
        child: CustomButton(
          buttonText: "Logout",
          buttonColor: AppColors.mainBlueColor,
          onTap: () async {
            logOut(context);
          },
        ));
  }
}

void logOut(BuildContext context) async {
  final isMeetingGoingOn = context.read<AppGlobalStateProvider>().isMeetingInProgress;
  if (isMeetingGoingOn) {
    context.read<MeetingRoomProvider>().leaveMeeting();
  }

  ApiHelper apiHelper = ApiHelper();
  await serviceLocator<UserCacheService>().clearAll().then((value) async {
    await serviceLocator<UserCacheService>().seenSliderScreens(value: true);
  });

  await apiHelper.updateAuthorization(clearToken: true);
  if (context.mounted) {
    Provider.of<AuthApiProvider>(context, listen: false).clearAuthProviderState();
    Navigator.pushNamedAndRemoveUntil(context, RoutesManager.logIn, (route) => false);
  }
}
