import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyrefresh/easy_refresh.dart';
import 'package:wanandroid/models/article_model.dart';
import 'package:wanandroid/models/event_bus_model.dart';
import 'package:wanandroid/view/drawer/drawer_holder.dart';

import '../../page_status.dart';
import '../../toast.dart';
import '../event_bus.dart';

abstract class BasePage extends StatefulWidget {
  const BasePage({Key? key}) : super(key: key);

  @override
  _BasePageState createState() => _BasePageState();
}

class _BasePageState extends State<BasePage> {
  late EasyRefreshController _easyRefreshController = EasyRefreshController();
  late ScrollController _scrollController = ScrollController();
  int pageStatus = PageStatus.statusLoading;
  int page = 0;
  bool showFloatingActionButton = false;
  late StreamSubscription event;
  List<ArticleItem> articleList = <ArticleItem>[];

  @override
  void initState() {
    super.initState();
    double lastOffset = 0.0;
    _scrollController.addListener(() {
      if (_scrollController.offset >= 10 &&
          !showFloatingActionButton &&
          _scrollController.offset < lastOffset) {
        setState(() {
          showFloatingActionButton = true;
        });
      } else if ((_scrollController.offset < 10 ||
          _scrollController.offset > lastOffset) &&
          showFloatingActionButton) {
        setState(() {
          showFloatingActionButton = false;
        });
      }
      lastOffset = _scrollController.offset;
    });
    initData();

    event = EventBusHolder.get.on<LoginState>().listen((event) {
      print("EventBus on ${event.isLogin}");
      setState(() {});
    });
  }

  void initData() {}

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