class VitalSignsRanges {
  final int minHr, maxHr;        // Ritmo cardíaco (lpm)
  final int minBpSys, maxBpSys;  // Presión sistólica (mmHg)
  final int minResp, maxResp;    // Frecuencia respiratoria (rpm)
  final int minSpo2, maxSpo2;    // Saturación de oxígeno (%)
  final double minTemp, maxTemp; // Temperatura corporal (°C)

  VitalSignsRanges({
    required this.minHr,
    required this.maxHr,
    required this.minBpSys,
    required this.maxBpSys,
    required this.minResp,
    required this.maxResp,
    required this.minSpo2,
    required this.maxSpo2,
    required this.minTemp,
    required this.maxTemp,
  });

  static VitalSignsRanges fromAge(int years) {
    // 🔹 La temperatura normal es prácticamente igual en todas las edades
    const minTemp = 35.0;
    const maxTemp = 37.5;

    if (years <= 0) {
      return VitalSignsRanges(
        minHr: 90,
        maxHr: 160,
        minBpSys: 65,
        maxBpSys: 100,
        minResp: 25,
        maxResp: 60,
        minSpo2: 94,
        maxSpo2: 100,
        minTemp: minTemp,
        maxTemp: maxTemp,
      );
    } else if (years < 3) {
      return VitalSignsRanges(
        minHr: 80,
        maxHr: 125,
        minBpSys: 90,
        maxBpSys: 105,
        minResp: 20,
        maxResp: 30,
        minSpo2: 94,
        maxSpo2: 100,
        minTemp: minTemp,
        maxTemp: maxTemp,
      );
    } else if (years < 6) {
      return VitalSignsRanges(
        minHr: 70,
        maxHr: 115,
        minBpSys: 95,
        maxBpSys: 110,
        minResp: 20,
        maxResp: 25,
        minSpo2: 94,
        maxSpo2: 100,
        minTemp: minTemp,
        maxTemp: maxTemp,
      );
    } else if (years < 12) {
      return VitalSignsRanges(
        minHr: 60,
        maxHr: 100,
        minBpSys: 100,
        maxBpSys: 120,
        minResp: 14,
        maxResp: 22,
        minSpo2: 94,
        maxSpo2: 100,
        minTemp: minTemp,
        maxTemp: maxTemp,
      );
    } else {
      return VitalSignsRanges(
        minHr: 60,
        maxHr: 100,
        minBpSys: 100,
        maxBpSys: 120,
        minResp: 12,
        maxResp: 18,
        minSpo2: 95,
        maxSpo2: 100,
        minTemp: minTemp,
        maxTemp: maxTemp,
      );
    }
  }
}
