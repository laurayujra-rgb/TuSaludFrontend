import 'package:flutter/material.dart';
import 'package:tusalud/api/request/app/ts_diet_request.dart';
import 'package:tusalud/api/response/app/ts_diet_response.dart';
import 'package:tusalud/api/tu_salud_api.dart';

class DietAdminProvider extends ChangeNotifier {
  List<TsDietResponse> _allDiets = [];
  List<TsDietResponse> _diets = [];

  bool _isLoading = false;
  String? _errorMessage;

  // 👉 Getters
  List<TsDietResponse> get diets => _diets;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;

  /// 🔹 Buscar dietas por nombre
  void searchDiets(String query) {
    if (query.isEmpty) {
      _diets = List.from(_allDiets);
    } else {
      _diets = _allDiets.where((d) {
        final name = d.dietName ?? '';
        return name.toLowerCase().contains(query.toLowerCase());
      }).toList();
    }
    notifyListeners();
  }

  /// 🔹 Cargar todas las dietas desde la API
  Future<void> loadDiets() async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      final response = await TuSaludApi().getAllDiets();
      if (response.isSuccess() && response.dataList != null) {
        // ✅ Filtramos solo las dietas activas (status == 1)
        _allDiets =
            response.dataList!.where((d) => d.dietStatus == 1).toList();
        _diets = List.from(_allDiets);
      } else {
        _errorMessage = response.message ?? 'Error al cargar las dietas';
      }
    } catch (e) {
      _errorMessage = 'Error de conexión: ${e.toString()}';
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  /// 🔹 Actualizar dieta
  Future<void> updateDiet(int dietId, String newName) async {
    _errorMessage = null;
    notifyListeners();

    try {
      final response = await TuSaludApi()
          .updateDiet(dietId, TsDietRequest(dietName: newName));

      if (response.isSuccess()) {
        await loadDiets();
      } else {
        _errorMessage = response.message ?? 'Error al actualizar la dieta';
      }
    } catch (e) {
      _errorMessage = 'Error: ${e.toString()}';
    } finally {
      notifyListeners();
    }
  }

  /// 🔹 Eliminar dieta
  Future<void> deleteDiet(int dietId) async {
    _errorMessage = null;
    notifyListeners();

    try {
      final response = await TuSaludApi().deleteDiet(dietId);
      if (response.isSuccess()) {
        await loadDiets(); // recargamos lista después de eliminar
      } else {
        _errorMessage = response.message ?? 'Error al eliminar la dieta';
      }
    } catch (e) {
      _errorMessage = 'Error: ${e.toString()}';
    } finally {
      notifyListeners();
    }
  }

  /// 🔹 Reintentar carga
  void retryLoading() {
    _errorMessage = null;
    loadDiets();
  }

  /// 🔹 Limpiar datos
  void clearDiets() {
    _allDiets = [];
    _diets = [];
    notifyListeners();
  }
}
