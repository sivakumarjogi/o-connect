import 'dart:convert';

import 'package:equatable/equatable.dart';
import 'package:flutter/widgets.dart';

class TickerMiddle extends Equatable {
  final int? id;
  final String? text;
  final int? scrollSpeed;
  final TickerStyle? tickerStyle;
  final bool? pauseButton;

  const TickerMiddle({
    this.id,
    this.text,
    this.scrollSpeed,
    this.tickerStyle,
    this.pauseButton,
  });

  @override
  List<Object?> get props {
    return [
      id,
      text,
      scrollSpeed,
      tickerStyle,
      pauseButton,
    ];
  }

  factory TickerMiddle.fromMap(Map<String, dynamic> map) {
    return TickerMiddle(
      id: map['id']?.toInt(),
      text: map['text'],
      scrollSpeed: map['scrollspeed']?.toInt(),
      tickerStyle: map['tickerStyle'] != null
          ? TickerStyle.fromMap(map['tickerStyle'])
          : null,
      pauseButton: map['pauseButton'],
    );
  }

  factory TickerMiddle.fromJson(String source) =>
      TickerMiddle.fromMap(json.decode(source));

  TickerMiddle copyWith({
    ValueGetter<int?>? id,
    ValueGetter<String?>? text,
    ValueGetter<int?>? scrollSpeed,
    ValueGetter<TickerStyle?>? tickerStyle,
    ValueGetter<bool?>? pauseButton,
  }) {
    return TickerMiddle(
      id: id?.call() ?? this.id,
      text: text?.call() ?? this.text,
      scrollSpeed: scrollSpeed?.call() ?? this.scrollSpeed,
      tickerStyle: tickerStyle?.call() ?? this.tickerStyle,
      pauseButton: pauseButton?.call() ?? this.pauseButton,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'text': text,
      'scrollspeed': scrollSpeed,
      'tickerStyle': tickerStyle?.toMap(),
      'pauseButton': pauseButton,
    };
  }

  String toJson() => json.encode(toMap());
}

class TickerStyle extends Equatable {
  final String? fontFamily;
  final String? fontSize;
  final String? fontWeight;
  final String? textDecoration;
  final String? fontStyle;
  final String? color;

  const TickerStyle({
    this.fontFamily,
    this.fontSize,
    this.fontWeight,
    this.textDecoration,
    this.fontStyle,
    this.color,
  });

  factory TickerStyle.fromMap(Map<String, dynamic> map) {
    return TickerStyle(
      fontFamily: map['fontFamily'],
      fontSize: map['fontSize'],
      fontWeight: map['fontWeight'],
      textDecoration: map['textDecoration'],
      fontStyle: map['fontStyle'],
      color: map['color'],
    );
  }

  factory TickerStyle.fromJson(String source) =>
      TickerStyle.fromMap(json.decode(source));

  @override
  List<Object?> get props {
    return [
      fontFamily,
      fontSize,
      fontWeight,
      textDecoration,
      fontStyle,
      color,
    ];
  }

  Map<String, dynamic> toMap() {
    return {
      'fontFamily': fontFamily,
      'fontSize': fontSize,
      'fontWeight': fontWeight,
      'textDecoration': textDecoration,
      'fontStyle': fontStyle,
      'color': color,
    };
  }

  String toJson() => json.encode(toMap());

  TickerStyle copyWith({
    ValueGetter<String?>? fontFamily,
    ValueGetter<String?>? fontSize,
    ValueGetter<String?>? fontWeight,
    ValueGetter<String?>? textDecoration,
    ValueGetter<String?>? fontStyle,
    ValueGetter<String?>? color,
  }) {
    return TickerStyle(
      fontFamily: fontFamily?.call() ?? this.fontFamily,
      fontSize: fontSize?.call() ?? this.fontSize,
      fontWeight: fontWeight?.call() ?? this.fontWeight,
      textDecoration: textDecoration?.call() ?? this.textDecoration,
      fontStyle: fontStyle?.call() ?? this.fontStyle,
      color: color?.call() ?? this.color,
    );
  }
}
