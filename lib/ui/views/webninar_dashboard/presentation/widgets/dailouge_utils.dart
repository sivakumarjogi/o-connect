import 'package:flutter/material.dart';

class DialogUtils {
  static DialogUtils _instance = new DialogUtils.internal();

  DialogUtils.internal();

  factory DialogUtils() => _instance;

  static void showCustomDialog(BuildContext context,
      {required String title, 
      String okBtnText = "Ok",
      String cancelBtnText = "Cancel",
      required VoidCallback  okBtnFunction}) {
    showDialog(
        context: context,
        builder: (_) {
          return AlertDialog(
            title: Text(title),
            content: Container(height: 200,width: 200,color: Colors.red,),
            actions: <Widget>[
              TextButton(
                child: Text(okBtnText),
                onPressed: okBtnFunction,
              ),
              TextButton(
                  child: Text(cancelBtnText),
                  onPressed: () => Navigator.pop(context))
            ],
          );
        });
  }
 }