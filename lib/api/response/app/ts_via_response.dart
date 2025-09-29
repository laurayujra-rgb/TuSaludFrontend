import 'dart:convert';
import 'package:tusalud/api/response/ts_response.dart';

class TsViaResponse implements TsResponseService {
  int viaId;
  String? viaName;
  int? viaStatus;

  TsViaResponse({
    required this.viaId,
    this.viaName,
    this.viaStatus,
  });

  factory TsViaResponse.createEmpty() =>
      TsViaResponse(viaId: 0, viaName: '', viaStatus: 0);

  @override
  String toJson() => json.encode(toMap());

  factory TsViaResponse.fromJson(Map<String, dynamic> json) => TsViaResponse(
        viaId: json["viaId"] as int? ?? 0,
        viaName: json["viaName"] as String?,
        viaStatus: json["viaStatus"] as int? ?? 0,
      );

  @override
  Map<String, dynamic> toMap() => {
        "viaId": viaId,
        "viaName": viaName,
        "viaStatus": viaStatus,
      };

  @override
  TsViaResponse fromJson(String jsonStr) {
    return fromMap(jsonDecode(jsonStr));
  }

  @override
  TsViaResponse fromMap(Map<String, dynamic> json) => TsViaResponse(
        viaId: json["viaId"] as int? ?? 0,
        viaName: json["viaName"] as String?,
        viaStatus: json["viaStatus"] as int? ?? 0,
      );
}
