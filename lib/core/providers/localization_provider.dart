import 'dart:ui';

import 'package:o_connect/core/providers/base_provider.dart';

class LocalizationProvider extends BaseProvider {
  String selectedLocale = "";
  int selectedIndex = -1;
  String translateFrom = "en";

  updateSelectedLocale(String updateLocale, int index) {
    selectedLocale = updateLocale;

    /// TODO: Hive removed need to do with shared preferences
    //saveAndSetLocale(Locale(updateLocale));
    selectedIndex = index;

    /// TODO: Hive removed need to do with shared preferences
    //getLocaleValue();
    notifyListeners();
  }

  /// TODO: Hive removed need to do with shared preferences

/* saveAndSetLocale(Locale locale) async{
     await UserStateHiveHelper.instance.setLocale(locale);
   }*/

  /// TODO: Hive removed need to do with shared preferences

/* Future<void> getLocaleValue() async{
    final translate = await UserStateHiveHelper.instance.getLocale();
    translateFrom = translate ?? "en";
    notifyListeners();
  }*/
}
