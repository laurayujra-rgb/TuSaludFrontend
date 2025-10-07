// patients_nursing_lic_provider.dart
import 'package:flutter/material.dart';
import 'package:tusalud/api/response/app/ts_people_response.dart';
import 'package:tusalud/api/tu_salud_api.dart';

class PatientsNursingLicProvider extends ChangeNotifier {
  List<TsPeopleResponse> _allPatients = [];
  List<TsPeopleResponse> _patients = [];

  bool _isLoading = false;
  String? _errorMessage;

  int? _selectedRoomId; // 👈 sala seleccionada (null = todas)

  // Getters
  List<TsPeopleResponse> get patients => _patients;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;
  int? get selectedRoomId => _selectedRoomId;

  /// Buscar por nombre/apellidos
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

  /// Cargar TODOS los pacientes (rol = 4)
  Future<void> loadPatients() async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      final response = await TuSaludApi().getAllPatientsByRole(); // ya filtra role=4
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

  /// Cargar pacientes por sala
  Future<void> loadPatientsByRoom(int roomId) async {
    _isLoading = true;
    _errorMessage = null;
    _selectedRoomId = roomId;
    notifyListeners();

    try {
      final response = await TuSaludApi().getPatientsByRoom(roomId);
      if (response.isSuccess() && response.dataList != null) {
        _allPatients = response.dataList!;
        _patients = List.from(_allPatients);
      } else {
        _errorMessage = response.message ?? 'No se pudo cargar pacientes por sala';
        _allPatients = [];
        _patients = [];
      }
    } catch (e) {
      _errorMessage = 'Error de conexión: ${e.toString()}';
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  /// Cambiar sala (null = todas)
  Future<void> setSelectedRoomId(int? roomId) async {
    _selectedRoomId = roomId;
    if (roomId == null) {
      await loadPatients();
    } else {
      await loadPatientsByRoom(roomId);
    }
  }

  void retryLoading() {
    _errorMessage = null;
    if (_selectedRoomId == null) {
      loadPatients();
    } else {
      loadPatientsByRoom(_selectedRoomId!);
    }
  }

  void clearPatients() {
    _allPatients = [];
    _patients = [];
    notifyListeners();
  }
}
