import 'dart:io';
import 'package:flutter/material.dart';
import 'package:tusalud/api/request/app/ts_medication_kardex_request.dart';
import 'package:tusalud/api/response/app/ts_kardex_medicine_response.dart';
import 'package:tusalud/api/tu_salud_api.dart';

class MedicationKardexNursingLicProvider extends ChangeNotifier {
  // 🔹 Lista de medicamentos activos
  List<TsMedicationKardexResponse> _medications = [];

  bool _isLoading = false;
  String? _errorMessage;

  // 👉 Getters
  List<TsMedicationKardexResponse> get medications => _medications;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;

  // ============================================================
  // 🔹 Cargar medicamentos por kardexId (solo activos)
  // ============================================================
  Future<void> loadMedicationsByKardex(int kardexId) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      final response = await TuSaludApi().getMedicationsByKardex(kardexId);

      if (response.isSuccess() && response.dataList != null) {
        // 🔥 Filtrar solo los que tienen status != 0 (activos)
        _medications = response.dataList!.where((m) => m.status != 0).toList();
        _errorMessage = null;
      } else if (response.status == 404) {
        _medications = [];
        _errorMessage = null;
      } else if (response.status! >= HttpStatus.badRequest) {
        _errorMessage = response.message ?? "Error al cargar medicamentos";
      }
    } catch (e) {
      _errorMessage = "Error de conexión: ${e.toString()}";
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  // ============================================================
  // 🔹 Crear nuevo medicamento en un kardex
  // ============================================================
  Future<bool> addMedication(TsMedicationKardexRequest request) async {
    try {
      final response = await TuSaludApi().createMedication(request);

      if (response.isSuccess() && response.data != null) {
        // Solo agregar si tiene status activo
        if (response.data!.status != 0) {
          _medications.add(response.data!);
        }
        notifyListeners();
        return true;
      } else {
        _errorMessage = response.message ?? "Error al agregar medicación";
        notifyListeners();
        return false;
      }
    } catch (e) {
      _errorMessage = "Error de conexión: ${e.toString()}";
      notifyListeners();
      return false;
    }
  }

  // ============================================================
  // 🔹 Actualizar un medicamento existente
  // ============================================================
  Future<bool> updateMedication(int id, TsMedicationKardexRequest request) async {
    try {
      final response = await TuSaludApi().updateMedication(id, request);

      if (response.isSuccess() && response.data != null) {
        final index = _medications.indexWhere((m) => m.id == id);
        if (index != -1) {
          // Reemplazar el objeto por el actualizado
          final updated = response.data!;
          if (updated.status != 0) {
            _medications[index] = updated;
          } else {
            // Si el actualizado vino con status 0, lo removemos
            _medications.removeAt(index);
          }
          notifyListeners();
        }
        return true;
      } else {
        _errorMessage = response.message ?? "Error al actualizar medicación";
        notifyListeners();
        return false;
      }
    } catch (e) {
      _errorMessage = "Error de conexión: ${e.toString()}";
      notifyListeners();
      return false;
    }
  }

  // ============================================================
  // 🔹 Eliminar medicación (soft delete)
  // ============================================================
  Future<bool> deleteMedication(int id) async {
    try {
      final response = await TuSaludApi().deleteMedication(id);

      if (response.isSuccess()) {
        // 🔥 Eliminamos del listado local (status 0)
        _medications.removeWhere((m) => m.id == id || m.status == 0);
        notifyListeners();
        return true;
      } else {
        _errorMessage = response.message ?? "Error al eliminar medicación";
        notifyListeners();
        return false;
      }
    } catch (e) {
      _errorMessage = "Error de conexión: ${e.toString()}";
      notifyListeners();
      return false;
    }
  }

  // ============================================================
  // 🔹 Limpiar lista completa
  // ============================================================
  void clearMedications() {
    _medications = [];
    notifyListeners();
  }
}
