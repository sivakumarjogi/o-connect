import 'dart:convert';

import 'package:equatable/equatable.dart';

class GlobalAccessSetResponse extends Equatable {
  final bool? status;
  final GlobalAccessSetData? data;

  const GlobalAccessSetResponse({
    this.status,
    this.data,
  });

  @override
  List<Object?> get props => [status, data];

  Map<String, dynamic> toMap() {
    return {
      'status': status,
      'data': data?.toMap(),
    };
  }

  factory GlobalAccessSetResponse.fromMap(Map<String, dynamic> map) {
    return GlobalAccessSetResponse(
      status: map['status'],
      data: map['data'] != null ? GlobalAccessSetData.fromMap(map['data']) : null,
    );
  }

  String toJson() => json.encode(toMap());

  factory GlobalAccessSetResponse.fromJson(String source) => GlobalAccessSetResponse.fromMap(json.decode(source));
}

class GlobalAccessSetData extends Equatable {
  final bool? permission;
  final String? reason;
  const GlobalAccessSetData({
    this.permission,
    this.reason,
  });

  @override
  List<Object?> get props => [permission, reason];

  Map<String, dynamic> toMap() {
    return {
      'permission': permission,
      'reason': reason,
    };
  }

  factory GlobalAccessSetData.fromMap(Map<String, dynamic> map) {
    return GlobalAccessSetData(
      permission: map['permission'],
      reason: map['reason'],
    );
  }

  String toJson() => json.encode(toMap());

  factory GlobalAccessSetData.fromJson(String source) => GlobalAccessSetData.fromMap(json.decode(source));
}
