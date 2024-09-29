import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:lottie/lottie.dart';
import 'package:o_connect/core/providers/my_contacts_provider.dart';
import 'package:o_connect/ui/utils/base_urls.dart';
import 'package:o_connect/ui/utils/buttons_helper/custom_botton.dart';
import 'package:o_connect/ui/utils/colors/colors.dart';
import 'package:o_connect/ui/utils/custom_toast_helper/custom_toast.dart';
import 'package:o_connect/ui/utils/images/images.dart';
import 'package:o_connect/ui/utils/textfield_helper/common_textfield.dart';
import 'package:o_connect/ui/views/drawer/contacts/groups/create_group.dart';
import 'package:o_connect/ui/views/pip_views/pip_global_navigation.dart';
import 'package:provider/provider.dart';

import '../../../../utils/textfield_helper/app_fonts.dart';

class SelectContactForCreatingGroupBottomSheet extends StatefulWidget {
  const SelectContactForCreatingGroupBottomSheet({this.isOpenInCreateGroup = false, Key? key, required this.className}) : super(key: key);
  final String className;
  final bool isOpenInCreateGroup;

  @override
  State<SelectContactForCreatingGroupBottomSheet> createState() => _SelectContactForCreatingGroupBottomSheetState();
}

class _SelectContactForCreatingGroupBottomSheetState extends State<SelectContactForCreatingGroupBottomSheet> {
  final TextEditingController controller = TextEditingController();
  late MyContactsProvider provider;
  Map<String, String>? data;

  @override
  void initState() {
    // TODO: implement initState
    SchedulerBinding.instance.addPostFrameCallback((timeStamp) {
      provider = Provider.of<MyContactsProvider>(context, listen: false);
      if (widget.isOpenInCreateGroup != true) {
        provider.selectedContactsList = [];
        provider.createGroupSearchedContacts = [...provider.contactsList];
      }
      provider.getAllContacts(context: context);
    });

    super.initState();
  }

  // groupContactListId

