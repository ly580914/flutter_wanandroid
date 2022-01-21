import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:wanandroid/config/colors.dart';
import 'package:wanandroid/data/service.dart';
import 'package:wanandroid/models/system_model.dart';
import 'package:wanandroid/view/common/common_article_page.dart';

class SystemClassifyPage extends StatefulWidget {
  const SystemClassifyPage({Key? key}) : super(key: key);

  @override
  _SystemClassifyPageState createState() => _SystemClassifyPageState();
}

class _SystemClassifyPageState extends State<SystemClassifyPage>
    with TickerProviderStateMixin {
  TabController? _tabController;
  SystemItem? item;
  var _contenPages = <Widget>[];

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
    _tabController?.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (item == null) {
      item = ModalRoute.of(context)?.settings.arguments as SystemItem;
      _tabController =
          TabController(length: item?.children.length as int, vsync: this);
      item?.children.forEach((element) {
        _contenPages.add(_articlePage(element['id']));
      });
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(item?.name as String),
        bottom: TabBar(
          tabs: item?.children
              ?.map((e) => Tab(
                    child: Text(
                      e['name'],
                      maxLines: 1,
                    ),
                  ))
              .toList() as List<Tab>,
          isScrollable: true,
          indicatorColor: AppColors.page,
          controller: _tabController,
        ),
      ),
      body: TabBarView(
        children: _contenPages,
        controller: _tabController,
      ),
    );
  }

  Widget _articlePage(int id) {
    return ArticlePage(
      apiFunction: (page) {
        return MyService().dio.get("/article/list/$page/json?cid=$id");
      },
    );
  }
}
