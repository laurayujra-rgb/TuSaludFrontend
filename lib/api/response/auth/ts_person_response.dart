import 'package:smarttolls/models/models.dart';
import 'package:smarttolls/api/api.dart';
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
  StGenderResponse gender;
  StPersonTypeResponse personType;


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
    required this.personType,

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
        gender: StGenderResponse.createEmpty(),
        personType: StPersonTypeResponse.createEmpty(),

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
          ? StGenderResponse.fromJson(json["gender"] as Map<String, dynamic>) 
          : StGenderResponse.createEmpty(),
      personType: json["personType"] != null
          ? StPersonTypeResponse.fromJson(json["personType"] as Map<String, dynamic>)
          : StPersonTypeResponse.createEmpty(),
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
        "personType": personType.toJson(),

      };

  @override
  TsPersonResponse fromJson(String json) {
    return fromMap(jsonDecode(json));
  }

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
          ? StGenderResponse.fromJson(json["gender"] as Map<String, dynamic>) 
          : StGenderResponse.createEmpty(),
      personType: json["personType"] != null
          ? StPersonTypeResponse.fromJson(json["personType"] as Map<String, dynamic>)
          : StPersonTypeResponse.createEmpty(),

    );
}