import 'package:flutter/material.dart';
import 'package:tusalud/api/request/auth/sign_up_request.dart';
import 'package:tusalud/api/tu_salud_api.dart';

class RegisterUserProvider extends ChangeNotifier {
  bool _isLoading = false;
  String? _errorMessage = '';
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;

  Future<void> registerUser(
    String personName,
    String personFatherSurname,
    String personMotherSurname,
    String personDni,
    String personBirthdate,
    int personAge,
    int genderId,
    int roleId,
  ) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      // Crear request
      final request = TsPersonRequest(
        personName: personName,
        personFatherSurname: personFatherSurname,
        personMotherSurname: personMotherSurname,
        personDni: personDni,
        personBirthdate: personBirthdate,
        personAge: personAge,
        genderId: genderId,
        roleId: roleId,
      );

      // Llamar al API
      final response = await TuSaludApi().registerUser(request);

      debugPrint('API Response: ${response.status} - ${response.message}');

      if (response.isSuccess()) {
        // Registro exitoso
        debugPrint('Registro exitoso: ${response.data}');
      } else {
        // Manejar error de backend
        _errorMessage = response.message ?? 'Error al registrar el usuario';
      }
    } catch (e, stackTrace) {
      debugPrint('Error en registerUser: $e');
      debugPrint('Stack trace: $stackTrace');
      _errorMessage = 'Error de conexión: ${e.toString()}';
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}
