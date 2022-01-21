import 'dart:async';

import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyrefresh/easy_refresh.dart';
import 'package:wanandroid/config/colors.dart';
import 'package:wanandroid/models/article_model.dart';
import 'package:wanandroid/models/event_bus_model.dart';
import 'package:wanandroid/utils/widget_utils.dart';
import 'package:wanandroid/view/common/article_item.dart';
import 'package:wanandroid/view/drawer/drawer_holder.dart';
import 'package:wanandroid/view/event_bus.dart';

import '../../../page_status.dart';
import '../../../toast.dart';
import 'collect_article_item.dart';

typedef apiFunction = Future<Response> Function(int page);

class CollectArticlePage extends StatefulWidget {
  apiFunction _apiFunction;
  String? _title;
  bool _hasDrawer;
  bool _hasSearch;

  CollectArticlePage(
      {Key? key,
      required apiFunction apiFunction,
      String? title,
      bool? hasDrawer,
      bool? hasSearch})
      : _apiFunction = apiFunction,
        _title = title,
        _hasDrawer = hasDrawer == null ? false : hasDrawer,
        _hasSearch = hasSearch == null ? false : hasSearch,
        super(key: key);

  @override
  _CollectArticlePageState createState() => _CollectArticlePageState();
}

class _CollectArticlePageState extends State<CollectArticlePage>
    with AutomaticKeepAliveClientMixin {
  EasyRefreshController _easyRefreshController = EasyRefreshController();
  ScrollController _scrollController = ScrollController();
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
    widget._apiFunction(page++).then((value) {
      if (value.data['errorCode'] != 0) {
        MyToast.show(context, "获取文章失败 ${value.data['errorMsg']}");
        if (pageStatus == PageStatus.statusLoading) {
          setState(() {
            pageStatus = PageStatus.statusLoadError;
          });
        }
        return false;
      }
      print('value.data = ${value.data.toString()}');
      ArticleList list = ArticleList.fromJson(value.data['data']['datas']);
      articleList.addAll(list.list);
      // _easyRefreshController.finishLoad(noMore: false);
      setState(() {
        pageStatus = PageStatus.statusLoaded;
      });
      if (value.data['data']['over']) {
        _easyRefreshController.finishLoad(noMore: true);
      }
    });
    return true;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: widget._title == null
          ? null
          : AppBar(
              title: Text(widget._title as String),
              actions: widget._hasSearch ? [
                IconButton(
                    onPressed: () => Navigator.pushNamed(context, 'search'),
                    icon: Icon(Icons.search))
              ] : null,
            ),
      drawer: widget._title == null || !widget._hasDrawer ? null : DrawerHolder.drawer,
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
            noMoreText: '没有更多数据',
          ),
          onLoad: _onLoad,
          onRefresh: _onRefresh,
          child: ListView.separated(
            addAutomaticKeepAlives: false,
            addRepaintBoundaries: false,
            itemCount: articleList.length + 1,
            shrinkWrap: true,
            controller: _scrollController,
            itemBuilder: (BuildContext context, int index) {
              if (index == articleList.length) {
                return Container(
                  width: double.infinity,
                  height: 0.1,
                );
              }
              return CollectArticleItem(context, articleList[index], (item) {
                setState(() {
                  if (item.remove) {
                    articleList.remove(item.item);
                  }else {
                    articleList.add(item.item);
                  }


                });
              });
            },
            separatorBuilder: (BuildContext context, int index) {
              return Divider(
                // height: index == 0 ? 60 : 0,

                color: AppColors.unactive2,
              );
            },
          )),
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

  @override
  // TODO: implement wantKeepAlive
  bool get wantKeepAlive => true;
}

class CollectItemChanged {
  ArticleItem item;
  bool remove;

  CollectItemChanged({required this.item, required this.remove});
}