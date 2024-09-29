import 'package:flutter/material.dart';

class OConnectVideoProgressBar extends StatefulWidget {
  const OConnectVideoProgressBar({
    super.key,
    required this.onSeekToRelativePosition,
    required this.controller,
    required this.getTotalDurationInMillis,
    required this.getPlayedValue,
    required this.getBufferedValue,
    required this.getTotalDuration,
  });

  final ValueNotifier controller;
  final void Function(Duration position, {required bool allowSeekAhead}) onSeekToRelativePosition;
  final double Function() getTotalDurationInMillis;
  final Duration Function() getTotalDuration;
  final double Function() getPlayedValue;
  final double Function() getBufferedValue;

  @override
  State<OConnectVideoProgressBar> createState() => _OConnectVideoProgressBarState();
}

class _OConnectVideoProgressBarState extends State<OConnectVideoProgressBar> {
  ValueNotifier? _controller;
  Offset _touchPoint = Offset.zero;

  double _playedValue = 0.0;
  double _bufferedValue = 0.0;

  bool _touchDown = false;
  Duration? _position;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _controller ??= widget.controller;
    _controller?.addListener(positionListener);
    positionListener();
  }

  @override
  void dispose() {
    _controller?.removeListener(positionListener);
    super.dispose();
  }

  void positionListener() {
    var totalDuration = widget.getTotalDurationInMillis();
    if (mounted && !totalDuration.isNaN && totalDuration != 0) {
      setState(() {
        _playedValue = widget.getPlayedValue();
        _bufferedValue = widget.getBufferedValue();
      });
    }
  }

  void _setValue() {
    _playedValue = _touchPoint.dx / context.size!.width;
  }

  void _checkTouchPoint() {
    if (_touchPoint.dx <= 0) {
      _touchPoint = Offset(0, _touchPoint.dy);
    }
    if (_touchPoint.dx >= context.size!.width) {
      _touchPoint = Offset(context.size!.width, _touchPoint.dy);
    }
  }

  void _seekToRelativePosition(Offset globalPosition) {
    final box = context.findRenderObject() as RenderBox;
    _touchPoint = box.globalToLocal(globalPosition);
    _checkTouchPoint();
    final relative = _touchPoint.dx / box.size.width;
    _position = widget.getTotalDuration() * relative;
    widget.onSeekToRelativePosition(_position!, allowSeekAhead: false);
  }

  void _dragEndActions() {
    setState(() {
      _touchDown = false;
    });
    if (_position != null) {
      widget.onSeekToRelativePosition(_position!, allowSeekAhead: true);
    }
  }

  Widget _buildBar() {
    return GestureDetector(
      onHorizontalDragDown: (details) {
        _seekToRelativePosition(details.globalPosition);
        setState(() {
          _setValue();
          _touchDown = true;
        });
      },
      onHorizontalDragUpdate: (details) {
        _seekToRelativePosition(details.globalPosition);
        setState(_setValue);
      },
      onHorizontalDragEnd: (details) {
        _dragEndActions();
      },
      onHorizontalDragCancel: _dragEndActions,
      child: Container(
        color: Colors.transparent,
        constraints: const BoxConstraints.expand(height: 7.0 * 2),
        child: CustomPaint(
          painter: _ProgressBarPainter(
            progressWidth: 4.0,
            handleRadius: 6.0,
            playedValue: _playedValue,
            bufferedValue: _bufferedValue,
            touchDown: _touchDown,
            themeData: Theme.of(context),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) => _buildBar();
}

class _ProgressBarPainter extends CustomPainter {
  final double progressWidth;
  final double handleRadius;
  final double playedValue;
  final double bufferedValue;
  final bool touchDown;
  final ThemeData themeData;

  _ProgressBarPainter({
    required this.progressWidth,
    required this.handleRadius,
    required this.playedValue,
    required this.bufferedValue,
    required this.touchDown,
    required this.themeData,
  });

  @override
  bool shouldRepaint(_ProgressBarPainter old) {
    return playedValue != old.playedValue || bufferedValue != old.bufferedValue || touchDown != old.touchDown;
  }

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..isAntiAlias = true
      ..strokeCap = StrokeCap.round
      ..strokeWidth = progressWidth;

    final centerY = size.height / 2.0;
    final barLength = size.width - handleRadius * 2.0;

    final startPoint = Offset(handleRadius, centerY);
    final endPoint = Offset(size.width - handleRadius, centerY);
    final progressPoint = Offset(
      barLength * playedValue + handleRadius,
      centerY,
    );
    final secondProgressPoint = Offset(
      barLength * bufferedValue + handleRadius,
      centerY,
    );

    const secondaryColor = Colors.red;

    paint.color = Colors.grey.shade800;
    canvas.drawLine(startPoint, endPoint, paint);

    paint.color = Colors.white;
    canvas.drawLine(startPoint, secondProgressPoint, paint);

    paint.color = secondaryColor;
    canvas.drawLine(startPoint, progressPoint, paint);

    final handlePaint = Paint()..isAntiAlias = true;

    handlePaint.color = Colors.transparent;
    canvas.drawCircle(progressPoint, centerY, handlePaint);

    const handleColor = secondaryColor;

    if (touchDown) {
      handlePaint.color = handleColor.withOpacity(0.2);
      canvas.drawCircle(progressPoint, handleRadius * 3, handlePaint);
    }

    handlePaint.color = handleColor;
    canvas.drawCircle(progressPoint, handleRadius, handlePaint);
  }
}
