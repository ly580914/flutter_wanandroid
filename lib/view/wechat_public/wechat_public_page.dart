import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:wanandroid/config/colors.dart';
import 'package:wanandroid/data/repository.dart';
import 'package:wanandroid/data/service.dart';
import 'package:wanandroid/models/wechat_model.dart';
import 'package:wanandroid/utils/api_utils.dart';
import 'package:wanandroid/utils/widget_utils.dart';
import 'package:wanandroid/view/common/common_article_page.dart';
import 'package:wanandroid/view/drawer/drawer_holder.dart';

import '../../page_status.dart';
import '../../toast.dart';

class WechatPublicPage extends StatefulWidget {
  const WechatPublicPage({Key? key}) : super(key: key);

  @override
  _WechatPublicPageState createState() => _WechatPublicPageState();
}

class _WechatPublicPageState extends State<WechatPublicPage>
    with TickerProviderStateMixin {
  late TabController? _tabController;
  int pageStatus = PageStatus.statusLoading;

  List<WxArticleTabItem>? _tabs;

  var _contenPages = <Widget>[];

  @override
  void initState() {
    super.initState();
    _initTabs();
  }

  @override
  void dispose() {
    super.dispose();
    _tabController?.dispose();
  }

  void _initTabs() {
    Repository().getWXArticleTabs().then((value) {
      if (!ApiUtils.isSuccess(value)) {
        MyToast.show(context, "获取列表失败 ${value.data['errorMsg']}");
        setState(() {
          pageStatus = PageStatus.statusLoadError;
        });
        return;
      }
      setState(() {
        _tabs = WxArticleTabList.fromJson(value.data['data']).list;
        _tabs?.forEach((element) {
          _contenPages.add(_articlePage(element.id));
        });
        _tabController =
            TabController(length: _tabs?.length as int, vsync: this);
        pageStatus = PageStatus.statusLoaded;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('公众号'),
          actions: [IconButton(onPressed: () => Navigator.pushNamed(context, 'search'), icon: Icon(Icons.search))],
          bottom: _tabs == null
              ? null
              : TabBar(
                  tabs: _tabs?.map((e) => Tab(text: e.name)).toList()
                      as List<Tab>,
                  controller: _tabController,
                  isScrollable: true,
                  indicatorColor: AppColors.page,
                ),
        ),
        drawer: DrawerHolder.drawer,
        body: WidgetUtils.getPageStateWidget(context, pageStatus, _body)
    );
  }

  Widget _body(BuildContext context) {
    return TabBarView(
      children: _contenPages,
      controller: _tabController,
    );
  }

  Widget _articlePage(int id) {
    return ArticlePage(
      apiFunction: (page) {
        return MyService().dio.get("/wxarticle/list/$id/$page/json");
      },
    );
  }
}
