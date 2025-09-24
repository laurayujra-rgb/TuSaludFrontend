import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class Preferences {
  final FlutterSecureStorage _storage = const FlutterSecureStorage();
  
  final keyAccessToken = 'accessToken';
  final keyEmail = 'email';
  final keyLastName = 'lastName';
  final keyName = 'name';
  final keyRefreshToken = 'refreshToken';
  final keyRole = 'role';
  final keyPersonId = 'personId';
  

  Future<String> accessToken() async{
    String value = await _storage.read(key: keyAccessToken) ?? '';
    return value;
  }
  Future<String> refreshToken() async{
    String value = await _storage.read(key: keyRefreshToken) ?? '';
    return value;
  }
  
}