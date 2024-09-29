import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:lottie/lottie.dart';
import 'package:o_connect/core/screen_configs.dart';
import 'package:o_connect/ui/utils/buttons_helper/custom_botton.dart';
import 'package:o_connect/ui/utils/colors/colors.dart';
import 'package:o_connect/ui/utils/constant_strings.dart';
import 'package:o_connect/ui/utils/images/images.dart';
import 'package:o_connect/ui/utils/textfield_helper/app_fonts.dart';
import 'package:o_connect/ui/utils/textfield_helper/common_textfield.dart';
import 'package:o_connect/ui/views/webninar_dashboard/presentation/create_webinar/provider/create_webinar_provider.dart';
import 'package:o_connect/ui/views/webninar_dashboard/presentation/create_webinar/widgets/contacts_tab_widget.dart';
import 'package:o_connect/ui/views/webninar_dashboard/presentation/create_webinar/widgets/groups_tab_widget.dart';
import 'package:oes_chatbot/utils/extensions/sizedbox_extension.dart';
import 'package:provider/provider.dart';

class CreateWebinarContacts extends StatefulWidget {
  const CreateWebinarContacts({super.key});

  @override
  State<CreateWebinarContacts> createState() => _CreateWebinarContactsState();
}

class _CreateWebinarContactsState extends State<CreateWebinarContacts> with TickerProviderStateMixin {
  late TabController _tabController;
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  TextEditingController contactsSearchController = TextEditingController();
  TextEditingController groupsSearchController = TextEditingController();
  ScrollController contactsScrollController = ScrollController();
  ScrollController groupsScrollController = ScrollController();
  ScrollController mainScrollController = ScrollController();

  final outerPhysics = const ClampingScrollPhysics();
  late CreateWebinarProvider createWebinarProvider;

  void innerListener(double velocity, ScrollController outerController) {
    final sim = outerPhysics.createBallisticSimulation(outerController.position, velocity);
    if (sim != null) {
      ScrollActivity test = BallisticScrollActivity(
        outerController.position.activity!.delegate,
        sim,
        this,
        true,
      );

      outerController.position.beginActivity(test);
    }
  }

  @override
  void initState() {
    createWebinarProvider = Provider.of<CreateWebinarProvider>(context, listen: false);
    _tabController = TabController(vsync: this, length: 2);

    _tabController.addListener(() {
      if (_tabController.index == 0) {
        contactsSearchController.text = "";
        createWebinarProvider.localSearchForAllContacts(contactsSearchController.text);
      } else {
        groupsSearchController.text = "";
        createWebinarProvider.localSearchForAllGroups(groupsSearchController.text);
      }
    });
    super.initState();
  }



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: AppBar(
        title: const Text("Contacts"),
      ),
      body: DefaultTabController(
        length: 2,
        child: Form(
          key: _formKey,
          child: SingleChildScrollView(
            child: Column(
              children: [
                Consumer<CreateWebinarProvider>(builder: (_, createWebinar, __) {
                  return Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: SizedBox(
                          height: 40.h,
                          child: Row(
                            children: [
                              Expanded(
                                child: SizedBox(
                                  height: 40.h,
                                  child: CommonTextFormField(
                                      fillColor: Theme.of(context).scaffoldBackgroundColor,
                                      borderColor: Colors.white,
                                      suffixIcon: Icon(
                                        Icons.search,
                                        color: Theme.of(context).primaryColorLight,
                                        size: 25.h,
                                      ),
                                      onChanged: (changed) {
                                        createWebinar.localSearchForAllGroups(changed);
                                        createWebinar.localSearchForAllContacts(changed);
                                      },
                                      hintText: ConstantsStrings.search,
                                      controller: contactsSearchController),
                                ),
                              ),
                              width10,
                              Container(
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
                                        icon: SvgPicture.asset(
                                          AppImages.groupIconSvg,
                                          colorFilter: ColorFilter.mode(_tabController.index != 1 ? Colors.blue : Colors.white, BlendMode.srcIn),
                                          height: 20.w,
                                          width: 20.w,
                                        ),
                                      ),
                                    ],
                                  )),
                            ],
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 630.h,
                        child: TabBarView(controller: _tabController, children: [
                          createWebinar.isContactsLoading
                              ? Lottie.asset(AppImages.loadingJson, width: 40.w, height: 40.w)
                              : ContactsTabWidget(
                                  controller: contactsSearchController,
                                  // scrollController: contactsScrollController,
                                  formKey: _formKey,
                                  // outerController: (vel, isMin) => innerListener(vel, mainScrollController)
                                ),
                          createWebinar.isGroupsLoading
                              ? Center(
                                  child: Lottie.asset(AppImages.loadingJson, height: 40.w, width: 40.w),
                                )
                              : GroupsTabWidget(
                                  context: context,
                                  
                                  controller: groupsSearchController,
                                  // scrollController: groupsScrollController,
                                  // outerController: (vel, isMin) => innerListener(vel, mainScrollController)
                                )
                        ]),
                      ),
                    ],
                  );
                }),
              ],
            ),
          ),
        ),
      ),
      bottomNavigationBar: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          CustomButton(
            buttonColor: const Color(0xff1B2632),
            width: ScreenConfig.width * 0.48,
            onTap: () {
              context.read<CreateWebinarProvider>().resetContactsInivtationDetails();
              Navigator.pop(context);
            },
            buttonText: "Cancel",
          ),
          5.w.width,
          CustomButton(
            width: ScreenConfig.width * 0.48,
            buttonText: "Add",
            onTap: () {
              // if (controller.text.isNotEmpty) {
              //   context.read<PresentationWhiteBoardProvider>().callBacks!.drawText(textToEnter: controller.text.trim());
              // } else {
              //   CustomToast.showErrorToast(msg: "Please enter the text!");
              // }
              Navigator.pop(context);
              print("is selected list file ${context.read<CreateWebinarProvider>().selectedContactsToInvite.toString()}");
            },
          )
        ],
      ),
    );
  }
}
