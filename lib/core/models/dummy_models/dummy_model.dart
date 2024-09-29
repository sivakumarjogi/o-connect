import 'package:flutter/material.dart';
import '../../../ui/utils/constant_strings.dart';
import '../../../ui/utils/textfield_helper/app_fonts.dart';

class VirtualBgDummyModel {
  VirtualBgDummyModel({required this.imagePath});

  final String imagePath;
}

class CheckboxModel {
  CheckboxModel({required this.isCheck, required this.checkboxText});

  late bool isCheck;
  final String checkboxText;
}

List<CheckboxModel> checkboxList = [
  CheckboxModel(isCheck: false, checkboxText: "All"),
  CheckboxModel(isCheck: false, checkboxText: "O-Connect"),
  CheckboxModel(isCheck: false, checkboxText: "O-Net"),
  CheckboxModel(isCheck: false, checkboxText: "O-Mail"),
];

List<CheckboxModel> checkboxListEvent = [
  CheckboxModel(isCheck: false, checkboxText: "All"),
  CheckboxModel(isCheck: false, checkboxText: "Upcoming Event"),
  CheckboxModel(isCheck: false, checkboxText: "Completed Event"),
  CheckboxModel(isCheck: false, checkboxText: "Cancelled Event"),
];

List<DropdownMenuItem<String>> countriesList = [
  const DropdownMenuItem(value: "Guests List", child: Text("Guests List")),
  const DropdownMenuItem(value: "Participant List", child: Text("Participant List")),
];

List<DropdownMenuItem<String>> webinarDropdownMenu = [
  DropdownMenuItem(
      value: ConstantsStrings.upcomingWebinars,
      child: Text(
        ConstantsStrings.upcomingWebinars,
        style: w400_14Poppins(color: Colors.white),
      )),
  DropdownMenuItem(
      value: ConstantsStrings.recurringWebinars,
      child: Text(
        ConstantsStrings.recurringWebinars,
        style: w400_14Poppins(color: Colors.white),
      )),
  DropdownMenuItem(
      value: ConstantsStrings.pastWebinars,
      child: Text(
        ConstantsStrings.pastWebinars,
        style: w400_14Poppins(color: Colors.white),
      )),
  DropdownMenuItem(
      value: ConstantsStrings.cancelledWebinars,
      child: Text(
        ConstantsStrings.cancelledWebinars,
        style: w400_14Poppins(color: Colors.red),
      )),
];

class CustomSlideModel {
  String key;
  String key1;
  String image;

  CustomSlideModel({required this.key, required this.key1, required this.image});
}

List<CustomSlideModel> customSlideLst = [
  CustomSlideModel(image: "assets/new_ui_icons/introslider/introslider_1.svg", key: '''Welcome to AI-powered Video Conferencing''', key1: '''OConnect elevates every virtual interaction with the power of AI.'''),
  CustomSlideModel(
      image: "assets/new_ui_icons/introslider/introslider_2.svg",
      key: '''Collaboration made fun and easy!''',
      key1: '''Engage, react, and energize your teamwork with Resounds, Reactions, and many more immersive features.'''),
  CustomSlideModel(
      image: "assets/new_ui_icons/introslider/introslider_3.svg", key: '''Explore the first AI video conferencing app''', key1: '''AI meets video conferencing for a game-changing experience! Get Started!'''),
];

class ValidatePassWord {
  bool isUpperCaseExists;
  bool isLowerCaseExists;
  bool isNumberExists;
  bool isSpecialCharacterExists;
  bool isValidPassWord;
  bool is8Characters;
  bool showPassWordInfo;
  String password;

  ValidatePassWord({
    this.isLowerCaseExists = false,
    this.isNumberExists = false,
    this.isSpecialCharacterExists = false,
    this.isUpperCaseExists = false,
    this.isValidPassWord = false,
    this.is8Characters = false,
    this.showPassWordInfo = false,
    this.password = "",
  });
}

class RadioGroupWidget {
  final String name;

  RadioGroupWidget({required this.name});
}

// List<String> videoList = ["8 bit", "16 bit", "24 bit", "34 bit"];

// List<String> secondsList = [
//   "3 ms",
//   "5 ms",
//   "10 ms",
//   "15 ms",
//   "20 ms",
//   "25 ms",
//   "30 ms"
// ];
// List<String> audioPresent = ["Conference Audio", "Hi-Fi Streaming"];
// List<String> audioInputDevice = [
//   "Microphone (USB PnP Sound Device) (8087:1024)",
//   "Communications - Microphone (USB PnP Sound Device) (8087:1024)",
//   "Microphone (USB PnP Sound Device) ",
//   "Stereo Mix (Realtek(R) Audio)"
// ];

List<DropdownMenuItem<String>> libraryDropdownList = [
  const DropdownMenuItem(value: "Meeting History", child: Text("Meeting History")),
  const DropdownMenuItem(value: "Template(s)", child: Text("Template(s)")),
  const DropdownMenuItem(value: "Presentation Files", child: Text("Presentation Files")),
];

