import 'dart:convert';

import 'package:tusalud/api/response/app/ts_audit_response.dart';
import 'package:tusalud/api/response/ts_response.dart';

class TsGenderResponse implements TsResponseService{

  int genderId;
  String? genderName;
  int genderStatus;
  TsAuditResponse audit;

  TsGenderResponse({
    required this.genderId,
    this.genderName,
    required this.genderStatus,
    required this.audit,
  });

  factory TsGenderResponse.createEmpty() => TsGenderResponse(
        genderId: 0,
        genderName: '',	
        genderStatus: 0,
        audit: TsAuditResponse.createEmpty(),
      );

  @override
  String toJson() => json.encode(toMap());

factory TsGenderResponse.fromJson(Map<String, dynamic> json) => TsGenderResponse(
      genderId: json["genderId"] as int,
      genderName: json["genderName"] as String,
      genderStatus: json["genderStatus"] as int,
      audit: TsAuditResponse.fromJson(json["audit"] as Map<String, dynamic>),
    );
  
  @override
  Map<String, dynamic> toMap() =>{
        "genderId": genderId,
        "genderName": genderName,
        "genderStatus": genderStatus,
        "audit": audit.toJson(),
  };
  
  @override
  TsGenderResponse fromJson(String json) {
    return fromMap(jsonDecode(json));
  }

  @override
  TsGenderResponse fromMap(Map<String, dynamic> json) => TsGenderResponse(
        genderId: json["genderId"],
        genderName: json["genderName"],
        genderStatus: json["genderStatus"],
        audit: TsAuditResponse.fromJson(json["audit"]),
      );
}