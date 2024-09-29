// // import 'dart:async';
// // import 'package:flutter/cupertino.dart';
// // import 'package:flutter/material.dart';
// // import 'package:flutter/widgets.dart';
// // import 'package:flutter_screenutil/flutter_screenutil.dart';
// // import 'package:flutter_svg/svg.dart';
// // import 'package:o_connect/core/screen_configs.dart';
// // import 'package:o_connect/ui/utils/images/images.dart';
// // import 'package:o_connect/ui/views/drawer/drawer_viewmodel.dart';
// // import 'package:o_connect/ui/views/drawer/library_revamp/library_revamp_provider.dart';
// // import 'package:o_connect/ui/views/meeting/utils/context_ext.dart';
// // import 'package:o_connect/ui/views/presentation/provider/presentation_popup_provider.dart';
// // import 'package:oes_chatbot/utils/extensions/sizedbox_extension.dart';
// // import 'template/library_templates.dart';
// // import 'presentation_files/presentation_files.dart';
// // import '../../../utils/buttons_helper/custom_botton.dart';
// // import '../../../utils/drawerHelper/drawerHelper.dart';
// // import '../../../../core/models/dummy_models/dummy_model.dart';
// // import '../../../../core/providers/library_provider.dart';
// // import '../../../utils/colors/colors.dart';
// // import '../../../utils/common_app_bar/common_appbar.dart';
// // import '../../../utils/constant_strings.dart';
// // import '../../../utils/textfield_helper/app_fonts.dart';
// // import '../../../utils/textfield_helper/common_textfield.dart';
// // import '../custom_drawer_view.dart';
// // import 'start_end_dates.dart';
// // import 'package:provider/provider.dart';
// // import 'meeting_history/meeting_history.dart';

// // class LibraryPage extends StatefulWidget {
// //   const LibraryPage({super.key});

// //   @override
// //   State<LibraryPage> createState() => _LibraryPageState();
// // }

// // class _LibraryPageState extends State<LibraryPage> {
// //   final TextEditingController searchController = TextEditingController();
// //   var refreshKey = GlobalKey<RefreshIndicatorState>();
// //   late LibraryRevampProvider _libraryProvider;

// //   @override
// //   void initState() {
// //     _libraryProvider = Provider.of<LibraryProvider>(context, listen: false);
// //     _libraryProvider.libraryDropdownSelectedItem = "Meeting History";
// //     _libraryProvider.fetchPresentationDataDetails();
// //     _libraryProvider.meetingHistoryScrollController.addListener(_libraryProvider.fetchMeetingHistoryLoadMore);
// //     _libraryProvider.templatesScrollController.addListener(_libraryProvider.fetchTemplateLoadMoreRunning);
// //     _libraryProvider.clearDates();
// //     super.initState();
// //   }

// //   @override
// //   void dispose() {
// //     searchController.dispose();
// //     // _libraryProvider.meetingHistoryScrollController.removeListener(_libraryProvider.fetchMeetingHistoryLoadMore);
// //     // _libraryProvider.templatesScrollController.removeListener(_libraryProvider.fetchTemplateLoadMoreRunning);
// //     // _libraryProvider.clearDates();
// //     // _libraryProvider.libraryDropdownSelectedItem = "Meeting History";
// //     super.dispose();
// //   }

// //   // Future _onRefresh() async {
// //   //   Completer completer = Completer();
// //   //   await Future.delayed(const Duration(seconds: 2)).then((value) {
// //   //     completer.complete();
// //   //     _libraryProvider.getLibraryHistoryDetails();
// //   //   });
// //   //   return completer.future;
// //   // }

// //   @override
// //   Widget build(BuildContext context) {
// //     return Consumer2<LibraryRevampProvider, PresentationPopUpProvider>(builder: (context, provider, presentationProvider, child) {
// //       return WillPopScope(
// //         onWillPop: () async {
// //           Provider.of<DrawerViewModel>(context, listen: false).mainSelectedChange(ConstantsStrings.home);
// //           return true;
// //         },
// //         child: Scaffold(
// //           backgroundColor: Theme.of(context).scaffoldBackgroundColor,
// //           // drawerEnableOpenDragGesture: false,
// //           resizeToAvoidBottomInset: false,
// //           drawer: const CustomDrawerView(),

