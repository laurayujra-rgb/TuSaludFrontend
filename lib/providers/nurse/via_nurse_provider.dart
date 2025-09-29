import 'package:flutter/material.dart';
import 'package:tusalud/api/response/app/ts_via_response.dart';
import 'package:tusalud/api/tu_salud_api.dart';

class ViaNurseProvider extends ChangeNotifier {
  List<TsViaResponse> _allVias = [];
  List<TsViaResponse> _vias = [];

  bool _isLoading = false;
  String? _errorMessage;


  List<TsViaResponse> get vias => _vias;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;

  /// 🔹 Buscar vías por nombre
  void searchVias(String query) {
    if (query.isEmpty) {
      _vias = List.from(_allVias);
    } else {
      _vias = _allVias.where((v) {
        final name = v.viaName ?? '';
        return name.toLowerCase().contains(query.toLowerCase());
      }).toList();
    }
    notifyListeners();
  }

  /// 🔹 Cargar todas las vías desde la API
  Future<void> loadVias() async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      final response = await TuSaludApi().getAllVias();
      if (response.isSuccess() && response.dataList != null) {
        _allVias = response.dataList!;
        _vias = List.from(_allVias);
      } else {
        _errorMessage = response.message ?? 'Error al cargar las vías';
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
    loadVias();
  }

  /// 🔹 Limpiar datos
  void clearVias() {
    _allVias = [];
    _vias = [];
    notifyListeners();
  }
}
