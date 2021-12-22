import 'package:flutter/cupertino.dart';
import 'package:wanandroid/view/root_page.dart';
import 'package:wanandroid/view/login_page.dart';
import 'package:wanandroid/view/splash_page.dart';

Map<String, WidgetBuilder> routes = {
  // '/': (BuildContext context) => SplashPage(),
  '/': (BuildContext context) => RootPage(), // 临时
  'home': (BuildContext context) => RootPage(),
};