// //           body: SingleChildScrollView(
// //             child: SafeArea(
// //                 child: Padding(
// //               padding: EdgeInsets.only(left: 15.w, right: 15.w, top: 10.h),
// //               child: SizedBox(
// //                 height: ScreenConfig.height,
// //                 child: Column(children: [
// //                   height10,
// //                   // provider.libraryDropdownSelectedItem == ConstantsStrings.presentationFiles
// //                   //     ?
// //                   Row(
// //                     mainAxisAlignment: MainAxisAlignment.spaceBetween,
// //                     children: [
// //                       SizedBox(
// //                         width: MediaQuery.of(context).size.width * 0.7,
// //                         height: 40.h,
// //                         child: CommonTextFormField(
// //                           fillColor: Theme.of(context).scaffoldBackgroundColor,
// //                           borderColor: Theme.of(context).primaryColorDark,
// //                           controller: searchController,
// //                           onChanged: (searchedText) async {
// //                             provider.localSearchForPresentation(searchedText);
// //                             if (provider.libraryDropdownSelectedItem == ConstantsStrings.template) {
// //                               if (searchedText.length > 2) {
// //                                 await provider.fetchTemplateFirstLoadRunning();
// //                               } else if (searchedText.isEmpty) {
// //                                 await provider.fetchTemplateFirstLoadRunning();
// //                               }
// //                             } else {
// //                               if (searchedText.length > 2) {
// //                                 await provider.fetchMeetingHistoryFirstLoading(false);
// //                               } else if (searchedText.isEmpty) {
// //                                 await provider.fetchMeetingHistoryFirstLoading(false);
// //                               }
// //                             }
// //                           },
// //                           keyboardType: TextInputType.text,
// //                           hintText: ConstantsStrings.search,
// //                           hintStyle: w400_14Poppins(color: Theme.of(context).primaryColorLight),
// //                           suffixIcon: Icon(
// //                             Icons.search,
// //                             size: 16.sp,
// //                             color: Theme.of(context).primaryColorLight,
// //                           ),
// //                           inputAction: TextInputAction.next,
// //                         ),
// //                       ),
// //                       SvgPicture.asset(AppImages.createFolderIcon),
// //                       GestureDetector(
// //                           onTap: () {
// //                             showModalBottomSheet(
// //                                 isScrollControlled: true,
// //                                 isDismissible: false,
// //                                 backgroundColor: Theme.of(context).scaffoldBackgroundColor,
// //                                 shape: RoundedRectangleBorder(borderRadius: BorderRadius.only(topRight: Radius.circular(24.r), topLeft: Radius.circular(24.r))),
// //                                 context: context,
// //                                 builder: (context) {
// //                                   return Padding(
// //                                     padding: const EdgeInsets.all(8.0),
// //                                     child: Column(crossAxisAlignment: CrossAxisAlignment.start, mainAxisAlignment: MainAxisAlignment.start, mainAxisSize: MainAxisSize.min, children: [
// //                                       Align(
// //                                         alignment: Alignment.center,
// //                                         child: Container(
// //                                           height: 5.h,
// //                                           width: 100.w,
// //                                           decoration: BoxDecoration(borderRadius: BorderRadius.circular(20.r), color: Color(0xff202223)),
// //                                         ),
// //                                       ),
// //                                       25.h.height,
// //                                       Row(
// //                                         mainAxisAlignment: MainAxisAlignment.spaceBetween,
// //                                         children: [
// //                                           Text(
// //                                             "Select File",
// //                                             style: w500_14Poppins(color: Colors.white),
// //                                           ),
// //                                           GestureDetector(
// //                                             onTap: () {
// //                                               Navigator.pop(context);
// //                                             },
// //                                             child: Container(
// //                                               decoration: BoxDecoration(
// //                                                 shape: BoxShape.circle,
// //                                                 color: Theme.of(context).primaryColorLight,
// //                                               ),
// //                                               child: Padding(
// //                                                 padding: const EdgeInsets.all(4.0),
// //                                                 child: Icon(
// //                                                   Icons.close,
// //                                                   size: 12,
// //                                                   color: Theme.of(context).scaffoldBackgroundColor,
// //                                                 ),
// //                                               ),
// //                                             ),
// //                                           ),
// //                                         ],
// //                                       ),
// //                                       Divider(),
// //                                       Padding(
// //                                         padding: const EdgeInsets.all(8.0),
// //                                         child: Row(
// //                                           mainAxisAlignment: MainAxisAlignment.spaceBetween,
// //                                           children: [
// //                                             Column(
// //                                               children: [
// //                                                 GestureDetector(
// //                                                     onTap: () {
// //                                                       provider.filePicker();
// //                                                     },
// //                                                     child: SvgPicture.asset(AppImages.documentIcon)),
// //                                                 5.h.height,
// //                                                 Text("Document")
// //                                               ],
// //                                             ),
// //                                             Column(
// //                                               children: [
// //                                                 GestureDetector(
// //                                                   onTap: () {
// //                                                     provider.filePicker();
// //                                                   },
// //                                                   child: SvgPicture.asset(AppImages.cameraIcon),
// //                                                 ),
// //                                                 5.h.height,
// //                                                 Text("Camera")
// //                                               ],
// //                                             ),
// //                                             Column(
// //                                               children: [
// //                                                 GestureDetector(
// //                                                     onTap: () {
// //                                                       provider.filePicker();
// //                                                     },
// //                                                     child: SvgPicture.asset(AppImages.galleryIcon)),
// //                                                 5.h.height,
// //                                                 Text("Gallery")
// //                                               ],
// //                                             ),
// //                                             Column(
// //                                               children: [
// //                                                 GestureDetector(
// //                                                     onTap: () {
// //                                                       provider.filePicker();
// //                                                     },
// //                                                     child: SvgPicture.asset(AppImages.musicIcon)),
// //                                                 5.h.height,
// //                                                 Text("Music")
// //                                               ],
// //                                             )
// //                                           ],
// //                                         ),
// //                                       ),
// //                                       Padding(
// //                                         padding: const EdgeInsets.all(8.0),
// //                                         child: Column(
// //                                           children: [
// //                                             GestureDetector(
// //                                                 onTap: () {
// //                                                   provider.filePicker();
// //                                                 },
// //                                                 child: SvgPicture.asset(AppImages.videoIconLib)),
// //                                             5.h.height,
// //                                             Text("Video")
// //                                           ],
// //                                         ),
// //                                       ),
// //                                     ]),
// //                                   );
// //                                 });
// //                           },
// //                           child: SvgPicture.asset(AppImages.uploadIcon)),
// //                       // CustomButton(
// //                       //   height: 40.h,
// //                       //   width: 80.w,
// //                       //   buttonText: "Upload",
// //                       //   onTap: () {
// //                       // provider.filePicker();
// //                       //   },
// //                       // )
// //                     ],
// //                   ),

