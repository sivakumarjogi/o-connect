import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:o_connect/core/screen_configs.dart';
import 'package:o_connect/ui/views/meeting/utils/meeting_utils_mixin.dart';

class MeetingEmojiProvider extends ChangeNotifier with MeetingUtilsMixin {
  TickerProvider? _tickerProvider;
  final List<AnimatedEmojiItem> animatedEmojieWidgets = [];
  final List<String> emojiFiles = [];

  MeetingEmojiProvider() {
    const noOfSupportedEmojies = 57;

    for (int i = 1; i <= noOfSupportedEmojies; i++) {
      emojiFiles.add('emoji-$i.gif');
    }
  }

  void setTickerProvider(TickerProvider tickerProvider) {
    _tickerProvider = tickerProvider;
  }

  void setupListeners() {
    hubSocket.socket?.on('entResponse', (res) {
      final parsed = jsonDecode(res);
      final data = parsed['data'];
      final command = data['command'];

      if (command == 'emoji') {
        final emojiFileName = data['emoji'];
        _animateEmoji(emojiFileName);
      }
    });
  }

  void _animateEmoji(String emojiFileName) {
    final controller = AnimationController(vsync: _tickerProvider!, duration: const Duration(seconds: 3));

    var animatedEmojiItem = AnimatedEmojiItem(
      slideAnimation: Tween<Offset>(
        begin: Offset(0.2, ScreenConfig.height * 0.9 / 100),
        end: const Offset(0.2, -1), // Slide to half of screen height
      ).animate(
        CurvedAnimation(
          parent: controller,
          curve: Curves.easeIn,
        ),
      ),
      fadeAnimation: Tween<double>(
        begin: 1.0,
        end: 0.0,
      ).animate(
        CurvedAnimation(
          parent: controller,
          curve: Curves.easeIn,
        ),
      ),
      child: SizedBox(
        height: 100,
        width: 100,
        child: Center(
          child: Image.asset(
            'assets/emoji/$emojiFileName',
          ),
        ),
      ),
      animationController: controller,
    );
    animatedEmojieWidgets.add(animatedEmojiItem);

    controller.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        animatedEmojieWidgets.remove(animatedEmojiItem);
        controller.dispose();
        notifyListeners();
      }
    });

    controller.forward();
    notifyListeners();
  }

  void sendEmoji(String fileName) {
    hubSocket.socket?.emitWithAck(
      'onEntCommand',
      jsonEncode({
        "uid": "ALL",
        "data": {
          "command": "emoji",
          "emoji": fileName,
          "id": userData.id,
        }
      }),
    );
  }
}

class AnimatedEmojiItem {
  final AnimationController animationController;
  final Animation<Offset> slideAnimation;
  final Animation<double> fadeAnimation;
  final Widget child;

  AnimatedEmojiItem({
    required this.slideAnimation,
    required this.fadeAnimation,
    required this.child,
    required this.animationController,
  });
}
