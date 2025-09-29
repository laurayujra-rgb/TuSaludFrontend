import 'package:flutter/material.dart';
import 'package:tusalud/api/request/app/ts_role_request.dart';
import 'package:tusalud/api/response/app/ts_role_response.dart';
import 'package:tusalud/api/tu_salud_api.dart';

class RoleAdminProvider extends ChangeNotifier {
  List<TsRoleResponse> _allRoles = [];
  List<TsRoleResponse> _roles = [];
  
  bool _isLoading = false;
  bool _isAdding = false;
  bool _isUpdating = false;
  bool _isDeleting = false;
  String? _errorMessage;

  // Getters
  List<TsRoleResponse> get roles => _roles;
  bool get isLoading => _isLoading;
  bool get isAdding => _isAdding;
  bool get isUpdating => _isUpdating;
  bool get isDeleting => _isDeleting;
  String? get errorMessage => _errorMessage;

  // Búsqueda de tipos de persona
  void searchRoles(String query) {
    if (query.isEmpty) {
      _roles = List.from(_allRoles);
    } else {
      _roles = _allRoles.where((role) =>
        role.roleName?.toLowerCase().contains(query.toLowerCase()) ?? false
      ).toList();
    }
    notifyListeners();
  }

  // Cargar roles desde la API
  Future<void> loadRoles() async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      final response = await TuSaludApi().getAllRoles();
      if (response.isSuccess() && response.dataList != null) {
        _allRoles = response.dataList!;
        _roles = List.from(_allRoles);
      } else {
        _errorMessage = response.message ?? 'Error al cargar los roles';
      }
    } catch (e) {
      _errorMessage = 'Error de conexión: ${e.toString()}';
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  // Agregar nuevo rol
  Future<void> addRole(String roleName) async {
    _isAdding = true;
    _errorMessage = null;
    notifyListeners();

    try {
      final request = TsRoleRequest(roleName: roleName);
      final response = await TuSaludApi().createRole(request);

      if (response.isSuccess()) {
        await loadRoles();
      } else {
        _errorMessage = response.message ?? 'Error al agregar rol';
      }
    } catch (e) {
      _errorMessage = 'Error al agregar: ${e.toString()}';
    } finally {
      _isAdding = false;
      notifyListeners();
    }
  }

  // Actualizar rol
  Future<void> updateRole(int id, String roleName) async {
    _isUpdating = true;
    _errorMessage = null;
    notifyListeners();

    try {
      final request = TsRoleRequest(roleName: roleName);
      final response = await TuSaludApi().updateRole(id, request);

      if (response.isSuccess()) {
        await loadRoles();
      } else {
        _errorMessage = response.message ?? 'Error al actualizar rol';
      }
    } catch (e) {
      _errorMessage = 'Error al actualizar: ${e.toString()}';
    } finally {
      _isUpdating = false;
      notifyListeners();
    }
  }

  // Eliminar rol
  Future<void> deleteRole(int id) async {
    _isDeleting = true;
    _errorMessage = null;
    notifyListeners();

    try {
      final response = await TuSaludApi().deleteRole(id);
      
      if (response.isSuccess()) {
        await loadRoles();
      } else {
        _errorMessage = response.message ?? 'Error al eliminar rol';
      }
    } catch (e) {
      _errorMessage = 'Error al eliminar: ${e.toString()}';
    } finally {
      _isDeleting = false;
      notifyListeners();
    }
  }

  // Reintentar carga
  void retryLoading() {
    _errorMessage = null;
    loadRoles();
  }

  // Limpiar datos
  void clearRoles() {
    _allRoles = [];
    _roles = [];
    notifyListeners();
  }
}