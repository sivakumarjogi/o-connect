import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:o_connect/core/providers/my_contacts_provider.dart';
import 'package:o_connect/core/screen_configs.dart';
import 'package:o_connect/ui/utils/base_urls.dart';
import 'package:o_connect/ui/utils/colors/colors.dart';
import 'package:o_connect/ui/utils/common_app_bar/all_products.dart';
import 'package:o_connect/ui/utils/common_app_bar/common_appbar.dart';
import 'package:o_connect/ui/utils/common_app_bar/notifications.dart';
import 'package:o_connect/ui/utils/custom_show_dialog_helper/custom_show_dialog.dart';
import 'package:o_connect/ui/utils/network_image_helpers/cached_image_validation.dart';
import 'package:o_connect/ui/utils/textfield_helper/app_fonts.dart';
import 'package:o_connect/ui/views/authentication/Auth_providers/auth_api_provider.dart';
import 'package:o_connect/ui/views/drawer/contacts/create_contact/add_contact.dart';
import 'package:o_connect/ui/views/drawer/contacts/groups/select_contact_for_creating_group.dart';
import 'package:o_connect/ui/views/drawer/custom_drawer_view.dart';
import 'package:o_connect/ui/views/drawer/drawer_viewmodel.dart';
import 'package:o_connect/ui/views/pip_views/pip_global_navigation.dart';
import 'package:o_connect/ui/views/profile_screen/profile_view/profile_page.dart';
import 'package:oes_chatbot/utils/extensions/sizedbox_extension.dart';
import 'package:provider/provider.dart';
import '../../../utils/constant_strings.dart';
import '../../../utils/images/images.dart';
import 'get_all_contacts/get_all_contact.dart';
import 'get_all_contacts/get_all_favourite.dart';
import 'get_all_contacts/get_all_groups.dart';
import 'get_all_contacts/get_all_trash_contact.dart';

class AllContactsPage extends StatefulWidget {
  const AllContactsPage({super.key, this.groupBool = false});

  final bool groupBool;

  @override
  State<AllContactsPage> createState() => _AllContactsPageState();
}

class _AllContactsPageState extends State<AllContactsPage> with TickerProviderStateMixin {
  final TextEditingController contactSearchController = TextEditingController();

  late AnimationController _controller;

  int selectedContactsIndex = -1;
  late TabController _tabController;
  int selectedIndexValue = 0;

  late MyContactsProvider myContactsProvider;

