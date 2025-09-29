class TsDietRequest {
  final String dietName;

  TsDietRequest({required this.dietName});

  Map<String, dynamic> toJson() {
    return {
      "dietName": dietName,
    };
  }

  debugPrint() {
    print("Diet Name: $dietName");
  }
}