// //                   height10,
// //                   // presentationProvider.selectedConvertedPresetationFile?.convertedImages==null?CircularProgressIndicator():
// //                   //  provider.presentationData.isEmpty == true? Text("no data"):

// //                   ListView.builder(
// //                       shrinkWrap: true,
// //                       physics: BouncingScrollPhysics(),
// //                       itemCount: provider.presentationDataList.length,
// //                       itemBuilder: ((context, index) {
// //                         print("the lenghtgg ${provider.presentationData.length}");
// //                         return Padding(
// //                           padding: const EdgeInsets.only(top: 4.0),
// //                           child: Container(
// //                             decoration: BoxDecoration(borderRadius: BorderRadius.circular(12), color: Theme.of(context).cardColor),
// //                             child: Padding(
// //                               padding: const EdgeInsets.all(8.0),
// //                               child: Row(
// //                                 mainAxisAlignment: MainAxisAlignment.spaceBetween,
// //                                 children: [
// //                                   Row(
// //                                     children: [
// //                                       provider.presentationDataList[index].folderName != null
// //                                           ? SvgPicture.asset(
// //                                               AppImages.document,
// //                                               height: 35.h,
// //                                               width: 35.w,
// //                                             )
// //                                           : provider.presentationDataList[index].fileName!.contains("png")
// //                                               ? Image.asset(
// //                                                   AppImages.photo,
// //                                                   height: 35.h,
// //                                                   width: 35.w,
// //                                                 )
// //                                               : provider.presentationDataList[index].fileName!.contains("mp4")
// //                                                   ? SvgPicture.asset(
// //                                                       AppImages.video,
// //                                                       height: 35.h,
// //                                                       width: 35.w,
// //                                                     )
// //                                                   : provider.presentationDataList[index].fileName!.contains("pdf")
// //                                                       ? SvgPicture.asset(AppImages.pdfLib)
// //                                                       : SvgPicture.asset(AppImages.musicIcon),
// //                                       Column(
// //                                         crossAxisAlignment: CrossAxisAlignment.start,
// //                                         children: [
// //                                           Text(
// //                                             provider.presentationDataList[index].fileName == null
// //                                                 ? provider.presentationDataList[index].folderName.toString()
// //                                                 : provider.presentationDataList[index].fileName.toString(),
// //                                             style: w500_14Poppins(color: Colors.white),
// //                                           ),
// //                                           5.h.height,
// //                                           Text(
// //                                             "sdkjskj",
// //                                             style: w400_14Poppins(color: Theme.of(context).primaryColorLight),
// //                                           )
// //                                         ],
// //                                       ),
// //                                     ],
// //                                   ),
// //                                   GestureDetector(
// //                                       onTap: () {
// //                                         showModalBottomSheet(
// //                                             isScrollControlled: true,
// //                                             isDismissible: false,
// //                                             backgroundColor: Theme.of(context).scaffoldBackgroundColor,
// //                                             shape: RoundedRectangleBorder(borderRadius: BorderRadius.only(topRight: Radius.circular(24.r), topLeft: Radius.circular(24.r))),
// //                                             context: context,
// //                                             builder: (context) {
// //                                               return moreBottomSheet();
// //                                             });
// //                                       },
// //                                       child: Icon(Icons.more_vert_rounded, color: Theme.of(context).primaryColorLight))
// //                                 ],
// //                               ),
// //                             ),
// //                           ),
// //                         );
// //                       })),
// //                   5.h.height,

