import 'package:equatable/equatable.dart';
import 'package:flutter/widgets.dart';
import 'package:mediasoup_client_flutter/mediasoup_client_flutter.dart';

// Represents a peer in a meeting.
class Peer extends Equatable {
  final Consumer? audio;
  final Consumer? video;
  final Consumer? screen;
  final String id;
  final String displayName;
  final String countryName;
  final String role;
  final bool audioOnly;
  final String picture;
  final String sessionId;
  final bool raisedHand;
  final RTCVideoRenderer? renderer;
  final RTCVideoRenderer? screenRenderer;
  final bool isActiveSpeaker;
  final String? countryFlag;

  const Peer({
    this.audio,
    this.video,
    this.screen,
    this.renderer,
    this.screenRenderer,
    required this.displayName,
    required this.id,
    required this.countryName,
    required this.countryFlag,
    required this.role,
    required this.audioOnly,
    required this.picture,
    required this.sessionId,
    required this.raisedHand,
    this.isActiveSpeaker = false,
  });

  Peer.fromMap(Map data)
      : id = data['id'],
        displayName = data['displayName'],
        audioOnly = data['audioOnly'] ?? false,
        countryName = data['countryName'],
        picture = data['picture'],

        ///key changed to roles
        role = data['role'] ?? data['roleType'] ?? '',
        sessionId = data['sessionId'],
        raisedHand = data['raisedHand'],
        countryFlag = "in",
        audio = null,
        video = null,
        screen = null,
        renderer = null,
        screenRenderer = null,
        isActiveSpeaker = false;

  List<String> get consumers => [
        if (audio != null) audio!.id,
        if (video != null) video!.id,
        if (screen != null) screen!.id,
      ];

  @override
  List<Object?> get props => [audio, video, screen, renderer, displayName, raisedHand, id, sessionId, isActiveSpeaker, screenRenderer];

  Peer copyWith({
    ValueGetter<Consumer?>? audio,
    ValueGetter<Consumer?>? video,
    ValueGetter<Consumer?>? screen,
    String? id,
    String? displayName,
    String? countryName,
    String? role,
    bool? audioOnly,
    String? picture,
    String? countryFlag,
    String? sessionId,
    bool? raisedHand,
    bool? isActiveSpeaker,
    ValueGetter<RTCVideoRenderer?>? renderer,
    ValueGetter<RTCVideoRenderer?>? screenRenderer,
  }) {
    return Peer(
      audio: audio != null ? audio() : this.audio,
      video: video != null ? video() : this.video,
      screen: screen != null ? screen() : this.screen,
      id: id ?? this.id,
      displayName: displayName ?? this.displayName,
      countryName: countryName ?? this.countryName,
      countryFlag: countryFlag ?? this.countryFlag,
      role: role ?? this.role,
      audioOnly: audioOnly ?? this.audioOnly,
      picture: picture ?? this.picture,
      sessionId: sessionId ?? this.sessionId,
      raisedHand: raisedHand ?? this.raisedHand,
      renderer: renderer != null ? renderer() : this.renderer,
      screenRenderer: screenRenderer != null ? screenRenderer() : this.screenRenderer,
      isActiveSpeaker: isActiveSpeaker ?? this.isActiveSpeaker,
    );
  }

  Peer removeAudio() => copyWith(audio: () => null);
  Peer removeVideoAndRenderer() => copyWith(video: () => null, renderer: () => null);
  Peer removeScreenAndRenderer() => copyWith(screen: () => null, screenRenderer: () => null);

  bool get isMicOn => audio != null && audio?.paused == false;
  bool get isVideoOn => video != null && video?.paused == false;
  bool get isScreenshareOn => screen != null;
}
