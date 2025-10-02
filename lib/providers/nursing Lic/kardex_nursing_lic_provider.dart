import 'dart:io';

import 'package:flutter/material.dart';
import 'package:tusalud/api/response/app/ts_kardex_response.dart';
import 'package:tusalud/api/tu_salud_api.dart';

class KardexNursingLicProvider extends ChangeNotifier {
  List<TsKardexResponse> _allKardex = [];
  List<TsKardexResponse> _kardexList = [];

  bool _isLoading = false;
  String? _errorMessage;

  // 👉 Getters
  List<TsKardexResponse> get kardexList => _kardexList;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;

  /// 🔹 Buscar kardex por diagnóstico
  void searchKardex(String query) {
    if (query.isEmpty) {
      _kardexList = List.from(_allKardex);
    } else {
      _kardexList = _allKardex.where((k) {
        final diagnosis = k.kardexDiagnosis ?? '';
        return diagnosis.toLowerCase().contains(query.toLowerCase());
      }).toList();
    }
    notifyListeners();
  }

  /// 🔹 Cargar kardex por patientId y roleId
Future<void> loadKardexByPatientAndRole(int patientId, int roleId) async {
  _isLoading = true;
  _errorMessage = null;
  notifyListeners();

  try {
    final response = await TuSaludApi().getKardexByPatientAndRole(patientId, roleId);

    // Caso éxito con datos
    if (response.isSuccess() && response.dataList != null && response.dataList!.isNotEmpty) {
      _allKardex = response.dataList!;
      _kardexList = List.from(_allKardex);
      _errorMessage = null;
    }
    // ✅ Caso "sin resultados": 404 o 2xx con lista vacía -> NO es error
    else if (response.status == 404 ||
             (response.isSuccess() && (response.dataList == null || response.dataList!.isEmpty))) {
      _allKardex = [];
      _kardexList = [];
      _errorMessage = null; // 👈 clave: no mostrar error
    }
    // ❌ Errores reales (red/timeout/500, etc.)
    else if (response.status == HttpStatus.networkConnectTimeoutError ||
             response.status! >= HttpStatus.badRequest) {
      _errorMessage = 'Error al cargar los kardex'; // tu mensaje genérico de error
    } else {
      _errorMessage = 'Error al cargar los kardex';
    }
  } catch (e) {
    _errorMessage = 'Error de conexión: ${e.toString()}';
  } finally {
    _isLoading = false;
    notifyListeners();
  }
}



  /// 🔹 Reintentar carga
  void retryLoading(int patientId, int roleId) {
    _errorMessage = null;
    loadKardexByPatientAndRole(patientId, roleId);
  }

  /// 🔹 Limpiar datos
  void clearKardex() {
    _allKardex = [];
    _kardexList = [];
    notifyListeners();
  }
}
