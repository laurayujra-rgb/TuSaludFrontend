class TsViaRequest {
  final String viaName;

  TsViaRequest({required this.viaName});

  Map<String, dynamic> toJson() {
    return {
      "viaName": viaName,
    };
  }

  debugPrint() {
    print("Via Name: $viaName");
  }
}
