// import 'dart:async';

// import 'package:flutter/material.dart';
// import 'package:o_connect/ui/utils/constant_strings.dart';
// import 'package:o_connect/ui/views/drawer/drawer_viewmodel.dart';
// import 'package:o_connect/ui/views/home_screen/home_screen_provider/home_screen_provider.dart';
// import 'package:o_connect/ui/views/webinar_details/webinar_details_provider/webinar_details_provider.dart';
// import 'package:o_connect/ui/utils/common_app_bar/common_appbar.dart';
// import 'package:o_connect/ui/views/drawer/custom_drawer_view.dart';
// import 'package:provider/provider.dart';
// import 'webinar_details_view.dart';

// class WebinarPage extends StatefulWidget {
//   const WebinarPage({super.key});

//   @override
//   State<WebinarPage> createState() => _WebinarPageState();
// }

// class _WebinarPageState extends State<WebinarPage> with TickerProviderStateMixin {
//   WebinarDetailsProvider? webinarDetailsProvider;
//   GlobalKey refreshKey = GlobalKey<RefreshIndicatorState>();

//   @override
//   void initState() {
//     super.initState();
//   }

//   Future _onRefresh() async {
//     FocusNode().unfocus();
//     Completer completer = Completer();
//     await Future.delayed(const Duration(seconds: 2)).then((value) {
//       print("Refresh data ==========> ");

//       // Provider.of<HomeScreenProvider>(context, listen: false)
//       //     .searchController
//       //     .text = "";
//       Provider.of<HomeScreenProvider>(context, listen: false).getMeetings(context);
//       completer.complete();
//     });
//     return completer.future;
//   }

//   @override
//   void dispose() {
//     super.dispose();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return WillPopScope(
//       onWillPop: () async {
//         Provider.of<DrawerViewModel>(context, listen: false).mainSelectedChange(ConstantsStrings.home);

//         return true;
//       },
//       child: Scaffold(
//           key: UniqueKey(),
//           backgroundColor: Theme.of(context).scaffoldBackgroundColor,
//           resizeToAvoidBottomInset: false,
        
//           appBar: commonAppBar(context,titleName: "Webinar"),
//           body: RefreshIndicator(
//             key: refreshKey,
//             onRefresh: _onRefresh,
//             child:  WebinarDetails(),
//           )),
//     );
//   }
// }
