import 'package:flutter/material.dart';
import 'package:tusalud/api/response/app/ts_kardex_response.dart';
import 'package:tusalud/api/tu_salud_api.dart';

class KardexNurseProvider extends ChangeNotifier {
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
      final response =
          await TuSaludApi().getKardexByPatientAndRole(patientId, roleId);

      if (response.isSuccess() && response.dataList != null) {
        _allKardex = response.dataList!;
        _kardexList = List.from(_allKardex);
      } else {
        _errorMessage = response.message ?? 'No se encontraron kardex';
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
