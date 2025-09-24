
class TsSignUpRequest{
  final String personName;
  final String personSurname;
  final String personBirthdate;
  final String personWhatsappNumber;
  final String personEmail;
  final String personPassword;
  final String personDni;
  final String personAddress;
  final String personAge;
  final int idGender;
  final int idPersonType;
  final int idCountry;
  final int idCity;

  TsSignUpRequest({
    required this.personName,
    required this.personSurname,
    required this.personBirthdate,
    required this.personWhatsappNumber,
    required this.personEmail,
    required this.personPassword,
    required this.personDni,
    required this.personAddress,
    required this.personAge,
    required this.idGender,
    required this.idPersonType,
    required this.idCountry,
    required this.idCity,
  });

  Map<String, dynamic> toJson() {
    return {
      'personName': personName,
      'personSurname': personSurname,
      'personBirthdate': personBirthdate,
      'personWhatsappNumber': personWhatsappNumber,
      'personEmail': personEmail,
      'personPassword': personPassword,
      'personDni': personDni,
      'personAddress': personAddress,
      'personAge': personAge,
      'idGender': idGender,
      'idPersonType': idPersonType,
      'idCountry': idCountry,
      'idCity': idCity,
    };
  }
}