// //                   // provider.libraryDropdownSelectedItem == ConstantsStrings.presentationFiles ? const SizedBox.shrink() : StartAndEndDate(provider: provider),
// //                   // if (provider.libraryDropdownSelectedItem != ConstantsStrings.presentationFiles) height10,
// //                   // provider.libraryDropdownSelectedItem == ConstantsStrings.template
// //                   //     ? LibraryTemplates(provider: provider)
// //                   //     : provider.libraryDropdownSelectedItem == ConstantsStrings.presentationFiles
// //                   //         ? PresentationFiles(provider: provider)
// //                   //         : const MeetingHistory(),
// //                   // height10,
// //                 ]),
// //               ),
// //             )),
// //           ),
// //         ),
// //       );
// //     });
// //   }

// //   moreBottomSheet() {
// //     return Padding(
// //       padding: const EdgeInsets.all(8.0),
// //       child: Column(
// //         crossAxisAlignment: CrossAxisAlignment.start,
// //         mainAxisAlignment: MainAxisAlignment.start,
// //         mainAxisSize: MainAxisSize.min,
// //         children: [
// //           Align(
// //             alignment: Alignment.center,
// //             child: Container(
// //               height: 5.h,
// //               width: 100.w,
// //               decoration: BoxDecoration(borderRadius: BorderRadius.circular(20.r), color: Color(0xff202223)),
// //             ),
// //           ),
// //           25.h.height,
// //           Row(
// //             mainAxisAlignment: MainAxisAlignment.spaceBetween,
// //             children: [
// //               Text(
// //                 "Details",
// //                 style: w500_14Poppins(color: Colors.white),
// //               ),
// //               GestureDetector(
// //                 onTap: () {
// //                   Navigator.pop(context);
// //                 },
// //                 child: Container(
// //                   decoration: BoxDecoration(
// //                     shape: BoxShape.circle,
// //                     color: Theme.of(context).primaryColorLight,
// //                   ),
// //                   child: Padding(
// //                     padding: const EdgeInsets.all(4.0),
// //                     child: Icon(
// //                       Icons.close,
// //                       size: 12,
// //                       color: Theme.of(context).scaffoldBackgroundColor,
// //                     ),
// //                   ),
// //                 ),
// //               ),
// //             ],
// //           ),
// //           Divider(),
// //           Row(
// //             children: [SvgPicture.asset(AppImages.pdf), 5.w.width, Text("kshjdjfjfjhfhh")],
// //           ),
// //           10.h.height,
// //           Row(
// //             children: [
// //               Container(
// //                 width: 175.w,
// //                 decoration: BoxDecoration(borderRadius: BorderRadius.circular(8), color: Color(0xff202223)),
// //                 child: Padding(
// //                   padding: const EdgeInsets.all(8.0),
// //                   child: Row(
// //                     children: [
// //                       Icon(Icons.remove_red_eye_outlined, color: Theme.of(context).primaryColorLight),
// //                       4.w.width,
// //                       Text(
// //                         "Edit",
// //                         style: w400_12Poppins(color: Theme.of(context).primaryColorLight),
// //                       )
// //                     ],
// //                   ),
// //                 ),
// //               ),
// //               8.w.width,
// //               Container(
// //                 width: 175.w,
// //                 decoration: BoxDecoration(borderRadius: BorderRadius.circular(8), color: Color(0xff202223)),
// //                 child: Padding(
// //                   padding: const EdgeInsets.all(8.0),
// //                   child: Row(
// //                     children: [
// //                       Icon(Icons.file_download_outlined, color: Theme.of(context).primaryColorLight),
// //                       4.w.width,
// //                       Text("Download", style: w400_12Poppins(color: Theme.of(context).primaryColorLight))
// //                     ],
// //                   ),
// //                 ),
// //               )
// //             ],
// //           ),
// //           5.h.height,
// //           Row(children: [
// //             Container(
// //               width: 175.w,
// //               decoration: BoxDecoration(borderRadius: BorderRadius.circular(8), color: Color(0xff202223)),
// //               child: Padding(
// //                 padding: const EdgeInsets.all(8.0),
// //                 child: Row(
// //                   children: [
// //                     Icon(Icons.delete_outline_outlined, color: Theme.of(context).primaryColorLight),
// //                     4.w.width,
// //                     Text("Delete", style: w400_12Poppins(color: Theme.of(context).primaryColorLight))
// //                   ],
// //                 ),
// //               ),
// //             ),
// //             8.w.width,
// //             Container(
// //                 width: 175.w,
// //                 decoration: BoxDecoration(borderRadius: BorderRadius.circular(8), color: Color(0xff202223)),
// //                 child: Padding(
// //                   padding: const EdgeInsets.all(8.0),
// //                   child: Row(
// //                     children: [Icon(Icons.edit, color: Theme.of(context).primaryColorLight), 4.w.width, Text("Rename", style: w400_12Poppins(color: Theme.of(context).primaryColorLight))],
// //                   ),
// //                 ))
// //           ]),
// //           Divider(),
// //           Text(
// //             "Type",
// //             style: w400_12Poppins(color: Theme.of(context).primaryColorLight),
// //           ),
// //           5.h.height,
// //           Text(
// //             "Type",
// //             style: w400_14Poppins(color: Theme.of(context).hintColor),
// //           ),
// //           10.h.height,
// //           Text(
// //             "Size",
// //             style: w400_12Poppins(color: Theme.of(context).primaryColorLight),
// //           ),
// //           5.h.height,
// //           Text(
// //             "Type",
// //             style: w400_14Poppins(color: Theme.of(context).hintColor),
// //           ),
// //           10.h.height,
// //           Text(
// //             "Date Created",
// //             style: w400_12Poppins(color: Theme.of(context).primaryColorLight),
// //           ),
// //           5.h.height,
// //           Text(
// //             "Type",
// //             style: w400_14Poppins(color: Theme.of(context).hintColor),
// //           ),
// //           10.h.height,
// //           Text(
// //             "Date Modified",
// //             style: w400_12Poppins(color: Theme.of(context).primaryColorLight),
// //           ),
// //           5.h.height,
// //           Text(
// //             "Type",
// //             style: w400_14Poppins(color: Theme.of(context).hintColor),
// //           ),
// //           10.h.height,
// //         ],
// //       ),
// //     );
// //   }
// // }
//   @override
//   Widget build(BuildContext context) {
//     return Consumer2<LibraryProvider, PresentationPopUpProvider>(builder: (context, provider, presentationProvider, child) {
//       return WillPopScope(
//         onWillPop: () async {
//           Provider.of<DrawerViewModel>(context, listen: false).mainSelectedChange(ConstantsStrings.home);
//           return true;
//         },
//         child: Scaffold(
//           backgroundColor: Theme.of(context).scaffoldBackgroundColor,
//           // drawerEnableOpenDragGesture: false,
//           resizeToAvoidBottomInset: false,
//           drawer: const CustomDrawerView(),

