class TsKardexRequest {
  final int kardexNumber;
  final String kardexDiagnosis;
  final String kardexDate;
  final String kardexHour;
  final String nursingActions;
  final int patientId;
  final int nurseId;
  final int dietId;

  TsKardexRequest({
    required this.kardexNumber,
    required this.kardexDiagnosis,
    required this.kardexDate,
    required this.kardexHour,
    required this.nursingActions,
    required this.patientId,
    required this.nurseId,
    required this.dietId,
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
      "nurse": {
        "personId": nurseId,
      },
      "diets": {
        "dietId": dietId,
      },
    };
  }
}
