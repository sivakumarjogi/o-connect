import 'package:flutter/material.dart';
import 'package:o_connect/ui/utils/internet_helper/internet_helper.dart';

class BaseProvider extends ChangeNotifier {
  /// Method used to check internet connection
  Future<bool> checkInternet() async {
    return await NetworkConnection.instance.checkInternetConnection();
  }

  /// Method used to notify for UI update
  void update() {
    notifyListeners();
  }
}
