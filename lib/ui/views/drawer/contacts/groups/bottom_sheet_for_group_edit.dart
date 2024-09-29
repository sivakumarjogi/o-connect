import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:lottie/lottie.dart';
import 'package:o_connect/core/providers/my_contacts_provider.dart';
import 'package:o_connect/core/screen_configs.dart';
import 'package:o_connect/ui/utils/base_urls.dart';
import 'package:o_connect/ui/utils/buttons_helper/custom_botton.dart';
import 'package:o_connect/ui/utils/colors/colors.dart';
import 'package:o_connect/ui/utils/countrie_flags.dart';
import 'package:o_connect/ui/utils/images/images.dart';
import 'package:o_connect/ui/utils/textfield_helper/app_fonts.dart';
import 'package:o_connect/ui/utils/textfield_helper/common_textfield.dart';
import 'package:provider/provider.dart';
import '../../../../utils/custom_toast_helper/custom_toast.dart';

class GroupBottomSheet extends StatefulWidget {
  const GroupBottomSheet({this.isOpenInCreateGroup = false, Key? key}) : super(key: key);

  final bool isOpenInCreateGroup;

  @override
  State<GroupBottomSheet> createState() => _GroupBottomSheetState();
}

class _GroupBottomSheetState extends State<GroupBottomSheet> {
  final TextEditingController controller = TextEditingController();
  late MyContactsProvider provider;
  Map<String, String>? data;

