import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:tusalud/api/request/auth/sign_up_request.dart';

import 'package:tusalud/api/request/auth/ts_auth_request.dart';
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
// DEFAULT METHODS
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
  // put
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
  
// signup
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

}