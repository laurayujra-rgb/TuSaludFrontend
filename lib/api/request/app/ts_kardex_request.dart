class TsKardexRequest {
  final int kardexNumber;
  final String kardexDiagnosis;
  final String kardexDate;
  final String kardexHour;
  final String nursingActions;
  final int patientId;
  final int dietId;
  final String? nurseLic; // 👈 nombre corregido


  TsKardexRequest({
    required this.kardexNumber,
    required this.kardexDiagnosis,
    required this.kardexDate,
    required this.kardexHour,
    required this.nursingActions,
    required this.patientId,
    required this.dietId,
    this.nurseLic,
  });

  Map<String, dynamic> toJson() {
    return {
      "kardexNumber": kardexNumber,
      "kardexDiagnosis": kardexDiagnosis,
      "kardexDate": kardexDate,
      "kardexHour": kardexHour,
      "nursingActions": nursingActions,
      "patient": {
        "personId": patientId,
      },
      "diets": {
        "dietId": dietId,
      },
      "nurseLic": nurseLic,
    };
  }
}
