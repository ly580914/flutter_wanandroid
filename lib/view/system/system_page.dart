import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:wanandroid/config/colors.dart';
import 'package:wanandroid/view/drawer/drawer_holder.dart';
import 'package:wanandroid/view/system/nav_tab_page.dart';
import 'package:wanandroid/view/system/system_tab_page.dart';

class SystemPage extends StatefulWidget {
  const SystemPage({Key? key}) : super(key: key);

  @override
  _SystemPageState createState() => _SystemPageState();
}

class _SystemPageState extends State<SystemPage> with TickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
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
          title: Text('体系'),
          actions: [IconButton(onPressed: () => Navigator.pushNamed(context, 'search'), icon: Icon(Icons.search))],
          bottom: TabBar(
            padding: EdgeInsets.only(right: 400),
            tabs: [Tab(child: Text('体系')), Tab(child: Text('导航'))],
            controller: _tabController,
            isScrollable: true,
            indicatorColor: AppColors.page,
          ),
        ),
        drawer: DrawerHolder.drawer,
        body: TabBarView(
          children: [SystemTabPage(), NavTabPage()],
          controller: _tabController,
        ));
  }
}
