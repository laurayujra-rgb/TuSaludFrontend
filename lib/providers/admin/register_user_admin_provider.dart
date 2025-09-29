import 'package:flutter/foundation.dart';
import 'package:tusalud/api/request/auth/ts_register_user_admin_request.dart';
import 'package:tusalud/api/response/app/ts_register_user_admin_response.dart';
import 'package:tusalud/api/response/ts_response.dart';
import 'package:tusalud/api/tu_salud_api.dart';

class RegisterUserAdminProvider extends ChangeNotifier {
  bool _isLoading = false;
  String? _errorMessage;
  TsRegisterUserAdminResponse? _registeredUser;

  // Getters
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;
  TsRegisterUserAdminResponse? get registeredUser => _registeredUser;

  /// 🔹 Registrar un nuevo usuario (person + account)
  Future<TsResponse<TsRegisterUserAdminResponse>> registerUser(
      TsRegisterUserAdminRequest request) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      final response = await TuSaludApi().registerAdminUser(request);

      if (response.isSuccess() && response.data != null) {
        _registeredUser = response.data;
        _isLoading = false;
        notifyListeners();
        return response;
      } else {
        _errorMessage = response.message ?? "Error al registrar usuario";
        _isLoading = false;
        notifyListeners();
        return response;
      }
    } catch (e) {
      _errorMessage = "Error inesperado: ${e.toString()}";
      _isLoading = false;
      notifyListeners();

      return TsResponse<TsRegisterUserAdminResponse>(
        status: 500,
        message: _errorMessage!,
        error: e.toString(),
      );
    }
  }

  /// 🔹 Limpiar datos previos
  void clear() {
    _registeredUser = null;
    _errorMessage = null;
    _isLoading = false;
    notifyListeners();
  }
}
