import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:lottie/lottie.dart';
import 'package:o_connect/core/common_functions.dart';
import 'package:o_connect/core/models/response_models/create_group_response_model/create_group_response_model.dart';
import 'package:o_connect/ui/utils/base_urls.dart';
import 'package:o_connect/ui/views/pip_views/pip_global_navigation.dart';
import 'package:provider/provider.dart';
import '../../../../../core/providers/my_contacts_provider.dart';
import '../../../../utils/colors/colors.dart';
import '../../../../utils/images/images.dart';
import '../../../../utils/network_image_helpers/cached_image_validation.dart';
import '../../../../utils/textfield_helper/app_fonts.dart';
import '../../../../utils/textfield_helper/common_textfield.dart';
import '../groups/view_group.dart';

class GetAllGroupsView extends StatefulWidget {
  const GetAllGroupsView({super.key, required this.index});

  final int index;

  @override
  State<GetAllGroupsView> createState() => _GetAllGroupsViewState();
}

class _GetAllGroupsViewState extends State<GetAllGroupsView> {
  @override
  void initState() {
    Provider.of<MyContactsProvider>(context, listen: false).getAllContacts(context: context);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<MyContactsProvider>(builder: (context, getAllContactsProvider, child) {
      return Column(
        children: [
          width10,
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 8.h),
            child: SizedBox(
              height: 40.w,
              child: CommonTextFormField(
                fillColor: Theme.of(context).scaffoldBackgroundColor,
                controller: getAllContactsProvider.contactSearchController,
                borderColor: Theme.of(context).primaryColorLight,
                // prefixIcon: Icon(
                //   Icons.search,
                //   color: Theme.of(context).disabledColor,
                // ),
                hintText: "Search",
                suffixIcon: Padding(
                  padding: EdgeInsets.all(8.0.sp),
                  child: SvgPicture.asset(
                    AppImages.searchIcon,
                    // width: 10.w,
                    // height: 10.h,
                  ),
                ),
                hintStyle: w300_14Poppins(color: Theme.of(context).hintColor),
                onChanged: (val) {
                  if (val.length > 1) {
                    getAllContactsProvider.getGroups(context: context, index: widget.index, searchKey: getAllContactsProvider.contactSearchController.text);
                  } else if (val.isEmpty) {
                    getAllContactsProvider.getGroups(context: context, index: widget.index);
                  }
                },
              ),
            ),
          ),
          Expanded(
            child: getAllContactsProvider.groupsContactsList.isEmpty
                ? getAllContactsProvider.contactSearchController.text.isNotEmpty && getAllContactsProvider.groupsContactsList.isEmpty
                    ? Center(
                        child: Text(
                        "No Records Found",
                        style: w400_16Poppins(color: Colors.white),
                      ))
                    : Column(
                        children: [
                          height70,
                          height70,
                          Lottie.asset(AppImages.noGroups, width: 113.w, height: 114.h),
                          height10,
                          Text(
                            "No groups created yet!",
                            style: w700_15Poppins(color: Colors.blue),
                          ),
                          height5,
                          SizedBox(
                            width: 250.w,
                            child: Text(
                              "Click the Create Group button to add a new Group.",
                              maxLines: 2,
                              textAlign: TextAlign.center,
                              style: w500_15Poppins(color: Theme.of(context).hintColor),
                            ),
                          ),
                        ],
                      )
                : ListView.separated(
                    shrinkWrap: true,
                    physics: BouncingScrollPhysics(),
                    padding: EdgeInsets.only(bottom: 50.h),
                    itemCount: getAllContactsProvider.groupsContactsList.length,
                    itemBuilder: (context, index) {
                      return GestureDetector(
                          onTap: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => PIPGlobalNavigation(childWidget: ViewGroup(groupDetails: getAllContactsProvider.groupsContactsList[index], tabIndex: widget.index)),
                                ));
                          },
                          child: GroupsCard(
                            index: index,
                            groupData: getAllContactsProvider.groupsContactsList,
                          ));
                    },
                    separatorBuilder: (context, index) => height10,
                  ),
          ),
        ],
      );
    });
  }
}

class GroupsCard extends StatelessWidget {
  const GroupsCard({super.key, required this.index, required this.groupData});

  final int index;
  final List<CreateGroupResponseModel> groupData;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 8.0.w),
      child: Container(
        decoration: BoxDecoration(borderRadius: BorderRadius.circular(5.0.r), color: Theme.of(context).cardColor),
        child: Row(
          children: [
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 10.0.w, vertical: 10.h),
              child: SizedBox(
                height: 40.w,
                width: 40.w,
                child: checkStringValue(groupData[index].groupPic)
                    ? ClipRRect(
                        borderRadius: BorderRadius.circular(50.r),
                        child: ImageServiceWidget(networkImgUrl: "${BaseUrls.imageUrl}${groupData[index].groupPic}"),
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
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Text(
                    "${groupData[index].groupName}",
                    style: w400_14Poppins(color: Theme.of(context).hintColor),
                  ),
                  height5,
                  Text(
                    "Members : ${groupData[index].contactsCount.toString() ?? "00"}",
                    style: w400_13Poppins(color: Theme.of(context).primaryColorLight),
                  ),
                ],
              ),
            ),
            // Padding(
            //   padding: EdgeInsets.symmetric(horizontal: 10.w),
            //   child: SizedBox(
            //     width: 22.w,
            //     height: 22.w,
            //     child: SvgPicture.asset(
            //       AppImages.mailIcon,
            //       color: Theme.of(context).disabledColor,
            //     ),
            //   ),
            // )
          ],
        ),
      ),
    );
  }
}
