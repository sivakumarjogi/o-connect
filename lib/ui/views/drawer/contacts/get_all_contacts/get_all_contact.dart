import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:o_connect/core/providers/my_contacts_provider.dart';
import 'package:o_connect/ui/utils/base_urls.dart';
import 'package:o_connect/ui/utils/countrie_flags.dart';
import 'package:o_connect/ui/views/pip_views/pip_global_navigation.dart';
import 'package:provider/provider.dart';
import '../../../../utils/colors/colors.dart';
import '../../../../utils/drawerHelper/drawerHelper.dart';
import '../../../../utils/images/images.dart';
import '../../../../utils/textfield_helper/app_fonts.dart';
import '../../../../utils/textfield_helper/common_textfield.dart';
import '../create_contact/view_contact_screen.dart';

class GetAllContactList extends StatefulWidget {
  const GetAllContactList({super.key, required this.index});

  final int index;

  @override
  State<GetAllContactList> createState() => _GetAllContactListState();
}

class _GetAllContactListState extends State<GetAllContactList> {
  int currentPageNumber = 0;
  late ScrollController _scrollController;
  late MyContactsProvider myContactsProvider;

  @override
  void initState() {
    _scrollController = ScrollController();
    myContactsProvider = Provider.of<MyContactsProvider>(context, listen: false);
    print("the values $currentPageNumber ${myContactsProvider.contactsList.length}");
    _scrollController.addListener(() {
      if (_scrollController.position.maxScrollExtent == _scrollController.position.pixels) {
        if (!myContactsProvider.loadedMaxContacts) {
          currentPageNumber++;
          // myContactsProvider.getAllContacts(context: context, pageNumber: currentPageNumber);
        }
      }
    });
    // To reset filters and set dropdown value to all
    myContactsProvider.selectContactTypeData(context, 0, "All");
    myContactsProvider.updateSelectedCategory("All");
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        myContactsProvider.loadedMaxContacts = false;
        return true;
      },
      child: Consumer<MyContactsProvider>(builder: (context, getAllContactsProvider, child) {
        return Stack(children: [
          Column(
            children: [
              SearchCardView(index: widget.index, isFav: false),
              getAllContactsProvider.contactsLoading
                  ? Column(
                      children: [
                        SizedBox(
                          height: MediaQuery.of(context).size.height * 0.3,
                        ),
                        const Center(child: CircularProgressIndicator()),
                      ],
                    )
                  : Expanded(
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
                                    Image.asset(AppImages.noContacts, 
                                    // width: 113.w, height: 114.h
                                    ),
                                    height10,
                                    Text(
                                      "No Contacts added Yet!",
                                      style: w700_15Poppins(color: Colors.blue),
                                    ),
                                    height5,
                                    SizedBox(
                                      width: 260.w,
                                      child: Text(
                                        "Click the Add Contacts button to add a new Contact.",
                                        maxLines: 2,
                                        textAlign: TextAlign.center,
                                        style: w400_13Poppins(color: Theme.of(context).hintColor.withOpacity(0.5)),
                                      ),
                                    ),
                                  ],
                                )
                          : ListView.separated(
                              shrinkWrap: true,
                              padding: EdgeInsets.only(
                                bottom: 50.h,
                              ),
                              controller: _scrollController,
                              itemCount: getAllContactsProvider.contactsList.length,
                              itemBuilder: (context, index) {
                                return GestureDetector(
                                  onTap: () {
                                    myContactsProvider.searchValue == true ? myContactsProvider.searchBoxEnableDisable() : myContactsProvider.searchValue = false;
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) => PIPGlobalNavigation(
                                                  childWidget: ViewContactScreen(
                                                    /*index: widget.index,*/ itemData: getAllContactsProvider.contactsList[index],
                                                    isFav: false,
                                                  ),
                                                )));
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
                                                  ? Stack(
                                                      children: [
                                                        ClipRRect(
                                                            borderRadius: BorderRadius.circular(50.r),
                                                            child: SvgPicture.asset(
                                                              AppImages.dummyProfileSvg,
                                                              width: 50.w,
                                                              height: 50.w,
                                                            )),
                                                        // Positioned(
                                                        //   bottom: 0,
                                                        //   right: 0,
                                                        //   child: Container(
                                                        //     height: 15.h,
                                                        //     width: 15.w,
                                                        //     decoration: const BoxDecoration(
                                                        //       shape: BoxShape.circle,
                                                        //       color: Color.fromARGB(255, 11, 233, 92),
                                                        //     ),
                                                        //   ),
                                                        // )
                                                      ],
                                                    )
                                                  : Stack(children: [
                                                      ClipRRect(
                                                        borderRadius: BorderRadius.circular(50.r),
                                                        child: Image.network(
                                                          "${BaseUrls.imageUrl}${getAllContactsProvider.contactsList[index].contactPic}",
                                                          fit: BoxFit.fill,
                                                          height: 40.w,
                                                          width: 40.w,
                                                        ),
                                                      ),
                                                      // Positioned(
                                                      //   bottom: 0,
                                                      //   right: 0,
                                                      //   child: Container(
                                                      //     height: 15.h,
                                                      //     width: 15.w,
                                                      //     decoration: const BoxDecoration(
                                                      //       shape: BoxShape.circle,
                                                      //       color: Color.fromARGB(255, 11, 233, 92),
                                                      //     ),
                                                      //   ),
                                                      // )
                                                    ]),
                                            ),
                                          ),
                                          Expanded(
                                            child: Column(
                                              crossAxisAlignment: CrossAxisAlignment.start,
                                              mainAxisAlignment: MainAxisAlignment.start,
                                              children: [
                                                Text(
                                                  "${getAllContactsProvider.contactsList[index].firstName} ${getAllContactsProvider.contactsList[index].lastName}",
                                                  overflow: TextOverflow.ellipsis,
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
                                                    myContactsProvider.getFavOrUnFav(context, widget.index, getAllContactsProvider.contactsList[index].favStatus);
                                                  },
                                                  child: SvgPicture.asset(
                                                    getAllContactsProvider.contactsList[index].favStatus == 1 ? AppImages.favoriteFillIcon : AppImages.favoriteEmptyIcon,
                                                  )),
                                            );
                                          })
                                        ],
                                      ),
                                    ),
                                  ),
                                );
                              },
                              separatorBuilder: (context, index) => height10,
                            ),
                    ),
            ],
          ),
          // Positioned(
          //   left: 0,
          //   right: 0,
          //   bottom: 0,
          //   child: Padding(
          //       padding: const EdgeInsets.all(12.0),
          //       child: Container(
          //         height: MediaQuery.of(context).size.height * 0.05,
          //         decoration: BoxDecoration(borderRadius: BorderRadius.circular(6.r), color: const Color(0xff0E78F9)),
          //         child: Center(
          //           child: Text(
          //             "Delete",
          //             style: w500_16Poppins(color: Theme.of(context).hintColor),
          //           ),
          //         ),
          //       )),
          // )
        ]);
      }),
    );
  }
}

