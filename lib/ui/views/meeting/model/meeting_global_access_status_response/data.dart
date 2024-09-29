import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:o_connect/ui/views/call_to_action/model/cta_response_data_model.dart';
import 'package:o_connect/ui/views/chat_screen/chat_model/chat_model.dart';
import 'package:o_connect/ui/views/meeting/model/meeting_global_access_status_response/calculator.dart';
import 'package:o_connect/ui/views/meeting/model/meeting_global_access_status_response/local_video.dart';
import 'package:o_connect/ui/views/meeting/model/meeting_global_access_status_response/presentation.dart';
import 'package:o_connect/ui/views/meeting/model/meeting_global_access_status_response/push_link.dart';
import 'package:o_connect/ui/views/meeting/model/meeting_global_access_status_response/theme.dart';
import 'package:o_connect/ui/views/meeting/model/meeting_global_access_status_response/timer.dart';
import 'package:o_connect/ui/views/themes/models/webinar_themes_model.dart';
import 'event_status.dart';
import 'poll_intial_data_model.dart';
import 'ticker_middle.dart';

@JsonSerializable()
class Data extends Equatable {
  final String? isAvModeOn;
  final bool? globalSpeakerAccess;
  final EventStatus? eventStatus;
  final bool? audio;
  final bool? video;
  final bool? emoji;
  final bool? chat;
  final bool? record;
  final String? activePage;
  final TickerMiddle? tickerMiddle;
  final CalculatorMiddle? calculatorMiddle;
  final InitialPushLink? pushLink;
  final VideoShareData? videoShareData;
  final VideoShareState? videoShareState;
  final InitialPresentationData? presentationData;
  final CtaResponseDataModel? callToAction;
  final InitialTheme? theme;
  final InitialTimer? timer;
  final List<ChatModel>? qaList;
  final PollInitialDataModel? pollData;
  final WebinarThemesListModel? themes;

  const Data({
    this.isAvModeOn,
    this.globalSpeakerAccess,
    this.eventStatus,
    this.audio,
    this.video,
    this.emoji,
    this.chat,
    this.record,
    this.tickerMiddle,
    this.calculatorMiddle,
    this.pushLink,
    this.activePage,
    this.videoShareData,
    this.videoShareState,
    this.presentationData,
    this.callToAction,
    this.theme,
    this.timer,
    this.qaList,
    this.pollData,
    this.themes,
  });

  factory Data.fromJson(Map<String, dynamic> json) => Data(
        isAvModeOn: json['isAvModeOn'] as String?,
        globalSpeakerAccess: json['globalSpeakerAccess'],
        eventStatus: json['eventStatus'] == null ? null : EventStatus.fromJson(json['eventStatus'] as Map<String, dynamic>),
        audio: json['audio'] as bool?,
        video: json['video'] as bool?,
        emoji: json['emoji'] as bool?,
        chat: json['chat'] as bool?,
        record: json['record'] as bool?,
        activePage: json['activePage'] as String?,
        tickerMiddle: json['tickerMiddle'] == null ? null : TickerMiddle.fromMap(json['tickerMiddle'] as Map<String, dynamic>),
        calculatorMiddle: json['calculatorMiddle'] == null ? null : CalculatorMiddle.fromMap(json['calculatorMiddle'] as Map<String, dynamic>),
        pushLink: json['Link'] == null ? null : InitialPushLink.fromMap(json['Link'] as Map<String, dynamic>),
        videoShareData: json['LocalVideo'] != null
            ? VideoShareData.fromMap((json['LocalVideo']))
            : json['youTubeVideo'] == null
                ? null
                : VideoShareData.fromMap((json['youTubeVideo']) as Map<String, dynamic>),
        videoShareState: json['localVideoState'] != null
            ? VideoShareState.fromMap((json['localVideoState']) as Map<String, dynamic>)
            : json['youTubeVideoState'] != null
                ? VideoShareState.fromMap((json['youTubeVideoState']) as Map<String, dynamic>)
                : null,
        presentationData: json['presentationData'] == null ? null : InitialPresentationData.fromMap(json['presentationData'] as Map<String, dynamic>),
        callToAction: json['callToAction'] == null ? null : CtaResponseDataModel.fromJson(json['callToAction'] as Map<String, dynamic>),
        theme: json['themes'] == null ? null : InitialTheme.fromMap(json['themes'] as Map<String, dynamic>),
        timer: json['timer'] == null ? null : InitialTimer.fromMap(json['timer'] as Map<String, dynamic>),
        qaList: json['QAList'] == null ? null : (json['QAList'] as List<dynamic>).map((e) => ChatModel.fromJson(e)).toList(),
        pollData: json['surveyMIddle'] == null ? null : PollInitialDataModel.fromJson(json["surveyMIddle"]['value'] as Map<String, dynamic>),
        themes: json['themes'] == null ? null : WebinarThemesListModel.fromJson(json["themes"] as Map<String, dynamic>),
      );

  @override
  bool get stringify => true;

  @override
  List<Object?> get props {
    return [
      isAvModeOn,
      globalSpeakerAccess,
      eventStatus,
      audio,
      video,
      emoji,
      chat,
      record,
      tickerMiddle,
      calculatorMiddle,
      activePage,
      pushLink,
      videoShareData,
      videoShareState,
      presentationData,
      callToAction,
      theme,
      timer,
      qaList,
      pollData,
      themes,
    ];
  }
}
