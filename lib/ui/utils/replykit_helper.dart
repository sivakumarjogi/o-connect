// Package imports:
import 'package:replay_kit_launcher/replay_kit_launcher.dart';

class ReplayKitHelper {
  final String broadcastExtName = 'OConnect';

  Future<void> openReplayKit() async {
    await ReplayKitLauncher.launchReplayKitBroadcast(broadcastExtName);
  }
}
