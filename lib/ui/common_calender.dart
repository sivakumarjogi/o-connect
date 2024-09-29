import 'package:flutter/material.dart';

Future<DateTime?> commonCalender(BuildContext context) async {
  return await showDatePicker(
    context: context,
    initialDate: DateTime.now().subtract(const Duration(days: 365 * 18)),
    firstDate: DateTime(1990),
    lastDate: DateTime.now().subtract(const Duration(days: 365 * 18)),
    builder: (context, child) {
      return Theme(
        data: Theme.of(context).copyWith(
          textTheme: Theme.of(context).textTheme.apply(
              bodyColor: Theme.of(context).hintColor, // Change text color to white
              displayColor: Theme.of(context).scaffoldBackgroundColor // Change text color to white
              ),
          shadowColor: Colors.transparent,
          dialogBackgroundColor: Theme.of(context).scaffoldBackgroundColor,
          textButtonTheme: TextButtonThemeData(
            style: TextButton.styleFrom(
              foregroundColor: Theme.of(context).hintColor, // button text color
            ),
          ),
          colorScheme: ColorScheme.light(
                  primary: Theme.of(context).hintColor,
                  onPrimary: Theme.of(context).cardColor,
                  background: Colors.green,
                  onBackground: Theme.of(context).cardColor,
                  surface: Theme.of(context).scaffoldBackgroundColor,
                  onSurface: Theme.of(context).hintColor)
              .copyWith(background: Colors.red),
        ),
        child: child!,
      );
    },
  );
}
