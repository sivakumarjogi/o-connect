// import 'package:flutter/material.dart';
// import 'package:flutter_screenutil/flutter_screenutil.dart';
// import 'package:flutter_svg/svg.dart';
// import 'package:o_connect/core/providers/all_participants_provider.dart';
// import 'package:provider/provider.dart';
//
// import '../../../../utils/colors/colors.dart';
// import '../../../../utils/constant_strings.dart';
// import '../../../../utils/images/images.dart';
// import '../../../../utils/textfield_helper/app_fonts.dart';
//
// class AllParticipantsPopUp extends StatelessWidget {
//   AllParticipantsPopUp({Key? key}) : super(key: key);
//
//   List<AllParticipantsModel> listData = [
//     AllParticipantsModel(
//         name: ConstantsStrings.host, imagePath: AppImages.host),
//     AllParticipantsModel(
//         name: ConstantsStrings.makeCoHost, imagePath: AppImages.cohost),
//     AllParticipantsModel(
//         name: ConstantsStrings.presenter, imagePath: AppImages.presenter),
//     AllParticipantsModel(
//         name: ConstantsStrings.makeAttendee, imagePath: AppImages.attendee),
//     AllParticipantsModel(
//         name: ConstantsStrings.pinAttendee, imagePath: AppImages.pinned),
//     AllParticipantsModel(
//         name: ConstantsStrings.micOnOff, imagePath: AppImages.mic_off),
//     AllParticipantsModel(
//         name: ConstantsStrings.videoOnOff, imagePath: AppImages.video_off),
//     AllParticipantsModel(
//         name: ConstantsStrings.privateChat, imagePath: AppImages.private_chat),
//     AllParticipantsModel(
//         name: ConstantsStrings.timer, imagePath: AppImages.timer),
//     AllParticipantsModel(
//         name: ConstantsStrings.block, imagePath: AppImages.block),
//     AllParticipantsModel(
//         name: ConstantsStrings.removeFromMeeting, imagePath: AppImages.cross),
//   ];
//
//   @override
//   Widget build(BuildContext context) {
//     return Consumer<AllParticipantProvider>(
//         builder: (context, provider, child) {
//       return Column(
//         children: [
//           Expanded(
//             child: Column(mainAxisSize: MainAxisSize.min, children: [
//               height10,
//               Align(
//                 alignment: Alignment.center,
//                 child: Container(
//                   height: 5.h,
//                   width: 50.w,
//                   decoration: BoxDecoration(
//                       borderRadius: BorderRadius.circular(15.r),
//                       color: Theme.of(context).hintColor),
//                 ),
//               ),
//               height10,
//               Container(
//                 color: Theme.of(context).primaryColor,
//                 child: Padding(
//                   padding: EdgeInsets.all(8.0.sp),
//                   child: Row(
//                     mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                     children: [
//                       Row(
//                         children: [
//                           Stack(
//                             alignment: Alignment.topLeft,
//                             children: <Widget>[
//                               Container(
//                                 height: 40.h,
//                                 width: 40.w,
//                                 decoration: const BoxDecoration(
//                                   image: DecorationImage(
//                                     image: AssetImage(
//                                       AppImages.imageIcon,
//                                     ),
//                                     fit: BoxFit.cover,
//                                   ),
//                                   shape: BoxShape.circle,
//                                 ),
//                               ),
//                               Container(
//                                 height: 15,
//                                 width: 15,
//                                 decoration: const BoxDecoration(
//                                   shape: BoxShape.circle,
//                                   color: Colors.white,
//                                 ),
//                                 padding: EdgeInsets.all(3.sp),
//                                 child: Container(
//                                   decoration: const BoxDecoration(
//                                       shape: BoxShape.circle,
//                                       color: Colors.red),
//                                 ),
//                               ),
//                             ],
//                           ),
//                           width20,
//                           Column(
//                             crossAxisAlignment: CrossAxisAlignment.start,
//                             children: [
//                               Text(
//                                 "Elenaor",
//                                 style: w400_16Poppins(
//                                     color: Theme.of(context).hintColor),
//                               ),
//                               Text(
//                                 "santhosh@gmail.com",
//                                 style: w300_14Poppins(
//                                     color: Theme.of(context).disabledColor),
//                               ),
//                             ],
//                           )
//                         ],
//                       ),
//                       Padding(
//                         padding: EdgeInsets.only(right: 10.w),
//                         child: Column(
//                           children: [
//                             SvgPicture.asset(AppImages.flag),
//                             height5,
//                             Text(
//                               "USA",
//                               style: w400_12Poppins(
//                                   color: Theme.of(context).hintColor),
//                             )
//                           ],
//                         ),
//                       ),
//                     ],
//                   ),
//                 ),
//               ),
//               height20,
//               Expanded(
//                 child: ListView.separated(
//                   shrinkWrap: true,
//                   itemCount: listData.length,
//                   itemBuilder: (context, index) {
//                     return Padding(
//                       padding: EdgeInsets.all(8.0.sp),
//                       child: Row(
//                         children: [
//                           SvgPicture.asset(listData[index].imagePath,
//                               height: 24.w,
//                               width: 24.w,
//                               color: Theme.of(context).hintColor),
//                           width20,
//                           Text(
//                             listData[index].name,
//                             style: w400_14Poppins(
//                                 color: Theme.of(context).hintColor),
//                           ),
//                         ],
//                       ),
//                     );
//                   },
//                   separatorBuilder: (BuildContext context, int index) {
//                     return Divider(
//                       color: Theme.of(context).primaryColor,
//                       thickness: 1,
//                     );
//                   },
//                 ),
//               )
//             ]),
//           ),
//           height20,
//           GestureDetector(
//             onTap: () {
//               Navigator.pop(context);
//             },
//             child: Center(
//               child: Text(
//                 ConstantsStrings.cancel,
//                 style: w500_16Poppins(color: AppColors.blueColor),
//               ),
//             ),
//           )
//         ],
//       );
//     });
//   }
// }
//
// class AllParticipantsModel {
//   AllParticipantsModel({required this.name, required this.imagePath});
//
//   final String name;
//   final String imagePath;
// }
