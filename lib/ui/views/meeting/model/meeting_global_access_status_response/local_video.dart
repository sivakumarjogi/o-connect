import 'dart:convert';

import 'package:equatable/equatable.dart';

class VideoShareState extends Equatable {
  final int? broadcastBy;
  final double? playerTime;
  final String playerState;

  const VideoShareState({
    this.broadcastBy,
    this.playerTime,
    required this.playerState,
  });

  @override
  List<Object?> get props => [broadcastBy, playerTime, playerState];

  Map<String, dynamic> toMap() {
    return {
      'broadcastBy': broadcastBy,
      'playerTime': playerTime,
      'playerState': playerState,
    };
  }

  factory VideoShareState.fromMap(Map<String, dynamic> map) {
    String playerState = 'play';

    if (map['playerState'] is int) {
      playerState = map['playerState'] == 1 ? 'play' : 'pause';
    } else {
      playerState = map['playerState'];
    }

    return VideoShareState(
      broadcastBy: map['broadcastBy'] is int ? map['broadcastBy'] : int.parse(map['broadcastBy'] ?? "0"),
      playerTime: map['playerTime']?.toDouble(),
      playerState: playerState,
    );
  }

  String toJson() => json.encode(toMap());

  factory VideoShareState.fromJson(String source) => VideoShareState.fromMap(json.decode(source));
}

class VideoShareData extends Equatable {
  final String url;
  final int broadcastedBy;
  const VideoShareData({
    required this.url,
    required this.broadcastedBy,
  });

  @override
  List<Object> get props => [url, broadcastedBy];

  Map<String, dynamic> toMap() {
    return {
      'url': url,
      'broadcastBy': broadcastedBy,
    };
  }

  factory VideoShareData.fromMap(Map<String, dynamic> map) {
    return VideoShareData(
      url: map['url'] ?? '',
      broadcastedBy: /* map['broadcastBy']?.toInt() ?? 0 */ map['userId'] is int ? map['userId'] : map['userId']?.toInt() ?? 0,
    );
  }

  String toJson() => json.encode(toMap());

  factory VideoShareData.fromJson(String source) => VideoShareData.fromMap(json.decode(source));
}
