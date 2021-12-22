import 'package:card_swiper/card_swiper.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:wanandroid/common.dart';
import 'package:wanandroid/data/api.dart';
import 'package:wanandroid/data/service.dart';
import 'package:wanandroid/models/banner_model.dart';
import 'package:wanandroid/page_status.dart';
import 'package:wanandroid/view/common/drawer_holder.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  // late List<Widget> _bannerList;
  int statusCode = PageStatus.statusLoading;
  late BannerList _bannerList;

  @override
  void initState() {
    super.initState();
    MyService().dio.get(API.banner).then((value) {
      if (value.data['errorCode'] != 0) {
        toast("获取轮播图失败 ${value.data['errorMsg']}");
        statusCode = PageStatus.statusLoadError;
        return;
      }
      setState(() {
        statusCode = PageStatus.statusLoaded;
        _bannerList = BannerList.fromJson(value.data['data']);
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('玩Android'),
        actions: [IconButton(onPressed: () {}, icon: Icon(Icons.search))],
      ),
      drawer: DrawerHolder.drawer,
      body: Column(
        children: [
          _banner(),
          Padding(
            padding: EdgeInsets.all(60),
            child: Text("jhbjhasvdjhasv"),
          )
        ],
      ),
    );
  }

  Widget _banner() {
    return  Container(
      height: 220,
      color: Colors.grey,
      child: statusCode == PageStatus.statusLoading
          ? Center(child: Text('加载中'))
          : statusCode == PageStatus.statusLoadError
          ? Center(child: Text('加载失败'))
          : Swiper(
        itemBuilder: (BuildContext context, int index) {
          return Image.network(_bannerList.list[index].imagePath, fit: BoxFit.fill,);
        },
        itemCount: _bannerList.list.length,
        autoplay: true,
        pagination: SwiperPagination(
            margin: EdgeInsets.all(0.0),
            builder: SwiperCustomPagination(builder:
                (BuildContext context,
                SwiperPluginConfig? config) {
              return ConstrainedBox(
                child: Container(
                  color: Colors.black54,
                  child: Padding(
                      padding:
                      EdgeInsets.symmetric(horizontal: 20),
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
                constraints:
                BoxConstraints.expand(height: 40.0),
              );
            })),
        controller: SwiperController(),
        indicatorLayout: PageIndicatorLayout.SCALE,
        // pagination: SwiperPagination(alignment: Alignment.topLeft)
      ),
    );
  }
}
