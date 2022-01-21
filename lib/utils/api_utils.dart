import 'package:dio/dio.dart';

class ApiUtils{
  static bool isSuccess(Response response) {
    return response.data['errorCode'] == 0;
  }
}