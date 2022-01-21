import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyrefresh/easy_refresh.dart';
import 'package:wanandroid/config/colors.dart';
import 'package:wanandroid/data/repository.dart';
import 'package:wanandroid/models/article_model.dart';
import 'package:wanandroid/models/event_bus_model.dart';
import 'package:wanandroid/utils/widget_utils.dart';
import 'package:wanandroid/view/common/article_item.dart';
import 'package:wanandroid/view/drawer/drawer_holder.dart';

import '../../page_status.dart';
import '../../toast.dart';
import '../event_bus.dart';

@Deprecated(
  'Use ArticlePage instead. '
)
class SquarePage extends StatefulWidget {
  const SquarePage({Key? key}) : super(key: key);

  @override
  _SquarePageState createState() => _SquarePageState();
}

class _SquarePageState extends State<SquarePage> {
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
    _getArticles();

    event = EventBusHolder.get.on<LoginState>().listen((event) {
      setState(() {});
    });
  }

  bool _getArticles() {
    Repository().getSquareArticles(page++).then((value) {
      if (value.data['errorCode'] != 0) {
        MyToast.show(context, "获取文章失败 ${value.data['errorMsg']}");
        setState(() {
          pageStatus = PageStatus.statusLoadError;
        });
        return false;
      }
      ArticleList list = ArticleList.fromJson(value.data['data']['datas']);
      articleList.addAll(list.list);
      setState(() {
        pageStatus = PageStatus.statusLoaded;
      });
    });
    return true;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('广场'),
        actions: [IconButton(onPressed: () {}, icon: Icon(Icons.add))],
      ),
      drawer: DrawerHolder.drawer,
      body: WidgetUtils.getPageStateWidget(context, pageStatus, _listView),
      floatingActionButton: showFloatingActionButton
          ? FloatingActionButton(
              backgroundColor: AppColors.primary,
              onPressed: () {
                _scrollController.animateTo(0,
                    duration: Duration(
                      milliseconds: (_scrollController.offset / 8.0).toInt(),
                    ),
                    curve: Curves.linear);
              },
              child: Icon(
                Icons.arrow_upward,
                color: Colors.white,
              ),
            )
          : null,
    );
  }

  Widget _listView(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(top: 10),
      child: EasyRefresh(
        controller: _easyRefreshController,
        header: ClassicalHeader(
          refreshText: "下拉刷新",
          refreshReadyText: "释放刷新",
          refreshFailedText: "刷新失败",
          refreshedText: "刷新成功",
          refreshingText: "正在刷新...",
          // infoText: "更新于"
          showInfo: false,
        ),
        footer: ClassicalFooter(
          loadText: "上拉加载",
          loadFailedText: "加载失败",
          loadReadyText: "释放加载",
          loadingText: "加载中...",
          loadedText: "加载成功",
          showInfo: false,
        ),
        onLoad: _onLoad,
        onRefresh: _onRefresh,
        child: ListView.separated(
          itemCount: articleList.length,
          shrinkWrap: true,
          controller: _scrollController,
          itemBuilder: (BuildContext context, int index) {
            return articleItem(context, articleList[index],);
          },
          separatorBuilder: (BuildContext context, int index) {
            return Divider(
              color: AppColors.unactive2,
            );
          },
        ),
      ),
    );
  }

  Future _onLoad() async {
    if (_getArticles()) {
      _easyRefreshController.finishLoad(noMore: false, success: true);
    } else {
      _easyRefreshController.finishLoad(noMore: false, success: false);
    }
  }

  Future _onRefresh() async {
    page = 0;
    articleList.clear();
    _getArticles();
    _easyRefreshController.finishRefresh(success: true);
  }
}
