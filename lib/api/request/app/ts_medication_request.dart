class TsMedicineRequest {
  final String medicineName;
  final String medicineLaboratory;
  final int viaId;

  TsMedicineRequest({
    required this.medicineName,
    required this.medicineLaboratory,

    required this.viaId,
  });

  Map<String, dynamic> toJson() {
    return {
      "medicineName": medicineName,
      "medicineLaboratory": medicineLaboratory,

      "via": {
        "viaId": viaId,
      }
    };
  }

  debugPrint() {
    print(
        "Medicine: $medicineName, Laboratory: $medicineLaboratory, ViaId: $viaId");
  }
}
