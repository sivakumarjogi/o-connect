import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:o_connect/core/common_functions.dart';
import 'package:o_connect/ui/views/meeting/model/meeting_global_access_status_response/ticker_middle.dart';
import 'package:o_connect/ui/views/meeting/utils/meeting_utils_mixin.dart';
import 'package:provider/provider.dart';

import '../../../../core/models/default_user_data_model.dart';
import '../../../../core/providers/default_user_data_provider.dart';
import '../../../../core/service/api_helper/api_helper.dart';
import '../../../utils/base_urls.dart';
import '../../../utils/custom_toast_helper/custom_toast.dart';

class MeetingTickerProvider extends ChangeNotifier with MeetingUtilsMixin {
  final tickerFormKey = GlobalKey<FormState>();
  int maxScrollSpeed = 30;
  int minScrollSpeed = 10;
  int scrollSpeedMultiple = 10;

  bool isSetAsDefault = false;
  List<String> supportedFontFamilies = ['Poppins', 'sans-serif', 'monospace'];
  late TextStyle tickerTextStyle;

  TickerMiddle _tickerData = const TickerMiddle(scrollSpeed: 10);

  TickerMiddle get tickerData => _tickerData;

  TickerMiddle _formTickerData = const TickerMiddle(scrollSpeed: 10);

  TickerMiddle get formTickerData => _formTickerData;

  bool displayTicker = false;

  resetData() {
    tickerTextStyle = const TextStyle(color: Colors.white, fontFamily: 'Poppins');
    //bold reset
    _tickerData.copyWith(
      tickerStyle: () => _tickerData.tickerStyle?.copyWith(
        fontWeight: () => FontWeight.normal.value.toString(),
      ),
    );
// italic rest
    _tickerData.copyWith(
      tickerStyle: () => _tickerData.tickerStyle?.copyWith(
        fontStyle: () => FontStyle.normal.name,
      ),
    );

    //underline reset
    _tickerData = _tickerData.copyWith(
      tickerStyle: () => _tickerData.tickerStyle?.copyWith(
        textDecoration: () => TextDecoration.none.toString(),
      ),
    );

    notifyListeners();
  }

  DefaultUserDataModel? defaultUserDataModel;

  updateTicketValue(BuildContext context, TextEditingController textController) {
    print("jfsfskjfsfs");
    isSetAsDefault = true;
    notifyListeners();
  }

  Future<void> isDefaultSet(String controllerData, BuildContext context, bool defaultValue) async {
    try {
      print("dsjhdfighdukigfdkghdsighfdkuig   $controllerData");
      context.read<DefaultUserDataProvider>().updateTicker(tickerData: controllerData);
      print("dfsdfdsf   $defaultValue");
      isSetAsDefault = defaultValue;
      notifyListeners();
    } on DioException catch (e) {
      print("rfgjhfghfhfhg    ${e.response?.data.toString()}");
    } catch (e) {
      print("asfafkfsfg    ${e.toString()}");
    }
    notifyListeners();
  }

  void setupListeners() {
    _tickerData = _tickerData.copyWith(id: () => attendee.userId, tickerStyle: () => const TickerStyle());
    tickerTextStyle = const TextStyle(color: Colors.white, fontFamily: 'Poppins');

    hubSocket.socket?.on('commandResponse', (res) {
      final parsed = jsonDecode(res);
      final data = parsed['data'];
      final command = data['command'];

      switch (command) {
        case 'ticker':
          if (data['value'] is Map) {
            final tickerData = data['value'];
            _tickerData = TickerMiddle.fromMap(tickerData);
            setupTicker(_tickerData);
            // scroll();
          } else {
            // Remove ticker
            if (data['value'] == false) {
              displayTicker = false;
              _tickerData = _tickerData.copyWith(pauseButton: () => false);
            }
            if (data['value'] == true) {
              displayTicker = true;
            }
          }
          notifyListeners();
          break;
        case 'pauseticker':
          final button = data['value'] ?? false;
          _tickerData = _tickerData.copyWith(pauseButton: () => button);
          if (button == true) {}
          notifyListeners();
          break;
      }
    });
  }

  void publishTicker(BuildContext context) async {
    await removeTicker(context);

    Map<String, Object?> tickerData = _tickerData.toMap();
    hubSocket.socket?.emitWithAck(
      'onCommand',
      jsonEncode(
        {
          'uid': 'ALL',
          'data': {
            'command': 'ticker',
            'value': tickerData,
          }
        },
      ),
    );

    hubSocket.socket?.emitWithAck(
      'onCommand',
      jsonEncode(
        {
          'uid': 'ALL',
          'data': {'command': 'pauseticker', 'value': true, 'button': true}
        },
      ),
    );

    await globalStatusRepo.updateGlobalAccessStatus(
      {"key": "tickerMiddle", "roomId": meeting.id, "value": tickerData},
    );
  }

  void togglePause() {
    if (_tickerData.pauseButton == true) {
      pauseTicker();
    } else {
      resumeTicker();
    }
  }

  void pauseTicker() => _pauseOrResumeTicker(pause: false);

  void resumeTicker() => _pauseOrResumeTicker(pause: true);

  void _pauseOrResumeTicker({required bool pause}) async {
    await globalStatusRepo.updateGlobalAccessStatus({
      "key": "tickerMiddle",
      "roomId": meeting.id,
      "value": _tickerData.toMap(),
    });

    hubSocket.socket?.emitWithAck(
      'onCommand',
      jsonEncode(
        {
          'uid': 'ALL',
          'data': {'command': 'pauseticker', 'value': pause, 'button': pause}
        },
      ),
    );
  }

