import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_svg/svg.dart';
import 'package:lottie/lottie.dart';
import 'package:o_connect/ui/utils/base_urls.dart';
import 'package:o_connect/ui/utils/countrie_flags.dart';
import 'package:o_connect/ui/utils/network_image_helpers/cached_image_validation.dart';
import 'package:o_connect/ui/views/drawer/contacts/create_contact/view_contact_screen.dart';
import 'package:o_connect/ui/views/pip_views/pip_global_navigation.dart';
import 'package:provider/provider.dart';
import '../../../../../core/providers/my_contacts_provider.dart';
import '../../../../../core/screen_configs.dart';
import '../../../../utils/colors/colors.dart';
import '../../../../utils/custom_show_dialog_helper/custom_show_dialog.dart';
import '../../../../utils/images/images.dart';
import '../../../../utils/textfield_helper/app_fonts.dart';
import '../../../delete_bottom_sheet.dart';

class TrashContacts extends StatefulWidget {
  const TrashContacts({
    super.key,
    required this.index,
  });

  final int index;

  @override
  State<TrashContacts> createState() => _TrashContactsState();
}

class _TrashContactsState extends State<TrashContacts> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(body: Consumer<MyContactsProvider>(builder: (context, getAllContactsProvider, child) {
      return getAllContactsProvider.contactsList.isNotEmpty
          ? ListView.separated(
              shrinkWrap: true,
              itemCount: getAllContactsProvider.contactsList.length,
              itemBuilder: (context, index) {
                return InkWell(
                  onTap: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => PIPGlobalNavigation(childWidget: ViewContactScreen(isFromTrash: true, itemData: getAllContactsProvider.contactsList[index], isFav: false)),
                        ));
                  },
                  child: Container(
                    margin: EdgeInsets.symmetric(horizontal: 5.w),
                    decoration: BoxDecoration(borderRadius: BorderRadius.circular(5.0.r), color: Theme.of(context).cardColor),
                    child: Row(
                      children: [
                        InkWell(
                          onTap: () {
                            getAllContactsProvider.updateContactListTrash(contactId: int.parse(getAllContactsProvider.contactsList[index].contactId.toString()));
                          },
                          child: Padding(
                            padding: EdgeInsets.all(8.0.sp),
                            child: SizedBox(
                              height: 40.w,
                              width: 40.w,
                              child: getAllContactsProvider.contactsList[index].contactPic == null || getAllContactsProvider.contactsList[index].contactPic == ""
                                  ? ClipRRect(
                                      borderRadius: BorderRadius.circular(50.r),
                                      child: getAllContactsProvider.selectedContactFromTrash.contains(getAllContactsProvider.contactsList[index].contactId)
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
                                      child: getAllContactsProvider.selectedContactFromTrash.contains(getAllContactsProvider.contactsList[index].contactId)
                                          ? Stack(
                                              children: [
                                                ImageServiceWidget(networkImgUrl: "${BaseUrls.imageUrl}${getAllContactsProvider.contactsList[index].contactPic}"),
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
                                          : ImageServiceWidget(networkImgUrl: "${BaseUrls.imageUrl}${getAllContactsProvider.contactsList[index].contactPic}"),
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
                                "${getAllContactsProvider.contactsList[index].firstName} ${getAllContactsProvider.contactsList[index].lastName}",
                                style: w400_14Poppins(color: Theme.of(context).hintColor),
                              ),
                              height5,
                              Text(
                                getAllContactsProvider.contactsList[index].alternateEmailId.toString() ?? "test@gmail.com",
                                style: w400_13Poppins(color: Theme.of(context).primaryColorLight),
                              ),
                            ],
                          ),
                        ),
                        width10,
                        Countries(countriesFlag: getAllContactsProvider.contactsList[index].countryName.toString().substring(0, 2)),
                        width10,
                        InkWell(
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
                                      getAllContactsProvider.deleteAllContacts(
                                        context: context,
                                        contactId: int.parse(getAllContactsProvider.contactsList[index].contactId.toString()),
                                      );
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
                                    body: "\nSelected Contact will get deleted permanently!\n Would you like to continue? ",
                                    onTap: () async {
                                      context.read<MyContactsProvider>().updateContactListTrash(contactId: getAllContactsProvider.contactsList[index].contactId ?? 0);
                                      getAllContactsProvider.permanentDeleteContacts(context: context, isValue: false);
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
                    "No contact(s) deleted yet",
                    style: w700_15Poppins(color: Colors.blue),
                  ),
                  height5,
                  Text(
                    "Deleted contacts are shown here.",
                    style: w500_15Poppins(color: Theme.of(context).hintColor),
                  ),
                ],
              ),
            );
    }));
  }
}
