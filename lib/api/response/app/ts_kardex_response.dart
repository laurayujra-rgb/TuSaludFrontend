import 'dart:convert';

import 'package:tusalud/api/response/ts_response.dart';

class TsKardexResponse implements TsResponseService {
  int kardexId;
  int kardexNumber;
  String? kardexDiagnosis;
  String? kardexDate;
  String? kardexHour;
  int kardexStatus;
  String? nursingActions;
  int? dietId;
  String? dietName;

  // 🔹 Solo nombres (ignoro los IDs)
  String? patientName;
  String? nurseName;

  TsKardexResponse({
    required this.kardexId,
    required this.kardexNumber,
    this.kardexDiagnosis,
    this.kardexDate,
    this.kardexHour,
    required this.kardexStatus,
    this.nursingActions,
    this.dietId,
    this.dietName,
    this.patientName,
    this.nurseName,
  });

  factory TsKardexResponse.createEmpty() => TsKardexResponse(
        kardexId: 0,
        kardexNumber: 0,
        kardexDiagnosis: '',
        kardexDate: '',
        kardexHour: '',
        kardexStatus: 0,
        nursingActions: '',
        dietId: 0,
        dietName: '',
        patientName: '',
        nurseName: '',
      );

  @override
  String toJson() => json.encode(toMap());

  factory TsKardexResponse.fromJson(Map<String, dynamic> json) =>
      TsKardexResponse(
        kardexId: json['kardexId'] as int? ?? 0,
        kardexNumber: json['kardexNumber'] as int? ?? 0,
        kardexDiagnosis: json['kardexDiagnosis'] as String? ?? '',
        kardexDate: json['kardexDate'] as String? ?? '',
        kardexHour: json['kardexHour'] as String? ?? '',
        kardexStatus: json['kardexStatus'] as int? ?? 0,
        nursingActions: json['nursingActions'] as String? ?? '',
        dietId: json['dietId'] as int?,
        dietName: json['dietName'] as String?,
        // 🔹 Aquí ignoro los IDs, solo uso nombres
        patientName: json['patientName'] as String? ?? '',
        nurseName: json['nurseName'] as String? ?? '',
      );

  @override
  Map<String, dynamic> toMap() => {
        "kardexId": kardexId,
        "kardexNumber": kardexNumber,
        "kardexDiagnosis": kardexDiagnosis,
        "kardexDate": kardexDate,
        "kardexHour": kardexHour,
        "kardexStatus": kardexStatus,
        "nursingActions": nursingActions,
        "dietId": dietId,
        "dietName": dietName,
        "patientName": patientName,
        "nurseName": nurseName,
      };

  @override
  TsKardexResponse fromJson(String jsonStr) {
    return fromMap(jsonDecode(jsonStr));
  }

  @override
  TsKardexResponse fromMap(Map<String, dynamic> json) => TsKardexResponse(
        kardexId: json['kardexId'] as int? ?? 0,
        kardexNumber: json['kardexNumber'] as int? ?? 0,
        kardexDiagnosis: json['kardexDiagnosis'] as String? ?? '',
        kardexDate: json['kardexDate'] as String? ?? '',
        kardexHour: json['kardexHour'] as String? ?? '',
        kardexStatus: json['kardexStatus'] as int? ?? 0,
        nursingActions: json['nursingActions'] as String? ?? '',
        dietId: json['dietId'] as int?,
        dietName: json['dietName'] as String?,
        patientName: json['patientName'] as String? ?? '',
        nurseName: json['nurseName'] as String? ?? '',
      );
}
