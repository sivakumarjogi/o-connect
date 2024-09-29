import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:o_connect/core/providers/my_contacts_provider.dart';
import 'package:provider/provider.dart';
import '../../../../../core/screen_configs.dart';
import '../../../../utils/colors/colors.dart';
import '../../../../utils/custom_show_dialog_helper/custom_show_dialog.dart';
import '../../../../utils/images/images.dart';
import '../../../../utils/textfield_helper/app_fonts.dart';
import '../../../../utils/textfield_helper/common_textfield.dart';
import '../../../delete_bottom_sheet.dart';
import '../contact_trash/contact_trash.dart';
import '../contact_trash/group_tarsh.dart';

class GetAllTrashContactList extends StatefulWidget {
  const GetAllTrashContactList({super.key, required this.index});

  final int index;

  @override
  State<GetAllTrashContactList> createState() => _GetAllTrashContactList();
}

class _GetAllTrashContactList extends State<GetAllTrashContactList> with TickerProviderStateMixin {
  late TabController _tabController;
  MyContactsProvider? myContactsProvider;

  @override
  void initState() {
    // TODO: implement initState
    myContactsProvider = Provider.of<MyContactsProvider>(context, listen: false);
    _tabController = TabController(vsync: this, length: 2, initialIndex: 0);
    myContactsProvider?.selectedContactFromTrash = [];
    myContactsProvider?.selectedGroupFromTrash = [];
    _tabController.addListener(() {
      print(_tabController.index);
      myContactsProvider?.contactSearchController.text = "";
      if (_tabController.index == 0) {
        myContactsProvider?.selectedContactFromTrash = [];

        myContactsProvider?.groupContactList = [];
        myContactsProvider?.updateSelectedDeleteTabValue(0);
        myContactsProvider?.getAllContacts(context: context, index: widget.index);
      } else {
        myContactsProvider?.contactsList = [];
        myContactsProvider?.selectedGroupFromTrash = [];
        myContactsProvider?.updateSelectedDeleteTabValue(1);
        myContactsProvider?.getIndexData(context, 4);
      }
    });

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Consumer<MyContactsProvider>(builder: (context, getAllContactsProvider, child) {
        return Stack(
          children: [
            Padding(
              padding: EdgeInsets.only(bottom: (myContactsProvider!.selectedContactFromTrash.isNotEmpty || myContactsProvider!.selectedGroupFromTrash.isNotEmpty) ? 50.h : 0),
              child: Column(
                children: [
                  SizedBox(
                    height: 60.h,
                    child: Row(
                      children: [
                        Expanded(
                          child: Padding(
                            padding:  EdgeInsets.only(left: 10.w),
                            child: SizedBox(
                              height: 40.h,
                              child: CommonTextFormField(
                                fillColor: Theme.of(context).scaffoldBackgroundColor,
                                borderColor: Theme.of(context).hintColor,
                                controller: getAllContactsProvider.contactSearchController,
                                // prefixIcon: Icon(
                                //   Icons.search,
                                //   color: Theme.of(context).disabledColor,
                                // ),
                                suffixIcon: Padding(
                                  padding: EdgeInsets.all(8.0.sp),
                                  child: SvgPicture.asset(AppImages.searchIcon),
                                ),
                                hintText: "Search",
                                hintStyle: w300_14Poppins(color: Theme.of(context).hintColor.withOpacity(0.3)),
                                onChanged: (val) {
                                  if (val.length > 2) {
                                    if (_tabController.index == 0) {
                                      getAllContactsProvider.getAllContacts(context: context, index: widget.index, searchKey: getAllContactsProvider.contactSearchController.text);
                                    } else {
                                      getAllContactsProvider.getGroups(context: context, index: widget.index, searchKey: getAllContactsProvider.contactSearchController.text);
                                    }
                                  } else if (val.isEmpty) {
                                    if (_tabController.index == 1) {
                                      getAllContactsProvider.getGroups(
                                        context: context,
                                        index: widget.index,
                                      );
                                    } else {
                                      getAllContactsProvider.getAllContacts(
                                        context: context,
                                        index: widget.index,
                                      );
                                    }
                                  }
                                },
                              ),
                            ),
                          ),
                        ),
                        width10,
                        Padding(
                          padding:  EdgeInsets.only(right: 10.w),
                          child: Container(
                              width: 100.w,
                              height: 40.h,
                              decoration: BoxDecoration(color: Theme.of(context).cardColor, borderRadius: BorderRadius.circular(5.r)),
                              child: TabBar(
                                indicatorColor: Colors.red,
                                unselectedLabelStyle: w400_12Poppins(color: Theme.of(context).hintColor),
                                unselectedLabelColor: Theme.of(context).hintColor,
                                controller: _tabController,
                                indicatorSize: TabBarIndicatorSize.tab,
                                indicator: BoxDecoration(
                                    borderRadius: BorderRadius.only(
                                      topLeft: _tabController.index != 0 ? Radius.zero : Radius.circular(5.0.r),
                                      bottomLeft: _tabController.index != 0 ? Radius.zero : Radius.circular(5.0.r),
                                      topRight: _tabController.index == 0 ? Radius.zero : Radius.circular(5.0.r),
                                      bottomRight: _tabController.index == 0 ? Radius.zero : Radius.circular(5.0.r),
                                    ),
                                    color: Colors.blue),
                                tabs: [
                                  Tab(
                                    icon: SvgPicture.asset(
                                      AppImages.contactsIcon,
                                      colorFilter: ColorFilter.mode(_tabController.index != 0 ? Colors.blue : Colors.white, BlendMode.srcIn),
                                      height: 20.w,
                                      width: 20.w,
                                    ),
                                  ),
                                  Tab(
                                      icon: Icon(
                                    Icons.groups,
                                    color: _tabController.index != 1 ? Colors.blue : Colors.white,
                                  )
                                      //  SvgPicture.asset(
                                      //   AppImages.groupIconSvg,
                                      //   colorFilter: ColorFilter.mode(_tabController.index != 1 ? Colors.blue : Colors.white, BlendMode.srcIn),
                                      //   height: 20.w,
                                      //   width: 20.w,
                                      // ),
                                      ),
                                ],
                              )),
                        ),
                      ],
                    ),
                  ),
                  Expanded(
                    child: TabBarView(physics: const ClampingScrollPhysics(), controller: _tabController, children: [
                      TrashContacts(index: widget.index ?? 0),
                      TrashGroups(index: widget.index ?? 0),
                    ]),
                  ),
                ],
              ),
            ),
            (_tabController.index == 0 && myContactsProvider!.selectedContactFromTrash.isNotEmpty) || (_tabController.index == 1 && myContactsProvider!.selectedGroupFromTrash.isNotEmpty)
                ? Align(
                    alignment: Alignment.bottomCenter,
                    child: Container(
                      width: MediaQuery.of(context).size.width,
                      height: 50.h,
                      padding: EdgeInsets.only(top: 10.h),
                      color: Theme.of(context).scaffoldBackgroundColor,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          GestureDetector(
                            onTap: () {
                              _tabController.index == 1
                                  ? customShowDialog(
                                      context,
                                      DeleteBottomSheet(
                                        headerTitle: "Restore",
                                        title: "Do you want to restore this Group?",
                                        body: "",
                                        onTap: () async {
                                          myContactsProvider?.deleteGroup(groupId: myContactsProvider?.selectedGroupFromTrash, context: context, isViewGroup: false);
                                        },
                                      ))
                                  : customShowDialog(
                                      context,
                                      DeleteBottomSheet(
                                        headerTitle: "Restore",
                                        title: "Do you want to restore this Contact?",
                                        body: "",
                                        onTap: () async {
                                          myContactsProvider?.deleteAllContacts(
                                            isViewContact: true,
                                            context: context,
                                            contactId: myContactsProvider?.selectedContactFromTrash,
                                          );
                                        },
                                      ));
                            },
                            child: Container(
                              height: 35.h,
                              width: ScreenConfig.width * 0.45,
                              decoration: BoxDecoration(
                                color: Theme.of(context).scaffoldBackgroundColor,
                                borderRadius: BorderRadius.circular(5.r),
                                border: Border.all(color: Colors.blue),
                              ),
                              child: Center(
                                child: Text(
                                  "Restore",
                                  style: w400_14Poppins(color: Theme.of(context).hintColor),
                                ),
                              ),
                            ),
                          ),
                          GestureDetector(
                            onTap: () {
                              _tabController.index == 0
                                  ? customShowDialog(
                                      context,
                                      DeleteBottomSheet(
                                        headerTitle: "Delete",
                                        title: "Do you want to delete this Contact?",
                                        body: "",
                                        onTap: () async {
                                          myContactsProvider?.permanentDeleteContacts(context: context, isValue: false);
                                        },
                                      ))
                                  : customShowDialog(
                                      context,
                                      DeleteBottomSheet(
                                        headerTitle: "Delete",
                                        title: "Do you want to delete this Group?",
                                        body: "",
                                        onTap: () async {
                                          myContactsProvider?.permanentDeleteGroups(
                                            context: context,
                                            selectedContactFromTrash: myContactsProvider?.selectedGroupFromTrash,
                                          );
                                        },
                                      ));
                            },
                            child: Container(
                              height: 35.h,
                              width: ScreenConfig.width * 0.45,
                              decoration: BoxDecoration(
                                color: Colors.blue,
                                borderRadius: BorderRadius.circular(5.r),
                                border: Border.all(color: Colors.transparent),
                              ),
                              child: Center(
                                child: Text(
                                  "Delete",
                                  style: w400_14Poppins(color: Theme.of(context).hintColor),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  )
                : const SizedBox.shrink()
          ],
        );
      }),
    );
  }
}
