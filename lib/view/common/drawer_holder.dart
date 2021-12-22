import 'package:flutter/material.dart';

class DrawerHolder {
  static Drawer _drawer = Drawer(
      child: Padding(
          padding: EdgeInsets.only(left: 20, top: 80),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: double.infinity,
                height: 60,
                child: Text("用户"),
              ),
              Container(
                width: double.infinity,
                height: 60,
                margin: EdgeInsets.only(left: 10),
                child: Text('相册'),
              )
            ],
          )));

  static get drawer => _drawer;
}
