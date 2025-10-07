// lib/api/request/auth/ts_patient_create_request.dart
class TsPatientCreateRequest {
  final String personName;
  final String personFatherSurname;
  final String? personMotherSurname;
  final String personDni;
  final String personBirthdate;
  final int personAge;
  final int genderId;
  final int bedId; // requerido para paciente

  // rol es SIEMPRE 4 (paciente) -> no lo exponemos fuera
  static const int _roleId = 4;

  TsPatientCreateRequest({
    required this.personName,
    required this.personFatherSurname,
    this.personMotherSurname,
    required this.personDni,
    required this.personBirthdate,
    required this.personAge,
    required this.genderId,
    required this.bedId,
  });

  Map<String, dynamic> toJson() {
    return {
      "personName": personName,
      "personFatherSurname": personFatherSurname,
      "personMotherSurname": personMotherSurname,
      "personDni": personDni,
      "personBirthdate": personBirthdate,
      "personAge": personAge,
      "gender": {"genderId": genderId},
      "role": {"roleId": _roleId},
      "bed": {"bedId": bedId},
    };
  }
}
