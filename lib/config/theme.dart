import 'package:flutter/material.dart';

import 'colors.dart';

class AppTheme {
  static final _theme = ThemeData();
  static final _themeData = _theme.copyWith(
    colorScheme: _theme.colorScheme.copyWith(primary: AppColors.primary),
    scaffoldBackgroundColor: AppColors.page,
    indicatorColor: AppColors. active,
    // textTheme: TextTheme(
    //   bodyText2: TextStyle(
    //     color: AppColors.unactive,
    //   )
    // ),

    // appBarTheme: AppBarTheme(
    //   backgroundColor: ,
    //   elevation: ,
    // ),

    // tabBarTheme: TabBarTheme(
    //   unselectedLabelColor: ,
    //   indicatorSize: ,
    //   labelStyle: TextStyle(
    //     fontSize: ,
    //   ),
    //   labelPadding: ,
    // ),

    // 取消水波纹效果
    splashColor: Colors.transparent,
    highlightColor: Colors.transparent,
    // bottomNavigationBarTheme: ...
  );

  static get themeData => _themeData;
}
