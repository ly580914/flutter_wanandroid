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
import 'package:wanandroid/view/drawer/share/share_notify.dart';

import '../../page_status.dart';
import '../../toast.dart';
import '../event_bus.dart';

typedef ApiFunction = Future<Response> Function(int);
typedef DataFunction = List<ArticleItem> Function(Response);

class ArticlePage extends StatefulWidget {
  ApiFunction _apiFunction;
  String? _title;
  bool _hasDrawer;
  bool _hasSearch;
  List<Widget>? _actions;
  DataFunction? _dataFunction;
  int? _initPage; // api很恶心，有的起始页是0，有的是1

  ArticlePage({Key? key,
    required ApiFunction apiFunction,
    String? title,
    bool? hasDrawer,
    bool? hasSearch,
    List<Widget>? actions,
    DataFunction? dataFunction,
    int? initPage,
    VoidCallback? initFunction})
      : _apiFunction = apiFunction,
        _title = title,
        _hasDrawer = hasDrawer == null ? false : hasDrawer,
        _hasSearch = hasSearch == null ? false : hasSearch,
        _actions = actions,
        _dataFunction = dataFunction,
        _initPage = initPage,
        super(key: key);

  @override
  _ArticlePageState createState() => _ArticlePageState();
}

class _ArticlePageState extends State<ArticlePage>
    with AutomaticKeepAliveClientMixin {
  EasyRefreshController _easyRefreshController = EasyRefreshController();
  ScrollController _scrollController = ScrollController();
  int pageStatus = PageStatus.statusLoading;
  late int page;
  bool showFloatingActionButton = false;
  late StreamSubscription event;
  List<ArticleItem> articleList = <ArticleItem>[];
  bool _isRefreshing = false;

  @override
  void initState() {
    super.initState();
    double lastOffset = 0.0;
    if (widget._initPage == null) {
      page = 0;
    } else {
      page = widget._initPage!;
    }
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
    _registerOtherEvent();
  }

  @override
  void dispose() {
    super.dispose();
    shareEvent.cancel();
    event.cancel();
    _easyRefreshController.dispose();
    _scrollController.dispose();
  }

  Future<bool> _getArticles() async {
    bool result = await widget._apiFunction(page++).then((value) {
      if (value.data['errorCode'] != 0) {
        MyToast.show(context, "获取文章失败 ${value.data['errorMsg']}");
        if (pageStatus == PageStatus.statusLoading) {
          setState(() {
            pageStatus = PageStatus.statusLoadError;
          });
        }
        return false;
      }
      if (_isRefreshing) {
        _isRefreshing = false;
        articleList.clear();
      }
      if (widget._dataFunction != null) {
        articleList.addAll(widget._dataFunction!.call(value));
      } else {
        ArticleList list = ArticleList.fromJson(value.data['data']['datas']);
        articleList.addAll(list.list);
      }
      setState(() {
        if (articleList.isEmpty) {
          pageStatus = PageStatus.statusEmpty;
        } else {
          pageStatus = PageStatus.statusLoaded;
        }
        if (value.data['data']['over'] is bool && value.data['data']['over']) {
          _easyRefreshController.finishLoad(noMore: true);
        }
      });

      return true;
    });
    return result;
  }

  @override
  Widget build(BuildContext context) {
    print('on build pageStatus = $pageStatus');
    return Scaffold(
      appBar: widget._title == null
          ? null
          : AppBar(
        title: Text(widget._title as String),
        actions: widget._actions != null
            ? widget._actions
            : widget._hasSearch
            ? [
          IconButton(
              onPressed: () =>
                  Navigator.pushNamed(context, 'search'),
              icon: Icon(Icons.search))
        ]
            : null,
      ),
      drawer: widget._title == null || !widget._hasDrawer
          ? null
          : DrawerHolder.drawer,
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
              // 强行给最后一个item加上分界线，虽然这样做不太好，但还是懒得改了，实际操作使用listview.builder,分界线直接画到item里
              if (index == articleList.length) {
                return Container(
                  width: double.infinity,
                  height: 0.1,
                );
              }
              print('id = ${articleList[index].id}');
              return articleItem(
                context,
                articleList[index],
              );
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
    _getArticles().then((value) {
      if (value) {
        _easyRefreshController.finishLoad(noMore: false, success: true);
      } else {
        _easyRefreshController.finishLoad(noMore: false, success: false);
      }
    });

  }

  Future _onRefresh() async {
    page = 0;
    _isRefreshing = true;
    _getArticles();
    _easyRefreshController.finishRefresh(success: true);
  }

  @override
  bool get wantKeepAlive => true;

  // 临时用个方法处理不同业务，太耦合，不实用
  late StreamSubscription shareEvent;
  void _registerOtherEvent() {
    shareEvent = EventBusHolder.get.on<ShareNotify>().listen((event) {
      setState(() {
        pageStatus = PageStatus.statusLoading;
      });
      _onRefresh();
    });
  }
}
