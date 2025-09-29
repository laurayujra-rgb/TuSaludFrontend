import 'dart:convert';
import 'package:tusalud/api/response/ts_response.dart';

class TsRegisterUserAdminResponse implements TsResponseService {
  int accountId;
  String accountEmail;
  int accountStatus;
  int personId;

  TsRegisterUserAdminResponse({
    required this.accountId,
    required this.accountEmail,
    required this.accountStatus,
    required this.personId,
  });

  /// Crear una instancia vacía
  factory TsRegisterUserAdminResponse.createEmpty() =>
      TsRegisterUserAdminResponse(
        accountId: 0,
        accountEmail: '',
        accountStatus: 0,
        personId: 0,
      );

  /// Implementación obligatoria de TsResponseService
  @override
  String toJson() => json.encode(toMap());

  @override
  Map<String, dynamic> toMap() {
    return {
      'accountId': accountId,
      'accountEmail': accountEmail,
      'accountStatus': accountStatus,
      'personId': personId,
    };
  }

  @override
  TsRegisterUserAdminResponse fromJson(String jsonStr) {
    return fromMap(json.decode(jsonStr));
  }

  @override
  TsRegisterUserAdminResponse fromMap(Map<String, dynamic> json) {
    return TsRegisterUserAdminResponse(
      accountId: json['accountId'] as int? ?? 0,
      accountEmail: json['accountEmail'] as String? ?? '',
      accountStatus: json['accountStatus'] as int? ?? 0,
      personId: json['personId'] as int? ?? 0,
    );
  }

  /// Método adicional para usar cuando ya tienes un Map (por consistencia)
  factory TsRegisterUserAdminResponse.fromJsonMap(Map<String, dynamic> json) {
    return TsRegisterUserAdminResponse(
      accountId: json['accountId'] as int? ?? 0,
      accountEmail: json['accountEmail'] as String? ?? '',
      accountStatus: json['accountStatus'] as int? ?? 0,
      personId: json['personId'] as int? ?? 0,
    );
  }
}
