import 'package:dio/dio.dart';
import 'package:wanandroid/account/account_info.dart';
import 'package:wanandroid/data/api.dart';
import 'package:wanandroid/data/service.dart';
import 'package:wanandroid/models/login_model.dart';

class Repository {
  static final Repository _instance = Repository._internal();

  factory Repository() {
    return _instance;
  }

  Repository._internal() {}

  Future getBannerList() async {
    var result = await MyService().dio.get(API.banner);
    return result;
  }

  Future<Response> login(String userName, String password) async {
    // Map<String, dynamic> map = Map();
    // map['username'] = userName;
    // map['password'] = password;
    FormData formData =
        FormData.fromMap({"username": userName, "password": password});
    return await MyService().dio.post(API.login, data: formData);
  }

  Future<Response> register(
      String username, String password, String repassword) async {
    FormData formData = FormData.fromMap(
        {"username": username, "password": password, "repassword": repassword});
    return await MyService().dio.post(API.register, data: formData);
  }

  Future<Response> logout() async {
    return await MyService().dio.get(API.loginout);
  }

  Future<Response> integral() async {
    return await MyService().dio.get(API.integral);
  }

  Future<Response> collect(int id) async {
    return await MyService().dio.post('/lg/collect/${id}/json');
  }

  Future<Response> unCollect(int id) async {
    return await MyService().dio.post('/lg/uncollect_originId/${id}/json');
  }

  Future<Response> getSquareArticles(int page) async {
    return await MyService().dio.get("/user_article/list/$page/json");
  }

  Future<Response> getWXArticleTabs() async {
    return await MyService().dio.get(API.wxArticleTabs);
  }

  Future<Response> getSystemData() async {
    return await MyService().dio.get(API.system);
  }

  Future<Response> getNaviData() async {
    return await MyService().dio.get(API.navigation);
  }

  Future<Response> getProjectTabs() async {
    return await MyService().dio.get(API.projectTabs);
  }

  Future<Response> getCollectList(int page) async {
    return await MyService().dio.get('/lg/collect/list/$page/json');
  }

  Future<Response> getIntegralList(int page) async {
    return await MyService().dio.get('//lg/coin/list/$page/json');
  }

  Future<Response> getShareList(int page) async {
    return await MyService().dio.get('/user/lg/private_articles/$page/json');
  }

  Future<Response> shareArticle(String title, String link) async {
    return await MyService().dio.post('/lg/user_article/add/json', data: FormData.fromMap({"title": title, "link": link}));
  }
}
