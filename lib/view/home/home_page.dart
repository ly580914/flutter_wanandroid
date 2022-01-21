import 'dart:async';

import 'package:card_swiper/card_swiper.dart';
import 'package:event_bus/event_bus.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:wanandroid/account/account_info.dart';
import 'package:wanandroid/custom/custom.dart';
import 'package:wanandroid/data/repository.dart';
import 'package:wanandroid/main.dart';
import 'package:wanandroid/models/event_bus_model.dart';
import 'package:wanandroid/toast.dart';
import 'package:wanandroid/config/colors.dart';
import 'package:wanandroid/data/api.dart';
import 'package:wanandroid/data/service.dart';
import 'package:wanandroid/models/article_model.dart';
import 'package:wanandroid/models/banner_model.dart';
import 'package:wanandroid/page_status.dart';
import 'package:wanandroid/utils/text_utils.dart';
import 'package:wanandroid/utils/widget_utils.dart';
import 'package:wanandroid/view/common/article_item.dart';
import 'package:wanandroid/view/drawer/drawer_holder.dart';
import 'package:flutter_easyrefresh/easy_refresh.dart';

import '../event_bus.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late EasyRefreshController _easyRefreshController = EasyRefreshController();
  late ScrollController _scrollController = ScrollController();
  int pageStatus = PageStatus.statusLoading;
  int netCount = 0;
  late BannerList _bannerList;
  List<ArticleItem> articleList = <ArticleItem>[];
  int page = 0;
  bool showFloatingActionButton = false;
  late StreamSubscription event;
  bool _isRefreshing = false;

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
    _initData();

    event = EventBusHolder.get.on<LoginState>().listen((event) {
      print("EventBus on ${event.isLogin}");
      setState(() {});
    });
  }

  @override
  void dispose() {
    super.dispose();
    _easyRefreshController.dispose();
    _scrollController.dispose();
    event.cancel();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('玩Android'),
        actions: [
          IconButton(
              onPressed: () => Navigator.pushNamed(context, 'search'),
              icon: Icon(Icons.search))
        ],
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

  Widget _banner() {
    return Container(
      height: 220,
      color: Colors.grey,
      child: Swiper(
        itemBuilder: (BuildContext context, int index) {
          return Image.network(
            _bannerList.list[index].imagePath,
            fit: BoxFit.fill,
          );
        },
        itemCount: _bannerList.list.length,
        autoplay: true,
        pagination: SwiperPagination(
            margin: EdgeInsets.all(0.0),
            builder: SwiperCustomPagination(
                builder: (BuildContext context, SwiperPluginConfig? config) {
              return ConstrainedBox(
                child: Container(
                  color: Colors.black54,
                  child: Padding(
                      padding: EdgeInsets.symmetric(horizontal: 20),
                      child: Row(
                        children: [
                          Text(
                            "${_bannerList.list[config?.activeIndex as int].title}",
                            style: TextStyle(
                              fontSize: 18.0,
                              color: Colors.white,
                            ),
                          ),
                          Expanded(
                            child: Align(
                              alignment: Alignment.centerRight,
                              child: DotSwiperPaginationBuilder(
                                      color: Colors.white60,
                                      activeColor: Colors.white,
                                      size: 10.0,
                                      activeSize: 20.0)
                                  .build(context, config),
                            ),
                          )
                        ],
                      )),
                ),
                constraints: BoxConstraints.expand(height: 40.0),
              );
            })),
        controller: SwiperController(),
        indicatorLayout: PageIndicatorLayout.SCALE,
        // pagination: SwiperPagination(alignment: Alignment.topLeft)
      ),
    );
  }

  Widget _listView(BuildContext context) {
    return EasyRefresh(
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
        itemCount: articleList.length + 1,
        shrinkWrap: true,
        controller: _scrollController,
        itemBuilder: (BuildContext context, int index) {
          if (index == 0) {
            return _banner();
          }
          return articleItem(context, articleList[index - 1],);
        },
        separatorBuilder: (BuildContext context, int index) {
          return Divider(
            color: index == 0 ? Colors.transparent : AppColors.unactive2,
          );
        },
      ),
    );
  }

  void _initData() {
    // 加载轮播图
    MyService().dio.get(API.banner).then((value) {
      if (value.data['errorCode'] != 0) {
        MyToast.show(context, "获取轮播图失败 ${value.data['errorMsg']}");
        setState(() {
          pageStatus = PageStatus.statusLoadError;
        });
        return;
      }
      _bannerList = BannerList.fromJson(value.data['data']);
      if (++netCount > 2) {
        setState(() {
          pageStatus = PageStatus.statusLoaded;
        });
      }
    });
    // 加载置顶文章
    MyService().dio.get(API.topArticleList).then((value) {
      if (value.data['errorCode'] != 0) {
        MyToast.show(context, "获取文章失败 ${value.data['errorMsg']}");
        setState(() {
          pageStatus = PageStatus.statusLoadError;
        });
        return;
      }
      ArticleList list = ArticleList.fromJson(value.data['data']);
      list.list.forEach((element) {
        element.setTop = true;
      });
      articleList.insertAll(0, list.list);
      if (++netCount > 2) {
        setState(() {
          pageStatus = PageStatus.statusLoaded;
        });
      }
    });
    // 加载文章
    _getArticles();
  }

  bool _getArticles() {
    MyService().dio.get("/article/list/${page++}/json").then((value) {
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
      ArticleList list = ArticleList.fromJson(value.data['data']['datas']);
      articleList.addAll(list.list);
      if (++netCount > 2) {
        setState(() {
          pageStatus = PageStatus.statusLoaded;
        });
      }
    });
    return true;
  }

  Future _onLoad() async {
    if (_getArticles()) {
      _easyRefreshController.finishLoad(noMore: false, success: true);
    } else {
      _easyRefreshController.finishLoad(noMore: false, success: false);
    }
  }

  Future _onRefresh() async {
    netCount = 0;
    page = 0;
    _isRefreshing = true;
    _initData();
    _easyRefreshController.finishRefresh(success: true);
  }
}
