import 'dart:convert';
import 'package:tusalud/api/response/ts_response.dart';

class TsPatientInfoResponse implements TsResponseService {
  int? patientId;
  String? patientName;
  String? personBirthdate;
  int? personAge;

  TsPatientInfoResponse({
    this.patientId,
    this.patientName,
    this.personBirthdate,
    this.personAge,
  });

  factory TsPatientInfoResponse.createEmpty() => TsPatientInfoResponse(
        patientId: 0,
        patientName: '',
        personBirthdate: '',
        personAge: 0,
      );

  factory TsPatientInfoResponse.fromJson(Map<String, dynamic> json) =>
      TsPatientInfoResponse(
        patientId: json['patientId'] as int? ?? 0,
        patientName: json['patientName'] as String?,
        personBirthdate: json['personBirthdate'] as String?,
        personAge: json['personAge'] as int? ?? 0,
      );

  @override
  String toJson() => json.encode(toMap());

  @override
  Map<String, dynamic> toMap() => {
        'patientId': patientId,
        'patientName': patientName,
        'personBirthdate': personBirthdate,
        'personAge': personAge,
      };

  @override
  TsPatientInfoResponse fromJson(String jsonStr) {
    return fromMap(jsonDecode(jsonStr));
  }

  @override
  TsPatientInfoResponse fromMap(Map<String, dynamic> json) =>
      TsPatientInfoResponse(
        patientId: json['patientId'] as int? ?? 0,
        patientName: json['patientName'] as String?,
        personBirthdate: json['personBirthdate'] as String?,
        personAge: json['personAge'] as int? ?? 0,
      );
}