class SearchCardView extends StatefulWidget {
  SearchCardView({
    super.key,
    required this.index,
    required this.isFav,
  });

  final int index;
  final bool isFav;

  @override
  State<SearchCardView> createState() => _SearchCardViewState();
}

class _SearchCardViewState extends State<SearchCardView> {
  late MyContactsProvider myContactsProvider;

  @override
  void initState() {
    myContactsProvider = Provider.of<MyContactsProvider>(context, listen: false);
    myContactsProvider.contactSearchController = TextEditingController();
    super.initState();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    // myContactsProvider.contactSearchController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<MyContactsProvider>(builder: (context, myContactsProvider, child) {
      return myContactsProvider.searchValue
          ? Padding(
              padding: EdgeInsets.only(left: 8.w, right: 8.w, bottom: 10.h, top: 10.h),
              child: SizedBox(
                height: 40.h,
                child: CommonTextFormField(
                    fillColor: Theme.of(context).scaffoldBackgroundColor,
                    borderColor: Theme.of(context).primaryColorDark,
                    suffixIcon: InkWell(
                      onTap: () {
                        myContactsProvider.searchBoxEnableDisable();
                      },
                      child: Icon(
                        Icons.close,
                        color: Theme.of(context).disabledColor,
                      ),
                    ),
                    controller: myContactsProvider.contactSearchController,
                    // prefixIcon: Icon(
                    //   Icons.search,
                    //   color: Theme.of(context).disabledColor,
                    // ),
                    hintText: "Search",
                    onChanged: (val) {
                      if (val.length > 2) {
                        myContactsProvider.getAllContacts(context: context, index: widget.index, searchKey: myContactsProvider.contactSearchController.text);
                      } else if (val.isEmpty) {
                        myContactsProvider.getAllContacts(
                          context: context,
                          index: widget.index,
                        );
                      }
                    }),
              ),
            )
          : Column(
              children: [
                Padding(
                  padding: EdgeInsets.only(left: 8.w, right: 8.w, bottom: 10.h, top: 10.h),
                  child: Row(
                    children: [
                      Expanded(
                        child: DropDownHelper(
                          borderRadius: 5.r,
                          buttonColor: Theme.of(context).scaffoldBackgroundColor,
                          selectedValue: myContactsProvider.selectedValue,
                          dropDownSheetColor: Theme.of(context).cardColor,
                          dropDownItems: myContactsProvider.contactCategoriesItems
                              .map<DropdownMenuItem<String>>(
                                (e) => DropdownMenuItem(
                                  value: e,
                                  child: Text(
                                    e,
                                    style: w400_14Poppins(color: Theme.of(context).hintColor),
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                              )
                              .toList(),
                          onChanged: (val) {
                            myContactsProvider.selectContactTypeData(context, widget.index, val);
                            myContactsProvider.updateSelectedCategory(val!);
                          },
                          // onChanged: (String? value) {
                          //   myContactsProvider
                          //       .updateSelectedCategory(
                          //       value!);
                          // },
                        ),
                      ),
                      width10,
                      InkWell(
                        onTap: () {
                          // CustomToast.showInfoToast(msg: "Coming Soon...");
                          myContactsProvider.searchBoxEnableDisable();
                        },
                        child: Container(
                          height: 38.w,
                          width: 40.w,
                          decoration: BoxDecoration(borderRadius: BorderRadius.circular(5.0.r), border: Border.all(color: Theme.of(context).primaryColorDark, width: 0.2)),
                          child: Center(
                            child: SvgPicture.asset(
                              AppImages.searchIcon,
                              // color: Theme.of(context).hintColor.withOpacity(0.2),
                              height: 25.h,
                              width: 25.h, 
                            ),
                          ),
                        ),
                      ),
                      width10,
                      InkWell(
                        onTap: () {
                          // CustomToast.showInfoToast(msg: "Coming Soon...");
                         myContactsProvider.uploadCSV(context, widget.isFav,myContactsProvider.selectedValue=="All"?"":
                         myContactsProvider.selectedValue=="Ecosystem"?"0":
                         myContactsProvider.selectedValue=="OMail"?"2":
                         myContactsProvider.selectedValue=="OCONNECT"?"4":"0"


                          
                          );
                         
                        
                        },
                        child: Container(
                          height: 38.w,
                          width: 40.w,
                          decoration: BoxDecoration(borderRadius: BorderRadius.circular(5.0.r), color: Theme.of(context).cardColor),
                          child: Center(
                            child: SvgPicture.asset(
                              AppImages.csvIcon,
                              color: Theme.of(context).primaryColorLight.withOpacity(0.8),
                              height: 25.h,
                              width: 25.h,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            );
    });
  }
}
