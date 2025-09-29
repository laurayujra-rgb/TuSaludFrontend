import 'package:flutter/material.dart';
import 'package:tusalud/api/response/app/ts_medication_response.dart';
import 'package:tusalud/api/tu_salud_api.dart';

class MedicineNurseProvider extends ChangeNotifier {
  List<TsMedicineResponse> _allMedicines = [];
  List<TsMedicineResponse> _medicines = [];

  bool _isLoading = false;
  String? _errorMessage;

  // 👉 Getters
  List<TsMedicineResponse> get medicines => _medicines;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;

  /// 🔹 Buscar medicamentos por nombre
  void searchMedicines(String query) {
    if (query.isEmpty) {
      _medicines = List.from(_allMedicines);
    } else {
      _medicines = _allMedicines.where((m) {
        final name = m.medicineName ?? '';
        return name.toLowerCase().contains(query.toLowerCase());
      }).toList();
    }
    notifyListeners();
  }

  /// 🔹 Cargar todos los medicamentos desde la API
  Future<void> loadMedicines() async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      final response = await TuSaludApi().getAllMedicines();
      if (response.isSuccess() && response.dataList != null) {
        _allMedicines = response.dataList!;
        _medicines = List.from(_allMedicines);
      } else {
        _errorMessage = response.message ?? 'Error al cargar los medicamentos';
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
    loadMedicines();
  }

  /// 🔹 Limpiar datos
  void clearMedicines() {
    _allMedicines = [];
    _medicines = [];
    notifyListeners();
  }
}
