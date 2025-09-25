import 'package:flutter/material.dart';
import 'package:tusalud/api/request/app/ts_room_request.dart';
import 'package:tusalud/api/response/app/ts_room_response.dart';
import 'package:tusalud/api/tu_salud_api.dart';

class RoomsAdminProvider  extends ChangeNotifier{
  List<TsRoomResponse> _allRooms = [];
  List<TsRoomResponse> _rooms= [];

  bool _isLoading = false;
  bool _isAdding = false;
  bool _isUpdating = false;
  bool _isDeleting = false;
  String? _errorMessage ;

  // Getters
  List<TsRoomResponse> get rooms => _rooms;
  bool get isLoading => _isLoading;
  bool get isAdding => _isAdding;
  bool get isUpdating => _isUpdating;
  bool get isDeleting => _isDeleting;
  String? get errorMessage => _errorMessage;

  // Busqueda de salas
  void searchRooms(String query){
    if(query.isEmpty){
      _rooms = List.from(_allRooms);
    }else{
      _rooms = _allRooms.where((room)=>
      room.roomName?.toLowerCase().contains(query.toLowerCase())?? false
      ).toList();
    }
    notifyListeners();
  }

  // Cargar todas las salas desde la API
  Future<void> loadRooms() async{
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      final response = await TuSaludApi().getAllRooms();
      if (response.isSuccess() && response.dataList != null) {
        _allRooms = response.dataList!;
        _rooms = List.from(_allRooms);
      } else {
        _errorMessage = response.message ?? 'Error al cargar las salas';
      }
    } catch (e) {
      _errorMessage = 'Error de conexión: ${e.toString()}';
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  // Agregar nueva sala
  Future<void> addRoom(String roomName) async{
    _isAdding = true;
    _errorMessage = null;
    notifyListeners();

    try{
      final request = TsRoomRequest(roomName: roomName);
      final response = await TuSaludApi().createRoom(request);

      if(response.isSuccess()){
        await loadRooms();
      }else{
        _errorMessage = response.message ?? 'Error al agregar la sala';
      }
    }catch(e){
      _errorMessage = 'Error de conexión: ${e.toString()}';
    }finally{
      _isAdding = false;
      notifyListeners();
    }
  }

  // Actualizar sala
  Future<void> updateRoom(int roomId, String roomName) async{
    _isUpdating = true;
    _errorMessage = null;
    notifyListeners();

    try{
      final request = TsRoomRequest(roomName: roomName);
      final response = await TuSaludApi().updateRoom(roomId, request);

      if(response.isSuccess()){
        await loadRooms();
    }else{
        _errorMessage = response.message ?? 'Error al actualizar la sala';
      }

    }catch(e){
      _errorMessage = 'Error de conexión: ${e.toString()}';
    }finally{
      _isUpdating = false;
      notifyListeners();
    }
  }
  // Eliminar sala
  Future<void>deleteRoom(int roomId) async{
    _isDeleting = true;
    _errorMessage = null;
    notifyListeners();

    try{
      final response = await TuSaludApi().deleteRoom(roomId);

      if(response.isSuccess()){
        await loadRooms();
      }else{
        _errorMessage = response.message ?? 'Error al eliminar la sala';
      }
    }catch(e){
      _errorMessage = 'Error de conexión: ${e.toString()}';
    }finally{
      _isDeleting = false;
      notifyListeners();
    }
  }
  // Reintentar carga de salas
  void retryLoading(){
    _errorMessage = null;
    loadRooms();
  }

  // limpiar datos
  void clearRooms(){
    _allRooms = [];
    _rooms = [];
    _errorMessage = null;
    notifyListeners();
  }
}