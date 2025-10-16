import 'dart:convert';
import 'package:tusalud/api/response/ts_response.dart';

class TsMedicationKardexResponse implements TsResponseService {
  int id;
  int kardexId;
  int medicineId;
  String? medicineName;
  String? dose;
  String? frequency;
  String? routeNote;
  String? notes;
  int status;
  String? nurseLic; // 👈 nombre corregido


  TsMedicationKardexResponse({
    required this.id,
    required this.kardexId,
    required this.medicineId,
    this.medicineName,
    this.dose,
    this.frequency,
    this.routeNote,
    this.notes,
    required this.status,
    this.nurseLic,
  });

  /// 🔹 Crear objeto vacío
  factory TsMedicationKardexResponse.createEmpty() => TsMedicationKardexResponse(
        id: 0,
        kardexId: 0,
        medicineId: 0,
        medicineName: '',
        dose: '',
        frequency: '',
        routeNote: '',
        notes: '',
        status: 0,
        nurseLic: '',
      );

  @override
  String toJson() => json.encode(toMap());

  /// 🔹 Convertir JSON → Response
  factory TsMedicationKardexResponse.fromJson(Map<String, dynamic> json) =>
      TsMedicationKardexResponse(
        id: json['id'] as int? ?? 0,
        kardexId: json['kardexId'] as int? ?? 0,
        medicineId: json['medicineId'] as int? ?? 0,
        medicineName: json['medicineName'] as String? ?? '',
        dose: json['dose'] as String? ?? '',
        frequency: json['frequency'] as String? ?? '',
        routeNote: json['routeNote'] as String? ?? '',
        notes: json['notes'] as String? ?? '',
        status: json['status'] as int? ?? 0,
        nurseLic: json['nurseLic'] as String? ?? '',
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
        "nurseLic": nurseLic,
      };

  @override
  TsMedicationKardexResponse fromJson(String jsonStr) {
    return fromMap(jsonDecode(jsonStr));
  }

  @override
  TsMedicationKardexResponse fromMap(Map<String, dynamic> json) =>
      TsMedicationKardexResponse(
        id: json['id'] as int? ?? 0,
        kardexId: json['kardexId'] as int? ?? 0,
        medicineId: json['medicineId'] as int? ?? 0,
        medicineName: json['medicineName'] as String? ?? '',
        dose: json['dose'] as String? ?? '',
        frequency: json['frequency'] as String? ?? '',
        routeNote: json['routeNote'] as String? ?? '',
        notes: json['notes'] as String? ?? '',
        status: json['status'] as int? ?? 0,
        nurseLic: json['nurseLic'] as String? ?? '',
      );
}
