import '../app/ts_gender_response.dart';
import '../app/ts_role_response.dart';

class TsPersonResponse {
  int personId;
  String? personName;
  String? personFatherSurname;
  String? personMotherSurname;
  String? personDni;
  String? personBirthdate;
  int? personAge;
  int personStatus;
  TsGenderResponse gender;
  TsRoleResponse role;

  TsPersonResponse({
    required this.personId,
    this.personName,
    this.personFatherSurname,
    this.personMotherSurname,
    this.personDni,
    this.personBirthdate,
    this.personAge,
    required this.personStatus,
    required this.gender,
    required this.role,
  });

  factory TsPersonResponse.createEmpty() => TsPersonResponse(
        personId: 0,
        personName: '',
        personFatherSurname: '',
        personMotherSurname: '',
        personDni: '',
        personBirthdate: '',
        personAge: 0,
        personStatus: 0,
        gender: TsGenderResponse.createEmpty(),
        role: TsRoleResponse.createEmpty(),
      );

  factory TsPersonResponse.fromJson(Map<String, dynamic> json) => TsPersonResponse(
        personId: json["personId"] as int? ?? 0,
        personName: json["personName"] as String?,
        personFatherSurname: json["personFatherSurname"] as String?,
        personMotherSurname: json["personMotherSurname"] as String?,
        personDni: json["personDni"] as String?,
        personBirthdate: json["personBirthdate"] as String?,
        personAge: json["personAge"] as int?,
        personStatus: json["personStatus"] as int? ?? 0,
        gender: json["gender"] != null
            ? TsGenderResponse.fromJson(json["gender"])
            : TsGenderResponse.createEmpty(),
        role: json["role"] != null
            ? TsRoleResponse.fromJson(json["role"])
            : TsRoleResponse.createEmpty(),
      );
}
