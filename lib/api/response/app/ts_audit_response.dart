class TsAuditResponse {
  String? createBy;
  DateTime createDate;
  String? updateBy;
  DateTime? updateDate;
  String? deleteBy;
  DateTime? deleteDate;
  String? ipAddress;
  String? action;
  dynamic previousValue;
  dynamic currentValue;
  int? recordVersion;

  TsAuditResponse({
    this.createBy,
    required this.createDate,
    this.updateBy,
    this.updateDate,
    this.deleteBy,
    this.deleteDate,
    this.ipAddress,
    this.action,
    this.previousValue,
    this.currentValue,
    this.recordVersion,
  });

  factory TsAuditResponse.createEmpty() => TsAuditResponse(
    createBy: '',
    createDate: DateTime.now(),
    updateBy: '',
    updateDate: null,
    deleteBy: '',
    deleteDate: null,
    ipAddress: '',
    action: '',
    previousValue: '',
    currentValue: '',
    recordVersion: 0,
  );

  factory TsAuditResponse.fromJson(Map<String, dynamic> json) => TsAuditResponse(
    createBy: json["createBy"],
    createDate: DateTime.parse(json["createDate"]),
    updateBy: json["updateBy"],
    updateDate: json["updateDate"] != null? DateTime.parse(json["updateDate"]): null,
    deleteBy: json["deleteBy"],
    deleteDate:  json["deleteDate"] != null? DateTime.parse(json["deleteDate"]): null,
    ipAddress: json["ipAddress"],
    action: json["action"],
    previousValue: json["previousValue"],
    currentValue: json["currentValue"],
    recordVersion: json["recordVersion"],
  );

  Map<String, dynamic> toJson() => {
    "createBy": createBy,
    "createDate": createDate.toIso8601String(),
    "updateBy": updateBy,
    "updateDate": updateDate,
    "deleteBy": deleteBy,
    "deleteDate": deleteDate,
    "ipAddress": ipAddress,
    "action": action,
    "previousValue": previousValue,
    "currentValue": currentValue,
    "recordVersion": recordVersion,
  };
}