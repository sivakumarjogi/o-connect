import 'package:json_annotation/json_annotation.dart';

part 'get_all_contacts_response_model.g.dart';

@JsonSerializable()
class GetAllContactsResponseModel {
  int statusCode;
  String status;
  String message;
  Data data;
  dynamic body;
  dynamic totalCount;

  GetAllContactsResponseModel({
    required this.statusCode,
    required this.status,
    required this.message,
    required this.data,
    this.body,
    this.totalCount,
  });

  factory GetAllContactsResponseModel.fromJson(Map<String, dynamic> json) => GetAllContactsResponseModel(
    statusCode: json["statusCode"],
    status: json["status"],
    message: json["message"],
    data: Data.fromJson(json["data"]),
    body: json["body"],
    totalCount: json["totalCount"],
  );

  Map<String, dynamic> toJson() => {
    "statusCode": statusCode,
    "status": status,
    "message": message,
    "data": data.toJson(),
    "body": body,
    "totalCount": totalCount,
  };
}

class Data {
  int pageNumber;
  int pageSize;
  int recordsSize;
  List<Record> records;

  Data({
    required this.pageNumber,
    required this.pageSize,
    required this.recordsSize,
    required this.records,
  });

  factory Data.fromJson(Map<String, dynamic> json) => Data(
    pageNumber: json["pageNumber"],
    pageSize: json["pageSize"],
    recordsSize: json["recordsSize"],
    records: List<Record>.from(json["records"].map((x) => Record.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "pageNumber": pageNumber,
    "pageSize": pageSize,
    "recordsSize": recordsSize,
    "records": List<dynamic>.from(records.map((x) => x.toJson())),
  };
}

class Record {
  int contactId;
  int sponsorCustomerAccountId;
  int? customerAccountId;
  String firstName;
  String lastName;
  String? jobTitle;
  String? companyName;
  String omailEmailId;
  String alternateEmailId;
  String countryCallCode;
  int countryId;
  String countryName;
  dynamic stateName;
  String? contactNumber;
  DateTime? dateOfBirth;
  dynamic stateId;
  String? zipcode;
  String? contactPic;
  String? address;
  int favStatus;
  int trash;
  int badgeId;
  dynamic sourceBadge;
  int isEmailAllowed;
  int emailAllowPermission;
  DateTime createdDate;
  DateTime updatedDate;

  Record({
    required this.contactId,
    required this.sponsorCustomerAccountId,
    this.customerAccountId,
    required this.firstName,
    required this.lastName,
    this.jobTitle,
    this.companyName,
    required this.omailEmailId,
    required this.alternateEmailId,
    required this.countryCallCode,
    required this.countryId,
    required this.countryName,
    this.stateName,
    this.contactNumber,
    this.dateOfBirth,
    this.stateId,
    this.zipcode,
    this.contactPic,
    this.address,
    required this.favStatus,
    required this.trash,
    required this.badgeId,
    this.sourceBadge,
    required this.isEmailAllowed,
    required this.emailAllowPermission,
    required this.createdDate,
    required this.updatedDate,
  });

  factory Record.fromJson(Map<String, dynamic> json) => Record(
    contactId: json["contactId"],
    sponsorCustomerAccountId: json["sponsorCustomerAccountId"],
    customerAccountId: json["customerAccountId"],
    firstName: json["firstName"],
    lastName: json["lastName"],
    jobTitle: json["jobTitle"],
    companyName: json["companyName"],
    omailEmailId: json["omailEmailId"],
    alternateEmailId: json["alternateEmailId"],
    countryCallCode: json["countryCallCode"],
    countryId: json["countryId"],
    countryName: json["countryName"],
    stateName: json["stateName"],
    contactNumber: json["contactNumber"],
    dateOfBirth: json["dateOfBirth"] == null ? null : DateTime.parse(json["dateOfBirth"]),
    stateId: json["stateId"],
    zipcode: json["zipcode"],
    contactPic: json["contactPic"],
    address: json["address"],
    favStatus: json["favStatus"],
    trash: json["trash"],
    badgeId: json["badgeId"],
    sourceBadge: json["sourceBadge"],
    isEmailAllowed: json["isEmailAllowed"],
    emailAllowPermission: json["emailAllowPermission"],
    createdDate: DateTime.parse(json["createdDate"]),
    updatedDate: DateTime.parse(json["updatedDate"]),
  );

  Map<String, dynamic> toJson() => {
    "contactId": contactId,
    "sponsorCustomerAccountId": sponsorCustomerAccountId,
    "customerAccountId": customerAccountId,
    "firstName": firstName,
    "lastName": lastName,
    "jobTitle": jobTitle,
    "companyName": companyName,
    "omailEmailId": omailEmailId,
    "alternateEmailId": alternateEmailId,
    "countryCallCode": countryCallCode,
    "countryId": countryId,
    "countryName": countryName,
    "stateName": stateName,
    "contactNumber": contactNumber,
    "dateOfBirth": "${dateOfBirth!.year.toString().padLeft(4, '0')}-${dateOfBirth!.month.toString().padLeft(2, '0')}-${dateOfBirth!.day.toString().padLeft(2, '0')}",
    "stateId": stateId,
    "zipcode": zipcode,
    "contactPic": contactPic,
    "address": address,
    "favStatus": favStatus,
    "trash": trash,
    "badgeId": badgeId,
    "sourceBadge": sourceBadge,
    "isEmailAllowed": isEmailAllowed,
    "emailAllowPermission": emailAllowPermission,
    "createdDate": createdDate.toIso8601String(),
    "updatedDate": updatedDate.toIso8601String(),
  };
}
