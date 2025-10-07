import 'dart:convert';

import 'package:tusalud/api/response/app/ts_audit_response.dart';
import 'package:tusalud/api/response/app/ts_room_response.dart';
import 'package:tusalud/api/response/ts_response.dart';

class TsBedsResponse implements TsResponseService {
  int bedId;
  String? bedName;
  TsRoomResponse room;
  int? bedStatus;
  bool? bedOccupied; // ✅ NUEVO CAMPO
  TsAuditResponse? audit;

  TsBedsResponse({
    required this.bedId,
    this.bedName,
    required this.room,
    this.bedStatus,
    this.bedOccupied, // ✅ NUEVO
    this.audit,
  });

  factory TsBedsResponse.createEmpty() => TsBedsResponse(
        bedId: 0,
        bedName: '',
        room: TsRoomResponse.createEmpty(),
        bedStatus: 0,
        bedOccupied: false, // ✅ default
        audit: TsAuditResponse.createEmpty(),
      );

  @override
  String toJson() => json.encode(toMap());

  factory TsBedsResponse.fromJson(Map<String, dynamic> json) => TsBedsResponse(
        bedId: json["bedId"] as int? ?? 0,
        bedName: json["bedName"] as String?,
        room: TsRoomResponse.fromJson(json["room"]),
        bedStatus: json["bedStatus"] as int? ?? 0,
        bedOccupied: json["bedOccupied"] as bool? ?? false, // ✅ NUEVO
        audit: json["audit"] != null
            ? TsAuditResponse.fromJson(json["audit"])
            : TsAuditResponse.createEmpty(),
      );

  @override
  Map<String, dynamic> toMap() => {
        "bedId": bedId,
        "bedName": bedName,
        "room": room.toMap(),
        "bedStatus": bedStatus,
        "bedOccupied": bedOccupied, // ✅ NUEVO
        "audit": audit?.toJson(),
      };

  @override
  TsBedsResponse fromJson(String jsonStr) {
    return fromMap(jsonDecode(jsonStr));
  }

  @override
  TsBedsResponse fromMap(Map<String, dynamic> json) => TsBedsResponse(
        bedId: json["bedId"] as int? ?? 0,
        bedName: json["bedName"] as String?,
        room: TsRoomResponse.fromJson(json["room"]),
        bedStatus: json["bedStatus"] as int? ?? 0,
        bedOccupied: json["bedOccupied"] as bool? ?? false, // ✅ NUEVO
        audit: json["audit"] != null
            ? TsAuditResponse.fromJson(json["audit"])
            : TsAuditResponse.createEmpty(),
      );
}
