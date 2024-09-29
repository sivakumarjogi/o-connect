import 'dart:async';

import 'package:firebase_dynamic_links/firebase_dynamic_links.dart';
import 'package:flutter/material.dart';
import 'package:o_connect/my_app.dart';
import 'package:o_connect/core/provider_registration.dart';

import 'package:provider/provider.dart';

class OConnectApp extends StatefulWidget {
  const OConnectApp({
    super.key,
  });

  @override
  State<OConnectApp> createState() => _OConnectAppState();
}

class _OConnectAppState extends State<OConnectApp> with WidgetsBindingObserver {
  final String _tag = "MyApp:";
  final String _locale = "en";

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addObserver(this);
    /* SchedulerBinding.instance.addPostFrameCallback((timeStamp) {
      provider = Provider.of<ThemeProvider>(context,listen: false);
    });*/
  }

  @override
  void dispose() {
    /// Remove observer before widget dispose
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  /// State called after initState and also called every time when any
  /// dependency is changes like language
  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    super.didChangeAppLifecycleState(state);
    debugPrint("$_tag AppLifecycleState ===> $state");
    _handleAppLifecycleState(state);
  }

  Future<void> _handleAppLifecycleState(AppLifecycleState state) async {
    switch (state) {
      case AppLifecycleState.paused:

        /// Do something when app goes in background state
        break;
      case AppLifecycleState.resumed:
        print("Do something when app opens from background state");

        /// Do something when app opens from background state

        break;
      case AppLifecycleState.inactive:

        /// Do something when app goes in minimized state
        break;
      case AppLifecycleState.detached:

        /// Do something when app goes in killed state
        break;
      default:

        /// Do nothing
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    return _oConnectMaterialApp(context);
  }

  /// Method used to return go share material app
  Widget _oConnectMaterialApp(BuildContext context) {
    return MultiProvider(
      providers: RegisterProviders.providers(context),
      child: const OnBoardingScreen(),
    );
  }
}
