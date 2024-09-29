import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:lottie/lottie.dart';
import 'package:o_connect/ui/utils/base_urls.dart';
import 'package:o_connect/ui/utils/network_image_helpers/cached_image_validation.dart';
import 'package:o_connect/ui/views/drawer/contacts/groups/view_group.dart';
import 'package:o_connect/ui/views/pip_views/pip_global_navigation.dart';
import 'package:provider/provider.dart';

import '../../../../../core/providers/my_contacts_provider.dart';
import '../../../../utils/colors/colors.dart';
import '../../../../utils/custom_show_dialog_helper/custom_show_dialog.dart';
import '../../../../utils/images/images.dart';
import '../../../../utils/textfield_helper/app_fonts.dart';
import '../../../delete_bottom_sheet.dart';

class TrashGroups extends StatefulWidget {
  const TrashGroups({super.key, required this.index});

  final int index;

  @override
  State<TrashGroups> createState() => _TrashGroupsState();
}

class _TrashGroupsState extends State<TrashGroups> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Consumer<MyContactsProvider>(builder: (context, getAllContactsProvider, child) {
        return getAllContactsProvider.groupsContactsList.isNotEmpty
            ? ListView.separated(
                shrinkWrap: true,
                itemCount: getAllContactsProvider.groupsContactsList.length,
                itemBuilder: (context, index) {
                  return InkWell(
                    onTap: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => PIPGlobalNavigation(
                                      childWidget: ViewGroup(
                                    groupDetails: getAllContactsProvider.groupsContactsList[index],
                                    tabIndex: widget.index,
                                    isFromTrashGroup: true,
                                  ))));
                    },
                    child: Container(
                      decoration: BoxDecoration(borderRadius: BorderRadius.circular(5.0.r), color: Theme.of(context).cardColor),
                      child: Row(
                        children: [
                          InkWell(
                            onTap: () {
                              getAllContactsProvider.updateGroupListTrash(
                                groupId: int.parse(getAllContactsProvider.groupsContactsList[index].groupId.toString() ?? "0"),
                              );
                            },
                            child: Padding(
                              padding: EdgeInsets.symmetric(horizontal: 10.0.w, vertical: 10.h),
                              child: SizedBox(
                                height: 40.w,
                                width: 40.w,
                                child: getAllContactsProvider.groupsContactsList[index].groupPic == null || getAllContactsProvider.groupsContactsList[index].groupPic.isEmpty
                                    ? ClipRRect(
                                        borderRadius: BorderRadius.circular(50.r),
                                        child: getAllContactsProvider.selectedGroupFromTrash.contains(getAllContactsProvider.groupsContactsList[index].groupId)
                                            ? Stack(
                                                children: [
                                                  SvgPicture.asset(
                                                    AppImages.dummyProfileSvg,
                                                    width: 50.w,
                                                    height: 50.w,
                                                  ),
                                                  Container(
                                                    color: Colors.blue.withOpacity(0.4),
                                                    child: Center(
                                                      child: SvgPicture.asset(
                                                        AppImages.tickIconSvg,
                                                      ),
                                                    ),
                                                  )
                                                ],
                                              )
                                            : SvgPicture.asset(
                                                AppImages.dummyProfileSvg,
                                                width: 50.w,
                                                height: 50.w,
                                              ))
                                    : ClipRRect(
                                        borderRadius: BorderRadius.circular(50.r),
                                        child: getAllContactsProvider.selectedGroupFromTrash.contains(getAllContactsProvider.groupsContactsList[index].groupId)
                                            ? Stack(
                                                children: [
                                                  Image.network(
                                                    "${BaseUrls.imageUrl}${getAllContactsProvider.groupsContactsList[index].groupPic}",
                                                    fit: BoxFit.fill,
                                                    height: 40.w,
                                                    width: 40.w,
                                                  ),
                                                  Container(
                                                    color: Colors.blue.withOpacity(0.4),
                                                    child: Center(
                                                      child: SvgPicture.asset(
                                                        AppImages.tickIconSvg,
                                                      ),
                                                    ),
                                                  )
                                                ],
                                              )
                                            : ImageServiceWidget(networkImgUrl: "${BaseUrls.imageUrl}${getAllContactsProvider.groupsContactsList[index].groupPic}"),
                                      ),
                              ),
                            ),
                          ),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                Text(
                                  "${getAllContactsProvider.groupsContactsList[index].groupName}",
                                  style: w400_14Poppins(color: Theme.of(context).hintColor),
                                ),
                                height5,
                                Text(
                                  "Members : ${getAllContactsProvider.groupsContactsList[index].contactsCount.toString() ?? "00"}",
                                  style: w400_13Poppins(color: Theme.of(context).primaryColorLight),
                                ),
                              ],
                            ),
                          ),
                          width10,
                          InkWell(
                              onTap: () {
                                customShowDialog(
                                    context,
                                    DeleteBottomSheet(
                                      headerTitle: "Restore",
                                      title: "Do you want to restore this Group?",
                                      body: "",
                                      onTap: () async {
                                        getAllContactsProvider.selectedGroupFromTrash = [];
                                        getAllContactsProvider.selectedGroupFromTrash.add(int.parse(getAllContactsProvider.groupsContactsList[index].groupId.toString()));
                                        getAllContactsProvider.deleteGroup(groupId: getAllContactsProvider.selectedGroupFromTrash, context: context, isViewGroup: false);
                                      },
                                    ));
                              },
                              child: Icon(
                                Icons.refresh_outlined,
                                color: Theme.of(context).primaryColorLight,
                              )),
                          width10,
                          InkWell(
                              onTap: () {
                                customShowDialog(
                                    context,
                                    DeleteBottomSheet(
                                      headerTitle: "Delete",
                                      titleTextColor: AppColors.customButtonBlueColor,
                                      title: "Are you sure you want to delete?",
                                      body: "\nSelected Group will get deleted permanently!\n Would you like to continue? ",
                                      onTap: () async {
                                        getAllContactsProvider.selectedGroupFromTrash = [];
                                        getAllContactsProvider.selectedGroupFromTrash.add(int.parse(getAllContactsProvider.groupsContactsList[index].groupId.toString()));
                                        getAllContactsProvider.permanentDeleteGroups(
                                          context: context,
                                          selectedContactFromTrash: getAllContactsProvider.selectedGroupFromTrash,
                                        );
                                      },
                                    ));
                              },
                              child: SvgPicture.asset(AppImages.delProfileIcon)),
                          width10,
                        ],
                      ),
                    ),
                  );
                },
                separatorBuilder: (context, index) {
                  return SizedBox(
                    height: 10.h,
                  );
                },
              )
            : Center(
                child: Column(
                  children: [
                    height70,
                    height70,
                    Image.asset(AppImages.trashImage),
                    height20,
                    Text(
                      "No group(s) deleted yet",
                      style: w700_15Poppins(color: Colors.blue),
                    ),
                    height5,
                    Text(
                      "Deleted groups are shown here.",
                      style: w500_15Poppins(color: Theme.of(context).hintColor),
                    ),
                  ],
                ),
              );
      }),
    );
  }
}
