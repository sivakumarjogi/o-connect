// import 'package:dropdown_button2/dropdown_button2.dart';
// import 'package:flutter/material.dart';
// import 'package:o_connect/ui/utils/constant_strings.dart';

// class DropDownHelper extends StatefulWidget {
//    DropDownHelper({required this.selectedValue,required this.dropDownItems,Key? key}) : super(key: key);
//    String selectedValue;
//    List<DropdownMenuItem<String>> dropDownItems;
//    @override
//    State<DropDownHelper> createState() => _DropDownHelperState();
// }

// class _DropDownHelperState extends State<DropDownHelper> {
//   @override
//   Widget build(BuildContext context) {
//     return DropdownButtonHideUnderline(
//       child: DropdownButton2(
//         isExpanded: true,
//         underline: const SizedBox(),
//         disabledHint: const Padding(
//           padding: EdgeInsets.all(8.0),
//           child: Text(
//             ConstantsStrings.selectTemplate,
//             style: TextStyle(color: Colors.black87),
//           ),
//         ),
//         value: widget.selectedValue,
//         items: widget.dropDownItems,
//         onChanged: (newValue) {
//           setState(() {
//             widget.selectedValue = newValue!;
//           });
//         },
//       ),
//     );
//   }
// }
