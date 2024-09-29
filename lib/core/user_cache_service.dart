// ignore_for_file: constant_identifier_names

import 'dart:developer';

import 'package:shared_preferences/shared_preferences.dart';

import '../core/service_locator.dart';

const String TOKEN = 'tokencache';
const String OConnectToken = 'oConnectTokenCache';
const String OConecctRefressToken = 'oConnectRefressTokenCache';

const String CUSTOMERACCOUNTID = 'customeraccountid';
const String LOGINSTATUS = 'loginStatus';
const String SEENSLIDERSCREENS = "seenSliderScreens";

class UserCacheService {
  String? _token;

  String? get token => _token;
  String? _oConnectToken;
  String? _oConnectRefressToken;
  String? _customerAccountId;

  String? get customerAccountId => _customerAccountId;
  String? initialTheme;
  String? initialLocale;

  SharedPreferences get sharedPrefs => serviceLocator<SharedPreferences>();
  bool? isFirstLogin;

  ///[Token]
  Future<bool> saveToken(String token) async {
    bool saved = await sharedPrefs.setString(TOKEN, token);
    if (saved) {
      _token = await getToken();
    }
    return saved;
  }

  ///[OConnectToken]
  Future<bool> saveOConnectToken(String token) async {
    bool saved = await sharedPrefs.setString(OConnectToken, token);
    if (saved) {
      _oConnectToken = await getOConnectToken();
    }
    return saved;
  }

  ///Oconnect refress token
  Future<bool> saveOConnectRefressToken(String token) async {
    bool saved = await sharedPrefs.setString(OConecctRefressToken, token);
    if (saved) {
      _oConnectRefressToken = await getOConectRefreshToken();
    }
    return saved;
  }

  Future<String?> getOConnectToken() async {
    String tkn;
    var token = sharedPrefs.getString(OConnectToken);
    if (token == null) {
      tkn = '';
      return null;
    }
    tkn = token;
    _oConnectToken = tkn;
    return _oConnectToken;
  }

  Future<String?> getOConectRefreshToken() async {
    String tkn;
    var token = sharedPrefs.getString(OConecctRefressToken);
    if (token == null) {
      tkn = '';
      return null;
    }
    tkn = token;
    _oConnectRefressToken = tkn;

    return _oConnectRefressToken;
  }

  Future<String?> getToken() async {
    String tkn;
    var token = sharedPrefs.getString(TOKEN);
    if (token == null) {
      tkn = '';
      return null;
    }
    tkn = token;
    _token = tkn;
    log("$_token");
    return _token;
  }

  Future<bool> deleteToken() async {
    _token = null;
    return await sharedPrefs.remove(TOKEN);
  }

  ///[Customer Account Id]
  Future<bool> saveCustomerAccounntId(String id) async {
    bool saved = await sharedPrefs.setString(CUSTOMERACCOUNTID, id);
    if (saved) {
      _customerAccountId = await getCustomerAccountId();
    }
    return saved;
  }

  Future<String?> getCustomerAccountId() async {
    String id;
    var cid = sharedPrefs.getString(CUSTOMERACCOUNTID);
    if (cid == null) {
      id = '';
      return null;
    }
    id = cid;
    _customerAccountId = id;
    log("$_customerAccountId");
    return _customerAccountId;
  }

  Future<bool> clearAll() async {
    return await sharedPrefs.clear();
  }

  Future saveUserData(key, value) async {
    return await sharedPrefs.setString(key, value);
  }

  Future saveProfileD(key, value) async {
    return await sharedPrefs.setString(key, value);
  }

  Future<String?> getUserData(key) async {
    return sharedPrefs.getString(key);
  }

  Future<void> seenSliderScreens({bool value = false}) async {
    await sharedPrefs.setBool(SEENSLIDERSCREENS, value);
    print("the value ${sharedPrefs.getBool(SEENSLIDERSCREENS)}");
  }

  bool? getSliderScreenVisibilityValue() {
    return sharedPrefs.getBool(SEENSLIDERSCREENS);
  }
}
