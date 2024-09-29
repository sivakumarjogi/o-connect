import 'dart:async';

import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:o_connect/core/local_db/hive_database_helper.dart';
import 'package:o_connect/o_connect_app.dart';
import 'package:o_connect/ui/utils/styles/styles.dart';

import 'core/service_locator.dart';

Future<void> main() async {
  runZonedGuarded(() async {
    /// Initialize the WidgetFlutterBinding if required
    WidgetsFlutterBinding.ensureInitialized();

    /// Used to initialize hive db and register adapters and generate encryption
    /// key for encrypted hive box
    await HiveHelper.initializeHiveAndRegisterAdapters();
    await SecureStorageHelper.instance.generateEncryptionKey();
    await Firebase.initializeApp();

    /// Ensuring Size of the phone in UI Design
    await ScreenUtil.ensureScreenSize();

    /// Sets the device orientation of application
    AppStyles.setDeviceOrientationOfApp();

    /// Sets the server config of application
    await setUpServiceLocator();

    /// Runs the application in its own error zone
    runApp(const OConnectApp());
  }, (error, stack) {
    debugPrint("Error while launching application $error && $stack");
  });
}
