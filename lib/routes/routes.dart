import 'package:fluro/fluro.dart';
import 'package:flutter/cupertino.dart';
import 'package:wanandroid/view/drawer/collect/collect_list_page.dart';
import 'package:wanandroid/view/drawer/integral/integral_page.dart';
import 'package:wanandroid/view/drawer/share/share_list_page.dart';
import 'package:wanandroid/view/drawer/share/share_page.dart';
import 'package:wanandroid/view/login/login_page.dart';
import 'package:wanandroid/view/login/register_page.dart';
import 'package:wanandroid/view/root_page.dart';
import 'package:wanandroid/view/search/search_detail_page.dart';
import 'package:wanandroid/view/search/search_page.dart';
import 'package:wanandroid/view/splash_page.dart';
import 'package:wanandroid/view/system/system_classify_page.dart';
import 'package:wanandroid/webview/webview.dart';

Map<String, WidgetBuilder> routes = {
  '/': (BuildContext context) => SplashPage(),
  // '/': (BuildContext context) => RootPage(), // 临时
};

Route<dynamic> onGenerateRoute(RouteSettings settings) {
  switch (settings.name) {
    case 'webview':
      return _pageRouteBuilder(settings, MyWebView());
    case 'home':
      return _pageRouteBuilder(settings, const RootPage());
    case 'login':
      return _pageRouteBuilder(settings, const LoginPage());
    case 'register':
      return _pageRouteBuilder(settings, const RegisterPage());
    case 'system':
      return _pageRouteBuilder(settings, const SystemClassifyPage());
    case 'search':
      return _pageRouteBuilder(settings, const SearchPage());
    case 'search_detail':
      return _pageRouteBuilder(settings, const SearchDetailPage());
    case 'collect_list':
      return _pageRouteBuilder(settings, const CollectListPage());
    case 'integral':
      return _pageRouteBuilder(settings, const IntegralPage());
    case 'share_list':
      return _pageRouteBuilder(settings, const ShareListPage());
    case 'share':
      return _pageRouteBuilder(settings, const SharePage());
  }
  throw UnsupportedError('Unknown route: ${settings.name}');
}

PageRouteBuilder _pageRouteBuilder(RouteSettings settings, Widget widget) {
  return PageRouteBuilder(
      transitionDuration: const Duration(milliseconds: 500),
      settings: settings,
      pageBuilder: (BuildContext context, Animation<double> animation,
              Animation<double> secondaryAnimation) =>
          widget,
      transitionsBuilder: (BuildContext context, Animation<double> animation1,
          Animation<double> animation2, Widget child) {
        return SlideTransition(
          position:
              Tween<Offset>(begin: Offset(1.0, 0.0), end: Offset(0.0, 0.0))
                  .animate(CurvedAnimation(
                      parent: animation1, curve: Curves.fastOutSlowIn)),
          child: child,
        );
      });
}

RouteTransitionsBuilder _standardTransitionsBuilder(
    TransitionType? transitionType) {
  return (BuildContext context, Animation<double> animation,
      Animation<double> secondaryAnimation, Widget child) {
    if (transitionType == TransitionType.fadeIn) {
      return FadeTransition(opacity: animation, child: child);
    } else {
      const Offset topLeft = const Offset(0.0, 0.0);
      const Offset topRight = const Offset(1.0, 0.0);
      const Offset bottomLeft = const Offset(0.0, 1.0);

      Offset startOffset = bottomLeft;
      Offset endOffset = topLeft;
      if (transitionType == TransitionType.inFromLeft) {
        startOffset = const Offset(-1.0, 0.0);
        endOffset = topLeft;
      } else if (transitionType == TransitionType.inFromRight) {
        startOffset = topRight;
        endOffset = topLeft;
      } else if (transitionType == TransitionType.inFromBottom) {
        startOffset = bottomLeft;
        endOffset = topLeft;
      } else if (transitionType == TransitionType.inFromTop) {
        startOffset = Offset(0.0, -1.0);
        endOffset = topLeft;
      }

      return SlideTransition(
        position: Tween<Offset>(
          begin: startOffset,
          end: endOffset,
        ).animate(animation),
        child: child,
      );
    }
  };
}






// final router = FluroRouter();

// var naviHandler = Handler(handlerFunc: (BuildContext context, Map<String, dynamic> params) {
//   return UsersScreen(params["id"][0]);
// });
//
// void defineRoutes(FluroRouter router) {
//   router.define("/users/:id", handler: naviHandler);
//
//   // it is also possible to define the route transition to use
//   // router.define("users/:id", handler: usersHandler, transitionType: TransitionType.inFromLeft);
// }

// class Routes {
//   static String root = "/";
//   static String home = "/home";
//   static String login = "/login";
//   static String register = "/register";
//   static String webview = "/webview";
//
//   static void configureRoutes(FluroRouter router) {
//     router.notFoundHandler = Handler(
//         handlerFunc: (BuildContext? context, Map<String, List<String>> params) {
//       print("ROUTE WAS NOT FOUND !!!");
//       return;
//     });
//     router.define(root, handler: rootHandler);
//     // router.define(home, handler: demoRouteHandler);
//   }
// }
