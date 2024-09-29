import 'package:equatable/equatable.dart';
import 'package:o_connect/ui/views/meeting/model/user_role.dart';

import 'package:o_connect/ui/views/meeting/utils/string_extension.dart';

import '../../../../../dummy_json/home_json.dart';

class HubUserData extends Equatable {
  final int? id;
  final String? displayName;
  final String? role;
  final String? meetingId;
  final String? co;

  final String? profilePic;
  final bool? pu;
  final bool? isAudioEnabled;
  final bool? isVideoEnabled;
  final bool? makePresenter;
  final bool? makeCohost;
  final bool? bc;
  final String? roomId;
  final bool? st;
  final String? peerId;
  final String? email;
  final String? country;
  final String? countryFlag;
  final bool? handRaise;
  final bool? activeHost;
  final int? oAcId;
  final UserRole? userRole;

  const HubUserData(
      {this.id,
      this.displayName,
      this.role,
      this.meetingId,
      this.co,
      this.profilePic,
      this.pu,
      this.isAudioEnabled,
      this.isVideoEnabled,
      this.makePresenter,
      this.makeCohost,
      this.bc,
      this.roomId,
      this.st,
      this.peerId,
      this.email,
      this.country,
      this.countryFlag,
      this.handRaise = false,
      this.activeHost,
      this.oAcId,
      this.userRole});

  factory HubUserData.fromJson(Map<String, dynamic> json) {
    return HubUserData(
      id: json['id'] as int?,
      displayName: json['un'] as String?,
      role: json['ro'] as String?,
      meetingId: json['mi'] as String?,
      co: json['co'] as String?,
      profilePic: json['pp'] as String?,
      pu: json['pu'] as bool?,
      isAudioEnabled: json['iae'] as bool?,
      isVideoEnabled: json['ive'] as bool?,
      makePresenter: json['mp'] as bool?,
      makeCohost: json['mch'] as bool?,
      bc: json['bc'] as bool?,
      roomId: json['ri'] as String?,
      st: json['st'] as bool?,
      peerId: json['peerId'] as String?,
      email: json['email'] as String?,
      country: json['country'] as String?,
      countryFlag: countries[json['country'] as String?],
      handRaise: json['hr'] as bool?,
      activeHost: json['activeHost'] as bool?,
      oAcId: json['oAcId'] as int?,
    );
  }

  Map<String, dynamic> toJson() => <String, dynamic>{
        'id': id,
        'un': displayName,
        'ro': role,
        'mi': meetingId,
        'co': co,
        'pp': profilePic,
        'pu': pu,
        'iae': isAudioEnabled,
        'ive': isVideoEnabled,
        'mp': makePresenter,
        'mch': makeCohost,
        'bc': bc,
        'ri': roomId,
        'st': st,
        'peerId': peerId,
        'email': email,
        'country': country,
        'hr': handRaise,
        'activeHost': activeHost,
        'oAcId': oAcId,
      };

  HubUserData copyWith(
      {int? id,
      String? un,
      String? ro,
      String? mi,
      String? co,
      String? pp,
      bool? pu,
      bool? iae,
      bool? ive,
      bool? mp,
      bool? mch,
      bool? bc,
      String? ri,
      bool? st,
      String? peerId,
      String? email,
      String? country,
      String? countryFlag,
      bool? hr,
      bool? activeHost,
      int? oAcId,
      UserRole? userRole}) {
    return HubUserData(
        id: id ?? this.id,
        displayName: un ?? displayName,
        role: ro ?? role,
        meetingId: mi ?? meetingId,
        co: co ?? this.co,
        profilePic: pp ?? profilePic,
        pu: pu ?? this.pu,
        isAudioEnabled: iae ?? isAudioEnabled,
        isVideoEnabled: ive ?? isVideoEnabled,
        makePresenter: mp ?? makePresenter,
        makeCohost: mch ?? makeCohost,
        bc: bc ?? this.bc,
        roomId: ri ?? roomId,
        st: st ?? this.st,
        peerId: peerId ?? this.peerId,
        email: email ?? this.email,
        country: country ?? this.country,
        countryFlag: countryFlag ?? this.countryFlag,
        handRaise: hr ?? handRaise,
        activeHost: activeHost ?? this.activeHost,
        oAcId: oAcId ?? this.oAcId,
        userRole: userRole ?? this.userRole);
  }

  @override
  bool get stringify => true;

  bool get isCohost => makeCohost == true && activeHost == false;

  bool get isActiveHost => makeCohost == true && activeHost == true;

  bool get isHost => role.isHost;

  bool get isHostOrActiveHost => isHost || isActiveHost;

  @override
  List<Object?> get props {
    return [
      id,
      displayName,
      role,
      meetingId,
      co,
      profilePic,
      pu,
      isAudioEnabled,
      isVideoEnabled,
      makePresenter,
      makeCohost,
      bc,
      roomId,
      st,
      peerId,
      email,
      country,
      countryFlag,
      handRaise,
      activeHost,
      oAcId,
    ];
  }

  @override
  String toString() {
    return 'HubUserData(id: $id, displayName: $displayName, role: $role, meetingId: $meetingId, co: $co, profilePic: $profilePic, pu: $pu, isPinned: $isAudioEnabled, isVideoEnabled: $isVideoEnabled, makePresenter: $makePresenter, makeCohost: $makeCohost, bc: $bc, roomId: $roomId, st: $st, peerId: $peerId, email: $email, country: $country, handRaise: $handRaise, activeHost: $activeHost, oAcId: $oAcId)';
  }
}
