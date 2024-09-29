class GlobalSetRequestModel {
  String? type;
  String? feature;
  String? action;
  String? meetingId;
  int? userId;
  int? role;

  GlobalSetRequestModel({
    this.type,
    this.feature,
    this.action,
    this.meetingId,
    this.userId,
    this.role,
  });

  Map<String, dynamic> toJson() => {
        "type": type,
        "feature": feature,
        "action": action,
        if (meetingId != null && meetingId!.isNotEmpty) "meetingId": meetingId,
        "userId": userId,
        "role": role,
      };
}
