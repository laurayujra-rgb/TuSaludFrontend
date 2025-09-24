import 'dart:convert';

import 'package:tusalud/api/response/ts_response.dart';

class TsAuthRequest implements TsResponseService{
  String? personEmail;
  String? personPassword;

  TsAuthRequest({
    this.personEmail,
    this.personPassword
  });

  factory TsAuthRequest.createEmpty() => TsAuthRequest(
    personEmail: '',
    personPassword: ''
  );

  @override
  String toJson() => json.encode(toMap());

  factory TsAuthRequest.fromJson(Map<String, dynamic> json) => TsAuthRequest(
    personEmail: json["personEmail"],
    personPassword: json["personPassword"],
  );

  @override
  Map<String, dynamic> toMap() => {
    "personEmail": personEmail,
    "personPassword": personPassword,
  };

  @override
  TsAuthRequest fromJson(String json){
    return TsAuthRequest.fromJson(jsonDecode(json));
  }

  @override
  TsAuthRequest fromMap(Map<String, dynamic> json) => TsAuthRequest(
    personEmail: json["personEmail"],
    personPassword: json["personPassword"],
  );
}