//           body: SingleChildScrollView(
//             child: SafeArea(
//                 child: Padding(
//               padding: EdgeInsets.only(left: 15.w, right: 15.w, top: 10.h),
//               child: SizedBox(
//                 height: ScreenConfig.height,
//                 child: Column(children: [
//                   height10,
//                   // provider.libraryDropdownSelectedItem == ConstantsStrings.presentationFiles
//                   //     ?
//                   Row(
//                     mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                     children: [
//                       SizedBox(
//                         width: MediaQuery.of(context).size.width * 0.7,
//                         height: 40.h,
//                         child: CommonTextFormField(
//                           fillColor: Theme.of(context).scaffoldBackgroundColor,
//                           borderColor: Theme.of(context).primaryColorDark,
//                           controller: searchController,
//                           onChanged: (searchedText) async {
//                             provider.localSearchForPresentation(searchedText);
//                             if (provider.libraryDropdownSelectedItem == ConstantsStrings.template) {
//                               if (searchedText.length > 2) {
//                                 await provider.fetchTemplateFirstLoadRunning();
//                               } else if (searchedText.isEmpty) {
//                                 await provider.fetchTemplateFirstLoadRunning();
//                               }
//                             } else {
//                               if (searchedText.length > 2) {
//                                 await provider.fetchMeetingHistoryFirstLoading(false);
//                               } else if (searchedText.isEmpty) {
//                                 await provider.fetchMeetingHistoryFirstLoading(false);
//                               }
//                             }
//                           },
//                           keyboardType: TextInputType.text,
//                           hintText: ConstantsStrings.search,
//                           hintStyle: w400_14Poppins(color: Theme.of(context).primaryColorLight),
//                           suffixIcon: Icon(
//                             Icons.search,
//                             size: 16.sp,
//                             color: Theme.of(context).primaryColorLight,
//                           ),
//                           inputAction: TextInputAction.next,
//                         ),
//                       ),
//                       SvgPicture.asset(AppImages.createFolderIcon),
//                       GestureDetector(
//                           onTap: () {
//                             showModalBottomSheet(
//                                 isScrollControlled: true,
//                                 isDismissible: false,
//                                 backgroundColor: Theme.of(context).scaffoldBackgroundColor,
//                                 shape: RoundedRectangleBorder(borderRadius: BorderRadius.only(topRight: Radius.circular(24.r), topLeft: Radius.circular(24.r))),
//                                 context: context,
//                                 builder: (context) {
//                                   return Padding(
//                                     padding: const EdgeInsets.all(8.0),
//                                     child: Column(crossAxisAlignment: CrossAxisAlignment.start, mainAxisAlignment: MainAxisAlignment.start, mainAxisSize: MainAxisSize.min, children: [
//                                       Align(
//                                         alignment: Alignment.center,
//                                         child: Container(
//                                           height: 5.h,
//                                           width: 100.w,
//                                           decoration: BoxDecoration(borderRadius: BorderRadius.circular(20.r), color: Color(0xff202223)),
//                                         ),
//                                       ),
//                                       25.h.height,
//                                       Row(
//                                         mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                                         children: [
//                                           Text(
//                                             "Select File",
//                                             style: w500_14Poppins(color: Colors.white),
//                                           ),
//                                           GestureDetector(
//                                             onTap: () {
//                                               Navigator.pop(context);
//                                             },
//                                             child: Container(
//                                               decoration: BoxDecoration(
//                                                 shape: BoxShape.circle,
//                                                 color: Theme.of(context).primaryColorLight,
//                                               ),
//                                               child: Padding(
//                                                 padding: const EdgeInsets.all(4.0),
//                                                 child: Icon(
//                                                   Icons.close,
//                                                   size: 12,
//                                                   color: Theme.of(context).scaffoldBackgroundColor,
//                                                 ),
//                                               ),
//                                             ),
//                                           ),
//                                         ],
//                                       ),
//                                       Divider(),
//                                       Padding(
//                                         padding: const EdgeInsets.all(8.0),
//                                         child: Row(
//                                           mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                                           children: [
//                                             Column(
//                                               children: [
//                                                 GestureDetector(
//                                                     onTap: () {
//                                                       provider.filePicker();
//                                                     },
//                                                     child: SvgPicture.asset(AppImages.documentIcon)),
//                                                 5.h.height,
//                                                 Text("Document")
//                                               ],
//                                             ),
//                                             Column(
//                                               children: [
//                                                 GestureDetector(
//                                                   onTap: () {
//                                                     provider.filePicker();
//                                                   },
//                                                   child: SvgPicture.asset(AppImages.cameraIcon),
//                                                 ),
//                                                 5.h.height,
//                                                 Text("Camera")
//                                               ],
//                                             ),
//                                             Column(
//                                               children: [
//                                                 GestureDetector(
//                                                     onTap: () {
//                                                       provider.filePicker();
//                                                     },
//                                                     child: SvgPicture.asset(AppImages.galleryIcon)),
//                                                 5.h.height,
//                                                 Text("Gallery")
//                                               ],
//                                             ),
//                                             Column(
//                                               children: [
                                                
