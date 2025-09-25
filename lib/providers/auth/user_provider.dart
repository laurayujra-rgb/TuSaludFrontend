import 'package:flutter/material.dart';

class UserProvider extends ChangeNotifier {
  String? _name;
  String? _lastName;
  String? _role;
  String? _email;
  int? _personId;  // Cambiado a int?
  String? get name => _name;
  String? get lastName => _lastName;
  String? get role => _role;
  String? get email => _email;
  int? get personId => _personId;


  void setUserData(String name, String lastName, String role, String email, int personId) {
    _name = name;
    _lastName = lastName;
    _role = role;
    _email = email;
    _personId = personId;
 
    notifyListeners();
  }
}