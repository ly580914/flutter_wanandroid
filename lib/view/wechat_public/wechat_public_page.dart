import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:wanandroid/view/common/drawer_holder.dart';

class WechatPublicPage extends StatefulWidget {
  const WechatPublicPage({Key? key}) : super(key: key);

  @override
  _WechatPublicPageState createState() => _WechatPublicPageState();
}

class _WechatPublicPageState extends State<WechatPublicPage>
    with TickerProviderStateMixin {
  late TabController _tabController;

  var _tabs = <String>['国产', '直播', '探花', '自拍', '日本', '欧美', '韩国', '无码', '有码', '综艺', '本地'];

  var _contenPages = <Widget>[];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: _tabs.length, vsync: this);
    _tabs.forEach((element) {
      _contenPages.add(_testPage(element));
    });
  }

  @override
  void dispose() {
    super.dispose();
    _tabController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('公众号'),
        actions: [IconButton(onPressed: () {}, icon: Icon(Icons.search))],
        bottom: TabBar(
          tabs: _tabs.map((e) => Tab(text: e)).toList(),
          controller: _tabController,
          isScrollable: true,
        ),
      ),
      drawer: DrawerHolder.drawer,
      body: TabBarView(
        children: _contenPages,
        controller: _tabController,
      ),
    );
  }

  Widget _testPage(String name) {
    return Padding(
      padding: EdgeInsets.all(20),
      child: Text(name),
    );
  }
}

