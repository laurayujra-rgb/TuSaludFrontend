import 'package:flutter/material.dart';
import 'package:tusalud/api/response/app/ts_people_response.dart';
import 'package:tusalud/api/tu_salud_api.dart';

class PatientsNurseProvider extends ChangeNotifier {
  List<TsPeopleResponse> _allPatients = [];
  List<TsPeopleResponse> _patients = [];

  bool _isLoading = false;
  String? _errorMessage;

  // Getters
  List<TsPeopleResponse> get patients => _patients;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;

  /// 🔹 Buscar pacientes por nombre o apellido
  void searchPatients(String query) {
    if (query.isEmpty) {
      _patients = List.from(_allPatients);
    } else {
      _patients = _allPatients.where((p) {
        final fullName =
            "${p.personName ?? ''} ${p.personFahterSurname ?? ''} ${p.personMotherSurname ?? ''}";
        return fullName.toLowerCase().contains(query.toLowerCase());
      }).toList();
    }
    notifyListeners();
  }

  /// 🔹 Cargar pacientes desde la API
  Future<void> loadPatients() async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      final response = await TuSaludApi().getAllPatients();
      if (response.isSuccess() && response.dataList != null) {
        _allPatients = response.dataList!;
        _patients = List.from(_allPatients);
      } else {
        _errorMessage = response.message ?? 'Error al cargar pacientes';
      }
    } catch (e) {
      _errorMessage = 'Error de conexión: ${e.toString()}';
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  /// 🔹 Reintentar carga
  void retryLoading() {
    _errorMessage = null;
    loadPatients();
  }

  /// 🔹 Limpiar datos
  void clearPatients() {
    _allPatients = [];
    _patients = [];
    notifyListeners();
  }
}
