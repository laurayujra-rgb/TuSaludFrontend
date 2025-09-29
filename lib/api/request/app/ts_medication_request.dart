class TsMedicineRequest {
  final String medicineName;
  final String medicineDateToEnd;
  final String medicineMoorning;
  final String medicineAfternoon;
  final String medicineEvening;
  final int viaId;

  TsMedicineRequest({
    required this.medicineName,
    required this.medicineDateToEnd,
    required this.medicineMoorning,
    required this.medicineAfternoon,
    required this.medicineEvening,
    required this.viaId,
  });

  Map<String, dynamic> toJson() {
    return {
      "medicineName": medicineName,
      "medicineDateToEnd": medicineDateToEnd,
      "medicineMoorning": medicineMoorning,
      "medicineAfternoon": medicineAfternoon,
      "medicineEvening": medicineEvening,
      "via": {
        "viaId": viaId,
      }
    };
  }

  debugPrint() {
    print(
        "Medicine: $medicineName, EndDate: $medicineDateToEnd, Morning: $medicineMoorning, Afternoon: $medicineAfternoon, Evening: $medicineEvening, ViaId: $viaId");
  }
}
