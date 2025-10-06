import 'package:flutter/material.dart';
import 'package:tusalud/api/request/app/ts_medication_request.dart';
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
 /// 🔹 Cargar todos los medicamentos desde la API
Future<void> loadMedicines() async {
  _isLoading = true;
  _errorMessage = null;
  notifyListeners();

  try {
    final response = await TuSaludApi().getAllMedicines();

    if (response.isSuccess() && response.dataList != null) {
      // 🔹 Filtrar solo los medicamentos activos (status == 1)
      _allMedicines = response.dataList!
          .where((m) => (m.medicineStatus ?? 0) == 1)
          .toList();

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
  /// 🔹 Crear nuevo medicamento
  Future<bool> createMedicine(TsMedicineRequest request) async {
    try {
      final response = await TuSaludApi().createMedicine(request);

      if (response.isSuccess()) {
        await loadMedicines(); // recargar después de crear
        return true;
      } else {
        _errorMessage = response.message ?? 'Error al crear el medicamento';
        notifyListeners();
        return false;
      }
    } catch (e) {
      _errorMessage = 'Error de conexión: ${e.toString()}';
      notifyListeners();
      return false;
    }
  }

  /// 🔹 Actualizar medicamento
  Future<void> updateMedicine(int medicineId, TsMedicineRequest request) async {
    try {
      final response = await TuSaludApi().updateMedicine(medicineId, request);

      if (response.isSuccess()) {
        await loadMedicines();
      } else {
        _errorMessage = response.message ?? 'Error al actualizar el medicamento';
      }
    } catch (e) {
      _errorMessage = 'Error de conexión: ${e.toString()}';
    } finally {
      notifyListeners();
    }
  }

  /// 🔹 Eliminar medicamento (soft delete)
  Future<void> deleteMedicine(int medicineId) async {
    try {
      final response = await TuSaludApi().deleteMedicine(medicineId);

      if (response.isSuccess()) {
        await loadMedicines(); // recarga después de eliminar
      } else {
        _errorMessage = response.message ?? 'Error al eliminar el medicamento';
      }
    } catch (e) {
      _errorMessage = 'Error de conexión: ${e.toString()}';
    } finally {
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
