import 'dart:convert';

import 'package:tusalud/api/response/app/ts_audit_response.dart';
import 'package:tusalud/api/response/ts_response.dart';

class TsRoomResponse implements TsResponseService{
  int roomId;
  String? roomName;
  int? roomStatus;
  TsAuditResponse? audit;

  TsRoomResponse({
    required this.roomId,
    this.roomName,
    required this.roomStatus,
    required this.audit
  });

  factory TsRoomResponse.createEmpty() => TsRoomResponse(
    roomId: 0,
    roomName: '',
    roomStatus: 0,
    audit: TsAuditResponse.createEmpty()
  );

  @override
  String toJson() => json.encode(toMap());

  factory TsRoomResponse.fromJson(Map<String, dynamic> json) => TsRoomResponse(
    roomId: json["roomId"] as int? ??0,
    roomName: json["roomName"] as String?,
    roomStatus: json["roomStatus"] as int? ??0,
    audit: json["audit"] != null 
        ? TsAuditResponse.fromJson(json["audit"]) 
        : TsAuditResponse.createEmpty(),
  );
    @override
  Map<String, dynamic> toMap() =>{
        "roomId": roomId,
        "roomName": roomName,
        "roomStatus": roomStatus,
        "audit": audit?.toJson(),
  };
    @override
  TsRoomResponse fromJson(String json) {
    return fromMap(jsonDecode(json));
  }

  @override
  TsRoomResponse fromMap(Map<String, dynamic> json) => TsRoomResponse(
        roomId: json["roomId"] as int? ??0,
        roomName: json["roomName"] as String?,
        roomStatus: json["roomStatus"] as int? ??0,
            audit: json["audit"] != null 
        ? TsAuditResponse.fromJson(json["audit"]) 
        : TsAuditResponse.createEmpty(),
      );
}