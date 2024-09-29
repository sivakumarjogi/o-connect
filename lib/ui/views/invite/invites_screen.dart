import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:o_connect/core/screen_configs.dart';
import 'package:o_connect/ui/utils/base_urls.dart';
import 'package:o_connect/ui/utils/colors/colors.dart';
import 'package:o_connect/ui/utils/constant_strings.dart';
import 'package:o_connect/ui/utils/custom_show_dialog_helper/custom_show_dialog.dart';
import 'package:o_connect/ui/utils/custom_toast_helper/custom_toast.dart';
import 'package:o_connect/ui/utils/network_image_helpers/cached_image_validation.dart';
import 'package:o_connect/ui/utils/textfield_helper/app_fonts.dart';
import 'package:o_connect/ui/utils/textfield_helper/common_textfield.dart';
import 'package:o_connect/ui/views/authentication/form_validations.dart';
import 'package:o_connect/ui/views/themes/providers/webinar_themes_provider.dart';
import 'package:provider/provider.dart';
import '../../utils/buttons_helper/custom_botton.dart';
import '../../utils/buttons_helper/custom_outline_button.dart';
import 'provider/invite_pop_up_provider.dart';

class InviteScreen extends StatefulWidget {
  const InviteScreen({super.key});

  @override
  State<InviteScreen> createState() => _InviteScreenState();
}

class _InviteScreenState extends State<InviteScreen> with SingleTickerProviderStateMixin {
  late TabController _tabController;
  final TextEditingController _newEmailController = TextEditingController();
  final TextEditingController _searchController = TextEditingController();
  late InvitePopupProvider invitePopupProvider;

  // String searchValue = "";
  List<Map> tabValues = [
    {"title": ConstantsStrings.newEmailId, "index": 0},
    {"title": ConstantsStrings.contacts, "index": 1}
  ];
  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    _tabController = TabController(length: 2, vsync: this);
    invitePopupProvider = Provider.of<InvitePopupProvider>(context, listen: false);
    invitePopupProvider.initCall();

