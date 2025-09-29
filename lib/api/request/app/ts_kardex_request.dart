class TsKardexRequest {
  final int kardexNumber;
  final String kardexDiagnosis;
  final String kardexDate;
  final String kardexHour;
  final int dietId;
  final String nursingActions;

  TsKardexRequest({
    required this.kardexNumber,
    required this.kardexDiagnosis,
    required this.kardexDate,
    required this.kardexHour,
    required this.dietId,
    required this.nursingActions,
  });

  Map<String, dynamic> toJson() {
    return {
      "kardexNumber": kardexNumber,
      "kardexDiagnosis": kardexDiagnosis,
      "kardexDate": kardexDate,
      "kardexHour": kardexHour,
      "diets": {
        "dietId": dietId, // 👈 así como espera tu backend
      },
      "nursingActions": nursingActions,
    };
  }

  debugPrint() {
    print(
        'KardexNumber: $kardexNumber, Diagnosis: $kardexDiagnosis, Date: $kardexDate, Hour: $kardexHour, DietId: $dietId, NursingActions: $nursingActions');
  }
}
