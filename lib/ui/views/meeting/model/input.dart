import 'dart:convert';

import 'hub_user_data/hub_user_data.dart';

/// Input that we need to send while creating establishing a connection with
/// hub socket server.
class HubSocketInput {
  final String uid;
  final String roomId;
  final HubUserData userData;
  final int panalist;
  final String origin;

  HubSocketInput({
    required this.uid,
    required this.roomId,
    required this.userData,
    required this.panalist,
    required this.origin,
  });

  Map<String, dynamic> toMap() {
    return {
      'uid': uid,
      'roomId': roomId,
      'userData': jsonEncode(userData.toJson()),
      'panalist': panalist,
    };
  }
}

/// Input that we need to send to fetch meeting data and meeting status
class CheckMeetingIsValidInput {
  final String autoGeneratedId;
  final String email;
  final String meetingId;

  CheckMeetingIsValidInput({
    required this.autoGeneratedId,
    required this.email,
    required this.meetingId,
  });

  Map<String, dynamic> toJson() {
    return {
      'auto_generated_id': autoGeneratedId,
      'email': email,
      'meeting_id': meetingId,
    };
  }
}

/// chat socket data model

class ChatSocketConnectionData {
  final String uid;
  final String roomId;

  ChatSocketConnectionData({
    required this.uid,
    required this.roomId,
  });

  Map<String, dynamic> toMap() {
    return {
      'uid': uid,
      'roomId': roomId,
    };
  }
}
