import 'package:card_swiper/card_swiper.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:wanandroid/common.dart';
import 'package:wanandroid/config/colors.dart';
import 'package:wanandroid/custom/custom.dart';
import 'package:wanandroid/data/api.dart';
import 'package:wanandroid/data/service.dart';
import 'package:wanandroid/models/article_model.dart';
import 'package:wanandroid/models/banner_model.dart';
import 'package:wanandroid/page_status.dart';
import 'package:wanandroid/utils/text_utils.dart';
import 'package:wanandroid/view/common/drawer_holder.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int bannerStatus = PageStatus.statusLoading;
  int netCount = 0;
  late BannerList _bannerList;
  List<ArticleItem> articleList = <ArticleItem>[];
  int page = 0;

  @override
  void initState() {
    super.initState();
    _getData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('玩Android'),
        actions: [IconButton(onPressed: () {}, icon: Icon(Icons.search))],
      ),
      drawer: DrawerHolder.drawer,
      body: bannerStatus == PageStatus.statusLoading
          ? Center(
              child: SizedBox(
                height: 22,
                width: 22,
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                  valueColor: AlwaysStoppedAnimation<Color>(AppColors.primary),
                ),
              ),
            )
          : bannerStatus == PageStatus.statusLoadError
              ? Center(
                  child: Text('加载失败'),
                )
              : _listView(context),
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
    return MediaQuery.removePadding(
      context: context,
      removeTop: true,
      child: ScrollConfiguration(
        behavior: CusBehavior(),
        child: ListView.separated(
          itemCount: articleList.length + 1,
          itemBuilder: (BuildContext context, int index) {
            if (index == 0) {
              return _banner();
            }
            return _articleItem(index - 1);
          },
          separatorBuilder: (BuildContext context, int index) {
            return Divider(
              color: index == 0 ? Colors.transparent : AppColors.unactive2,
            );
          },
        ),
      ),
    );
  }

  Widget _articleItem(int index) {
    ArticleItem item = articleList[index];
    return Padding(
      padding: EdgeInsets.only(left: 10, right: 10),
      child: Column(
        children: [
          Row(
            children: _topItems(item),
          ),
          SizedBox(
            height: 4,
          ),
          Align(
            child: Text(
              item.title,
              style: TextStyle(fontSize: 16, color: AppColors.active),
            ),
            alignment: Alignment.centerLeft,
          ),
          _bottomItem(item),
        ],
      ),
    );
  }

  List<Widget> _topItems(ArticleItem item) {
    // todo OffStage可以控制显示或隐藏
    bool havePadding = false;
    List<Widget> list = <Widget>[];
    if (item.top) {
      havePadding = true;
      list.add(Container(
        height: 16,
        width: 24,
        child: Center(
            child: Text('置顶',
                style: TextStyle(color: AppColors.blue, fontSize: 8))),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(2.0),
          border: new Border.all(width: 1, color: AppColors.blue),
        ),
      ));
    }

    if (DateTime.now().millisecondsSinceEpoch - item.publishTime < 86400000) {
      // print("diff.inDays < 1 : ${item.title} ----------> now = ${DateTime.now().millisecondsSinceEpoch}, publishTime = ${item.publishTime}");
      list.add(Container(
        height: 16,
        width: 16,
        margin: EdgeInsets.only(left: havePadding ? 8 : 0),
        child: Center(
          child: Text(
            '新',
            style: TextStyle(color: AppColors.tip, fontSize: 8),
          ),
        ),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(2.0),
          border: new Border.all(width: 1, color: AppColors.tip),
        ),
      ));
      havePadding = true;
    }

    late String name;
    if (!TextUtils.isEmpty(item.author)) {
      name = item.author as String;
    } else if (!TextUtils.isEmpty(item.shareUser)) {
      name = item.shareUser as String;
    }
    list.add(Padding(
        padding: EdgeInsets.only(left: havePadding ? 8 : 0),
        child: Text(
          name,
          style: TextStyle(fontSize: 12, color: AppColors.unactive),
        )));
    if (!TextUtils.isEmpty(item.niceDate)) {
      list.add(Expanded(
          child: Align(
        child: Text(
          item.niceDate as String,
          style: TextStyle(fontSize: 12, color: AppColors.unactive),
        ),
        alignment: Alignment.centerRight,
      )));
    }
    return list;
  }

  Widget _bottomItem(ArticleItem item) {
    return Container(
      height: 34,
      child: Stack(
        children: [
          Positioned(
              left: 0,
              bottom: 0,
              child: Text(
                "${item.superChapterName} / ${item.chapterName}",
                style: TextStyle(color: AppColors.unactive, fontSize: 12),
              )),
          Positioned(
            bottom: 0,
            right: 0,
            child: Image.asset(
              'images/icons/icon_zan.png',
              width: 24,
              height: 24,
              color: AppColors.unactive2,
            ),
          )
        ],
      ),
    );
  }

  void _getData() {
    // 加载轮播图
    MyService().dio.get(API.banner).then((value) {
      if (value.data['errorCode'] != 0) {
        toast("获取轮播图失败 ${value.data['errorMsg']}");
        setState(() {
          bannerStatus = PageStatus.statusLoadError;
        });
        return;
      }
      _bannerList = BannerList.fromJson(value.data['data']);
      if (++netCount == 2) {
        setState(() {
          bannerStatus = PageStatus.statusLoaded;
        });
      }
    });
    // 加载置顶文章
    MyService().dio.get(API.topArticleList).then((value) {
      if (value.data['errorCode'] != 0) {
        toast("获取文章失败 ${value.data['errorMsg']}");
        setState(() {
          bannerStatus = PageStatus.statusLoadError;
        });
        return;
      }
      ArticleList list = ArticleList.fromJson(value.data['data']);
      list.list.forEach((element) {
        element.setTop = true;
      });
      articleList.insertAll(0, list.list);
      if (++netCount == 2) {
        setState(() {
          bannerStatus = PageStatus.statusLoaded;
        });
      }
    });
    // 加载文章
    MyService().dio.get("/article/list/${page++}/json").then((value) {
      if (value.data['errorCode'] != 0) {
        toast("获取文章失败 ${value.data['errorMsg']}");
        setState(() {
          bannerStatus = PageStatus.statusLoadError;
        });
        return;
      }
      ArticleList list = ArticleList.fromJson(value.data['data']['datas']);
      articleList.addAll(list.list);
      if (++netCount == 3) {
        setState(() {
          bannerStatus = PageStatus.statusLoaded;
        });
      }
    });
  }
}