    _tabController.addListener(() {});
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer2<WebinarThemesProviders, InvitePopupProvider>(builder: (context, webinarThemesProvider, invitePopupProvider, child) {
      return WillPopScope(
        onWillPop: () async {
          invitePopupProvider.clearData();
          return true;
        },
        child: Form(
          key: _formKey,
          child: Container(
            decoration: BoxDecoration(
                border: Border.all(color: webinarThemesProvider.colors.headerColor, width: 2.sp),
                color: webinarThemesProvider.colors.bodyColor ?? Theme.of(context).scaffoldBackgroundColor,
                borderRadius: BorderRadius.only(topRight: Radius.circular(25.r), topLeft: Radius.circular(25.r))),
            height: ScreenConfig.height * 0.7,
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 8.w),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Expanded(
                    child: SingleChildScrollView(
                      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                        showDialogCustomHeader(context, headerTitle: "New Invites"),
                        height5,
                        Container(
                          color: webinarThemesProvider.colors.bodyColor,
                          child: TabBar(
                              onTap: (index) {
                                invitePopupProvider.callNotify();
                                invitePopupProvider.invitesList.clear();
                                invitePopupProvider.contactsEmailIndex.clear();
                                // invitePopupProvider.clearData();
                              },
                              labelPadding: EdgeInsets.symmetric(horizontal: 3.w),
                              dividerColor: Colors.transparent,
                              labelColor: Colors.white,
                              labelStyle: w400_12Poppins(color: Theme.of(context).focusColor),
                              indicatorColor: Colors.transparent,
                              // indicator:  const BoxDecoration(borderRadius:BorderRadius.all(Radius.circular(5)), color: Colors.blue),
                              indicatorSize: TabBarIndicatorSize.tab,
                              unselectedLabelStyle: w400_12Poppins(color: Theme.of(context).hintColor),
                              unselectedLabelColor: Theme.of(context).hintColor,
                              controller: _tabController,
                              tabs: tabValues.map((e) {
                                return tab(
                                  e["title"],
                                  e["index"],
                                  webinarThemesProvider.unSelectButtonsColor,
                                );
                              }).toList()),
                        ),
                        SizedBox(
                          height: ScreenConfig.height * 0.50,
                          child: TabBarView(controller: _tabController, children: [
                            Container(
                              height: ScreenConfig.height * 0.40,
                              decoration: BoxDecoration(color: webinarThemesProvider.bgColor),
                              child: SingleChildScrollView(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    height8,
                                    Padding(
                                      padding: EdgeInsets.symmetric(horizontal: 5.w),
                                      child: Text(
                                        "Participants",
                                        style: w400_12Poppins(color: Colors.white),
                                      ),
                                    ),
                                    Padding(
                                      padding: EdgeInsets.symmetric( vertical: 10.h),
                                      child: CommonTextFormField(
                                          controller: _newEmailController,
                                          validator: (val, fieldName) {
                                            return FormValidations.emailValidation(val, fieldName);
                                          },
                                          autovalidateMode: AutovalidateMode.disabled,
                                          suffixIcon: GestureDetector(
                                            onTap: () {
                                              // if (_newEmailController.text.isEmpty && invitePopupProvider.invitesList.isEmpty) {
                                              //   CustomToast.showErrorToast(msg: "Enter at least one email");
                                              //   return;
                                              // }

                                              if (_formKey.currentState!.validate()) {
                                                Provider.of<InvitePopupProvider>(context, listen: false).addEmailToInvite(_newEmailController.text);
                                                _newEmailController.clear();
                                              }
                                            },
                                            child: Container(
                                              width: 70.w,
                                              decoration: ShapeDecoration(
                                                shape: RoundedRectangleBorder(
                                                  borderRadius: BorderRadius.only(
                                                    bottomRight: Radius.circular(5.r),
                                                    topRight: Radius.circular(5.r),
                                                  ),
                                                ),
                                                color: Colors.blue,
                                              ),
                                              alignment: Alignment.center,
                                              child: Text("Add", style: w400_14Poppins(color: Colors.white)),
                                            ),
                                          ),
                                          hintStyle: w400_14Poppins(
                                            color: webinarThemesProvider.hintTextColor,
                                          ),
                                          borderColor: webinarThemesProvider.hintTextColor,
                                          hintText: ConstantsStrings.enterEmailId,
                                          fillColor: webinarThemesProvider.headerNotchColor ?? Theme.of(context).primaryColor,
                                          keyboardType: TextInputType.text,
                                          inputAction: TextInputAction.done),
                                    ),
                                    invitePopupProvider.invitesList.isNotEmpty
                                        ? Container(
                                            width: ScreenConfig.width,
                                            height: ScreenConfig.height,
                                            margin: EdgeInsets.symmetric(vertical: 10.h),
                                            decoration: BoxDecoration(color: Colors.black, borderRadius: BorderRadius.circular(10)),
                                            child: Column(
                                                children: List.generate(
                                                    invitePopupProvider.invitesList.length,
                                                    (index) => Container(
                                                          padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 10.h),
                                                          margin: EdgeInsets.all(5.sp),
                                                          decoration: BoxDecoration(
                                                              color: Colors.primaries[Random().nextInt(Colors.primaries.length)] ?? Theme.of(context).primaryColor,
                                                              borderRadius: BorderRadius.circular(10.r)),
                                                          child: Row(
                                                            mainAxisSize: MainAxisSize.max,
                                                            children: [
                                                              Text(
                                                                invitePopupProvider.invitesList[index],
                                                                style: w400_14Poppins(color: Colors.white),
                                                              ),
                                                              GestureDetector(
                                                                  onTap: () {
                                                                    invitePopupProvider.removeEmailsFromInviteList(index);
                                                                  },
                                                                  child: Icon(
                                                                    Icons.cancel,
                                                                    size: 24.sp,
                                                                    color: Colors.primaries[Random().nextInt(Colors.primaries.length)],
                                                                  ))
                                                            ],
                                                          ),
                                                        ))),
                                          )
                                        : const SizedBox.shrink()
                                  ],
                                ),
                              ),
                            ),

                            ///Contacts Tab
                            Container(
                              decoration: BoxDecoration(borderRadius: BorderRadius.circular(10.r)),
                              child: Column(
                                children: [
                                  Padding(
                                    padding: EdgeInsets.symmetric(horizontal:3.w,vertical: 10.h),
                                    child: CommonTextFormField(
                                      controller: _searchController,
                                      hintText: ConstantsStrings.search,
                                      hintStyle: w400_14Poppins(color: webinarThemesProvider.hintTextColor),
                                      fillColor: webinarThemesProvider.headerNotchColor,
                                      borderColor: webinarThemesProvider.hintTextColor,
                                      keyboardType: TextInputType.text,
                                      inputAction: TextInputAction.done,
                                      onChanged: (val) {
                                        invitePopupProvider.searchContacts(val);
                                      },
                                    ),
                                  ),
                                  Container(color: Colors.black, height: 320.sp, child: const InviteContactCard())
                                ],
                              ),
                            ),
                          ]),
                        ),
                      ]),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.all(5.sp),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        CustomOutlinedButton(
                          width: MediaQuery.of(context).size.width / 2 - 20.sp,
                          outLineBorderColor: webinarThemesProvider.headerNotchColor,
                          height: 35.h,
                          buttonTextStyle: w400_13Poppins(color: Colors.white),
                          buttonText: ConstantsStrings.close,
                          color: webinarThemesProvider.closeButtonColor,
                          onTap: () {
                            invitePopupProvider.clearData();
                            Navigator.pop(context);
                          },
                        ),
                        width10,
                        CustomButton(
                          width: MediaQuery.of(context).size.width / 2 - 20.sp,
                          height: 35.h,
                          buttonText: ConstantsStrings.invite,
                          buttonColor: webinarThemesProvider.colors.buttonColor ?? AppColors.mainBlueColor,
                          buttonTextStyle: w500_13Poppins(color: AppColors.whiteColor),
                          onTap: () {
                            if (invitePopupProvider.invitesList.isEmpty && invitePopupProvider.inviteContactsList.isEmpty) {
                              CustomToast.showErrorToast(msg: "Add at least one invitee to send invite");
                              return;
                            }
                            invitePopupProvider.sendInvitesToEmail(context);
                            FocusScope.of(context).unfocus();
                          },
                        )
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      );
    });
  }

  Widget tab(String title, int index, Color unSelectButtonsColor) {
    return Tab(
        child: Container(
      alignment: Alignment.center,
      width: double.infinity,
      decoration: ShapeDecoration(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(
            Radius.circular(5.r),
          ),
        ),
        color: index == _tabController.index ? Colors.blue : unSelectButtonsColor,
      ),
      child: Text(
        title,
        style: w500_12Poppins(color: Colors.white),
      ),
    )

        // ext(title, style: TextStyle(fontSize: 14.sp, fontWeight:  ? FontWeight.bold : FontWeight.normal)),
        );
  }
}

