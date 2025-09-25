import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:tusalud/api/request/app/ts_bed_request.dart';
import 'package:tusalud/api/request/app/ts_gender_request.dart';
import 'package:tusalud/api/request/app/ts_role_request.dart';
import 'package:tusalud/api/request/app/ts_room_request.dart';
import 'package:tusalud/api/request/auth/sign_up_request.dart';

import 'package:tusalud/api/request/auth/ts_auth_request.dart';
import 'package:tusalud/api/response/app/ts_bed_response.dart';
import 'package:tusalud/api/response/app/ts_gender_response.dart';
import 'package:tusalud/api/response/app/ts_role_response.dart';
import 'package:tusalud/api/response/app/ts_room_response.dart';
import 'package:tusalud/api/response/auth/ts_person_response.dart';
import 'package:tusalud/api/response/ts_response.dart';
import 'package:tusalud/config/enviroment.dart';

import 'request/auth/ts_token_request.dart';

class TuSaludApi {

  static const int authorizationForbidden = 403;
  static const int authorizationUnauthorized = 401;

  static final String _baseUrl = Enviroment.apiTuSaludURL;
  static final String _baseAuthUrl = Enviroment.apiTuSaludAuthURL;

  Future<TsResponse<TsTokenRequest>> autenticateUser(TsAuthRequest authRequest) async{
    try{
      final response = await httpPost('$_baseAuthUrl/auth/login', getHeaders(), authRequest.toJson());

      if(response.statusCode >= HttpStatus.badRequest){
        if(response.statusCode == HttpStatus.networkConnectTimeoutError){
          return TsResponse<TsTokenRequest>(status: HttpStatus.networkConnectTimeoutError);
        }

        try{
          final errorJson = json.decode(response.body);
          return TsResponse<TsTokenRequest>(
            status: response.statusCode,
            message: errorJson['message']?? 'érror desconocido',
            error: errorJson['error']??  '',
          );
        }catch(e){
          return TsResponse<TsTokenRequest>.createEmpty();
        }
      }
      final responseJson = json.decode(response.body);

      // Manejar el caso cuando la respuesta no tiene el formato esperado
      if(responseJson['data'] == null){
        return TsResponse<TsTokenRequest>(
          status: response.statusCode,
          message: 'Respuesta inesperada del servidor',
          error: 'Datos no encontrados',
        );
      }

      //Crear la respuesta con los tokens
      final tokenData = TsTokenRequest.createEmpty().fromMap(responseJson['data']);

      return TsResponse<TsTokenRequest>(
        data: tokenData,
        status: responseJson['status'] ?? response.statusCode,
        message: responseJson['message'] ?? 'Autenticación exitosa',
        error: responseJson['error'] ?? '',
      );
    }catch(e){
      return TsResponse<TsTokenRequest>(
        status: HttpStatus.internalServerError,
        message: 'Error del servidor: $e',
        error: 'Error del servidor',
      );
    }
    
  }
/// ------------------------------------------------------------------------------------
/// DEFAULT METHODS

/// ------------------------------------------------------------------------------------
/// GET
/// ------------------------------------------------------------------------------------
  Future<http.Response> httpGet(String baseUrl, dynamic header) async {
    try {
      var httpResponse = await http.get(Uri.parse(baseUrl), headers: header);
      if (httpResponse.statusCode != HttpStatus.ok) {
        final error = TsResponse.fromJson(httpResponse.body);
        if (error.status == authorizationForbidden || error.status == authorizationUnauthorized) {
          // httpResponse = await reloginMethodGet(baseUrl, header, httpResponse);
        }
      }
      return httpResponse;
    } catch (e) {
      if (e.toString().contains('errno = 7') || e.toString().contains('Software caused connection abort')) {
        return http.Response("{}", HttpStatus.networkConnectTimeoutError);
      }
    }
    return http.Response("{}", HttpStatus.conflict);
  }
///-------------------------------------------------------------------------------------
/// PUT
/// ------------------------------------------------------------------------------------
  Future<http.Response> httpPut(String baseUrl, dynamic header, String jsonRequest) async {
    try {
      var httpResponse = await http.put(
        Uri.parse(baseUrl),
        headers: header,
        body: jsonRequest,
        encoding: Encoding.getByName("utf-8")
      ).timeout(const Duration(seconds: 120));
      if (httpResponse.statusCode != HttpStatus.ok) {
        final error = TsResponse.fromJson(httpResponse.body);
        if (error.status == authorizationForbidden || error.status == authorizationUnauthorized) {
          // httpResponse = await reloginMethodPut(baseUrl, header, httpResponse, jsonRequest);
        }
      }
      return httpResponse;
    } catch (e) {
      if (e.toString().contains('errno = 7') || e.toString().contains('Software caused connection abort')) {
        return http.Response("{}", HttpStatus.networkConnectTimeoutError);
      }
    }
    return http.Response("{}", HttpStatus.conflict);
  }
/// ------------------------------------------------------------------------------------
/// POST
/// ------------------------------------------------------------------------------------
  Future<http.Response> httpPost(String baseUrl, dynamic header, String jsonRequest) async {
    try {
      var httpResponse = await http.post(
        Uri.parse(baseUrl),
        headers: header,
        body: jsonRequest,
        encoding: Encoding.getByName("utf-8")
      ).timeout(const Duration(seconds: 120));
      if (httpResponse.statusCode != HttpStatus.ok) {
        final error = TsResponse.fromJson(httpResponse.body);

        if (error.status == authorizationForbidden || error.status == authorizationUnauthorized) {
          // httpResponse = await reloginMethodPost(baseUrl, header, httpResponse, jsonRequest);
        }
      }
      return httpResponse;
    } catch (e) {
      if (e.toString().contains('errno = 7') || e.toString().contains('Software caused connection abort'))
        return http.Response("{}", HttpStatus.networkConnectTimeoutError);
    }
    return http.Response("{}", HttpStatus.conflict);
  }
/// ------------------------------------------------------------------------------------
/// DELETE
/// ------------------------------------------------------------------------------------
Future<http.Response> httpDelete(String baseUrl, dynamic header) async {
  try {
    var httpResponse = await http.delete(
      Uri.parse(baseUrl),
      headers: header,
    ).timeout(const Duration(seconds: 120));
    
    if (httpResponse.statusCode != HttpStatus.ok) {
      final error = TsResponse.fromJson(httpResponse.body);
      if (error.status == authorizationForbidden || error.status == authorizationUnauthorized) {
        // httpResponse = await reloginMethodDelete(baseUrl, header, httpResponse);
      }
    }
    return httpResponse;
  } catch (e) {
    if (e.toString().contains('errno = 7') || e.toString().contains('Software caused connection abort')) {
      return http.Response("{}", HttpStatus.networkConnectTimeoutError);
    }
  }
  return http.Response("{}", HttpStatus.conflict);
}


