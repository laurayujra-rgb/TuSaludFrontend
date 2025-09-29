
import 'package:flutter/material.dart';
import 'package:tusalud/api/response/app/ts_people_response.dart';
import 'package:tusalud/api/tu_salud_api.dart';

class PeopleAdminProvider extends ChangeNotifier {
  List<TsPeopleResponse> _allPeople = [];
  List<TsPeopleResponse> _people = [];

  bool _isLoading = false;
  String? _errorMessage;

  // Getters
  List<TsPeopleResponse> get people => _people;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;

  /// 🔹 Buscar personas por nombre o apellido
  void searchPeople(String query) {
    if (query.isEmpty) {
      _people = List.from(_allPeople);
    } else {
      _people = _allPeople.where((p) {
        final fullName = "${p.personName ?? ''} ${p.personFahterSurname ?? ''} ${p.personMotherSurname ?? ''}";
        return fullName.toLowerCase().contains(query.toLowerCase());
      }).toList();
    }
    notifyListeners();
  }

  /// 🔹 Cargar personas desde la API filtradas por roleId
  Future<void> loadPeopleByRole(int roleId) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      final response = await TuSaludApi().getPeopleByRole(roleId);
      if (response.isSuccess() && response.dataList != null) {
        _allPeople = response.dataList!;
        _people = List.from(_allPeople);
      } else {
        _errorMessage = response.message ?? 'Error al cargar personas';
      }
    } catch (e) {
      _errorMessage = 'Error de conexión: ${e.toString()}';
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  /// 🔹 Reintentar carga
  void retryLoading(int roleId) {
    _errorMessage = null;
    loadPeopleByRole(roleId);
  }

  /// 🔹 Limpiar datos
  void clearPeople() {
    _allPeople = [];
    _people = [];
    notifyListeners();
  }
}
