import 'dart:convert';

import 'package:tusalud/api/response/app/ts_audit_response.dart';
import 'package:tusalud/api/response/app/ts_gender_response.dart';
import 'package:tusalud/api/response/app/ts_role_response.dart';
import 'package:tusalud/api/response/app/ts_bed_response.dart';
import 'package:tusalud/api/response/ts_response.dart';

class TsPeopleResponse implements TsResponseService {
  int personId;
  String? personName;
  String? personFahterSurname;
  String? personMotherSurname;
  String? personDni;
  String? personBirthdate;
  int? personAge;
  int? personStatus;

  // 👇 NUEVO: cama (con room dentro)
  TsBedsResponse? bed;

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
    this.bed, // 👈
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
        bed: null,
        gender: TsGenderResponse.createEmpty(),
        role: TsRoleResponse.createEmpty(),
        audit: TsAuditResponse.createEmpty(),
      );

  @override
  String toJson() => json.encode(toMap());

  factory TsPeopleResponse.fromJson(Map<String, dynamic> json) =>
      TsPeopleResponse(
        personId: json['personId'] as int? ?? 0,
        personName: json['personName'] as String?,
        personFahterSurname: json['personFatherSurname'] as String? ??
            json['personFahterSurname'] as String?, // por si el backend usa ambos
        personMotherSurname: json['personMotherSurname'] as String?,
        personDni: json['personDni'] as String?,
        personBirthdate: json['personBirthdate'] as String?,
        personAge: json['personAge'] as int? ?? 0,
        personStatus: json['personStatus'] as int? ?? 1,

        // 👇 bed opcional
        bed: (json["bed"] != null)
            ? TsBedsResponse.fromJson(json["bed"] as Map<String, dynamic>)
            : null,

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
  Map<String, dynamic> toMap() => {
        'personId': personId,
        'personName': personName,
        'personFahterSurname': personFahterSurname,
        'personMotherSurname': personMotherSurname,
        'personDni': personDni,
        'personBirthdate': personBirthdate,
        'personAge': personAge,
        'personStatus': personStatus,

        // 👇 incluimos cama si existe
        if (bed != null) 'bed': bed!.toMap(),

        'gender': gender.toJson(),
        'role': role.toJson(),
        "audit": audit?.toJson(),
      };

  @override
  TsPeopleResponse fromJson(String jsonStr) {
    return fromMap(jsonDecode(jsonStr));
  }

  @override
  TsPeopleResponse fromMap(Map<String, dynamic> json) => TsPeopleResponse(
        personId: json['personId'] as int? ?? 0,
        personName: json['personName'] as String?,
        personFahterSurname: json['personFatherSurname'] as String? ??
            json['personFahterSurname'] as String?,
        personMotherSurname: json['personMotherSurname'] as String?,
        personDni: json['personDni'] as String?,
        personBirthdate: json['personBirthdate'] as String?,
        personAge: json['personAge'] as int? ?? 0,
        personStatus: json['personStatus'] as int? ?? 1,

        bed: (json["bed"] != null)
            ? TsBedsResponse.fromJson(json["bed"] as Map<String, dynamic>)
            : null,

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
