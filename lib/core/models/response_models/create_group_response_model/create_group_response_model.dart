/// groupId : 1361
/// customerAccountId : 567188
/// groupName : "hdhftg"
/// description : null
/// groupPic : null
/// allEmails : "[]"
/// toEmail : "[]"
/// ccEmail : "[]"
/// bccEmail : "[]"
/// allEmailsData : null
/// toEmailsData : null
/// ccEmailsData : null
/// bccEmailsData : null
/// contacts : null
/// contactsCount : 0
/// trash : 0
/// createdDate : "2023-09-20 14:06:31"
/// updatedTime : "2023-09-26 07:40:14"

class CreateGroupResponseModel {
  CreateGroupResponseModel({
      int? groupId, 
      int? customerAccountId, 
      String? groupName, 
      dynamic description, 
      dynamic groupPic, 
      String? allEmails, 
      String? toEmail, 
      String? ccEmail, 
      String? bccEmail, 
      dynamic allEmailsData, 
      dynamic toEmailsData, 
      dynamic ccEmailsData, 
      dynamic bccEmailsData, 
      dynamic contacts, 
      int? contactsCount, 
      int? trash, 
      String? createdDate, 
      String? updatedTime,}){
    _groupId = groupId;
    _customerAccountId = customerAccountId;
    _groupName = groupName;
    _description = description;
    _groupPic = groupPic;
    _allEmails = allEmails;
    _toEmail = toEmail;
    _ccEmail = ccEmail;
    _bccEmail = bccEmail;
    _allEmailsData = allEmailsData;
    _toEmailsData = toEmailsData;
    _ccEmailsData = ccEmailsData;
    _bccEmailsData = bccEmailsData;
    _contacts = contacts;
    _contactsCount = contactsCount;
    _trash = trash;
    _createdDate = createdDate;
    _updatedTime = updatedTime;
}

  CreateGroupResponseModel.fromJson(dynamic json) {
    _groupId = json['groupId'];
    _customerAccountId = json['customerAccountId'];
    _groupName = json['groupName'];
    _description = json['description'];
    _groupPic = json['groupPic'];
    _allEmails = json['allEmails'];
    _toEmail = json['toEmail'];
    _ccEmail = json['ccEmail'];
    _bccEmail = json['bccEmail'];
    _allEmailsData = json['allEmailsData'];
    _toEmailsData = json['toEmailsData'];
    _ccEmailsData = json['ccEmailsData'];
    _bccEmailsData = json['bccEmailsData'];
    _contacts = json['contacts'];
    _contactsCount = json['contactsCount'];
    _trash = json['trash'];
    _createdDate = json['createdDate'];
    _updatedTime = json['updatedTime'];
  }
  int? _groupId;
  int? _customerAccountId;
  String? _groupName;
  dynamic _description;
  dynamic _groupPic;
  String? _allEmails;
  String? _toEmail;
  String? _ccEmail;
  String? _bccEmail;
  dynamic _allEmailsData;
  dynamic _toEmailsData;
  dynamic _ccEmailsData;
  dynamic _bccEmailsData;
  dynamic _contacts;
  int? _contactsCount;
  int? _trash;
  String? _createdDate;
  String? _updatedTime;
CreateGroupResponseModel copyWith({  int? groupId,
  int? customerAccountId,
  String? groupName,
  dynamic description,
  dynamic groupPic,
  String? allEmails,
  String? toEmail,
  String? ccEmail,
  String? bccEmail,
  dynamic allEmailsData,
  dynamic toEmailsData,
  dynamic ccEmailsData,
  dynamic bccEmailsData,
  dynamic contacts,
  int? contactsCount,
  int? trash,
  String? createdDate,
  String? updatedTime,
}) => CreateGroupResponseModel(  groupId: groupId ?? _groupId,
  customerAccountId: customerAccountId ?? _customerAccountId,
  groupName: groupName ?? _groupName,
  description: description ?? _description,
  groupPic: groupPic ?? _groupPic,
  allEmails: allEmails ?? _allEmails,
  toEmail: toEmail ?? _toEmail,
  ccEmail: ccEmail ?? _ccEmail,
  bccEmail: bccEmail ?? _bccEmail,
  allEmailsData: allEmailsData ?? _allEmailsData,
  toEmailsData: toEmailsData ?? _toEmailsData,
  ccEmailsData: ccEmailsData ?? _ccEmailsData,
  bccEmailsData: bccEmailsData ?? _bccEmailsData,
  contacts: contacts ?? _contacts,
  contactsCount: contactsCount ?? _contactsCount,
  trash: trash ?? _trash,
  createdDate: createdDate ?? _createdDate,
  updatedTime: updatedTime ?? _updatedTime,
);
  int? get groupId => _groupId;
  int? get customerAccountId => _customerAccountId;
  String? get groupName => _groupName;
  dynamic get description => _description;
  dynamic get groupPic => _groupPic;
  String? get allEmails => _allEmails;
  String? get toEmail => _toEmail;
  String? get ccEmail => _ccEmail;
  String? get bccEmail => _bccEmail;
  dynamic get allEmailsData => _allEmailsData;
  dynamic get toEmailsData => _toEmailsData;
  dynamic get ccEmailsData => _ccEmailsData;
  dynamic get bccEmailsData => _bccEmailsData;
  dynamic get contacts => _contacts;
  int? get contactsCount => _contactsCount;
  int? get trash => _trash;
  String? get createdDate => _createdDate;
  String? get updatedTime => _updatedTime;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['groupId'] = _groupId;
    map['customerAccountId'] = _customerAccountId;
    map['groupName'] = _groupName;
    map['description'] = _description;
    map['groupPic'] = _groupPic;
    map['allEmails'] = _allEmails;
    map['toEmail'] = _toEmail;
    map['ccEmail'] = _ccEmail;
    map['bccEmail'] = _bccEmail;
    map['allEmailsData'] = _allEmailsData;
    map['toEmailsData'] = _toEmailsData;
    map['ccEmailsData'] = _ccEmailsData;
    map['bccEmailsData'] = _bccEmailsData;
    map['contacts'] = _contacts;
    map['contactsCount'] = _contactsCount;
    map['trash'] = _trash;
    map['createdDate'] = _createdDate;
    map['updatedTime'] = _updatedTime;
    return map;
  }

}