  @override
  void initState() {
    _tabController = TabController(
      initialIndex: widget.groupBool ? 2 : 0,
      length: 4,
      vsync: this,
    );
    myContactsProvider = Provider.of<MyContactsProvider>(context, listen: false);

    SchedulerBinding.instance.addPostFrameCallback((timeStamp) {
      myContactsProvider.getAllContacts(context: context);
    });

    myContactsProvider.getCountries();

    _controller = AnimationController(
      duration: const Duration(seconds: 1),
      vsync: this,
    );
    myContactsProvider.animation = CurvedAnimation(
      parent: _controller,
      curve: Curves.fastLinearToSlowEaseIn,
    );
    _tabController.addListener(() {
      myContactsProvider.contactSearchController.text = "";
      myContactsProvider.getIndexData(context, _tabController.index);
      if (_tabController.index == 3) {
        myContactsProvider.updateSelectedDeleteTabValue(0);
      }
      if (_tabController.index == 0) {
        myContactsProvider.selectedValue = ConstantsStrings.all;
      } else if (_tabController.index == 1) {
        myContactsProvider.selectedValue = ConstantsStrings.all;
      }
    });
    super.initState();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<MyContactsProvider>(
      builder: (context, myContactsProvider, child) {
        return WillPopScope(
          onWillPop: () async {
            Provider.of<DrawerViewModel>(context, listen: false).mainSelectedChange(ConstantsStrings.home);
            return true;
          },
          child: SafeArea(
            child: Scaffold(
              appBar: AppBar(
                backgroundColor: Theme.of(context).cardColor,
                leading: IconButton(
                    onPressed: () {
                      Navigator.pop(context);
                      myContactsProvider.searchValue == true ? myContactsProvider.searchBoxEnableDisable() : myContactsProvider.searchValue = false;
                    },
                    icon: Icon(
                      Icons.chevron_left_outlined,
                      color: Theme.of(context).primaryColorLight,
                    )),
                title: Text(
                  "Contacts",
                  style: w400_14Poppins(color: Theme.of(context).hintColor.withOpacity(0.8)),
                ),
                actions: [
                  GestureDetector(
                      onTap: () {
                        // CustomToast.showInfoToast(msg: "Coming Soon...");

                        // customShowDialog(context, const NotificationScreen());
                        Navigator.push(context, MaterialPageRoute(builder: (context) => const PIPGlobalNavigation(childWidget: NotificationsScreen())));
                      },
                      child: Padding(
                        padding: EdgeInsets.symmetric(horizontal: 5.w),
                        child: Stack(
                          children: [
                            // Positioned(
                            //     left: 10,
                            //     child: Container(
                            //       height: 10.h,
                            //       width: 10.w,
                            //       decoration: BoxDecoration(shape: BoxShape.circle, color: Colors.red),
                            //     )),
                            SvgPicture.asset(
                              AppImages.notificationIcon,
                              height: 20.w,
                              width: 20.w,
                            ),
                          ],
                        ),
                      )),
                  5.w.width,
                  GestureDetector(
                      onTap: () {
                        // CustomToast.showInfoToast(msg: "Coming Soon...");
                        // customShowDialog(context, const AllproductsScreen(),
                        //     height: MediaQuery.of(context).size.height * 0.7);
                        Navigator.push(context, MaterialPageRoute(builder: (context) => const PIPGlobalNavigation(childWidget: AllProductsScreen())));
                      },
                      child: Padding(
                        padding: EdgeInsets.symmetric(horizontal: 5.w),
                        child: SvgPicture.asset(
                          AppImages.categoryIcon,
                          height: 22.w,
                          width: 22.w,
                        ),
                      )),
                  5.w.width,
                  Consumer<AuthApiProvider>(builder: (context, authProvider, child) {
                    return GestureDetector(
                      child: Padding(
                        padding: EdgeInsets.symmetric(horizontal: 5.w, vertical: 12.h),
                        child: Container(
                          decoration: BoxDecoration(
                            border: Border.all(color: Colors.white24),
                            borderRadius: BorderRadius.circular(50.r),
                          ),
                          height: 25.h,
                          width: 25.w,
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(50.r),
                            child: ImageServiceWidget(networkImgUrl: "${BaseUrls.imageUrl}${authProvider.profileData?.data!.profilePic}"),
                          ),
                        ),
                      ),
                      onTap: () {
                        Navigator.push(context, MaterialPageRoute(builder: (context) => const ProfilePage()));
                      },
                    );
                  })
                ],
              ),
              floatingActionButton: Visibility(
                  visible: _tabController.index == 3 ? false : true,
                  child: Padding(
                    padding: EdgeInsets.fromLTRB(0, 0, 20.w, 40.h),
                    child: FloatingActionButton(
                        backgroundColor: const Color(0xff0E78F9),
                        elevation: 0,
                        shape: const CircleBorder(),
                        onPressed: () async {
                          myContactsProvider.searchValue == true ? myContactsProvider.searchBoxEnableDisable() : myContactsProvider.searchValue = false;

                          if (_tabController.index == 2) {
                            customShowDialog(
                                context,
                                const SelectContactForCreatingGroupBottomSheet(
                                  className: "add",
                                ));
                          } else {
                            var res = await Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => const PIPGlobalNavigation(
                                          childWidget: AddContactPage(),
                                        )));
                            if (res != null && res == true) {
                              if (!mounted) return;
                              myContactsProvider.getAllContacts(context: context);
                            }
                          }
                        },
                        child: const Icon(
                          Icons.add,
                          color: Colors.white,
                        )
                        //  _tabController.index == 2
                        //     ? SvgPicture.asset(
                        //         AppImages.addGroupIcon,
                        //         color: Colors.white,
                        //       )
                        //     : const Icon(
                        //         Icons.add,
                        //         color: Colors.white,
                        //       )
                        ),
                  )),
              backgroundColor: Theme.of(context).scaffoldBackgroundColor,
              drawerEnableOpenDragGesture: false,
              // appBar: commonAppBar(context, titleName: "My Contacts"),
              resizeToAvoidBottomInset: false,
              drawer: const CustomDrawerView(),
              body: Scaffold(
                body: Column(
                  children: [
                    height10,
                    Padding(
                      padding: EdgeInsets.only(
                        left: 10.w,
                        right: 10.w,
                      ),
                      child: Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10.r),
                          color: Theme.of(context).cardColor, // Background color of the container
                        ),
                        child: TabBar(
                            onTap: (value) {
                              myContactsProvider.searchValue == true ? myContactsProvider.searchBoxEnableDisable() : myContactsProvider.searchValue = false;
                            },
                            // indicator: const BoxDecoration(),
                            // labelPadding: const EdgeInsets.symmetric(vertical: 0), // Set vertical padding for the label
                            indicatorPadding: EdgeInsets.symmetric(vertical: 5.h, horizontal: 5.w),
                            indicatorWeight: 4,
                            indicatorSize: TabBarIndicatorSize.tab,
                            labelColor: Colors.white,
                            indicatorColor: Theme.of(context).splashColor,
                            dividerColor: Colors.transparent,
                            indicator: BoxDecoration(
                                border: const Border(
                                  bottom: BorderSide(width: 1, color: Color(0xff0E78F9)), // Thickness and color of the border
                                ),
                                borderRadius: BorderRadius.circular(8.r), // Creates border
                                color: const Color(0xff0E78F9)),
                            unselectedLabelColor: Theme.of(context).primaryColorLight.withOpacity(0.5),
                            controller: _tabController,
                            labelStyle: w500_10Poppins(),
                            labelPadding: EdgeInsets.zero,
                            tabs: [
                              Tab(
                                icon: SvgPicture.asset(
                                  AppImages.allContactsIcon,
                                  color: _tabController.index != 0 ? Theme.of(context).primaryColorLight.withOpacity(0.5) : Colors.white,
                                  width: 26.w,
                                  height: 26.w,
                                ),
                                text: "All Contacts",
                              ),
                              Tab(
                                icon: SvgPicture.asset(
                                  AppImages.favoriteIcon,
                                  color: _tabController.index != 1 ? Theme.of(context).primaryColorLight.withOpacity(0.5) : Colors.white,
                                  width: 26.w,
                                  height: 26.w,
                                ),
                                text: "Favourites",
                              ),
                              Tab(
                                icon: SvgPicture.asset(
                                  AppImages.groupsIcon,
                                  color: _tabController.index != 2 ? Theme.of(context).primaryColorLight.withOpacity(0.5) : Colors.white,
                                  width: 26.w,
                                  height: 26.w,
                                ),
                                text: "Groups",
                              ),
                              Tab(
                                icon: SvgPicture.asset(
                                  AppImages.trashIcon,
                                  color: _tabController.index != 3 ? Theme.of(context).primaryColorLight.withOpacity(0.5) : Colors.white,
                                  width: 26.w,
                                  height: 26.w,
                                ),
                                text: "Trash",
                              ),
                            ]),
                      ),
                    ),
                    Flexible(
                      child: TabBarView(
                        physics: const NeverScrollableScrollPhysics(),
                        controller: _tabController,
                        children: [
                          GetAllContactList(index: _tabController.index),
                          GetAllFavouriteContactList(index: _tabController.index),
                          GetAllGroupsView(index: _tabController.index),
                          GetAllTrashContactList(index: _tabController.index)
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
