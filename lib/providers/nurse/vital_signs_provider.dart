import 'package:flutter/material.dart';
import 'package:tusalud/api/request/app/ts_vital_signs_request.dart';
import 'package:tusalud/api/response/app/ts_vital_signs_response.dart';
import 'package:tusalud/api/tu_salud_api.dart';

class VitalSignsNurseProvider extends ChangeNotifier {
  List<TsVitalSignsResponse> _allVitalSigns = [];
  TsVitalSignsResponse? _vitalSignById;

  bool? _isLoading = false;
  bool? _isAdding = false;
  bool? _isUpdating = false;
  bool? _isDeleting = false;
  String? _errorMessage;

  // =======================
  // Getters
  // =======================
  List<TsVitalSignsResponse> get allVitalSigns => _allVitalSigns;
  TsVitalSignsResponse? get vitalSignById => _vitalSignById;
  bool? get isLoading => _isLoading;
  bool? get isAdding => _isAdding;
  bool? get isUpdating => _isUpdating;
  bool? get isDeleting => _isDeleting;
  String? get errorMessage => _errorMessage;

  // =======================
  // Cargar todos los signos vitales
  // =======================
  Future<void> loadAllVitalSigns() async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      final response = await TuSaludApi().getAllVitalSigns();
      if (response.isSuccess() && response.dataList != null) {
        _allVitalSigns = response.dataList!;
      } else {
        _errorMessage =
            response.message ?? 'Error al cargar los signos vitales';
        _allVitalSigns = [];
      }
    } catch (e) {
      _errorMessage = 'Error de conexión: ${e.toString()}';
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  // =======================
  // Cargar un signo vital por ID
  // =======================
  Future<void> loadVitalSignById(int vitalSignId) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      final response = await TuSaludApi().getVitalSignById(vitalSignId);
      if (response.isSuccess() && response.data != null) {
        _vitalSignById = response.data!;
      } else {
        _errorMessage = response.message ?? 'Error al cargar el signo vital';
        _vitalSignById = null;
      }
    } catch (e) {
      _errorMessage = 'Error de conexión: ${e.toString()}';
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
Future<void> loadVitalSignsByKardex(int kardexId) async {
  _isLoading = true;
  _errorMessage = null;
  notifyListeners();

  try {
    final response = await TuSaludApi().getVitalSignsByKardex(kardexId);
    if (response.isSuccess() && response.dataList != null) {
      _allVitalSigns = response.dataList!;
    } else {
      _allVitalSigns = [];
      _errorMessage = response.message ?? "No se encontraron signos vitales";
    }
  } catch (e) {
    _errorMessage = "Error de conexión: ${e.toString()}";
  } finally {
    _isLoading = false;
    notifyListeners();
  }
}




  // =======================
  // Agregar un signo vital
  // =======================
  Future<void> addVitalSign(TsVitalSignsRequest request) async {
    _isAdding = true;
    _errorMessage = null;
    notifyListeners();

    try {
      final response = await TuSaludApi().createVitalSign(request);

      if (response.isSuccess()) {
        await loadAllVitalSigns();
      } else {
        _errorMessage = response.message ?? 'Error al agregar signo vital';
      }
    } catch (e) {
      _errorMessage = 'Error al agregar: ${e.toString()}';
    } finally {
      _isAdding = false;
      notifyListeners();
    }
  }

  // =======================
  // Actualizar un signo vital
  // =======================
  Future<void> updateVitalSign(
      int vitalSignId, TsVitalSignsRequest request) async {
    _isUpdating = true;
    _errorMessage = null;
    notifyListeners();

    try {
      final response =
          await TuSaludApi().updateVitalSign(vitalSignId, request);

      if (response.isSuccess()) {
        await loadAllVitalSigns();
      } else {
        _errorMessage =
            response.message ?? 'Error al actualizar el signo vital';
      }
    } catch (e) {
      _errorMessage = 'Error al actualizar: ${e.toString()}';
    } finally {
      _isUpdating = false;
      notifyListeners();
    }
  }

  // =======================
  // Eliminar un signo vital
  // =======================
  Future<void> deleteVitalSign(int vitalSignId) async {
    _isDeleting = true;
    _errorMessage = null;
    notifyListeners();

    try {
      final response = await TuSaludApi().deleteVitalSign(vitalSignId);
      if (response.isSuccess()) {
        await loadAllVitalSigns();
      } else {
        _errorMessage =
            response.message ?? 'Error al eliminar el signo vital';
      }
    } catch (e) {
      _errorMessage = 'Error al eliminar: ${e.toString()}';
    } finally {
      _isDeleting = false;
      notifyListeners();
    }
  }

  // =======================
  // Limpiar datos
  // =======================
  void clearVitalSigns() {
    _allVitalSigns = [];
    _vitalSignById = null;
    notifyListeners();
  }
}
