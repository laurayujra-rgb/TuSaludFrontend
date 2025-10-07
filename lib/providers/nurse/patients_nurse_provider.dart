import 'package:flutter/material.dart';
import 'package:tusalud/api/response/app/ts_people_response.dart';
import 'package:tusalud/api/tu_salud_api.dart';

class PatientsNurseProvider extends ChangeNotifier {
  List<TsPeopleResponse> _allPatients = [];
  List<TsPeopleResponse> _patients = [];

  bool _isLoading = false;
  String? _errorMessage;

  // 🔹 Nuevo: filtro por sala
  int? _selectedRoomId;

  // Getters
  List<TsPeopleResponse> get patients => _patients;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;
  int? get selectedRoomId => _selectedRoomId;

  /// 🔹 Buscar pacientes por nombre o apellido (se combina con filtro de sala)
  void searchPatients(String query) {
    _applyFilters(query: query);
  }

  /// 🔹 Setear sala seleccionada (null = todas)
  void setSelectedRoomId(int? roomId) {
    _selectedRoomId = roomId;
    _applyFilters();
    notifyListeners();
  }

  void _applyFilters({String? query}) {
    List<TsPeopleResponse> base = List.from(_allPatients);

    // Filtro por sala (miramos room directo o room dentro de bed)
    if (_selectedRoomId != null) {
      base = base.where((p) {
        final int? roomId = p.room?.roomId ?? p.bed?.room.roomId;
        return roomId == _selectedRoomId;
      }).toList();
    }

    // Filtro por texto
    if (query != null && query.isNotEmpty) {
      base = base.where((p) {
        final fullName =
            "${p.personName ?? ''} ${p.personFahterSurname ?? ''} ${p.personMotherSurname ?? ''}";
        return fullName.toLowerCase().contains(query.toLowerCase());
      }).toList();
    }

    _patients = base;
    notifyListeners();
  }

  /// 🔹 Cargar pacientes desde la API
  Future<void> loadPatients() async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      final response = await TuSaludApi().getAllPatientsByRole(); // solo role=4
      if (response.isSuccess() && response.dataList != null) {
        _allPatients = response.dataList!;
        _applyFilters(); // 👈 aplica filtros actuales (sala/búsqueda)
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
    _selectedRoomId = null;
    notifyListeners();
  }
}
