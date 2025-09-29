import 'dart:convert';

class TsPersonRequest {
  String? personName;
  String? personFatherSurname;
  String? personMotherSurname;
  String? personDni;
  String? personBirthdate;
  int? personAge;
  int genderId;
  int roleId;

  TsPersonRequest({
    this.personName,
    this.personFatherSurname,
    this.personMotherSurname,
    this.personDni,
    this.personBirthdate,
    this.personAge,
    required this.genderId,
    required this.roleId,
  });

  factory TsPersonRequest.createEmpty() => TsPersonRequest(
        personName: '',
        personFatherSurname: '',
        personMotherSurname: '',
        personDni: '',
        personBirthdate: '',
        personAge: 0,
        genderId: 0,
        roleId: 0,
      );

  Map<String, dynamic> toMap() => {
        "personName": personName,
        "personFatherSurname": personFatherSurname,
        "personMotherSurname": personMotherSurname,
        "personDni": personDni,
        "personBirthdate": personBirthdate,
        "personAge": personAge,
        "gender": {
          "genderId": genderId,
        },
        "role": {
          "roleId": roleId,
        },
      };

  String toJson() => json.encode(toMap());

  factory TsPersonRequest.fromJson(Map<String, dynamic> json) =>
      TsPersonRequest(
        personName: json["personName"] as String?,
        personFatherSurname: json["personFatherSurname"] as String?,
        personMotherSurname: json["personMotherSurname"] as String?,
        personDni: json["personDni"] as String?,
        personBirthdate: json["personBirthdate"] as String?,
        personAge: json["personAge"] as int?,
        genderId: (json["gender"]?["genderId"] as int?) ?? 0,
        roleId: (json["role"]?["roleId"] as int?) ?? 0,
      );

  TsPersonRequest fromMap(Map<String, dynamic> json) => TsPersonRequest.fromJson(json);
}
