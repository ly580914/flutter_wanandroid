import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:wanandroid/view/common/drawer_holder.dart';

class SquarePage extends StatelessWidget {
  const SquarePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('广场'),
        actions: [IconButton(onPressed: () {}, icon: Icon(Icons.add))],
      ),
      drawer: DrawerHolder.drawer,
      body: Center(
        child: Text('广场'),
      ),
    );
  }
}
