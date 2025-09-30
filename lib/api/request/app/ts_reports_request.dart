class TsReportsRequest {
  final String reportDetails;
  final int kardexId;

  TsReportsRequest({
    required this.reportDetails,
    required this.kardexId,
  });

  Map<String, dynamic> toJson() {
    return {
      "reportDetails": reportDetails,
      "kardex": {
        "kardexId": kardexId, // 👈 tal como espera tu backend
      }
    };
  }

  void debugPrint() {
    print(
        'ReportDetails: $reportDetails, KardexId: $kardexId');
  }
}
