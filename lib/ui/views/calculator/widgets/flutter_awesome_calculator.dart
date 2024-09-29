// ignore_for_file: must_be_immutable

library calculator;

import 'package:flutter/material.dart';
import 'package:o_connect/ui/utils/textfield_helper/app_fonts.dart';
import 'package:o_connect/ui/views/calculator/widgets/calculator_button.dart';
import 'package:o_connect/ui/views/calculator/widgets/calculator_controller.dart';
import 'package:o_connect/ui/views/calculator/widgets/error_snack_bar.dart';
import 'package:math_expressions/math_expressions.dart';

class FlutterAwesomeCalculator extends StatefulWidget {
  BuildContext context;

  ///Height of the calculator
  double? height;

  ///Color for the "C" button of the calculator
  Color? clearButtonColor;

  ///Color for all the arithmetic buttons of the calculator
  Color? operatorsButtonColor;

  ///Color for the all the digits button of the calculator
  Color? digitsButtonColor;

  ///Color for calculator input expression
  Color? expressionAnswerColor;

  ///Radius of calculator buttons
  double? buttonRadius;

  ///Background color of the calculator
  Color? backgroundColor;

  ///Number of digits allowed after decimal point, if fractionDigits:2, then answer will
  ///be rounded to 1.00
  int? fractionDigits;
  Color? equalToButtonColor;

  ///Bool value for showing answer field of the calculator, if false then only calculator will be displayed
  bool? showAnswerField;
  void Function(String answer, String expression)? onChanged;
  TextStyle? digitsButtonTextStyle;
  TextStyle? operatorsButtonTextStyle;
  TextStyle? expressionAnswerTextStyle;
  TextStyle? clearButtonTextStyle;
  double? answerFontSize;
  Color? answerFieldColor;
  CalculatorController controller;
  bool? disableClick;

  FlutterAwesomeCalculator({
    Key? key,
    required this.context,
    this.height,
    this.digitsButtonColor,
    this.operatorsButtonColor,
    this.clearButtonColor,
    this.buttonRadius,
    this.backgroundColor,
    this.expressionAnswerColor,
    this.fractionDigits,
    this.showAnswerField,
    this.onChanged,
    this.digitsButtonTextStyle,
    this.operatorsButtonTextStyle,
    this.expressionAnswerTextStyle,
    this.clearButtonTextStyle,
    this.equalToButtonColor,
    this.answerFontSize,
    this.answerFieldColor,
    this.disableClick = false,
    required this.controller,
  }) : super(key: key);

  @override
  State<FlutterAwesomeCalculator> createState() => _FlutterAwesomeCalculatorState();
}

class _FlutterAwesomeCalculatorState extends State<FlutterAwesomeCalculator> {
  late Color clearButtonColor;
  late Color operatorsButtonColor;
  late Color digitsButtonColor;
  late Color backgroundColor;
  late double buttonRadius;
  late Color expressionAnswerColor;
  late int fractionDigits;
  late bool showAnswerField;
  String expression = '';
  String userInput = '';
  String answer = '';
  double? answerFontSize;
  bool invalid = false;
  Color? answerFieldColor;

  Color buttonColor = Colors.red;

  late ScrollController _scrollController;

  @override
  void initState() {
    super.initState();
    clearButtonColor = widget.clearButtonColor ?? Colors.blue.shade500;
    operatorsButtonColor = widget.operatorsButtonColor ?? Colors.blue.shade200;
    digitsButtonColor = widget.digitsButtonColor ?? Colors.white;
    buttonRadius = widget.buttonRadius ?? 8.0;
    backgroundColor = widget.backgroundColor ?? Colors.blueGrey;
    expressionAnswerColor = widget.expressionAnswerColor ?? Colors.black;
    fractionDigits = widget.fractionDigits ?? 1;
    showAnswerField = widget.showAnswerField ?? false;
    answerFontSize = widget.answerFontSize ?? 28;
    answerFieldColor = widget.answerFieldColor ?? Colors.black;
    _scrollController = ScrollController();

    widget.controller.addListener(() {
      // String btnPressed = widget.controller.button;

      // // If the user clicks clear button, we will get empty value from the socket.
      // // That is why we are checking with empty string
      // if (btnPressed.isEmpty) {
      //   calculatorButtonPressed(0)();
      // } else {
      //   int btnIdx = buttons.indexOf(btnPressed);
      //   if (btnIdx >= 0) {
      //     calculatorButtonPressed(btnIdx)();
      //   }
      // }

      answer = widget.controller.input;
      userInput = widget.controller.answer;

      setState(() {});
    });
  }

