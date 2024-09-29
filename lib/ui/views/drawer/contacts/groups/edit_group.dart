import 'dart:developer';
import 'dart:io';

import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:o_connect/core/models/response_models/create_group_response_model/create_group_response_model.dart';
import 'package:o_connect/core/providers/my_contacts_provider.dart';
import 'package:o_connect/core/screen_configs.dart';
import 'package:o_connect/ui/utils/base_urls.dart';
import 'package:o_connect/ui/utils/buttons_helper/custom_botton.dart';
import 'package:o_connect/ui/utils/colors/colors.dart';
import 'package:o_connect/ui/utils/common_app_bar/image_picker_bottombar.dart';
import 'package:o_connect/ui/utils/countrie_flags.dart';
import 'package:o_connect/ui/utils/custom_show_dialog_helper/custom_show_dialog.dart';
import 'package:o_connect/ui/utils/custom_toast_helper/custom_toast.dart';
import 'package:o_connect/ui/utils/network_image_helpers/cached_image_validation.dart';
import 'package:o_connect/ui/utils/textfield_helper/app_fonts.dart';
import 'package:o_connect/ui/utils/textfield_helper/common_textfield.dart';
import 'package:o_connect/ui/utils/textfield_helper/textFieldTexts.dart';
import 'package:o_connect/ui/views/drawer/contacts/groups/bottom_sheet_for_group_edit.dart';
import 'package:provider/provider.dart';
import '../../../../utils/images/images.dart';

class EditGroup extends StatefulWidget {
  const EditGroup({
    Key? key,
    required this.indexList,
    required this.tabIndex,
  }) : super(key: key);

  final CreateGroupResponseModel indexList;
  final int tabIndex;

  @override
  State<EditGroup> createState() => _EditGroupState();
}

class _EditGroupState extends State<EditGroup> {
  TextEditingController groupNameController = TextEditingController();
  late MyContactsProvider myContactsProvider;

