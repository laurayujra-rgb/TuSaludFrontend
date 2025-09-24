class TsGenderRequest {
  final String genderName;

  TsGenderRequest({
    required this.genderName,
  });
  Map<String, dynamic> toJson() {
    return{
      'genderName': genderName,
    };
  }
  debugPrint(){
    print('Gender Name: $genderName');
  }
}