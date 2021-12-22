
import 'package:wanandroid/data/api.dart';
import 'package:wanandroid/data/service.dart';

Future getBannerList() async {
  var result = await MyService().dio.get(API.banner);
  return result;
}