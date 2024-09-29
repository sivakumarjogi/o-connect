// import 'package:flutter/material.dart';
// import 'package:o_connect/core/providers/common_provider.dart';
// import 'package:o_connect/ui/utils/constant_strings.dart';
// import 'package:o_connect/ui/utils/images/images.dart';
// import 'package:provider/provider.dart';

// class MiniAudioPlayer extends StatelessWidget {
//   const MiniAudioPlayer({
//     super.key,
//   });

//   @override
//   Widget build(BuildContext context) {
//     return  Consumer<CommonProvider>(
//                       builder: (context, commonProvider, child) {
//                     return Container(
//         height: MediaQuery.of(context).size.height * 0.04,
//         width: MediaQuery.of(context).size.width * 0.45,
//         decoration: const BoxDecoration(
//           borderRadius: BorderRadius.all(Radius.circular(20)),
//         ),
//         child: Row(crossAxisAlignment: CrossAxisAlignment.center, children: [
//           Expanded(
//             child: Container(
//               height: MediaQuery.of(context).size.height * 0.04,
//               decoration: const BoxDecoration(
//                   borderRadius: BorderRadius.only(
//                       topLeft: Radius.circular(16),
//                       bottomLeft: Radius.circular(16)),
//                   color: Colors.blue),
//               child: Row(
//                 crossAxisAlignment: CrossAxisAlignment.center,
//                 mainAxisAlignment: MainAxisAlignment.spaceAround,
//                 children: [
//                   const Icon(
//                     Icons.menu,
//                     color: Colors.white,
//                   ),
//                   Image.asset(
//                     AppImages.waveAudioGif,
//                   ),
//                 ],
//               ),
//             ),
//           ),
//           Expanded(
//             child: Container(
//               height: MediaQuery.of(context).size.height * 0.04,
//               decoration: const BoxDecoration(
//                   borderRadius: BorderRadius.only(
//                       topRight: Radius.circular(16),
//                       bottomRight: Radius.circular(16)),
//                   color: Colors.white),
//               child: Row(
//                 crossAxisAlignment: CrossAxisAlignment.center,
//                 mainAxisAlignment: MainAxisAlignment.spaceAround,
//                 children: [
//                   const Text(
//                     ConstantsStrings.wow,
//                   ),
//                  InkWell(
//                       child: const Icon(
//                         Icons.cancel,
//                         color: Colors.red,
//                       ),
//                       onTap: () {
//                         commonProvider.miniPlayerController();
                      
//                   })
//                 ],
//               ),
//             ),
//           ),
//         ]),
//       );}
//     );
//   }
// }
