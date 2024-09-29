class CallToActionSetStatusRequestModel {
  String? roomId;
  String? key;
  CallToActionSetStatusRequestModelValue? value;

  CallToActionSetStatusRequestModel({
    this.roomId,
    this.key,
    this.value,
  });

  Map<String, dynamic> toJson() => {
        "roomId": roomId,
        "key": key,
        "value": value?.toJson(),
      };
}

class CallToActionSetStatusRequestModelValue {
  int? userId;
  String? meetingId;
  String? meetingName;
  String? meetingDate;
  String? title;
  String? buttonUrl;
  String? buttonText;
  CallToActionSetStatusRequestModelDisplayTime? displayTime;
  int? isActive;
  String? createdOn;
  String? updatedOn;
  String? id;
  String? headerBgColor;
  String? headerTextColor;
  String? buttonBgColor;
  String? buttonTextColor;
  int? ou;
  String? on;
  String? addedTime;

  CallToActionSetStatusRequestModelValue({
    this.userId,
    this.meetingId,
    this.meetingName,
    this.meetingDate,
    this.title,
    this.buttonUrl,
    this.buttonText,
    this.displayTime,
    this.isActive,
    this.createdOn,
    this.updatedOn,
    this.id,
    this.headerBgColor,
    this.headerTextColor,
    this.buttonBgColor,
    this.buttonTextColor,
    this.ou,
    this.on,
    this.addedTime,
  });

  Map<String, dynamic> toJson() => {
        "user_id": userId,
        "meeting_id": meetingId,
        "meeting_name": meetingName,
        "meeting_date": meetingDate,
        "title": title,
        "button_url": buttonUrl,
        "button_text": buttonText,
        "display_time": displayTime?.toJson(),
        "is_active": isActive,
        "created_on": createdOn,
        "updated_on": updatedOn,
        "_id": id,
        "headerBgColor": headerBgColor,
        "headerTextColor": headerTextColor,
        "buttonBgColor": buttonBgColor,
        "buttonTextColor": buttonTextColor,
        "ou": ou,
        "on": on,
        "addedTime": addedTime,
      };
}

class CallToActionSetStatusRequestModelDisplayTime {
  String? minutes;
  String? seconds;

  CallToActionSetStatusRequestModelDisplayTime({
    this.minutes,
    this.seconds,
  });

  factory CallToActionSetStatusRequestModelDisplayTime.fromJson(Map<String, dynamic> json) => CallToActionSetStatusRequestModelDisplayTime(
        minutes: json["minutes"],
        seconds: json["seconds"],
      );

  Map<String, dynamic> toJson() => {
        "minutes": minutes,
        "seconds": seconds,
      };
}
