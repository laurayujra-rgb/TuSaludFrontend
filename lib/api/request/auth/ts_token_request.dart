import 'dart:convert';

import 'package:tusalud/api/response/ts_response.dart';

class TsTokenRequest implements TsResponseService{

  String? accessToken;
  String? refreshToken;

  TsTokenRequest({
    this.accessToken,
    this.refreshToken
  });

  factory TsTokenRequest.createEmpty() => TsTokenRequest(
    accessToken: '',
    refreshToken: ''
  );

  @override
  String toJson() => json.encode(toMap());

  factory TsTokenRequest.fromJson(Map<String, dynamic> json) => TsTokenRequest(
    accessToken: json["accessToken"]?? json["accessToken"],
    refreshToken: json["refreshToken"]?? json["refreshToken"],
  );

  @override
  Map<String, dynamic> toMap() => {
    "accessToken": accessToken,
    "refreshToken": refreshToken,
  };

  @override
  TsTokenRequest fromJson(String json){
    return fromMap(jsonDecode(json));
  }

  @override
  TsTokenRequest fromMap(Map<String, dynamic> json) => TsTokenRequest(
    accessToken: json["accessToken"]?? json["accessToken"],
    refreshToken: json["refreshToken"]?? json["refreshToken"],
  );

}