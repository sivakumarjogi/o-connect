import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:o_connect/core/local_db/hive_database_helper.dart';

/// Helper class to save user information locally on the device
class UserStateHiveHelper {
  UserStateHiveHelper.__internal();

  static final UserStateHiveHelper _instance = UserStateHiveHelper.__internal();

  static UserStateHiveHelper get instance => _instance;

  /// Method used to open user box [Boxes.userBox]
  /// Box is opened only when hive is initialized
  /// Hive already initialized in [main.dart] file
  /// inside main method before [runApp] method is called
  Future<Box<dynamic>> _openHiveBox() async {
    try {
      return await Hive.openBox(
        Boxes.userBox,
        encryptionCipher:
            HiveAesCipher(SecureStorageHelper.instance.decodedKey),
      );
    } catch (e) {
      /// If hive db gives some error then it is initialized and open again
      /// and generate again encryption key for encrypted hive box
      await HiveHelper.initializeHiveAndRegisterAdapters();
      await SecureStorageHelper.instance.generateEncryptionKey();
      return await Hive.openBox(
        Boxes.userBox,
        encryptionCipher:
            HiveAesCipher(SecureStorageHelper.instance.decodedKey),
      );
    }
  }

  /// Method used to close hive box [Boxes.userBox]
  Future<void> close() async {
    _openHiveBox().then((box) {
      box.close();
    });
  }

  /// Method used to set user is logged in inside the box [Boxes.userBox]
  Future<void> setLogin() async {
    final Box<dynamic> encryptedBox = await _openHiveBox();
    encryptedBox.put(UserStateKeys.loggedIn, true);
  }

  /// Method used to check user is logged in or not from the box [Boxes.userBox]
  Future<bool> isLoggedIn() async {
    final Box<dynamic> encryptedBox = await _openHiveBox();
    final loggedIn = encryptedBox.get(UserStateKeys.loggedIn);
    return loggedIn ?? false;
  }

  /// Method used to logout and delete data from the box [Boxes.userBox]
  Future<void> logOut() async {
    final Box<dynamic> encryptedBox = await _openHiveBox();
    encryptedBox.put(UserStateKeys.loggedIn, false);
    await _deleteUser();
  }

  /// Method used deleting data from the box [Boxes.userBox]
  Future<void> _deleteUser() async {
    final Box<dynamic> encryptedBox = await _openHiveBox();
    // encryptedBox.clear();
    encryptedBox.delete(UserStateKeys.loggedIn);
    // encryptedBox.delete(Boxes.accessToken);
    SecureStorageHelper.instance.deleteAccessToken();
    encryptedBox.delete(UserStateKeys.userData);
    encryptedBox.delete(UserStateKeys.ongoingAndNextReservation);
    return;
  }

  /// Method used to set access token inside box [Boxes.userBox]
  Future<void> setAccessToken(String? accessToken) async {
    await SecureStorageHelper.instance.setAccessToken(accessToken);

  }

  /// Method used to get access token from the box [Boxes.userBox]
  Future<String> getAccessToken() async {
    final accessToken = await SecureStorageHelper.instance.getAccessToken();
    return accessToken ?? "";
  }

  /// Method used to check user is logged in or not from the box [Boxes.userBox]
  Future<void> setLocale(Locale locale) async {
    final Box<dynamic> encryptedBox = await _openHiveBox();
    encryptedBox.put(UserStateKeys.languageCode, locale.languageCode);
  }


  Future getLocale() async {
    final Box<dynamic> encryptedBox = await _openHiveBox();
    final languageCode = encryptedBox.get(UserStateKeys.languageCode);
    return languageCode;
  }


}
