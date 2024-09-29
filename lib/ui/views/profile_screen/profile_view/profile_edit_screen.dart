import 'dart:convert';
import 'dart:io';

import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:image_picker/image_picker.dart';
import 'package:lottie/lottie.dart';
import 'package:o_connect/core/routes/routes_name.dart';
import 'package:o_connect/ui/utils/base_urls.dart';
import 'package:o_connect/ui/utils/colors/colors.dart';
import 'package:o_connect/ui/utils/common_app_bar/image_picker_bottombar.dart';
import 'package:o_connect/ui/utils/constant_strings.dart';
import 'package:o_connect/ui/utils/images/images.dart';
import 'package:o_connect/ui/utils/network_image_helpers/cached_image_validation.dart';
import 'package:o_connect/ui/utils/textfield_helper/app_fonts.dart';
import 'package:o_connect/ui/utils/textfield_helper/common_textfield.dart';
import 'package:o_connect/ui/views/authentication/Auth_providers/auth_api_provider.dart';
import 'package:o_connect/ui/views/pip_views/pip_global_navigation.dart';
import 'package:o_connect/ui/views/profile_screen/profile_provider/profile_api_provider.dart';
import 'package:o_connect/ui/views/profile_screen/profile_view/changePassword_profile.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../../core/models/response_models/profile_response_model.dart/profile_response_model.dart';
import '../../../../core/providers/create_contact_provider.dart';

class ProfileEditScreen extends StatefulWidget {
  const ProfileEditScreen({super.key});

  @override
  State<ProfileEditScreen> createState() => _ProfileEditScreenState();
}

class _ProfileEditScreenState extends State<ProfileEditScreen> {
  final _formKey = GlobalKey<FormState>();

  final TextEditingController searchController = TextEditingController();
  final TextEditingController _firstName = TextEditingController();
  final TextEditingController _lastName = TextEditingController();
  final TextEditingController _emailAddress = TextEditingController();
  final TextEditingController _mobile = TextEditingController();
  final TextEditingController _userName = TextEditingController();
  final TextEditingController _alternativeEmailAddress = TextEditingController();
  late ProfileScreenProvider profileScreenProvider;
  String countryCode = "";