  Future<void> removeTicker(BuildContext context) async {
    await globalStatusRepo.updateGlobalAccessStatus({
      "key": "remove",
      "roomId": meeting.id,
      "value": ["tickerMiddle"]
    });

    hubSocket.socket?.emitWithAck(
      'onCommand',
      jsonEncode({
        "uid": "ALL",
        "data": {"command": "ticker", "value": false}
      }),
    );
  }

  void setFontFamily(value) {
    tickerTextStyle = tickerTextStyle.copyWith(
      fontFamily: value,
    );
    _tickerData = _tickerData.copyWith(
      tickerStyle: () => _tickerData.tickerStyle?.copyWith(
        fontFamily: () => value,
      ),
    );
    notifyListeners();
  }

  void toggleBoldStatus() {
    final newFontWeight = tickerTextStyle.fontWeight == FontWeight.bold ? FontWeight.normal : FontWeight.bold;
    tickerTextStyle = tickerTextStyle.copyWith(
      fontWeight: newFontWeight,
    );
    _tickerData = _tickerData.copyWith(
      tickerStyle: () => _tickerData.tickerStyle?.copyWith(
        fontWeight: () => newFontWeight.value.toString(),
      ),
    );
    notifyListeners();
  }

  void toggleItalicStatus() {
    var newFontStyle = tickerTextStyle.fontStyle == FontStyle.normal ? FontStyle.italic : FontStyle.normal;
    tickerTextStyle = tickerTextStyle.copyWith(
      fontStyle: newFontStyle,
    );
    _tickerData = _tickerData.copyWith(
      tickerStyle: () => _tickerData.tickerStyle?.copyWith(
        fontStyle: () => newFontStyle.name,
      ),
    );
    notifyListeners();
  }

  void toggleDecorationStatus(TextDecoration decoration) {
    var newTextdecoration = tickerTextStyle.decoration == decoration ? TextDecoration.none : decoration;
    tickerTextStyle = tickerTextStyle.copyWith(
      decoration: newTextdecoration,
    );
    _tickerData = _tickerData.copyWith(
      tickerStyle: () => _tickerData.tickerStyle?.copyWith(
        textDecoration: () => newTextdecoration.toString().substring(newTextdecoration.toString().indexOf(".") + 1),
      ),
    );
    notifyListeners();
  }

  void setTickerColor(Color color) {
    tickerTextStyle = tickerTextStyle.copyWith(color: color);

    _tickerData = _tickerData.copyWith(
      tickerStyle: () => _tickerData.tickerStyle?.copyWith(color: () => color.toHex()),
    );
    notifyListeners();
  }

  void onTickerTextChanged(String value) {
    _tickerData = tickerData.copyWith(text: () => value);
    notifyListeners();
  }

  void secCountUp() {
    if (_tickerData.scrollSpeed != maxScrollSpeed) {
      _tickerData = _tickerData.copyWith(
        scrollSpeed: () => _tickerData.scrollSpeed! + scrollSpeedMultiple,
      );
      notifyListeners();
    }
  }

  void secCountDown() {
    if (_tickerData.scrollSpeed != minScrollSpeed) {
      _tickerData = _tickerData.copyWith(
        scrollSpeed: () => _tickerData.scrollSpeed! - scrollSpeedMultiple,
      );
      notifyListeners();
    }
  }

  /// Called whenever we joined a meeting which has an active ticker
  /// running
  void setupTicker(TickerMiddle? ticker) {
    if (ticker != null) {
      _tickerData = ticker;
      if (_tickerData.tickerStyle != null) {
        _setTextStyleFromMap(_tickerData.tickerStyle!);
      }
      displayTicker = true;
      // scroll();
      // context.read<CommonProvider>().showTicker();
      notifyListeners();
    }
  }

  void _setTextStyleFromMap(TickerStyle tickerStyle) {
    final fontWeightVal = int.tryParse(tickerStyle.fontWeight ?? '400') ?? 400;
    final fontWeightEnum = FontWeight.values.where((e) => e.value == fontWeightVal).first;

    final fontStyleVal = tickerStyle.fontStyle == null || tickerStyle.fontStyle!.isEmpty == true ? 'normal' : tickerStyle.fontStyle;
    final fontStyleEnum = FontStyle.values.where((e) => e.name == fontStyleVal).first;

    tickerTextStyle = tickerTextStyle.copyWith(
      fontWeight: fontWeightEnum,
      fontStyle: fontStyleEnum,
      fontFamily: tickerStyle.fontFamily ?? 'Poppins',
      color: tickerStyle.color?.toColor(),
      decoration: _getTextDecoration(tickerStyle.textDecoration),
    );
  }

  TextDecoration _getTextDecoration(String? value) {
    switch (value?.toLowerCase()) {
      case 'underline':
        return TextDecoration.underline;
      case 'overline':
        return TextDecoration.overline;
      case 'lineThrough':
      case 'line-through':
        return TextDecoration.lineThrough;
      default:
        return TextDecoration.none;
    }
  }

  void resetState() {
    _formTickerData = const TickerMiddle(scrollSpeed: 10);
    notifyListeners();
  }
}

extension TextStyleExt on TextStyle {
  bool get isBold => fontWeight == FontWeight.bold;

  bool get isItalic => fontStyle == FontStyle.italic;

  bool get isUnderline => decoration == TextDecoration.underline;
}
