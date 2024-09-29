import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:o_connect/core/common_functions.dart';
import 'package:o_connect/core/models/response_models/create_group_response_model/create_group_response_model.dart';
import 'package:o_connect/core/providers/my_contacts_provider.dart';
import 'package:o_connect/core/screen_configs.dart';
import 'package:o_connect/ui/utils/base_urls.dart';
import 'package:o_connect/ui/utils/colors/colors.dart';
import 'package:o_connect/ui/utils/countrie_flags.dart';
import 'package:o_connect/ui/utils/custom_show_dialog_helper/custom_show_dialog.dart';
import 'package:o_connect/ui/utils/network_image_helpers/cached_image_validation.dart';
import 'package:o_connect/ui/utils/textfield_helper/app_fonts.dart';
import 'package:o_connect/ui/views/delete_bottom_sheet.dart';
import 'package:o_connect/ui/views/drawer/contacts/groups/edit_group.dart';
import 'package:o_connect/ui/views/drawer/contacts/widgets/action_container.dart';
import 'package:o_connect/ui/views/pip_views/pip_global_navigation.dart';
import 'package:provider/provider.dart';

import '../../../../utils/images/images.dart';

class ViewGroup extends StatefulWidget {
  const ViewGroup({Key? key, required this.groupDetails, required this.tabIndex, this.isFromTrashGroup = false}) : super(key: key);

  final CreateGroupResponseModel groupDetails;
  final int tabIndex;
  final bool isFromTrashGroup;

  @override
  State<ViewGroup> createState() => _ViewGroupState();
}

class _ViewGroupState extends State<ViewGroup> {
  TextEditingController groupNameController = TextEditingController();

  MyContactsProvider? myContactsProvider;

