import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:intl/intl.dart';
import 'package:o_connect/core/common_functions.dart';
import 'package:o_connect/core/providers/my_contacts_provider.dart';
import 'package:o_connect/core/screen_configs.dart';
import 'package:o_connect/ui/utils/base_urls.dart';
import 'package:o_connect/ui/utils/colors/colors.dart';
import 'package:o_connect/ui/utils/constant_strings.dart';
import 'package:o_connect/ui/utils/network_image_helpers/cached_image_validation.dart';
import 'package:o_connect/ui/utils/textfield_helper/app_fonts.dart';
import 'package:o_connect/ui/views/delete_bottom_sheet.dart';
import 'package:o_connect/ui/views/drawer/contacts/create_contact/add_contact.dart';
import 'package:o_connect/ui/views/drawer/contacts/widgets/action_container.dart';
import 'package:o_connect/ui/views/drawer/contacts/widgets/detail_card.dart';
import 'package:o_connect/ui/views/pip_views/pip_global_navigation.dart';
import 'package:provider/provider.dart';
import '../../../../../core/models/create_webinar_model/get_contact_model.dart';
import '../../../../utils/custom_show_dialog_helper/custom_show_dialog.dart';
import '../../../../utils/images/images.dart';

class ViewContactScreen extends StatefulWidget {
  const ViewContactScreen({Key? key, required this.itemData, required this.isFav, this.isFromTrash = false}) : super(key: key);

  final AllContactsModelDataRecord itemData;
  final bool isFav;
  final bool isFromTrash;

  @override
  State<ViewContactScreen> createState() => _ViewContactScreenState();
}

