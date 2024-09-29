import '../../utils/constant_strings.dart';
import 'base_viewmodel.dart';

///samople

class DrawerViewModel extends BaseViewModel {
  String expandableSelected = 'User Behaviour';
  String mainSelected = ConstantsStrings.home;

  // String mainSelected = 'Tracking Code';
  bool chatBotActive = false;

  activateChatBot(bool value) {
    chatBotActive = value;
    update();
  }

  autoChange() {
    if (mainSelected == 'Dashboard' || mainSelected == 'Real Time' || mainSelected == 'Acquisition' || mainSelected == 'User path' || mainSelected == 'Geo Location' || mainSelected == 'Cohorts') {
      expandableSelected = 'User Behaviour';
    } else if (mainSelected == 'Block IP' || mainSelected == 'Block List') {
      expandableSelected = 'IP Blocking';
    } else if (mainSelected == 'Notification Setup' || mainSelected == 'Analytics') {
      expandableSelected = 'Notification';
    } else {
      expandableSelected = '';
    }
  }

  expandableSelectedChange(String value) {
    if (value == expandableSelected) {
      expandableSelected = "";
    } else {
      expandableSelected = value;
    }
    update();
  }

  mainSelectedChange(String value ,{bool fromInitState = false}) {
    if (value == mainSelected) {
    }
    mainSelected = value;
    print(mainSelected);
    if(!fromInitState){
      update();
    }
  }
}
