
// import 'package:flutter/material.dart';
// import 'package:o_connect/ui/utils/textfield_helper/app_fonts.dart';


// class AlterDialogBox {
//   static showAlertDialog(
//       {required BuildContext context, required String descriptionText, String? continueButtonText, required VoidCallback onTap}) {

//     /// Cancel Button
//     Widget cancelButton = TextButton(
//       child: Text(
//         "Cancel",
//         style: w500_14Poppins(color: Colors.blueAccent),
//       ),
//       onPressed: () {
//         Navigator.pop(context);
//       },
//     );
//     /// Continue Button
//     Widget continueButton = TextButton(
//       onPressed: onTap,
//       child:Text(
//         continueButtonText ?? "Continue",
//         style: w500_14Poppins(color: Colors.blueAccent),
//       )
//     );
//     ///set up the AlertDialog
//     AlertDialog alert = AlertDialog(
//       shape:  RoundedRectangleBorder(
//           borderRadius: BorderRadius.circular(20),
//           side: const BorderSide(color: Colors.transparent)),
//       content: Container(
//       decoration: BoxDecoration(
//         color: Colors.grey,
//         borderRadius: BorderRadius.circular(8.0),
//       ),
//       padding: const EdgeInsets.all(24.0),
//       child: FlipCountdownClock(
//         duration: const Duration(minutes: 1),
//         digitSize: 50.0,
//         width: 46.0,
//         height: 62.0,
//         digitColor: Colors.white,
//         backgroundColor: Colors.grey,
//         separatorColor: Colors.black,
//         borderColor: Colors.grey,
//         hingeColor: Colors.black87,
//         borderRadius: const BorderRadius.all(Radius.circular(8.0)),
//         onDone: () => print('Buzzzz!'),
//       ),
//     ),
//       actions: [
//         cancelButton,
//         continueButton,
//       ],
//     );

//     /// Show Dialog Properties
//     showDialog(
//       context: context,
//       barrierDismissible: false,
//       builder: (BuildContext context) {
//         return alert;
//       },
//     );
//   }
// }

