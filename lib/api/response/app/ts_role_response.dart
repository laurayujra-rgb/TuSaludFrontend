import 'dart:convert';

import 'package:tusalud/api/response/app/ts_audit_response.dart';
import 'package:tusalud/api/response/ts_response.dart';

class TsRoleResponse implements TsResponseService{

int roleId;
String? roleName;
int roleStatus;
TsAuditResponse? audit;

  TsRoleResponse({
    required this.roleId,
    this.roleName,
    required this.roleStatus,
    required this.audit,
  });

  factory TsRoleResponse.createEmpty() => TsRoleResponse(
        roleId: 0,
        roleName: '',
        roleStatus: 0,
        audit: TsAuditResponse.createEmpty(),
      );

  @override
  String toJson() => json.encode(toMap());

  factory TsRoleResponse.fromJson(Map<String, dynamic> json) => TsRoleResponse(
      roleId: json["roleId"] as int? ?? 0,
      roleName: json["roleName"] as String?,
      roleStatus: json["roleStatus"] as int? ?? 0,
      audit: json["audit"] != null 
        ? TsAuditResponse.fromJson(json["audit"]) 
        : TsAuditResponse.createEmpty(),
    );
    @override
    Map<String, dynamic> toMap() =>{
        "roleId": roleId,
        "roleName": roleName,
        "roleStatus": roleStatus,
        "audit": audit?.toJson(),
};

  @override
  TsRoleResponse fromJson(String json) {
    return fromMap(jsonDecode(json));
  }

  @override
  TsRoleResponse fromMap(Map<String, dynamic> json) => TsRoleResponse(
        roleId: json["roleId"] as int? ?? 0,
        roleName: json["roleName"]as String?,
        roleStatus: json["roleStatus"] as int? ?? 0,
        audit: json["audit"] != null 
        ? TsAuditResponse.fromJson(json["audit"]) 
        : TsAuditResponse.createEmpty(),
      );
}