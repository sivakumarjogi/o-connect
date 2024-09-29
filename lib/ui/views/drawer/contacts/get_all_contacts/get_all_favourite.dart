import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:lottie/lottie.dart';
import 'package:o_connect/core/providers/my_contacts_provider.dart';
import 'package:o_connect/ui/utils/base_urls.dart';
import 'package:o_connect/ui/utils/countrie_flags.dart';
import 'package:o_connect/ui/views/pip_views/pip_global_navigation.dart';
import 'package:provider/provider.dart';
import '../../../../utils/colors/colors.dart';
import '../../../../utils/images/images.dart';
import '../../../../utils/textfield_helper/app_fonts.dart';
import '../create_contact/view_contact_screen.dart';
import 'get_all_contact.dart';

class GetAllFavouriteContactList extends StatefulWidget {
  const GetAllFavouriteContactList({
    super.key,
    required this.index,
  });

  final int index;

  @override
  State<GetAllFavouriteContactList> createState() => _GetAllFavouriteContactListState();
}

class _GetAllFavouriteContactListState extends State<GetAllFavouriteContactList> {
  @override
  Widget build(BuildContext context) {
    return Consumer<MyContactsProvider>(builder: (context, getAllContactsProvider, child) {
      return Column(
        children: [
          SearchCardView(
            index: widget.index,
            isFav: true,
          ),
          Expanded(
            child: getAllContactsProvider.contactsList.isEmpty
                ? getAllContactsProvider.contactsList.isEmpty && getAllContactsProvider.contactSearchController.text.isNotEmpty
                    ? Center(
                        child: Text(
                        "No Records Found",
                        style: w400_16Poppins(color: Colors.white),
                      ))
                    : Column(
                        children: [
                          height70,
                          height50,
                          // Lottie.asset(AppImages.noFav, width: 113.w, height: 114.h),
                           Image.asset(AppImages.noFav, 
                                    // width: 113.w, height: 114.h
                                    ),
                          height10,
                          Text(
                            "No favourites yet!",
                            style: w700_15Poppins(color: Colors.blue),
                          ),
                          height5,
                          SizedBox(
                            width: 250.w,
                            child: Text(
                              "Click the star icon to add a Contact to your favourites.",
                              maxLines: 2,
                              textAlign: TextAlign.center,
                              style: w400_13Poppins(color: Theme.of(context).hintColor.withOpacity(0.5)),
                            ),
                          ),
                        ],
                      )
                : ListView.separated(
                    shrinkWrap: true,
                    padding: EdgeInsets.only(bottom: 50.h),
                    itemCount: getAllContactsProvider.contactsList.length,
                    itemBuilder: (context, index) {
                      return GestureDetector(
                        onTap: () {
                          Navigator.push(
                              context, MaterialPageRoute(builder: (context) => PIPGlobalNavigation(childWidget: ViewContactScreen(itemData: getAllContactsProvider.contactsList[index], isFav: true))));
                        },
                        child: Padding(
                          padding: EdgeInsets.symmetric(horizontal: 8.w),
                          child: Container(
                            decoration: BoxDecoration(borderRadius: BorderRadius.circular(5.0.r), color: Theme.of(context).cardColor),
                            child: Row(
                              children: [
                                Padding(
                                  padding: EdgeInsets.all(8.0.sp),
                                  child: SizedBox(
                                    height: 40.w,
                                    width: 40.w,
                                    child: getAllContactsProvider.contactsList[index].contactPic == null || getAllContactsProvider.contactsList[index].contactPic == ""
                                        ? ClipRRect(
                                            borderRadius: BorderRadius.circular(50.r),
                                            child: SvgPicture.asset(
                                              AppImages.dummyProfileSvg,
                                              width: 50.w,
                                              height: 50.w,
                                            ))
                                        : ClipRRect(
                                            borderRadius: BorderRadius.circular(50.r),
                                            child: Image.network(
                                              "${BaseUrls.imageUrl}${getAllContactsProvider.contactsList[index].contactPic}",
                                              fit: BoxFit.fill,
                                              height: 40.w,
                                              width: 40.w,
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
                                Countries(countriesFlag: getAllContactsProvider.contactsList[index].countryName.toString().substring(0, 2)),
                                width10,
                                Consumer<MyContactsProvider>(builder: (context, myContactsProvider, child) {
                                  return Padding(
                                    padding: EdgeInsets.only(right: 10.h),
                                    child: GestureDetector(
                                      onTap: () {
                                        myContactsProvider.favOrUnFav = [];
                                        myContactsProvider.favOrUnFav.add(int.parse(getAllContactsProvider.contactsList[index].contactId.toString()));
                                        print(myContactsProvider.favOrUnFav);
                                        myContactsProvider.getFavOrUnFav(context, widget.index, getAllContactsProvider.contactsList[index].favStatus);
                                      },
                                      child: SvgPicture.asset(
                                        getAllContactsProvider.contactsList[index].favStatus == 1 ? AppImages.favoriteFillIcon : AppImages.favoriteEmptyIcon,
                                      ),
                                    ),
                                  );
                                })
                              ],
                            ),
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
        ],
      );
    });
  }
}
