import 'dart:convert';
import 'dart:developer';

DefaultUserDataModel defaultUserDataModelFromJson(String str) => DefaultUserDataModel.fromJson(json.decode(str));

String defaultUserDataModelToJson(DefaultUserDataModel data) => json.encode(data.toJson());

class DefaultUserDataModel {
  bool? status;
  UserData? data;

  DefaultUserDataModel({
    required this.status,
    this.data,
  });

  DefaultUserDataModel copyWith({
    bool? status,
    UserData? data,
  }) =>
      DefaultUserDataModel(
        status: status ?? this.status,
        data: data ?? this.data,
      );

  factory DefaultUserDataModel.fromJson(json) {
    log(json.toString());
    return DefaultUserDataModel(
      status: json!["status"],
      data: UserData.fromJson(json["data"] ?? json),
    );
  }

  Map<String, dynamic> toJson() => {
        "status": status,
        "data": data?.toJson(),
      };
}

class UserData {
  String? id;
  int? userId;
  String? exitUrl;
  PushALink? pushALink;
  Cta? cta;
  dynamic poll;
  Ticker? ticker;
  int? createdBy;
  int? updatedBy;
  DateTime? updatedOn;
  DateTime? createdOn;

  UserData({
     this.id,
     this.userId,
     this.exitUrl,
     this.pushALink,
     this.cta,
     this.poll,
     this.ticker,
     this.createdBy,
     this.updatedBy,
     this.updatedOn,
     this.createdOn,
  });

  UserData copyWith({
    String? id,
    int? userId,
    String? exitUrl,
    PushALink? pushALink,
    Cta? cta,
    dynamic poll,
    Ticker? ticker,
    int? createdBy,
    int? updatedBy,
    DateTime? updatedOn,
    DateTime? createdOn,
  }) =>
      UserData(
        id: id ?? this.id,
        userId: userId ?? this.userId,
        exitUrl: exitUrl ?? this.exitUrl,
        pushALink: pushALink ?? this.pushALink,
        cta: cta ?? this.cta,
        poll: poll ?? this.poll,
        ticker: ticker ?? this.ticker,
        createdBy: createdBy ?? this.createdBy,
        updatedBy: updatedBy ?? this.updatedBy,
        updatedOn: updatedOn ?? this.updatedOn,
        createdOn: createdOn ?? this.createdOn,
      );

  factory UserData.fromJson(Map<String, dynamic> json) => UserData(
        id: json["_id"],
        userId: json["user_id"],
        exitUrl: json["exit_url"],
        pushALink: PushALink.fromJson(json["push_a_link"] ?? {}),
        cta: Cta.fromJson(json["cta"] ?? {}),
        poll: json["poll"],
        ticker: Ticker.fromJson(json["ticker"] ?? {}),
        createdBy: json["created_by"],
        updatedBy: json["updated_by"],
        updatedOn: DateTime.parse(json["updated_on"]),
        createdOn: DateTime.parse(json["created_on"]),
      );

  Map<String, dynamic> toJson() => {
        "_id": id,
        "user_id": userId,
        "exit_url": exitUrl,
        "push_a_link": pushALink?.toJson(),
        "cta": cta?.toJson(),
        "poll": poll,
        "ticker": ticker?.toJson(),
        "created_by": createdBy,
        "updated_by": updatedBy,
        "updated_on": updatedOn?.toIso8601String(),
        "created_on": createdOn?.toIso8601String(),
      };
}

class Cta {
  String buttonTxt;
  String buttonUrl;
  int displayTime;
  String title;
  String titleBgClr;
  String titleClr;
  String btnBgClr;
  String btnClr;

  Cta({
    required this.buttonTxt,
    required this.buttonUrl,
    required this.displayTime,
    required this.title,
    required this.titleBgClr,
    required this.titleClr,
    required this.btnBgClr,
    required this.btnClr,
  });

  Cta copyWith({
    String? buttonTxt,
    String? buttonUrl,
    int? displayTime,
    String? title,
    String? titleBgClr,
    String? titleClr,
    String? btnBgClr,
    String? btnClr,
  }) =>
      Cta(
        buttonTxt: buttonTxt ?? this.buttonTxt,
        buttonUrl: buttonUrl ?? this.buttonUrl,
        displayTime: displayTime ?? this.displayTime,
        title: title ?? this.title,
        titleBgClr: titleBgClr ?? this.titleBgClr,
        titleClr: titleClr ?? this.titleClr,
        btnBgClr: btnBgClr ?? this.btnBgClr,
        btnClr: btnClr ?? this.btnClr,
      );

  factory Cta.fromJson(Map<String, dynamic> json) => Cta(
        buttonTxt: json["button_txt"] ?? "",
        buttonUrl: json["button_url"] ?? "",
        displayTime: json["display_time"] ?? 0,
        title: json["title"] ?? "",
        titleBgClr: json["titleBg_clr"] ?? "",
        titleClr: json["title_clr"] ?? "",
        btnBgClr: json["btnBg_clr"] ?? "",
        btnClr: json["btn_clr"] ?? "",
      );

  Map<String, dynamic> toJson() => {
        "button_txt": buttonTxt,
        "button_url": buttonUrl,
        "display_time": displayTime,
        "title": title,
        "titleBg_clr": titleBgClr,
        "title_clr": titleClr,
        "btnBg_clr": btnBgClr,
        "btn_clr": btnClr,
      };
}

class PushALink {
  String link;
  String button;

  PushALink({
    required this.link,
    required this.button,
  });

  PushALink copyWith({
    String? link,
    String? button,
  }) =>
      PushALink(
        link: link ?? this.link,
        button: button ?? this.button,
      );

  factory PushALink.fromJson(Map<String, dynamic> json) => PushALink(
        link: json["link"] ?? "",
        button: json["button"] ?? "",
      );

  Map<String, dynamic> toJson() => {
        "link": link,
        "button": button,
      };
}

class Ticker {
  String ticker;

  Ticker({
    required this.ticker,
  });

  Ticker copyWith({
    String? ticker,
  }) =>
      Ticker(
        ticker: ticker ?? this.ticker,
      );

  factory Ticker.fromJson(Map<String, dynamic> json) => Ticker(
        ticker: json["ticker"] ?? "",
      );

  Map<String, dynamic> toJson() => {
        "ticker": ticker,
      };
}
