import 'package:flutter/material.dart';

// Copyright 2020 Sarbagya Dhaubanjar. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

/// Formats duration in milliseconds to xx:xx:xx format.
String durationFormatter(int milliSeconds) {
  var seconds = milliSeconds ~/ 1000;
  final hours = seconds ~/ 3600;
  seconds = seconds % 3600;
  var minutes = seconds ~/ 60;
  seconds = seconds % 60;
  final hoursString = hours >= 10
      ? '$hours'
      : hours == 0
          ? '00'
          : '0$hours';
  final minutesString = minutes >= 10
      ? '$minutes'
      : minutes == 0
          ? '00'
          : '0$minutes';
  final secondsString = seconds >= 10
      ? '$seconds'
      : seconds == 0
          ? '00'
          : '0$seconds';
  final formattedTime = '${hoursString == '00' ? '' : '$hoursString:'}$minutesString:$secondsString';
  return formattedTime;
}

class OConnectCurrentVideoPosition extends StatefulWidget {
  const OConnectCurrentVideoPosition({
    super.key,
    required this.controller,
    required this.getCurrentPosition,
    required this.getTotalDuration,
  });

  final ValueNotifier controller;
  final int Function() getCurrentPosition;
  final int Function() getTotalDuration;

  @override
  State<OConnectCurrentVideoPosition> createState() => _OConnectCurrentVideoPositionState();
}

class _OConnectCurrentVideoPositionState extends State<OConnectCurrentVideoPosition> {
  ValueNotifier? _controller;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _controller ??= widget.controller;
    _controller?.removeListener(listener);
    _controller?.addListener(listener);
  }

  @override
  void dispose() {
    _controller?.removeListener(listener);
    super.dispose();
  }

  void listener() {
    if (mounted) setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Text(
      "${durationFormatter(widget.getCurrentPosition())} / ${durationFormatter(widget.getTotalDuration())}",
      style: const TextStyle(
        color: Colors.white,
        fontSize: 12.0,
      ),
    );
  }
}
