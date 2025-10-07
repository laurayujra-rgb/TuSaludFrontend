// lib/providers/auth/register_patient_provider.dart
import 'package:flutter/material.dart';
import 'package:tusalud/api/request/app/ts_request_create_request.dart';
import 'package:tusalud/api/response/app/ts_people_response.dart';
import 'package:tusalud/api/response/ts_response.dart';
import 'package:tusalud/api/tu_salud_api.dart';

class RegisterPatientProvider extends ChangeNotifier {
  bool _isLoading = false;
  String? _errorMessage;
  TsPeopleResponse? _createdPatient;

  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;
  TsPeopleResponse? get createdPatient => _createdPatient;

  Future<TsResponse<TsPeopleResponse>> registerPatient(
    TsPatientCreateRequest req,
  ) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      final resp = await TuSaludApi().createPatient(req);

      if (resp.isSuccess() && resp.data != null) {
        _createdPatient = resp.data;
      } else {
        _errorMessage = resp.message ?? 'Error al registrar paciente';
      }
      return resp;
    } catch (e) {
      _errorMessage = 'Error de conexión: ${e.toString()}';
      return TsResponse<TsPeopleResponse>(
        status: 500,
        message: _errorMessage!,
        error: e.toString(),
      );
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  void clear() {
    _createdPatient = null;
    _errorMessage = null;
    _isLoading = false;
    notifyListeners();
  }
}
