import 'dart:convert';

import 'package:tusalud/api/response/app/ts_audit_response.dart';
import 'package:tusalud/api/response/ts_response.dart';

class TsRoomResponse implements TsResponseService{
  int roomId;
  String? roomName;
  int roomStatus;
  TsAuditResponse audit;

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
    roomId: json["roomId"] as int,
    roomName: json["roomName"] as String,
    roomStatus: json["roomStatus"] as int,
    audit: TsAuditResponse.fromJson(json["audit"] as Map<String, dynamic>),
  );
    @override
  Map<String, dynamic> toMap() =>{
        "roomId": roomId,
        "roomName": roomName,
        "roomStatus": roomStatus,
        "audit": audit.toJson(),
  };
    @override
  TsRoomResponse fromJson(String json) {
    return fromMap(jsonDecode(json));
  }

  @override
  TsRoomResponse fromMap(Map<String, dynamic> json) => TsRoomResponse(
        roomId: json["roomId"],
        roomName: json["roomName"],
        roomStatus: json["roomStatus"],
        audit: TsAuditResponse.fromJson(json["audit"]),
      );
}