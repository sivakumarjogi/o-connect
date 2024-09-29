// import 'package:flutter/material.dart';
// import 'package:flutter_screenutil/flutter_screenutil.dart';
// import 'package:o_connect/core/providers/calender_provider.dart';
// import 'package:o_connect/ui/utils/constant_strings.dart';
// import 'package:o_connect/ui/utils/textfield_helper/common_textfield.dart';
// import 'package:o_connect/ui/views/drawer/calender/widgets/events_card.dart';
// import 'package:provider/provider.dart';
//
// import '../../../../utils/textfield_helper/app_fonts.dart';
//
// class UpcomingCompleteCancelledTabView extends StatefulWidget {
//   const UpcomingCompleteCancelledTabView({super.key});
//
//   @override
//   State<UpcomingCompleteCancelledTabView> createState() =>
//       _UpcomingCompleteCancelledTabViewState();
// }
//
// class _UpcomingCompleteCancelledTabViewState
//     extends State<UpcomingCompleteCancelledTabView> {
//   TextEditingController searchController = TextEditingController();
//
//   @override
//   Widget build(BuildContext context) {
//     return Consumer<CalenderProvider>(
//       builder: (context, cp, child) {
//         return Column(
//           mainAxisAlignment: MainAxisAlignment.spaceBetween,
//           mainAxisSize: MainAxisSize.min,
//           children: [
//
//              const EventsCard(type: 1),
//           ],
//         );
//       },
//     );
//   }
// }
