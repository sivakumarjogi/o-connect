import 'dart:convert';
import 'dart:io';

import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:hive/hive.dart';
import 'package:path_provider/path_provider.dart';



class HiveHelper {
  static Future<bool> initializeHiveAndRegisterAdapters() async {
    /// Do not edit this method until you need a new adapter
    try {
      Directory appDocDir = await getApplicationDocumentsDirectory();
      String dbFilePath = [appDocDir.path, 'o_mail_db'].join('/');
      Hive.init(dbFilePath);

      /// For every model that needs to be saved locally, an adapter is generated
      /// These adapter need to be registered
      // Hive.registerAdapter(UserAdapter());
      return true;
    } catch (e) {
      return false;
    }
  }
}

class SecureStorageHelper {
  SecureStorageHelper.__internal();

  static final SecureStorageHelper _instance = SecureStorageHelper.__internal();

  static SecureStorageHelper get instance => _instance;

  final FlutterSecureStorage secureStorage = const FlutterSecureStorage();
  final String _secureKey = 'secure_key';

  String? encryptionKey;
  List<int> decodedKey = [];

  /// Method used to secure decoded key for encrypting the box [Boxes.userBox][Boxes.userBox]
  Future<void> generateEncryptionKey() async {
    try {
      /// Decrypts and returns the value for the given key or null if key is not
      /// in the storage
      encryptionKey = await secureStorage.read(key: _secureKey);
      if (encryptionKey == null) {
        /// Generates a secure encryption key using the fortuna random algorithm
        final key = Hive.generateSecureKey();
        /// Encrypts and saves the key with the given value.
        /// If the key was already in the storage, its associated value is changed.
        /// If the value is null, deletes associated value for the given key.
        /// key shouldn't be null
        await secureStorage.write(
          key: _secureKey,
          value: base64UrlEncode(key),
        );
        /// Decrypts and returns the value for the given key
        encryptionKey = await secureStorage.read(key: _secureKey);
      }
      // /The input is decoded as if by [decoder.convert]
      decodedKey = base64Url.decode(encryptionKey!);

    } catch (e) {

    }
  }

  Future<void> setAccessToken(String? accessToken) async {
    await secureStorage.write(key: UserStateKeys.accessToken, value: accessToken);
  }

  Future<void> deleteAccessToken() async {
    await secureStorage.delete(key: UserStateKeys.accessToken);
  }

  Future<String?> getAccessToken() async {
    final accessToken = await secureStorage.read(key: UserStateKeys.accessToken);
    return accessToken ?? "";
  }
}

class UserStateKeys {
  static const String loggedIn = 'logged_in';
  static const String accessToken = 'access_token';
  static const String userData = 'user_data';
  static const String tipsVisited = 'tips_visited';
  static const String ongoingAndNextReservation = 'ongoing_and_next_reservation';
  static const String ongoingReservationId = 'ongoing_reservation_id';
  static const String ongoingReservationState = 'ongoing_reservation_state';
  static const String languageCode = 'language_code';
  static const String languageCountryCode = 'language_country_code';
}

class Boxes {
  static const String userBox = 'user_box';
  static const String analyticsBox = 'analytics_box';
  static const String apiBox = 'api_box';
}

class HiveTypes {
  static const int user = 0;
}
