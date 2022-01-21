import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

/**
 * with context
 */
class MyToast {
  static FToast _fToast = FToast();
  static late Widget _toast;

  static void show(BuildContext context, String msg) {
    _fToast.init(context);
    _createToast(msg);
    _showToast();
  }

  static void _createToast(String msg) {
    _toast = Container(
        padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 12.0),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(18.0),
          color: Colors.black54,
        ),
        child: Text(msg, style: TextStyle(color: Colors.white),));
  }

  static _showToast() {
    _fToast.showToast(
      child: _toast,
      gravity: ToastGravity.CENTER,
      toastDuration: Duration(milliseconds: 1500),
    );
  }
}

/**
 * without context
 */
void toast(String msg) {
  // todo xiaomi手机上属性没有任何作用，包括官方demo，静待解决？
  Fluttertoast.showToast(
      msg: msg,
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.CENTER,
      // timeInSecForIosWeb: 1,
      // backgroundColor: Colors.red,
      // textColor: Colors.white,
      fontSize: 16.0);
}