  @override
  void initState() {
    myContactsProvider = Provider.of<MyContactsProvider>(context, listen: false);
    print(widget.groupDetails.groupName);
    var getId = widget.groupDetails.groupId;
    myContactsProvider?.viewGroupDetails(context: context, groupId: int.parse(getId.toString()));
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<MyContactsProvider>(
      builder: (context, provider, child) {
        return Scaffold(
          body: SafeArea(
            child: SingleChildScrollView(
              physics: const ClampingScrollPhysics(),
              child: Column(crossAxisAlignment: CrossAxisAlignment.start, mainAxisAlignment: MainAxisAlignment.start, children: [
                Padding(
                  padding: EdgeInsets.all(8.0.sp),
                  child: Container(
                    width: ScreenConfig.width,
                    decoration: BoxDecoration(borderRadius: BorderRadius.circular(8.r), color: Theme.of(context).cardColor),
                    child: Row(
                      children: [
                        IconButton(
                            onPressed: () {
                              Navigator.pop(context);
                            },
                            icon: Icon(Icons.arrow_back_ios, size: 18.sp, color: Theme.of(context).hintColor.withOpacity(0.5))),
                        width5,
                        Text(
                          "View Group",
                          style: w500_14Poppins(color: Theme.of(context).hintColor),
                        ),
                      ],
                    ),
                  ),
                ),
                // height10,
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 2.h),
                  child: Container(
                    decoration: BoxDecoration(borderRadius: BorderRadius.circular(10.0.r), color: Theme.of(context).cardColor),
                    child: Padding(
                      padding: EdgeInsets.all(10.0.sp),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              SizedBox(
                                height: ScreenConfig.height * 0.09,
                                width: ScreenConfig.width * 0.18,
                                child: widget.groupDetails.groupPic != null && widget.groupDetails.groupPic != ""
                                    ? ClipRRect(
                                        borderRadius: BorderRadius.circular(10.r),
                                        child: Image.network("${BaseUrls.imageUrl}${widget.groupDetails.groupPic}", width: MediaQuery.of(context).size.width, fit: BoxFit.fill),
                                      )
                                    : ClipRRect(
                                        borderRadius: BorderRadius.circular(10.r),
                                        child: Image.asset(
                                          AppImages.defaultContactImg,
                                          fit: BoxFit.fill,
                                        )),
                              ),
                              width10,
                              Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  SizedBox(
                                    width: 180.w,
                                    child: Text(
                                      widget.groupDetails.groupName ?? "N/A",
                                      style: w500_14Poppins(color: Theme.of(context).hintColor),
                                    ),
                                  ),
                                  Text(
                                    "${widget.groupDetails.contactsCount.toString()} Members" ?? "N/A",
                                    style: w500_16Poppins(color: Theme.of(context).hintColor.withOpacity(0.3)),
                                  ),
                                ],
                              ),
                            ],
                          ),
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              Consumer<MyContactsProvider>(builder: (context, myContactsProvider, child) {
                                return ActionContainer(
                                  imagePath: widget.isFromTrashGroup ? AppImages.delProfileIcon : AppImages.editProfileIcon,
                                  // backgroundColor: Colors.blue,
                                  width: 40.w,
                                  imgHeight: 25.h,
                                  borderColor: Colors.transparent,
                                  onTap: () {
                                    widget.isFromTrashGroup
                                        ? customShowDialog(
                                            context,
                                            DeleteBottomSheet(
                                              headerTitle: "Delete",
                                              title: "Are you sure to delete this Group?",
                                              text: "\nSelected group will move to Trash.",
                                              textColor: Theme.of(context).hintColor,
                                              body: "",
                                              onTap: () async {
                                                myContactsProvider.selectedGroupFromTrash = [];
                                                myContactsProvider.selectedGroupFromTrash.add(widget.groupDetails.groupId!.toInt());
                                                myContactsProvider.permanentDeleteGroups(context: context, selectedContactFromTrash: myContactsProvider.selectedGroupFromTrash, isFullScreenView: true);
                                              },
                                            ))
                                        : Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                                builder: (context) => PIPGlobalNavigation(
                                                        childWidget: EditGroup(
                                                      indexList: widget.groupDetails,
                                                      tabIndex: widget.tabIndex,
                                                    ))));
                                  },
                                );
                              }),
                              Consumer<MyContactsProvider>(builder: (context, myContactsProvider, child) {
                                return ActionContainer(
                                  extraPadding: 0.sp,
                                  iconColor: Theme.of(context).hintColor.withOpacity(0.5),
                                  imagePath: widget.isFromTrashGroup ? AppImages.refreshIcon : AppImages.delProfileIcon,
                                  borderColor: Colors.transparent,
                                  width: 30.w,
                                  imgHeight: 22.h,
                                  onTap: () {
                                    /* widget.isFromTrashGroup?*/

                                    widget.isFromTrashGroup
                                        ? customShowDialog(
                                            context,
                                            DeleteBottomSheet(
                                              headerTitle: "Restore",
                                              title: "Do you want to restore this Group?",
                                              body: "",
                                              onTap: () async {
                                                myContactsProvider.selectedGroupFromTrash = [];
                                                myContactsProvider.selectedGroupFromTrash.add(widget.groupDetails.groupId!.toInt());
                                                myContactsProvider.deleteGroup(groupId: myContactsProvider.selectedGroupFromTrash, context: context, isViewGroup: false, isFullScreenView: true);
                                              },
                                            ))
                                        : customShowDialog(
                                            context,
                                            DeleteBottomSheet(
                                              headerTitle: "Delete",
                                              title: "Are you sure to delete this Group?",
                                              text: "\nSelected group will move to Trash.",
                                              textColor: Theme.of(context).hintColor,
                                              body: "",
                                              onTap: () async {
                                                provider.deleteGroup(groupId: widget.groupDetails.groupId, context: context, isViewGroup: true);
                                              },
                                            ));
                                  },
                                );
                              }),
                              // width15,
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                height5,
                Card(
                  color: Theme.of(context).cardColor,
                  elevation: 0,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8.r)),
                  child: Padding(
                    padding: EdgeInsets.all(8.0.sp),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Selected Contacts",
                          style: w500_14Poppins(color: Theme.of(context).hintColor),
                        ),
                        height15,

                        /// ListView Builder
                        SizedBox(
                          height: MediaQuery.of(context).size.height * 0.67,
                          child: ListView.separated(
                            shrinkWrap: true,
                            itemCount: provider.groupContactList.length,
                            itemBuilder: (context, index) {
                              print("get data from group data ${provider.groupContactList[index].countryName}");
                              print("get data from group data11111 ${provider.groupContactList[index].countryCallCode}");
                              return Container(
                                  decoration: BoxDecoration(color: Theme.of(context).primaryColorLight.withOpacity(0.05), borderRadius: BorderRadius.circular(10.0.r)),
                                  child: Padding(
                                    padding: EdgeInsets.all(5.sp),
                                    child: Row(
                                      children: [
                                        Padding(
                                          padding: EdgeInsets.symmetric(horizontal: 10.0.w, vertical: 10.h),
                                          child: SizedBox(
                                            height: 40.w,
                                            width: 40.w,
                                            child: checkStringValue(provider.groupContactList[index].contactPic)
                                                ? ClipRRect(
                                                    borderRadius: BorderRadius.circular(50.r),
                                                    child: ImageServiceWidget(networkImgUrl: "${BaseUrls.imageUrl}${provider.groupContactList[index].contactPic}"),
                                                  )
                                                : ClipRRect(
                                                    borderRadius: BorderRadius.circular(50.r),
                                                    child: SvgPicture.asset(
                                                      AppImages.dummyProfileSvg,
                                                      width: 50.w,
                                                      height: 50.w,
                                                    )),
                                          ),
                                        ),
                                        width10,
                                        SizedBox(
                                          width: 200.w,
                                          child: Column(
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            children: [
                                              Text(
                                                "${provider.groupContactList[index].firstName!} ${provider.groupContactList[index].lastName!}",
                                                style: w400_14Poppins(color: Theme.of(context).hintColor),
                                              ),
                                              Text(
                                                "${provider.groupContactList[index].alternateEmailId} ",
                                                style: w400_14Poppins(color: Theme.of(context).hintColor.withOpacity(0.3)),
                                              ),
                                            ],
                                          ),
                                        ),
                                        width40,
                                        Countries(countriesFlag: provider.groupContactList[index].countryName == null ? "In" : provider.groupContactList[index].countryName.toString().substring(0, 2)),
                                      ],
                                    ),
                                  ));
                            },
                            separatorBuilder: (BuildContext context, int index) => height5,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ]),
            ),
          ),
        );
      },
    );
  }
}
