import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:tusalud/api/request/app/ts_bed_request.dart';
import 'package:tusalud/api/request/app/ts_diet_request.dart';
import 'package:tusalud/api/request/app/ts_gender_request.dart';
import 'package:tusalud/api/request/app/ts_kardex_request.dart';
import 'package:tusalud/api/request/app/ts_medication_kardex_request.dart';
import 'package:tusalud/api/request/app/ts_medication_request.dart';
import 'package:tusalud/api/request/app/ts_reports_request.dart';
import 'package:tusalud/api/request/app/ts_request_create_request.dart';
import 'package:tusalud/api/request/app/ts_role_request.dart';
import 'package:tusalud/api/request/app/ts_room_request.dart';
import 'package:tusalud/api/request/app/ts_vital_signs_request.dart';
import 'package:tusalud/api/request/auth/ts_person_request.dart';

import 'package:tusalud/api/request/auth/ts_auth_request.dart';
import 'package:tusalud/api/response/app/ts_bed_response.dart';
import 'package:tusalud/api/response/app/ts_diet_response.dart';
import 'package:tusalud/api/response/app/ts_gender_response.dart';
import 'package:tusalud/api/response/app/ts_kardex_medicine_response.dart';
import 'package:tusalud/api/response/app/ts_kardex_response.dart';
import 'package:tusalud/api/response/app/ts_medication_response.dart';
import 'package:tusalud/api/response/app/ts_register_user_admin_response.dart';
import 'package:tusalud/api/response/app/ts_reports_response.dart';
import 'package:tusalud/api/response/app/ts_role_response.dart';
import 'package:tusalud/api/response/app/ts_room_response.dart';
import 'package:tusalud/api/response/app/ts_via_response.dart';
import 'package:tusalud/api/response/app/ts_vital_signs_response.dart';
import 'package:tusalud/api/response/ts_response.dart';
import 'package:tusalud/config/enviroment.dart';
import '../config/preferences.dart';
import 'request/app/ts_via_request.dart';
import 'request/auth/ts_register_user_admin_request.dart';
import 'request/auth/ts_token_request.dart';
import 'response/app/ts_patient_info_response.dart';
import 'response/app/ts_people_response.dart';
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
/// 
/// 
Future<TsResponse<TsPeopleResponse>> createPatient(
  TsPatientCreateRequest request,
) async {
  try {
    final response = await httpPost(
      '$_baseUrl/persons/create',
      getHeaders(),
      jsonEncode(request.toJson()),
    );

    if (response.statusCode >= HttpStatus.badRequest) {
      final errorJson = json.decode(response.body);
      return TsResponse<TsPeopleResponse>(
        status: response.statusCode,
        message: errorJson['message'] ?? 'Error al crear paciente',
        error: errorJson['error'] ?? '',
      );
    }

    final responseJson = json.decode(response.body);
    final personData = TsPeopleResponse.createEmpty().fromMap(
      Map<String, dynamic>.from(responseJson['data']),
    );

    return TsResponse<TsPeopleResponse>(
      data: personData,
      status: response.statusCode,
      message: responseJson['message'],
    );
  } catch (e) {
    return TsResponse<TsPeopleResponse>(
      status: HttpStatus.internalServerError,
      message: 'Error inesperado al procesar la respuesta',
      error: e.toString(),
    );
  }
}

///-----------------------------------------------------------------------------
// CREATE A PERSON
/// ----------------------------------------------------------------------------------------------------
Future<TsResponse<TsPeopleResponse>> registerUser(TsPersonRequest personRequest) async {
  try {
    final response = await httpPost(
      '$_baseUrl/persons/create',
      getHeaders(),
      jsonEncode(personRequest.toJson()),
    );

    // 🔹 Si hubo error HTTP
    if (response.statusCode >= HttpStatus.badRequest) {
      final errorJson = json.decode(response.body);
      return TsResponse<TsPeopleResponse>(
        status: response.statusCode,
        message: errorJson['message'] ?? 'Error al crear la persona',
        error: errorJson['error'] ?? '',
      );
    }

    // 🔹 Procesar respuesta en caso de éxito
    final responseJson = json.decode(response.body);

    final personData = TsPeopleResponse.createEmpty().fromMap(
      Map<String, dynamic>.from(responseJson['data']),
    );

    return TsResponse<TsPeopleResponse>(
      data: personData,
      status: response.statusCode,
      message: responseJson['message'],
    );
  } catch (e) {
    return TsResponse<TsPeopleResponse>(
      status: HttpStatus.internalServerError,
      message: 'Error inesperado al procesar la respuesta',
      error: e.toString(),
    );
  }
}

Future<TsResponse<TsPeopleResponse>> getPatientsByRoom(int roomId) async {
  try {
    final response = await httpGet(
      '$_baseUrl/persons/rooms/$roomId/patients',
      getHeaders(),
    );

    if (response.statusCode >= HttpStatus.badRequest) {
      final errorJson = json.decode(response.body);
      return TsResponse<TsPeopleResponse>(
        status: response.statusCode,
        message: errorJson['message'] ?? 'Error al obtener pacientes por sala',
        error: errorJson['error'] ?? '',
      );
    }

    final responseJson = json.decode(response.body);
    final List<dynamic> list = responseJson['data'] ?? [];

    final patients = list
        .map((e) => TsPeopleResponse.createEmpty().fromMap(
              Map<String, dynamic>.from(e),
            ))
        .toList();

    return TsResponse<TsPeopleResponse>(
      dataList: patients,
      status: response.statusCode,
      message: responseJson['message'] ?? 'OK',
    );
  } catch (e) {
    return TsResponse<TsPeopleResponse>(
      status: HttpStatus.internalServerError,
      message: 'Error inesperado al obtener pacientes por sala',
      error: e.toString(),
    );
  }
}
// ------------------------------------------------------------------------------------------------
/// REGISTER USER ADMIN (PERSON + ACCOUNT)
/// ------------------------------------------------------------------------------------------------
/// 🔹 Registrar usuario (person + account)
  Future<TsResponse<TsRegisterUserAdminResponse>> registerAdminUser(TsRegisterUserAdminRequest request) async {
      try {
        final response = await httpPost(
          "$_baseUrl/users/register",
          getHeaders(),
          request.toJson(),
        );
  
        if (response.statusCode >= HttpStatus.badRequest) {
          final errorJson = json.decode(response.body);
          return TsResponse<TsRegisterUserAdminResponse>(
            status: response.statusCode,
            message: errorJson['message'] ?? 'Error al registrar usuario',
            error: errorJson['error'] ?? '',
          );
        }
  
        final responseJson = json.decode(response.body);
  
        final userData = TsRegisterUserAdminResponse.createEmpty().fromMap(
          Map<String, dynamic>.from(responseJson['data']),
        );
  
        return TsResponse<TsRegisterUserAdminResponse>(
          data: userData,
          status: response.statusCode,
          message: responseJson['message'] ?? "Registro exitoso",
        );
      } catch (e) {
        return TsResponse<TsRegisterUserAdminResponse>(
          status: HttpStatus.internalServerError,
          message: "Error inesperado al registrar usuario",
          error: e.toString(),
        );
      }
    }
 
  /// ------------------------------------------------------------------------------------------------
  /// GET PEOPLE BY ROLE
  /// ------------------------------------------------------------------------------------------------
  Future<TsResponse<TsPeopleResponse>> getPeopleByRole(int roleId) async {
    try {
      final response = await httpGet('$_baseUrl/persons/role/$roleId', getHeaders());
      if (response.statusCode >= HttpStatus.badRequest) {
        if (response.statusCode == HttpStatus.networkConnectTimeoutError) {
          return TsResponse<TsPeopleResponse>(status: HttpStatus.networkConnectTimeoutError);
        }
        return TsResponse.createEmpty();
      }
      TsResponse<TsPeopleResponse> responseData =
          TsResponse.fromJsonList(utf8.decode(response.bodyBytes), TsPeopleResponse.createEmpty());
      return responseData;
    } catch (e) {
      return TsResponse.createEmpty();
    }
  }
  /// ------------------------------------------------------------------------------------------------
  /// GET ALL PATIENTS
  /// ------------------------------------------------------------------------------------------------
