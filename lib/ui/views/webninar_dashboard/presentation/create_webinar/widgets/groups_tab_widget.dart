import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:o_connect/ui/utils/base_urls.dart';
import 'package:provider/provider.dart';
import '../provider/create_webinar_provider.dart';
import '../../../../../utils/colors/colors.dart';
import '../../../../../utils/images/images.dart';
import '../../../../../utils/textfield_helper/app_fonts.dart';

class GroupsTabWidget extends StatefulWidget {
  const GroupsTabWidget({
    super.key,
    required this.context,
    required this.controller,
    //  required this.scrollController, required this.outerController
  });

  final BuildContext context;

  final TextEditingController controller;

  @override
  State<GroupsTabWidget> createState() => _GroupsTabWidgetState();
}

class _GroupsTabWidgetState extends State<GroupsTabWidget> {
  late CreateWebinarProvider createWebinarProvider;

  @override
  void initState() {
    createWebinarProvider = Provider.of<CreateWebinarProvider>(context, listen: false);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 10.h, horizontal: 10.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          height10,
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              createWebinarProvider.finalUpdatedGroupsRecords.isNotEmpty
                  ? GestureDetector(
                      onTap: () {
                        createWebinarProvider.updateGroupsSelectAll();
                      },
                      child: Row(
                        children: [
                          Checkbox(
                              value: createWebinarProvider.isGroupsSelect,
                              activeColor: Colors.blue,
                              onChanged: (value) {
                                createWebinarProvider.groupsRecords.every((obj) => obj.isCheck == true);
                                createWebinarProvider.updateGroupsSelectAll();
                              }),
                          Text(
                            createWebinarProvider.isGroupsSelect ? "Deselect All" : "Select All",
                            style: w400_14Poppins(color: AppColors.mainBlueColor),
                          ),
                        ],
                      ),
                    )
                  : const SizedBox.shrink(),
              createWebinarProvider.finalUpdatedGroupsRecords.isNotEmpty
                  ? Text(
                      "${createWebinarProvider.selectedGroupsIndexList.length.toString()} contacts selected",
                      style: w500_14Poppins(color: Theme.of(context).primaryColorLight),
                    )
                  : const SizedBox.shrink(),
            ],
          ),
          Expanded(
            child: SizedBox(
              height: 700.h,
              child: createWebinarProvider.finalUpdatedGroupsRecords.isEmpty
                  ? Center(
                      child: Text(
                        "No Records Found",
                        style: w500_14Poppins(color: Theme.of(context).hintColor),
                      ),
                    )
                  : ListView.builder(
                      itemCount: createWebinarProvider.finalUpdatedGroupsRecords.length,
                      physics: BouncingScrollPhysics(
                          // outerController: widget.outerController,
                          ),
                      shrinkWrap: true,
                      itemBuilder: (context, index) {
                        return Padding(
                            padding: EdgeInsets.only(top: 4.h, bottom: 4.h),
                            child: Column(children: [
                              Container(
                                  clipBehavior: Clip.antiAlias,
                                  width: double.infinity,
                                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                                  decoration: ShapeDecoration(
                                    color: Theme.of(context).cardColor,
                                    shape: const RoundedRectangleBorder(
                                      borderRadius: BorderRadius.only(
                                        topLeft: Radius.circular(4),
                                        topRight: Radius.circular(4),
                                      ),
                                    ),
                                  ),
                                  child: Row(mainAxisSize: MainAxisSize.min, mainAxisAlignment: MainAxisAlignment.spaceBetween, crossAxisAlignment: CrossAxisAlignment.center, children: [
                                    Row(mainAxisSize: MainAxisSize.min, mainAxisAlignment: MainAxisAlignment.start, crossAxisAlignment: CrossAxisAlignment.center, children: [
                                      GestureDetector(
                                        onTap: () {
                                          createWebinarProvider.updateGroupsCheckValue(index, groupId: createWebinarProvider.finalUpdatedGroupsRecords[index].groupId);
                                        },
                                        child: !createWebinarProvider.selectedGroupsIndexList.contains(index)
                                            ? (createWebinarProvider.finalUpdatedGroupsRecords[index].groupPic != null && createWebinarProvider.finalUpdatedGroupsRecords[index].groupPic != "")
                                                ? Container(
                                                    width: 50,
                                                    height: 50,
                                                    decoration: ShapeDecoration(
                                                      image: DecorationImage(
                                                        image: NetworkImage("${BaseUrls.imageUrl}${createWebinarProvider.finalUpdatedGroupsRecords[index].groupPic}"),
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
                                      width10,
                                      Column(
                                        mainAxisAlignment: MainAxisAlignment.center,
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          SizedBox(
                                            width: ScreenUtil.defaultSize.width * 0.6,
                                            child: Text(
                                              createWebinarProvider.finalUpdatedGroupsRecords[index].groupName ?? "fdsfsf",
                                              style: w400_14Poppins(color: Theme.of(context).hintColor),
                                              maxLines: 2,
                                              overflow: TextOverflow.ellipsis,
                                            ),
                                          ),
                                          Text(createWebinarProvider.finalUpdatedGroupsRecords[index].contactsCount.toString(), style: w400_12Poppins(color: Theme.of(context).primaryColorLight)),
                                        ],
                                      ),
                                    ]),
                                  ]))
                            ]));
                      }),
            ),
          )
        ],
      ),
    );
  }
}
