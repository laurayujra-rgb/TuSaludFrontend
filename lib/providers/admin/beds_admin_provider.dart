import 'package:flutter/material.dart';
import 'package:tusalud/api/request/app/ts_bed_request.dart';
import 'package:tusalud/api/tu_salud_api.dart';

import '../../api/response/app/ts_bed_response.dart';

class BedsAdminProvider extends ChangeNotifier {
  List<TsBedsResponse> _allBeds = [];      // todas las camas
  List<TsBedsResponse> _bedsByRoom = [];   // camas filtradas por sala

  bool? _isLoading = false;
  bool? _isAdding = false;
  bool? _isUpdating = false;
  bool? _isDeleting = false;
  String? _errorMessage;
  int? currentRoomId;

  // Getters
  List<TsBedsResponse> get allBeds => _allBeds;
  List<TsBedsResponse> get bedsByRoom => _bedsByRoom;
  bool? get isLoading => _isLoading;
  bool? get isAdding => _isAdding;
  bool? get isUpdating => _isUpdating;
  bool? get isDeleting => _isDeleting;
  String? get errorMessage => _errorMessage;
  int? get getCurrentRoomId => currentRoomId;

  // -------------------------------
  // Cargar todas las camas
  Future<void> loadAllBeds() async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      final response = await TuSaludApi().getAllBeds();
      if (response.isSuccess() && response.dataList != null) {
        _allBeds = response.dataList!;
      } else {
        _errorMessage = response.message ?? 'Error al cargar todas las camas';
        _allBeds = [];
      }
    } catch (e) {
      _errorMessage = 'Error de conexión: ${e.toString()}';
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  // -------------------------------
  // Cargar camas por sala
  Future<void> loadBedsByRoom(int roomId) async {
    currentRoomId = roomId;
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      final response = await TuSaludApi().getBedsByRoom(roomId);
      if (response.isSuccess() && response.dataList != null) {
        _bedsByRoom = response.dataList!;
      } else {
        _errorMessage = response.message ?? 'Error al cargar las camas';
        _bedsByRoom = [];
      }
    } catch (e) {
      _errorMessage = 'Error de conexión: ${e.toString()}';
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  // -------------------------------
  // Agregar nueva cama
  Future<void> addBed(String bedName, int roomId) async {
    _isAdding = true;
    _errorMessage = null;
    notifyListeners();

    try {
      final request = TsBedsRequest(bedName: bedName, roomId: roomId);
      final response = await TuSaludApi().createBed(request);

      if (response.isSuccess()) {
        await loadBedsByRoom(roomId);
        await loadAllBeds(); // refresca también la lista general
      } else {
        _errorMessage = response.message ?? 'Error al agregar cama';
      }
    } catch (e) {
      _errorMessage = 'Error al agregar: ${e.toString()}';
    } finally {
      _isAdding = false;
      notifyListeners();
    }
  }

  // -------------------------------
  // Actualizar cama
  Future<void> updateBed(int id, String bedName, int roomId) async {
    _isUpdating = true;
    _errorMessage = null;
    notifyListeners();

    try {
      final request = TsBedsRequest(bedName: bedName, roomId: roomId);
      final response = await TuSaludApi().updateBed(id, request);

      if (response.isSuccess()) {
        await loadBedsByRoom(roomId);
        await loadAllBeds();
      } else {
        _errorMessage = response.message ?? 'Error al actualizar cama';
      }
    } catch (e) {
      _errorMessage = 'Error al actualizar: ${e.toString()}';
    } finally {
      _isUpdating = false;
      notifyListeners();
    }
  }

  // -------------------------------
  // Eliminar cama
  Future<void> deleteBed(int bedId) async {
    _isDeleting = true;
    _errorMessage = null;
    notifyListeners();

    try {
      final response = await TuSaludApi().deleteBed(bedId);
      if (response.isSuccess()) {
        if (currentRoomId != null) {
          await loadBedsByRoom(currentRoomId!);
        }
        await loadAllBeds();
      } else {
        _errorMessage = response.message ?? 'Error al eliminar cama';
      }
    } catch (e) {
      _errorMessage = 'Error al eliminar: ${e.toString()}';
    } finally {
      _isDeleting = false;
      notifyListeners();
    }
  }

  // -------------------------------
  void clearBeds() {
    _allBeds = [];
    _bedsByRoom = [];
    notifyListeners();
  }
}
