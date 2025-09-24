import 'package:tusalud/api/response/app/ts_gender_response.dart';
import 'package:tusalud/api/response/app/ts_role_response.dart';
import 'dart:convert';

import 'package:tusalud/api/response/ts_response.dart';

class TsPersonResponse implements TsResponseService {
  int idPerson;
  String? personName;
  String? personSurname;
  String? personWhatsappNumber;
  String? personPassword;
  String? personDni;
  String? personBirthdate;
  String? personEmail;
  String? personAddress;
  String? personAge;
  int personStatus;
  TsGenderResponse gender;
  TsRoleResponse role;


  TsPersonResponse({
    required this.idPerson,
    this.personName,
    this.personSurname,
    this.personWhatsappNumber,
    this.personPassword,
    this.personDni,
    this.personBirthdate,
    this.personEmail,
    this.personAddress,
    this.personAge,
    required this.personStatus,
    required this.gender,
    required this.role,

  });

  factory TsPersonResponse.createEmpty() => TsPersonResponse(
        idPerson: 0,
        personName: '',
        personSurname: '',
        personWhatsappNumber: '',
        personPassword: '',
        personDni: '',
        personBirthdate: '',
        personEmail: '',
        personAddress: '',
        personAge: '',
        personStatus: 0,
        gender: TsGenderResponse.createEmpty(),
        role: TsRoleResponse.createEmpty(),

      );

  @override
  String toJson() => json.encode(toMap());

factory TsPersonResponse.fromJson(Map<String, dynamic> json) => TsPersonResponse(
      idPerson: json["idPerson"] as int? ?? 0,
      personName: json["personName"] as String?,
      personSurname: json["personSurname"] as String?,
      personWhatsappNumber: json["personWhatsappNumber"] as String?,
      personPassword: json["personPassword"] as String?,
      personDni: json["personDni"] as String?,
      personBirthdate: json["personBirthdate"] as String?,
      personEmail: json["personEmail"] as String?,
      personAddress: json["personAddress"] as String?,
      personAge: json["personAge"] as String?,
      personStatus: json["personStatus"] as int? ?? 0,
      gender: json["gender"] != null 
          ? TsGenderResponse.fromJson(json["gender"] as Map<String, dynamic>) 
          : TsGenderResponse.createEmpty(),
      role: json["role"] != null
          ? TsRoleResponse.fromJson(json["role"] as Map<String, dynamic>)
          : TsRoleResponse.createEmpty(),
    );

  @override
  Map<String, dynamic> toMap() => {
        "idPerson": idPerson,
        "personName": personName,
        "personSurname": personSurname,
        "personWhatsappNumber": personWhatsappNumber,
        "personPassword": personPassword,
        "personDni": personDni,
        "personBirthdate": personBirthdate,
        "personEmail": personEmail,
        "personAddress": personAddress,
        "personAge": personAge,
        "personStatus": personStatus,
        "gender": gender.toJson(),
        "role": role.toJson(),

      };

  @override
  TsPersonResponse fromJson(String json) {
    return fromMap(jsonDecode(json));
  }

  @override
  TsPersonResponse fromMap(Map<String, dynamic> json) => TsPersonResponse(
      idPerson: json["idPerson"] as int? ?? 0,
      personName: json["personName"] as String?,
      personSurname: json["personSurname"] as String?,
      personWhatsappNumber: json["personWhatsappNumber"] as String?,
      personPassword: json["personPassword"] as String?,
      personDni: json["personDni"] as String?,
      personBirthdate: json["personBirthdate"] as String?,
      personEmail: json["personEmail"] as String?,
      personAddress: json["personAddress"] as String?,
      personAge: json["personAge"] as String?,
      personStatus: json["personStatus"] as int? ?? 0,
      gender: json["gender"] != null 
          ? TsGenderResponse.fromJson(json["gender"] as Map<String, dynamic>) 
          : TsGenderResponse.createEmpty(),
      role: json["role"] != null
          ? TsRoleResponse.fromJson(json["role"] as Map<String, dynamic>)
          : TsRoleResponse.createEmpty(),

    );
}