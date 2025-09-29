import 'dart:convert';

import 'package:tusalud/api/response/app/ts_audit_response.dart';
import 'package:tusalud/api/response/app/ts_gender_response.dart';
import 'package:tusalud/api/response/app/ts_role_response.dart';
import 'package:tusalud/api/response/auth/ts_person_response.dart';
import 'package:tusalud/api/response/ts_response.dart';
import 'package:tusalud/generated/l10.dart';

class TsPeopleResponse implements TsResponseService {
  int personId;
  String? personName;
  String? personFahterSurname;
  String? personMotherSurname;
  String? personDni;
  String? personBirthdate;
  int? personAge;
  int? personStatus;
  TsGenderResponse gender;
  TsRoleResponse role;
  TsAuditResponse? audit;

  TsPeopleResponse({
    required this.personId,
    this.personName,
    this.personFahterSurname,
    this.personMotherSurname,
    this.personDni,
    this.personBirthdate,
    this.personAge,
    this.personStatus,
    required this.gender,
    required this.role,
    required this.audit,
  });

  factory TsPeopleResponse.createEmpty() => TsPeopleResponse(
        personId: 0,
        personName: '',
        personFahterSurname: '',
        personMotherSurname: '',
        personDni: '',
        personBirthdate: '',
        personAge: 0,
        personStatus: 0,
        gender: TsGenderResponse.createEmpty(),
        role: TsRoleResponse.createEmpty(),
        audit: TsAuditResponse.createEmpty()
      );

    @override
    String toJson()=> json.encode(toMap());
  
  factory TsPeopleResponse.fromJson(Map<String, dynamic>json)=> TsPeopleResponse(
        personId: json['personId'] as int? ?? 0,
        personName: json['personName'] as String?,
        personFahterSurname: json['personFahterSurname'] as String?,
        personMotherSurname: json['personMotherSurname'] as String?,
        personDni: json['personDni'] as String?,
        personBirthdate: json['personBirthdate'] as String?,
        personAge: json['personAge'] as int? ?? 0,
        personStatus: json['personStatus'] as int? ?? 1,
        gender: json["gender"] != null
            ? TsGenderResponse.fromJson(json['gender'] as Map<String, dynamic>)
            : TsGenderResponse.createEmpty(),
        role: json["role"] != null
            ? TsRoleResponse.fromJson(json['role'] as Map<String, dynamic>)
            : TsRoleResponse.createEmpty(),
        audit: json["audit"] != null
            ? TsAuditResponse.fromJson(json["audit"])
            : TsAuditResponse.createEmpty(),
      );
    @override
    Map<String, dynamic> toMap()=> {
        'personId': personId,
        'personName': personName,
        'personFahterSurname': personFahterSurname,
        'personMotherSurname': personMotherSurname,
        'personDni': personDni,
        'personBirthdate': personBirthdate,
        'personAge': personAge,
        'personStatus': personStatus,
        'gender': gender.toJson(),
        'role': role.toJson(),
        "audit": audit?.toJson(),
        
      };
    @override
    TsPeopleResponse fromJson(String json){
      return fromMap(jsonDecode(json));
    }

    @override
    TsPeopleResponse fromMap(Map<String, dynamic>json) => TsPeopleResponse(
        personId: json['personId'] as int? ?? 0,
        personName: json['personName'] as String?,
        personFahterSurname: json['personFahterSurname'] as String?,
        personMotherSurname: json['personMotherSurname'] as String?,
        personDni: json['personDni'] as String?,
        personBirthdate: json['personBirthdate'] as String?,
        personAge: json['personAge'] as int? ?? 0,
        personStatus: json['personStatus'] as int? ?? 1,
        gender: json["gender"] != null
            ? TsGenderResponse.fromJson(json['gender'] as Map<String, dynamic>)
            : TsGenderResponse.createEmpty(),
        role: json["role"] != null
            ? TsRoleResponse.fromJson(json['role'] as Map<String, dynamic>)
            : TsRoleResponse.createEmpty(),
                audit: json["audit"] != null 
        ? TsAuditResponse.fromJson(json["audit"]) 
        : TsAuditResponse.createEmpty(),
    );
}