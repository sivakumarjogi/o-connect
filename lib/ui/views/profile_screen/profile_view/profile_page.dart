import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:lottie/lottie.dart';
import 'package:o_connect/core/models/response_models/profile_response_model.dart/profile_response_model.dart';
import 'package:o_connect/my_app.dart';
import 'package:o_connect/ui/utils/colors/colors.dart';
import 'package:o_connect/ui/views/authentication/terrms_and_policy/terms_n_conditions_privacy_policy.dart';
import 'package:o_connect/ui/views/meeting/utils/context_ext.dart';
import 'package:oes_chatbot/utils/extensions/sizedbox_extension.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../../core/providers/create_contact_provider.dart';
import '../../../../core/routes/routes_name.dart';
import '../../../utils/base_urls.dart';
import '../../../utils/common_app_bar/account_logout_page.dart';
import '../../../utils/images/images.dart';
import '../../../utils/network_image_helpers/cached_image_validation.dart';
import '../../../utils/textfield_helper/app_fonts.dart';
import '../../authentication/Auth_providers/auth_api_provider.dart';
import '../../home_screen/home_screen_provider/home_screen_provider.dart';
import '../profile_provider/profile_api_provider.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  late ProfileScreenProvider profileScreenProvider;
  late HomeScreenProvider homeScreenProvider;
  bool _iconVisible = false;
  GetProfileResponsData userData = GetProfileResponsData();
  int? noOfDaysLeft;
  Future<void> getUserData() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    final String? userDataString = sharedPreferences.getString("saveProfileData");
    print("Profile data is called ${sharedPreferences.getString("saveProfileData").toString()}");
    userData = GetProfileResponsData.fromJson(jsonDecode(userDataString!));
    setState(() {});
  }

  @override
  void initState() {
    homeScreenProvider = Provider.of<HomeScreenProvider>(context, listen: false);
    profileScreenProvider = Provider.of<ProfileScreenProvider>(context, listen: false);

   // print("vjhbjg profilePic ${profileScreenProvider.profileInfoData?.profilePic}");
    profileScreenProvider.profileMenuList = profileScreenProvider.getProfileMeniList();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      noOfDaysLeft = await context.read<HomeScreenProvider>().getSubScriptionEndDate(context);
    });
    getUserData();
    super.initState();
  }

  void handleClick() {
    setState(() {
      _iconVisible = true; // Show the icon
    });

    // Delay for 500 milliseconds (0.5 seconds)
    Future.delayed(const Duration(milliseconds: 850), () {
      setState(() {
        _iconVisible = false; // Hide the icon after 0.5 seconds
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Consumer2<AuthApiProvider, ProfileScreenProvider>(builder: (build, authProvider, profileScreenProvider, child) {
      return Scaffold(
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        appBar: AppBar(
          backgroundColor: Theme.of(context).cardColor,
          leading: Padding(
            padding: const EdgeInsets.all(8.0),
            child: GestureDetector(
              onTap: () async {
                Navigator.pop(context);
              },
              child: Icon(
                Icons.chevron_left_outlined,
                size: 32,
                color: Theme.of(context).primaryColorLight,
              ),
            ),
          ),
          title: Text(
            "My Account",
            style: w500_17Poppins(color: Colors.white),
          ),
          actions: [
            GestureDetector(
              onTap: () async {
                context.showLoading();
                await Provider.of<CreateContactProvider>(context, listen: false).getCountries();
                if (context.mounted) {
                  context.hideLoading();
                  Navigator.pushNamed(context, RoutesManager.profileScreen);
                }
                // Navigator.pushNamed(context, RoutesManager.profileScreen);
              },
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: SvgPicture.asset(
                  AppImages.editImage,

                  // color: Theme.of(context).disabledColor,
                ),
              ),
            ),
          ],
        ),
        body: Container(
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                5.h.height,
                Center(
                    child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: profileScreenProvider.profileInfoData != null && profileScreenProvider.profileInfoData?.profilePic != null && profileScreenProvider.profileInfoData
                      !.profilePic!.isNotEmpty
                      ? Container(
                          decoration: const BoxDecoration(
                            color: Colors.white,
                            shape: BoxShape.circle,
                          ),
                          height: 100,
                          width: 100,
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(50.r),
                            child: SizedBox(
                              height: 100,
                              width: 100,
                              child: ImageServiceWidget(networkImgUrl: "${BaseUrls.imageUrl}${profileScreenProvider.profileInfoData?.profilePic ?? ""}"),
                              /*  child: Image.network(
                                "${BaseUrls.imageUrl}${profileScreenProvider.profileInfoData!.profilePic ?? ""}",
                                fit: BoxFit.fill,
                                errorBuilder: (context, error, stackTrace) {
                                  return SizedBox(
                                    width: 20,
                                    height: 20,
                                    child: Image.asset(
                                      AppImages.defaultContactImg,
                                      fit: BoxFit.fill,
                                    ),
                                  );
                                },
                                loadingBuilder: (BuildContext ctx, Widget child, ImageChunkEvent? loadingProgress) {
                                  if (loadingProgress == null) {
                                    return child;
                                  } else {
                                    return Center(
                                      child: Lottie.asset(AppImages.loadingJson, height: 40.w, width: 40.w),
                                    );
                                  }
                                },
                              ),*/
                            ),
                          ))
                      : Container(
                          decoration: const BoxDecoration(
                            color: Colors.white,
                            shape: BoxShape.circle,
                          ),
                          height: 100,
                          width: 100,
                          child: SvgPicture.asset(
                            AppImages.dummyProfileSvg,
                            width: 50.w,
                            height: 50.w,
                          ),
                        ),
                )),
                Text(
                  (userData.firstName ?? "") + (userData.lastName ?? ""),
                  style: w500_16Poppins(color: Colors.white),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      userData.emailId ?? "",
                      style: w400_12Poppins(color: Theme.of(context).primaryColorLight),
                    ),
                    5.w.width,
                    InkWell(
                      onTap: () async {
                        await Clipboard.setData(ClipboardData(text: profileScreenProvider.profileInfoData?.emailId ?? ""));
                        handleClick();

                        // CustomToast.showSuccessToast(msg: "Copied Successfully");
                      },
                      child: Icon(
                        Icons.copy,
                        color: Theme.of(context).primaryColorLight,
                        size: 13,
                      ),
                    ),
                    5.w.width,
                    _iconVisible
                        ? Icon(
                            Icons.check_circle,
                            color: Theme.of(context).primaryColorLight,
                            size: 18,
                          )
                        : SizedBox(
                            width: 17.w,
                          )
                  ],
                ),
                height30,
                RemainingDays(
                  days: noOfDaysLeft != null ? noOfDaysLeft.toString() : "0",
                  renualAction: () async {
                    await launchUrl(
                      Uri.parse("https://obs-qa.onpassive.com/"),
                    );
                  },
                ),
                5.h.height,
                SizedBox(
                  height: 190.h,
                  width: MediaQuery.of(context).size.width - 25,
                  child: GridView.builder(
                    itemCount: profileScreenProvider.profileMenuList!.length,
                    physics: const NeverScrollableScrollPhysics(),
                    itemBuilder: (context, index) => ItemTile(
                      index,
                      title: iconTitle(index, profileScreenProvider.profileMenuList![index].title, authProvider),
                      iconName: profileScreenProvider.profileMenuList![index].icon,
                      onTap: profileScreenProvider.profileMenuList![index].onTap,
                      icon: profileScreenProvider.profileMenuList![index].iconData,
                    ),
                    gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      childAspectRatio: 2.8,
                    ),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(top: 4.h, left: 10.w, right: 10.w),
                  child: GestureDetector(
                    onTap: () {
                      Navigator.push(
                          navigationKey.currentContext!,
                          MaterialPageRoute(
                              builder: (context) => const TermsNConditionsPrivacy(
                                    appBarTitle: "Privacy Policy",
                                    iconName: AppImages.privacyPolicy,
                                  )));
                    },
                    child: Container(
                      margin: EdgeInsets.all(8.sp),
                      padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 10.h),
                      decoration: BoxDecoration(borderRadius: BorderRadius.circular(4), color: Theme.of(context).cardColor),
                      child: Row(children: [
                        SizedBox(
                            height: 25.h,
                            width: 25.w,
                            child: SvgPicture.asset(
                              AppImages.privacyPolicyIcon,
                              fit: BoxFit.fill,
                            )),
                        const SizedBox(width: 5),
                        Text("Privacy Policy",
                            style: w500_12Poppins(
                              color: Colors.white,
                            )),
                      ] //Ap31 jr 8306
                          ),
                    ),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 10.w),
                  child: GestureDetector(
                    onTap: () {
                      Navigator.push(
                          navigationKey.currentContext!,
                          MaterialPageRoute(
                              builder: (context) => const TermsNConditionsPrivacy(
                                    appBarTitle: "Terms & Conditions",
                                    iconName: AppImages.termsAndConditions,
                                  )));
                    },
                    child: Container(
                      margin: EdgeInsets.all(8.sp),
                      padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 10.h),
                      decoration: BoxDecoration(borderRadius: BorderRadius.circular(4), color: Theme.of(context).cardColor),
                      child: Row(children: [
                        SizedBox(
                            height: 25.h,
                            width: 25.w,
                            child: SvgPicture.asset(
                              AppImages.termsAndConditionsIcon,
                              fit: BoxFit.fill,
                            )),
                        const SizedBox(width: 5),
                        Text("Terms And Conditions",
                            style: w500_12Poppins(
                              color: Colors.white,
                            )),
                      ] //Ap31 jr 8306
                          ),
                    ),
                  ),
                ),
                height30,
                GestureDetector(
                  onTap: () {
                    logOut(context);
                  },
                  child: Container(
                    decoration: BoxDecoration(color: Colors.blue, borderRadius: BorderRadius.circular(4)),
                    width: MediaQuery.of(context).size.width - 40,
                    height: 40,
                    child: Center(
                        child: Text(
                      "Logout",
                      style: w600_14Poppins(color: Colors.white),
                    )),
                  ),
                ),
                height15
              ],
            ),
          ),
        ),
      );
    });
  }

  String iconTitle(int index, String titleStr, AuthApiProvider authProvider) {
    if (index == 2) {
      return authProvider.profileData?.data?.customerAccounts?.first.balance.toString() ?? "";
    } else {
      return titleStr;
    }
  }
}

