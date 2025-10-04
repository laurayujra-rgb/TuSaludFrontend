import 'dart:io';
import 'package:flutter/material.dart';
import 'package:tusalud/api/request/app/ts_medication_kardex_request.dart';
import 'package:tusalud/api/response/app/ts_kardex_medicine_response.dart';
import 'package:tusalud/api/tu_salud_api.dart';

class MedicationKardexNursingLicProvider extends ChangeNotifier {
  // 🔹 Lista de medicamentos
  List<TsMedicationKardexResponse> _medications = [];
  bool _isLoading = false;
  String? _errorMessage;

  // 👉 Getters
  List<TsMedicationKardexResponse> get medications => _medications;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;

  /// 🔹 Cargar medicamentos por kardexId
  Future<void> loadMedicationsByKardex(int kardexId) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      final response = await TuSaludApi().getMedicationsByKardex(kardexId);

      if (response.isSuccess() && response.dataList != null) {
        _medications = response.dataList!;
        _errorMessage = null;
      } else if (response.status == 404) {
        _medications = [];
        _errorMessage = null; // 👈 no error, solo vacío
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

  /// 🔹 Crear nuevo medicamento en un kardex
  Future<bool> addMedication(TsMedicationKardexRequest request) async {
    try {
      final response = await TuSaludApi().createMedication(request);

      if (response.isSuccess() && response.data != null) {
        _medications.add(response.data!);
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

  /// 🔹 Limpiar datos
  void clearMedications() {
    _medications = [];
    notifyListeners();
  }
}
