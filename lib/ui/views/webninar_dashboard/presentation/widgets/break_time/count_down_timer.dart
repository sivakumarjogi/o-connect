import 'dart:async';

import 'package:flutter/material.dart';

import 'package:o_connect/ui/views/webninar_dashboard/presentation/widgets/break_time/flicp_clock_builder.dart';


class FlipCountdownClock extends StatelessWidget {

  FlipCountdownClock({
    Key? key,
    required this.duration,
    required double digitSize,
    required double width,
    required double height,
    AxisDirection flipDirection = AxisDirection.up,
    Curve? flipCurve,
    Color? digitColor,
    Color? backgroundColor,
    double? separatorWidth,
    Color? separatorColor,
    Color? separatorBackgroundColor,
    bool? showBorder,
    double? borderWidth,
    Color? borderColor,
    BorderRadius borderRadius = const BorderRadius.all(Radius.circular(4.0)),
    double hingeWidth = 0.8,
    double? hingeLength,
    Color? hingeColor,
    EdgeInsets digitSpacing = const EdgeInsets.symmetric(horizontal: 2.0),
    this.onDone,
  })  : _showHours = duration.inHours > 0,
        _displayBuilder = FlipClockBuilder(
          digitSize: digitSize,
          width: width,
          height: height,
          flipDirection: flipDirection,
          flipCurve: flipCurve,
          digitColor: digitColor,
          backgroundColor: backgroundColor,
          separatorWidth: separatorWidth ?? width / 3.0,
          separatorColor: separatorColor,
          // separatorBackgroundColor: separatorBackgroundColor,
          showBorder: showBorder ?? (borderColor != null || borderWidth != null),
          borderWidth: borderWidth,
          borderColor: borderColor,
          borderRadius: borderRadius,
          hingeWidth: hingeWidth,
          hingeLength: hingeWidth == 0.0
              ? 0.0
              : hingeLength ??
                  (flipDirection == AxisDirection.down || flipDirection == AxisDirection.up ? width : height),
          hingeColor: hingeColor,
          digitSpacing: digitSpacing,
        );

  /// Duration of the countdown.
  final Duration duration;
  final VoidCallback? onDone;
  final FlipClockBuilder _displayBuilder;

  final bool _showHours;

  @override
  Widget build(BuildContext context) {
    const step = Duration(seconds: 1);
    final startTime = DateTime.now();
    final endTime = startTime.add(duration).add(step);

    var done = false;
    final periodicStream = Stream<Duration>.periodic(step, (_) {
      final now = DateTime.now();
      if (now.isBefore(endTime)) {
        return endTime.difference(now);
      }
      if (!done && onDone != null) {
        onDone!();
      }
      done = true;
      return Duration.zero;
    });

    // Take up to (including) Duration.zero
    var fetchedZero = false;
    final durationStream = periodicStream.takeWhile((timeLeft) {
      final waitingZero = !fetchedZero;
      fetchedZero |= timeLeft.inSeconds == 0;
      return waitingZero;
    }).asBroadcastStream();

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        if (_showHours) ...[
          _buildHoursDisplay(durationStream, duration),
          // _displayBuilder.buildSeparator(context),
        ],
        _buildMinutesDisplay(durationStream, duration),
        // _displayBuilder.buildSeparator(context),
        _buildSecondsDisplay(durationStream, duration),
      ],
    );
  }

  Widget _buildHoursDisplay(Stream<Duration> stream, Duration initValue) => _displayBuilder.buildTimePartDisplay(
        stream.map((time) => time.inHours % 24),
        initValue.inHours % 24,
      );

  Widget _buildMinutesDisplay(Stream<Duration> stream, Duration initValue) => _displayBuilder.buildTimePartDisplay(
        stream.map((time) => time.inMinutes % 60),
        initValue.inMinutes % 60,
      );

  Widget _buildSecondsDisplay(Stream<Duration> stream, Duration initValue) => _displayBuilder.buildTimePartDisplay(
        stream.map((time) => time.inSeconds % 60),
        initValue.inSeconds % 60,
      );
}

