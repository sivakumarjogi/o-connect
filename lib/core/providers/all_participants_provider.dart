import 'package:o_connect/core/providers/base_provider.dart';

class AllParticipantProvider extends BaseProvider {
  bool isMicOn = true;
  bool isCameraOn = true;
  bool isChatOn = true;
  bool isSmileyOn = true;
  bool isMicBottomOn = true;
  bool isCameraBottomOn = true;
  bool isHand = true;
  String selectedItem = "Guests List";

  // List participantsDetails = [
  //   {"name": "Priyam", "position": "host"},
  //   {"name": "Sagar", "position": "co-host"},
  //   {"name": "Raji", "position": "pinnedUser"},
  //   {"name": "Siva", "position": "host"},
  //   {"name": "Sampada", "position": "pinnedUser"},
  //   {"name": "Anurada", "position": "user"},
  //   {"name": "Appal Reddy", "position": "co-host"},
  //   {"name": "Santhosh", "position": "user"}
  // ];

  // sortUsersBasedOnPosition() {
  //   participantsDetails.sort((a, b) {
  //     if (a["position"] == b["position"]) {
  //       return 0;
  //     }
  //     if (a["position"] == "host") {
  //       return -1;
  //     }
  //     if (a["position"] == "co-host" && b["position"] != "host") {
  //       return -1;
  //     }
  //     if (a["position"] == "pinnedUser" &&
  //         b["position"] != "host" &&
  //         b["position"] != "co-host") {
  //       return -1;
  //     }
  //     return 1;
  //   });
  // }

  void changeMicStatus() {
    isMicOn = !isMicOn;
    notifyListeners();
  }

  void changeCameraStatus() {
    isCameraOn = !isCameraOn;
    notifyListeners();
  }

  void changeChatStatus() {
    isChatOn = !isChatOn;
    notifyListeners();
  }

  void changeSmileyStatus() {
    isSmileyOn = !isSmileyOn;
    notifyListeners();
  }

  void changeHandStatus() {
    isHand = !isHand;
    notifyListeners();
  }

  void changeMicBottomStatus() {
    isMicBottomOn = !isMicBottomOn;
    notifyListeners();
  }

  void changeCameraBottomStatus() {
    isCameraBottomOn = !isCameraBottomOn;
    notifyListeners();
  }

  updateGuestList(String updatedValue) {
    selectedItem = updatedValue;
    notifyListeners();
  }
}