//                                                 GestureDetector(
//                                                     onTap: () {
//                                                       provider.filePicker();
//                                                     },
//                                                     child: SvgPicture.asset(AppImages.musicIcon)),
//                                                 5.h.height,
//                                                 Text("Music")
//                                               ],
//                                             )
//                                           ],
//                                         ),
//                                       ),
//                                       Padding(
//                                         padding: const EdgeInsets.all(8.0),
//                                         child: Column(
//                                           children: [
//                                             GestureDetector(
//                                                 onTap: () {
//                                                   provider.filePicker();
//                                                 },
//                                                 child: SvgPicture.asset(AppImages.videoIconLib)),
//                                             5.h.height,
//                                             Text("Video")
//                                           ],
//                                         ),
//                                       ),
//                                     ]),
//                                   );
//                                 });
//                           },
//                           child: SvgPicture.asset(AppImages.uploadIcon)),
//                       // CustomButton(
//                       //   height: 40.h,
//                       //   width: 80.w,
//                       //   buttonText: "Upload",
//                       //   onTap: () {
//                       // provider.filePicker();
//                       //   },
//                       // )
//                     ],
//                   ),

//                   height10,
//                   // presentationProvider.selectedConvertedPresetationFile?.convertedImages==null?CircularProgressIndicator():
//                   provider.presentationDataList.isEmpty == true
//                       ? Text("no data")
//                       : ListView.builder(
//                           shrinkWrap: true,
//                           physics: BouncingScrollPhysics(),
//                           itemCount: provider.presentationDataList.length,
//                           itemBuilder: ((context, index) {
//                             print("the lenghtgg ${provider.presentationData.length}");
//                             return Padding(
//                               padding: const EdgeInsets.only(top: 4.0),
//                               child: Container(
//                                 decoration: BoxDecoration(borderRadius: BorderRadius.circular(12), color: Theme.of(context).cardColor),
//                                 child: Padding(
//                                   padding: const EdgeInsets.all(8.0),
//                                   child: Row(
//                                     mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                                     children: [
//                                       Row(
//                                         children: [
//                                           provider.presentationDataList[index].folderName != null
//                                               ? SvgPicture.asset(
//                                                   AppImages.document,
//                                                   height: 35.h,
//                                                   width: 35.w,
//                                                 )
//                                               : provider.presentationDataList[index].fileName!.contains("png")
//                                                   ? Image.asset(
//                                                       AppImages.photo,
//                                                       height: 35.h,
//                                                       width: 35.w,
//                                                     )
//                                                   : provider.presentationDataList[index].fileName!.contains("mp4")
//                                                       ? SvgPicture.asset(
//                                                           AppImages.video,
//                                                           height: 35.h,
//                                                           width: 35.w,
//                                                         )
//                                                       : provider.presentationDataList[index].fileName!.contains("pdf")
//                                                           ? SvgPicture.asset(AppImages.pdfLib)
//                                                           : SvgPicture.asset(AppImages.musicIcon),
//                                           Column(
//                                             crossAxisAlignment: CrossAxisAlignment.start,
//                                             children: [
//                                               Text(
//                                                 provider.presentationDataList[index].fileName == null
//                                                     ? provider.presentationDataList[index].folderName.toString()
//                                                     : provider.presentationDataList[index].fileName.toString(),
//                                                 style: w500_14Poppins(color: Colors.white),
//                                               ),
//                                               5.h.height,
//                                               Text(
//                                                 "sdkjskj",
//                                                 style: w400_14Poppins(color: Theme.of(context).primaryColorLight),
//                                               )
//                                             ],
//                                           ),
//                                         ],
//                                       ),
//                                       GestureDetector(
//                                           onTap: () {
//                                             showModalBottomSheet(
//                                                 isScrollControlled: true,
//                                                 isDismissible: false,
//                                                 backgroundColor: Theme.of(context).scaffoldBackgroundColor,
//                                                 shape: RoundedRectangleBorder(borderRadius: BorderRadius.only(topRight: Radius.circular(24.r), topLeft: Radius.circular(24.r))),
//                                                 context: context,
//                                                 builder: (context) {
//                                                   return moreBottomSheet();
//                                                 });
//                                           },
//                                           child: Icon(Icons.more_vert_rounded, color: Theme.of(context).primaryColorLight))
//                                     ],
//                                   ),
//                                 ),
//                               ),
//                             );
//                           })),
//                   5.h.height,