class ItemTile extends StatelessWidget {
  final int itemNo;
  final String? iconName;
  final String title;
  final VoidCallback onTap;
  final IconData? icon;

  const ItemTile(this.itemNo, {super.key, this.iconName, required this.title, required this.onTap, this.icon});

  @override
  Widget build(BuildContext context) {
    return Consumer<AuthApiProvider>(builder: (context, authProvider, __) {
      return GestureDetector(
        onTap: onTap,
        child: Container(
          margin: EdgeInsets.all(6.sp),
          padding: EdgeInsets.only(left: 8.w, right: 2.w),
          decoration: BoxDecoration(borderRadius: BorderRadius.circular(4), color: Theme.of(context).cardColor),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                mainAxisAlignment: iconName != null ? MainAxisAlignment.start : MainAxisAlignment.center,
                children: [
                  if (iconName != null) ...[
                    SizedBox(
                        height: 25.w,
                        width: 25.w,
                        child: SvgPicture.asset(
                          iconName!,
                          fit: BoxFit.fill,
                        )),
                    SizedBox(width: 4.w),
                  ],
                  if (itemNo == 2 || itemNo == 0)
                    profileRowWidget(context, authProvider, itemNo)
                  else
                    Text(title,
                        style: w500_12Poppins(
                          color: Colors.white,
                        )),
                ], //Ap31 jr 8306
              ),
              Icon(
                icon,
                color: Theme.of(context).primaryColorLight,
              ),
            ],
          ),
        ),
      );
    });
  }

  Widget profileRowWidget(BuildContext context, AuthApiProvider authApiProvider, int index) {
    if (index == 0) {
      return RichText(
          text: TextSpan(children: [
        TextSpan(
          text: "ID: OES - ",
          style: w500_12Poppins(color: Colors.white),
        ),
        TextSpan(text: authApiProvider.profileData?.data!.customerAccounts!.first.custAffId.toString() ?? "0000", style: w500_12Poppins(color: Colors.white))
      ]));
    } else if (index == 2) {
      return RichText(
          text: TextSpan(children: [
        TextSpan(
          text: title,
          style: w500_12Poppins(color: AppColors.mainBlueColor),
        ),
        TextSpan(text: "  Credits", style: w500_12Poppins(color: Colors.white))
      ]));
    }
    return Container();
  }
}

