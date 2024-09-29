/// _id : "6549c01f69341d0008dae646"
/// from_user : "siva kumar"
/// from_user_id : 4455770
/// message : "attachment"
/// meeting_id : "6549bf9d4decb9000871cbd4"
/// is_chat_active : 1
/// ppic : "https://de4nfar4wtruu.cloudfront.net/ECOSYSTEM/QA/OES/CUSTOMER/659303/profile/1698925254255_moto (1).png"
/// type : "groupChat"
/// index : 1
/// message_type : "file"
/// reply_chat_id : null
/// roleType : "Host"
/// file_name : "1698925254255_moto (1).png"
/// file_size : "1944654"
/// file_type : "image/png"
/// url : "https://df8wbawj934ec.cloudfront.net/uploads/4455770/1698925254255_moto%20%281%29.png"
/// created_on : "2023-11-07T04:42:07.224Z"
/// updated_on : "2023-11-07T04:42:07.224Z"

class ChatModel {
  ChatModel({
    String? id,
    bool isContinue = false,
    int? chatId,
    String? fromUser,
    String? userName,
    num? fromUserId,
    String? message,
    String? meetingId,
    num? isChatActive,
    String? ppic,
    String? type,
    num? index,
    String? messageType,
    dynamic replyChatId,
    String? roleType,
    String? fileName,
    String? fileSize,
    String? fileType,
    String? url,
    String? userProfile,
    String? createdOn,
    String? updatedOn,
  }) {
    _id = id;
    _isContinue = isContinue;
    _chatId = chatId;
    _fromUser = fromUser;
    _userName = userName;
    _fromUserId = fromUserId;
    _message = message;
    _meetingId = meetingId;
    _isChatActive = isChatActive;
    _ppic = ppic;
    _type = type;
    _index = index;
    _messageType = messageType;
    _replyChatId = replyChatId;
    _roleType = roleType;
    _fileName = fileName;
    _fileSize = fileSize;
    _fileType = fileType;
    _url = url;
    _userProfile = userProfile;
    _createdOn = createdOn;
    _updatedOn = updatedOn;
  }

  ChatModel.fromJson(dynamic json) {
    _id = json['_id'];
    _chatId = json['chat_id'];
    _fromUser = json['from_user'];
    _userName = json['userName'];
    _fromUserId = json['from_user_id'];
    _message = json['message'];
    _meetingId = json['meeting_id'];
    _isChatActive = json['is_chat_active'];
    _ppic = json['ppic'];
    _type = json['type'];
    _index = json['index'];
    _messageType = json['message_type'];
    _replyChatId = json['reply_chat_id'];
    _roleType = json['roleType'];
    _fileName = json['file_name'];
    _fileSize = json['file_size'];
    _fileType = json['file_type'];
    _url = json['url'];
    _userProfile = json['userProfile'];
    _createdOn = json['created_on'];
    _updatedOn = json['updated_on'];
  }

  String? _id;
  bool? _isContinue;
  int? _chatId;
  String? _fromUser;
  String? _userName;
  num? _fromUserId;
  String? _message;
  String? _meetingId;
  num? _isChatActive;
  String? _ppic;
  String? _type;
  num? _index;
  String? _messageType;
  dynamic _replyChatId;
  String? _roleType;
  String? _fileName;
  String? _fileSize;
  String? _fileType;
  String? _url;
  String? _userProfile;
  String? _createdOn;
  String? _updatedOn;

  ChatModel copyWith({
    String? id,
    bool? isContinue,
    int? chatId,
    String? fromUser,
    String? userName,
    num? fromUserId,
    String? message,
    String? meetingId,
    num? isChatActive,
    String? ppic,
    String? type,
    num? index,
    String? messageType,
    dynamic replyChatId,
    String? roleType,
    String? fileName,
    String? fileSize,
    String? fileType,
    String? url,
    String? userProfile,
    String? createdOn,
    String? updatedOn,
  }) =>
      ChatModel(
        id: id ?? _id,
        isContinue: isContinue ?? false,
        chatId: chatId ?? _chatId,
        fromUser: fromUser ?? _fromUser,
        userName: userName ?? _userName,
        fromUserId: fromUserId ?? _fromUserId,
        message: message ?? _message,
        meetingId: meetingId ?? _meetingId,
        isChatActive: isChatActive ?? _isChatActive,
        ppic: ppic ?? _ppic,
        type: type ?? _type,
        index: index ?? _index,
        messageType: messageType ?? _messageType,
        replyChatId: replyChatId ?? _replyChatId,
        roleType: roleType ?? _roleType,
        fileName: fileName ?? _fileName,
        fileSize: fileSize ?? _fileSize,
        fileType: fileType ?? _fileType,
        url: url ?? _url,
        userProfile: userProfile ?? _userProfile,
        createdOn: createdOn ?? _createdOn,
        updatedOn: updatedOn ?? _updatedOn,
      );

  String? get id => _id;
  int? get chatId => _chatId;

  String? get fromUser => _fromUser;
  bool? get isContinue => _isContinue;

  String? get userName => _userName;

  num? get fromUserId => _fromUserId;

  String? get message => _message;

  String? get meetingId => _meetingId;

  num? get isChatActive => _isChatActive;

  String? get ppic => _ppic;

  String? get type => _type;

  num? get index => _index;

  String? get messageType => _messageType;

  dynamic get replyChatId => _replyChatId;

  String? get roleType => _roleType;

  String? get fileName => _fileName;

  String? get fileSize => _fileSize;

  String? get fileType => _fileType;

  String? get url => _url;

  String? get userProfile => _userProfile;

  String? get createdOn => _createdOn;

  String? get updatedOn => _updatedOn;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['_id'] = _id;
    map['chat_id'] = _chatId;
    map['from_user'] = _fromUser;
    map['userName'] = _userName;
    map['from_user_id'] = _fromUserId;
    map['message'] = _message;
    map['meeting_id'] = _meetingId;
    map['is_chat_active'] = _isChatActive;
    map['ppic'] = _ppic;
    map['type'] = _type;
    map['index'] = _index;
    map['message_type'] = _messageType;
    map['reply_chat_id'] = _replyChatId;
    map['roleType'] = _roleType;
    map['file_name'] = _fileName;
    map['file_size'] = _fileSize;
    map['file_type'] = _fileType;
    map['url'] = _url;
    map['userProfile'] = _userProfile;
    map['created_on'] = _createdOn;
    map['updated_on'] = _updatedOn;
    return map;
  }
}