List<DropdownMenuItem<String>> get timeZonedDopdownTimeItems {
  List<DropdownMenuItem<String>> menuItems = [
    const DropdownMenuItem(value: "Asia/Calcutta (UTC +05:30)", child: Text("Asia/Calcutta (UTC +05:30)")),
    const DropdownMenuItem(value: "Africa/Abidjan (UTC +00:00)", child: Text("Africa/Abidjan (UTC +00:00)")),
    const DropdownMenuItem(value: "Africa/Accra (UTC +00:00)", child: Text("Africa/Accra (UTC +00:00)")),
    const DropdownMenuItem(value: "Africa/Addis_Ababa (UTC +03:00)", child: Text("Africa/Addis_Ababa (UTC +03:00)")),
    const DropdownMenuItem(value: "Africa/Algiers (UTC +01:00)", child: Text("Africa/Algiers (UTC +01:00)")),
    const DropdownMenuItem(value: "Africa/Asmara (UTC +03:00)", child: Text("Africa/Asmara (UTC +03:00)")),
    const DropdownMenuItem(value: "Africa/Asmera (UTC +03:00)", child: Text("Africa/Asmera (UTC +03:00)")),
    const DropdownMenuItem(value: "Africa/Bamako (UTC +00:00)", child: Text("Africa/Bamako (UTC +00:00)")),
    const DropdownMenuItem(value: "Africa/Bangui (UTC +01:00)", child: Text("Africa/Bangui (UTC +01:00)")),
    const DropdownMenuItem(value: "Africa/Bissau (UTC +00:00)", child: Text("Africa/Bissau (UTC +00:00)")),
    const DropdownMenuItem(value: "Africa/Blantyre (UTC +02:00)", child: Text("Africa/Blantyre (UTC +02:00)")),
    const DropdownMenuItem(value: "Africa/Brazzaville (UTC +01:00)", child: Text("Africa/Brazzaville (UTC +01:00)")),
    const DropdownMenuItem(value: "Africa/Bujumbura (UTC +02:00)", child: Text("Africa/Bujumbura (UTC +02:00)")),
    const DropdownMenuItem(value: "Africa/Cairo (UTC +03:00)", child: Text("Africa/Cairo (UTC +03:00)")),
    const DropdownMenuItem(value: "Africa/Casablanca (UTC +01:00)", child: Text("Africa/Casablanca (UTC +01:00)")),
    const DropdownMenuItem(value: "Africa/Ceuta (UTC +02:00)", child: Text("Africa/Ceuta (UTC +02:00)")),
    const DropdownMenuItem(value: "Africa/Conakry (UTC +00:00)", child: Text("Africa/Conakry (UTC +00:00)")),
    const DropdownMenuItem(value: "Africa/Conakry (UTC +00:00)", child: Text("Africa/Conakry (UTC +00:00)")),
    const DropdownMenuItem(value: "Africa/Dakar (UTC +00:00)", child: Text("Africa/Dakar (UTC +00:00)")),
    const DropdownMenuItem(value: "Africa/Dar_es_Salaam (UTC +03:00)", child: Text("Africa/Dar_es_Salaam (UTC +03:00)")),
    const DropdownMenuItem(value: "Africa/Djibouti (UTC +03:00)", child: Text("Africa/Djibouti (UTC +03:00)")),
    const DropdownMenuItem(value: "Africa/Douala (UTC +01:00)", child: Text("Africa/Douala (UTC +01:00)")),
    const DropdownMenuItem(value: "Africa/El_Aaiun (UTC +01:00)", child: Text("Africa/El_Aaiun (UTC +01:00)")),
    const DropdownMenuItem(value: "Africa/Freetown (UTC +00:00)", child: Text("Africa/Freetown (UTC +00:00)")),
    const DropdownMenuItem(value: "Africa/Gaborone (UTC +02:00)", child: Text("Africa/Gaborone (UTC +02:00)")),
    const DropdownMenuItem(value: "Africa/Harare (UTC +02:00)", child: Text("Africa/Harare (UTC +02:00)")),
    const DropdownMenuItem(value: "Africa/Johannesburg (UTC +02:00)", child: Text("Africa/Johannesburg (UTC +02:00)")),
    const DropdownMenuItem(value: "Africa/Juba (UTC +02:00)", child: Text("Africa/Juba (UTC +02:00)")),
    const DropdownMenuItem(value: "Africa/Kampala (UTC +03:00)", child: Text("Africa/Kampala (UTC +03:00))")),
    const DropdownMenuItem(value: "Africa/Khartoum (UTC +02:00)", child: Text("Africa/Khartoum (UTC +02:00)")),
    const DropdownMenuItem(value: "Africa/Kinshasa (UTC +01:00)", child: Text("Africa/Kinshasa (UTC +01:00)")),
    const DropdownMenuItem(value: "Africa/Lagos (UTC +01:00)", child: Text("Africa/Lagos (UTC +01:00)")),
    const DropdownMenuItem(value: "Africa/Libreville (UTC +01:00)", child: Text("Africa/Libreville (UTC +01:00)")),
    const DropdownMenuItem(value: "Africa/Lome (UTC +00:00)", child: Text("Africa/Lome (UTC +00:00)")),
    const DropdownMenuItem(value: "Africa/Luanda (UTC +01:00)", child: Text("Africa/Luanda (UTC +01:00)")),
    const DropdownMenuItem(value: "Africa/Lubumbashi (UTC +02:00)", child: Text("Africa/Lubumbashi (UTC +02:00)")),
    const DropdownMenuItem(value: "Africa/Lusaka (UTC +02:00)", child: Text("Africa/Lusaka (UTC +02:00)")),
    const DropdownMenuItem(value: "Africa/Malabo (UTC +01:00)", child: Text("Africa/Malabo (UTC +01:00)")),
    const DropdownMenuItem(value: "Africa/Maputo (UTC +02:00)", child: Text("Africa/Maputo (UTC +02:00)")),
    const DropdownMenuItem(value: "Africa/Maseru (UTC +02:00)", child: Text("Africa/Maseru (UTC +02:00)")),
    const DropdownMenuItem(value: "Africa/Mbabane (UTC +02:00)", child: Text("Africa/Mbabane (UTC +02:00)")),
    const DropdownMenuItem(value: "Africa/Mogadishu (UTC +03:00)", child: Text("Africa/Mogadishu (UTC +03:00)")),
    const DropdownMenuItem(value: "Africa/Monrovia (UTC +00:00)", child: Text("Africa/Monrovia (UTC +00:00)")),
    const DropdownMenuItem(value: "Africa/Nairobi (UTC +03:00)", child: Text("Africa/Nairobi (UTC +03:00)")),
    const DropdownMenuItem(value: "Africa/Ndjamena (UTC +01:00)", child: Text("Africa/Ndjamena (UTC +01:00)")),
    const DropdownMenuItem(value: "Africa/Niamey (UTC +01:00)", child: Text("Africa/Niamey (UTC +01:00)")),
    const DropdownMenuItem(value: "Africa/Nouakchott (UTC +00:00)", child: Text("Africa/Nouakchott (UTC +00:00)")),
    const DropdownMenuItem(value: "Africa/Ouagadougou (UTC +00:00)", child: Text("Africa/Ouagadougou (UTC +00:00)")),
    const DropdownMenuItem(value: "Africa/Porto-Novo (UTC +01:00", child: Text("Africa/Porto-Novo (UTC +01:00")),
    const DropdownMenuItem(value: "Africa/Sao_Tome (UTC +00:00)", child: Text("Africa/Sao_Tome (UTC +00:00)")),
    const DropdownMenuItem(value: "Africa/Timbuktu (UTC +00:00)", child: Text("Africa/Timbuktu (UTC +00:00)")),
    const DropdownMenuItem(value: "Africa/Tripoli (UTC +02:00)", child: Text("Africa/Tripoli (UTC +02:00)")),
    const DropdownMenuItem(value: "Africa/Tunis (UTC +01:00)", child: Text("Africa/Tunis (UTC +01:00)")),
    const DropdownMenuItem(value: "Africa/Windhoek (UTC +02:00)", child: Text("Africa/Windhoek (UTC +02:00)")),
    const DropdownMenuItem(value: "America/Adak (UTC -09:00)", child: Text("America/Adak (UTC -09:00)")),
    const DropdownMenuItem(value: "America/Adak (UTC -09:00)", child: Text("America/Adak (UTC -09:00)")),
    const DropdownMenuItem(value: "America/Anchorage (UTC -08:00)", child: Text("America/Anchorage (UTC -08:00)")),
    const DropdownMenuItem(value: "America/Anguilla (UTC -04:00)", child: Text("America/Anguilla (UTC -04:00)")),
    const DropdownMenuItem(value: "America/Antigua (UTC -04:00)", child: Text("America/Antigua (UTC -04:00)")),
    const DropdownMenuItem(value: "America/Araguaina (UTC -03:00)", child: Text("America/Araguaina (UTC -03:00)")),
    const DropdownMenuItem(value: "America/Argentina/Buenos_Aires (UTC -03:00)", child: Text("America/Argentina/Buenos_Aires (UTC -03:00)")),
    const DropdownMenuItem(value: "America/Argentina/Catamarca (UTC -03:00)", child: Text("America/Argentina/Catamarca (UTC -03:00)")),
    const DropdownMenuItem(value: "America/Argentina/ComodRivadavia (UTC -03:00)", child: Text("America/Argentina/ComodRivadavia (UTC -03:00)")),
    const DropdownMenuItem(value: "America/Argentina/Cordoba (UTC -03:00)", child: Text("America/Argentina/Cordoba (UTC -03:00)")),
    const DropdownMenuItem(value: "America/Argentina/Jujuy (UTC -03:00)", child: Text("America/Argentina/Jujuy (UTC -03:00)")),
    const DropdownMenuItem(value: "America/Argentina/La_Rioja (UTC -03:00)", child: Text("America/Argentina/La_Rioja (UTC -03:00)")),
    const DropdownMenuItem(value: "America/Argentina/Mendoza (UTC -03:00)", child: Text("America/Argentina/Mendoza (UTC -03:00)")),
    const DropdownMenuItem(value: "America/Argentina/Rio_Gallegos (UTC -03:00)", child: Text("America/Argentina/Rio_Gallegos (UTC -03:00)")),
    const DropdownMenuItem(value: "America/Argentina/Salta (UTC -03:00)", child: Text("America/Argentina/Salta (UTC -03:00)")),
    const DropdownMenuItem(value: "America/Argentina/San_Juan (UTC -03:00)", child: Text("America/Argentina/San_Juan (UTC -03:00)")),
    const DropdownMenuItem(value: "America/Argentina/San_Luis (UTC -03:00)", child: Text("America/Argentina/San_Luis (UTC -03:00)")),
    const DropdownMenuItem(value: "America/Argentina/Tucuman (UTC -03:00)", child: Text("America/Argentina/Tucuman (UTC -03:00)")),
    const DropdownMenuItem(value: "America/Argentina/Ushuaia (UTC -03:00)", child: Text("America/Argentina/Ushuaia (UTC -03:00)")),
    const DropdownMenuItem(value: "America/Aruba (UTC -04:00)", child: Text("America/Aruba (UTC -04:00)")),
    const DropdownMenuItem(value: "America/Asuncion (UTC -04:00)", child: Text("America/Asuncion (UTC -04:00)")),
    const DropdownMenuItem(value: "America/Atikokan (UTC -05:00)", child: Text("America/Atikokan (UTC -05:00)")),
    const DropdownMenuItem(value: "America/Atka (UTC -09:00)", child: Text("America/Atka (UTC -09:00)")),
    const DropdownMenuItem(value: "America/Bahia (UTC -03:00)", child: Text("America/Bahia (UTC -03:00)")),
    const DropdownMenuItem(value: "America/Bahia_Banderas (UTC -06:00)", child: Text("America/Bahia_Banderas (UTC -06:00)")),
    const DropdownMenuItem(value: "America/Barbados (UTC -04:00)", child: Text("America/Barbados (UTC -04:00)")),
    const DropdownMenuItem(value: "America/Belem (UTC -03:00)", child: Text("America/Belem (UTC -03:00)")),
    const DropdownMenuItem(value: "America/Belize (UTC -06:00)", child: Text("America/Belize (UTC -06:00)")),
    const DropdownMenuItem(value: "America/Blanc-Sablon (UTC -04:00)", child: Text("America/Blanc-Sablon (UTC -04:00)")),
    const DropdownMenuItem(value: "America/Boa_Vista (UTC -04:00)", child: Text("America/Boa_Vista (UTC -04:00)")),
    const DropdownMenuItem(value: "America/Bogota (UTC -05:00)", child: Text("America/Bogota (UTC -05:00)")),
    const DropdownMenuItem(value: "America/Boise (UTC -06:00)", child: Text("America/Boise (UTC -06:00)")),
    const DropdownMenuItem(value: "America/Buenos_Aires (UTC -03:00)", child: Text("America/Buenos_Aires (UTC -03:00)")),
    const DropdownMenuItem(value: "America/Cambridge_Bay (UTC -06:00)", child: Text("America/Cambridge_Bay (UTC -06:00)")),
    const DropdownMenuItem(value: "America/Campo_Grande (UTC -04:00)", child: Text("America/Campo_Grande (UTC -04:00)")),
    const DropdownMenuItem(value: "America/Cancun (UTC -05:00)", child: Text("America/Cancun (UTC -05:00)")),
    const DropdownMenuItem(value: "America/Caracas (UTC -04:00)", child: Text("America/Caracas (UTC -04:00)")),
    const DropdownMenuItem(value: "America/Catamarca (UTC -03:00)", child: Text("America/Catamarca (UTC -03:00)")),
    const DropdownMenuItem(value: "America/Cayenne (UTC -03:00)", child: Text("America/Cayenne (UTC -03:00)")),
    const DropdownMenuItem(value: "America/Cayman (UTC -05:00)", child: Text("America/Cayman (UTC -05:00)")),
    const DropdownMenuItem(value: "America/Chicago (UTC -05:00)", child: Text("America/Chicago (UTC -05:00)")),
    const DropdownMenuItem(value: "America/Chihuahua (UTC -06:00)", child: Text("America/Chihuahua (UTC -06:00)")),
    const DropdownMenuItem(value: "America/Ciudad_Juarez (UTC -06:00)", child: Text("America/Ciudad_Juarez (UTC -06:00)")),
    const DropdownMenuItem(value: "America/Coral_Harbour (UTC -05:00)", child: Text("America/Coral_Harbour (UTC -05:00)")),
    const DropdownMenuItem(value: "America/Cordoba (UTC -03:00)", child: Text("America/Cordoba (UTC -03:00)")),
    const DropdownMenuItem(value: "America/Costa_Rica (UTC -06:00)", child: Text("America/Costa_Rica (UTC -06:00)")),
    const DropdownMenuItem(value: "America/Creston (UTC -07:00)", child: Text("America/Creston (UTC -07:00)")),
    const DropdownMenuItem(value: "America/Cuiaba (UTC -04:00)", child: Text("America/Cuiaba (UTC -04:00)")),
    const DropdownMenuItem(value: "America/Curacao (UTC -04:00)", child: Text("America/Curacao (UTC -04:00)")),
    const DropdownMenuItem(value: "America/Danmarkshavn (UTC +00:00)", child: Text("America/Danmarkshavn (UTC +00:00)")),
    const DropdownMenuItem(value: "America/Dawson (UTC -07:00)", child: Text("America/Dawson (UTC -07:00)")),
    const DropdownMenuItem(value: "America/Dawson_Creek (UTC -07:00)", child: Text("America/Dawson_Creek (UTC -07:00)")),
    const DropdownMenuItem(value: "America/Denver (UTC -06:00)", child: Text("America/Denver (UTC -06:00)")),
    const DropdownMenuItem(value: "America/Detroit (UTC -04:00)", child: Text("America/Detroit (UTC -04:00)")),
    const DropdownMenuItem(value: "America/Dominica (UTC -04:00)", child: Text("America/Dominica (UTC -04:00)")),
    const DropdownMenuItem(value: "America/Edmonton (UTC -06:00)", child: Text("America/Edmonton (UTC -06:00)")),
    const DropdownMenuItem(value: "America/Eirunepe (UTC -05:00)", child: Text("America/Eirunepe (UTC -05:00)")),
    const DropdownMenuItem(value: "America/El_Salvador (UTC -06:00)", child: Text("America/El_Salvador (UTC -06:00)")),
    const DropdownMenuItem(value: "America/Ensenada (UTC -07:00)", child: Text("America/Ensenada (UTC -07:00)")),
    const DropdownMenuItem(value: "America/Fort_Nelson (UTC -07:00)", child: Text("America/Fort_Nelson (UTC -07:00)")),
    const DropdownMenuItem(value: "America/Fort_Wayne (UTC -04:00)", child: Text("America/Fort_Wayne (UTC -04:00)")),
    const DropdownMenuItem(value: "America/Fortaleza (UTC -03:00)", child: Text("America/Fortaleza (UTC -03:00)")),
    const DropdownMenuItem(value: "America/Glace_Bay (UTC -03:00)", child: Text("America/Glace_Bay (UTC -03:00)")),
    const DropdownMenuItem(value: "America/Godthab (UTC -02:00)", child: Text("America/Godthab (UTC -02:00)")),
    const DropdownMenuItem(value: "America/Goose_Bay (UTC -03:00)", child: Text("America/Goose_Bay (UTC -03:00)")),
    const DropdownMenuItem(value: "America/Grand_Turk (UTC -04:00)", child: Text("America/Grand_Turk (UTC -04:00)")),
    const DropdownMenuItem(value: "America/Grenada (UTC -04:00)", child: Text("America/Grenada (UTC -04:00)")),
    const DropdownMenuItem(value: "America/Guadeloupe (UTC -04:00)", child: Text("America/Guadeloupe (UTC -04:00)")),
    const DropdownMenuItem(value: "America/Guatemala (UTC -06:00)", child: Text("America/Guatemala (UTC -06:00)")),
    const DropdownMenuItem(value: "America/Guayaquil (UTC -05:00)", child: Text("America/Guayaquil (UTC -05:00)")),
    const DropdownMenuItem(value: "America/Guyana (UTC -04:00)", child: Text("America/Guyana (UTC -04:00)")),
    const DropdownMenuItem(value: "America/Halifax (UTC -03:00)", child: Text("America/Halifax (UTC -03:00)")),
    const DropdownMenuItem(value: "America/Havana (UTC -04:00)", child: Text("America/Havana (UTC -04:00)")),
    const DropdownMenuItem(value: "America/Hermosillo (UTC -07:00)", child: Text("America/Hermosillo (UTC -07:00)")),
    const DropdownMenuItem(value: "America/Indiana/Indianapolis (UTC -04:00)", child: Text("America/Indiana/Indianapolis (UTC -04:00)")),
    const DropdownMenuItem(value: "America/Indiana/Knox (UTC -05:00)", child: Text("America/Indiana/Knox (UTC -05:00)")),
    const DropdownMenuItem(value: "America/Indiana/Marengo (UTC -04:00)", child: Text("America/Indiana/Marengo (UTC -04:00)")),
    const DropdownMenuItem(value: "America/Indiana/Petersburg (UTC -04:00)", child: Text("America/Indiana/Petersburg (UTC -04:00)")),
    const DropdownMenuItem(value: "America/Indiana/Tell_City (UTC -05:00)", child: Text("America/Indiana/Tell_City (UTC -05:00)")),
    const DropdownMenuItem(value: "America/Indiana/Vevay (UTC -04:00)", child: Text("America/Indiana/Vevay (UTC -04:00)")),
    const DropdownMenuItem(value: "America/Indiana/Vincennes (UTC -04:00)", child: Text("America/Indiana/Vincennes (UTC -04:00)")),
    const DropdownMenuItem(value: "America/Indiana/Winamac (UTC -04:00)", child: Text("America/Indiana/Winamac (UTC -04:00)")),
    const DropdownMenuItem(value: "America/Indianapolis (UTC -04:00)", child: Text("America/Indianapolis (UTC -04:00)")),
    const DropdownMenuItem(value: "America/Inuvik (UTC -06:00)", child: Text("America/Inuvik (UTC -06:00)")),
    const DropdownMenuItem(value: "America/Iqaluit (UTC -04:00)", child: Text("America/Iqaluit (UTC -04:00)")),
    const DropdownMenuItem(value: "America/Jamaica (UTC -05:00)", child: Text("America/Jamaica (UTC -05:00)")),
    const DropdownMenuItem(value: "America/Jujuy (UTC -03:00)", child: Text("America/Jujuy (UTC -03:00)")),
    const DropdownMenuItem(value: "America/Juneau (UTC -08:00)", child: Text("America/Juneau (UTC -08:00)")),
    const DropdownMenuItem(value: "America/Kentucky/Louisville (UTC -04:00)", child: Text("America/Kentucky/Louisville (UTC -04:00)")),
    const DropdownMenuItem(value: "America/Kentucky/Monticello (UTC -04:00)", child: Text("America/Kentucky/Monticello (UTC -04:00)")),
    const DropdownMenuItem(value: "America/Knox_IN (UTC -05:00)", child: Text("America/Knox_IN (UTC -05:00)")),
    const DropdownMenuItem(value: "America/Kralendijk (UTC -04:00)", child: Text("America/Kralendijk (UTC -04:00)")),
    const DropdownMenuItem(value: "America/La_Paz (UTC -04:00)", child: Text("America/La_Paz (UTC -04:00)")),
    const DropdownMenuItem(value: "America/Lima (UTC -05:00)", child: Text("America/Lima (UTC -05:00)")),
    const DropdownMenuItem(value: "America/Los_Angeles (UTC -07:00)", child: Text("America/Los_Angeles (UTC -07:00)")),
    const DropdownMenuItem(value: "America/Louisville (UTC -04:00)", child: Text("America/Louisville (UTC -04:00)")),
    const DropdownMenuItem(value: "America/Lower_Princes (UTC -04:00)", child: Text("America/Lower_Princes (UTC -04:00)")),
    const DropdownMenuItem(value: "America/Maceio (UTC -03:00)", child: Text("America/Maceio (UTC -03:00)")),
    const DropdownMenuItem(value: "America/Managua (UTC -06:00)", child: Text("America/Managua (UTC -06:00)")),
    const DropdownMenuItem(value: "America/Manaus (UTC -04:00)", child: Text("America/Manaus (UTC -04:00)")),
    const DropdownMenuItem(value: "America/Marigot (UTC -04:00)", child: Text("America/Marigot (UTC -04:00)")),
    const DropdownMenuItem(value: "America/Martinique (UTC -04:00)", child: Text("America/Martinique (UTC -04:00)")),
    const DropdownMenuItem(value: "America/Matamoros (UTC -05:00)", child: Text("America/Matamoros (UTC -05:00)")),
    const DropdownMenuItem(value: "America/Mazatlan (UTC -07:00)", child: Text("America/Mazatlan (UTC -07:00)")),
    const DropdownMenuItem(value: "America/Mendoza (UTC -03:00)", child: Text("America/Mendoza (UTC -03:00)")),
    const DropdownMenuItem(value: "America/Menominee (UTC -05:00)", child: Text("America/Menominee (UTC -05:00)")),
    const DropdownMenuItem(value: "America/Merida (UTC -06:00)", child: Text("America/Merida (UTC -06:00)")),
    const DropdownMenuItem(value: "America/Metlakatla (UTC -08:00)", child: Text("America/Metlakatla (UTC -08:00)")),
    const DropdownMenuItem(value: "America/Mexico_City (UTC -06:00)", child: Text("America/Mexico_City (UTC -06:00)")),
    const DropdownMenuItem(value: "America/Miquelon (UTC -02:00)", child: Text("America/Miquelon (UTC -02:00)")),
    const DropdownMenuItem(value: "America/Moncton (UTC -03:00)", child: Text("America/Moncton (UTC -03:00)")),
    const DropdownMenuItem(value: "America/Montevideo (UTC -03:00)", child: Text("America/Montevideo (UTC -03:00)")),
    const DropdownMenuItem(value: "America/Montreal (UTC -04:00)", child: Text("America/Montreal (UTC -04:00)")),
    const DropdownMenuItem(value: "America/Montserrat (UTC -04:00)", child: Text("America/Montserrat (UTC -04:00)")),
    const DropdownMenuItem(value: "America/Nassau (UTC -04:00)", child: Text("America/Nassau (UTC -04:00)")),
    const DropdownMenuItem(value: "America/New_York (UTC -04:00)", child: Text("America/New_York (UTC -04:00)")),
    const DropdownMenuItem(value: "America/Nipigon (UTC -04:00)", child: Text("America/Nipigon (UTC -04:00)")),
    const DropdownMenuItem(value: "America/Nome (UTC -08:00)", child: Text("America/Nome (UTC -08:00)")),
    const DropdownMenuItem(value: "America/Noronha (UTC -02:00)", child: Text("America/Noronha (UTC -02:00)")),
    const DropdownMenuItem(value: "America/North_Dakota/Beulah (UTC -05:00)", child: Text("America/North_Dakota/Beulah (UTC -05:00)")),
    const DropdownMenuItem(value: "America/North_Dakota/Center (UTC -05:00)", child: Text("America/North_Dakota/Center (UTC -05:00)")),
    const DropdownMenuItem(value: "America/North_Dakota/New_Salem (UTC -05:00)", child: Text("America/North_Dakota/New_Salem (UTC -05:00)")),
    const DropdownMenuItem(value: "America/Nuuk (UTC -02:00)", child: Text("America/Nuuk (UTC -02:00)")),
    const DropdownMenuItem(value: "America/Ojinaga (UTC -05:00)", child: Text("America/Ojinaga (UTC -05:00)")),
    const DropdownMenuItem(value: "America/Panama (UTC -05:00)", child: Text("America/Panama (UTC -05:00)")),
    const DropdownMenuItem(value: "America/Pangnirtung (UTC -04:00)", child: Text("America/Pangnirtung (UTC -04:00)")),
    const DropdownMenuItem(value: "America/Paramaribo (UTC -03:00)", child: Text("America/Paramaribo (UTC -03:00)")),
    const DropdownMenuItem(value: "America/Phoenix (UTC -07:00)", child: Text("America/Phoenix (UTC -07:00)")),
    const DropdownMenuItem(value: "America/Port-au-Prince (UTC -04)", child: Text("AAmerica/Port-au-Prince (UTC -04")),
    const DropdownMenuItem(value: "America/Port_of_Spain (UTC -04:00)", child: Text("America/Port_of_Spain (UTC -04:00)")),
    const DropdownMenuItem(value: "America/Porto_Acre (UTC -05:00)", child: Text("America/Porto_Acre (UTC -05:00)")),
    const DropdownMenuItem(value: "America/Porto_Velho (UTC -04:00)", child: Text("America/Porto_Velho (UTC -04:00)")),
    const DropdownMenuItem(value: "America/Puerto_Rico (UTC -04:00)", child: Text("America/Puerto_Rico (UTC -04:00)")),
    const DropdownMenuItem(value: "America/Punta_Arenas (UTC -03:00)", child: Text("America/Punta_Arenas (UTC -03:00)")),
    const DropdownMenuItem(value: "America/Rainy_River (UTC -05:00)", child: Text("America/Rainy_River (UTC -05:00)")),
    const DropdownMenuItem(value: "America/Rankin_Inlet (UTC -05:00)", child: Text("America/Rankin_Inlet (UTC -05:00)")),
    const DropdownMenuItem(value: "America/Recife (UTC -03:00)", child: Text("America/Recife (UTC -03:00)")),
    const DropdownMenuItem(value: "America/Regina (UTC -06:00)", child: Text("America/Regina (UTC -06:00)")),
    const DropdownMenuItem(value: "America/Resolute (UTC -05:00)", child: Text("America/Resolute (UTC -05:00)")),
    const DropdownMenuItem(value: "America/Rio_Branco (UTC -05:00)", child: Text("America/Rio_Branco (UTC -05:00)")),
    const DropdownMenuItem(value: "America/Rosario (UTC -03:00)", child: Text("America/Rosario (UTC -03:00)")),
    const DropdownMenuItem(value: "America/Santa_Isabel (UTC -07:00)", child: Text("America/Santa_Isabel (UTC -07:00)")),
    const DropdownMenuItem(value: "America/Santarem (UTC -03:00)", child: Text("America/Santarem (UTC -03:00)")),
    const DropdownMenuItem(value: "America/Santiago (UTC -03:00)", child: Text("America/Santiago (UTC -03:00)")),
    const DropdownMenuItem(value: "America/Santo_Domingo (UTC -04:00)", child: Text("America/Santo_Domingo (UTC -04:00)")),
    const DropdownMenuItem(value: "America/Sao_Paulo (UTC -03:00)", child: Text("America/Sao_Paulo (UTC -03:00)")),
    const DropdownMenuItem(value: "America/Scoresbysund (UTC +00:00)", child: Text("America/Scoresbysund (UTC +00:00)")),
    const DropdownMenuItem(value: "America/Shiprock (UTC -06:00)", child: Text("America/Shiprock (UTC -06:00)")),
    const DropdownMenuItem(value: "America/Sitka (UTC -08:00)", child: Text("America/Sitka (UTC -08:00)")),
    const DropdownMenuItem(value: "America/St_Barthelemy (UTC -04:00)", child: Text("America/St_Barthelemy (UTC -04:00)")),
    const DropdownMenuItem(value: "America/St_Johns (UTC -02:30)", child: Text("America/St_Johns (UTC -02:30)")),
    const DropdownMenuItem(value: "America/St_Kitts (UTC -04:00)", child: Text("America/St_Kitts (UTC -04:00)")),
    const DropdownMenuItem(value: "America/St_Lucia (UTC -04:00)", child: Text("America/St_Lucia (UTC -04:00)")),
    const DropdownMenuItem(value: "America/St_Thomas (UTC -04:00)", child: Text("America/St_Thomas (UTC -04:00)")),
    const DropdownMenuItem(value: "America/St_Vincent (UTC -04:00)", child: Text("America/St_Vincent (UTC -04:00)")),
    const DropdownMenuItem(value: "America/Swift_Current (UTC -06:00)", child: Text("America/Swift_Current (UTC -06:00)")),
    const DropdownMenuItem(value: "America/Tegucigalpa (UTC -06:00)", child: Text("America/Tegucigalpa (UTC -06:00)")),
    const DropdownMenuItem(value: "America/Thule (UTC -03:00)", child: Text("America/Thule (UTC -03:00)")),
    const DropdownMenuItem(value: "America/Thunder_Bay (UTC -04:00)", child: Text("America/Thunder_Bay (UTC -04:00)")),
    const DropdownMenuItem(value: "America/Tijuana (UTC -07:00)", child: Text("America/Tijuana (UTC -07:00)")),
    const DropdownMenuItem(value: "America/Toronto (UTC -04:00)", child: Text("America/Toronto (UTC -04:00)")),
    const DropdownMenuItem(value: "America/Tortola (UTC -04:00)", child: Text("America/Tortola (UTC -04:00)")),
    const DropdownMenuItem(value: "America/Vancouver (UTC -07:00)", child: Text("America/Vancouver (UTC -07:00)")),
    const DropdownMenuItem(value: "America/Virgin (UTC -04:00)", child: Text("America/Virgin (UTC -04:00)")),
    const DropdownMenuItem(value: "America/Whitehorse (UTC -07:00)", child: Text("America/Whitehorse (UTC -07:00)")),
    const DropdownMenuItem(value: "America/Winnipeg (UTC -05:00)", child: Text("America/Winnipeg (UTC -05:00)")),
    const DropdownMenuItem(value: "America/Yakutat (UTC -08:00)", child: Text("America/Yakutat (UTC -08:00)")),
    const DropdownMenuItem(value: "America/Yellowknife (UTC -06:00)", child: Text("America/Yellowknife (UTC -06:00)")),
    const DropdownMenuItem(value: "Antarctica/Casey (UTC +11:00)", child: Text("Antarctica/Casey (UTC +11:00)")),
    const DropdownMenuItem(value: "Antarctica/Davis (UTC +07:00)", child: Text("Antarctica/Davis (UTC +07:00)")),
    const DropdownMenuItem(value: "Antarctica/DumontDUrville (UTC +10:00)", child: Text("Antarctica/DumontDUrville (UTC +10:00)")),
    const DropdownMenuItem(value: "Antarctica/Macquarie (UTC +10:00)", child: Text("Antarctica/Macquarie (UTC +10:00)")),
    const DropdownMenuItem(value: "Antarctica/Mawson (UTC +05:00)", child: Text("Antarctica/Mawson (UTC +05:00)")),
    const DropdownMenuItem(value: "Antarctica/McMurdo (UTC +12:00)", child: Text("Antarctica/McMurdo (UTC +12:00)")),
    const DropdownMenuItem(value: "Antarctica/Palmer (UTC -03:00)", child: Text("Antarctica/Palmer (UTC -03:00)")),
    const DropdownMenuItem(value: "Antarctica/Rothera (UTC -03:00)", child: Text("Antarctica/Rothera (UTC -03:00)")),
    const DropdownMenuItem(value: "Antarctica/South_Pole (UTC +12:00)", child: Text("Antarctica/South_Pole (UTC +12:00)")),
    const DropdownMenuItem(value: "Antarctica/Syowa (UTC +03:00)", child: Text("Antarctica/Syowa (UTC +03:00)")),
    const DropdownMenuItem(value: "Antarctica/Troll (UTC +02:00)", child: Text("Antarctica/Troll (UTC +02:00)")),
    const DropdownMenuItem(value: "Antarctica/Vostok (UTC +06:00)", child: Text("Antarctica/Vostok (UTC +06:00)")),
    const DropdownMenuItem(value: "Arctic/Longyearbyen (UTC +02:00)", child: Text("Arctic/Longyearbyen (UTC +02:00)")),
    const DropdownMenuItem(value: "Asia/Aden (UTC +03:00)", child: Text("Asia/Aden (UTC +03:00)")),
    const DropdownMenuItem(value: "Asia/Almaty (UTC +06:00)", child: Text("Asia/Almaty (UTC +06:00)")),
    const DropdownMenuItem(value: "Asia/Amman (UTC +03:00)", child: Text("Asia/Amman (UTC +03:00)")),
    const DropdownMenuItem(value: "Asia/Anadyr (UTC +12:00)", child: Text("Asia/Anadyr (UTC +12:00)")),
    const DropdownMenuItem(value: "Asia/Aqtau (UTC +05:00)", child: Text("Asia/Aqtau (UTC +05:00)")),
    const DropdownMenuItem(value: "Asia/Aqtobe (UTC +05:00)", child: Text("Asia/Aqtobe (UTC +05:00)")),
    const DropdownMenuItem(value: "Asia/Ashgabat (UTC +05:00)", child: Text("Asia/Ashgabat (UTC +05:00)")),
    const DropdownMenuItem(value: "Asia/Ashkhabad (UTC +05:00)", child: Text("Asia/Ashkhabad (UTC +05:00)")),
    const DropdownMenuItem(value: "Asia/Atyrau (UTC +05:00)", child: Text("Asia/Atyrau (UTC +05:00)")),
    const DropdownMenuItem(value: "Asia/Baghdad (UTC +03:00)", child: Text("Asia/Baghdad (UTC +03:00)")),
    const DropdownMenuItem(value: "Asia/Bahrain (UTC +03:00)", child: Text("Asia/Bahrain (UTC +03:00)")),
    const DropdownMenuItem(value: "Asia/Baku (UTC +04:00)", child: Text("Asia/Baku (UTC +04:00)")),
    const DropdownMenuItem(value: "Asia/Bangkok (UTC +07:00))", child: Text("Asia/Bangkok (UTC +07:00)")),
    const DropdownMenuItem(value: "Asia/Barnaul (UTC +07:00)", child: Text("Asia/Barnaul (UTC +07:00))")),
    const DropdownMenuItem(value: "Asia/Beirut (UTC +03:00)", child: Text("Asia/Beirut (UTC +03:00)")),
    const DropdownMenuItem(value: "Asia/Bishkek (UTC +06:00)", child: Text("Asia/Bishkek (UTC +06:00)")),
    const DropdownMenuItem(value: "Asia/Brunei (UTC +08:00)", child: Text("Asia/Brunei (UTC +08:00)")),
    const DropdownMenuItem(value: "Asia/Chita (UTC +09:00)", child: Text("Asia/Chita (UTC +09:00)")),
    const DropdownMenuItem(value: "Asia/Choibalsan (UTC +08:00)", child: Text("Asia/Choibalsan (UTC +08:00)")),
    const DropdownMenuItem(value: "Asia/Chongqing (UTC +08:00)", child: Text("Asia/Chongqing (UTC +08:00)")),
    const DropdownMenuItem(value: "Asia/Chungking (UTC +08:00)", child: Text("Asia/Chungking (UTC +08:00)")),
    const DropdownMenuItem(value: "Asia/Colombo (UTC +05:30)", child: Text("Asia/Colombo (UTC +05:30)")),
    const DropdownMenuItem(value: "Asia/Dacca (UTC +06:00)", child: Text("Asia/Dacca (UTC +06:00)")),
    const DropdownMenuItem(value: "Asia/Damascus (UTC +03:00)", child: Text("Asia/Damascus (UTC +03:00)")),
    const DropdownMenuItem(value: "Asia/Dhaka (UTC +06:00))", child: Text("Asia/Dhaka (UTC +06:00)")),
    const DropdownMenuItem(value: "Asia/Dili (UTC +09:00)", child: Text("Asia/Dili (UTC +09:00)")),
    const DropdownMenuItem(value: "Asia/Dubai (UTC +04:00)", child: Text("Asia/Dubai (UTC +04:00)")),
    const DropdownMenuItem(value: "Asia/Dushanbe (UTC +05:00)", child: Text("Asia/Dushanbe (UTC +05:00)")),
    const DropdownMenuItem(value: "Asia/Famagusta (UTC +03:00)", child: Text("Asia/Famagusta (UTC +03:00)")),
    const DropdownMenuItem(value: "Asia/Gaza (UTC +03:00)", child: Text("Asia/Gaza (UTC +03:00)")),
    const DropdownMenuItem(value: "Asia/Harbin (UTC +08:00)", child: Text("Asia/Harbin (UTC +08:00)")),
    const DropdownMenuItem(value: "Asia/Hebron (UTC +03:00)", child: Text("Asia/Hebron (UTC +03:00)")),
    const DropdownMenuItem(value: "Asia/Ho_Chi_Minh (UTC +07:00)", child: Text("Asia/Ho_Chi_Minh (UTC +07:00)")),
    const DropdownMenuItem(value: "Asia/Hong_Kong (UTC +08:00)", child: Text("Asia/Hong_Kong (UTC +08:00)")),
    const DropdownMenuItem(value: "Asia/Hovd (UTC +07:00)", child: Text("Asia/Hovd (UTC +07:00)")),
    const DropdownMenuItem(value: "Asia/Irkutsk (UTC +08:00)", child: Text("Asia/Irkutsk (UTC +08:00)")),
    const DropdownMenuItem(value: "Asia/Istanbul (UTC +03:00)", child: Text("Asia/Istanbul (UTC +03:00)")),
    const DropdownMenuItem(value: "Asia/Jakarta (UTC +07:00)", child: Text("Asia/Jakarta (UTC +07:00)")),
    const DropdownMenuItem(value: "Asia/Jayapura (UTC +09:00)", child: Text("Asia/Jayapura (UTC +09:00)")),
    const DropdownMenuItem(value: "Asia/Jerusalem (UTC +03:00)", child: Text("Asia/Jerusalem (UTC +03:00))")),
    const DropdownMenuItem(value: "Asia/Kabul (UTC +04:30)", child: Text("Asia/Kabul (UTC +04:30)")),
    const DropdownMenuItem(value: "Asia/Kamchatka (UTC +12:00)", child: Text("Asia/Kamchatka (UTC +12:00)")),
    const DropdownMenuItem(value: "Asia/Karachi (UTC +05:00)", child: Text("Asia/Karachi (UTC +05:00)")),
    const DropdownMenuItem(value: "Asia/Kashgar (UTC +06:00)", child: Text("Asia/Kashgar (UTC +06:00)")),
    const DropdownMenuItem(value: "Asia/Kathmandu (UTC +05:45)", child: Text("Asia/Kathmandu (UTC +05:45)")),
    const DropdownMenuItem(value: "Asia/Katmandu (UTC +05:45)", child: Text("Asia/Katmandu (UTC +05:45)")),
    const DropdownMenuItem(value: "Asia/Khandyga (UTC +09:00)", child: Text("Asia/Khandyga (UTC +09:00)")),
    const DropdownMenuItem(value: "Asia/Kolkata (UTC +05:30)", child: Text("Asia/Kolkata (UTC +05:30)")),
    const DropdownMenuItem(value: "Asia/Krasnoyarsk (UTC +07:00)", child: Text("Asia/Krasnoyarsk (UTC +07:00)")),
    const DropdownMenuItem(value: "Asia/Kuala_Lumpur (UTC +08:00)", child: Text("Asia/Kuala_Lumpur (UTC +08:00)")),
    const DropdownMenuItem(value: "Asia/Kuching (UTC +08:00)", child: Text("Asia/Kuching (UTC +08:00)")),
    const DropdownMenuItem(value: "Asia/Kuwait (UTC +03:00)", child: Text("Asia/Kuwait (UTC +03:00)")),
    const DropdownMenuItem(value: "Asia/Macao (UTC +08:00)", child: Text("Asia/Macao (UTC +08:00)")),
    const DropdownMenuItem(value: "Asia/Macau (UTC +08:00))", child: Text("Asia/Macau (UTC +08:00)")),
    const DropdownMenuItem(value: "Asia/Magadan (UTC +11:00)", child: Text("Asia/Magadan (UTC +11:00)")),
    const DropdownMenuItem(value: "Asia/Makassar (UTC +08:00)", child: Text("Asia/Makassar (UTC +08:00)")),
    const DropdownMenuItem(value: "Asia/Manila (UTC +08:00)", child: Text("Asia/Manila (UTC +08:00)")),
    const DropdownMenuItem(value: "Asia/Muscat (UTC +04:00)", child: Text("Asia/Muscat (UTC +04:00)")),
    const DropdownMenuItem(value: "Asia/Nicosia (UTC +03:00)", child: Text("Asia/Nicosia (UTC +03:00)")),
    const DropdownMenuItem(value: "Asia/Novokuznetsk (UTC +07:00)", child: Text("Asia/Novokuznetsk (UTC +07:00)")),
    const DropdownMenuItem(value: "Asia/Novosibirsk (UTC +07:00)", child: Text("Asia/Novosibirsk (UTC +07:00)")),
    const DropdownMenuItem(value: "Asia/Omsk (UTC +06:00)", child: Text("Asia/Omsk (UTC +06:00)")),
    const DropdownMenuItem(value: "Asia/Oral (UTC +05:00)", child: Text("Asia/Oral (UTC +05:00)")),
    const DropdownMenuItem(value: "Asia/Phnom_Penh (UTC +07:00)", child: Text("Asia/Phnom_Penh (UTC +07:00)")),
    const DropdownMenuItem(value: "Asia/Pontianak (UTC +07:00)", child: Text("Asia/Pontianak (UTC +07:00)")),
    const DropdownMenuItem(value: "Asia/Pyongyang (UTC +09:00)", child: Text("Asia/Pyongyang (UTC +09:00)")),
    const DropdownMenuItem(value: "Asia/Qatar (UTC +03:00)", child: Text("Asia/Qatar (UTC +03:00)")),
    const DropdownMenuItem(value: "Asia/Qostanay (UTC +06:00)", child: Text("Asia/Qostanay (UTC +06:00)")),
    const DropdownMenuItem(value: "AAsia/Qyzylorda (UTC +05:00))", child: Text("Asia/Qyzylorda (UTC +05:00)")),
    const DropdownMenuItem(value: "Asia/Rangoon (UTC +06:30)", child: Text("Asia/Rangoon (UTC +06:30)")),
    const DropdownMenuItem(value: "Asia/Riyadh (UTC +03:00)", child: Text("Asia/Riyadh (UTC +03:00)")),
    const DropdownMenuItem(value: "Asia/Saigon (UTC +07:00)", child: Text("Asia/Saigon (UTC +07:00)")),
    const DropdownMenuItem(value: "Asia/Sakhalin (UTC +11:00)", child: Text("Asia/Sakhalin (UTC +11:00)")),
    const DropdownMenuItem(value: "Asia/Samarkand (UTC +05:00)", child: Text("Asia/Samarkand (UTC +05:00)")),
    const DropdownMenuItem(value: "Asia/Seoul (UTC +09:00))", child: Text("Asia/Seoul (UTC +09:00)")),
    const DropdownMenuItem(value: "Asia/Shanghai (UTC +08:00)", child: Text("Asia/Shanghai (UTC +08:00)")),
    const DropdownMenuItem(value: "Asia/Singapore (UTC +08:00)", child: Text("Asia/Singapore (UTC +08:00)")),
    const DropdownMenuItem(value: "Asia/Srednekolymsk (UTC +11:00)", child: Text("Asia/Srednekolymsk (UTC +11:00)")),
    const DropdownMenuItem(value: "Asia/Taipei (UTC +08:00)", child: Text("Asia/Taipei (UTC +08:00)")),
    const DropdownMenuItem(value: "Asia/Tashkent (UTC +05:00)", child: Text("Asia/Tashkent (UTC +05:00)")),
    const DropdownMenuItem(value: "Asia/Tbilisi (UTC +04:00)", child: Text("Asia/Tbilisi (UTC +04:00)")),
    const DropdownMenuItem(value: "Asia/Tehran (UTC +03:30)", child: Text("Asia/Tehran (UTC +03:30)")),
    const DropdownMenuItem(value: "Asia/Tel_Aviv (UTC +03:00)", child: Text("Asia/Tel_Aviv (UTC +03:00)")),
    const DropdownMenuItem(value: "Asia/Thimbu (UTC +06:00)", child: Text("Asia/Thimbu (UTC +06:00)")),
    const DropdownMenuItem(value: "Asia/Thimphu (UTC +06:00)", child: Text("Asia/Thimphu (UTC +06:00)")),
    const DropdownMenuItem(value: "Asia/Tokyo (UTC +09:00)", child: Text("Asia/Tokyo (UTC +09:00)")),
    const DropdownMenuItem(value: "Asia/Tomsk (UTC +07:00)", child: Text("Asia/Tomsk (UTC +07:00)")),
    const DropdownMenuItem(value: "Asia/Ujung_Pandang (UTC +08:00)", child: Text("Asia/Ujung_Pandang (UTC +08:00)")),
    const DropdownMenuItem(value: "Asia/Ulaanbaatar (UTC +08:00)", child: Text("Asia/Ulaanbaatar (UTC +08:00)")),
    const DropdownMenuItem(value: "Asia/Ulan_Bator (UTC +08:00)", child: Text("Asia/Ulan_Bator (UTC +08:00)")),
    const DropdownMenuItem(value: "Asia/Urumqi (UTC +06:00)", child: Text("Asia/Urumqi (UTC +06:00)")),
    const DropdownMenuItem(value: "Asia/Ust-Nera (UTC +10:00)", child: Text("Asia/Ust-Nera (UTC +10:00)")),
    const DropdownMenuItem(value: "Asia/Vientiane (UTC +07:00)", child: Text("Asia/Vientiane (UTC +07:00)")),
    const DropdownMenuItem(value: "Asia/Vladivostok (UTC +10:00)", child: Text("AAsia/Vladivostok (UTC +10:00)")),
    const DropdownMenuItem(value: "Asia/Yakutsk (UTC +09:00)", child: Text("Asia/Yakutsk (UTC +09:00)")),
    const DropdownMenuItem(value: "Asia/Yakutsk (UTC +09:00)", child: Text("Asia/Yakutsk (UTC +09:00)")),
    const DropdownMenuItem(value: "Asia/Yangon (UTC +06:30)", child: Text("Asia/Yangon (UTC +06:30)")),
    const DropdownMenuItem(value: "Asia/Yekaterinburg (UTC +05:00)", child: Text("Asia/Yekaterinburg (UTC +05:00)")),
    const DropdownMenuItem(value: "Asia/Yerevan (UTC +04:00)", child: Text("Asia/Yerevan (UTC +04:00)")),
    const DropdownMenuItem(value: "Atlantic/Azores (UTC +00:00)", child: Text("Atlantic/Azores (UTC +00:00)")),
    const DropdownMenuItem(value: "Atlantic/Bermuda (UTC -03:00)", child: Text("Atlantic/Bermuda (UTC -03:00)")),
    const DropdownMenuItem(value: "Atlantic/Canary (UTC +01:00)", child: Text("Atlantic/Canary (UTC +01:00)")),
    const DropdownMenuItem(value: "Atlantic/Cape_Verde (UTC -01:00))", child: Text("Atlantic/Cape_Verde (UTC -01:00)")),
    const DropdownMenuItem(value: "Atlantic/Faeroe (UTC +01:00)", child: Text("Atlantic/Faeroe (UTC +01:00)")),
    const DropdownMenuItem(value: "Atlantic/Faroe (UTC +01:00)", child: Text("Atlantic/Faroe (UTC +01:00)")),
    const DropdownMenuItem(value: "Atlantic/Jan_Mayen (UTC +02:00)", child: Text("Atlantic/Jan_Mayen (UTC +02:00)")),
    const DropdownMenuItem(value: "Atlantic/Madeira (UTC +01:00)", child: Text("Atlantic/Madeira (UTC +01:00)")),
    const DropdownMenuItem(value: "Atlantic/Reykjavik (UTC +00:00)", child: Text("Atlantic/Reykjavik (UTC +00:00)")),
    const DropdownMenuItem(value: "Atlantic/South_Georgia (UTC -02:00)", child: Text("Atlantic/South_Georgia (UTC -02:00)")),
    const DropdownMenuItem(value: "Atlantic/St_Helena (UTC +00:00)", child: Text("Atlantic/St_Helena (UTC +00:00)")),
    const DropdownMenuItem(value: "Atlantic/Stanley (UTC -03:00)", child: Text("Atlantic/Stanley (UTC -03:00)")),
    const DropdownMenuItem(value: "Australia/ACT (UTC +10:00)", child: Text("Australia/ACT (UTC +10:00)")),
    const DropdownMenuItem(value: "Australia/Adelaide (UTC +09:30)", child: Text("Australia/Adelaide (UTC +09:30)")),
    const DropdownMenuItem(value: "Australia/Brisbane (UTC +10:00)", child: Text("Australia/Brisbane (UTC +10:00)")),
    const DropdownMenuItem(value: "Australia/Broken_Hill (UTC +09:30)", child: Text("Australia/Broken_Hill (UTC +09:30)")),
    const DropdownMenuItem(value: "Australia/Canberra (UTC +10:00)", child: Text("Australia/Canberra (UTC +10:00)")),
    const DropdownMenuItem(value: "Australia/Currie (UTC +10:00)", child: Text("Australia/Currie (UTC +10:00)")),
  ];
  return menuItems;
}

