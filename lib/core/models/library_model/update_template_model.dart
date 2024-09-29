import 'dart:convert';

UpdateTemplateModel updateTemplateModelFromJson(String str) => UpdateTemplateModel.fromJson(json.decode(str));

String updateTemplateModelToJson(UpdateTemplateModel data) => json.encode(data.toJson());

class UpdateTemplateModel {
  bool? status;
  Data? data;

  UpdateTemplateModel({
    this.status,
    this.data,
  });

  factory UpdateTemplateModel.fromJson(Map<String, dynamic> json) => UpdateTemplateModel(
    status: json["status"],
    data: json["data"] == null ? null : Data.fromJson(json["data"]),
  );

  Map<String, dynamic> toJson() => {
    "status": status,
    "data": data?.toJson(),
  };
}

class Data {
  List<dynamic>? generatedMaps;
  Raw? raw;
  int? affected;

  Data({
    this.generatedMaps,
    this.raw,
    this.affected,
  });

  factory Data.fromJson(Map<String, dynamic> json) => Data(
    generatedMaps: json["generatedMaps"] == null ? [] : List<dynamic>.from(json["generatedMaps"]!.map((x) => x)),
    raw: json["raw"] == null ? null : Raw.fromJson(json["raw"]),
    affected: json["affected"],
  );

  Map<String, dynamic> toJson() => {
    "generatedMaps": generatedMaps == null ? [] : List<dynamic>.from(generatedMaps!.map((x) => x)),
    "raw": raw?.toJson(),
    "affected": affected,
  };
}

class Raw {
  Result? result;
  Connection? connection;
  int? modifiedCount;
  dynamic upsertedId;
  int? upsertedCount;
  int? matchedCount;
  int? n;
  String? electionId;
  OpTime? opTime;
  int? nModified;
  int? ok;
  ClusterTime? clusterTime;
  String? operationTime;

  Raw({
    this.result,
    this.connection,
    this.modifiedCount,
    this.upsertedId,
    this.upsertedCount,
    this.matchedCount,
    this.n,
    this.electionId,
    this.opTime,
    this.nModified,
    this.ok,
    this.clusterTime,
    this.operationTime,
  });

  factory Raw.fromJson(Map<String, dynamic> json) => Raw(
    result: json["result"] == null ? null : Result.fromJson(json["result"]),
    connection: json["connection"] == null ? null : Connection.fromJson(json["connection"]),
    modifiedCount: json["modifiedCount"],
    upsertedId: json["upsertedId"],
    upsertedCount: json["upsertedCount"],
    matchedCount: json["matchedCount"],
    n: json["n"],
    electionId: json["electionId"],
    opTime: json["opTime"] == null ? null : OpTime.fromJson(json["opTime"]),
    nModified: json["nModified"],
    ok: json["ok"],
    clusterTime: json["\u0024clusterTime"] == null ? null : ClusterTime.fromJson(json["\u0024clusterTime"]),
    operationTime: json["operationTime"],
  );

  Map<String, dynamic> toJson() => {
    "result": result?.toJson(),
    "connection": connection?.toJson(),
    "modifiedCount": modifiedCount,
    "upsertedId": upsertedId,
    "upsertedCount": upsertedCount,
    "matchedCount": matchedCount,
    "n": n,
    "electionId": electionId,
    "opTime": opTime?.toJson(),
    "nModified": nModified,
    "ok": ok,
    "\u0024clusterTime": clusterTime?.toJson(),
    "operationTime": operationTime,
  };
}

class ClusterTime {
  String? clusterTime;
  Signature? signature;

  ClusterTime({
    this.clusterTime,
    this.signature,
  });

  factory ClusterTime.fromJson(Map<String, dynamic> json) => ClusterTime(
    clusterTime: json["clusterTime"],
    signature: json["signature"] == null ? null : Signature.fromJson(json["signature"]),
  );

  Map<String, dynamic> toJson() => {
    "clusterTime": clusterTime,
    "signature": signature?.toJson(),
  };
}

class Signature {
  String? hash;
  String? keyId;

  Signature({
    this.hash,
    this.keyId,
  });

  factory Signature.fromJson(Map<String, dynamic> json) => Signature(
    hash: json["hash"],
    keyId: json["keyId"],
  );

  Map<String, dynamic> toJson() => {
    "hash": hash,
    "keyId": keyId,
  };
}

class Connection {
  Events? events;
  int? eventsCount;
  int? id;
  String? address;
  Events? bson;
  int? socketTimeout;
  String? host;
  int? port;
  bool? monitorCommands;
  bool? closed;
  bool? destroyed;
  bool? helloOk;
  int? lastIsMasterMs;

  Connection({
    this.events,
    this.eventsCount,
    this.id,
    this.address,
    this.bson,
    this.socketTimeout,
    this.host,
    this.port,
    this.monitorCommands,
    this.closed,
    this.destroyed,
    this.helloOk,
    this.lastIsMasterMs,
  });

  factory Connection.fromJson(Map<String, dynamic> json) => Connection(
    events: json["_events"] == null ? null : Events.fromJson(json["_events"]),
    eventsCount: json["_eventsCount"],
    id: json["id"],
    address: json["address"],
    bson: json["bson"] == null ? null : Events.fromJson(json["bson"]),
    socketTimeout: json["socketTimeout"],
    host: json["host"],
    port: json["port"],
    monitorCommands: json["monitorCommands"],
    closed: json["closed"],
    destroyed: json["destroyed"],
    helloOk: json["helloOk"],
    lastIsMasterMs: json["lastIsMasterMS"],
  );

  Map<String, dynamic> toJson() => {
    "_events": events?.toJson(),
    "_eventsCount": eventsCount,
    "id": id,
    "address": address,
    "bson": bson?.toJson(),
    "socketTimeout": socketTimeout,
    "host": host,
    "port": port,
    "monitorCommands": monitorCommands,
    "closed": closed,
    "destroyed": destroyed,
    "helloOk": helloOk,
    "lastIsMasterMS": lastIsMasterMs,
  };
}

class Events {
  Events();

  factory Events.fromJson(Map<String, dynamic> json) => Events(
  );

  Map<String, dynamic> toJson() => {
  };
}

class OpTime {
  String? ts;
  int? t;

  OpTime({
    this.ts,
    this.t,
  });

  factory OpTime.fromJson(Map<String, dynamic> json) => OpTime(
    ts: json["ts"],
    t: json["t"],
  );

  Map<String, dynamic> toJson() => {
    "ts": ts,
    "t": t,
  };
}

class Result {
  int? n;
  String? electionId;
  OpTime? opTime;
  int? nModified;
  int? ok;
  ClusterTime? clusterTime;
  String? operationTime;

  Result({
    this.n,
    this.electionId,
    this.opTime,
    this.nModified,
    this.ok,
    this.clusterTime,
    this.operationTime,
  });

  factory Result.fromJson(Map<String, dynamic> json) => Result(
    n: json["n"],
    electionId: json["electionId"],
    opTime: json["opTime"] == null ? null : OpTime.fromJson(json["opTime"]),
    nModified: json["nModified"],
    ok: json["ok"],
    clusterTime: json["\u0024clusterTime"] == null ? null : ClusterTime.fromJson(json["\u0024clusterTime"]),
    operationTime: json["operationTime"],
  );

  Map<String, dynamic> toJson() => {
    "n": n,
    "electionId": electionId,
    "opTime": opTime?.toJson(),
    "nModified": nModified,
    "ok": ok,
    "\u0024clusterTime": clusterTime?.toJson(),
    "operationTime": operationTime,
  };
}
