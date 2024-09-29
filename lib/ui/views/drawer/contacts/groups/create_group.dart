import 'dart:io';
import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:image_picker/image_picker.dart';
import 'package:o_connect/core/providers/my_contacts_provider.dart';
import 'package:o_connect/ui/utils/base_urls.dart';
import 'package:o_connect/ui/utils/buttons_helper/custom_botton.dart';
import 'package:o_connect/ui/utils/colors/colors.dart';
import 'package:o_connect/ui/utils/common_app_bar/image_picker_bottombar.dart';
import 'package:o_connect/ui/utils/constant_strings.dart';
import 'package:o_connect/ui/utils/countrie_flags.dart';
import 'package:o_connect/ui/utils/custom_show_dialog_helper/custom_show_dialog.dart';
import 'package:o_connect/ui/utils/custom_toast_helper/custom_toast.dart';
import 'package:o_connect/ui/utils/textfield_helper/app_fonts.dart';
import 'package:o_connect/ui/utils/textfield_helper/common_textfield.dart';
import 'package:o_connect/ui/utils/textfield_helper/textFieldTexts.dart';
import 'package:o_connect/ui/views/authentication/form_validations.dart';
import 'package:o_connect/ui/views/drawer/contacts/groups/select_contact_for_creating_group.dart';
import 'package:provider/provider.dart';
import '../../../../../core/screen_configs.dart';
import '../../../../utils/images/images.dart';

class CreateGroup extends StatefulWidget {
  const CreateGroup({required this.contactIds, Key? key}) : super(key: key);
  final List contactIds;

  @override
  State<CreateGroup> createState() => _CreateGroupState();
}