  @override
  Widget build(BuildContext context) {
    return Consumer<MyContactsProvider>(
      builder: (context, getAllContactsProvider, child) {
        return Container(
          decoration: BoxDecoration(borderRadius: BorderRadius.circular(10.0.r)),
          child: Padding(
              padding: EdgeInsets.all(8.0.sp),
              child: Column(mainAxisSize: MainAxisSize.min, crossAxisAlignment: CrossAxisAlignment.start, children: [
                height5,
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 8.0.w, vertical: 5.h),
                  child: Text(
                    "Select Contact",
                    textAlign: TextAlign.start,
                    style: w400_16Poppins(color: Colors.white),
                  ),
                ),
                Divider(
                  color: Theme.of(context).primaryColorLight,
                  thickness: 0.3,
                ),
                height5,
                SizedBox(
                    height: 40.h,
                    child: CommonTextFormField(
                      fillColor: Theme.of(context).scaffoldBackgroundColor,
                      controller: controller,
                      suffixIcon: Padding(
                        padding: EdgeInsets.all(5.0.sp),
                        child: SvgPicture.asset(AppImages.searchIcon),
                      ),
                      hintText: "Search by name",
                      onChanged: (val) {
                        getAllContactsProvider.contactFilter(val);
                        // if (val.length > 2) {
                        //   getAllContactsProvider.getAllContacts(context: context, searchKey: controller.text);
                        // } else if (val.isEmpty) {
                        //   getAllContactsProvider.getAllContacts(
                        //     context: context,
                        //   );
                        // }
                      },
                    )),
                height10,
                Align(
                    alignment: Alignment.topRight,
                    child: Text("${getAllContactsProvider.selectedContactsList.length} Contacts Selected",
                        style: w400_14Poppins(color: Theme.of(context).hintColor.withOpacity(0.5)), textAlign: TextAlign.end)),
                height10,
                getAllContactsProvider.contactsLoading
                    ? Center(child: Lottie.asset(AppImages.loadingJson, width: 50.w, height: 50.w))
                    : SizedBox(
                        height: MediaQuery.of(context).size.width * 0.6,
                        child: getAllContactsProvider.createGroupSearchedContacts.isNotEmpty
                            ? ListView.separated(
                                shrinkWrap: true,
                                itemCount: getAllContactsProvider.createGroupSearchedContacts.length,
                                itemBuilder: (context, index) {
                                  return Padding(
                                    padding: EdgeInsets.symmetric(horizontal: 8.w),
                                    child: Container(
                                      decoration: BoxDecoration(borderRadius: BorderRadius.circular(5.0.r), color: Theme.of(context).primaryColor),
                                      child: Row(
                                        children: [
                                          InkWell(
                                            onTap: () {
                                              getAllContactsProvider.updateSelectedContactValue(
                                                  int.parse(getAllContactsProvider.createGroupSearchedContacts[index].contactId.toString()), widget.className);
                                            },
                                            child: Padding(
                                              padding: EdgeInsets.all(8.0.sp),
                                              child: SizedBox(
                                                height: 40.w,
                                                width: 40.w,
                                                child: getAllContactsProvider.createGroupSearchedContacts[index].contactPic == null ||
                                                        getAllContactsProvider.createGroupSearchedContacts[index].contactPic == ""
                                                    ? ClipRRect(
                                                        borderRadius: BorderRadius.circular(50.r),
                                                        child: getAllContactsProvider.selectedContactsList.contains(getAllContactsProvider.createGroupSearchedContacts[index].contactId)
                                                            ? Stack(
                                                                children: [
                                                                  ClipRRect(
                                                                      borderRadius: BorderRadius.circular(50.r),
                                                                      child: SvgPicture.asset(
                                                                        AppImages.dummyProfileSvg,
                                                                        width: 50.w,
                                                                        height: 50.w,
                                                                      )),
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
                                                            : ClipRRect(
                                                                borderRadius: BorderRadius.circular(50.r),
                                                                child: SvgPicture.asset(
                                                                  AppImages.dummyProfileSvg,
                                                                  width: 50.w,
                                                                  height: 50.w,
                                                                )))
                                                    : ClipRRect(
                                                        borderRadius: BorderRadius.circular(50.r),
                                                        child: getAllContactsProvider.selectedContactsList.contains(getAllContactsProvider.createGroupSearchedContacts[index].contactId)
                                                            ? Stack(
                                                                children: [
                                                                  Image.network(
                                                                    "${BaseUrls.imageUrl}${getAllContactsProvider.createGroupSearchedContacts[index].contactPic}",
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
                                                            : Image.network(
                                                                "${BaseUrls.imageUrl}${getAllContactsProvider.createGroupSearchedContacts[index].contactPic}",
                                                                fit: BoxFit.fill,
                                                                height: 40.w,
                                                                width: 40.w,
                                                              ),
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
                                                  "${getAllContactsProvider.createGroupSearchedContacts[index].firstName} ${getAllContactsProvider.contactsList[index].lastName}",
                                                  style: w400_14Poppins(color: Theme.of(context).hintColor),
                                                ),
                                                height5,
                                                Text(
                                                  getAllContactsProvider.createGroupSearchedContacts[index].alternateEmailId.toString() ?? "test@gmail.com",
                                                  style: w400_13Poppins(color: Theme.of(context).hintColor.withOpacity(0.5)),
                                                ),
                                              ],
                                            ),
                                          ),
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
                                child: Text(
                                "No contacts found",
                                style: w400_14Poppins(color: Theme.of(context).hintColor),
                              )),
                      ),
                height5,
                Row(
                  children: [
                    const Spacer(),
                    CustomButton(
                      buttonText: "Cancel",
                      buttonColor: Theme.of(context).cardColor,
                      borderColor: Colors.blue,
                      width: 100,
                      onTap: () {
                        getAllContactsProvider.cancelSelectedContactValue();

                        widget.isOpenInCreateGroup == false ? getAllContactsProvider.selectedContactsList.clear() : null;
                        Navigator.pop(context);
                      },
                    ),
                    width10,
                    CustomButton(
                      buttonText: widget.isOpenInCreateGroup == true ? "Add" : "Submit",
                      width: 100,
                      onTap: () {
                        if (getAllContactsProvider.selectedContactsList.isEmpty) {
                          CustomToast.showErrorToast(msg: "Select at list one contact");
                        } else if (widget.isOpenInCreateGroup == true) {
                          Navigator.pop(context);
                        } else {
                          Navigator.pop(context);
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => PIPGlobalNavigation(
                                          childWidget: CreateGroup(
                                        contactIds: getAllContactsProvider.selectedContactsList,
                                      ))));
                        }
                      },
                    )
                  ],
                )
              ])),
        );
      },
    );
  }
}