  GetProfileResponsData userData = GetProfileResponsData();
  Future<void> getUserData() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    final String? userDataString = sharedPreferences.getString("saveProfileData");
    print("Profile data is called ${sharedPreferences.getString("saveProfileData").toString()}");
    userData = GetProfileResponsData.fromJson(jsonDecode(userDataString!));
    setState(() {});
  }

  @override
  void initState() {
    profileScreenProvider = Provider.of<ProfileScreenProvider>(context, listen: false);
    profileScreenProvider.isPicEdit = false;
    getUserData().then((value) {
      _firstName.text = profileScreenProvider.profileInfoData?.firstName ?? "";
      _lastName.text = profileScreenProvider.profileInfoData?.lastName ?? "";
      _emailAddress.text = profileScreenProvider.profileInfoData?.emailId ?? "";
      _userName.text = profileScreenProvider.profileInfoData?.name ?? "";
      _mobile.text = profileScreenProvider.profileInfoData?.mobileNumber ?? "";
      _alternativeEmailAddress.text = profileScreenProvider.profileInfoData?.alternateEmail ?? "";
      countryCode = profileScreenProvider.profileInfoData?.countryCode ?? "";

      for (int i = 0; i < context.read<CreateContactProvider>().countriesList.length; i++) {
        if (context.read<CreateContactProvider>().countriesList[i].iso2 == countryCode) {
          Provider.of<CreateContactProvider>(context, listen: false).selectedCountry = context.read<CreateContactProvider>().countriesList[i].name;
        }
      }
    });

    super.initState();
  }

  @override
  void dispose() {
    searchController.dispose();
    _firstName.dispose();
    _lastName.dispose();
    _emailAddress.dispose();
    _mobile.dispose();
    _userName.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: WillPopScope(
      onWillPop: () async {
        profileScreenProvider.imageFile = null;
        return true;
      },
      child: Scaffold(
          backgroundColor: Theme.of(context).scaffoldBackgroundColor,
          appBar: AppBar(
            elevation: 0,
            bottomOpacity: 0.0,
            backgroundColor: Theme.of(context).cardColor,
            centerTitle: false,
            leading: IconButton(
              icon: Icon(
                Icons.chevron_left,
                size: 30,
                color: Theme.of(context).primaryColorLight,
              ),
              onPressed: () {
                Navigator.pop(context);
              },
            ),
            title: Text(
              ConstantsStrings.profile,
              style: w500_16Poppins(color: Theme.of(context).hintColor),
            ),
          ),
          resizeToAvoidBottomInset: false,
          body: Consumer2<AuthApiProvider, ProfileScreenProvider>(
            builder: (build, authProvider, profileScreenProvider, child) {

              print("profilePic scren ${userData.profilePic}");

              return userData == null
                  ? Center(
                      child: Lottie.asset(AppImages.loadingJson, height: 40.w, width: 40.w),
                    )
                  : SingleChildScrollView(
                    child: Form(
                        key: _formKey,
                        child: Padding(
                          padding: const EdgeInsets.all(10.0),
                          child: Column(
                            children: [
                              // Container(
                              //   height: 47.h,
                              //   width: MediaQuery.of(context).size.width,
                              //   decoration: BoxDecoration(
                              //     color: Theme.of(context).primaryColor,
                              //     borderRadius: BorderRadius.circular(4.0.r),
                              //   ),
                              //   child: Padding(
                              //     padding: const EdgeInsets.all(4.0),
                              //     child: Row(
                              //       mainAxisAlignment: MainAxisAlignment.start,
                              //       children: [
                              //         IconButton(
                              //             padding: EdgeInsets.zero,
                              //             onPressed: () {
                              //               Navigator.pop(context);
                              //               profileScreenProvider.imageFile = null;
                              //             },
                              //             icon: Icon(
                              //               Icons.chevron_left_outlined,
                              //               color: Theme.of(context).disabledColor,
                              //             )),
                              //         width5,
                              //         Text(
                              //           ConstantsStrings.profile,
                              //           style: w500_16Poppins(color: Theme.of(context).disabledColor),
                              //         ),
                              //       ],
                              //     ),
                              //   ),
                              // ),
                              height20,
                              Stack(
                                alignment: Alignment.bottomRight,
                                children: [
                                  profileScreenProvider.imageFile != null
                                      ? Container(
                                          height: 100.w,
                                          width: 100.w,
                                          decoration: BoxDecoration(
                                              borderRadius: BorderRadius.circular(50),
                                              border: Border.all(color: Colors.grey.shade200),
                                              image: DecorationImage(image: FileImage(File(profileScreenProvider.imageFile!.path)), fit: BoxFit.fill),
                                              color: AppColors.whiteColor),
                                        )
                                      : Container(
                                          width: 100.w,
                                          height: 100.w,
                                          decoration: BoxDecoration(
                                              // color: Colors.red,
                                              borderRadius: BorderRadius.circular(70.r),
                                              border: Border.all(color: Colors.grey.shade200)),
                                          child: ClipRRect(
                                            borderRadius: BorderRadius.circular(50),
                                            child: FittedBox(
                                              fit: BoxFit.fill,
                                              child: ImageServiceWidget(networkImgUrl: "${BaseUrls.imageUrl}${profileScreenProvider.profileInfoData!.profilePic ?? ""}"),
                                            ),
                                          )),
                                  //       profileScreenProvider.imageFile != null ? Positioned(
                                  // left: 5.h,
                                  // child: Container(height: 30,width: 30,color: Colors.red,),
                                  // ) : Container(),
                                  Positioned(
                                    bottom: 5.h,
                                    child: Stack(
                                      alignment: Alignment.center,
                                      children: [
                                        Container(
                                          width: 10.w,
                                          height: 10.h,
                                          decoration: BoxDecoration(color: Theme.of(context).scaffoldBackgroundColor, borderRadius: BorderRadius.circular(50)),
                                        ),
                                        InkWell(
                                            onTap: () async {
                                              await ImagePickerService.imagePickerBottomSheet(context).then((value) {
                                                if (value != null) {
                                                  profileScreenProvider.updateImagePickerFile(value);
                                                }
                                              });
                                            },
                                            child: Image.asset(AppImages.profileEdit))
                                      ],
                                    ),
                                  ),

                                  Positioned(
                                    left: 5.h,
                                    bottom: 5.h,
                                    child: userData.profilePic != null && userData.profilePic!.isNotEmpty
                                        ? GestureDetector(
                                            onTap: () {
                                              profileScreenProvider.deleteProfilePic();
                                            },
                                            child: Container(
                                              height: 20.w,
                                              width: 20.w,
                                              decoration: const BoxDecoration(color: Color(0xff3A3A3C), shape: BoxShape.circle),
                                              child: Icon(Icons.delete, size: 15.w),
                                            ))
                                        : Container(),
                                  )
                                ],
                              ),
                              SizedBox(height: 12.h),
                              Text(
                                "${userData.firstName ?? ""} ${userData.lastName ?? ""}",
                                style: w500_14Poppins(color: Theme.of(context).primaryColorLight),
                              ),
                              SizedBox(height: 12.h),
                              CommonTextFormField(
                                borderColor: Theme.of(context).primaryColorLight,
                                fillColor: Theme.of(context).scaffoldBackgroundColor,
                                style: w400_16Poppins(color: Theme.of(context).hintColor),
                                hintText: ConstantsStrings.firstName,
                                hintStyle: TextStyle(color: Theme.of(context).hintColor),
                                suffixIcon: Padding(
                                  padding: const EdgeInsets.all(14.0),
                                  child: SvgPicture.asset(
                                    AppImages.userIcon,
                                    color: Theme.of(context).primaryColorLight,
                                  ),
                                ),
                                controller: _firstName,
                                keyboardType: TextInputType.name,
                                inputAction: TextInputAction.next,
                                onChanged: (value) {
                                  print("first name value is $value");
                                },
                              ),
                              SizedBox(
                                height: 18.h,
                              ),
                              CommonTextFormField(
                                borderColor: Theme.of(context).primaryColorLight,
                                fillColor: Theme.of(context).scaffoldBackgroundColor,
                                hintText: ConstantsStrings.lastName,
                                hintStyle: TextStyle(color: Theme.of(context).hintColor),
                                style: w400_14Poppins(color: Theme.of(context).hintColor),
                                suffixIcon: Padding(
                                  padding: const EdgeInsets.all(14.0),
                                  child: SvgPicture.asset(
                                    AppImages.userIcon,
                                    color: Theme.of(context).primaryColorLight,
                                  ),
                                ),
                                controller: _lastName,
                                keyboardType: TextInputType.name,
                                inputAction: TextInputAction.next,
                              ),
                              SizedBox(
                                height: 18.h,
                              ),
                              CommonTextFormField(
                                borderColor: Theme.of(context).primaryColorLight,
                                readOnly: true,
                                fillColor: Theme.of(context).primaryColor,
                                hintText: ConstantsStrings.emailAddress,
                                style: TextStyle(color: Theme.of(context).hintColor),
                                labelStyle: TextStyle(color: Theme.of(context).hintColor),
                                hintStyle: TextStyle(color: Theme.of(context).hintColor),
                                suffixIcon: Padding(
                                  padding: const EdgeInsets.all(14.0),
                                  child: SvgPicture.asset(
                                    AppImages.mailIcon,
                                    color: Theme.of(context).primaryColorLight,
                                  ),
                                ),
                                controller: _emailAddress,
                                keyboardType: TextInputType.emailAddress,
                                inputAction: TextInputAction.next,
                              ),
                              SizedBox(
                                height: 18.h,
                              ),
                              Consumer<CreateContactProvider>(builder: (context, createContactProvider, child) {
                                return Column(
                                  children: [
                                    DropdownButton2(
                                      style: TextStyle(color: Theme.of(context).hintColor),
                                      dropdownStyleData: DropdownStyleData(
                                          decoration: BoxDecoration(color: Theme.of(context).scaffoldBackgroundColor, border: Border.all(color: Theme.of(context).primaryColorLight, width: 0.2))),
                                      buttonStyleData: ButtonStyleData(
                                          decoration: BoxDecoration(
                                              color: Theme.of(context).scaffoldBackgroundColor,
                                              borderRadius: BorderRadius.circular(5.r),
                                              border: Border.all(color: Theme.of(context).primaryColorLight, width: 0.2))),
                                      isExpanded: true,
                                      iconStyleData: IconStyleData(
                                        icon: Padding(
                                          padding: EdgeInsets.all(6.0.sp),
                                          child: Icon(
                                            Icons.expand_more,
                                            color: Theme.of(context).primaryColorLight,
                                          ),
                                        ),
                                        iconSize: 30.sp,
                                      ),
                                      underline: const SizedBox.shrink(),
                                      /*   disabledHint: Padding(
                                        padding: EdgeInsets.all(5.0.sp),
                                        child: Text("Select Country", style: w400_14Poppins(color: Theme.of(context).disabledColor)),
                                      ),*/
                                      hint: Text("Select Country", style: w400_14Poppins(color: Theme.of(context).hintColor)),
                                      value: createContactProvider.selectedCountry.isEmpty
                                          ? createContactProvider.countriesList.isEmpty
                                              ? "India"
                                              : createContactProvider.countriesList.first.name
                                          : createContactProvider.selectedCountry,
                                      items: createContactProvider.countriesList.map(
                                        (value) {
                                          return DropdownMenuItem<String>(
                                            value: value.name ?? "Select Country",
                                            child: Text(
                                              value.name ?? "Select Country",
                                              style: w400_15Poppins(color: Theme.of(context).hintColor),
                                            ),
                                          );
                                        },
                                      ).toList(),
                                      onChanged: (value) {
                                        print("zfnsdkjfdskdsk $value");
                                        createContactProvider.updateDropdownValue(countryName: value!);
                    // })
                                      },
                                    ),
                                    SizedBox(
                                      height: 18.h,
                                    ),
                                    CommonTextFormField(
                                      borderColor: Theme.of(context).primaryColorLight,

                                      // readOnly: true,
                                      fillColor: Theme.of(context).scaffoldBackgroundColor,
                                      hintStyle: TextStyle(color: Theme.of(context).hintColor),
                                      style: w400_14Poppins(color: Theme.of(context).hintColor),
                                      hintText: "Mobile Number",
                                      maxLength: 10,
                                      suffixIcon: Padding(
                                        padding: const EdgeInsets.all(14.0),
                                        child: SvgPicture.asset(
                                          AppImages.phoneIcon,
                                          color: Theme.of(context).primaryColorLight,
                                        ),
                                      ),
                                      controller: _mobile,
                                      keyboardType: TextInputType.phone,
                                      inputAction: TextInputAction.next,
                                    ),
                                    // Row(
                                    //   // mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    //   children: [
                                    //     // Container(
                                    //     //   height: 45.h,
                                    //     //   width: ScreenConfig.width * 0.25,
                                    //     //   decoration: BoxDecoration(color: Theme.of(context).primaryColor, borderRadius: BorderRadius.circular(5.r)),
                                    //     //   child: Center(
                                    //     //     child: Text(
                                    //     //       "+${createContactProvider.countryCode}",
                                    //     //       style: w500_14Poppins(color: Theme.of(context).disabledColor),
                                    //     //     ),
                                    //     //   ),
                                    //     // ),
                                    //     // width5,
                                    //     CommonTextFormField(
                                    //         // readOnly: true,
                                    //         fillColor: Theme.of(context).primaryColor,
                                    //         hintStyle: TextStyle(color: Theme.of(context).disabledColor),
                                    //         style: w400_14Poppins(color: Theme.of(context).disabledColor),
                                    //         hintText: "Mobile Number",
                                    //         maxLength: 10,
                                    //         suffixIcon: Padding(
                                    //           padding: const EdgeInsets.all(14.0),
                                    //           child: SvgPicture.asset(
                                    //             AppImages.phoneIcon,
                                    //             color: Theme.of(context).disabledColor,
                                    //           ),
                                    //         ),
                                    //         controller: _mobile,
                                    //         keyboardType: TextInputType.phone,
                                    //         inputAction: TextInputAction.next,
                                    //       ),

                                    //   ],
                                    // ),
                                  ],
                                );
                              }),
                              SizedBox(
                                height: 18.h,
                              ),
                              CommonTextFormField(
                                borderColor: Theme.of(context).primaryColorLight,
                                readOnly: true,
                                fillColor: Theme.of(context).primaryColor,
                                hintText: ConstantsStrings.emailAddress,
                                style: TextStyle(color: Theme.of(context).hintColor),
                                labelStyle: TextStyle(color: Theme.of(context).hintColor),
                                hintStyle: TextStyle(color: Theme.of(context).hintColor),
                                suffixIcon: Padding(
                                  padding: const EdgeInsets.all(14.0),
                                  child: SvgPicture.asset(
                                    AppImages.userIcon,
                                    color: Theme.of(context).primaryColorLight,
                                  ),
                                ),
                                controller: _alternativeEmailAddress,
                                keyboardType: TextInputType.emailAddress,
                                inputAction: TextInputAction.next,
                              ),
                              SizedBox(
                                height: 18.h,
                              ),
                              // const Spacer(),
                              GestureDetector(
                                onTap: () {
                                  Navigator.push(context, MaterialPageRoute(builder: (context) => const PIPGlobalNavigation(childWidget: ChangePasswordProfile())));
                                },
                                child: Align(
                                  alignment: Alignment.topLeft,
                                  child: Text(
                                    ConstantsStrings.changeYourPassword,
                                    style: w400_14Poppins(color: Colors.blue),
                                  ),
                                ),
                              ),
                              SizedBox(height: 60.h),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Flexible(
                                    flex: 1,
                                    child: InkWell(
                                      onTap: () {
                                        Navigator.pop(context);
                                        profileScreenProvider.imageFile = null;
                                      },
                                      child: Container(
                                        // width: 80.w,
                                        height: 40.h,
                                        decoration: BoxDecoration(borderRadius: BorderRadius.circular(3), color: Color(0xff1B2632)),
                                        child: const Center(
                                          child: Text(
                                            ConstantsStrings.cancel,
                                            style: TextStyle(color: Colors.white, fontSize: 13, fontWeight: FontWeight.bold),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                  SizedBox(
                                    width: 10.w,
                                  ),
                                  Flexible(
                                    flex: 1,
                                    child: InkWell(
                                      onTap: () {
                                        print(Provider.of<CreateContactProvider>(context, listen: false).countryIso);
                                        profileScreenProvider.updateProfile(
                                            alternateEmailId: _alternativeEmailAddress.text,
                                            firstName: _firstName.text,
                                            lastName: _lastName.text,
                                            mobileNumber: _mobile.text,
                                            context: context,
                                            countryCode: Provider.of<CreateContactProvider>(context, listen: false).countryIso);
                                      },
                                      child: Container(
                                          // width: 100.w,
                                          height: 40.h,
                                          decoration: BoxDecoration(borderRadius: BorderRadius.circular(3), color: Colors.blue),
                                          child: const Center(
                                            child: Text(
                                              ConstantsStrings.save,
                                              style: TextStyle(color: Colors.white, fontSize: 13, fontWeight: FontWeight.bold),
                                            ),
                                          )),
                                    ),
                                  )
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                  );
            },
          )),
    ));
  }
}
