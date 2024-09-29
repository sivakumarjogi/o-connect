// Dart imports:
import 'dart:io';

// Flutter imports:
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:o_connect/ui/views/meeting/providers/meeting_room_provider.dart';
import 'package:provider/provider.dart';

class ReplayKitChannel {
  final MethodChannel rkChannel = const MethodChannel('oconnect_screenshare_listener');

  // Private constructor
  ReplayKitChannel._();

  // Singleton instance
  static ReplayKitChannel? _instance;

  // Factory method to get the instance
  factory ReplayKitChannel() {
    _instance ??= ReplayKitChannel._();
    return _instance!;
  }

  void listenEvents({
    required BuildContext context,
  }) {
    if (!Platform.isIOS) return;

    rkChannel.setMethodCallHandler((call) async {
      print(call.method);
      if (call.method == "closeReplayKitFromNative") {
        await stopSharing(context);
      } else if (call.method == "hasSampleBroadcast") {
        await startSharing(context);
      }
    });
  }

  Future<void> startSharing(BuildContext context) async {
    final bool? isPresenting = await context.read<MeetingRoomProvider>().presentScreen();
    await context.read<MeetingRoomProvider>().callStartScreenShareNetworkCalls(
          isPresenting: (isPresenting ?? false),
        );
  }

  Future<void> stopSharing(BuildContext context) async {
    await closeReplayKit();
    _instance?.rkChannel.setMethodCallHandler((call) async {});
    await context.read<MeetingRoomProvider>().callStopScreenShareNetworkCalls();
  }

  Future<void> startReplayKit() async {
    await rkChannel.invokeMethod("startReplayKit");
  }

  Future<void> closeReplayKit() async {
    await _instance?.rkChannel.invokeMethod("closeReplayKitFromFlutter");
  }
}
