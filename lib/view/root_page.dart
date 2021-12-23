import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:wanandroid/view/home/home_page.dart';
import 'package:wanandroid/view/project/project_page.dart';
import 'package:wanandroid/view/square/square_page.dart';
import 'package:wanandroid/view/system/system_page.dart';
import 'package:wanandroid/view/wechat_public/wechat_public_page.dart';

class RootPage extends StatefulWidget {
  const RootPage({Key? key}) : super(key: key);

  @override
  _RootPageState createState() => _RootPageState();
}

class _RootPageState extends State<RootPage>
    with SingleTickerProviderStateMixin {
  var _currentIndex = 0;
  final _bottomTabs = {
    "home": "首页",
    "square": "广场",
    "wechat": "公众号",
    "system": "体系",
    "project": "项目",
  };
  final tabs = <BottomNavigationBarItem>[];
  final pages = <Widget>[
    HomePage(),
    SquarePage(),
    WechatPublicPage(),
    SystemPage(),
    ProjectPage()
  ];

  // late TabController _tabController;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _bottomTabs.forEach((key, value) {
      tabs.add(_BottomNavigationBarItem(key, value));
    });
    // _tabController = TabController(length: pages.length, vsync: this, );
  }

  @override
  void dispose() {
    super.dispose();
    // _tabController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: _bottomNavigationBar(),
      body: IndexedStack(
        children: pages,
        index: _currentIndex,
      )
    );
  }

  BottomNavigationBar _bottomNavigationBar() {
    return BottomNavigationBar(
      items: tabs,
      currentIndex: _currentIndex,
      onTap: (v) =>
          setState(() {
            _currentIndex = v;
            // _tabController.animateTo(_currentIndex);
          }),
      type: BottomNavigationBarType.fixed,
      unselectedFontSize: 12,
      selectedFontSize: 12,
    );
  }

  BottomNavigationBarItem _BottomNavigationBarItem(String assetName,
      String label) {
    return BottomNavigationBarItem(
        icon: Image.asset(
          'images/icons/icon_$assetName.png',
          width: 24,
          height: 24,
        ),
        activeIcon: Image.asset(
          'images/icons/icon_${assetName}_active.png',
          width: 24,
          height: 24,
        ),
        label: label);
  }

}
