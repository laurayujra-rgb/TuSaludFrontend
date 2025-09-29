class TsKardexMedicineRequest {
  final int kardexId;
  final int medicineId;
  final String dose;
  final String frequency;
  final String routeNote;
  final String notes;

  TsKardexMedicineRequest({
    required this.kardexId,
    required this.medicineId,
    required this.dose,
    required this.frequency,
    required this.routeNote,
    required this.notes,
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
    };
  }

  void debugPrint() {
    print(
        "KardexId: $kardexId, MedicineId: $medicineId, Dose: $dose, Freq: $frequency, Route: $routeNote, Notes: $notes");
  }
}
