import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_dynamic_links/firebase_dynamic_links.dart';
import 'package:flutter/material.dart';
import 'package:o_connect/core/providers/app_global_state_provider.dart';
import 'package:o_connect/ui/views/home_screen/home_screen_provider/home_screen_provider.dart';
import 'package:o_connect/ui/views/home_screen/home_screen_view/home_screen.dart';
import 'package:o_connect/ui/views/meeting/providers/meeting_room_provider.dart';
import 'package:provider/provider.dart';

class AppLifecycleManager extends StatefulWidget {
  final Widget child;

  const AppLifecycleManager({
    Key? key,
    required this.child,
  }) : super(key: key);

  @override
  _AppLifecycleManagerState createState() => _AppLifecycleManagerState();
}

class _AppLifecycleManagerState extends State<AppLifecycleManager> with WidgetsBindingObserver {
  String? path;

  @override
  void initState() {
    WidgetsBinding.instance.addObserver(this);
    // Provider.of<HomeScreenProvider>(context, listen: false).getDynamicLink(context);
    // context.read<HomeScreenProvider>().initDynamicLinks(context);
    //Provider.of<HomeScreenProvider>(navigationKey.currentState!.context, listen: false).initDynamicLinks(context);
    // super.initState();
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    debugPrint('state = $state');
    if (state == AppLifecycleState.resumed) {
      // context.read<HomeScreenProvider>().initDynamicLinks(context);
      // moveLink(context);
    } else if (state == AppLifecycleState.detached) {
      final isMeetingGoingOn = context.read<AppGlobalStateProvider>().isMeetingInProgress;
      if (isMeetingGoingOn) {
        context.read<MeetingRoomProvider>().leaveMeeting();
      }
    } else {
      // Provider.of<HomeScreenProvider>(navigationKey.currentState!.context,listen: false).initDynamicLinks(context);
    }
  }

  Future moveLink(BuildContext context) async {
    // if (context.mounted) {
    //   Navigator.push(context, MaterialPageRoute(builder: (context) => const HomeScreen(),));
    // }
    await Firebase.initializeApp();
    final PendingDynamicLinkData? initialLink = await FirebaseDynamicLinks.instance.getInitialLink();
    if (initialLink != null) {
      print("This is error >>> ${initialLink.link}");
    }

//this is when the app is in recent/background mode
    FirebaseDynamicLinks.instance.onLink.listen((dynamicLinkData) {
      print("This is error >>> ${dynamicLinkData.link}");
    }).onError((error) {
      print("This is error >>> "+error.message);
    });
    if (context.mounted) {
      Future.delayed(const Duration(seconds: 1),() {
        Provider.of<HomeScreenProvider>(context, listen: false).initDynamicLinks(context,null);

      },);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: widget.child,
    );
  }
}
