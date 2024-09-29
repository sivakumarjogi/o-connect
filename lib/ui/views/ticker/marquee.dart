import 'package:flutter/material.dart';

class TickerMarquee extends StatelessWidget {
  const TickerMarquee({
    Key? key,
    required this.child,
    required this.scrollController,
  }) : super(key: key);

  final Widget child;
  final ScrollController scrollController;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      physics: const NeverScrollableScrollPhysics(),
      scrollDirection: Axis.horizontal,
      controller: scrollController,
      child: child,
    );
  }
}