/*



Australia/Darwin (UTC +09:30)
Australia/Eucla (UTC +08:45)
Australia/Hobart (UTC +10:00)
Australia/LHI (UTC +10:30)
Australia/Lindeman (UTC +10:00)
Australia/Lord_Howe (UTC +10:30)
Australia/Melbourne (UTC +10:00)
Australia/NSW (UTC +10:00)
Australia/North (UTC +09:30)
Australia/Perth (UTC +08:00)
Australia/Queensland (UTC +10:00)
Australia/South (UTC +09:30)
Australia/Sydney (UTC +10:00)
Australia/Tasmania (UTC +10:00)
Australia/Victoria (UTC +10:00)
Australia/West (UTC +08:00)
Australia/Yancowinna (UTC +09:30)
Brazil/Acre (UTC -05:00)
Brazil/DeNoronha (UTC -02:00)
Brazil/East (UTC -03:00)
Brazil/West (UTC -04:00)
CET (UTC +02:00)
CST6CDT (UTC -05:00)
Canada/Atlantic (UTC -03:00)
Canada/Central (UTC -05:00)
Canada/Eastern (UTC -04:00)
Canada/Mountain (UTC -06:00)
Canada/Newfoundland (UTC -02:30)
Canada/Pacific (UTC -07:00)
Canada/Saskatchewan (UTC -06:00)
Canada/Yukon (UTC -07:00)
Chile/Continental (UTC -03:00)
Chile/EasterIsland (UTC -05:00)
Cuba (UTC -04:00)
EET (UTC +03:00)
EST (UTC -05:00)
EST5EDT (UTC -04:00)
Egypt (UTC +03:00)
Eire (UTC +01:00)
Etc/GMT (UTC +00:00)
Etc/GMT+0 (UTC +00:00
Etc/GMT+1 (UTC -01:00
Etc/GMT+10 (UTC -10:00
Etc/GMT+11 (UTC -11:00
Etc/GMT+12 (UTC -12:00
Etc/GMT+2 (UTC -02:00
Etc/GMT+3 (UTC -03:00
Etc/GMT+4 (UTC -04:00
Etc/GMT+5 (UTC -05:00
Etc/GMT+6 (UTC -06:00
Etc/GMT+7 (UTC -07:00
Etc/GMT+8 (UTC -08:00
Etc/GMT+9 (UTC -09:00
Etc/GMT-0 (UTC +00:00
Etc/GMT-1 (UTC +01:00
Etc/GMT-10 (UTC +10:00
Etc/GMT-11 (UTC +11:00



Etc/GMT-12 (UTC +12:00
Etc/GMT-13 (UTC +13:00
Etc/GMT-14 (UTC +14:00
Etc/GMT-2 (UTC +02:00
Etc/GMT-3 (UTC +03:00
Etc/GMT-4 (UTC +04:00
Etc/GMT-5 (UTC +05:00
Etc/GMT-6 (UTC +06:00
Etc/GMT-7 (UTC +07:00
Etc/GMT-8 (UTC +08:00
Etc/GMT-9 (UTC +09:00
Etc/GMT0 (UTC +00:00)
Etc/Greenwich (UTC +00:00)
Etc/UCT (UTC +00:00)
Etc/UTC (UTC +00:00)
Etc/Universal (UTC +00:00)
Etc/Zulu (UTC +00:00)
Europe/Amsterdam (UTC +02:00)
Europe/Andorra (UTC +02:00)
Europe/Astrakhan (UTC +04:00)
Europe/Athens (UTC +03:00)
Europe/Belfast (UTC +01:00)
Europe/Belgrade (UTC +02:00)
Europe/Berlin (UTC +02:00)
Europe/Bratislava (UTC +02:00)
Europe/Brussels (UTC +02:00)
Europe/Bucharest (UTC +03:00)
Europe/Budapest (UTC +02:00)
Europe/Busingen (UTC +02:00)
Europe/Chisinau (UTC +03:00)
Europe/Copenhagen (UTC +02:00)
Europe/Dublin (UTC +01:00)
Europe/Gibraltar (UTC +02:00)
Europe/Guernsey (UTC +01:00)
Europe/Helsinki (UTC +03:00)
Europe/Isle_of_Man (UTC +01:00)
Europe/Istanbul (UTC +03:00)
Europe/Jersey (UTC +01:00)
Europe/Kaliningrad (UTC +02:00)
Europe/Kiev (UTC +03:00)
Europe/Kirov (UTC +03:00)
Europe/Kyiv (UTC +03:00)
Europe/Lisbon (UTC +01:00)
Europe/Ljubljana (UTC +02:00)
Europe/London (UTC +01:00)
Europe/Luxembourg (UTC +02:00)
Europe/Madrid (UTC +02:00)
Europe/Malta (UTC +02:00)
Europe/Mariehamn (UTC +03:00)
Europe/Minsk (UTC +03:00)
Europe/Monaco (UTC +02:00)
Europe/Moscow (UTC +03:00)
Europe/Nicosia (UTC +03:00)
Europe/Oslo (UTC +02:00)
Europe/Paris (UTC +02:00)
Europe/Podgorica (UTC +02:00)
Europe/Prague (UTC +02:00)
Europe/Riga (UTC +03:00)
Europe/Rome (UTC +02:00)
Europe/Samara (UTC +04:00)
Europe/San_Marino (UTC +02:00)
Europe/Sarajevo (UTC +02:00)
Europe/Saratov (UTC +04:00)
Europe/Simferopol (UTC +03:00)
Europe/Skopje (UTC +02:00)
Europe/Sofia (UTC +03:00)
Europe/Stockholm (UTC +02:00)
Europe/Tallinn (UTC +03:00)
Europe/Tirane (UTC +02:00)
Europe/Tiraspol (UTC +03:00)
Europe/Ulyanovsk (UTC +04:00)
Europe/Uzhgorod (UTC +03:00)
Europe/Vaduz (UTC +02:00)
Europe/Vatican (UTC +02:00)
Europe/Vienna (UTC +02:00)
Europe/Vilnius (UTC +03:00)
Europe/Volgograd (UTC +03:00)
Europe/Warsaw (UTC +02:00)
Europe/Zagreb (UTC +02:00)
Europe/Zaporozhye (UTC +03:00)
Europe/Zurich (UTC +02:00)
GB (UTC +01:00)
GB-Eire (UTC +01:00)
GMT (UTC +00:00)
GMT+0 (UTC +00:00)
GMT-0 (UTC +00:00)
GMT0 (UTC +00:00)
Greenwich (UTC +00:00)
HST (UTC -10:00)
Hongkong (UTC +08:00)
Iceland (UTC +00:00)
Indian/Antananarivo (UTC +03:00)
Indian/Chagos (UTC +06:00)
Indian/Christmas (UTC +07:00)
Indian/Cocos (UTC +06:30)
Indian/Comoro (UTC +03:00)
Indian/Kerguelen (UTC +05:00)
Indian/Mahe (UTC +04:00)
Indian/Maldives (UTC +05:00)
Indian/Mauritius (UTC +04:00)
Indian/Mayotte (UTC +03:00)
Indian/Reunion (UTC +04:00)
Iran (UTC +03:30)
Israel (UTC +03:00)
Jamaica (UTC -05:00)
Japan (UTC +09:00)
Kwajalein (UTC +12:00)
Libya (UTC +02:00)
MET (UTC +02:00)
MST (UTC -07:00)
MST7MDT (UTC -06:00)
Mexico/BajaNorte (UTC -07:00)
Mexico/BajaSur (UTC -07:00)
Mexico/General (UTC -06:00)
NZ (UTC +12:00)
NZ-CHAT (UTC +12:45)
Navajo (UTC -06:00)
PRC (UTC +08:00)
PST8PDT (UTC -07:00)
Pacific/Apia (UTC +13:00)
Pacific/Auckland (UTC +12:00)
Pacific/Bougainville (UTC +11:00)
Pacific/Chatham (UTC +12:45)
Pacific/Chuuk (UTC +10:00)
Pacific/Easter (UTC -05:00)
Pacific/Efate (UTC +11:00)
Pacific/Enderbury (UTC +13:00)
Pacific/Fakaofo (UTC +13:00)
Pacific/Fiji (UTC +12:00)
Pacific/Funafuti (UTC +12:00)
Pacific/Galapagos (UTC -06:00)
Pacific/Gambier (UTC -09:00)
Pacific/Guadalcanal (UTC +11:00)
Pacific/Guam (UTC +10:00)
Pacific/Honolulu (UTC -10:00)
Pacific/Johnston (UTC -10:00)
Pacific/Kanton (UTC +13:00)
Pacific/Kiritimati (UTC +14:00)
Pacific/Kosrae (UTC +11:00)
Pacific/Kwajalein (UTC +12:00)
Pacific/Majuro (UTC +12:00)
Pacific/Marquesas (UTC -09:30)
Pacific/Midway (UTC -11:00)
Pacific/Nauru (UTC +12:00)
Pacific/Niue (UTC -11:00)
Pacific/Norfolk (UTC +11:00)
Pacific/Noumea (UTC +11:00)
Pacific/Pago_Pago (UTC -11:00)
Pacific/Palau (UTC +09:00)
Pacific/Pitcairn (UTC -08:00)
Pacific/Pohnpei (UTC +11:00)
Pacific/Ponape (UTC +11:00)
Pacific/Port_Moresby (UTC +10:00)
Pacific/Rarotonga (UTC -10:00)
Pacific/Saipan (UTC +10:00)
Pacific/Samoa (UTC -11:00)
Pacific/Tahiti (UTC -10:00)
Pacific/Tarawa (UTC +12:00)
Pacific/Tongatapu (UTC +13:00)
Pacific/Truk (UTC +10:00)
Pacific/Wake (UTC +12:00)
Pacific/Wallis (UTC +12:00)
Pacific/Yap (UTC +10:00)
Poland (UTC +02:00)
Portugal (UTC +01:00)
ROC (UTC +08:00)
ROK (UTC +09:00)
Singapore (UTC +08:00)
Turkey (UTC +03:00)
UCT (UTC +00:00)
US/Alaska (UTC -08:00)
US/Aleutian (UTC -09:00)
US/Arizona (UTC -07:00)
US/Central (UTC -05:00)
US/East-Indiana (UTC -04:00
US/Eastern (UTC -04:00)
US/Hawaii (UTC -10:00)
US/Indiana-Starke (UTC -05:00
US/Michigan (UTC -04:00)
US/Mountain (UTC -06:00)
US/Pacific (UTC -07:00)
US/Samoa (UTC -11:00)
UTC (UTC +00:00)
Universal (UTC +00:00)
W-SU (UTC +03:00)
WET (UTC +01:00)
Zulu (UTC +00:00)*/
