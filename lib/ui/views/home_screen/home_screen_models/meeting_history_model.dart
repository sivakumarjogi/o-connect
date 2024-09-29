/// _id : "64fb0912b961560008763731"
/// webinar-video : 0
/// all-features : 0
/// whiteboard : 0
/// presentation : 0
/// VirtualBg : 0
/// BGM : 0
/// Resounds : 0
/// Themes : 0
/// Recordings : 0
/// Chat : 1
/// survey : 0
/// ScreenShot : 0
/// callToAction : 0
/// meeting_name : "addas"
/// meeting_date : "2023-09-08T11:53:09.000Z"
/// event_id : "720765451153385"
/// count : 3

class MeetingHistoryModel {
  MeetingHistoryModel({
      String? id, 
      int? webinarvideo,
      int? allfeatures,
    int? whiteboard,
    int? presentation,
    int? virtualBg,
    int? bgm,
    int? resounds,
    int? themes,
    int? recordings,
    int? chat,
    int? survey,
    int? screenShot,
    int? callToAction,
      String? meetingName, 
      String? meetingDate, 
      String? eventId,
    int? count,}){
    _id = id;
    _webinarvideo = webinarvideo;
    _allfeatures = allfeatures;
    _whiteboard = whiteboard;
    _presentation = presentation;
    _virtualBg = virtualBg;
    _bgm = bgm;
    _resounds = resounds;
    _themes = themes;
    _recordings = recordings;
    _chat = chat;
    _survey = survey;
    _screenShot = screenShot;
    _callToAction = callToAction;
    _meetingName = meetingName;
    _meetingDate = meetingDate;
    _eventId = eventId;
    _count = count;
}

  MeetingHistoryModel.fromJson(dynamic json) {
    _id = json['_id'];
    _webinarvideo = json['webinar-video'];
    _allfeatures = json['all-features'];
    _whiteboard = json['whiteboard'];
    _presentation = json['presentation'];
    _virtualBg = json['VirtualBg'];
    _bgm = json['BGM'];
    _resounds = json['Resounds'];
    _themes = json['Themes'];
    _recordings = json['Recordings'];
    _chat = json['Chat'];
    _survey = json['survey'];
    _screenShot = json['ScreenShot'];
    _callToAction = json['callToAction'];
    _meetingName = json['meeting_name'];
    _meetingDate = json['meeting_date'];
    _eventId = json['event_id'];
    _count = json['count'];
  }
  String? _id;
  int? _webinarvideo;
  int? _allfeatures;
  int? _whiteboard;
  int? _presentation;
  int? _virtualBg;
  int? _bgm;
  int? _resounds;
  int? _themes;
  int? _recordings;
  int? _chat;
  int? _survey;
  int? _screenShot;
  int? _callToAction;
  String? _meetingName;
  String? _meetingDate;
  String? _eventId;
  int? _count;
MeetingHistoryModel copyWith({  String? id,
  int? webinarvideo,
  int? allfeatures,
  int? whiteboard,
  int? presentation,
  int? virtualBg,
  int? bgm,
  int? resounds,
  int? themes,
  int? recordings,
  int? chat,
  int? survey,
  int? screenShot,
  int? callToAction,
  String? meetingName,
  String? meetingDate,
  String? eventId,
  int? count,
}) => MeetingHistoryModel(  id: id ?? _id,
  webinarvideo: webinarvideo ?? _webinarvideo,
  allfeatures: allfeatures ?? _allfeatures,
  whiteboard: whiteboard ?? _whiteboard,
  presentation: presentation ?? _presentation,
  virtualBg: virtualBg ?? _virtualBg,
  bgm: bgm ?? _bgm,
  resounds: resounds ?? _resounds,
  themes: themes ?? _themes,
  recordings: recordings ?? _recordings,
  chat: chat ?? _chat,
  survey: survey ?? _survey,
  screenShot: screenShot ?? _screenShot,
  callToAction: callToAction ?? _callToAction,
  meetingName: meetingName ?? _meetingName,
  meetingDate: meetingDate ?? _meetingDate,
  eventId: eventId ?? _eventId,
  count: count ?? _count,
);
  String? get id => _id;
  int? get webinarvideo => _webinarvideo;
  int? get allfeatures => _allfeatures;
  int? get whiteboard => _whiteboard;
  int? get presentation => _presentation;
  int? get virtualBg => _virtualBg;
  int? get bgm => _bgm;
  int? get resounds => _resounds;
  int? get themes => _themes;
  int? get recordings => _recordings;
  int? get chat => _chat;
  int? get survey => _survey;
  int? get screenShot => _screenShot;
  int? get callToAction => _callToAction;
  String? get meetingName => _meetingName;
  String? get meetingDate => _meetingDate;
  String? get eventId => _eventId;
  int? get count => _count;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['_id'] = _id;
    map['webinar-video'] = _webinarvideo;
    map['all-features'] = _allfeatures;
    map['whiteboard'] = _whiteboard;
    map['presentation'] = _presentation;
    map['VirtualBg'] = _virtualBg;
    map['BGM'] = _bgm;
    map['Resounds'] = _resounds;
    map['Themes'] = _themes;
    map['Recordings'] = _recordings;
    map['Chat'] = _chat;
    map['survey'] = _survey;
    map['ScreenShot'] = _screenShot;
    map['callToAction'] = _callToAction;
    map['meeting_name'] = _meetingName;
    map['meeting_date'] = _meetingDate;
    map['event_id'] = _eventId;
    map['count'] = _count;
    return map;
  }

}