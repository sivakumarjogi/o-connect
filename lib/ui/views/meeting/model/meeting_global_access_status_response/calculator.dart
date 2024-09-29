import 'dart:convert';

import 'package:equatable/equatable.dart';

class CalculatorMiddle extends Equatable {
  final bool open;
  final int id;
  const CalculatorMiddle({
    required this.open,
    required this.id,
  });

  @override
  List<Object> get props => [open, id];

  Map<String, dynamic> toMap() {
    return {
      'open': open,
      'id': id,
    };
  }

  factory CalculatorMiddle.fromMap(Map<String, dynamic> map) {
    return CalculatorMiddle(
      open: map['open'] ?? false,
      id: map['id']?.toInt() ?? 0,
    );
  }

  String toJson() => json.encode(toMap());

  factory CalculatorMiddle.fromJson(String source) => CalculatorMiddle.fromMap(json.decode(source));
}
