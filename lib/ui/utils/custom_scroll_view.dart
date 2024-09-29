import 'package:flutter/material.dart';

class CustomScrollPhysics extends ClampingScrollPhysics {
  final Function outerController;

  CustomScrollPhysics({required this.outerController, ScrollPhysics? parent}) : super(parent: parent);

  bool isMinCheck = false;

  @override
  CustomScrollPhysics applyTo(ScrollPhysics? ancestor) {
    return CustomScrollPhysics(outerController: outerController, parent: buildParent(ancestor)!);
  }

  @override
  Simulation? createBallisticSimulation(ScrollMetrics position, double velocity) {
    if (position.pixels >= position.maxScrollExtent && velocity >= 0.0) {
      outerController(velocity, false);
    } else if (position.pixels == position.minScrollExtent && isMinCheck) {
      outerController(velocity, true);
    } else {
      isMinCheck = true;
    }

    return super.createBallisticSimulation(position, velocity);
  }
}
