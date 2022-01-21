import 'dart:async';

import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyrefresh/easy_refresh.dart';
import 'package:wanandroid/account/account_info.dart';
import 'package:wanandroid/config/colors.dart';
import 'package:wanandroid/data/repository.dart';
import 'package:wanandroid/data/service.dart';
import 'package:wanandroid/models/article_model.dart';
import 'package:wanandroid/models/event_bus_model.dart';
import 'package:wanandroid/utils/widget_utils.dart';
import 'package:wanandroid/view/common/article_item.dart';
import 'package:wanandroid/view/drawer/drawer_holder.dart';

import '../../page_status.dart';
import '../../toast.dart';
import '../event_bus.dart';

class ProjectItemPage extends StatefulWidget {
  late int id;

  ProjectItemPage({Key? key, required int id})
      : this.id = id,
        super(key: key);

  @override
  _ProjectItemPageState createState() => _ProjectItemPageState();
}

class _ProjectItemPageState extends State<ProjectItemPage>
    with AutomaticKeepAliveClientMixin {
  EasyRefreshController _easyRefreshController = EasyRefreshController();
  ScrollController _scrollController = ScrollController();
  int pageStatus = PageStatus.statusLoading;
  int page = 1;
  bool showFloatingActionButton = false;
  late StreamSubscription event;
  List<ArticleItem> articleList = <ArticleItem>[];
  bool _isRefreshing = true;

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
    MyService()
        .dio
        .get("/project/list/${page++}/json?cid=${widget.id}")
        .then((value) {
      if (value.data['errorCode'] != 0) {
        MyToast.show(context, "获取文章失败 ${value.data['errorMsg']}");
        setState(() {
          pageStatus = PageStatus.statusLoadError;
        });
        return false;
      }
      if (_isRefreshing) {
        _isRefreshing = false;
        articleList.clear();
      }
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
    return WidgetUtils.getPageStateWidget(context, pageStatus, _listView);
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
            itemCount: articleList.length,
            shrinkWrap: true,
            controller: _scrollController,
            itemBuilder: (BuildContext context, int index) {
              return _projectItem(
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
    if (_getArticles()) {
      _easyRefreshController.finishLoad(noMore: false, success: true);
    } else {
      _easyRefreshController.finishLoad(noMore: false, success: false);
    }
  }

  Future _onRefresh() async {
    page = 0;
    _isRefreshing = true;
    _getArticles();
    _easyRefreshController.finishRefresh(success: true);
  }

  @override
  // TODO: implement wantKeepAlive
  bool get wantKeepAlive => true;

  Widget _projectItem(BuildContext context, ArticleItem item) {
    return IntrinsicHeight(
      // TODO listview中的column中要使用expand，要用IntrinsicHeight包裹
      child: InkWell(
        onTap: () {
          Map<String, String> args = {'url': item.link, 'title': item.title};
          Navigator.pushNamed(
            context,
            'webview',
            arguments: args,
          );
        },
        child: Padding(
          padding: EdgeInsets.all(10),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Image.network(
                item.envelopePic as String,
                width: 100,
                height: 170,
                fit: BoxFit.cover,
              ),
              Expanded(
                  child: Padding(
                padding: EdgeInsets.only(left: 14),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      item.title,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(color: AppColors.active, fontSize: 16),
                    ),
                    SizedBox(
                      height: 8,
                    ),
                    Text(
                      item.desc as String,
                      maxLines: 3,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(color: AppColors.unactive, fontSize: 14),
                    ),
                    Expanded(
                      child: Stack(
                        children: [
                          Positioned(
                              bottom: 30,
                              left: 0,
                              right: 0,
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(item.author as String,
                                      style: TextStyle(
                                          color: AppColors.unactive,
                                          fontSize: 12)),
                                  Text(item.niceDate as String,
                                      style: TextStyle(
                                          color: AppColors.unactive,
                                          fontSize: 12))
                                ],
                              ),
                          ),
                          Positioned(
                              right: 0,
                              bottom: 0,
                              child: _collectionView(context, item.id))
                        ],
                      ),
                    )
                  ],
                ),
              )),
            ],
          ),
        ),
      ),
    );
  }

  Widget _collectionView(BuildContext context, int articleId) {
    Account? account = Account.get;
    if (account != null) {
      List<int>? ids = Account.get.collectIds;
      if (ids is List<int> && ids.contains(articleId)) {
        return InkWell(
          onTap: () {
            account.unCollect(articleId);
            setState(() {

            });
            Repository().unCollect(articleId).then((value) {
              if (value.data['errorCode'] != 0) {
                MyToast.show(context, '取消收藏失败');
                account.addCollect(articleId);
                setState(() {

                });
              } else {
                MyToast.show(context, '取消收藏成功');
              }
            });
          },
          child: Image.asset(
            'images/icons/icon_zan_active.png',
            width: 24,
            height: 24,
          ),
        );
      }  else {
        return InkWell(
          onTap: () {
            account.addCollect(articleId);
            setState(() {

            });
            Repository().collect(articleId).then((value) {
              if (value.data['errorCode'] != 0) {
                MyToast.show(context, '收藏失败');
                account.unCollect(articleId);
                setState(() {

                });
              } else {
                MyToast.show(context, '收藏成功');
              }
            });
          },
          child: Image.asset(
            'images/icons/icon_zan.png',
            width: 24,
            height: 24,
            color: AppColors.unactive2,
          ),
        );
      }
    }
    return InkWell(
      onTap: () {
        Navigator.pushNamed(context, 'login');
      },
      child: Image.asset(
        'images/icons/icon_zan.png',
        width: 24,
        height: 24,
        color: AppColors.unactive2,
      ),
    );
  }


}
