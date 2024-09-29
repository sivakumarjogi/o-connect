import 'package:flutter/material.dart';
import 'dart:math';

class BorderAnimation extends StatefulWidget {
  const BorderAnimation({
    Key? key,
    this.isBorderRadiusRequired = true,
    this.strokeWidth = 15,
    this.borderRadius = 16,
  }) : super(key: key);
  final bool isBorderRadiusRequired;
  final double strokeWidth;
  final double borderRadius;

  @override
  State createState() => _BorderAnimationState();
}

class _BorderAnimationState extends State<BorderAnimation> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  double _progress = 0.0;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2), // Adjust the animation duration
    )..addListener(() {
        setState(() {
          _progress = _controller.value;
        });
      });
    _controller.repeat(reverse: false);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(widget.isBorderRadiusRequired ? widget.borderRadius : 0),
      child: AnimatedBuilder(
        animation: _controller,
        builder: (context, child) {
          return CustomPaint(
            painter: BorderPainter(progress: _progress, strokeWidth: widget.strokeWidth),
          );
        },
      ),
    );
  }
}

class BorderPainter extends CustomPainter {
  final double progress;
  final double strokeWidth;

  BorderPainter({required this.progress, required this.strokeWidth});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth
      ..strokeCap = StrokeCap.round; // Add rounded stroke cap

    final sideLength = min(size.width, size.height);
    final rotation = 2 * pi * progress;
    final rotationCenter = Offset(size.width / 2, size.height / 2);

    final gradient = SweepGradient(
      startAngle: pi,
      endAngle: pi * 2,
      colors: const [
        Color(0xff0EFAFD),
        Color(0xffFF0063),
      ],
      stops: const [0.0, 1.0],
      transform: GradientRotation(rotation),
    );

    paint.shader = gradient.createShader(
      Rect.fromCenter(
        center: rotationCenter,
        width: sideLength,
        height: sideLength,
      ),
    );

    final path = Path()
      ..moveTo(0, 0)
      ..lineTo(size.width, 0)
      ..lineTo(size.width, size.height)
      ..lineTo(0, size.height)
      ..close();

    canvas.save();
    canvas.translate(size.width / 2, size.height / 2);
    canvas.translate(-size.width / 2, -size.height / 2);

    canvas.drawPath(path, paint);
    canvas.restore();

    paint.shader = null; // Reset shader
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}
