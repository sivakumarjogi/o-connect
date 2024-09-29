import 'dart:async';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:device_preview/device_preview.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:o_connect/core/providers/theme_provider.dart';
import 'package:o_connect/core/routes/routes_name.dart';
import 'package:o_connect/ui/utils/textfield_helper/app_fonts.dart';
import 'package:o_connect/ui/views/home_screen/home_screen_provider/home_screen_provider.dart';
import 'package:provider/provider.dart';
import 'applifecycle_manager.dart';

class OnBoardingScreen extends StatefulWidget {
  const OnBoardingScreen({
    Key? key,
  }) : super(key: key);

  @override
  State<OnBoardingScreen> createState() => _OnBoardingScreenState();
}

class _OnBoardingScreenState extends State<OnBoardingScreen> {
  final NetworkConnectivityListener connectivityListener = NetworkConnectivityListener();

  HomeScreenProvider? homeScreenProvider;

  @override
  void initState() {
    homeScreenProvider = Provider.of<HomeScreenProvider>(context, listen: false);
    connectivityListener.startListening(_handleConnectivityChange);
    super.initState();
    // homeScreenProvider?.initDynamicLinks(context);
  }

  @override
  void dispose() {
    connectivityListener.stopListening();
    super.dispose();
  }

  Future<void> _handleConnectivityChange(ConnectivityResult result) async {
    // Handle network connectivity changes here

    if (result == ConnectivityResult.none) {
      scaffoldKey.currentState!.showSnackBar(
        SnackBar(

          content: Row(
            children: [
              const Icon(Icons.wifi, size: 24),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      "No connection",
                      style: w400_14Poppins(color: Colors.white),
                    ),
                    Text(
                      "Please check your internet",
                      style: w400_14Poppins(color: Colors.white),
                    ),
                  ],
                ),
              ),
            ],
          ),
          margin: const EdgeInsets.all(16.0),
          elevation: 0,
          behavior: SnackBarBehavior.floating,
          duration: const Duration(days: 1),
          backgroundColor: Colors.red,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        ),
      );
    } else {
      if (scaffoldKey.currentState != null && scaffoldKey.currentState!.mounted) {
        scaffoldKey.currentState!.removeCurrentSnackBar();
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return DevicePreview(
      enabled: false,
      tools: const [
        ...DevicePreview.defaultTools,
      ],
      builder: (context) => AppLifecycleManager(
        child: MaterialApp(
          scrollBehavior: MyBehavior(),
          navigatorKey: navigationKey,
          scaffoldMessengerKey: scaffoldKey,
          navigatorObservers: [routeObserver],

          onGenerateRoute: (RouteSettings setting) {
            return RoutesManager.generateRoute(setting);
          },
          builder: (
            BuildContext context,
            Widget? child,
          ) {
            ScreenUtil.init(context, designSize: const Size(375, 812));
            return MediaQuery(
              data: MediaQuery.of(context).copyWith(textScaler: const TextScaler.linear(1)),
              child: child!,
            );
          },
          theme: context.watch<ThemeProvider>().appTheme,
          debugShowCheckedModeBanner: false,
          initialRoute: RoutesManager.splashScreen,

          // navigatorObservers: const <NavigatorObserver>[],
        ),
      ),
    );
  }
}

class MyBehavior extends ScrollBehavior {
  @override
  Widget buildOverscrollIndicator(BuildContext context, Widget child, ScrollableDetails details) {
    return child;
  }
}

final navigationKey = GlobalKey<NavigatorState>();
final RouteObserver<ModalRoute<Object?>> routeObserver = RouteObserver<ModalRoute<Object?>>();

final GlobalKey<ScaffoldMessengerState> scaffoldKey = GlobalKey();

class NetworkConnectivityListener {
  StreamSubscription<ConnectivityResult>? subscription;

  void startListening(void Function(ConnectivityResult) onConnectivityChanged) {
    subscription = Connectivity().onConnectivityChanged.listen(onConnectivityChanged);
  }

  void stopListening() {
    subscription?.cancel();
  }
}