  void _scrollToEnd() async {
    print("the scroll called");
    // Wait for the UI to build
    _scrollController.animateTo(
      _scrollController.position.maxScrollExtent,
      duration: const Duration(milliseconds: 200),
      curve: Curves.easeInOut,
    );
  }

  @override
  void dispose() {
    super.dispose();
  }

  final List<String> buttons = [
    'C', //0
    '/', //1
    '%', //2
    'DEL', //3
    '7', //4
    '8', //5
    '9', //6
    '+', //7
    '4', //8
    '5', //9
    '6', //10
    'x', //11
    '1', //12
    '2', //13
    '3', //14
    '-', //15
    '0', //16
    '.', //17
    '+/-', //18
    '=', //19
  ];

  calculator() {
    return Container(
      height: widget.height ?? 400,
      margin: const EdgeInsets.symmetric(horizontal: 10),
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(4),
      ),
      child: Stack(
        children: [
          showAnswerField
              ? Container(
                  width: double.infinity,
                  height: widget.height != null ? widget.height! / 4.5 : 80,
                  decoration: BoxDecoration(
                    color: answerFieldColor,
                    borderRadius: BorderRadius.circular(4),
                  ),
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
                  child: Column(
                    children: [
                      Align(
                        alignment: Alignment.bottomRight,
                        child: SingleChildScrollView(
                          // fit: BoxFit.scaleDown,
                          controller: _scrollController,
                          scrollDirection: Axis.horizontal,
                          child: Text(
                            userInput.isEmpty ? ' ' : userInput,
                            style: w400_14Poppins(color: Colors.grey),
                          ),
                        ),
                      ),
                      Expanded(
                        flex: 3,
                        child: Align(
                          alignment: Alignment.bottomRight,
                          child: FittedBox(
                            fit: BoxFit.scaleDown,
                            child: Text(
                              answer.isEmpty ? ' ' : answer,
                              style: w400_24Poppins(color: Colors.white),
                            ),
                          ),
                        ),
                      )
                    ],
                  ),
                )
              : const SizedBox.shrink(),
          Align(
            alignment: Alignment.bottomCenter,
            child: SizedBox(
              height: !showAnswerField
                  ? widget.height
                  : widget.height != null
                      ? widget.height! / 1.3
                      : 320,
              child: Row(
                children: [
                  Expanded(
                    flex: 5,
                    child: Column(
                      children: [
                        Expanded(
                          child: Row(
                            children: [
                              Expanded(
                                child: CalcButton(
                                  buttonTapped: widget.disableClick == true ? null : calculatorButtonPressed(0),
                                  buttonText: buttons[0],
                                  color: clearButtonColor,
                                  calcButtonTextStyle: widget.clearButtonTextStyle,
                                  buttonRadius: buttonRadius,
                                ),
                              ),
                              Expanded(
                                child: CalcButton(
                                  buttonTapped: widget.disableClick == true ? null : calculatorButtonPressed(18),
                                  buttonText: buttons[18],
                                  color: operatorsButtonColor,
                                  calcButtonTextStyle: widget.operatorsButtonTextStyle,
                                  buttonRadius: buttonRadius,
                                ),
                              ),
                              Expanded(
                                child: CalcButton(
                                  buttonTapped: widget.disableClick == true ? null : calculatorButtonPressed(2),
                                  buttonText: buttons[2],
                                  color: operatorsButtonColor,
                                  calcButtonTextStyle: widget.operatorsButtonTextStyle,
                                  buttonRadius: buttonRadius,
                                ),
                              ),
                              Expanded(
                                child: CalcButton(
                                  buttonTapped: widget.disableClick == true ? null : calculatorButtonPressed(1),
                                  buttonText: buttons[1],
                                  color: Colors.blue,
                                  calcButtonTextStyle: widget.operatorsButtonTextStyle,
                                  buttonRadius: buttonRadius,
                                ),
                              ),
                            ],
                          ),
                        ),
                        Expanded(
                          child: Row(
                            children: [
                              Expanded(
                                child: CalcButton(
                                  buttonTapped: widget.disableClick == true ? null : calculatorButtonPressed(4),
                                  buttonText: buttons[4],
                                  color: operatorsButtonColor,
                                  buttonRadius: buttonRadius,
                                  calcButtonTextStyle: widget.digitsButtonTextStyle,
                                ),
                              ),
                              Expanded(
                                child: CalcButton(
                                  buttonTapped: widget.disableClick == true ? null : calculatorButtonPressed(5),
                                  buttonText: buttons[5],
                                  color: operatorsButtonColor,
                                  calcButtonTextStyle: widget.digitsButtonTextStyle,
                                  buttonRadius: buttonRadius,
                                ),
                              ),
                              Expanded(
                                child: CalcButton(
                                  buttonTapped: widget.disableClick == true ? null : calculatorButtonPressed(6),
                                  buttonText: buttons[6],
                                  color: operatorsButtonColor,
                                  calcButtonTextStyle: widget.digitsButtonTextStyle,
                                  buttonRadius: buttonRadius,
                                ),
                              ),
                              Expanded(
                                child: CalcButton(
                                  buttonTapped: widget.disableClick == true ? null : calculatorButtonPressed(11),
                                  buttonText: buttons[11],
                                  color: Colors.blue,
                                  calcButtonTextStyle: widget.operatorsButtonTextStyle,
                                  buttonRadius: buttonRadius,
                                ),
                              ),
                            ],
                          ),
                        ),
                        Expanded(
                          child: Row(
                            children: [
                              Expanded(
                                child: CalcButton(
                                  buttonTapped: widget.disableClick == true ? null : calculatorButtonPressed(8),
                                  buttonText: buttons[8],
                                  color: operatorsButtonColor,
                                  calcButtonTextStyle: widget.digitsButtonTextStyle,
                                  buttonRadius: buttonRadius,
                                ),
                              ),
                              Expanded(
                                child: CalcButton(
                                  buttonTapped: widget.disableClick == true ? null : calculatorButtonPressed(9),
                                  buttonText: buttons[9],
                                  color: operatorsButtonColor,
                                  calcButtonTextStyle: widget.digitsButtonTextStyle,
                                  buttonRadius: buttonRadius,
                                ),
                              ),
                              Expanded(
                                child: CalcButton(
                                  buttonTapped: widget.disableClick == true ? null : calculatorButtonPressed(10),
                                  buttonText: buttons[10],
                                  color: operatorsButtonColor,
                                  calcButtonTextStyle: widget.digitsButtonTextStyle,
                                  buttonRadius: buttonRadius,
                                ),
                              ),
                              Expanded(
                                child: CalcButton(
                                  buttonTapped: widget.disableClick == true ? null : calculatorButtonPressed(15),
                                  buttonText: buttons[15],
                                  color: Colors.blue,
                                  calcButtonTextStyle: widget.operatorsButtonTextStyle,
                                  buttonRadius: buttonRadius,
                                ),
                              ),
                            ],
                          ),
                        ),
                        Expanded(
                          child: Row(
                            children: [
                              Expanded(
                                child: CalcButton(
                                  buttonTapped: widget.disableClick == true ? null : calculatorButtonPressed(12),
                                  buttonText: buttons[12],
                                  color: operatorsButtonColor,
                                  calcButtonTextStyle: widget.digitsButtonTextStyle,
                                  buttonRadius: buttonRadius,
                                ),
                              ),
                              Expanded(
                                child: CalcButton(
                                  buttonTapped: widget.disableClick == true ? null : calculatorButtonPressed(13),
                                  buttonText: buttons[13],
                                  color: operatorsButtonColor,
                                  calcButtonTextStyle: widget.digitsButtonTextStyle,
                                  buttonRadius: buttonRadius,
                                ),
                              ),
                              Expanded(
                                child: CalcButton(
                                  buttonTapped: widget.disableClick == true ? null : calculatorButtonPressed(14),
                                  buttonText: buttons[14],
                                  color: operatorsButtonColor,
                                  calcButtonTextStyle: widget.digitsButtonTextStyle,
                                  buttonRadius: buttonRadius,
                                ),
                              ),
                              Expanded(
                                child: CalcButton(
                                  buttonTapped: widget.disableClick == true ? null : calculatorButtonPressed(7),
                                  buttonText: buttons[7],
                                  color: Colors.blue,
                                  calcButtonTextStyle: widget.operatorsButtonTextStyle,
                                  buttonRadius: buttonRadius,
                                ),
                              ),
                            ],
                          ),
                        ),
                        Expanded(
                          child: Row(
                            children: [
                              Expanded(
                                child: CalcButton(
                                  buttonTapped: widget.disableClick == true ? null : calculatorButtonPressed(17),
                                  buttonText: buttons[17],
                                  color: operatorsButtonColor,
                                  calcButtonTextStyle: widget.operatorsButtonTextStyle,
                                  buttonRadius: buttonRadius,
                                ),
                              ),
                              Expanded(
                                child: CalcButton(
                                  buttonTapped: widget.disableClick == true ? null : calculatorButtonPressed(2),
                                  buttonText: buttons[2],
                                  color: operatorsButtonColor,
                                  calcButtonTextStyle: widget.operatorsButtonTextStyle,
                                  buttonRadius: buttonRadius,
                                ),
                              ),
                              Expanded(
                                child: CalcButton(
                                  buttonTapped: widget.disableClick == true ? null : calculatorButtonPressed(3),
                                  buttonText: buttons[3],
                                  color: operatorsButtonColor,
                                  calcButtonTextStyle: widget.digitsButtonTextStyle,
                                  buttonRadius: buttonRadius,
                                ),
                              ),

                              Expanded(
                                child: CalcButton(
                                  buttonTapped: widget.disableClick == true ? null : calculatorButtonPressed(19),
                                  buttonText: buttons[19],
                                  color: Colors.blue,
                                  calcButtonTextStyle: widget.clearButtonTextStyle,
                                  buttonRadius: buttonRadius,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  // resetFontSize() {
  //   answerFontSize = 12;
  // }

  Function() calculatorButtonPressed(int buttonIndex) {
    _scrollToEnd();
    switch (buttonIndex) {
      /// clear button
      case 0:
        return () {
          setState(() {
            userInput = '';
            answer = '';
            resetInvalid();
            // resetFontSize();
            if (widget.onChanged != null) {
              widget.onChanged!(answer, userInput);
            }
          });
        };

      /// % button
      case 2:
        return () {
          // otherButtonPressed(buttonIndex);
          // userInput += buttons[buttonIndex];
          // calculatorCubit.emitCalculatorValue(userInput);
          operatorButtonPressed(buttonIndex);
        };

      ///delete button
      case 3:
        return () {
          if (userInput.isNotEmpty) {
            /// To restrict the user, when there is any digit in amount, then DEL button,
            /// will remove last digit, else will not.
            userInput = userInput.substring(0, userInput.length - 1);
            // resetFontSize();
          }
          bool invalidResult = checkResultLength();
          if (!invalidResult) {
            resetInvalid();
          }

          widget.onChanged?.call(answer, userInput);
          setState(() {});
        };

      ///equal button
      case 19:
        return () {
          equalPressed();
        };

      case 1:
        return () {
          operatorButtonPressed(buttonIndex);
        };

      case 11:
        return () {
          operatorButtonPressed(buttonIndex);
        };

      case 7:
        return () {
          operatorButtonPressed(buttonIndex);
        };

      case 15:
        return () {
          operatorButtonPressed(buttonIndex);
        };

      case 17:
        return () {
          operatorButtonPressed(buttonIndex);
        };

      ///other buttons
      default:
        return () {
          digitButtonPressed(buttonIndex);
        };
    }
  }

  bool isOperator(String x) {
    if (x == '/' || x == 'x' || x == '-' || x == '+' || x == '=') {
      return true;
    }
    return false;
  }

// function to calculate the input operation
  void equalPressed() {
    if (userInput.isEmpty) {
      return;
    }
    String finalUserInput = userInput;
    finalUserInput = userInput.replaceAll('x', '*');
    Parser p = Parser();
    try {
      Expression exp = p.parse(finalUserInput);
      ContextModel cm = ContextModel();
      double evaluatedAnswer = exp.evaluate(EvaluationType.REAL, cm);
      answer = evaluatedAnswer.toStringAsFixed(fractionDigits);
    } catch (e) {
      ///to remove last operator value from expression e.g if user press 6+ and press equal
      ///we remove last + from expression
      finalUserInput = finalUserInput.substring(0, finalUserInput.length - 1);
      userInput = finalUserInput;
      equalPressed();
      return;
    }
    answerFontSize = 20;

    // userInput = amount.toStringAsFixed(2);
    // answer = userInput;

    setState(() {});
  }

  String previousAns = '';

  bool checkResultLength() {
    String finalAnswer = userInput;
    finalAnswer = userInput.replaceAll('x', '*');
    Parser parser = Parser();
    late double evaluatedAnswer;

    try {
      Expression exp = parser.parse(finalAnswer);
      ContextModel contextModel = ContextModel();
      evaluatedAnswer = exp.evaluate(EvaluationType.REAL, contextModel);
      answer = evaluatedAnswer.toStringAsFixed(fractionDigits);
      finalAnswer = answer.substring(0, answer.indexOf('.'));
      if (finalAnswer.length > 14) {
        userInput = userInput.substring(0, userInput.length - 1);
        invalid = true;
        answer = previousAns;
        showErrorSnackBar('Non supported value');
        return true;
      }
      previousAns = answer;
      return false;
    } catch (e) {
      return false;
    }
  }

  resetInvalid() {
    invalid = false;
  }

  showErrorSnackBar(String message) {
    ErrorSnackBar.showSnackBar(message: 'Non Supported value', context: widget.context);
  }

  operatorButtonPressed(int index) {
    resetInvalid();
    userInput += buttons[index];
    RegExp regExp = RegExp(r'^[0-9]+$');
    if (!(regExp.hasMatch(buttons[index])) && userInput.length == 1) {
      ///this If is use when user enter first digit an arithmetic operator, that is
      ///if user enter first digit +,- or any other, we won't allow to add into amount
      ///and remove from user input.
      userInput = '';
      return;
    }

    ///if user pressing any of below button again and again, it will replace with the last character
    ///e.g if value is 12+ and user press - , it will replace + with -.
    String lastChar = userInput.characters.elementAt(userInput.length - 2);

    if (lastChar == '+' || lastChar == '-' || lastChar == 'x' || lastChar == '/' || lastChar == '%' || lastChar == '.') {
      userInput = userInput.substring(0, userInput.length - 2);
      userInput += buttons[index];
    } else {
      userInput = userInput.substring(0, userInput.length - 1);
      userInput += buttons[index];
    }
    setState(() {});
  }

  digitButtonPressed(int index) {
    ///if button tapped is operator button or not
    if (!invalid) {
      userInput += buttons[index];

      ///checking length of answer value and also negative number
      checkResultLength();

      if (widget.onChanged != null) {
        widget.onChanged!(answer, userInput);
      }
    } else {
      showErrorSnackBar('Non supported value');
    }
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return calculator();
  }
}
