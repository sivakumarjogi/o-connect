import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:o_connect/core/screen_configs.dart';
import 'package:o_connect/ui/utils/base_urls.dart';
import 'package:o_connect/ui/utils/countrie_flags.dart';
import 'package:o_connect/ui/utils/images/images.dart';
import 'package:provider/provider.dart';

import '../../../../../utils/colors/colors.dart';
import '../../../../../utils/textfield_helper/app_fonts.dart';
import '../provider/create_webinar_provider.dart';

class ContactsTabWidget extends StatefulWidget {
  const ContactsTabWidget({super.key, required this.controller, required this.formKey});

  final TextEditingController controller;

  final GlobalKey<FormState> formKey;

  @override
  State<ContactsTabWidget> createState() => _ContactsTabWidgetState();
}

class _ContactsTabWidgetState extends State<ContactsTabWidget> {
  late CreateWebinarProvider createWebinarProvider;

  @override
  void initState() {
    createWebinarProvider = Provider.of<CreateWebinarProvider>(context, listen: false);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 5.h, horizontal: 10.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          // !createWebinarProvider.isContactsLoading
          //     ? CommonTextFormField(
          //         fillColor: Theme.of(context).primaryColor,
          //         prefixIcon: Icon(
          //           Icons.search,
          //           color: Theme.of(context).disabledColor,
          //           size: 30.h,
          //         ),
          //         hintText: ConstantsStrings.search,
          //         onChanged: (changed) {
          //           createWebinarProvider.localSearchForAllContacts(changed);
          //         },
          //         controller: widget.controller)
          //     : const SizedBox.shrink(),
          height20,
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              createWebinarProvider.finalUpdatedAllContactsBody.isNotEmpty
                  ? Row(
                    children: [
                      Checkbox(

                          value: createWebinarProvider.isSelect,
                          activeColor: Colors.blue,


                          onChanged: (value) {
                            createWebinarProvider.finalUpdatedAllContactsBody.every((obj) => obj.isCheck == true);
                            createWebinarProvider.updateSelectAll();
                          }



                          ),
                      Text(
                        createWebinarProvider.isSelect || createWebinarProvider.finalUpdatedAllContactsBody.every((obj) => obj.isCheck == true) ? "Deselect All" : "Select All",
                        style: w400_14Poppins(color: AppColors.mainBlueColor),
                      ),
                    ],
                  )
                  : const SizedBox.shrink(),

              //  here is show all con data
              createWebinarProvider.finalUpdatedAllContactsBody.isNotEmpty
                  ? Text(
                      "${createWebinarProvider.selectedContactsIndexList.length} contacts selected",
                      style: w500_14Poppins(color: Theme.of(context).primaryColorLight),
                    )
                  : const SizedBox.shrink(),
            ],
          ),
          Expanded(
            child: SizedBox(
              height: 300.h,
              child: createWebinarProvider.finalUpdatedAllContactsBody.isEmpty
                  ? Center(
                      child: Text(
                        "No Records Found",
                        style: w500_14Poppins(color: Theme.of(context).hintColor),
                      ),
                    )
                  : ListView.builder(
                      itemCount: createWebinarProvider.finalUpdatedAllContactsBody.length,
                      shrinkWrap: true,
                      physics: const BouncingScrollPhysics(),
                      itemBuilder: (context, i) {
                        return Padding(
                          padding: EdgeInsets.all(4.0.sp),
                          child: Container(
                            width: MediaQuery.of(context).size.width,
                            clipBehavior: Clip.antiAlias,
                            decoration: const ShapeDecoration(
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.only(
                                  bottomLeft: Radius.circular(4),
                                  bottomRight: Radius.circular(4),
                                ),
                              ),
                            ),
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Container(
                                  width: double.infinity,
                                  padding: const EdgeInsets.only(left: 10, top: 10, bottom: 10, right: 0),
                                  decoration: ShapeDecoration(
                                    color: Theme.of(context).cardColor,
                                    shape: const RoundedRectangleBorder(
                                      borderRadius: BorderRadius.only(
                                        topLeft: Radius.circular(4),
                                        topRight: Radius.circular(4),
                                      ),
                                    ),
                                  ),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      Row(
                                        // mainAxisSize: MainAxisSize.min,
                                        mainAxisAlignment: MainAxisAlignment.start,
                                        crossAxisAlignment: CrossAxisAlignment.center,
                                        children: [
                                          GestureDetector(
                                            onTap: () {
                                              createWebinarProvider.updateContactsCheckValue(i, contactId: createWebinarProvider.finalUpdatedAllContactsBody[i].contactId);
                                            },
                                            child: Center(
                                              child: (!(createWebinarProvider.selectedContactsIndexList.contains(i)))
                                                  ? (createWebinarProvider.finalUpdatedAllContactsBody[i].contactPic != "" && createWebinarProvider.finalUpdatedAllContactsBody[i].contactPic != null)
                                                      ? Container(
                                                          width: 50,
                                                          height: 50,
                                                          decoration: ShapeDecoration(
                                                            image: DecorationImage(
                                                              image: NetworkImage("${BaseUrls.imageUrl}${createWebinarProvider.finalUpdatedAllContactsBody[i].contactPic}"),
                                                              fit: BoxFit.fill,
                                                            ),
                                                            shape: RoundedRectangleBorder(
                                                              borderRadius: BorderRadius.circular(100),
                                                            ),
                                                          ),
                                                        )
                                                      : ClipRRect(
                                                          borderRadius: BorderRadius.circular(100),
                                                          child: SvgPicture.asset(
                                                            AppImages.dummyProfileSvg,
                                                            width: 50,
                                                            height: 50,
                                                          ),
                                                        )
                                                  : Container(
                                                      alignment: Alignment.center,
                                                      width: 50,
                                                      height: 50,
                                                      decoration: BoxDecoration(color: const Color.fromRGBO(29, 155, 240, 0.8), borderRadius: BorderRadius.circular(30)),
                                                      child: const Icon(
                                                        Icons.check,
                                                        color: AppColors.whiteColor,
                                                      ),
                                                    ),
                                            ),
                                          ),
                                          width10,
                                          Column(
                                            mainAxisSize: MainAxisSize.min,
                                            mainAxisAlignment: MainAxisAlignment.center,
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            children: [
                                              SizedBox(
                                                width: ScreenConfig.width - 200.w,
                                                child: Text(
                                                  "${createWebinarProvider.finalUpdatedAllContactsBody[i].firstName ?? ""} ${createWebinarProvider.finalUpdatedAllContactsBody[i].lastName ?? ""}",
                                                  style: w400_14Poppins(color: Theme.of(context).primaryColorLight),
                                                  maxLines: 2,
                                                  overflow: TextOverflow.ellipsis,
                                                ),
                                              ),
                                              SizedBox(height: 3.h),
                                              SizedBox(
                                                width: ScreenConfig.width * 0.52,
                                                child: Text(createWebinarProvider.finalUpdatedAllContactsBody[i].alternateEmailId ?? "",
                                                    overflow: TextOverflow.ellipsis, style: w400_12Poppins(color: AppColors.mainBlueColor)),
                                              ),
                                              SizedBox(height: 3.h),
                                              // Text(createWebinarProvider.finalUpdatedAllContactsBody[i].countryName ?? "", style: w400_12Poppins(color: Theme.of(context).disabledColor)),
                                            ],
                                          ),
                                        ],
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: Countries(
                                          countriesFlag: createWebinarProvider.finalUpdatedAllContactsBody[i].countryName.toString().substring(0, 2),
                                        ),
                                      ),
                                      // createWebinarProvider.selectedWebinarType == 0
                                      //     ? PopupMenuButton(
                                      //         padding: const EdgeInsets.all(0.0),
                                      //         shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5.r)),
                                      //         elevation: 0,
                                      //         onSelected: (value) {
                                      //           createWebinarProvider.updateContactsSelectedParticipants(createWebinarProvider.finalUpdatedAllContactsBody[i], value);
                                      //         },
                                      //         icon: Icon(
                                      //           Icons.more_vert_outlined,
                                      //           color: Theme.of(context).primaryColorLight,
                                      //         ),
                                      //         itemBuilder: (BuildContext bc) {
                                      //           return [
                                      //             PopupMenuItem(
                                      //               value: 4,

                                      //               ///Guest in web used roleId 4
                                      //               child: Text(
                                      //                 "speaker",
                                      //                 style: w400_15Poppins(color: Theme.of(context).primaryColorLight),
                                      //               ),
                                      //             ),
                                      //             PopupMenuItem(
                                      //               value: 3,

                                      //               ///Guest in web used roleId 3
                                      //               child: Text(
                                      //                 "Attendee",
                                      //                 style: w400_15Poppins(color: Theme.of(context).primaryColorLight),
                                      //               ),
                                      //             ),
                                      //           ];
                                      //         },
                                      //       )
                                      //     : Container()
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        );
                      }),
            ),
          )
        ],
      ),
    );
  }
}
