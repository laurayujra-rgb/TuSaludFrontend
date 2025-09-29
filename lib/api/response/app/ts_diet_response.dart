import 'dart:convert';
import 'package:tusalud/api/response/ts_response.dart';

class TsDietResponse implements TsResponseService {
  int dietId;
  String? dietName;
  int? dietStatus;

  TsDietResponse({
    required this.dietId,
    this.dietName,
    this.dietStatus,
  });

  factory TsDietResponse.createEmpty() =>
      TsDietResponse(dietId: 0, dietName: '', dietStatus: 0);

  @override
  String toJson() => json.encode(toMap());

  factory TsDietResponse.fromJson(Map<String, dynamic> json) => TsDietResponse(
        dietId: json["dietId"] as int? ?? 0,
        dietName: json["dietName"] as String?,
        dietStatus: json["dietStatus"] as int? ?? 0,
      );

  @override
  Map<String, dynamic> toMap() => {
        "dietId": dietId,
        "dietName": dietName,
        "dietStatus": dietStatus,
      };

  @override
  TsDietResponse fromJson(String jsonStr) {
    return fromMap(jsonDecode(jsonStr));
  }

  @override
  TsDietResponse fromMap(Map<String, dynamic> json) => TsDietResponse(
        dietId: json["dietId"] as int? ?? 0,
        dietName: json["dietName"] as String?,
        dietStatus: json["dietStatus"] as int? ?? 0,
      );
}