  @override
  void initState() {
    print("Hello");
    print("ID ===>>> ${widget.indexList.groupId} && ${widget.indexList.groupPic.runtimeType}");
    myContactsProvider = Provider.of<MyContactsProvider>(context, listen: false);
    myContactsProvider.viewGroupDetails(context: context, groupId: widget.indexList.groupId!.toInt() ?? 0);
    groupNameController.text = widget.indexList.groupName ?? "";
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(child: Consumer<MyContactsProvider>(
      builder: (context, provider, child) {
        return Scaffold(
          body: SingleChildScrollView(
            child: SafeArea(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(children: [
                  Container(
                    width: ScreenConfig.width,
                    decoration: BoxDecoration(borderRadius: BorderRadius.circular(8.r), color: Theme.of(context).cardColor),
                    child: Padding(
                      padding: EdgeInsets.symmetric(horizontal: 8.sp),
                      child: Row(
                        children: [
                          IconButton(
                              onPressed: () {
                                Navigator.pop(context);
                                myContactsProvider.clearFields();
                              },
                              icon: Icon(Icons.arrow_back_ios, size: 18.sp, color: Theme.of(context).hintColor.withOpacity(0.5))),
                          width5,
                          Text(
                            "Edit Group",
                            style: w500_14Poppins(color: Theme.of(context).hintColor),
                          ),
                        ],
                      ),
                    ),
                  ),
                  height10,

                  /// Image Container

                  Stack(
                    children: [
                      myContactsProvider.imageFileGroup != null
                          ? SizedBox(
                              height: 100.h,
                              width: 100.w,
                              child: ClipRRect(
                                  borderRadius: BorderRadius.circular(5.r),
                                  child: Image.file(
                                    File(myContactsProvider.imageFileGroup!.path),
                                    fit: BoxFit.fill,
                                  )),
                            )
                          : Container(
                              height: 100.h,
                              width: 100.w,
                              decoration: BoxDecoration(borderRadius: BorderRadius.circular(8.r), color: Theme.of(context).cardColor),
                              child: widget.indexList.groupPic != null && widget.indexList.groupPic != ""
                                  ? ClipRRect(
                                      borderRadius: BorderRadius.circular(10.r),
                                      child: Image.network("${BaseUrls.imageUrl}${widget.indexList.groupPic}", width: MediaQuery.of(context).size.width, fit: BoxFit.fill),
                                    )
                                  : ClipRRect(
                                      borderRadius: BorderRadius.circular(10.r),
                                      child: Image.asset(
                                        AppImages.defaultContactImg,
                                        fit: BoxFit.fill,
                                      )),
                            ),
                      Positioned(
                          top: 10.h,
                          left: 20.w,
                          child: widget.indexList.groupPic != null
                              ? InkWell(
                                  onTap: () async {
                                    if (groupNameController.text.isEmpty) {
                                      CustomToast.showErrorToast(msg: "Please enter group name");
                                    } else if (provider.selectedContactsList.isEmpty) {
                                      CustomToast.showErrorToast(msg: 'Select at least 1 contact for creating group');
                                    } else {
                                      provider.createGroupFunction(
                                          context: context,
                                          id: widget.indexList.groupId ?? 0,
                                          contactPic: provider.imageFileGroup,
                                          name: groupNameController.text,
                                          ids: provider.selectedContactsList,
                                          isFromEdit: true,
                                          groupImageUrl: null);
                                    }
                                  },
                                  child: Container(
                                    decoration: BoxDecoration(borderRadius: BorderRadius.circular(8), color: Theme.of(context).scaffoldBackgroundColor),
                                    child: Padding(
                                      padding: EdgeInsets.all(5.0.sp),
                                      child: Icon(
                                        Icons.delete,
                                        size: 22.sp,
                                        color: AppColors.mainBlueColor,
                                      ),
                                    ),
                                  ),
                                )
                              : const SizedBox())
                    ],
                  ),
                  InkWell(
                    onTap: () async {
                      await ImagePickerService.imagePickerBottomSheet(context).then((value) {
                        print("the image name $value");
                        if (value != null) {
                          print("the image $value");
                          myContactsProvider.updateGroupImagePickerFile(value);
                        }
                      });
                    },
                    child: Container(
                      decoration: BoxDecoration(borderRadius: BorderRadius.circular(8), color: Theme.of(context).scaffoldBackgroundColor),
                      child: Padding(
                          padding: EdgeInsets.all(5.0.sp),
                          child: Text(
                            (myContactsProvider.imageFileGroup != null || (widget.indexList.groupPic != null && widget.indexList.groupPic != "")) ? "Update Group Photo" : "Add Group Photo",
                            style: w500_14Poppins(color: const Color(0xff0E78F9)),
                          )),
                    ),
                  ),
                  height10,

                  CommonTextFormField(
                    controller: groupNameController,
                    fillColor: Theme.of(context).scaffoldBackgroundColor,
                    style: w400_14Poppins(color: Theme.of(context).hintColor),
                    borderColor: Theme.of(context).primaryColorLight,
                  ),

                  height10,
                  Container(
                    height: 450.h,
                    decoration: BoxDecoration(color: Theme.of(context).cardColor, borderRadius: BorderRadius.circular(10.r)),
                    child: Padding(
                      padding: EdgeInsets.all(10.0.sp),
                      child:myContactsProvider.contactsList.isEmpty?Center(child: Text("No contacts found",style: w400_14Poppins(color: Theme.of(context).hintColor),)):
                                Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "Selected Contacts",
                            style: w500_14Poppins(color: Theme.of(context).hintColor),
                          ),
                          height15,
                          Consumer<MyContactsProvider>(builder: (context, myContactsProvider, child) {
                            return SizedBox(
                              height: MediaQuery.of(context).size.height * 0.48,
                              width: double.maxFinite,
                              child:ListView.builder(
                                  shrinkWrap: true,
                                  itemCount: myContactsProvider.selectedContactsList.length,
                                  itemBuilder: (context, index) {
                                    var dataModel = myContactsProvider.contactsList.where((element) => element.contactId == myContactsProvider.selectedContactsList[index]).first;

                                    return Padding(
                                      padding: EdgeInsets.symmetric(vertical: 3.0.h),
                                      child: Container(
                                        decoration: BoxDecoration(color: Theme.of(context).primaryColorLight.withOpacity(0.05), borderRadius: BorderRadius.circular(10.0.r)),
                                        child: Padding(
                                          padding: EdgeInsets.all(9.sp),
                                          child: Row(
                                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                            children: [
                                              ClipRRect(
                                                borderRadius: BorderRadius.circular(50.r),
                                                child: SizedBox(
                                                    width: 45.w,
                                                    height: 45.w,
                                                    child: dataModel.contactPic != null
                                                        ? ImageServiceWidget(networkImgUrl: "${BaseUrls.imageUrl}${dataModel.contactPic}")
                                                        : SvgPicture.asset(AppImages.dummyProfileSvg)),
                                              ),
                                              // width10,
                                              SizedBox(
                                                width: 190.w,
                                                child: Padding(
                                                  padding: EdgeInsets.only(left: 10.0.sp),
                                                  child: Column(
                                                    crossAxisAlignment: CrossAxisAlignment.start,
                                                    children: [
                                                      Text(
                                                        "${dataModel.firstName.toString()} ${dataModel.lastName.toString()}",
                                                        style: w400_14Poppins(color: Theme.of(context).hintColor),
                                                      ),
                                                      Text(
                                                        "${dataModel.alternateEmailId.toString()} ",
                                                        style: w400_14Poppins(color: Theme.of(context).hintColor.withOpacity(0.3)),
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                              ),
                                              width10,
                                              Countries(
                                                countriesFlag: dataModel.countryName.toString().substring(0, 2),
                                              ),
                                              IconButton(
                                                onPressed: () {
                                                  if (myContactsProvider.selectedContactsList.length == 1) {
                                                    CustomToast.showErrorToast(msg: "At least 1 contact required for creating group");
                                                  } else {
                                                    myContactsProvider.removeSelectedContactFromGroupList(contactId: myContactsProvider.selectedContactsList[index]);
                                                  }
                                                },
                                                icon: Icon(
                                                  Icons.remove_circle_outline,
                                                  color: Theme.of(context).primaryColorLight,
                                                  size: 25.sp,
                                                ),
                                              )
                                            ],
                                          ),
                                        ),
                                      ),
                                    );
                                  }),
                            );
                          }),
                        ],
                      ),
                    ),
                  ),
                  height10,
                ]),
              ),
            ),
          ),
          bottomNavigationBar: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              CustomButton(
                buttonText: "Add More",
                buttonColor: Theme.of(context).scaffoldBackgroundColor,
                borderColor: const Color(0xff0E78F9),
                buttonTextStyle: w400_14Poppins(color: const Color(0xff0E78F9)),
                textColor: Colors.white,
                width: 110.w,
                onTap: () {
                  customShowDialog(context, const GroupBottomSheet());
                },
              ),
              CustomButton(
                buttonText: "Cancel",
                buttonColor: Theme.of(context).cardColor,
                buttonTextStyle: w400_14Poppins(color: Colors.white),
                // borderColor: Colors.blue,
                onTap: () {
                  Provider.of<MyContactsProvider>(context, listen: false).clearFields();
                  Navigator.pop(context);
                },
                textColor: Colors.white,
                width: 110.w,
              ),
              CustomButton(
                buttonText: "Update",
                textColor: Colors.white,
                buttonColor: const Color(0xff0E78F9),
                width: 110.w,
                onTap: () {
                  print(widget.indexList.groupId);
                  if (groupNameController.text.isEmpty) {
                    CustomToast.showErrorToast(msg: "Please enter group name");
                  } else if (provider.selectedContactsList.isEmpty) {
                    CustomToast.showErrorToast(msg: 'Select at least 1 contact for creating group');
                  } else {
                    provider.createGroupFunction(
                        context: context,
                        id: widget.indexList.groupId ?? 0,
                        contactPic: provider.imageFileGroup,
                        name: groupNameController.text,
                        ids: provider.selectedContactsList,
                        isFromEdit: true,
                        groupImageUrl: widget.indexList.groupPic);
                  }
                },
              ),
            ],
          ),
        );
      },
    ), onWillPop: () async {
      myContactsProvider.clearFields();
      return true;
    });
  }
}