class InviteContactCard extends StatelessWidget {
  const InviteContactCard({super.key});

  @override
  Widget build(BuildContext context) {
    bool? isChecked = true;
    return Consumer2<InvitePopupProvider, WebinarThemesProviders>(builder: (context, invitePopupProvider, webinarThemesProviders, child) {
      return invitePopupProvider.finalContactList.isEmpty
          ? Center(
              child: Column(
              children: [
                SizedBox(
                  height: ScreenConfig.height * 0.15,
                ),
                Text(
                  "No Contacts",
                  style: w400_16Poppins(color: webinarThemesProviders.hintTextColor),
                ),
              ],
            ))
          : Expanded(
              child: ListView.builder(
                  itemCount: invitePopupProvider.finalContactList.length,
                  physics: const AlwaysScrollableScrollPhysics(),
                  shrinkWrap: true,
                  itemBuilder: (context, index) {
                    return Padding(
                      padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 5.h),
                      child: Container(
                          decoration: BoxDecoration(borderRadius: BorderRadius.circular(8.r), color: webinarThemesProviders.bgColor),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Expanded(
                                child: Padding(
                                  padding: EdgeInsets.all(8.0.sp),
                                  child: Row(
                                    children: [

                                      Checkbox(
                                        tristate: true,
                                        activeColor: webinarThemesProviders.hintTextColor,
                                        value: invitePopupProvider.contactsEmailIndex.contains(index) ? true : false,
                                        onChanged: (bool? value) {
                                          String contactEmail = invitePopupProvider.finalContactList[index].alternateEmailId ?? "";
                                          invitePopupProvider.contactsEmailIndex.contains(index)
                                              ? invitePopupProvider.removeContactsEmailsFromInviteList(index)
                                              : invitePopupProvider.addContactsEmailToInviteList(contactEmail, index);
                                        },
                                      ),
                                      ImageServiceWidget(
                                        height: 36.h,
                                        width: 50.w,
                                        imageBorderRadius: 5.r,
                                        networkImgUrl: "${BaseUrls.imageUrl}${invitePopupProvider.finalContactList[index].contactPic}",
                                      ),
                                      width20,
                                      Expanded(
                                        child: Column(
                                          mainAxisSize: MainAxisSize.min,
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              invitePopupProvider.finalContactList[index].firstName ?? "test",
                                              style: w400_14Poppins(color: Theme.of(context).hintColor),
                                            ),
                                            Text(
                                              invitePopupProvider.finalContactList[index].alternateEmailId ?? "test@onpassive.com",
                                              style: w400_10Poppins(color: Theme.of(context).hintColor),
                                            )
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                              // GestureDetector(
                              //   onTap: () {
                              //     String contactEmail = invitePopupProvider.finalContactList[index].alternateEmailId ?? "";
                              //     invitePopupProvider.contactsEmailIndex.contains(index)
                              //         ? invitePopupProvider.removeContactsEmailsFromInviteList(index)
                              //         : invitePopupProvider.addContactsEmailToInviteList(contactEmail, index);
                              //   },
                              //   child: Padding(
                              //     padding: EdgeInsets.all(8.0.sp),
                              //     child: Icon(
                              //       invitePopupProvider.contactsEmailIndex.contains(index) ? Icons.remove : Icons.add,
                              //       size: 16.sp,
                              //       color: Theme.of(context).disabledColor,
                              //     ),
                              //   ),
                              // )
                            ],
                          )),
                    );
                  }));
    });
  }
}
