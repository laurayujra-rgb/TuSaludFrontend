import 'dart:convert';

import 'package:tusalud/api/response/app/ts_audit_response.dart';
import 'package:tusalud/api/response/app/ts_kardex_medicine_response.dart';
import 'package:tusalud/api/response/ts_response.dart';

import 'ts_diet_response.dart';

class TsKardexResponse implements TsResponseService {
  int kardexId;
  int? kardexNumber;
  String? kardexDiagnosis;
  String? kardexDate;
  String? kardexHour;
  int? kardexStatus;
  TsDietResponse? diet;
  List<TsKardexMedicineResponse> kardexMedicines;
  String? nursingActions;
  TsAuditResponse? audit;

  TsKardexResponse({
    required this.kardexId,
    this.kardexNumber,
    this.kardexDiagnosis,
    this.kardexDate,
    this.kardexHour,
    this.kardexStatus,
    this.diet,
    this.kardexMedicines = const [],
    this.nursingActions,
    this.audit,
  });

  factory TsKardexResponse.createEmpty() => TsKardexResponse(
        kardexId: 0,
        kardexNumber: 0,
        kardexDiagnosis: '',
        kardexDate: '',
        kardexHour: '',
        kardexStatus: 0,
        diet: TsDietResponse.createEmpty(),
        kardexMedicines: [],
        nursingActions: '',
        audit: TsAuditResponse.createEmpty(),
      );

  @override
  String toJson() => json.encode(toMap());

  factory TsKardexResponse.fromJson(Map<String, dynamic> json) =>
      TsKardexResponse(
        kardexId: json["kardexId"] as int? ?? 0,
        kardexNumber: json["kardexNumber"] as int?,
        kardexDiagnosis: json["kardexDiagnosis"] as String?,
        kardexDate: json["kardexDate"] as String?,
        kardexHour: json["kardexHour"] as String?,
        kardexStatus: json["kardexStatus"] as int?,
        diet: json["diets"] != null
            ? TsDietResponse.fromJson(json["diets"])
            : TsDietResponse.createEmpty(),
        kardexMedicines: json["kardexMedicines"] != null
            ? List<TsKardexMedicineResponse>.from(
                (json["kardexMedicines"] as List)
                    .map((x) => TsKardexMedicineResponse.fromJson(x)))
            : [],
        nursingActions: json["nursingActions"] as String?,
        audit: json["audit"] != null
            ? TsAuditResponse.fromJson(json["audit"])
            : TsAuditResponse.createEmpty(),
      );

  @override
  Map<String, dynamic> toMap() => {
        "kardexId": kardexId,
        "kardexNumber": kardexNumber,
        "kardexDiagnosis": kardexDiagnosis,
        "kardexDate": kardexDate,
        "kardexHour": kardexHour,
        "kardexStatus": kardexStatus,
        "diets": diet?.toMap(),
        "kardexMedicines":
            kardexMedicines.map((x) => x.toMap()).toList(),
        "nursingActions": nursingActions,
        "audit": audit?.toJson(),
      };

  @override
  TsKardexResponse fromJson(String jsonStr) {
    return fromMap(jsonDecode(jsonStr));
  }

  @override
  TsKardexResponse fromMap(Map<String, dynamic> json) => TsKardexResponse(
        kardexId: json["kardexId"] as int? ?? 0,
        kardexNumber: json["kardexNumber"] as int?,
        kardexDiagnosis: json["kardexDiagnosis"] as String?,
        kardexDate: json["kardexDate"] as String?,
        kardexHour: json["kardexHour"] as String?,
        kardexStatus: json["kardexStatus"] as int?,
        diet: json["diets"] != null
            ? TsDietResponse.fromJson(json["diets"])
            : TsDietResponse.createEmpty(),
        kardexMedicines: json["kardexMedicines"] != null
            ? List<TsKardexMedicineResponse>.from(
                (json["kardexMedicines"] as List)
                    .map((x) => TsKardexMedicineResponse.fromJson(x)))
            : [],
        nursingActions: json["nursingActions"] as String?,
        audit: json["audit"] != null
            ? TsAuditResponse.fromJson(json["audit"])
            : TsAuditResponse.createEmpty(),
      );
}
