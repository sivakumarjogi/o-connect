import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:o_connect/ui/utils/custom_show_dialog_helper/custom_show_dialog.dart';
import 'package:o_connect/ui/views/calculator/calculator_view.dart';
import 'package:o_connect/ui/views/calculator/widgets/calculator_controller.dart';
import 'package:o_connect/ui/views/meeting/utils/context_ext.dart';
import 'package:o_connect/ui/views/meeting/utils/meeting_utils_mixin.dart';

class CalculatorProvider extends ChangeNotifier with MeetingUtilsMixin {
  late CalculatorController calculatorController;
  BuildContext? _widgetContext;

  void setWidgetContext(BuildContext context) {
    _widgetContext = context;
  }

  void openCalculatorDialog({required bool closable}) {
    customShowDialog(
      context,
      enableDrag: false,
      WillPopScope(
        onWillPop: () async => closable,
        child: const Calculator(disableClick: true),
      ),
      height: 0.65.screenHeight,
    );
  }

  void setupListeners() {
    calculatorController = CalculatorController();

    hubSocket.socket?.on('commandResponse', (res) {
      final parsed = jsonDecode(res);
      final data = parsed['data'];
      final command = data['command'];

      final isCmdNotFromMe = parsed['from'].toString() != userData.id.toString();

      if (command == 'calculatorOpen') {
        customShowDialog(
          context,
          WillPopScope(
            onWillPop: () async => false,
            child: Calculator(disableClick: isCmdNotFromMe),
          ),
          height: 0.65.screenHeight,
          routeSettings: const RouteSettings(name: 'calculator'),
        );
      } else if (command == 'calculatorClose') {
        // Close calculator
        if (isCmdNotFromMe && _widgetContext?.mounted == true) {
          Navigator.of(context).pop();
        }
      } else if (command == 'calculatorInput') {
        if (parsed['from'].toString() != userData.id.toString()) {
          final value = data['value'].toString();
          final enteredValue = data['enteredValue'].toString();
          calculatorController.setInputAndAnswer(value, enteredValue);
        }
      }
    });
  }

  void setCalculatorIsOpen() async {
    globalStatusRepo.updateGlobalAccessStatus({
      "key": "calculatorMiddle",
      "roomId": meeting.id,
      "value": {"icon": "calculator", "id": userData.id, "open": true}
    });

    hubSocket.socket?.emitWithAck(
      'onCommand',
      jsonEncode({
        "uid": "ALL",
        "data": {"command": "calculatorOpen", "value": "calculator", "ou": userData.id, "on": userData.userName}
      }),
    );
  }

  void setCalculatorIsClosed() async {
    globalStatusRepo.updateGlobalAccessStatus({
      "roomId": meeting.id,
      "key": "remove",
      "value": ["calculatorMiddle"]
    });

    hubSocket.socket?.emitWithAck(
      'onCommand',
      jsonEncode({
        "uid": "ALL",
        "data": {"command": "calculatorClose", "value": false}
      }),
    );
  }

  void emitCalculatorInput(String ans, String expression) {
    hubSocket.socket?.emitWithAck(
      'onCommand',
      jsonEncode({
        "uid": "ALL",
        "data": {"command": "calculatorInput", "value": ans, "enteredValue": expression}
      }),
    );
  }

  void resetState() {
    calculatorController.dispose();
  }
}
