import 'package:flutter/material.dart';
import 'package:tusalud/api/request/app/ts_reports_request.dart';
import 'package:tusalud/api/response/app/ts_reports_response.dart';
import 'package:tusalud/api/tu_salud_api.dart';

class ReportsNurseProvider extends ChangeNotifier {
  List<TsReportsResponse> _allReports = [];
  TsReportsResponse? _reportById;

  bool? _isLoading = false;
  bool? _isAdding = false;
  bool? _isUpdating = false;
  bool? _isDeleting = false;
  String? _errorMessage;

  // =======================
  // Getters
  // =======================
  List<TsReportsResponse> get allReports => _allReports;
  TsReportsResponse? get reportById => _reportById;
  bool? get isLoading => _isLoading;
  bool? get isAdding => _isAdding;
  bool? get isUpdating => _isUpdating;
  bool? get isDeleting => _isDeleting;
  String? get errorMessage => _errorMessage;

  // =======================
  // Cargar todos los reportes
  // =======================
  Future<void> loadAllReports() async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      final response = await TuSaludApi().getAllReports();
      if (response.isSuccess() && response.dataList != null) {
        _allReports = response.dataList!;
      } else {
        _errorMessage = response.message ?? 'Error al cargar los reportes';
        _allReports = [];
      }
    } catch (e) {
      _errorMessage = 'Error de conexión: ${e.toString()}';
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  // =======================
  // Cargar un reporte por ID
  // =======================
  Future<void> loadReportById(int reportId) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      final response = await TuSaludApi().getReportById(reportId);
      if (response.isSuccess() && response.data != null) {
        _reportById = response.data!;
      } else {
        _errorMessage = response.message ?? 'Error al cargar el reporte';
        _reportById = null;
      }
    } catch (e) {
      _errorMessage = 'Error de conexión: ${e.toString()}';
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  // =======================
  // Cargar reportes por Kardex
  // =======================
  Future<void> loadReportsByKardex(int kardexId) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      final response = await TuSaludApi().getReportsByKardex(kardexId);
      if (response.isSuccess() && response.dataList != null) {
        _allReports = response.dataList!;
      } else {
        _allReports = [];
        _errorMessage = response.message ?? "No se encontraron reportes";
      }
    } catch (e) {
      _errorMessage = "Error de conexión: ${e.toString()}";
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  // =======================
  // Agregar un reporte
  // =======================
  Future<void> addReport(TsReportsRequest request) async {
    _isAdding = true;
    _errorMessage = null;
    notifyListeners();

    try {
      final response = await TuSaludApi().createReport(request);
      if (response.isSuccess()) {
        await loadAllReports();
      } else {
        _errorMessage = response.message ?? 'Error al agregar reporte';
      }
    } catch (e) {
      _errorMessage = 'Error al agregar: ${e.toString()}';
    } finally {
      _isAdding = false;
      notifyListeners();
    }
  }

  // =======================
  // Actualizar un reporte
  // =======================
  Future<void> updateReport(int reportId, TsReportsRequest request) async {
    _isUpdating = true;
    _errorMessage = null;
    notifyListeners();

    try {
      final response = await TuSaludApi().updateReport(reportId, request);
      if (response.isSuccess()) {
        await loadAllReports();
      } else {
        _errorMessage = response.message ?? 'Error al actualizar el reporte';
      }
    } catch (e) {
      _errorMessage = 'Error al actualizar: ${e.toString()}';
    } finally {
      _isUpdating = false;
      notifyListeners();
    }
  }

  // =======================
  // Eliminar un reporte
  // =======================
  Future<void> deleteReport(int reportId) async {
    _isDeleting = true;
    _errorMessage = null;
    notifyListeners();

    try {
      final response = await TuSaludApi().deleteReport(reportId);
      if (response.isSuccess()) {
        await loadAllReports();
      } else {
        _errorMessage = response.message ?? 'Error al eliminar el reporte';
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
  void clearReports() {
    _allReports = [];
    _reportById = null;
    notifyListeners();
  }
}
