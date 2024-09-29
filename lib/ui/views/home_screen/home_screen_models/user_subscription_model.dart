class UserSubscriptionModel {
  UserSubscriptionModel({
    num? statusCode,
    String? status,
    String? message,
    dynamic data,
    List<UserSubscriptionModelBody>? body,
    dynamic totalCount,
  }) {
    _statusCode = statusCode;
    _status = status;
    _message = message;
    _data = data;
    _body = body;
    _totalCount = totalCount;
  }

  UserSubscriptionModel.fromJson(dynamic json) {
    _statusCode = json['statusCode'];
    _status = json['status'];
    _message = json['message'];
    _data = json['data'];
    if (json['body'] != null) {
      _body = [];
      json['body'].forEach((v) {
        _body?.add(UserSubscriptionModelBody.fromJson(v));
      });
    }
    _totalCount = json['totalCount'];
  }

  num? _statusCode;
  String? _status;
  String? _message;
  dynamic _data;
  List<UserSubscriptionModelBody>? _body;
  dynamic _totalCount;

  UserSubscriptionModel copyWith({
    num? statusCode,
    String? status,
    String? message,
    dynamic data,
    List<UserSubscriptionModelBody>? body,
    dynamic totalCount,
  }) =>
      UserSubscriptionModel(
        statusCode: statusCode ?? _statusCode,
        status: status ?? _status,
        message: message ?? _message,
        data: data ?? _data,
        body: body ?? _body,
        totalCount: totalCount ?? _totalCount,
      );

  num? get statusCode => _statusCode;

  String? get status => _status;

  String? get message => _message;

  dynamic get data => _data;

  List<UserSubscriptionModelBody>? get body => _body;

  dynamic get totalCount => _totalCount;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['statusCode'] = _statusCode;
    map['status'] = _status;
    map['message'] = _message;
    map['data'] = _data;
    if (_body != null) {
      map['body'] = _body?.map((v) => v.toJson()).toList();
    }
    map['totalCount'] = _totalCount;
    return map;
  }
}

/// productId : 4
/// productName : "O-Connect"
/// path : "https://www.onpassive.com/"
/// logo : "ECOSYSTEM/QA/PRODUCTLOGO/4/ECOSYSTEM-396a381b42-4.svg"
/// is_trial : 0
/// no_of_days : 264
/// subsEndDate : 1718198918000

class UserSubscriptionModelBody {
  UserSubscriptionModelBody({
    num? productId,
    String? productName,
    String? path,
    String? logo,
    num? isTrial,
    int? noOfDays,
    int? subsEndDate,
  }) {
    _productId = productId;
    _productName = productName;
    _path = path;
    _logo = logo;
    _isTrial = isTrial;
    _noOfDays = noOfDays;
    _subsEndDate = subsEndDate;
  }

  UserSubscriptionModelBody.fromJson(dynamic json) {
    _productId = json['productId'];
    _productName = json['productName'];
    _path = json['path'];
    _logo = json['logo'];
    _isTrial = json['is_trial'];
    _noOfDays = json['no_of_days'];
    _subsEndDate = json['subsEndDate'];
  }

  num? _productId;
  String? _productName;
  String? _path;
  String? _logo;
  num? _isTrial;
  int? _noOfDays;
  dynamic _subsEndDate;

  UserSubscriptionModelBody copyWith({
    num? productId,
    String? productName,
    String? path,
    String? logo,
    num? isTrial,
    int? noOfDays,
    int? subsEndDate,
  }) =>
      UserSubscriptionModelBody(
        productId: productId ?? _productId,
        productName: productName ?? _productName,
        path: path ?? _path,
        logo: logo ?? _logo,
        isTrial: isTrial ?? _isTrial,
        noOfDays: noOfDays ?? _noOfDays,
        subsEndDate: subsEndDate ?? _subsEndDate,
      );

  num? get productId => _productId;

  String? get productName => _productName;

  String? get path => _path;

  String? get logo => _logo;

  num? get isTrial => _isTrial;

  int? get noOfDays => _noOfDays;

  dynamic get subsEndDate => _subsEndDate;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['productId'] = _productId;
    map['productName'] = _productName;
    map['path'] = _path;
    map['logo'] = _logo;
    map['is_trial'] = _isTrial;
    map['no_of_days'] = _noOfDays;
    map['subsEndDate'] = _subsEndDate;
    return map;
  }
}