  @override
  void initState() {
    // TODO: implement initState
    SchedulerBinding.instance.addPostFrameCallback((timeStamp) {
      provider = Provider.of<MyContactsProvider>(context, listen: false);
      provider.getAllContacts(context: context, index: 0);
      provider.createGroupSearchedContacts = [...provider.contactsList];
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<MyContactsProvider>(
      builder: (context, getAllContactsProvider, child) {
        return Container(
          decoration: BoxDecoration(borderRadius: BorderRadius.circular(10.0), color: Theme.of(context).cardColor),
          child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(mainAxisSize: MainAxisSize.min, crossAxisAlignment: CrossAxisAlignment.start, children: [
                height5,
                Center(
                  child: Container(
                    height: 5.h,
                    width: 100.w,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10.r),
                      color: Theme.of(context).primaryColorLight.withOpacity(0.1),
                    ),
                  ),
                ),
                height15,
                Text(
                  "Select Contacts",
                  textAlign: TextAlign.start,
                  style: w400_14Poppins(color: Colors.white),
                ),
                height5,
                const Divider(
                  // color: Colors.white,
                  thickness: 1,
                ),
                height15,
                SizedBox(
                    height: 40.h,
                    child: CommonTextFormField(
                      fillColor: Theme.of(context).cardColor,
                      borderColor: Theme.of(context).primaryColorLight.withOpacity(0.5),
                      controller: controller,
                      suffixIcon: Padding(
                        padding: EdgeInsets.all(8.0.sp),
                        child: SvgPicture.asset(AppImages.searchIcon),
                      ),
                      onChanged: (v) {
                        getAllContactsProvider.contactFilter(v, whileEdit: true);
                        print(v);
                      },
                      hintText: "Search",
                      hintStyle: w400_14Poppins(color: Theme.of(context).hintColor.withOpacity(0.3)),
                    )),
                height10,

                Align(
                    alignment: Alignment.topRight,
                    child: Text("${getAllContactsProvider.selectedContactsList.length}  Contacts Selected",
                        style: w400_14Poppins(color: Theme.of(context).hintColor.withOpacity(0.3)), textAlign: TextAlign.end)),
                height10,

                getAllContactsProvider.contactsLoading
                    ? Center(child: Lottie.asset(AppImages.loadingJson, width: 50.w, height: 50.w))
                    : getAllContactsProvider.createGroupSearchedContacts.isEmpty
                        ? Center(
                            child: Text(
                            "No contacts found",
                            style: w400_14Poppins(color: Theme.of(context).hintColor),
                          ))
                        : SizedBox(
                            height: MediaQuery.of(context).size.width * 0.6,
                            child: ListView.separated(
                              shrinkWrap: true,
                              itemCount: getAllContactsProvider.createGroupSearchedContacts.length,
                              itemBuilder: (context, index) {
                                return Padding(
                                  padding: EdgeInsets.symmetric(horizontal: 8.w),
                                  child: Container(
                                    decoration: BoxDecoration(borderRadius: BorderRadius.circular(5.0.r), color: Theme.of(context).primaryColorLight.withOpacity(0.05)),
                                    child: Row(
                                      children: [
                                        InkWell(
                                          onTap: () {
                                            getAllContactsProvider.updateSelectedContactValue(int.parse(getAllContactsProvider.contactsList[index].contactId.toString()), "add");
                                          },
                                          child: Padding(
                                            padding: EdgeInsets.all(8.0.sp),
                                            child: SizedBox(
                                              height: 40.w,
                                              width: 40.w,
                                              child: getAllContactsProvider.contactsList[index].contactPic == null || getAllContactsProvider.contactsList[index].contactPic == ""
                                                  ? ClipRRect(
                                                      borderRadius: BorderRadius.circular(50.r),
                                                      child: getAllContactsProvider.selectedContactsList.contains(getAllContactsProvider.contactsList[index].contactId)
                                                          ? Stack(
                                                              children: [
                                                                Icon(
                                                                  Icons.person,
                                                                  size: 40.sp,
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
                                                          : Icon(
                                                              Icons.person,
                                                              size: 40.sp,
                                                            ))
                                                  : ClipRRect(
                                                      borderRadius: BorderRadius.circular(50.r),
                                                      child: getAllContactsProvider.selectedContactsList.contains(getAllContactsProvider.contactsList[index].contactId)
                                                          ? Stack(
                                                              children: [
                                                                Image.network(
                                                                  "${BaseUrls.imageUrl}${getAllContactsProvider.contactsList[index].contactPic}",
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
                                                              "${BaseUrls.imageUrl}${getAllContactsProvider.contactsList[index].contactPic}",
                                                              fit: BoxFit.fill,
                                                              height: 40.w,
                                                              width: 40.w,
                                                            ),
                                                    ),
                                            ),
                                          ),
                                        ),
                                        SizedBox(
                                          width: 225.w,
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
                                                style: w400_13Poppins(color: Theme.of(context).hintColor.withOpacity(0.3)),
                                              ),
                                            ],
                                          ),
                                        ),
                                        width10,
                                        Countries(
                                          countriesFlag: getAllContactsProvider.contactsList[index].countryName.toString().substring(0, 2),
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
                            ),
                          ),
                height5,

                /// Row
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 8.sp),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      // const Spacer(),
                      CustomButton(
                        buttonText: "Close",
                        buttonColor: Colors.blue.withOpacity(0.08),
                        // borderColor: Colors.blue,
                        width: ScreenConfig.width * 0.42,
                        onTap: () {
                          widget.isOpenInCreateGroup == false ? Provider.of<MyContactsProvider>(context, listen: false).selectedContactsList.clear() : null;
                          Navigator.pop(context);
                        },
                      ),
                      const SizedBox(
                        width: 5,
                      ),
                      CustomButton(
                        buttonText: "Submit",
                        width: ScreenConfig.width * 0.42,
                        buttonColor: const Color(0xff0E78F9),
                        onTap: () {
                          if (getAllContactsProvider.selectedContactsList.isEmpty) {
                            CustomToast.showErrorToast(msg: "Select at list one contact");
                          } else if (widget.isOpenInCreateGroup == true) {
                            Navigator.pop(context);
                          } else {
                            Navigator.pop(context);
                          }
                        },
                      )
                    ],
                  ),
                )
              ])),
        );
      },
    );
  }
}
