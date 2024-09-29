/// userName : "Santhosh"
/// userDesignation : "Flutter Developer"
/// userImage : "true"

class BlockedUserModel {
  BlockedUserModel({
      String? userName, 
      String? userDesignation, 
      bool? userImage,}){
    _userName = userName;
    _userDesignation = userDesignation;
    _userImage = userImage;
}

  BlockedUserModel.fromJson(dynamic json) {
    _userName = json['userName'];
    _userDesignation = json['userDesignation'];
    _userImage = json['userImage'];
  }
  String? _userName;
  String? _userDesignation;
  bool? _userImage;
BlockedUserModel copyWith({  String? userName,
  String? userDesignation,
  bool? userImage,
}) => BlockedUserModel(  userName: userName ?? _userName,
  userDesignation: userDesignation ?? _userDesignation,
  userImage: userImage ?? _userImage,
);
  String? get userName => _userName;
  String? get userDesignation => _userDesignation;
  bool? get userImage => _userImage;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['userName'] = _userName;
    map['userDesignation'] = _userDesignation;
    map['userImage'] = _userImage;
    return map;
  }

}