  getHeaders() {
    return {
      'Content-Type': 'application/json; charset=UTF-8',
    };
  }

  getHeadersByToken(String token) {
    return {
      'Content-Type': 'application/json; charset=UTF-8',
      'Authorization': 'Bearer $token',
    };
  }

  Map<String, dynamic> parseJwt(String token) {
    final parts = token.split('.');
    if (parts.length != 3) {
      throw Exception('invalid token');
    }

    final payload = _decodeBase64(parts[1]);
    final payloadMap = json.decode(payload);
    if (payloadMap is! Map<String, dynamic>) {
      throw Exception('invalid payload');
    }

    return payloadMap;
  }

  String _decodeBase64(String str) {
    String output = str.replaceAll('-', '+').replaceAll('_', '/');

    switch (output.length % 4) {
      case 0:
        break;
      case 2:
        output += '==';
        break;
      case 3:
        output += '=';
        break;
      default:
        throw Exception('Illegal base64url string!"');
    }

    return utf8.decode(base64Url.decode(output));
  }
///----------------------------------------------------------------------------
/// AUTH SECTION
/// ----------------------------------------------------------------------------
/// 
///-----------------------------------------------------------------------------
// SIGNUP
/// ----------------------------------------------------------------------------------------------------
Future<TsResponse<TsPersonResponse>> signup(TsSignUpRequest personRequest) async {
  try {
    final response = await httpPost('$_baseUrl/persons/create', getHeaders(), jsonEncode(personRequest.toJson()));
    if (response.statusCode >= HttpStatus.badRequest) {
      if (response.statusCode == HttpStatus.networkConnectTimeoutError) {
        return TsResponse<TsPersonResponse>(status: HttpStatus.networkConnectTimeoutError);
      }
      try {
        final errorJson = json.decode(response.body);
        return TsResponse<TsPersonResponse>(
          status: response.statusCode,
          message: errorJson['message'] ?? 'Error al crear la persona',
          error: errorJson['error'] ?? '',
        );
      } catch (e) {
        return TsResponse<TsPersonResponse>.createEmpty();
      }
    }
    final responseJson = json.decode(response.body);
    final personData = TsPersonResponse.createEmpty().fromMap(responseJson['data']);
    return TsResponse<TsPersonResponse>(
      data: personData,
      status: response.statusCode,
      message: responseJson['message'],
    );
  } catch (e) {
    return TsResponse<TsPersonResponse>(
      status: HttpStatus.internalServerError,
      message: 'Error durante la creación de la persona',
      error: e.toString(),
    );
  }
}
///----------------------------------------------------------------------------------------------------
/// GENDER SECTION
/// ----------------------------------------------------------------------------
/// CREATE GENDER
/// ----------------------------------------------------------------------------------------------------
  Future<TsResponse<TsGenderResponse>> createGender(TsGenderRequest genderRequest) async {
    try{
      final response = await httpPost('$_baseUrl/gender/create', getHeaders(), jsonEncode(genderRequest.toJson()));
      if(response.statusCode >= HttpStatus.badRequest){
        if(response.statusCode == HttpStatus.networkConnectTimeoutError){
          return TsResponse<TsGenderResponse>(status: HttpStatus.networkConnectTimeoutError);
        }
        try{
          final errorJson = json.decode(response.body);
          return TsResponse<TsGenderResponse>(
            status: response.statusCode,
            message: errorJson['message'] ?? 'Error al crear el género',
            error: errorJson['error'] ?? '',
          );
        }catch(e){
          return TsResponse<TsGenderResponse>.createEmpty();
        }
      }
      final responseJson = json.decode(response.body);
      final genderData = TsGenderResponse.createEmpty().fromMap(responseJson['data']);
      return TsResponse<TsGenderResponse>(
        data: genderData,
        status: response.statusCode,
        message: responseJson['message'],
      );
    }catch(e){
      return TsResponse<TsGenderResponse>(
        status: HttpStatus.internalServerError,
        message: 'Error durante la creación del género',
        error: e.toString(),
      );
    }
  }
///  ----------------------------------------------------------------------------------------------------
/// GET ALL GENDERS
/// ----------------------------------------------------------------------------------------------------
  Future<TsResponse<TsGenderResponse>> getAllGenders() async{
    try{
      final response = await httpGet('$_baseUrl/gender', getHeaders());
      if(response.statusCode >= HttpStatus.badRequest){
        if(response.statusCode == HttpStatus.networkConnectTimeoutError){
          TsResponse<TsGenderResponse> responseData = TsResponse(status: HttpStatus.networkConnectTimeoutError);
          return responseData;
        }
        return TsResponse.createEmpty();
      }
      TsResponse<TsGenderResponse> responseData = TsResponse.fromJsonList(utf8.decode(response.bodyBytes), TsGenderResponse.createEmpty());
      return responseData;
    }catch(e){
      return TsResponse.createEmpty();
    }
  }
///  ------------------------------------------------------------------------------------------------
/// GET A GENDER
/// ----------------------------------------------------------------------------------------------------
  Future<TsResponse<TsGenderResponse>> getGender(int genderId) async{
    try{
      final response = await httpGet('$_baseUrl/gender/$genderId', getHeaders());
      if(response.statusCode >= HttpStatus.badRequest){
        if(response.statusCode == HttpStatus.networkConnectTimeoutError){
          TsResponse<TsGenderResponse> responseData = TsResponse(status: HttpStatus.networkConnectTimeoutError);
          return responseData;
        }
        return TsResponse.createEmpty();
      }
      TsResponse<TsGenderResponse> responseData = TsResponse.fromJson(utf8.decode(response.bodyBytes));
      return responseData;
    }catch(e){
      return TsResponse.createEmpty();
    }
  }
///  ------------------------------------------------------------------------------------------------
/// UPDATE A GENDER
/// ----------------------------------------------------------------------------------------------------
  Future<TsResponse<TsGenderResponse>> updateGender(int genderId, TsGenderRequest genderRequest) async {
    try {
      final response = await httpPut('$_baseUrl/gender/$genderId', getHeaders(), jsonEncode(genderRequest.toJson()));
      if (response.statusCode >= HttpStatus.badRequest) {
        if (response.statusCode == HttpStatus.networkConnectTimeoutError) {
          return TsResponse<TsGenderResponse>(status: HttpStatus.networkConnectTimeoutError);
        }
        try {
          final errorJson = json.decode(response.body);
          return TsResponse<TsGenderResponse>(
            status: response.statusCode,
            message: errorJson['message'] ?? 'Error al actualizar el género',
            error: errorJson['error'] ?? '',
          );
        } catch (e) {
          return TsResponse<TsGenderResponse>.createEmpty();
        }
      }
      final responseJson = json.decode(response.body);
      final genderData = TsGenderResponse.createEmpty().fromMap(responseJson['data']);
      return TsResponse<TsGenderResponse>(
        data: genderData,
        status: response.statusCode,
        message: responseJson['message'],
      );
    } catch (e) {
      return TsResponse<TsGenderResponse>(
        status: HttpStatus.internalServerError,
        message: 'Error durante la actualización del género',
        error: e.toString(),
      );
    }
  }
///  ------------------------------------------------------------------------------------------------
/// DELETE A GENDER
/// ----------------------------------------------------------------------------------------------------
  Future<TsResponse<TsGenderResponse>> deleteGender(int genderId) async {
    try {
      final response = await httpDelete('$_baseUrl/gender/$genderId', getHeaders());
      if (response.statusCode >= HttpStatus.badRequest) {
        if (response.statusCode == HttpStatus.networkConnectTimeoutError) {
          return TsResponse<TsGenderResponse>(status: HttpStatus.networkConnectTimeoutError);
        }
        try {
          final errorJson = json.decode(response.body);
          return TsResponse<TsGenderResponse>(
            status: response.statusCode,
            message: errorJson['message'] ?? 'Error al eliminar el género',
            error: errorJson['error'] ?? '',
          );
        } catch (e) {
          return TsResponse<TsGenderResponse>.createEmpty();
        }
      }
      final responseJson = json.decode(response.body);
      final genderData = TsGenderResponse.createEmpty().fromMap(responseJson['data']);
      return TsResponse<TsGenderResponse>(
        data: genderData,
        status: response.statusCode,
        message: responseJson['message'],
      );
    } catch (e) {
      return TsResponse<TsGenderResponse>(
        status: HttpStatus.internalServerError,
        message: 'Error durante la eliminación del género',
        error: e.toString(),
      );
    }
  }

///----------------------------------------------------------------------------------------------------
/// ROLE SECTION
/// ---------------------------------------------------------------------------------------------------

///----------------------------------------------------------------------------------------------------
/// CREATE ROLE
/// ----------------------------------------------------------------------------------------------------
  Future<TsResponse<TsRoleResponse>> createRole(TsRoleRequest roleRequest) async{
    try{
      final response = await httpPost('$_baseUrl/personsType/create', getHeaders(), jsonEncode(roleRequest.toJson()));
      if(response.statusCode >= HttpStatus.badRequest){
        if(response.statusCode == HttpStatus.networkConnectTimeoutError){
          return TsResponse<TsRoleResponse>(status: HttpStatus.networkConnectTimeoutError);
        }
        try{
          final errorJson = json.decode(response.body);
          return TsResponse<TsRoleResponse>(
            status: response.statusCode,
            message: errorJson['message'] ?? 'Error al crear el tipo de persona',
            error: errorJson['error'] ?? '',
          );
        }catch(e){
          return TsResponse<TsRoleResponse>.createEmpty();
        }
      }
      final responseJson = json.decode(response.body);
      final personTypeData = TsRoleResponse.createEmpty().fromMap(responseJson['data']);
      return TsResponse<TsRoleResponse>(
        data: personTypeData,
        status: response.statusCode,
        message: responseJson['message'],
      );
    }catch(e){
      return TsResponse<TsRoleResponse>(
        status: HttpStatus.internalServerError,
        message: 'Error durante la creación del tipo de persona',
        error: e.toString(),
      );
    }
  }
///  ----------------------------------------------------------------------------------------------------
/// GET ALL ROLES
/// ----------------------------------------------------------------------------------------------------
  Future<TsResponse<TsRoleResponse>> getAllRoles() async{
    try{
      final response = await httpGet('$_baseUrl/roles', getHeaders());
      if(response.statusCode >= HttpStatus.badRequest){
        if(response.statusCode == HttpStatus.networkConnectTimeoutError){
          TsResponse<TsRoleResponse> responseData = TsResponse(status: HttpStatus.networkConnectTimeoutError);
          return responseData;
        }
        return TsResponse.createEmpty();
      }
      TsResponse<TsRoleResponse> responseData = TsResponse.fromJsonList(utf8.decode(response.bodyBytes), TsRoleResponse.createEmpty());
      return responseData;
    }catch(e){
      return TsResponse.createEmpty();
    }
  }
///  ------------------------------------------------------------------------------------------------
/// UpDATE A ROLE
/// ----------------------------------------------------------------------------------------------------
  Future<TsResponse<TsRoleResponse>> updateRole(int roleId, TsRoleRequest roleRequest) async {
    try {
      final response = await httpPut('$_baseUrl/roles/$roleId', getHeaders(), jsonEncode(roleRequest.toJson()));
      if (response.statusCode >= HttpStatus.badRequest) {
        if (response.statusCode == HttpStatus.networkConnectTimeoutError) {
          return TsResponse<TsRoleResponse>(status: HttpStatus.networkConnectTimeoutError);
        }
        try {
          final errorJson = json.decode(response.body);
          return TsResponse<TsRoleResponse>(
            status: response.statusCode,
            message: errorJson['message'] ?? 'Error al actualizar el rol',
            error: errorJson['error'] ?? '',
          );
        } catch (e) {
          return TsResponse<TsRoleResponse>.createEmpty();
        }
      }
      final responseJson = json.decode(response.body);
      final roleData = TsRoleResponse.createEmpty().fromMap(responseJson['data']);
      return TsResponse<TsRoleResponse>(
        data: roleData,
        status: response.statusCode,
        message: responseJson['message'],
      );
    } catch (e) {
      return TsResponse<TsRoleResponse>(
        status: HttpStatus.internalServerError,
        message: 'Error durante la actualización del rol',
        error: e.toString(),
      );
    }
  }
///  ------------------------------------------------------------------------------------------------
/// DELETE A ROLE
/// ----------------------------------------------------------------------------------------------------
  Future<TsResponse<TsRoleResponse>> deleteRole(int roleId) async {
    try {
      final response = await httpDelete('$_baseUrl/roles/$roleId', getHeaders());
      if (response.statusCode >= HttpStatus.badRequest) {
        if (response.statusCode == HttpStatus.networkConnectTimeoutError) {
          return TsResponse<TsRoleResponse>(status: HttpStatus.networkConnectTimeoutError);
        }
        try {
          final errorJson = json.decode(response.body);
          return TsResponse<TsRoleResponse>(
            status: response.statusCode,
            message: errorJson['message'] ?? 'Error al eliminar el rol',
            error: errorJson['error'] ?? '',
          );
        } catch (e) {
          return TsResponse<TsRoleResponse>.createEmpty();
        }
      }
      final responseJson = json.decode(response.body);
      final roleData = TsRoleResponse.createEmpty().fromMap(responseJson['data']);
      return TsResponse<TsRoleResponse>(
        data: roleData,
        status: response.statusCode,
        message: responseJson['message'],
      );
    } catch (e) {
      return TsResponse<TsRoleResponse>(
        status: HttpStatus.internalServerError,
        message: 'Error durante la eliminación del rol',
        error: e.toString(),
      );
    }
  }
///  ------------------------------------------------------------------------------------------------
/// ROOM SECTION
/// ---------------------------------------------------------------------------------------------------

///------------------------------------------------------------------------------------
/// CREATE ROOM
///----------------------------------------------------------------------------------------------------
Future<TsResponse<TsRoomResponse>>createRoom(TsRoomRequest roomRequest) async{
    try{
      final response = await httpPost('$_baseUrl/rooms/create', getHeaders(), jsonEncode(roomRequest.toJson()));
      if(response.statusCode >= HttpStatus.badRequest){
        if(response.statusCode == HttpStatus.networkConnectTimeoutError){
          return TsResponse<TsRoomResponse>(status: HttpStatus.networkConnectTimeoutError);
        }
        try{
          final errorJson = json.decode(response.body);
          return TsResponse<TsRoomResponse>(
            status: response.statusCode,
            message: errorJson['message'] ?? 'Error al crear la sala',
            error: errorJson['error'] ?? '',
          );
        }catch(e){
          return TsResponse<TsRoomResponse>.createEmpty();
        }
    }
    final responseJson = json.decode(response.body);
    final roomData = TsRoomResponse.createEmpty().fromMap(responseJson['data']);
    return TsResponse<TsRoomResponse>(
      data: roomData,
      status: response.statusCode,
      message: responseJson['message'],
    );
}catch(e){
      return TsResponse<TsRoomResponse>(
        status: HttpStatus.internalServerError,
        message: 'Error durante la creación de la sala',
        error: e.toString(),
      );
    }
  }
///  ----------------------------------------------------------------------------------------------------

/// ------------------------------------------------------------------------------------ --------------- 
/// GET ALL ROOMS
/// ----------------------------------------------------------------------------------------------------
Future<TsResponse<TsRoomResponse>> getAllRooms() async{
    try{
      final response = await httpGet('$_baseUrl/rooms', getHeaders());
      if(response.statusCode >= HttpStatus.badRequest){
        if(response.statusCode == HttpStatus.networkConnectTimeoutError){
          TsResponse<TsRoomResponse> responseData = TsResponse(status: HttpStatus.networkConnectTimeoutError);
          return responseData;
        }
        return TsResponse.createEmpty();
      }
      TsResponse<TsRoomResponse> responseData = TsResponse.fromJsonList(utf8.decode(response.bodyBytes), TsRoomResponse.createEmpty());
      return responseData;
    }catch(e){
      return TsResponse.createEmpty();
    }
  }
///  ------------------------------------------------------------------------------------------------

/// ------------------------------------------------------------------------------------
/// UPDATE A ROOM
/// ----------------------------------------------------------------------------------------------------
Future<TsResponse<TsRoomResponse>> updateRoom(int roomId, TsRoomRequest roomRequest) async {
    try {
      final response = await httpPut('$_baseUrl/rooms/$roomId', getHeaders(), jsonEncode(roomRequest.toJson()));
      if (response.statusCode >= HttpStatus.badRequest) {
        if (response.statusCode == HttpStatus.networkConnectTimeoutError) {
          return TsResponse<TsRoomResponse>(status: HttpStatus.networkConnectTimeoutError);
        }
        try {
          final errorJson = json.decode(response.body);
          return TsResponse<TsRoomResponse>(
            status: response.statusCode,
            message: errorJson['message'] ?? 'Error al actualizar la sala',
            error: errorJson['error'] ?? '',
          );
        } catch (e) {
          return TsResponse<TsRoomResponse>.createEmpty();
        }
      }
      final responseJson = json.decode(response.body);
      final roomData = TsRoomResponse.createEmpty().fromMap(responseJson['data']);
      return TsResponse<TsRoomResponse>(
        data: roomData,
        status: response.statusCode,
        message: responseJson['message'],
      );
    } catch (e) {
      return TsResponse<TsRoomResponse>(
        status: HttpStatus.internalServerError,
        message: 'Error durante la actualización de la sala',
        error: e.toString(),
      );
    }
  }
///  ------------------------------------------------------------------------------------------------

/// -------------------------------------------------------------------------------------------------
/// DELETE A ROOM
/// ----------------------------------------------------------------------------------------------------
Future<TsResponse<TsRoomResponse>> deleteRoom(int roomId) async {
    try {
      final response = await httpDelete('$_baseUrl/rooms/$roomId', getHeaders());
      if (response.statusCode >= HttpStatus.badRequest) {
        if (response.statusCode == HttpStatus.networkConnectTimeoutError) {
          return TsResponse<TsRoomResponse>(status: HttpStatus.networkConnectTimeoutError);
        }
        try {
          final errorJson = json.decode(response.body);
          return TsResponse<TsRoomResponse>(
            status: response.statusCode,
            message: errorJson['message'] ?? 'Error al eliminar la sala',
            error: errorJson['error'] ?? '',
          );
        } catch (e) {
          return TsResponse<TsRoomResponse>.createEmpty();
        }
      }
      final responseJson = json.decode(response.body);
      final roomData = TsRoomResponse.createEmpty().fromMap(responseJson['data']);
      return TsResponse<TsRoomResponse>(
        data: roomData,
        status: response.statusCode,
        message: responseJson['message'],
      );
    } catch (e) {
      return TsResponse<TsRoomResponse>(
        status: HttpStatus.internalServerError,
        message: 'Error durante la eliminación de la sala',
        error: e.toString(),
      );
    }
  }
///  ------------------------------------------------------------------------------------------------


///----------------------------------------------------------------------------------------------------
///BEDS SECTION
/// ---------------------------------------------------------------------------------------------------


///----------------------------------------------------------------------------------------------------
///CREATE BED BY ROOMID
/// ----------------------------------------------------------------------------------------------------
Future<TsResponse<TsBedsResponse>> createBed(TsBedsRequest bedRequest) async {
    try {
      final response = await httpPost('$_baseUrl/beds/create', getHeaders(), jsonEncode(bedRequest.toJson()));
      if (response.statusCode >= HttpStatus.badRequest) {
        if (response.statusCode == HttpStatus.networkConnectTimeoutError) {
          return TsResponse<TsBedsResponse>(status: HttpStatus.networkConnectTimeoutError);
        }
        try {
          final errorJson = json.decode(response.body);
          return TsResponse<TsBedsResponse>(
            status: response.statusCode,
            message: errorJson['message'] ?? 'Error al crear la cama',
            error: errorJson['error'] ?? '',
          );
        } catch (e) {
          return TsResponse<TsBedsResponse>.createEmpty();
        }
      }
      final responseJson = json.decode(response.body);
      final modelData = TsBedsResponse.createEmpty().fromMap(responseJson['data']);
      return TsResponse<TsBedsResponse>(
        data: modelData,
        status: response.statusCode,
        message: responseJson['message'],
      );
    } catch (e) {
      return TsResponse<TsBedsResponse>(
        status: HttpStatus.internalServerError,
        message: 'Error durante la creación de la cama',
        error: e.toString(),
      );
    }
  }
/// ---------------------------------------------------------------------------
/// GET ALL BEDS
/// ----------------------------------------------------------------------------------------------------
  Future<TsResponse<TsBedsResponse>> getAllBeds() async{
    try {
      final response = await httpGet('$_baseUrl/beds', getHeaders());
      if (response.statusCode >= HttpStatus.badRequest) {
        if (response.statusCode == HttpStatus.networkConnectTimeoutError) {
          TsResponse<TsBedsResponse> responseData = TsResponse(status: HttpStatus.networkConnectTimeoutError);
          return responseData;
        }
        return TsResponse.createEmpty();
      }
      TsResponse<TsBedsResponse> responseData = TsResponse.fromJsonList(utf8.decode(response.bodyBytes), TsBedsResponse.createEmpty());
      return responseData;
    } catch (e) {
      return TsResponse.createEmpty();
    }
  }
///  ------------------------------------------------------------------------------------------------
/// GET BEDS By ROOM ID
/// ----------------------------------------------------------------------------------------------------
  Future<TsResponse<TsBedsResponse>> getBedssByRoom(int roomId) async{
    try{
      final response = await httpGet('$_baseUrl/beds/byRoom/$roomId', getHeaders());
      if (response.statusCode >= HttpStatus.badRequest) {
        if (response.statusCode == HttpStatus.networkConnectTimeoutError) {
          TsResponse<TsBedsResponse> responseData = TsResponse(status: HttpStatus.networkConnectTimeoutError);
          return responseData;
        }
        return TsResponse.createEmpty();
      }
      TsResponse<TsBedsResponse> responseData = TsResponse.fromJsonList(utf8.decode(response.bodyBytes), TsBedsResponse.createEmpty());
      return responseData;
    }catch(e){
      return TsResponse.createEmpty();
    }
  } 
///  ------------------------------------------------------------------------------------------------
/// UPDATE A BED
/// ----------------------------------------------------------------------------------------------------

