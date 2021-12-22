import 'package:dio/dio.dart';

class MyService {
  static final MyService _instance = MyService._internal();
  Dio dio = Dio();

  factory MyService(){
    return _instance;
  }
  MyService._internal() {
    dio.options = BaseOptions(
      baseUrl: "https://www.wanandroid.com",
      connectTimeout: 10 * 1000,
      sendTimeout: 10 * 1000,
      receiveTimeout: 10 * 1000,
      // headers: {
      //   "token" : "12345",
      // }
      contentType: Headers.jsonContentType,
    );
    dio.interceptors.add(InterceptorsWrapper(onRequest: (options, handelr) {
      print("dio onRequest : " + options.uri.toString());
      return handelr.next(options);
    },onResponse: (e, handler) {
      // print("dio onResponse : " + e.toString());
      // print('---------> ' + e.data.toString());
      return handler.next(e);
    },onError: (e, handler) {
      // if (e.type == DioErrorType.)
      print("dio onError : " + e.message);
    }));
  }

}