class _CreateGroupState extends State<CreateGroup> {
  TextEditingController groupNameController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
        child: Scaffold(
          body: SingleChildScrollView(
            physics: const ClampingScrollPhysics(),
            child: SafeArea(
              child: SingleChildScrollView(
                child: Padding(
                  padding: EdgeInsets.all(10.0.sp),
                  child: Consumer<MyContactsProvider>(builder: (context, myContactsProvider, child) {
                    return Form(
                      key: _formKey,
                      child: Column(children: [
                        /// Heading
                        Container(
                          width: ScreenConfig.width,
                          decoration: BoxDecoration(borderRadius: BorderRadius.circular(8.r), color: Theme.of(context).cardColor),
                          child: Row(
                            children: [
                              IconButton(
                                  onPressed: () {
                                    Navigator.pop(context);
                                    Provider.of<MyContactsProvider>(context, listen: false).clearFields();
                                  },
                                  icon: Icon(
                                    Icons.arrow_back_ios,
                                    color: Theme.of(context).primaryColorLight,
                                    size: 15,
                                  )),
                              SizedBox(
                                width: 5.w,
                              ),
                              Text(
                                "Create Group",
                                style: w500_14Poppins(color: Theme.of(context).primaryColorLight),
                              ),
                            ],
                          ),
                        ),
                        height10,
                        Container(
                            height: 120.h,
                            width: 120.w,
                            decoration: BoxDecoration(borderRadius: BorderRadius.circular(8.r), color: Theme.of(context).cardColor),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                myContactsProvider.imageFileGroup == null
                                    ? Column(
                                        children: [
                                          SvgPicture.asset(AppImages.noProfileIcon)

                                          // GestureDetector(
                                          //   onTap: () async {
                                          //     await ImagePickerService.imagePickerBottomSheet(context).then((value) {
                                          //       if (value != null) {
                                          //         myContactsProvider.updateGroupImagePickerFile(value);
                                          //       }
                                          //     });
                                          //   },
                                          //   child: Padding(
                                          //     padding: EdgeInsets.all(12.0.sp),
                                          //     child: Icon(
                                          //       Icons.camera_alt_rounded,
                                          //       color: AppColors.mainBlueColor,
                                          //       size: 28.sp,
                                          //     ),
                                          //   ),
                                          // ),
                                        ],
                                      )
                                    : GestureDetector(
                                        onTap: () {},
                                        child: Stack(
                                          alignment: Alignment.topRight,
                                          children: [
                                            SizedBox(
                                              height: 120.h,
                                              width: 120.w,
                                              child: ClipRRect(
                                                borderRadius: BorderRadius.circular(5.r),
                                                child: Image.file(
                                                  File(
                                                    myContactsProvider.imageFileGroup!.path,
                                                  ),
                                                  fit: BoxFit.fill,
                                                ),
                                              ),
                                            ),
                                            SvgPicture.asset(AppImages.noProfileIcon)
                                          ],
                                        ),
                                      ),
                                // Visibility(
                                //   visible: myContactsProvider.imageFileGroup == null,
                                //   child: Text(
                                //     "Upload group photo",
                                //     style: w400_14Poppins(color: AppColors.mainBlueColor),
                                //   ),
                                // ),
                              ],
                            )),
                        height10,
                        InkWell(
                          onTap: () async {
                            await ImagePickerService.imagePickerBottomSheet(context).then((value) {
                              if (value != null) {
                                myContactsProvider.updateGroupImagePickerFile(value);
                              }
                            });
                          },
                          child: Text(
                            "Upload group photo",
                            style: w400_16Poppins(color: AppColors.customButtonBlueColor),
                          ),
                        ),
                        // DottedBorder(
                        //   strokeWidth: 1,
                        //   dashPattern: const [8, 4],
                        //   borderType: BorderType.RRect,
                        //   color: Theme.of(context).disabledColor.withOpacity(0.5),
                        //   radius: Radius.circular(10.r),
                        //   child:

                        // ),
                        // height10,
                        // const TextFieldTexts(
                        //   name: "Group Name",
                        //   isRequired: true,
                        // ),
                        height15,
                        CommonTextFormField(
                          fillColor: Theme.of(context).scaffoldBackgroundColor,
                          controller: groupNameController,
                          hintText: "Enter Group Name",
                          hintStyle: w400_14Poppins(color: Theme.of(context).hintColor.withOpacity(0.2)),
                          validator: FormValidations.requiredFieldValidation,
                          maxLength: 60,
                        ),
                        height15,
                        Container(
                          height: ScreenConfig.height*0.52,
                          decoration: BoxDecoration(color: Theme.of(context).cardColor, borderRadius: BorderRadius.circular(10.r)),
                          child: Padding(
                            padding: EdgeInsets.all(8.0.sp),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  "Selected Contacts",
                                  style: w400_14Poppins(color: Theme.of(context).hintColor),
                                ),
                                height10,
                                SizedBox(
                                  height: ScreenConfig.height*0.45,
                                  child: ListView.builder(
                                      shrinkWrap: true,
                                      itemCount: Provider.of<MyContactsProvider>(context).selectedContactsList.length,
                                      itemBuilder: (context, index) {
                                        return Padding(
                                          padding: EdgeInsets.symmetric(vertical: 3.0.h),
                                          child: Container(
                                            height: 70.h,
                                            decoration: BoxDecoration(color: Theme.of(context).primaryColor, borderRadius: BorderRadius.circular(10.0.r)),
                                            child: Padding(
                                              padding: EdgeInsets.all(8.0.sp),
                                              child: Row(
                                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                children: [
                                                  Row(
                                                    children: [
                                                      myContactsProvider.contactsList.where((e) => e.contactId == myContactsProvider.selectedContactsList[index]).toList().first.contactPic == null ||
                                                              myContactsProvider.contactsList.where((e) => e.contactId == myContactsProvider.selectedContactsList[index]).toList().first.contactPic ==
                                                                  ""
                                                          ? ClipRRect(
                                                              borderRadius: BorderRadius.circular(50.r),
                                                              child: SvgPicture.asset(
                                                                AppImages.dummyProfileSvg,
                                                                width: 50.w,
                                                                height: 50.w,
                                                              ))
                                                          : ClipRRect(
                                                              borderRadius: BorderRadius.circular(50.r),
                                                              child: Image.network(
                                                                "${BaseUrls.imageUrl}${myContactsProvider.contactsList.where((e) => e.contactId == myContactsProvider.selectedContactsList[index]).toList().first.contactPic}",
                                                                fit: BoxFit.fill,
                                                                height: 40.w,
                                                                width: 40.w,
                                                              ),
                                                              //  SvgPicture.asset(
                                                              //   AppImages.dummyProfileSvg,
                                                              //   width: 50.w,
                                                              //   height: 50.w,
                                                              // )
                                                            ),
                                                      Padding(
                                                        padding: EdgeInsets.only(left: 10.0.sp),
                                                        child: SizedBox(
                                                          width:  ScreenConfig.width*0.5,
                                                          child: Column(
                                                            crossAxisAlignment: CrossAxisAlignment.start,
                                                            children: [
                                                              Text(
                                                                myContactsProvider.contactsList
                                                                    .where((e) => e.contactId == myContactsProvider.selectedContactsList[index])
                                                                    .toList()
                                                                    .first
                                                                    .firstName
                                                                    .toString(),
                                                                style: w400_14Poppins(
                                                                  color: Theme.of(context).hintColor,
                                                                ),
                                                                overflow: TextOverflow.ellipsis,
                                                              ),
                                                              Text(
                                                                myContactsProvider.contactsList
                                                                        .where((e) => e.contactId == myContactsProvider.selectedContactsList[index])
                                                                        .toList()
                                                                        .first
                                                                        .alternateEmailId
                                                                        .toString() ??
                                                                    "NA",
                                                                style: w400_12Poppins(
                                                                  color: Theme.of(context).hintColor.withOpacity(0.5),
                                                                ),
                                                                overflow: TextOverflow.ellipsis,
                                                              ),
                                                            ],
                                                          ),
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                  Row(
                                                    children: [
                                                      Countries(
                                                          countriesFlag: myContactsProvider.contactsList
                                                              .where((e) => e.contactId == myContactsProvider.selectedContactsList[index])
                                                              .toList()
                                                              .first
                                                              .countryName
                                                              .toString()
                                                              .substring(0, 2)),
                                                      width10,
                                                      InkWell(
                                                          onTap: () {
                                                            if (myContactsProvider.selectedContactsList.length == 1) {
                                                              CustomToast.showErrorToast(msg: "At least 1 contact required for creating group");
                                                            } else {
                                                              myContactsProvider.removeSelectedContactFromGroupList(contactId: myContactsProvider.selectedContactsList[index]);
                                                            }
                                                          },
                                                          child: SvgPicture.asset(AppImages.remove)),
                                                    ],
                                                  )
                                                ],
                                              ),
                                            ),
                                          ),
                                        );
                                      }),
                                ),
                              ],
                            ),
                          ),
                        ),
                        height10,
                      ]),
                    );
                  }),
                ),
              ),
            ),
          ),
          bottomNavigationBar: Consumer<MyContactsProvider>(builder: (context, myContactsProvider, child) {
            return Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                CustomButton(
                  buttonText: "Add More",
                  // buttonColor: const Color(0x330381f5),
                  borderColor: AppColors.customButtonBlueColor,
                  buttonColor: Theme.of(context).scaffoldBackgroundColor,
                  buttonTextStyle: w400_14Poppins(
                    color: AppColors.customButtonBlueColor,
                  ),
                  width: 100.w,
                  onTap: () {
                    customShowDialog(
                        context,
                        const SelectContactForCreatingGroupBottomSheet(
                          isOpenInCreateGroup: true,
                          className: "Add More",
                        ));
                  },
                ),
                width20,
                CustomButton(
                  buttonText: "Cancel",
                  onTap: () {
                    Provider.of<MyContactsProvider>(context, listen: false).clearFields();
                    groupNameController.clear();
                    myContactsProvider.selectedContactsList.clear();
                    Navigator.pop(context);
                  },
                  buttonColor: AppColors.customButtonBlueColor.withOpacity(0.1),
                  buttonTextStyle: w400_14Poppins(color: Theme.of(context).hintColor),
                  // borderColor: Colors.blue,
                  textColor: Colors.blue,
                  width: 100.w,
                ),
                width20,
                CustomButton(
                  buttonText: "Create",
                  textColor: Colors.white,
                  buttonColor: AppColors.customButtonBlueColor,
                  width: 100.w,
                  onTap: () {
                    if (_formKey.currentState!.validate()) {
                      if (groupNameController.text.isEmpty) {
                        CustomToast.showErrorToast(msg: "Group name required");
                      } else if (myContactsProvider.selectedContactsList.isEmpty) {
                        CustomToast.showErrorToast(msg: '"Select at least 1 contact for creating group"');
                      } else if (groupNameController.text.length > 60) {
                        CustomToast.showErrorToast(msg: "Maximum character allowed is 60");
                      } else {
                        myContactsProvider.createGroupFunction(
                            context: context, id: 0, contactPic: myContactsProvider.imageFileGroup, name: groupNameController.text, ids: myContactsProvider.selectedContactsList);
                        // myContactsProvider.selectedContactsList
                        //     .clear();
                        // // Provider.of<MyContactsProvider>(context).selectedIndexValue = 0;
                        // Navigator.push(
                        //     context,
                        //     MaterialPageRoute(
                        //         builder: (context) =>
                        //             AllContactsPage()));
                      }
                    }
                  },
                ),
              ],
            );
          }),
        ),
        onWillPop: () async {
          Provider.of<MyContactsProvider>(context, listen: false).clearFields();
          return true;
        });
  }
}
