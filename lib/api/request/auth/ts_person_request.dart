class TsPersonRequest {
  final String personName;
  final String personFatherSurname;
  final String? personMotherSurname;
  final String personDni;
  final String personBirthdate;
  final int personAge;
  final int genderId;
  final int roleId;

  TsPersonRequest({
    required this.personName,
    required this.personFatherSurname,
    this.personMotherSurname,
    required this.personDni,
    required this.personBirthdate,
    required this.personAge,
    required this.genderId,
    required this.roleId,
  });

  Map<String, dynamic> toJson() {
    return {
      "personName": personName,
      "personFatherSurname": personFatherSurname,
      "personMotherSurname": personMotherSurname,
      "personDni": personDni,
      "personBirthdate": personBirthdate,
      "personAge": personAge,
      "gender": { "genderId": genderId },
      "role": { "roleId": roleId },
    };
  }

  debugPrint() {
    print(
      'Nombre: $personName, Apellido: $personFatherSurname, DNI: $personDni, '
      'Edad: $personAge, Genero: $genderId, Rol: $roleId'
    );
  }
}
