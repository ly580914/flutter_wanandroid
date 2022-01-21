import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

// 去掉listview过渡拖动波纹效果
class CusBehavior extends ScrollBehavior {
  @override
  Widget buildViewportChrome(
      BuildContext context, Widget child, AxisDirection axisDirection) {
    if (Platform.isAndroid || Platform.isFuchsia) return child;
    return super.buildViewportChrome(context, child, axisDirection);
  }
}

class SlideRightRoute extends PageRouteBuilder {
  final Widget page;

  SlideRightRoute({required this.page})
      : super(
          pageBuilder: (
            BuildContext context,
            Animation<double> animation,
            Animation<double> secondaryAnimation,
          ) =>
              page,
          transitionsBuilder: (
            BuildContext context,
            Animation<double> animation,
            Animation<double> secondaryAnimation,
            Widget child,
          ) =>
              SlideTransition(
            position: Tween<Offset>(
              begin: const Offset(-1, 0),
              end: Offset.zero,
            ).animate(animation),
            child: child,
          ),
        );
}

class CustomNamedPageTransition extends PageRouteBuilder {
  CustomNamedPageTransition(
      GlobalKey materialAppKey,
      String routeName, {
        Object? arguments,
      }) : super(
    settings: RouteSettings(
      arguments: arguments,
      name: routeName,
    ),
    pageBuilder: (
        BuildContext context,
        Animation<double> animation,
        Animation<double> secondaryAnimation,
        ) {
      assert(materialAppKey.currentWidget != null);
      assert(materialAppKey.currentWidget is MaterialApp);
      var mtapp = materialAppKey.currentWidget as MaterialApp;
      var routes = mtapp.routes;
      assert(routes!.containsKey(routeName));
      return routes![routeName]!(context);
    },
    transitionsBuilder: (
        BuildContext context,
        Animation<double> animation,
        Animation<double> secondaryAnimation,
        Widget child,
        ) =>
        FadeTransition(
          opacity: animation,
          child: child,
        ),
    transitionDuration: Duration(seconds: 1),
  );
}