  Future<TsResponse<TsBedsResponse>> updateBed(int bedId, TsBedsRequest bedRequest) async {
    try {
      final response = await httpPut('$_baseUrl/beds/$bedId', getHeaders(), jsonEncode(bedRequest.toJson()));
      if (response.statusCode >= HttpStatus.badRequest) {
        if (response.statusCode == HttpStatus.networkConnectTimeoutError) {
          return TsResponse<TsBedsResponse>(status: HttpStatus.networkConnectTimeoutError);
        }
        try {
          final errorJson = json.decode(response.body);
          return TsResponse<TsBedsResponse>(
            status: response.statusCode,
            message: errorJson['message'] ?? 'Error al actualizar la cama',
            error: errorJson['error'] ?? '',
          );
        } catch (e) {
          return TsResponse<TsBedsResponse>.createEmpty();
        }
      }
      final responseJson = json.decode(response.body);
      final bedData = TsBedsResponse.createEmpty().fromMap(responseJson['data']);
      return TsResponse<TsBedsResponse>(
        data: bedData,
        status: response.statusCode,
        message: responseJson['message'],
      );
    } catch (e) {
      return TsResponse<TsBedsResponse>(
        status: HttpStatus.internalServerError,
        message: 'Error durante la actualización de la cama',
        error: e.toString(),
      );
    }
  }
///  ------------------------------------------------------------------------------------------------
/// DELETE A BED
/// ----------------------------------------------------------------------------------------------------
  Future<TsResponse<TsBedsResponse>> deleteBed(int bedId) async {
    try {
      final response = await httpDelete('$_baseUrl/beds/$bedId', getHeaders());
      if (response.statusCode >= HttpStatus.badRequest) {
        if (response.statusCode == HttpStatus.networkConnectTimeoutError) {
          return TsResponse<TsBedsResponse>(status: HttpStatus.networkConnectTimeoutError);
        }
        try {
          final errorJson = json.decode(response.body);
          return TsResponse<TsBedsResponse>(
            status: response.statusCode,
            message: errorJson['message'] ?? 'Error al eliminar la cama',
            error: errorJson['error'] ?? '',
          );
        } catch (e) {
          return TsResponse<TsBedsResponse>.createEmpty();
        }
      }
      final responseJson = json.decode(response.body);
      final bedData = TsBedsResponse.createEmpty().fromMap(responseJson['data']);
      return TsResponse<TsBedsResponse>(
        data: bedData,
        status: response.statusCode,
        message: responseJson['message'],
      );
    } catch (e) {
      return TsResponse<TsBedsResponse>(
        status: HttpStatus.internalServerError,
        message: 'Error durante la eliminación de la cama',
        error: e.toString(),
      );
    }
  }
}