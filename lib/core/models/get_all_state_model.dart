/// id : 4006
/// name : "Meghalaya"
/// countryId : 101
/// countryCode : "IN"
/// countryName : "India"
/// stateCode : "ML"

class GetAllStateModel {
  int id;
  String name;
  int countryId;
  String countryCode;
  String countryName;
  String stateCode;

  GetAllStateModel({
    required this.id,
    required this.name,
    required this.countryId,
    required this.countryCode,
    required this.countryName,
    required this.stateCode,
  });

  factory GetAllStateModel.fromJson(Map<String, dynamic> json) =>
      GetAllStateModel(
        id: json["id"],
        name: json["name"],
        countryId: json["countryId"],
        countryCode: json["countryCode"],
        countryName: json["countryName"],
        stateCode: json["stateCode"],
      );

  Map<String, dynamic> toJson() => {
    "id": id,
    "name": name,
    "countryId": countryId,
    "countryCode": countryCode,
    "countryName": countryName,
    "stateCode": stateCode,
  };
}
