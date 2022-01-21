import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:wanandroid/config/colors.dart';
import 'package:wanandroid/data/repository.dart';
import 'package:wanandroid/models/project_model.dart';
import 'package:wanandroid/utils/api_utils.dart';
import 'package:wanandroid/view/drawer/drawer_holder.dart';
import 'package:wanandroid/utils/widget_utils.dart';
import 'package:wanandroid/view/project/project_item_page.dart';

import '../../page_status.dart';
import '../../toast.dart';

class ProjectPage extends StatefulWidget {
  const ProjectPage({Key? key}) : super(key: key);

  @override
  _ProjectPageState createState() => _ProjectPageState();
}

class _ProjectPageState extends State<ProjectPage>
    with TickerProviderStateMixin {
  late TabController? _tabController;
  int pageStatus = PageStatus.statusLoading;
  List<ProjectTabItem>? _tabs;
  var _contenPages = <Widget>[];

  @override
  void initState() {
    super.initState();
    _initData();
  }

  void _initData() {
    Repository().getProjectTabs().then((value) {
      if (!ApiUtils.isSuccess(value)) {
        MyToast.show(context, "获取导航失败 ${value.data['errorMsg']}");
        setState(() {
          pageStatus = PageStatus.statusLoadError;
        });
        return;
      }
      _tabs = ProjectTabList.fromJson(value.data['data']).list;
      _tabs?.forEach((element) {
        _contenPages.add(_articlePage(element.id));
      });
      _tabController = TabController(length: _tabs?.length as int, vsync: this);
      setState(() {
        pageStatus = PageStatus.statusLoaded;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('项目'),
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
        body:WidgetUtils.getPageStateWidget(context, pageStatus, _body));
  }

  Widget _body(BuildContext context) {
    return TabBarView(
      children: _contenPages,
      controller: _tabController,
    );
  }

  Widget _articlePage(int id) {
    return ProjectItemPage(
      id: id,
    );
  }
}
