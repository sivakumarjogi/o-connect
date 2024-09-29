import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:o_connect/core/providers/my_contacts_provider.dart';
import 'package:o_connect/ui/utils/colors/colors.dart';
import 'package:o_connect/ui/utils/images/images.dart';
import 'package:o_connect/ui/utils/textfield_helper/app_fonts.dart';
import 'package:provider/provider.dart';

class MyTrashCard extends StatelessWidget {
  const MyTrashCard(
      {required this.alternateEmailId,
      required this.country,
      required this.phoneNumber,
      required this.index,
      required this.contactName,
      required this.contactMail,
      required this.animation,
      required this.favStatus,
      this.onTap,
      this.teamMember,
      Key? key})
      : super(key: key);
  final String contactName;
  final String contactMail;
  final int index;
  final String alternateEmailId;
  final String phoneNumber;
  final String country;
  final Animation<double> animation;
  final VoidCallback? onTap;
  final int favStatus;
  final int? teamMember;

  @override
  Widget build(BuildContext context) {
    return Consumer<MyContactsProvider>(
        builder: (context, myContactsProvider, child) {
      return Container(
          decoration: BoxDecoration(
              color: Theme.of(context).cardColor,
              borderRadius: BorderRadius.circular(10.0)),
          child: Column(
            children: [
              SizedBox(
                child: Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: Row(
                    children: [
                      GestureDetector(
                          onTap: () {
                            if (myContactsProvider.selectedDeleteTabValue ==
                                1) {
                              /// Here Updating Contact List Value
                              myContactsProvider.updateContactListTrash(
                                  contactId: int.parse(myContactsProvider
                                      .contactsList![index].contactId
                                      .toString()));
                            }
                            debugPrint(
                                "Selected Contact List Trash ===>>> ${myContactsProvider.selectedContactFromTrash}");
                            if (myContactsProvider.selectedDeleteTabValue ==
                                2) {
                              /// Here Updating Group List Value
                              myContactsProvider.updateGroupListTrash(
                                  groupId: myContactsProvider
                                      .groupsList[index].groupId);
                              debugPrint(
                                  "Selected Group List Trash ===>>> ${myContactsProvider.selectedGroupFromTrash}");
                            }
                          },
                          child: myContactsProvider.selectedDeleteTabValue == 1
                              ? CircleAvatar(
                                  child: myContactsProvider
                                          .selectedContactFromTrash
                                          .contains(myContactsProvider
                                              .contactsList![index].contactId)
                                      ? SvgPicture.asset(AppImages.tickIconSvg)
                                      : const Icon(Icons.person))
                              : CircleAvatar(
                                  child: myContactsProvider
                                          .selectedGroupFromTrash
                                          .contains(myContactsProvider
                                              .groupsList[index].groupId)
                                      ? SvgPicture.asset(AppImages.tickIconSvg)
                                      : const Icon(Icons.person))),
                      SizedBox(
                        width: 10.w,
                      ),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Text(
                              contactName,
                              style: w400_14Poppins(
                                  color: Theme.of(context).primaryColorLight),
                            ),
                            height5,
                            Visibility(
                                visible:
                                    myContactsProvider.selectedDeleteTabValue ==
                                            2
                                        ? true
                                        : false,
                                child: Text(
                                  "Members: $teamMember",
                                  style: w400_13Poppins(
                                      color: Theme.of(context).disabledColor),
                                )),
                            Visibility(
                              visible:
                                  myContactsProvider.selectedDeleteTabValue == 2
                                      ? false
                                      : true,
                              child: Text(
                                contactMail,
                                style: w400_12Poppins(
                                    color: Theme.of(context).disabledColor),
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(
                        width: 10.0,
                      ),
                    ],
                  ),
                ),
              ),

              /// More Details Container
              // Visibility(
              //     visible: myContactsProvider.selectedIndex == index &&
              //             myContactsProvider.selectedIndexValue != 2
              //         ? true
              //         : ,
              //     child: ExpandedContactCard(
              //       animation: animation,
              //       alternateEmailIdValue: alternateEmailId,
              //       phoneNumberValue: phoneNumber,
              //       country: country,
              //       index: index,
              //     ))
            ],
          ));
    });
  }
}
