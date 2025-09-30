import 'dart:convert';
import 'package:tusalud/api/response/ts_response.dart';

class TsReportsResponse implements TsResponseService {
  int reportId;
  int reportStatus;
  String? reportDetails;
  int kardexId;

  TsReportsResponse({
    required this.reportId,
    required this.reportStatus,
    this.reportDetails,
    required this.kardexId,
  });

  factory TsReportsResponse.createEmpty() => TsReportsResponse(
        reportId: 0,
        reportStatus: 0,
        reportDetails: '',
        kardexId: 0,
      );

  @override
  String toJson() => json.encode(toMap());

  factory TsReportsResponse.fromJson(Map<String, dynamic> json) =>
      TsReportsResponse(
        reportId: json["reportId"] as int? ?? 0,
        reportStatus: json["reportStatus"] as int? ?? 0,
        reportDetails: json["reportDetails"] as String?,
        kardexId: json["kardexId"] as int? ?? 0,
      );

  @override
  Map<String, dynamic> toMap() => {
        "reportId": reportId,
        "reportStatus": reportStatus,
        "reportDetails": reportDetails,
        "kardexId": kardexId,
      };

  @override
  TsReportsResponse fromJson(String jsonStr) {
    return fromMap(jsonDecode(jsonStr));
  }

  @override
  TsReportsResponse fromMap(Map<String, dynamic> json) =>
      TsReportsResponse.fromJson(json);
}
