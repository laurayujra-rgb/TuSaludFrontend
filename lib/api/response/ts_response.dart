import 'dart:convert';
import 'dart:io';

abstract class TsResponseService{
  String toJson();
  Map<String, dynamic> toMap();
  dynamic fromJson(String json);
  dynamic fromMap(Map<String, dynamic> map);
}
class TsResponse<T extends TsResponseService>{
  static const String errorDefault = 'Ha ocurrido un error, intente nuevamente';
  final int successCode = 200;
  final int undefinedErrorCode = -1;

  T? data;
  String? error;
  List<T>? dataList;
  String? message;
  int? status;

  TsResponse({
    this.data,
    this.error,
    this.dataList,
    this.message,
    this.status
  });

  TsResponse.createEmpty(){
    data;
    dataList;
    error;
    message = errorDefault;
    status = undefinedErrorCode;
  }
  factory TsResponse.fromJson(String str)  => TsResponse.fromMap(jsonDecode(str));
  factory TsResponse.fromJsonT(String str, T data) => TsResponse.fromMapT(jsonDecode(str), data);
  factory TsResponse.fromJsonList(String str, T data) => TsResponse.fromMapList(jsonDecode(str), data);
  String toJson() => json.encode(toMap());
  
  factory TsResponse.fromMap(Map<String, dynamic> json) => TsResponse(
    data: null,
    error: json["error"],
    message: json["message"],
    status: json["status"],
  );

  factory TsResponse.fromMapT(Map<String, dynamic> json, T data) => TsResponse(
    data: json.containsKey("data")? (json["data"]!= null ? data.fromMap(json["data"]) : null) : null,
    error: json["error"],
    message: json["message"],
    status: json["status"],
  );

  factory TsResponse.fromMapList(Map<String, dynamic> json, T dataTempalte) => TsResponse(
    dataList: json.containsKey("data") && json["data"] != null
        ?(json["data"] as List).map((item) => dataTempalte.fromMap(item) as T).toList( )
        : null,
    error: json["error"],
    message: json["message"],
    status: json["status"],
  );

  Map<String, dynamic> toMap() => {
    'data': data?.toMap(),
    'dataList': dataList?.map((item) => item.toMap()).toList(),
    "error": error,
    "message": message,
    "status": status,
  };

  static T? tryCast<T>(dynamic value){
    try{
      return (value as T);
    } on TypeError catch(_){
      return null;
    }
  }

  bool isSuccess(){
    return status == HttpStatus.ok;
  }

  bool isCreated(){
    return status ==  HttpStatus.created;
  }

    bool isBadRequest() {
    return status == HttpStatus.badRequest;
  }

  bool isNotFound() {
    return status == HttpStatus.notFound;
  }

  bool isUnauthorized() {
    return status == HttpStatus.unauthorized;
  }
}