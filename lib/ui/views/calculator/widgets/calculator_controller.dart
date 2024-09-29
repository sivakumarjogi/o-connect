import 'package:flutter/material.dart';

class CalculatorController extends ChangeNotifier {
  String _lastButtonPressed = '';
  String get button => _lastButtonPressed;

  String _userInput = '';
  String get input => _userInput;

  String _answer = '';
  String get answer => _answer;

  void click(String button) {
    _lastButtonPressed = button;
    notifyListeners();
  }

  void setInputAndAnswer(String input, String answer) {
    _userInput = input;
    _answer = answer;
    notifyListeners();
  }
}
