import 'dart:convert';
import 'package:tusalud/api/response/ts_response.dart';
import 'package:tusalud/api/response/app/ts_audit_response.dart';

class TsRoomResponse implements TsResponseService {
  int roomId;
  String? roomName;
  int? roomStatus;
  bool? roomOccupied;
  TsAuditResponse? audit;

  TsRoomResponse({
    required this.roomId,
    this.roomName,
    this.roomStatus,
    this.roomOccupied,
    this.audit,
  });

  factory TsRoomResponse.createEmpty() => TsRoomResponse(
        roomId: 0,
        roomName: '',
        roomStatus: 0,
        roomOccupied: false,
        audit: TsAuditResponse.createEmpty(),
      );

  @override
  String toJson() => json.encode(toMap());

  factory TsRoomResponse.fromJson(Map<String, dynamic> json) => TsRoomResponse(
        roomId: json['roomId'] as int? ?? 0,
        roomName: json['roomName'] as String?,
        roomStatus: json['roomStatus'] as int? ?? 0,
        roomOccupied: json['roomOccupied'] as bool? ?? false,
        audit: json["audit"] != null
            ? TsAuditResponse.fromJson(json["audit"])
            : TsAuditResponse.createEmpty(),
      );

  @override
  Map<String, dynamic> toMap() => {
        "roomId": roomId,
        "roomName": roomName,
        "roomStatus": roomStatus,
        "roomOccupied": roomOccupied,
        "audit": audit?.toJson(),
      };

  @override
  TsRoomResponse fromJson(String jsonStr) {
    return fromMap(jsonDecode(jsonStr));
  }

  @override
  TsRoomResponse fromMap(Map<String, dynamic> json) => TsRoomResponse(
        roomId: json['roomId'] as int? ?? 0,
        roomName: json['roomName'] as String?,
        roomStatus: json['roomStatus'] as int? ?? 0,
        roomOccupied: json['roomOccupied'] as bool? ?? false,
        audit: json["audit"] != null
            ? TsAuditResponse.fromJson(json["audit"])
            : TsAuditResponse.createEmpty(),
      );
}