class RemainingDays extends StatelessWidget {
  const RemainingDays({super.key, this.days, required this.renualAction});

  final String? days;
  final VoidCallback renualAction;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8),
        gradient: const LinearGradient(
            colors: [
              Color(0xffAB2442),
              Color(0xff7F3A72),
            ],
            begin: FractionalOffset(0.0, 0.0),
            end: FractionalOffset(1.0, 0.0),
            stops: [0.0, 1.0],
            tileMode: TileMode.clamp),
      ),
      width: MediaQuery.of(context).size.width - 40,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.only(top: 20, left: 15),
                child: Text(
                  "Remaining Days",
                  style: w500_12Poppins(color: Theme.of(context).hintColor),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(left: 15, bottom: 10),
                child: RichText(
                  text: TextSpan(
                    text: days ?? '',
                    style: w700_30Poppins(color: Colors.white),
                    children: <TextSpan>[
                      TextSpan(
                        text: ' Days',
                        style: w500_12Poppins(color: Colors.white),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
          GestureDetector(
            onTap: renualAction,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Container(
                decoration: BoxDecoration(color: Colors.transparent, border: Border.all(color: Colors.white, width: 1), borderRadius: BorderRadius.circular(4)),
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    "Renewal",
                    style: w600_14Poppins(color: Colors.white),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
