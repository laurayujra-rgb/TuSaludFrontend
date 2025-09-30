import 'dart:convert';
import 'package:tusalud/api/response/ts_response.dart';
import 'package:tusalud/api/response/app/ts_kardex_response.dart';

class TsVitalSignsResponse implements TsResponseService {
  int vitalSignsId;
  String? vitalSignsDate;
  String? vitalSignsHour;
  String? vitalSignsTemperature;
  String? vitalSignsHeartRate;
  String? vitalSignsRespiratoryRate;
  String? vitalSignsBloodPressure;
  String? vitalSignsOxygenSaturation;
  int vitalSignsStatus;
  TsKardexResponse kardex;

  TsVitalSignsResponse({
    required this.vitalSignsId,
    this.vitalSignsDate,
    this.vitalSignsHour,
    this.vitalSignsTemperature,
    this.vitalSignsHeartRate,
    this.vitalSignsRespiratoryRate,
    this.vitalSignsBloodPressure,
    this.vitalSignsOxygenSaturation,
    required this.vitalSignsStatus,
    required this.kardex,
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
        vitalSignsStatus: 0,
        kardex: TsKardexResponse.createEmpty(),
      );

  @override
  String toJson() => json.encode(toMap());

  factory TsVitalSignsResponse.fromJson(Map<String, dynamic> json) =>
      TsVitalSignsResponse(
        vitalSignsId: json["vitalSignsId"] as int? ?? 0,
        vitalSignsDate: json["vitalSignsDate"] as String?,
        vitalSignsHour: json["vitalSignsHour"] as String?,
        vitalSignsTemperature: json["vitalSignsTemperature"] as String?,
        vitalSignsHeartRate: json["vitalSignsHeartRate"] as String?,
        vitalSignsRespiratoryRate: json["vitalSignsRespiratoryRate"] as String?,
        vitalSignsBloodPressure: json["vitalSignsBloodPressure"] as String?,
        vitalSignsOxygenSaturation: json["vitalSignsOxygenSaturation"] as String?,
        vitalSignsStatus: json["vitalSignsStatus"] as int? ?? 0,
        kardex: json["kardex"] != null
            ? TsKardexResponse.fromJson(
                json["kardex"] as Map<String, dynamic>)
            : TsKardexResponse.createEmpty(),
      );

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
        "vitalSignsStatus": vitalSignsStatus,
        "kardex": kardex.toMap(),
      };

  @override
  TsVitalSignsResponse fromJson(String jsonStr) {
    return fromMap(jsonDecode(jsonStr));
  }

  @override
  TsVitalSignsResponse fromMap(Map<String, dynamic> json) =>
      TsVitalSignsResponse.fromJson(json);
}
