class TsVitalSignsRequest {
  final String vitalSignsDate;
  final String vitalSignsHour;
  final String vitalSignsTemperature;
  final String vitalSignsHeartRate;
  final String vitalSignsRespiratoryRate;
  final String vitalSignsBloodPressure;
  final String vitalSignsOxygenSaturation;
  final String? vitalSignsNurse;
  final int kardexId;

  TsVitalSignsRequest({
    required this.vitalSignsDate,
    required this.vitalSignsHour,
    required this.vitalSignsTemperature,
    required this.vitalSignsHeartRate,
    required this.vitalSignsRespiratoryRate,
    required this.vitalSignsBloodPressure,
    required this.vitalSignsOxygenSaturation,
    this.vitalSignsNurse,
    required this.kardexId,
  });

  Map<String, dynamic> toJson() {
    return {
      "vitalSignsDate": vitalSignsDate,
      "vitalSignsHour": vitalSignsHour,
      "vitalSignsTemperature": vitalSignsTemperature,
      "vitalSignsHeartRate": vitalSignsHeartRate,
      "vitalSignsRespiratoryRate": vitalSignsRespiratoryRate,
      "vitalSignsBloodPressure": vitalSignsBloodPressure,
      "vitalSignsOxygenSaturation": vitalSignsOxygenSaturation,
      // 👇 usa el mismo nombre que el backend (con el typo)
      "nureseName": vitalSignsNurse,
      "kardex": {
        "kardexId": kardexId,
      }
    };
  }

  debugPrint() {
    print(
        'Date: $vitalSignsDate, Hour: $vitalSignsHour, Temp: $vitalSignsTemperature, HR: $vitalSignsHeartRate, RR: $vitalSignsRespiratoryRate, BP: $vitalSignsBloodPressure, O2: $vitalSignsOxygenSaturation, Nurse: $vitalSignsNurse, KardexId: $kardexId');
  }
}
