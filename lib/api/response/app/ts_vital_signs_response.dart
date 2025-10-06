import 'dart:convert';
import 'package:tusalud/api/response/ts_response.dart';

class TsVitalSignsResponse implements TsResponseService {
  int vitalSignsId;
  String? vitalSignsDate;
  String? vitalSignsHour;
  String? vitalSignsTemperature;
  String? vitalSignsHeartRate;
  String? vitalSignsRespiratoryRate;
  String? vitalSignsBloodPressure;
  String? vitalSignsOxygenSaturation;
  String? vitalSignsNurse; // 👈 nombre corregido
  int vitalSignsStatus;
  int kardexId;

  TsVitalSignsResponse({
    required this.vitalSignsId,
    this.vitalSignsDate,
    this.vitalSignsHour,
    this.vitalSignsTemperature,
    this.vitalSignsHeartRate,
    this.vitalSignsRespiratoryRate,
    this.vitalSignsBloodPressure,
    this.vitalSignsOxygenSaturation,
    this.vitalSignsNurse,
    required this.vitalSignsStatus,
    required this.kardexId,
  });

  factory TsVitalSignsResponse.createEmpty() => TsVitalSignsResponse(
        vitalSignsId: 0,
        vitalSignsDate: '',
        vitalSignsHour: '',
        vitalSignsTemperature: '',
        vitalSignsHeartRate: '',
        vitalSignsRespiratoryRate: '',
        vitalSignsBloodPressure: '',
        vitalSignsOxygenSaturation: '',
        vitalSignsNurse: '',
        vitalSignsStatus: 0,
        kardexId: 0,
      );

  factory TsVitalSignsResponse.fromJson(Map<String, dynamic> json) {
    return TsVitalSignsResponse(
      vitalSignsId: json["vitalSignsId"] ?? 0,
      vitalSignsDate: json["vitalSignsDate"],
      vitalSignsHour: json["vitalSignsHour"],
      vitalSignsTemperature: json["vitalSignsTemperature"],
      vitalSignsHeartRate: json["vitalSignsHeartRate"],
      vitalSignsRespiratoryRate: json["vitalSignsRespiratoryRate"],
      vitalSignsBloodPressure: json["vitalSignsBloodPressure"],
      vitalSignsOxygenSaturation: json["vitalSignsOxygenSaturation"],
      // 👇 aquí aceptamos ambos nombres, el correcto y el del backend con typo
      vitalSignsNurse:
          json["vitalSignsNurse"] ?? json["nureseName"] ?? json["nurseName"],
      vitalSignsStatus: json["vitalSignsStatus"] ?? 0,
      kardexId: json["kardexId"] ?? 0,
    );
  }

  @override
  Map<String, dynamic> toMap() => {
        "vitalSignsId": vitalSignsId,
        "vitalSignsDate": vitalSignsDate,
        "vitalSignsHour": vitalSignsHour,
        "vitalSignsTemperature": vitalSignsTemperature,
        "vitalSignsHeartRate": vitalSignsHeartRate,
        "vitalSignsRespiratoryRate": vitalSignsRespiratoryRate,
        "vitalSignsBloodPressure": vitalSignsBloodPressure,
        "vitalSignsOxygenSaturation": vitalSignsOxygenSaturation,
        "vitalSignsNurse": vitalSignsNurse,
        "vitalSignsStatus": vitalSignsStatus,
        "kardexId": kardexId,
      };

  @override
  String toJson() => json.encode(toMap());

  @override
  TsVitalSignsResponse fromJson(String jsonStr) =>
      fromMap(jsonDecode(jsonStr));

  @override
  TsVitalSignsResponse fromMap(Map<String, dynamic> json) =>
      TsVitalSignsResponse.fromJson(json);
}
