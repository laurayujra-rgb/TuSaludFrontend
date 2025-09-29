import 'dart:convert';
import 'package:tusalud/api/response/app/ts_kardex_medicine_response.dart';
import 'package:tusalud/api/response/app/ts_via_response.dart';
import 'package:tusalud/api/response/ts_response.dart';

class TsMedicineResponse implements TsResponseService {
  int medicineId;
  String? medicineName;
  String? medicineDateToEnd;
  String? medicineMoorning;
  String? medicineAfternoon;
  String? medicineEvening;
  int? medicineStatus;
  TsViaResponse via;
  List<TsKardexMedicineResponse> kardexMedicines;

  TsMedicineResponse({
    required this.medicineId,
    this.medicineName,
    this.medicineDateToEnd,
    this.medicineMoorning,
    this.medicineAfternoon,
    this.medicineEvening,
    this.medicineStatus,
    required this.via,
    this.kardexMedicines = const [],
  });

  factory TsMedicineResponse.createEmpty() => TsMedicineResponse(
        medicineId: 0,
        medicineName: '',
        medicineDateToEnd: '',
        medicineMoorning: '',
        medicineAfternoon: '',
        medicineEvening: '',
        medicineStatus: 0,
        via: TsViaResponse.createEmpty(),
        kardexMedicines: [],
      );

  @override
  String toJson() => json.encode(toMap());

  factory TsMedicineResponse.fromJson(Map<String, dynamic> json) =>
      TsMedicineResponse(
        medicineId: json["medicineId"] as int? ?? 0,
        medicineName: json["medicineName"] as String?,
        medicineDateToEnd: json["medicineDateToEnd"] as String?,
        medicineMoorning: json["medicineMoorning"] as String?,
        medicineAfternoon: json["medicineAfternoon"] as String?,
        medicineEvening: json["medicineEvening"] as String?,
        medicineStatus: json["medicineStatus"] as int?,
        via: TsViaResponse.fromJson(json["via"]),
        kardexMedicines: json["kardexMedicines"] != null
            ? List<TsKardexMedicineResponse>.from(
                (json["kardexMedicines"] as List)
                    .map((x) => TsKardexMedicineResponse.fromJson(x)))
            : [],
      );

  @override
  Map<String, dynamic> toMap() => {
        "medicineId": medicineId,
        "medicineName": medicineName,
        "medicineDateToEnd": medicineDateToEnd,
        "medicineMoorning": medicineMoorning,
        "medicineAfternoon": medicineAfternoon,
        "medicineEvening": medicineEvening,
        "medicineStatus": medicineStatus,
        "via": via.toMap(),
        "kardexMedicines":
            kardexMedicines.map((x) => x.toMap()).toList(),
      };

  @override
  TsMedicineResponse fromJson(String jsonStr) {
    return fromMap(jsonDecode(jsonStr));
  }

  @override
  TsMedicineResponse fromMap(Map<String, dynamic> json) =>
      TsMedicineResponse(
        medicineId: json["medicineId"] as int? ?? 0,
        medicineName: json["medicineName"] as String?,
        medicineDateToEnd: json["medicineDateToEnd"] as String?,
        medicineMoorning: json["medicineMoorning"] as String?,
        medicineAfternoon: json["medicineAfternoon"] as String?,
        medicineEvening: json["medicineEvening"] as String?,
        medicineStatus: json["medicineStatus"] as int?,
        via: TsViaResponse.fromJson(json["via"]),
        kardexMedicines: json["kardexMedicines"] != null
            ? List<TsKardexMedicineResponse>.from(
                (json["kardexMedicines"] as List)
                    .map((x) => TsKardexMedicineResponse.fromJson(x)))
            : [],
      );
}
