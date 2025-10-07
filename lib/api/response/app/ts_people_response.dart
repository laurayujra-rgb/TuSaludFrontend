// ts_people_response.dart
import 'dart:convert';

import 'package:tusalud/api/response/app/ts_audit_response.dart';
import 'package:tusalud/api/response/app/ts_gender_response.dart';
import 'package:tusalud/api/response/app/ts_role_response.dart';
import 'package:tusalud/api/response/app/ts_bed_response.dart';
import 'package:tusalud/api/response/app/ts_room_response.dart';
import 'package:tusalud/api/response/ts_response.dart';

class TsPeopleResponse implements TsResponseService {
  int personId;
  String? personName;
  String? personFahterSurname; // (propiedad mantiene el nombre que ya usas)
  String? personMotherSurname;
  String? personDni;
  String? personBirthdate;
  int? personAge;
  int? personStatus;
  TsGenderResponse gender;
  TsRoleResponse role;

  /// 👇 Relacionadas
  TsBedsResponse? bed;
  TsRoomResponse? room;

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
    this.bed,
    this.room,
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
        bed: null,
        room: null,
        audit: TsAuditResponse.createEmpty(),
      );

  @override
  String toJson() => json.encode(toMap());

  factory TsPeopleResponse.fromJson(Map<String, dynamic> json) {
    // fallback para room: si no viene en raíz, lo tomo de bed.room
    final dynamic roomJson =
        json['room'] ?? (json['bed'] is Map<String, dynamic> ? (json['bed'] as Map<String, dynamic>)['room'] : null);

    return TsPeopleResponse(
      personId: json['personId'] as int? ?? 0,
      personName: json['personName'] as String?,
      // 👇 fallback key correcto/typo
      personFahterSurname:
          (json['personFatherSurname'] as String?) ?? (json['personFahterSurname'] as String?),
      personMotherSurname: json['personMotherSurname'] as String?,
      personDni: json['personDni'] as String?,
      personBirthdate: json['personBirthdate'] as String?,
      personAge: json['personAge'] as int? ?? 0,
      personStatus: json['personStatus'] as int? ?? 1,
      gender: json["gender"] != null
          ? TsGenderResponse.fromJson(Map<String, dynamic>.from(json['gender']))
          : TsGenderResponse.createEmpty(),
      role: json["role"] != null
          ? TsRoleResponse.fromJson(Map<String, dynamic>.from(json['role']))
          : TsRoleResponse.createEmpty(),
      bed: json["bed"] != null
          ? TsBedsResponse.fromJson(Map<String, dynamic>.from(json["bed"]))
          : null,
      room: roomJson != null
          ? TsRoomResponse.fromJson(Map<String, dynamic>.from(roomJson))
          : null,
      audit: json["audit"] != null
          ? TsAuditResponse.fromJson(json["audit"])
          : TsAuditResponse.createEmpty(),
    );
  }

  @override
  Map<String, dynamic> toMap() => {
        'personId': personId,
        'personName': personName,
        'personFatherSurname': personFahterSurname, // exporta con la key correcta
        'personMotherSurname': personMotherSurname,
        'personDni': personDni,
        'personBirthdate': personBirthdate,
        'personAge': personAge,
        'personStatus': personStatus,
        // Nota: si tus modelos tienen toMap(), mejor úsalo. Si sólo tienen toJson() que devuelve String, déjalo así.
        'gender': gender.toJson(),
        'role': role.toJson(),
        'bed': bed?.toMap(),
        'room': room?.toMap(),
        'audit': audit?.toJson(),
      };

  @override
  TsPeopleResponse fromJson(String jsonStr) {
    return fromMap(jsonDecode(jsonStr));
  }

  @override
  TsPeopleResponse fromMap(Map<String, dynamic> json) {
    final dynamic roomJson =
        json['room'] ?? (json['bed'] is Map<String, dynamic> ? (json['bed'] as Map<String, dynamic>)['room'] : null);

    return TsPeopleResponse(
      personId: json['personId'] as int? ?? 0,
      personName: json['personName'] as String?,
      // 👇 fallback key correcto/typo
      personFahterSurname:
          (json['personFatherSurname'] as String?) ?? (json['personFahterSurname'] as String?),
      personMotherSurname: json['personMotherSurname'] as String?,
      personDni: json['personDni'] as String?,
      personBirthdate: json['personBirthdate'] as String?,
      personAge: json['personAge'] as int? ?? 0,
      personStatus: json['personStatus'] as int? ?? 1,
      gender: json["gender"] != null
          ? TsGenderResponse.fromJson(Map<String, dynamic>.from(json['gender']))
          : TsGenderResponse.createEmpty(),
      role: json["role"] != null
          ? TsRoleResponse.fromJson(Map<String, dynamic>.from(json['role']))
          : TsRoleResponse.createEmpty(),
      bed: json["bed"] != null
          ? TsBedsResponse.fromJson(Map<String, dynamic>.from(json["bed"]))
          : null,
      room: roomJson != null
          ? TsRoomResponse.fromJson(Map<String, dynamic>.from(roomJson))
          : null,
      audit: json["audit"] != null
          ? TsAuditResponse.fromJson(json["audit"])
          : TsAuditResponse.createEmpty(),
    );
  }
}
