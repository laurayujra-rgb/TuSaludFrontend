class TsVitalSignsRequest {
  final String vitalSignsDate;
  final String vitalSignsHour;
  final String vitalSignsTemperature;
  final String vitalSignsHeartRate;
  final String vitalSignsRespiratoryRate;
  final String vitalSignsBloodPressure;
  final String vitalSignsOxygenSaturation;
  final int kardexId;

  TsVitalSignsRequest({
    required this.vitalSignsDate,
    required this.vitalSignsHour,
    required this.vitalSignsTemperature,
    required this.vitalSignsHeartRate,
    required this.vitalSignsRespiratoryRate,
    required this.vitalSignsBloodPressure,
    required this.vitalSignsOxygenSaturation,
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
      "kardex": {
        "kardexId": kardexId, // 👈 tal como espera tu backend
      }
    };
  }

  debugPrint() {
    print(
        'Date: $vitalSignsDate, Hour: $vitalSignsHour, Temp: $vitalSignsTemperature, HR: $vitalSignsHeartRate, RR: $vitalSignsRespiratoryRate, BP: $vitalSignsBloodPressure, O2: $vitalSignsOxygenSaturation, KardexId: $kardexId');
  }
}
