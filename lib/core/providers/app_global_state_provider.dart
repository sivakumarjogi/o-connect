import 'dart:async';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:o_connect/core/providers/base_provider.dart';
import 'package:o_connect/core/routes/routes_name.dart';

class AppGlobalStateProvider extends BaseProvider {
  AppGlobalStateProvider() {
    var connectivity = Connectivity();
    connectivity.checkConnectivity().then((value) => _connectivityResult = value);
    _connectivitySubscription = connectivity.onConnectivityChanged.listen(_handleConnectivityChange);
  }

  late final StreamSubscription<ConnectivityResult> _connectivitySubscription;
  ConnectivityResult _connectivityResult = ConnectivityResult.none;

  bool get isConnected => _connectivityResult != ConnectivityResult.none;

  bool isMeetingInProgress = false;
  String? meetingId;
  bool isPIPEnabled = false;

  //for DraggerView//////////
  double positionX = 0.0;
  double positionY = 0.0;
  bool dragging = false;

  void setDraggerEnabled({required bool isDragging}) {
    dragging = isDragging;
    notifyListeners();
  }

  void setPositionX({required double positionXvalue}) {
    positionX = positionXvalue;
    notifyListeners();
  }

  set setDragHandlePosition(Offset positionData) {
    positionX = (positionData.dx) * 0.8;
    positionY = positionData.dy * 0.7;
    notifyListeners();
  }

  void setPositionY({required double positionYvalue}) {
    positionY = positionYvalue;
    notifyListeners();
  }
  //////////////////////////

  void isPIPEnable(BuildContext context) {
    isPIPEnabled = true;
    notifyListeners();
    Navigator.pop(context);
  }

  void leaveMeetingMiniView() {
    isPIPEnabled = false;
    notifyListeners();
  }

  void isPIPDisable(BuildContext context) {
    isPIPEnabled = false;
    notifyListeners();
    Navigator.of(context).pushNamed(RoutesManager.webinarDashboard);
  }

  void setIsMeetingInProgress(bool value, [String? mid]) {
    isMeetingInProgress = value;
    meetingId = mid;
    notifyListeners();
  }

  void _handleConnectivityChange(ConnectivityResult event) {
    _connectivityResult = event;
    notifyListeners();
  }

  @override
  void dispose() {
    _connectivitySubscription.cancel();
    super.dispose();
  }
}