Future<TsResponse<TsPeopleResponse>> getAllPatients() async {
  try {
    // 🔹 roleId = 4 para pacientes
    final response = await httpGet('$_baseUrl/persons/role/4', getHeaders());

    if (response.statusCode >= HttpStatus.badRequest) {
      return TsResponse.createEmpty();
    }

    return TsResponse.fromJsonList(
      utf8.decode(response.bodyBytes),
      TsPeopleResponse.createEmpty(),
    );
  } catch (e) {
    return TsResponse.createEmpty();
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
      final response = await httpGet('$_baseUrl/gender/all', getHeaders());
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
      final response = await httpGet('$_baseUrl/roles/all', getHeaders());
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
      final response = await httpGet('$_baseUrl/rooms/all', getHeaders());
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
      final response = await httpPut('$_baseUrl/rooms/update/$roomId', getHeaders(), jsonEncode(roomRequest.toJson()));
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
      final response = await httpDelete('$_baseUrl/rooms/delete/$roomId', getHeaders());
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
      final response = await httpPost('$_baseUrl/bed/create', getHeaders(), jsonEncode(bedRequest.toJson()));
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
      final response = await httpGet('$_baseUrl/bed/all', getHeaders());
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
  Future<TsResponse<TsBedsResponse>> getBedsByRoom(int roomId) async{
    try{
      final response = await httpGet('$_baseUrl/bed/room/$roomId', getHeaders());
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
      final response = await httpPut('$_baseUrl/bed/update/$bedId', getHeaders(), jsonEncode(bedRequest.toJson()));
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
      final response = await httpDelete('$_baseUrl/bed/delete/$bedId', getHeaders());
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
  /// ------------------------------------------------------------------------------------------------
  /// VIA SECTION (MEDICATION ADMINISTRATION ROUTE)
  ///  ------------------------------------------------------------------------------------------------ 
  
    /// CREATE VIA
  Future<TsResponse<TsViaResponse>> createVia(TsViaRequest viaRequest) async {
    try {
      final response = await httpPost(
        '$_baseUrl/via/create',
        getHeaders(),
        jsonEncode(viaRequest.toJson()),
      );

      if (response.statusCode >= HttpStatus.badRequest) {
        if (response.statusCode == HttpStatus.networkConnectTimeoutError) {
          return TsResponse<TsViaResponse>(
            status: HttpStatus.networkConnectTimeoutError,
          );
        }
        try {
          final errorJson = json.decode(response.body);
          return TsResponse<TsViaResponse>(
            status: response.statusCode,
            message: errorJson['message'] ?? 'Error al crear la vía',
            error: errorJson['error'] ?? '',
          );
        } catch (_) {
          return TsResponse<TsViaResponse>.createEmpty();
        }
      }

      final responseJson = json.decode(response.body);
      final viaData =
          TsViaResponse.createEmpty().fromMap(responseJson['data']);
      return TsResponse<TsViaResponse>(
        data: viaData,
        status: response.statusCode,
        message: responseJson['message'],
      );
    } catch (e) {
      return TsResponse<TsViaResponse>(
        status: HttpStatus.internalServerError,
        message: 'Error durante la creación de la vía',
        error: e.toString(),
      );
    }
  }

  /// GET ALL VIAS
  Future<TsResponse<TsViaResponse>> getAllVias() async {
    try {
      final response = await httpGet('$_baseUrl/via/all', getHeaders());

      if (response.statusCode >= HttpStatus.badRequest) {
        if (response.statusCode == HttpStatus.networkConnectTimeoutError) {
          return TsResponse<TsViaResponse>(
            status: HttpStatus.networkConnectTimeoutError,
          );
        }
        return TsResponse.createEmpty();
      }

      return TsResponse.fromJsonList(
        utf8.decode(response.bodyBytes),
        TsViaResponse.createEmpty(),
      );
    } catch (_) {
      return TsResponse.createEmpty();
    }
  }

  /// GET VIA BY ID
  Future<TsResponse<TsViaResponse>> getVia(int viaId) async {
    try {
      final response = await httpGet('$_baseUrl/via/$viaId', getHeaders());

      if (response.statusCode >= HttpStatus.badRequest) {
        if (response.statusCode == HttpStatus.networkConnectTimeoutError) {
          return TsResponse<TsViaResponse>(
            status: HttpStatus.networkConnectTimeoutError,
          );
        }
        return TsResponse.createEmpty();
      }

      return TsResponse.fromJson(
        utf8.decode(response.bodyBytes),
      );
    } catch (_) {
      return TsResponse.createEmpty();
    }
  }

  /// UPDATE VIA
  Future<TsResponse<TsViaResponse>> updateVia(
      int viaId, TsViaRequest viaRequest) async {
    try {
      final response = await httpPut(
        '$_baseUrl/via/update/$viaId',
        getHeaders(),
        jsonEncode(viaRequest.toJson()),
      );

      if (response.statusCode >= HttpStatus.badRequest) {
        if (response.statusCode == HttpStatus.networkConnectTimeoutError) {
          return TsResponse<TsViaResponse>(
            status: HttpStatus.networkConnectTimeoutError,
          );
        }
        try {
          final errorJson = json.decode(response.body);
          return TsResponse<TsViaResponse>(
            status: response.statusCode,
            message: errorJson['message'] ?? 'Error al actualizar la vía',
            error: errorJson['error'] ?? '',
          );
        } catch (_) {
          return TsResponse<TsViaResponse>.createEmpty();
        }
      }

      final responseJson = json.decode(response.body);
      final viaData =
          TsViaResponse.createEmpty().fromMap(responseJson['data']);
      return TsResponse<TsViaResponse>(
        data: viaData,
        status: response.statusCode,
        message: responseJson['message'],
      );
    } catch (e) {
      return TsResponse<TsViaResponse>(
        status: HttpStatus.internalServerError,
        message: 'Error durante la actualización de la vía',
        error: e.toString(),
      );
    }
  }

  /// DELETE VIA
  Future<TsResponse<TsViaResponse>> deleteVia(int viaId) async {
    try {
      final response = await httpDelete('$_baseUrl/via/delete/$viaId', getHeaders());

      if (response.statusCode >= HttpStatus.badRequest) {
        if (response.statusCode == HttpStatus.networkConnectTimeoutError) {
          return TsResponse<TsViaResponse>(
            status: HttpStatus.networkConnectTimeoutError,
          );
        }
        try {
          final errorJson = json.decode(response.body);
          return TsResponse<TsViaResponse>(
            status: response.statusCode,
            message: errorJson['message'] ?? 'Error al eliminar la vía',
            error: errorJson['error'] ?? '',
          );
        } catch (_) {
          return TsResponse<TsViaResponse>.createEmpty();
        }
      }

      final responseJson = json.decode(response.body);
      final viaData =
          TsViaResponse.createEmpty().fromMap(responseJson['data']);
      return TsResponse<TsViaResponse>(
        data: viaData,
        status: response.statusCode,
        message: responseJson['message'],
      );
    } catch (e) {
      return TsResponse<TsViaResponse>(
        status: HttpStatus.internalServerError,
        message: 'Error durante la eliminación de la vía',
        error: e.toString(),
      );
    }
  }
/// ------------------------------------------------------------------------------------------------
/// DIET SECTION (DIETS MANAGEMENT)
/// ------------------------------------------------------------------------------------------------

  /// CREATE DIET
  Future<TsResponse<TsDietResponse>> createDiet(TsDietRequest dietRequest) async {
    try {
      final response = await httpPost(
        '$_baseUrl/diets/create',
        getHeaders(),
        jsonEncode(dietRequest.toJson()),
      );

      if (response.statusCode >= HttpStatus.badRequest) {
        if (response.statusCode == HttpStatus.networkConnectTimeoutError) {
          return TsResponse<TsDietResponse>(
            status: HttpStatus.networkConnectTimeoutError,
          );
        }
        try {
          final errorJson = json.decode(response.body);
          return TsResponse<TsDietResponse>(
            status: response.statusCode,
            message: errorJson['message'] ?? 'Error al crear la dieta',
            error: errorJson['error'] ?? '',
          );
        } catch (_) {
          return TsResponse<TsDietResponse>.createEmpty();
        }
      }

      final responseJson = json.decode(response.body);
      final dietData =
          TsDietResponse.createEmpty().fromMap(responseJson['data']);
      return TsResponse<TsDietResponse>(
        data: dietData,
        status: response.statusCode,
        message: responseJson['message'],
      );
    } catch (e) {
      return TsResponse<TsDietResponse>(
        status: HttpStatus.internalServerError,
        message: 'Error durante la creación de la dieta',
        error: e.toString(),
      );
    }
  }

  /// GET ALL DIETS
  Future<TsResponse<TsDietResponse>> getAllDiets() async {
    try {
      final response = await httpGet('$_baseUrl/diets/all', getHeaders());

      if (response.statusCode >= HttpStatus.badRequest) {
        if (response.statusCode == HttpStatus.networkConnectTimeoutError) {
          return TsResponse<TsDietResponse>(
            status: HttpStatus.networkConnectTimeoutError,
          );
        }
        return TsResponse.createEmpty();
      }

      return TsResponse.fromJsonList(
        utf8.decode(response.bodyBytes),
        TsDietResponse.createEmpty(),
      );
    } catch (_) {
      return TsResponse.createEmpty();
    }
  }

  /// GET DIET BY ID
  Future<TsResponse<TsDietResponse>> getDiet(int dietId) async {
    try {
      final response = await httpGet('$_baseUrl/diets/$dietId', getHeaders());

      if (response.statusCode >= HttpStatus.badRequest) {
        if (response.statusCode == HttpStatus.networkConnectTimeoutError) {
          return TsResponse<TsDietResponse>(
            status: HttpStatus.networkConnectTimeoutError,
          );
        }
        return TsResponse.createEmpty();
      }

      return TsResponse.fromJson(
        utf8.decode(response.bodyBytes),
      );
    } catch (_) {
      return TsResponse.createEmpty();
    }
  }

  /// UPDATE DIET
  Future<TsResponse<TsDietResponse>> updateDiet(
      int dietId, TsDietRequest dietRequest) async {
    try {
      final response = await httpPut(
        '$_baseUrl/diets/update/$dietId',
        getHeaders(),
        jsonEncode(dietRequest.toJson()),
      );

      if (response.statusCode >= HttpStatus.badRequest) {
        if (response.statusCode == HttpStatus.networkConnectTimeoutError) {
          return TsResponse<TsDietResponse>(
            status: HttpStatus.networkConnectTimeoutError,
          );
        }
        try {
          final errorJson = json.decode(response.body);
          return TsResponse<TsDietResponse>(
            status: response.statusCode,
            message: errorJson['message'] ?? 'Error al actualizar la dieta',
            error: errorJson['error'] ?? '',
          );
        } catch (_) {
          return TsResponse<TsDietResponse>.createEmpty();
        }
      }

      final responseJson = json.decode(response.body);
      final dietData =
          TsDietResponse.createEmpty().fromMap(responseJson['data']);
      return TsResponse<TsDietResponse>(
        data: dietData,
        status: response.statusCode,
        message: responseJson['message'],
      );
    } catch (e) {
      return TsResponse<TsDietResponse>(
        status: HttpStatus.internalServerError,
        message: 'Error durante la actualización de la dieta',
        error: e.toString(),
      );
    }
  }

  /// DELETE DIET
  Future<TsResponse<TsDietResponse>> deleteDiet(int dietId) async {
    try {
      final response =
          await httpDelete('$_baseUrl/diets/delete/$dietId', getHeaders());

      if (response.statusCode >= HttpStatus.badRequest) {
        if (response.statusCode == HttpStatus.networkConnectTimeoutError) {
          return TsResponse<TsDietResponse>(
            status: HttpStatus.networkConnectTimeoutError,
          );
        }
        try {
          final errorJson = json.decode(response.body);
          return TsResponse<TsDietResponse>(
            status: response.statusCode,
            message: errorJson['message'] ?? 'Error al eliminar la dieta',
            error: errorJson['error'] ?? '',
          );
        } catch (_) {
          return TsResponse<TsDietResponse>.createEmpty();
        }
      }

      final responseJson = json.decode(response.body);
      final dietData =
          TsDietResponse.createEmpty().fromMap(responseJson['data']);
      return TsResponse<TsDietResponse>(
        data: dietData,
        status: response.statusCode,
        message: responseJson['message'],
      );
    } catch (e) {
      return TsResponse<TsDietResponse>(
        status: HttpStatus.internalServerError,
        message: 'Error durante la eliminación de la dieta',
        error: e.toString(),
      );
    }
  }
/// ------------------------------------------------------------------------------------------------
/// MEDICINE SECTION
/// ------------------------------------------------------------------------------------------------

/// CREATE MEDICINE
Future<TsResponse<TsMedicineResponse>> createMedicine(
    TsMedicineRequest medicineRequest) async {
  try {
    final response = await httpPost(
      '$_baseUrl/medicine/create',
      getHeaders(),
      jsonEncode(medicineRequest.toJson()),
    );

    if (response.statusCode >= HttpStatus.badRequest) {
      if (response.statusCode == HttpStatus.networkConnectTimeoutError) {
        return TsResponse<TsMedicineResponse>(
          status: HttpStatus.networkConnectTimeoutError,
        );
      }
      try {
        final errorJson = json.decode(response.body);
        return TsResponse<TsMedicineResponse>(
          status: response.statusCode,
          message: errorJson['message'] ?? 'Error al crear el medicamento',
          error: errorJson['error'] ?? '',
        );
      } catch (_) {
        return TsResponse<TsMedicineResponse>.createEmpty();
      }
    }

    final responseJson = json.decode(response.body);
    final medData =
        TsMedicineResponse.createEmpty().fromMap(responseJson['data']);
    return TsResponse<TsMedicineResponse>(
      data: medData,
      status: response.statusCode,
      message: responseJson['message'],
    );
  } catch (e) {
    return TsResponse<TsMedicineResponse>(
      status: HttpStatus.internalServerError,
      message: 'Error durante la creación del medicamento',
      error: e.toString(),
    );
  }
}

/// GET ALL MEDICINES
Future<TsResponse<TsMedicineResponse>> getAllMedicines() async {
  try {
    final response = await httpGet('$_baseUrl/medicine/all', getHeaders());

    if (response.statusCode >= HttpStatus.badRequest) {
      if (response.statusCode == HttpStatus.networkConnectTimeoutError) {
        return TsResponse<TsMedicineResponse>(
          status: HttpStatus.networkConnectTimeoutError,
        );
      }
      return TsResponse.createEmpty();
    }

    return TsResponse.fromJsonList(
      utf8.decode(response.bodyBytes),
      TsMedicineResponse.createEmpty(),
    );
  } catch (_) {
    return TsResponse.createEmpty();
  }
}

/// GET MEDICINE BY ID
Future<TsResponse<TsMedicineResponse>> getMedicine(int medicineId) async {
  try {
    final response =
        await httpGet('$_baseUrl/medicine/$medicineId', getHeaders());

    if (response.statusCode >= HttpStatus.badRequest) {
      if (response.statusCode == HttpStatus.networkConnectTimeoutError) {
        return TsResponse<TsMedicineResponse>(
          status: HttpStatus.networkConnectTimeoutError,
        );
      }
      return TsResponse.createEmpty();
    }

    return TsResponse.fromJson(
      utf8.decode(response.bodyBytes),
    );
  } catch (_) {
    return TsResponse.createEmpty();
  }
}

/// UPDATE MEDICINE
Future<TsResponse<TsMedicineResponse>> updateMedicine(
    int medicineId, TsMedicineRequest medicineRequest) async {
  try {
    final response = await httpPut(
      '$_baseUrl/medicine/update/$medicineId',
      getHeaders(),
      jsonEncode(medicineRequest.toJson()),
    );

    if (response.statusCode >= HttpStatus.badRequest) {
      if (response.statusCode == HttpStatus.networkConnectTimeoutError) {
        return TsResponse<TsMedicineResponse>(
          status: HttpStatus.networkConnectTimeoutError,
        );
      }
      try {
        final errorJson = json.decode(response.body);
        return TsResponse<TsMedicineResponse>(
          status: response.statusCode,
          message: errorJson['message'] ?? 'Error al actualizar el medicamento',
          error: errorJson['error'] ?? '',
        );
      } catch (_) {
        return TsResponse<TsMedicineResponse>.createEmpty();
      }
    }

    final responseJson = json.decode(response.body);
    final medData =
        TsMedicineResponse.createEmpty().fromMap(responseJson['data']);
    return TsResponse<TsMedicineResponse>(
      data: medData,
      status: response.statusCode,
      message: responseJson['message'],
    );
  } catch (e) {
    return TsResponse<TsMedicineResponse>(
      status: HttpStatus.internalServerError,
      message: 'Error durante la actualización del medicamento',
      error: e.toString(),
    );
  }
}

/// DELETE MEDICINE
Future<TsResponse<TsMedicineResponse>> deleteMedicine(int medicineId) async {
  try {
    final response =
        await httpDelete('$_baseUrl/medicine/delete/$medicineId', getHeaders());

    if (response.statusCode >= HttpStatus.badRequest) {
      if (response.statusCode == HttpStatus.networkConnectTimeoutError) {
        return TsResponse<TsMedicineResponse>(
          status: HttpStatus.networkConnectTimeoutError,
        );
      }
      try {
        final errorJson = json.decode(response.body);
        return TsResponse<TsMedicineResponse>(
          status: response.statusCode,
          message: errorJson['message'] ?? 'Error al eliminar el medicamento',
          error: errorJson['error'] ?? '',
        );
      } catch (_) {
        return TsResponse<TsMedicineResponse>.createEmpty();
      }
    }

    final responseJson = json.decode(response.body);
    final medData =
        TsMedicineResponse.createEmpty().fromMap(responseJson['data']);
    return TsResponse<TsMedicineResponse>(
      data: medData,
      status: response.statusCode,
      message: responseJson['message'],
    );
  } catch (e) {
    return TsResponse<TsMedicineResponse>(
      status: HttpStatus.internalServerError,
      message: 'Error durante la eliminación del medicamento',
      error: e.toString(),
    );
  }
}
/// ------------------------------------------------------------------------------------------------
/// KARDEX SECTION 
/// ------------------------------------------------------------------------------------------------
  ///Get kardexby parsonId and rolebyid
  
/// GET KARDEX BY PATIENT + ROLE
Future<TsResponse<TsKardexResponse>> getKardexByPatientAndRole(
  int patientId, 
  int roleId,
) async {
  try {
    final response = await httpGet(
      '$_baseUrl/kardex/patient/$patientId/role/$roleId',
      getHeaders(),
    );

    // Si viene error (>=400), devolvemos TsResponse con status y lista vacía
    if (response.statusCode >= HttpStatus.badRequest) {
      // Intentamos leer el message del backend (aunque no lo uses para UI)
      String? backendMessage;
      try {
        final Map<String, dynamic> jsonBody =
            jsonDecode(utf8.decode(response.bodyBytes));
        backendMessage = jsonBody['message']?.toString();
      } catch (_) {}

      return TsResponse<TsKardexResponse>(
        status: response.statusCode,           // 👈 importante
        message: backendMessage,               // opcional
        dataList: const [],                    // 👈 vacío para provider
      );
    }

    // OK 2xx
    return TsResponse.fromJsonList(
      utf8.decode(response.bodyBytes),
      TsKardexResponse.createEmpty(),
    );
  } catch (_) {
    return TsResponse<TsKardexResponse>(
      status: HttpStatus.internalServerError,  // 👈 distingue error real
      message: 'Error de conexión',
      dataList: const [],
    );
  }
}
// ----------------------------------------------------------------
// GET KARDEX BY PATIENT ID (ROLE ID = 4 for patients)
// ----------------------------------------------------------------
Future<TsResponse<TsKardexResponse>> getKardexByPatientId(int patientId) async {
  try {
    final response = await httpGet(
      '$_baseUrl/kardex/patient/$patientId/role/4', // roleId=4 (paciente)
      getHeaders(),
    );

    if (response.statusCode >= HttpStatus.badRequest) {
      return TsResponse.createEmpty();
    }

    return TsResponse.fromJsonList(
      utf8.decode(response.bodyBytes),
      TsKardexResponse.createEmpty(),
    );
  } catch (_) {
    return TsResponse.createEmpty();
  }
}


// info paciente
// GET PATIENT INFO BY KARDEX ID
Future<TsResponse<TsPatientInfoResponse>> getPatientInfoByKardexId(int kardexId) async {
  try {
    final resp = await httpGet('$_baseUrl/kardex/$kardexId/patient-info', getHeaders());

    if (resp.statusCode >= HttpStatus.badRequest) {
      return TsResponse.createEmpty();
    }

    final decoded = jsonDecode(utf8.decode(resp.bodyBytes));
    final dataMap = (decoded['data'] as Map?)?.cast<String, dynamic>();

    final model = dataMap != null
        ? TsPatientInfoResponse.fromJson(dataMap)
        : TsPatientInfoResponse.createEmpty();

    return TsResponse<TsPatientInfoResponse>(
      status: decoded['status'] as int? ?? 200,
      message: decoded['message'] as String? ?? 'OK',
      data: model,
    );
  } catch (e) {
    print('Error getPatientInfoByKardexId: $e');
    return TsResponse.createEmpty();
  }
}



Future<TsResponse<TsPeopleResponse>> getAllPatientsByRole() async {
  try {
    final response = await httpGet('$_baseUrl/persons/role/4', getHeaders());

    if (response.statusCode >= HttpStatus.badRequest) {
      return TsResponse.createEmpty();
    }

    return TsResponse.fromJsonList(
      utf8.decode(response.bodyBytes),
      TsPeopleResponse.createEmpty(),
    );
  } catch (_) {
    return TsResponse.createEmpty();
  }
}




  /// CREATE KARDEX
  Future<TsResponse<TsKardexResponse>> createKardex(
      TsKardexRequest kardexRequest) async {
    try {
      final response = await httpPost(
        '$_baseUrl/kardex/create',
        getHeaders(),
        jsonEncode(kardexRequest.toJson()),
      );

      if (response.statusCode >= HttpStatus.badRequest) {
        if (response.statusCode == HttpStatus.networkConnectTimeoutError) {
          return TsResponse<TsKardexResponse>(
            status: HttpStatus.networkConnectTimeoutError,
          );
        }
        try {
          final errorJson = json.decode(response.body);
          return TsResponse<TsKardexResponse>(
            status: response.statusCode,
            message: errorJson['message'] ?? 'Error al crear el kardex',
            error: errorJson['error'] ?? '',
          );
        } catch (_) {
          return TsResponse<TsKardexResponse>.createEmpty();
        }
      }

      final responseJson = json.decode(response.body);
      final kardexData =
          TsKardexResponse.createEmpty().fromMap(responseJson['data']);
      return TsResponse<TsKardexResponse>(
        data: kardexData,
        status: response.statusCode,
        message: responseJson['message'],
      );
    } catch (e) {
      return TsResponse<TsKardexResponse>(
        status: HttpStatus.internalServerError,
        message: 'Error durante la creación del kardex',
        error: e.toString(),
      );
    }
  }

  /// GET ALL KARDEX
  Future<TsResponse<TsKardexResponse>> getAllKardex() async {
    try {
      final response = await httpGet('$_baseUrl/kardex/all', getHeaders());

      if (response.statusCode >= HttpStatus.badRequest) {
        if (response.statusCode == HttpStatus.networkConnectTimeoutError) {
          return TsResponse<TsKardexResponse>(
            status: HttpStatus.networkConnectTimeoutError,
          );
        }
        return TsResponse.createEmpty();
      }

      return TsResponse.fromJsonList(
        utf8.decode(response.bodyBytes),
        TsKardexResponse.createEmpty(),
      );
    } catch (_) {
      return TsResponse.createEmpty();
    }
  }

  /// GET KARDEX BY ID
  Future<TsResponse<TsKardexResponse>> getKardex(int kardexId) async {
    try {
      final response =
          await httpGet('$_baseUrl/kardex/$kardexId', getHeaders());

      if (response.statusCode >= HttpStatus.badRequest) {
        if (response.statusCode == HttpStatus.networkConnectTimeoutError) {
          return TsResponse<TsKardexResponse>(
            status: HttpStatus.networkConnectTimeoutError,
          );
        }
        return TsResponse.createEmpty();
      }

      return TsResponse.fromJson(
        utf8.decode(response.bodyBytes),
      );
    } catch (_) {
      return TsResponse.createEmpty();
    }
  }
  

  /// UPDATE KARDEX
  Future<TsResponse<TsKardexResponse>> updateKardex(
      int kardexId, TsKardexRequest kardexRequest) async {
    try {
      final response = await httpPut(
        '$_baseUrl/kardex/update/$kardexId',
        getHeaders(),
        jsonEncode(kardexRequest.toJson()),
      );

      if (response.statusCode >= HttpStatus.badRequest) {
        if (response.statusCode == HttpStatus.networkConnectTimeoutError) {
          return TsResponse<TsKardexResponse>(
            status: HttpStatus.networkConnectTimeoutError,
          );
        }
        try {
          final errorJson = json.decode(response.body);
          return TsResponse<TsKardexResponse>(
            status: response.statusCode,
            message: errorJson['message'] ?? 'Error al actualizar el kardex',
            error: errorJson['error'] ?? '',
          );
        } catch (_) {
          return TsResponse<TsKardexResponse>.createEmpty();
        }
      }

      final responseJson = json.decode(response.body);
      final kardexData =
          TsKardexResponse.createEmpty().fromMap(responseJson['data']);
      return TsResponse<TsKardexResponse>(
        data: kardexData,
        status: response.statusCode,
        message: responseJson['message'],
      );
    } catch (e) {
      return TsResponse<TsKardexResponse>(
        status: HttpStatus.internalServerError,
        message: 'Error durante la actualización del kardex',
        error: e.toString(),
      );
    }
  }

  /// DELETE KARDEX
  Future<TsResponse<TsKardexResponse>> deleteKardex(int kardexId) async {
    try {
      final response =
          await httpDelete('$_baseUrl/kardex/delete/$kardexId', getHeaders());

      if (response.statusCode >= HttpStatus.badRequest) {
        if (response.statusCode == HttpStatus.networkConnectTimeoutError) {
          return TsResponse<TsKardexResponse>(
            status: HttpStatus.networkConnectTimeoutError,
          );
        }
        try {
          final errorJson = json.decode(response.body);
          return TsResponse<TsKardexResponse>(
            status: response.statusCode,
            message: errorJson['message'] ?? 'Error al eliminar el kardex',
            error: errorJson['error'] ?? '',
          );
        } catch (_) {
          return TsResponse<TsKardexResponse>.createEmpty();
        }
      }

      final responseJson = json.decode(response.body);
      final kardexData =
          TsKardexResponse.createEmpty().fromMap(responseJson['data']);
      return TsResponse<TsKardexResponse>(
        data: kardexData,
        status: response.statusCode,
        message: responseJson['message'],
      );
    } catch (e) {
      return TsResponse<TsKardexResponse>(
        status: HttpStatus.internalServerError,
        message: 'Error durante la eliminación del kardex',
        error: e.toString(),
      );
    }
  }

  /// --------------------------------------------------------------------------------------------
/// MEDICATION SECTION (KardexMedicines)
/// --------------------------------------------------------------------------------------------

/// GET ALL MEDICATIONS
Future<TsResponse<TsMedicationKardexResponse>> getAllMedications() async {
  try {
    final response = await httpGet('$_baseUrl/kardex-medicines/all', getHeaders());

    if (response.statusCode >= HttpStatus.badRequest) {
      return TsResponse.createEmpty();
    }

    return TsResponse.fromJsonList(
      utf8.decode(response.bodyBytes),
      TsMedicationKardexResponse.createEmpty(),
    );
  } catch (_) {
    return TsResponse.createEmpty();
  }
}

/// GET MEDICATION BY ID
Future<TsResponse<TsMedicationKardexResponse>> getMedication(int id) async {
  try {
    final response = await httpGet('$_baseUrl/kardex-medicines/$id', getHeaders());

    if (response.statusCode >= HttpStatus.badRequest) {
      return TsResponse.createEmpty();
    }

    return TsResponse.fromJson(
      utf8.decode(response.bodyBytes),
    );
  } catch (_) {
    return TsResponse.createEmpty();
  }
}

/// GET MEDICATIONS BY KARDEX ID
Future<TsResponse<TsMedicationKardexResponse>> getMedicationsByKardex(int kardexId) async {
  try {
    final response = await httpGet('$_baseUrl/kardex-medicines/by-kardex/$kardexId', getHeaders());

    if (response.statusCode >= HttpStatus.badRequest) {
      return TsResponse.createEmpty();
    }

    return TsResponse.fromJsonList(
      utf8.decode(response.bodyBytes),
      TsMedicationKardexResponse.createEmpty(),
    );
  } catch (_) {
    return TsResponse.createEmpty();
  }
}

/// CREATE MEDICATION
Future<TsResponse<TsMedicationKardexResponse>> createMedication(
    TsMedicationKardexRequest request) async {
  try {
    final response = await httpPost(
      '$_baseUrl/kardex-medicines/create',
      getHeaders(),
      jsonEncode(request.toJson()),
    );

    if (response.statusCode >= HttpStatus.badRequest) {
      try {
        final errorJson = json.decode(response.body);
        return TsResponse<TsMedicationKardexResponse>(
          status: response.statusCode,
          message: errorJson['message'] ?? 'Error al crear la medicación',
          error: errorJson['error'] ?? '',
        );
      } catch (_) {
        return TsResponse<TsMedicationKardexResponse>.createEmpty();
      }
    }

    final responseJson = json.decode(response.body);
    final medData = TsMedicationKardexResponse.createEmpty().fromMap(responseJson['data']);
    return TsResponse<TsMedicationKardexResponse>(
      data: medData,
      status: response.statusCode,
      message: responseJson['message'],
    );
  } catch (e) {
    return TsResponse<TsMedicationKardexResponse>(
      status: HttpStatus.internalServerError,
      message: 'Error durante la creación de la medicación',
      error: e.toString(),
    );
  }
}

/// UPDATE MEDICATION
Future<TsResponse<TsMedicationKardexResponse>> updateMedication(
    int id, TsMedicationKardexRequest request) async {
  try {
    final response = await httpPut(
      '$_baseUrl/kardex-medicines/update/$id',
      getHeaders(),
      jsonEncode(request.toJson()),
    );

    if (response.statusCode >= HttpStatus.badRequest) {
      try {
        final errorJson = json.decode(response.body);
        return TsResponse<TsMedicationKardexResponse>(
          status: response.statusCode,
          message: errorJson['message'] ?? 'Error al actualizar la medicación',
          error: errorJson['error'] ?? '',
        );
      } catch (_) {
        return TsResponse<TsMedicationKardexResponse>.createEmpty();
      }
    }

    final responseJson = json.decode(response.body);
    final medData = TsMedicationKardexResponse.createEmpty().fromMap(responseJson['data']);
    return TsResponse<TsMedicationKardexResponse>(
      data: medData,
      status: response.statusCode,
      message: responseJson['message'],
    );
  } catch (e) {
    return TsResponse<TsMedicationKardexResponse>(
      status: HttpStatus.internalServerError,
      message: 'Error durante la actualización de la medicación',
      error: e.toString(),
    );
  }
}

/// DELETE MEDICATION
Future<TsResponse<TsMedicationKardexResponse>> deleteMedication(int id) async {
  try {
    final response = await httpDelete('$_baseUrl/kardex-medicines/delete/$id', getHeaders());

    if (response.statusCode >= HttpStatus.badRequest) {
      try {
        final errorJson = json.decode(response.body);
        return TsResponse<TsMedicationKardexResponse>(
          status: response.statusCode,
          message: errorJson['message'] ?? 'Error al eliminar la medicación',
          error: errorJson['error'] ?? '',
        );
      } catch (_) {
        return TsResponse<TsMedicationKardexResponse>.createEmpty();
      }
    }

    final responseJson = json.decode(response.body);
    final medData = TsMedicationKardexResponse.createEmpty().fromMap(responseJson['data']);
    return TsResponse<TsMedicationKardexResponse>(
      data: medData,
      status: response.statusCode,
      message: responseJson['message'],
    );
  } catch (e) {
    return TsResponse<TsMedicationKardexResponse>(
      status: HttpStatus.internalServerError,
      message: 'Error durante la eliminación de la medicación',
      error: e.toString(),
    );
  }
}

  /// ----------------------------------------------------------------------------------------------------
/// CREATE VITAL SIGN
/// ----------------------------------------------------------------------------------------------------
Future<TsResponse<TsVitalSignsResponse>> createVitalSign(
    TsVitalSignsRequest request) async {
  try {
    final response = await httpPost(
      '$_baseUrl/vitalSigns/create',
      getHeaders(),
      jsonEncode(request.toJson()),
    );

    if (response.statusCode >= HttpStatus.badRequest) {
      if (response.statusCode == HttpStatus.networkConnectTimeoutError) {
        return TsResponse<TsVitalSignsResponse>(
          status: HttpStatus.networkConnectTimeoutError,
        );
      }
      try {
        final errorJson = json.decode(response.body);
        return TsResponse<TsVitalSignsResponse>(
          status: response.statusCode,
          message: errorJson['message'] ?? 'Error al crear el signo vital',
          error: errorJson['error'] ?? '',
        );
      } catch (e) {
        return TsResponse<TsVitalSignsResponse>.createEmpty();
      }
    }

    final responseJson = json.decode(response.body);
    final modelData = TsVitalSignsResponse.createEmpty()
        .fromMap(responseJson['data']);
    return TsResponse<TsVitalSignsResponse>(
      data: modelData,
      status: response.statusCode,
      message: responseJson['message'],
    );
  } catch (e) {
    return TsResponse<TsVitalSignsResponse>(
      status: HttpStatus.internalServerError,
      message: 'Error durante la creación del signo vital',
      error: e.toString(),
    );
  }
}

/// ----------------------------------------------------------------------------------------------------
/// GET ALL VITAL SIGNS
/// ----------------------------------------------------------------------------------------------------
Future<TsResponse<TsVitalSignsResponse>> getAllVitalSigns() async {
  try {
    final response = await httpGet('$_baseUrl/vitalSigns/all', getHeaders());
    if (response.statusCode >= HttpStatus.badRequest) {
      if (response.statusCode == HttpStatus.networkConnectTimeoutError) {
        return TsResponse<TsVitalSignsResponse>(
          status: HttpStatus.networkConnectTimeoutError,
        );
      }
      return TsResponse.createEmpty();
    }
    TsResponse<TsVitalSignsResponse> responseData =
        TsResponse.fromJsonList(utf8.decode(response.bodyBytes),
            TsVitalSignsResponse.createEmpty());
    return responseData;
  } catch (e) {
    return TsResponse.createEmpty();
  }
}

/// ----------------------------------------------------------------------------------------------------
/// GET VITAL SIGN BY ID
/// ----------------------------------------------------------------------------------------------------
Future<TsResponse<TsVitalSignsResponse>> getVitalSignById(
    int vitalSignId) async {
  try {
    final response =
        await httpGet('$_baseUrl/vitalsigns/$vitalSignId', getHeaders());
    if (response.statusCode >= HttpStatus.badRequest) {
      if (response.statusCode == HttpStatus.networkConnectTimeoutError) {
        return TsResponse<TsVitalSignsResponse>(
          status: HttpStatus.networkConnectTimeoutError,
        );
      }
      return TsResponse.createEmpty();
    }
    final responseJson = json.decode(response.body);
    final modelData = TsVitalSignsResponse.createEmpty()
        .fromMap(responseJson['data']);
    return TsResponse<TsVitalSignsResponse>(
      data: modelData,
      status: response.statusCode,
      message: responseJson['message'],
    );
  } catch (e) {
    return TsResponse.createEmpty();
  }
}
Future<TsResponse<TsVitalSignsResponse>> getVitalSignsByKardexId(int kardexId) async {
  try {
    final response = await httpGet("$_baseUrl/vitalSigns/kardex/$kardexId", getHeaders());

    if (response.statusCode >= HttpStatus.badRequest) {
      return TsResponse.createEmpty();
    }

    return TsResponse.fromJsonList(
      utf8.decode(response.bodyBytes),
      TsVitalSignsResponse.createEmpty(),
    );
  } catch (_) {
    return TsResponse.createEmpty();
  }
}
// ----------------------------------------------------------------------------------------------------
/// GET VITAL SIGNS BY KARDEX ID
///   -------------------------------------------------------------------------------------------------
Future<TsResponse<TsVitalSignsResponse>> getVitalSignsByKardex(int kardexId) async {
  try {
    final response = await httpGet("$_baseUrl/vitalSigns/kardex/$kardexId", getHeaders());

    if (response.statusCode >= HttpStatus.badRequest) {
      return TsResponse.createEmpty();
    }

    return TsResponse.fromJsonList(
      utf8.decode(response.bodyBytes),
      TsVitalSignsResponse.createEmpty(),
    );
  } catch (_) {
    return TsResponse.createEmpty();
  }
}


/// ----------------------------------------------------------------------------------------------------
/// UPDATE VITAL SIGN
/// ----------------------------------------------------------------------------------------------------
Future<TsResponse<TsVitalSignsResponse>> updateVitalSign(
    int vitalSignId, TsVitalSignsRequest request) async {
  try {
    final response = await httpPut(
      '$_baseUrl/vitalsigns/update/$vitalSignId',
      getHeaders(),
      jsonEncode(request.toJson()),
    );
    if (response.statusCode >= HttpStatus.badRequest) {
      if (response.statusCode == HttpStatus.networkConnectTimeoutError) {
        return TsResponse<TsVitalSignsResponse>(
          status: HttpStatus.networkConnectTimeoutError,
        );
      }
      try {
        final errorJson = json.decode(response.body);
        return TsResponse<TsVitalSignsResponse>(
          status: response.statusCode,
          message: errorJson['message'] ?? 'Error al actualizar el signo vital',
          error: errorJson['error'] ?? '',
        );
      } catch (e) {
        return TsResponse<TsVitalSignsResponse>.createEmpty();
      }
    }
    final responseJson = json.decode(response.body);
    final modelData = TsVitalSignsResponse.createEmpty()
        .fromMap(responseJson['data']);
    return TsResponse<TsVitalSignsResponse>(
      data: modelData,
      status: response.statusCode,
      message: responseJson['message'],
    );
  } catch (e) {
    return TsResponse<TsVitalSignsResponse>(
      status: HttpStatus.internalServerError,
      message: 'Error durante la actualización del signo vital',
      error: e.toString(),
    );
  }
}

/// ----------------------------------------------------------------------------------------------------
/// DELETE VITAL SIGN
/// ----------------------------------------------------------------------------------------------------
Future<TsResponse<TsVitalSignsResponse>> deleteVitalSign(
    int vitalSignId) async {
  try {
    final response =
        await httpDelete('$_baseUrl/vitalsigns/delete/$vitalSignId', getHeaders());
    if (response.statusCode >= HttpStatus.badRequest) {
      if (response.statusCode == HttpStatus.networkConnectTimeoutError) {
        return TsResponse<TsVitalSignsResponse>(
          status: HttpStatus.networkConnectTimeoutError,
        );
      }
      try {
        final errorJson = json.decode(response.body);
        return TsResponse<TsVitalSignsResponse>(
          status: response.statusCode,
          message: errorJson['message'] ?? 'Error al eliminar el signo vital',
          error: errorJson['error'] ?? '',
        );
      } catch (e) {
        return TsResponse<TsVitalSignsResponse>.createEmpty();
      }
    }
    final responseJson = json.decode(response.body);
    final modelData = TsVitalSignsResponse.createEmpty()
        .fromMap(responseJson['data']);
    return TsResponse<TsVitalSignsResponse>(
      data: modelData,
      status: response.statusCode,
      message: responseJson['message'],
    );
  } catch (e) {
    return TsResponse<TsVitalSignsResponse>(
      status: HttpStatus.internalServerError,
      message: 'Error durante la eliminación del signo vital',
      error: e.toString(),
    );
  }
}

/// ----------------------------------------------------------------------------------------------------
/// CREATE REPORT
/// ----------------------------------------------------------------------------------------------------
Future<TsResponse<TsReportsResponse>> createReport(TsReportsRequest request) async {
  try {
    final response = await httpPost(
      "$_baseUrl/reports/create",
      getHeaders(),
      jsonEncode(request.toJson()),
    );

    if (response.statusCode >= HttpStatus.badRequest) {
      return TsResponse<TsReportsResponse>(
        status: response.statusCode,
        message: json.decode(response.body)["message"] ?? "Error al crear reporte",
        error: json.decode(response.body)["error"] ?? "",
      );
    }

    final responseJson = json.decode(response.body);
    final modelData = TsReportsResponse.createEmpty().fromMap(responseJson["data"]);
    return TsResponse<TsReportsResponse>(
      data: modelData,
      status: response.statusCode,
      message: responseJson["message"],
    );
  } catch (e) {
    return TsResponse<TsReportsResponse>(
      status: HttpStatus.internalServerError,
      message: "Error durante la creación del reporte",
      error: e.toString(),
    );
  }
}

/// ----------------------------------------------------------------------------------------------------
/// GET ALL REPORTS
/// ----------------------------------------------------------------------------------------------------
Future<TsResponse<TsReportsResponse>> getAllReports() async {
  try {
    final response = await httpGet("$_baseUrl/reports/all", getHeaders());

    if (response.statusCode >= HttpStatus.badRequest) {
      return TsResponse.createEmpty();
    }

    return TsResponse.fromJsonList(
      utf8.decode(response.bodyBytes),
      TsReportsResponse.createEmpty(),
    );
  } catch (_) {
    return TsResponse.createEmpty();
  }
}

/// ----------------------------------------------------------------------------------------------------
/// GET REPORT BY ID
/// ----------------------------------------------------------------------------------------------------
Future<TsResponse<TsReportsResponse>> getReportById(int reportId) async {
  try {
    final response = await httpGet("$_baseUrl/reports$reportId", getHeaders());

    if (response.statusCode >= HttpStatus.badRequest) {
      return TsResponse.createEmpty();
    }

    final responseJson = json.decode(response.body);
    final modelData = TsReportsResponse.createEmpty().fromMap(responseJson["data"]);
    return TsResponse<TsReportsResponse>(
      data: modelData,
      status: response.statusCode,
      message: responseJson["message"],
    );
  } catch (_) {
    return TsResponse.createEmpty();
  }
}

/// ----------------------------------------------------------------------------------------------------
/// GET REPORTS BY KARDEX
/// ----------------------------------------------------------------------------------------------------
Future<TsResponse<TsReportsResponse>> getReportsByKardex(int kardexId) async {
  try {
    final response = await httpGet("$_baseUrl/reports/kardex/$kardexId", getHeaders());

    if (response.statusCode >= HttpStatus.badRequest) {
      return TsResponse.createEmpty();
    }

    return TsResponse.fromJsonList(
      utf8.decode(response.bodyBytes),
      TsReportsResponse.createEmpty(),
    );
  } catch (_) {
    return TsResponse.createEmpty();
  }
}

/// ----------------------------------------------------------------------------------------------------
/// UPDATE REPORT
/// ----------------------------------------------------------------------------------------------------
Future<TsResponse<TsReportsResponse>> updateReport(int reportId, TsReportsRequest request) async {
  try {
    final response = await httpPut(
      "$_baseUrl/reports/update/$reportId",
      getHeaders(),
      jsonEncode(request.toJson()),
    );

    if (response.statusCode >= HttpStatus.badRequest) {
      return TsResponse<TsReportsResponse>(
        status: response.statusCode,
        message: json.decode(response.body)["message"] ?? "Error al actualizar reporte",
        error: json.decode(response.body)["error"] ?? "",
      );
    }

    final responseJson = json.decode(response.body);
    final modelData = TsReportsResponse.createEmpty().fromMap(responseJson["data"]);
    return TsResponse<TsReportsResponse>(
      data: modelData,
      status: response.statusCode,
      message: responseJson["message"],
    );
  } catch (e) {
    return TsResponse<TsReportsResponse>(
      status: HttpStatus.internalServerError,
      message: "Error durante la actualización del reporte",
      error: e.toString(),
    );
  }
}

/// ----------------------------------------------------------------------------------------------------
/// DELETE REPORT
/// ----------------------------------------------------------------------------------------------------
Future<TsResponse<TsReportsResponse>> deleteReport(int reportId) async {
  try {
    final response = await httpDelete("$_baseUrl/reports/delete/$reportId", getHeaders());

    if (response.statusCode >= HttpStatus.badRequest) {
      return TsResponse.createEmpty();
    }

    final responseJson = json.decode(response.body);
    final modelData = TsReportsResponse.createEmpty().fromMap(responseJson["data"]);
    return TsResponse<TsReportsResponse>(
      data: modelData,
      status: response.statusCode,
      message: responseJson["message"],
    );
  } catch (_) {
    return TsResponse.createEmpty();
  }
}
Future<TsResponse<TsPeopleResponse>> getCurrentUserData() async {
  try {
    // Obtener el personId del almacenamiento seguro
    final personId = await Preferences().personId();
    
    if (personId == 0) {
      return TsResponse(
        status: 401,
        message: 'No se pudo obtener el ID del usuario',
      );
    }
    
    // Usar el método existente getPersonById con el personId del token
    return await getPersonById(personId);
  } catch (e, stackTrace) {
    debugPrint('Error en getCurrentUserData: $e');
    debugPrint('Stack trace: $stackTrace');
    return TsResponse(
      status: 500,
      message: 'Error al obtener datos del usuario: ${e.toString()}',
    );
  }
}
// get person by id (profile)
Future<TsResponse<TsPeopleResponse>> getPersonById(int personId) async {
  try {
    final response = await httpGet('$_baseUrl/persons/$personId', getHeaders());
    
    if (response.statusCode >= HttpStatus.badRequest) {
      return TsResponse(
        status: response.statusCode,
        message: 'Error del servidor: ${response.statusCode}',
      );
    }
    
    final responseData = jsonDecode(utf8.decode(response.bodyBytes));
    
    // Verifica si hay datos y si tienen la estructura esperada
    if (responseData['data'] == null || responseData['data'] is! Map) {
      return TsResponse(
        status: responseData['status'] ?? 404,
        message: responseData['message'] ?? 'Datos de persona no encontrados',
      );
    }
    
    try {
      final person = TsPeopleResponse.fromJson(responseData['data']);
      return TsResponse(
        status: responseData['status'] ?? 200,
        message: responseData['message'] ?? 'OK',
        data: person,
        dataList: [person],
      );
    } catch (e, stackTrace) {
      debugPrint('Error parsing person data: $e');
      debugPrint('Stack trace: $stackTrace');
      return TsResponse(
        status: 500,
        message: 'Error al procesar los datos de la persona',
      );
    }
    
  } catch (e, stackTrace) {
    debugPrint('Error en getPersonById: $e');
    debugPrint('Stack trace: $stackTrace');
    return TsResponse(
      status: 500,
      message: 'Error de conexión: ${e.toString()}',
    );
  }
}

// ------------------------------------------------------------------------------------------------
/// UPDATE PERSON
/// ------------------------------------------------------------------------------------------------
Future<TsResponse<TsPeopleResponse>> updatePerson(
  int personId,
  Map<String, dynamic> body,
) async {
  try {
    final api = TuSaludApi();
    final response = await api.httpPut(
      '${Enviroment.apiTuSaludURL}/persons/update/$personId', // ✅ aquí usamos personId, no user.personId
      api.getHeaders(),
      jsonEncode(body),
    );

    if (response.statusCode >= HttpStatus.badRequest) {
      // Manejo de errores del backend
      try {
        final errorJson = json.decode(response.body);
        return TsResponse<TsPeopleResponse>(
          status: response.statusCode,
          message: errorJson['message'] ?? 'Error al actualizar persona',
          error: errorJson['error'] ?? '',
        );
      } catch (e) {
        return TsResponse<TsPeopleResponse>(
          status: response.statusCode,
          message: 'Error desconocido al actualizar persona',
          error: e.toString(),
        );
      }
    }

    // ✅ Parsear respuesta exitosa
    final responseJson = json.decode(response.body);
    final personData = TsPeopleResponse.createEmpty().fromMap(
      Map<String, dynamic>.from(responseJson['data']),
    );

    return TsResponse<TsPeopleResponse>(
      data: personData,
      status: response.statusCode,
      message: responseJson['message'] ?? 'Persona actualizada correctamente',
    );
  } catch (e) {
    return TsResponse<TsPeopleResponse>(
      status: HttpStatus.internalServerError,
      message: 'Error durante la actualización de la persona',
      error: e.toString(),
    );
  }
}





}