class TsMedicationKardexRequest {
  final int kardexId;
  final int medicineId;
  final String dose;
  final String frequency;
  final String routeNote;
  final String notes;
  final String? nurseLic; // 👈 nombre corregido

  TsMedicationKardexRequest({
    required this.kardexId,
    required this.medicineId,
    required this.dose,
    required this.frequency,
    required this.routeNote,
    required this.notes,
    this.nurseLic,
  });

  Map<String, dynamic> toJson() {
    return {
      "kardex": {
        "kardexId": kardexId,
      },
      "medicine": {
        "medicineId": medicineId,
      },
      "dose": dose,
      "frequency": frequency,
      "routeNote": routeNote,
      "notes": notes,
      "nurseLic": nurseLic,
    };
  }
}