//                   // provider.libraryDropdownSelectedItem == ConstantsStrings.presentationFiles ? const SizedBox.shrink() : StartAndEndDate(provider: provider),
//                   // if (provider.libraryDropdownSelectedItem != ConstantsStrings.presentationFiles) height10,
//                   // provider.libraryDropdownSelectedItem == ConstantsStrings.template
//                   //     ? LibraryTemplates(provider: provider)
//                   //     : provider.libraryDropdownSelectedItem == ConstantsStrings.presentationFiles
//                   //         ? PresentationFiles(provider: provider)
//                   //         : const MeetingHistory(),
//                   // height10,
//                 ]),
//               ),
//             )),
//           ),
//         ),
//       );
//     });
//   }

//   moreBottomSheet() {
//     return Padding(
//       padding: const EdgeInsets.all(8.0),
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         mainAxisAlignment: MainAxisAlignment.start,
//         mainAxisSize: MainAxisSize.min,
//         children: [
//           Align(
//             alignment: Alignment.center,
//             child: Container(
//               height: 5.h,
//               width: 100.w,
//               decoration: BoxDecoration(borderRadius: BorderRadius.circular(20.r), color: Color(0xff202223)),
//             ),
//           ),
//           25.h.height,
//           Row(
//             mainAxisAlignment: MainAxisAlignment.spaceBetween,
//             children: [
//               Text(
//                 "Details",
//                 style: w500_14Poppins(color: Colors.white),
//               ),
//               GestureDetector(
//                 onTap: () {
//                   Navigator.pop(context);
//                 },
//                 child: Container(
//                   decoration: BoxDecoration(
//                     shape: BoxShape.circle,
//                     color: Theme.of(context).primaryColorLight,
//                   ),
//                   child: Padding(
//                     padding: const EdgeInsets.all(4.0),
//                     child: Icon(
//                       Icons.close,
//                       size: 12,
//                       color: Theme.of(context).scaffoldBackgroundColor,
//                     ),
//                   ),
//                 ),
//               ),
//             ],
//           ),
//           Divider(),
//           Row(
//             children: [SvgPicture.asset(AppImages.pdf), 5.w.width, Text("kshjdjfjfjhfhh")],
//           ),
//           10.h.height,
//           Row(
//             children: [
//               Container(
//                 width: 175.w,
//                 decoration: BoxDecoration(borderRadius: BorderRadius.circular(8), color: Color(0xff202223)),
//                 child: Padding(
//                   padding: const EdgeInsets.all(8.0),
//                   child: Row(
//                     children: [
//                       Icon(Icons.remove_red_eye_outlined, color: Theme.of(context).primaryColorLight),
//                       4.w.width,
//                       Text(
//                         "Edit",
//                         style: w400_12Poppins(color: Theme.of(context).primaryColorLight),
//                       )
//                     ],
//                   ),
//                 ),
//               ),
//               8.w.width,
//               Container(
//                 width: 175.w,
//                 decoration: BoxDecoration(borderRadius: BorderRadius.circular(8), color: Color(0xff202223)),
//                 child: Padding(
//                   padding: const EdgeInsets.all(8.0),
//                   child: Row(
//                     children: [
//                       Icon(Icons.file_download_outlined, color: Theme.of(context).primaryColorLight),
//                       4.w.width,
//                       Text("Download", style: w400_12Poppins(color: Theme.of(context).primaryColorLight))
//                     ],
//                   ),
//                 ),
//               )
//             ],
//           ),
//           5.h.height,
//           Row(children: [
//             Container(
//               width: 175.w,
//               decoration: BoxDecoration(borderRadius: BorderRadius.circular(8), color: Color(0xff202223)),
//               child: Padding(
//                 padding: const EdgeInsets.all(8.0),
//                 child: Row(
//                   children: [
//                     Icon(Icons.delete_outline_outlined, color: Theme.of(context).primaryColorLight),
//                     4.w.width,
//                     Text("Delete", style: w400_12Poppins(color: Theme.of(context).primaryColorLight))
//                   ],
//                 ),
//               ),
//             ),
//             8.w.width,
//             Container(
//                 width: 175.w,
//                 decoration: BoxDecoration(borderRadius: BorderRadius.circular(8), color: Color(0xff202223)),
//                 child: Padding(
//                   padding: const EdgeInsets.all(8.0),
//                   child: Row(
//                     children: [Icon(Icons.edit, color: Theme.of(context).primaryColorLight), 4.w.width, Text("Rename", style: w400_12Poppins(color: Theme.of(context).primaryColorLight))],
//                   ),
//                 ))
//           ]),
//           Divider(),
//           Text(
//             "Type",
//             style: w400_12Poppins(color: Theme.of(context).primaryColorLight),
//           ),
//           5.h.height,
//           Text(
//             "Type",
//             style: w400_14Poppins(color: Theme.of(context).hintColor),
//           ),
//           10.h.height,
//           Text(
//             "Size",
//             style: w400_12Poppins(color: Theme.of(context).primaryColorLight),
//           ),
//           5.h.height,
//           Text(
//             "Type",
//             style: w400_14Poppins(color: Theme.of(context).hintColor),
//           ),
//           10.h.height,
//           Text(
//             "Date Created",
//             style: w400_12Poppins(color: Theme.of(context).primaryColorLight),
//           ),
//           5.h.height,
//           Text(
//             "Type",
//             style: w400_14Poppins(color: Theme.of(context).hintColor),
//           ),
//           10.h.height,
//           Text(
//             "Date Modified",
//             style: w400_12Poppins(color: Theme.of(context).primaryColorLight),
//           ),
//           5.h.height,
//           Text(
//             "Type",
//             style: w400_14Poppins(color: Theme.of(context).hintColor),
//           ),
//           10.h.height,
//         ],
//       ),
//     );
//   }
// }
