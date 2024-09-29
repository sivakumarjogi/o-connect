import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:o_connect/core/service/api_constants.dart';


enum ConnectivityStatus {
  wifi,
  cellular,
  offline
}

//Internet Connectivity
class NetworkConnection {
  NetworkConnection.__internal();
  static final NetworkConnection _instance = NetworkConnection.__internal();
  static NetworkConnection get instance => _instance;

  Future<bool> checkInternetConnection() async {
    bool checkConnection;
    try {
      final result = await InternetAddress.lookup(ApiConstants.googleLink).timeout(const Duration(seconds: 5));
      if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
        checkConnection = true;
      }else{
        checkConnection = false;
      }
    } on TimeoutException catch(_) {
      checkConnection = false;
    } on SocketException catch (_) {
      checkConnection = false;
    } catch (e){
      checkConnection = false;
    }
    return checkConnection;
  }

}

