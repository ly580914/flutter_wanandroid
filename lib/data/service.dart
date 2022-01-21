import 'package:dio/dio.dart';
import 'package:wanandroid/account/account_info.dart';

class MyService {
  static final MyService _instance = MyService._internal();
  Dio dio = Dio();

  factory MyService(){
    return _instance;
  }
  MyService._internal() {
    // BaseOptions options = BaseOptions();
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
      if (Account.get != null) {
        options.headers['Cookie'] = 'loginUserName=${Account.get.username}, loginUserPassword=${Account.get.password}';
      }
      return handelr.next(options);
    },onResponse: (e, handler) {
      // print('dio onResponse' + e.data.toString());
      return handler.next(e);
    },onError: (e, handler) {
      // if (e.type == DioErrorType.)
      print("dio onError : " + e.message);
    }));
  }

}
