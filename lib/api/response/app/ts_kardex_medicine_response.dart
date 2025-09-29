import 'dart:convert';
import 'package:tusalud/api/response/ts_response.dart';

class TsKardexMedicineResponse implements TsResponseService {
  int id;
  int kardexId;
  int medicineId;
  String? medicineName;
  String? dose;
  String? frequency;
  String? routeNote;
  String? notes;
  int? status;

  TsKardexMedicineResponse({
    required this.id,
    required this.kardexId,
    required this.medicineId,
    this.medicineName,
    this.dose,
    this.frequency,
    this.routeNote,
    this.notes,
    this.status,
  });

  factory TsKardexMedicineResponse.createEmpty() => TsKardexMedicineResponse(
        id: 0,
        kardexId: 0,
        medicineId: 0,
        medicineName: '',
        dose: '',
        frequency: '',
        routeNote: '',
        notes: '',
        status: 0,
      );

  @override
  String toJson() => json.encode(toMap());

  factory TsKardexMedicineResponse.fromJson(Map<String, dynamic> json) =>
      TsKardexMedicineResponse(
        id: json["id"] as int? ?? 0,
        kardexId: json["kardexId"] as int? ?? 0,
        medicineId: json["medicineId"] as int? ?? 0,
        medicineName: json["medicineName"] as String? ?? '',
        dose: json["dose"] as String? ?? '',
        frequency: json["frequency"] as String? ?? '',
        routeNote: json["routeNote"] as String? ?? '',
        notes: json["notes"] as String? ?? '',
        status: json["status"] as int? ?? 0,
      );

  @override
  Map<String, dynamic> toMap() => {
        "id": id,
        "kardexId": kardexId,
        "medicineId": medicineId,
        "medicineName": medicineName,
        "dose": dose,
        "frequency": frequency,
        "routeNote": routeNote,
        "notes": notes,
        "status": status,
      };

  @override
  TsKardexMedicineResponse fromJson(String jsonStr) {
    return fromMap(jsonDecode(jsonStr));
  }

  @override
  TsKardexMedicineResponse fromMap(Map<String, dynamic> json) =>
      TsKardexMedicineResponse(
        id: json["id"] as int? ?? 0,
        kardexId: json["kardexId"] as int? ?? 0,
        medicineId: json["medicineId"] as int? ?? 0,
        medicineName: json["medicineName"] as String? ?? '',
        dose: json["dose"] as String? ?? '',
        frequency: json["frequency"] as String? ?? '',
        routeNote: json["routeNote"] as String? ?? '',
        notes: json["notes"] as String? ?? '',
        status: json["status"] as int? ?? 0,
      );
}
