import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:wanandroid/view/common/drawer_holder.dart';

class SystemPage extends StatelessWidget {
  const SystemPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('体系'),
        actions: [IconButton(onPressed: () {}, icon: Icon(Icons.search))],
      ),
      drawer: DrawerHolder.drawer,
      body: Center(
        child: Text('体系'),
      ),
    );
  }
}
