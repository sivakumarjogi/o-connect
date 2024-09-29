/// status : true
/// data : [{"_id":"07-2023","value":3,"attendees":8,"name":"Jul-2023"},{"_id":"09-2023","value":4,"attendees":4,"name":"Sep-2023"},{"_id":"08-2023","value":3,"attendees":6,"name":"Aug-2023"}]

class WebinarStatisticsModel {
  WebinarStatisticsModel({
      bool? status, 
      List<Data>? data,}){
    _status = status;
    _data = data;
}

  WebinarStatisticsModel.fromJson(dynamic json) {
    _status = json['status'];
    if (json['data'] != null) {
      _data = [];
      json['data'].forEach((v) {
        _data?.add(Data.fromJson(v));
      });
    }
  }
  bool? _status;
  List<Data>? _data;
WebinarStatisticsModel copyWith({  bool? status,
  List<Data>? data,
}) => WebinarStatisticsModel(  status: status ?? _status,
  data: data ?? _data,
);
  bool? get status => _status;
  List<Data>? get data => _data;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['status'] = _status;
    if (_data != null) {
      map['data'] = _data?.map((v) => v.toJson()).toList();
    }
    return map;
  }

}

/// _id : "07-2023"
/// value : 3
/// attendees : 8
/// name : "Jul-2023"

class Data {
  Data({
      String? id, 
      num? value, 
      num? attendees, 
      String? name,}){
    _id = id;
    _value = value;
    _attendees = attendees;
    _name = name;
}

  Data.fromJson(dynamic json) {
    _id = json['_id'];
    _value = json['value'];
    _attendees = json['attendees'];
    _name = json['name'];
  }
  String? _id;
  num? _value;
  num? _attendees;
  String? _name;
Data copyWith({  String? id,
  num? value,
  num? attendees,
  String? name,
}) => Data(  id: id ?? _id,
  value: value ?? _value,
  attendees: attendees ?? _attendees,
  name: name ?? _name,
);
  String? get id => _id;
  num? get value => _value;
  num? get attendees => _attendees;
  String? get name => _name;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['_id'] = _id;
    map['value'] = _value;
    map['attendees'] = _attendees;
    map['name'] = _name;
    return map;
  }

}