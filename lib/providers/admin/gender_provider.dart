import 'package:flutter/material.dart';
import 'package:tusalud/api/request/app/ts_gender_request.dart';
import 'package:tusalud/api/tu_salud_api.dart';

import '../../api/response/app/ts_gender_response.dart';

class GenderAdminProvider  extends ChangeNotifier{
    List<TsGenderResponse> _allGenders = [];
  List<TsGenderResponse> _genders = [];
  
  bool _isLoading = false;
  bool _isAdding = false;
  bool _isUpdating = false;
  bool _isDeleting = false;
  String? _errorMessage;

  // Getters
  List<TsGenderResponse> get genders => _genders;
  bool get isLoading => _isLoading;
  bool get isAdding => _isAdding;
  bool get isUpdating => _isUpdating;
  bool get isDeleting => _isDeleting;
  String? get errorMessage => _errorMessage;

  // Búsqueda de géneros
  void searchGenders(String query) {
    if (query.isEmpty) {
      _genders = List.from(_allGenders);
    } else {
      _genders = _allGenders.where((gender) => 
        gender.genderName?.toLowerCase().contains(query.toLowerCase()) ?? false
      ).toList();
    }
    notifyListeners();
  }

  // Cargar géneros desde la API
  Future<void> loadGenders() async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      final response = await TuSaludApi().getAllGenders();
      if (response.isSuccess() && response.dataList != null) {
        _allGenders = response.dataList!;
        _genders = List.from(_allGenders);
      } else {
        _errorMessage = response.message ?? 'Error al cargar los géneros';
      }
    } catch (e) {
      _errorMessage = 'Error de conexión: ${e.toString()}';
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  // Agregar nuevo género
  Future<void> addGender(String genderName) async {
    _isAdding = true;
    _errorMessage = null;
    notifyListeners();

    try {
      final request = TsGenderRequest(genderName: genderName);
      final response = await TuSaludApi().createGender(request);
      
      if (response.isSuccess()) {
        await loadGenders();
      } else {
        _errorMessage = response.message ?? 'Error al agregar género';
      }
    } catch (e) {
      _errorMessage = 'Error al agregar: ${e.toString()}';
    } finally {
      _isAdding = false;
      notifyListeners();
    }
  }

  // Actualizar género
  Future<void> updateGender(int idGender, String genderName) async {
    _isUpdating = true;
    _errorMessage = null;
    notifyListeners();

    try {
      final request = TsGenderRequest(genderName: genderName);
      final response = await TuSaludApi().updateGender(idGender, request);

      if (response.isSuccess()) {
        await loadGenders();
      } else {
        _errorMessage = response.message ?? 'Error al actualizar género';
      }
    } catch (e) {
      _errorMessage = 'Error al actualizar: ${e.toString()}';
    } finally {
      _isUpdating = false;
      notifyListeners();
    }
  }

  // Eliminar género
  Future<void> deleteGender(int idGender) async {
    _isDeleting = true;
    _errorMessage = null;
    notifyListeners();

    try {
      final response = await TuSaludApi().deleteGender(idGender);
      
      if (response.isSuccess()) {
        await loadGenders();
      } else {
        _errorMessage = response.message ?? 'Error al eliminar género';
      }
    } catch (e) {
      _errorMessage = 'Error al eliminar: ${e.toString()}';
    } finally {
      _isDeleting = false;
      notifyListeners();
    }
  }

  // Reintentar carga
  void retryLoading() {
    _errorMessage = null;
    loadGenders();
  }

  // Limpiar datos
  void clearGenders() {
    _allGenders = [];
    _genders = [];
    notifyListeners();
  }
}