class _ViewContactScreenState extends State<ViewContactScreen> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    print('ggggggggggggggggg   ${widget.itemData.badgeId}');
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.all(8.0.sp),
            child: Column(
              children: [
                Container(
                  width: ScreenConfig.width,
                  decoration: BoxDecoration(borderRadius: BorderRadius.circular(8.r), color: Theme.of(context).cardColor),
                  child: Row(
                    children: [
                      IconButton(
                          onPressed: () {
                            Navigator.pop(context);
                          },
                          icon: Icon(
                            Icons.chevron_left_outlined,
                            color: Theme.of(context).hintColor.withOpacity(0.5),
                          )),
                      Text(
                        "View Contact",
                        style: w400_14Poppins(color: Theme.of(context).primaryColorLight),
                      ),
                    ],
                  ),
                ),
                height10,
                SizedBox(
                  child: Consumer<MyContactsProvider>(
                    builder: (context, provider, child) {
                      return Column(
                        children: [
                          /// Image Container and action buttons
                          Container(
                            decoration: BoxDecoration(borderRadius: BorderRadius.circular(10.0.r), color: Theme.of(context).cardColor),
                            child: Padding(
                              padding: EdgeInsets.all(15.0.sp),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      Row(
                                        // crossAxisAlignment: CrossAxisAlignment.start,
                                        // mainAxisAlignment: MainAxisAlignment.start,
                                        children: [
                                          SizedBox(
                                              height: 60.h,
                                              width: 60.w,
                                              child: ClipRRect(
                                                borderRadius: BorderRadius.circular(5.r),
                                                child: ImageServiceWidget(
                                                  networkImgUrl: "${BaseUrls.imageUrl}${widget.itemData.contactPic}",
                                                ),
                                              )),
                                          width5,
                                          Column(
                                            mainAxisAlignment: MainAxisAlignment.start,
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            children: [
                                              SizedBox(
                                                width: 
                                                200.w,
                                                child: Text(
                                                  "${widget.itemData.firstName ?? ""} ${widget.itemData.lastName ?? ""}",
                                                  style: w400_14Poppins(color: Theme.of(context).hintColor),
                                                ),
                                              ),
                                              height5,
                                              SvgPicture.asset(
                                                getSvgProductLogoPath(widget.itemData.badgeId ?? 4),
                                                height: 20.h,
                                                width: 20.w,
                                              ),
                                            ],
                                          ),
                                          // width5,
                                        ],
                                      ),
                                      widget.itemData.omailEmailId ==null|| widget.itemData.omailEmailId!.isEmpty?
                                      Row(
                                        crossAxisAlignment: CrossAxisAlignment.end,
                                        mainAxisAlignment: MainAxisAlignment.end,
                                        children: [
                                          // width10,
                                          // const Spacer(),
                                          if (!widget.isFromTrash) ...[
                                            // ActionContainer(
                                            //     imagePath: AppImages.mailBlueImg,
                                            //     borderColor: Colors.transparent,
                                            //     backgroundColor: AppColors.appmainThemeColor,
                                            //     width: 50.w,
                                            //     onTap: () {
                                            //       CustomToast.showInfoToast(msg: "Coming Soon...");
                                            //     }
                                            //     //   Navigator.pushNamed(context,
                                            //     //       RoutesManager.addContact);
                                            //     // },
                                            //     ),
                                            ActionContainer(
                                                imagePath: AppImages.editProfileIcon,
                                                // backgroundColor: Colors.blue,
                                                width: 40.w,
                                                imgHeight: 23.h,
                                                borderColor: Colors.transparent,
                                                onTap: () {
                                                  Navigator.push(
                                                      context,
                                                      MaterialPageRoute(
                                                          builder: (context) => PIPGlobalNavigation(
                                                                  childWidget: AddContactPage(
                                                                isEdit: true,
                                                                contactData: widget.itemData,
                                                              ))));
                                                }),

                                            ActionContainer(
                                              extraPadding: 0.sp,
                                              imagePath: AppImages.delProfileIcon,
                                              borderColor: Colors.transparent,
                                              width: 20.w,
                                              imgHeight: 25.h,
                                              onTap: () {
                                                customShowDialog(
                                                    context,
                                                    DeleteBottomSheet(
                                                      headerTitle: "Delete",
                                                      title: "Are you sure to delete this Contact?",
                                                      text: "\nSelected contact will move to Trash.",
                                                      textColor: Theme.of(context).hintColor,
                                                      body: "",
                                                      onTap: () async {
                                                        await provider.deleteAllContacts(
                                                            context: context, contactId: int.parse(widget.itemData.contactId.toString()), isViewContact: true, isFav: widget.isFav);
                                                      },
                                                    ));
                                              },
                                            ),
                                          ] else ...[
                                            // width10,
                                            Consumer<MyContactsProvider>(builder: (context, myContactsProvider, child) {
                                              return GestureDetector(
                                                  onTap: () {
                                                    customShowDialog(
                                                        context,
                                                        DeleteBottomSheet(
                                                          headerTitle: "Restore",
                                                          title: "Do you want to restore this Contact?",
                                                          body: "",
                                                          onTap: () async {
                                                            /*  getAllContactsProvider.selectedContactFromTrash = [];
                                      getAllContactsProvider.selectedContactFromTrash.add(int.parse(getAllContactsProvider.contactsList[index].contactId.toString()));*/
                                                            myContactsProvider.deleteAllContacts(context: context, contactId: int.parse(widget.itemData.contactId.toString()), isFullScreenView: true);
                                                          },
                                                        ));
                                                  },
                                                  child: Padding(
                                                    padding: EdgeInsets.only(bottom: 8.h),
                                                    child: SvgPicture.asset(
                                                      AppImages.refreshIcon,
                                                      height: 20.h,
                                                      color: Theme.of(context).primaryColorLight,
                                                    ),
                                                  ));
                                            }),
                                            // width10,
                                            Consumer<MyContactsProvider>(builder: (context, myContactsProvider, child) {
                                              return ActionContainer(
                                                  imagePath: AppImages.delProfileIcon,
                                                  // backgroundColor: Colors.blue,
                                                  width: 40.w,
                                                  imgHeight: 25.h,
                                                  borderColor: Colors.transparent,
                                                  onTap: () {
                                                    customShowDialog(
                                                        context,
                                                        DeleteBottomSheet(
                                                          headerTitle: "Delete",
                                                          title: "Are you sure to delete this Contact?",
                                                          text: "\nSelected contact will move to Trash.",
                                                          textColor: Theme.of(context).hintColor,
                                                          body: "",
                                                          onTap: () async {
                                                            myContactsProvider.updateContactListTrash(contactId: widget.itemData.contactId!.toInt());
                                                            myContactsProvider.permanentDeleteContacts(context: context, isValue: false, isFromFullScreen: true);
                                                          },
                                                        ));
                                                  });
                                            })
                                          ]
                                        ],
                                      ):SizedBox()
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ),

                          /// Space
                          height10,

                          /// Details Container 1
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Container(
                                decoration: BoxDecoration(color: Theme.of(context).cardColor, borderRadius: BorderRadius.circular(10.0)),
                                child: Padding(
                                  padding: EdgeInsets.symmetric(horizontal: 6.w, vertical: 6.h),
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Padding(
                                        padding: EdgeInsets.all(8.0.sp),
                                        child: Text(
                                          ConstantsStrings.contactInfo,
                                          style: w500_14Poppins(color: Theme.of(context).hintColor.withOpacity(0.9)),
                                        ),
                                      ),
                                      height10,
                                      DetailCard(
                                        fieldHeading: ConstantsStrings.companyName,
                                        fieldData: checkStringValue(widget.itemData.companyName) ? widget.itemData.companyName! : ConstantsStrings.responseFieldEmptyText,
                                        imagePath: AppImages.companyIcon,
                                      ),
                                      height10,
                                      DetailCard(
                                        fieldHeading: ConstantsStrings.jobTitle,
                                        fieldData: checkStringValue(widget.itemData.jobTitle) ? widget.itemData.jobTitle! : ConstantsStrings.responseFieldEmptyText,
                                        imagePath: AppImages.jobTitleIcon,
                                      ),
                                      height10,
                                      DetailCard(
                                        fieldHeading: ConstantsStrings.dateOfBirth,
                                        fieldData: checkStringValue(widget.itemData.dateOfBirth)
                                            ? DateFormat('MMM dd, yyyy').format(DateTime.parse(widget.itemData.dateOfBirth!))
                                            : ConstantsStrings.responseFieldEmptyText,
                                        imagePath: AppImages.calendarIcon,
                                      ),
                                      height10,
                                      DetailCard(
                                        fieldHeading: ConstantsStrings.joinedDate,
                                        fieldData: checkStringValue(widget.itemData.createdDate)
                                            ? DateFormat("MMM dd yyyy, H:mm a").format(DateTime.parse(widget.itemData.createdDate!).toLocal())
                                            : ConstantsStrings.responseFieldEmptyText,
                                        imagePath: AppImages.calendarIcon,
                                      ),
                                      height10,
                                    ],
                                  ),
                                ),
                              ),
                              height10,

                              // DetailCard(
                              //   fieldHeading: ConstantsStrings.phoneNumber,
                              //   fieldData: checkStringValue(widget.itemData.contactNumber) ? widget.itemData.contactNumber! : ConstantsStrings.responseFieldEmptyText,
                              //   imagePath: AppImages.callIcon,
                              // ),
                              // height15,
                              Container(
                                decoration: BoxDecoration(color: Theme.of(context).cardColor, borderRadius: BorderRadius.circular(10.0)),
                                child: Padding(
                                  padding: EdgeInsets.symmetric(horizontal: 6.w, vertical: 6.h),
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Padding(
                                        padding: EdgeInsets.all(8.0.sp),
                                        child: Text(
                                          ConstantsStrings.personalInfo,
                                          style: w500_14Poppins(color: Theme.of(context).hintColor.withOpacity(0.9)),
                                        ),
                                      ),
                                      height10,
                                      DetailCard(
                                        fieldHeading: ConstantsStrings.oMailAddress,
                                        fieldData: checkStringValue(widget.itemData.omailEmailId) ? widget.itemData.omailEmailId! : ConstantsStrings.responseFieldEmptyText,
                                        imagePath: AppImages.mailIcon2,
                                      ),
                                      height10,
                                      DetailCard(
                                        fieldHeading: ConstantsStrings.alternateEmailAddress,
                                        fieldData: checkStringValue(widget.itemData.alternateEmailId) ? widget.itemData.alternateEmailId! : ConstantsStrings.responseFieldEmptyText,
                                        imagePath: AppImages.mailIcon2,
                                      ),
                                      height10,
                                      DetailCard(
                                        fieldHeading: ConstantsStrings.address,
                                        fieldData: checkStringValue(widget.itemData.address) ? widget.itemData.address! : ConstantsStrings.responseFieldEmptyText,
                                        iconNeeded: true,
                                        icon: Icons.location_on,
                                      ),
                                      height10,
                                      DetailCard(
                                        fieldHeading: ConstantsStrings.country,
                                        fieldData: widget.itemData.countryName ?? ConstantsStrings.responseFieldEmptyText,
                                        iconNeeded: true,
                                        icon: Icons.location_on,
                                      ),
                                      height10,
                                      DetailCard(
                                        fieldHeading: ConstantsStrings.state,
                                        fieldData: widget.itemData.stateName ?? ConstantsStrings.responseFieldEmptyText,
                                        iconNeeded: true,
                                        icon: Icons.location_on,
                                      ),
                                      height10,
                                      DetailCard(
                                        fieldHeading: ConstantsStrings.phoneNumber,
                                        fieldData: checkStringValue(widget.itemData.contactNumber) ? widget.itemData.contactNumber! : ConstantsStrings.responseFieldEmptyText,
                                        iconNeeded: true,
                                        icon: Icons.phone,
                                      ),
                                      height10,
                                      DetailCard(
                                        fieldHeading: ConstantsStrings.zipCode,
                                        fieldData: checkStringValue(widget.itemData.zipcode) ? widget.itemData.zipcode! : ConstantsStrings.responseFieldEmptyText,
                                        iconNeeded: true,
                                        icon: Icons.location_on,
                                      ),
                                      height10,
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      );
                    },
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
