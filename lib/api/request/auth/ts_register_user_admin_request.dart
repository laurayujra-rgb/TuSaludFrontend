import 'dart:convert';

class TsRegisterUserAdminRequest {
  final TsPersonPart person;
  final TsAccountPart account;

  TsRegisterUserAdminRequest({
    required this.person,
    required this.account,
  });

  Map<String, dynamic> toMap() {
    return {
      'person': person.toMap(),
      'account': account.toMap(),
    };
  }

  String toJson() => json.encode(toMap());
}

/// Representa los datos de la persona
class TsPersonPart {
  final String personName;
  final String personFatherSurname;
  final String personMotherSurname;
  final String personDni;
  final String personBirthdate;
  final int personAge;
  final int genderId;
  final int roleId;

  TsPersonPart({
    required this.personName,
    required this.personFatherSurname,
    required this.personMotherSurname,
    required this.personDni,
    required this.personBirthdate,
    required this.personAge,
    required this.genderId,
    required this.roleId,
  });

  Map<String, dynamic> toMap() {
    return {
      'personName': personName,
      'personFatherSurname': personFatherSurname,
      'personMotherSurname': personMotherSurname,
      'personDni': personDni,
      'personBirthdate': personBirthdate,
      'personAge': personAge,
      'genderId': genderId,
      'roleId': roleId,
    };
  }
}

/// Representa los datos de la cuenta
class TsAccountPart {
  final String accountEmail;
  final String accountPassword;

  TsAccountPart({
    required this.accountEmail,
    required this.accountPassword,
  });

  Map<String, dynamic> toMap() {
    return {
      'accountEmail': accountEmail,
      'accountPassword': accountPassword,
    };
  }
}
