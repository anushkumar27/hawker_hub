import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:hawker_hub/services/api_base.dart';
import 'package:hawker_hub/services/api_exceptions.dart';
import 'package:hawker_hub/utilities/constants.dart';
import 'package:http/http.dart' as http;

/// HTTP Client
/// Singleton helper class for making HTTPS REST API calls
class HttpClient {
  static final HttpClient _singleton = HttpClient();

  static HttpClient get instance => _singleton;

  Future<dynamic> fetchData({String? url, Map<String, String>? params}) async {
    dynamic responseJson;

    var uri = APIBase.baseURL +
        ((url != null) ? url : "") +
        ((params != null) ? queryParameters(params) : "");
    var header = {HttpHeaders.contentTypeHeader: 'application/json'};
    try {
      final response = await http
          .get(
            Uri.parse(uri),
            headers: header,
          )
          .timeout(Constants.clientNetworkTimeout);
      responseJson = _returnResponse(response);
    } on SocketException {
      throw FetchDataException('No Internet connection');
    } on TimeoutException {
      throw ClientTimeoutException(
          "${Constants.clientNetworkTimeout.inSeconds} seconds");
    }
    return responseJson;
  }

  String queryParameters(Map<String, String>? params) {
    if (params != null) {
      final jsonString = Uri(queryParameters: params);
      return '?${jsonString.query}';
    }
    return '';
  }

  Future<dynamic> postData(String url, dynamic body) async {
    dynamic responseJson;
    var header = {HttpHeaders.contentTypeHeader: 'application/json'};
    try {
      final response = await http
          .post(Uri.parse(APIBase.baseURL + url), body: body, headers: header)
          .timeout(Constants.clientNetworkTimeout);
      responseJson = _returnResponse(response);
    } on SocketException {
      throw FetchDataException('No Internet connection');
    } on TimeoutException {
      throw ClientTimeoutException(
          "${Constants.clientNetworkTimeout.inSeconds} seconds");
    }
    return responseJson;
  }

  dynamic _returnResponse(http.Response response) {
    switch (response.statusCode) {
      case 200:
        var responseJson = json.decode(response.body.toString());
        return responseJson;
      case 400:
        throw BadRequestException(response.body.toString());
      case 401:
      case 403:
        throw UnauthorisedException(response.body.toString());
      case 500:
      default:
        throw FetchDataException(
            'Error occured while Communication with Server with StatusCode : ${response.statusCode}');
    }
  }
}
