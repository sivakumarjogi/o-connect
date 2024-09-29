// To parse this JSON data, do
//
//     final getCountries = getCountriesFromJson(jsonString);

import 'dart:convert';

GetCountries getCountriesFromJson(String str) => GetCountries.fromJson(json.decode(str));

String getCountriesToJson(GetCountries data) => json.encode(data.toJson());

class GetCountries {
  int id;
  String name;
  String iso3;
  String iso2;
  int numericCode;
  String capital;
  String currencySymbol;
  String native1;
  String region;
  String subregion;
  String timezones;
  String longitude;
  double latitude;
  String emoji;
  String emojiU;
  String flag32;
  String flag128;
  String flag720;
  String roundFlag;
  String phoneCode;
  String currency;
  String currencyName;

  GetCountries({
    required this.id,
    required this.name,
    required this.iso3,
    required this.iso2,
    required this.numericCode,
    required this.capital,
    required this.currencySymbol,
    required this.native1,
    required this.region,
    required this.subregion,
    required this.timezones,
    required this.longitude,
    required this.latitude,
    required this.emoji,
    required this.emojiU,
    required this.flag32,
    required this.flag128,
    required this.flag720,
    required this.roundFlag,
    required this.phoneCode,
    required this.currency,
    required this.currencyName,
  });

  factory GetCountries.fromJson(Map<String, dynamic> json) => GetCountries(
    id: json["id"],
    name: json["name"],
    iso3: json["iso3"],
    iso2: json["iso2"],
    numericCode: json["numeric_code"],
    capital: json["capital"],
    currencySymbol: json["currency_symbol"],
    native1: json["native1"],
    region: json["region"],
    subregion: json["subregion"],
    timezones: json["timezones"],
    longitude: json["longitude"],
    latitude: json["latitude"],
    emoji: json["emoji"],
    emojiU: json["emojiU"],
    flag32: json["flag_32"],
    flag128: json["flag_128"],
    flag720: json["flag_720"],
    roundFlag: json["round_flag"],
    phoneCode: json["phoneCode"],
    currency: json["currency"],
    currencyName: json["currencyName"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "name": name,
    "iso3": iso3,
    "iso2": iso2,
    "numeric_code": numericCode,
    "capital": capital,
    "currency_symbol": currencySymbol,
    "native1": native1,
    "region": region,
    "subregion": subregion,
    "timezones": timezones,
    "longitude": longitude,
    "latitude": latitude,
    "emoji": emoji,
    "emojiU": emojiU,
    "flag_32": flag32,
    "flag_128": flag128,
    "flag_720": flag720,
    "round_flag": roundFlag,
    "phoneCode": phoneCode,
    "currency": currency,
    "currencyName": currencyName,
  };
}
