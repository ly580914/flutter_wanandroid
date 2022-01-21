import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyrefresh/easy_refresh.dart';
import 'package:wanandroid/account/account_info.dart';
import 'package:wanandroid/config/colors.dart';
import 'package:wanandroid/custom/custom.dart';
import 'package:wanandroid/data/repository.dart';
import 'package:wanandroid/models/integral_model.dart';
import 'package:wanandroid/utils/api_utils.dart';
import 'package:wanandroid/utils/widget_utils.dart';

import '../../../page_status.dart';
import '../../../toast.dart';


class IntegralPage extends StatefulWidget {
  const IntegralPage({Key? key}) : super(key: key);

  @override
  _IntegralPageState createState() => _IntegralPageState();
}

class _IntegralPageState extends State<IntegralPage> {
  int pageStatus = PageStatus.statusLoading;
  var list = <IntegralItem>[];
  int page = 1;
  EasyRefreshController _easyRefreshController = EasyRefreshController();
  bool _isRefreshing = false;

  @override
  void initState() {
    super.initState();
    _getData();
  }

  @override
  void dispose() {
    super.dispose();
    _easyRefreshController.dispose();
  }

  bool _getData() {
    Repository().getIntegralList(page++).then((value) {
      if (!ApiUtils.isSuccess(value)) {
        MyToast.show(context, "查询失败 ${value.data['errorMsg']}");
        if (pageStatus == PageStatus.statusLoading) {
          setState(() {
            pageStatus = PageStatus.statusLoadError;
          });
        }
        return false;
      }
      setState(() {
        if (_isRefreshing) {
          _isRefreshing = false;
          list.clear();
        }
        list.addAll(IntegralList.fromJson(value.data['data']['datas']).list);
        pageStatus = PageStatus.statusLoaded;
        if (value.data['data']['over']) {
          _easyRefreshController.finishLoad(noMore: true);
        }
      });
    });
    return true;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: NestedScrollView(
            headerSliverBuilder:
                (BuildContext context, bool innerBoxIsScrolled) {
              return [
                SliverAppBar(
                    title: Text('积分明细'),
                    expandedHeight: 170,
                    forceElevated: true,
                    actions: [
                      IconButton(
                        onPressed: () {
                          Map<String, dynamic> args = {'url': 'https://www.wanandroid.com/blog/show/2653', 'title': '本站积分规则s'};
                          Navigator.pushNamed(context, 'webview', arguments: args);
                        },
                        icon: Image.asset('images/icons/icon_wenhao.png',
                            width: 24, height: 24, color: Colors.white),
                      )
                    ],
                    backgroundColor: AppColors.primary,
                    elevation: 0.0,
                    flexibleSpace: FlexibleSpaceBar(
                        collapseMode: CollapseMode.parallax,
                        background: Container(
                            child: Padding(
                          padding: EdgeInsets.only(top: 60),
                          child: Center(
                            child: Text(
                              '${Account.get.coinCount}',
                              style:
                                  TextStyle(fontSize: 50, color: Colors.white),
                            ),
                          ),
                        ))))
              ];
            },
            body: WidgetUtils.getPageStateWidget(context, pageStatus, _body)));
  }

  Widget _body(BuildContext context) {
    return MediaQuery.removePadding(
      context: context,
      removeTop: true,
      child: ScrollConfiguration(
          behavior: CusBehavior(),
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
              child: ListView.builder(
                  itemCount: list.length,
                  itemBuilder: (BuildContext context, int index) {
                    return Container(
                      height: 80,
                      child: Stack(
                        children: [
                          Positioned(
                              left: 16,
                              top: 16,
                              child: Text(
                                list[index].reason,
                                style: TextStyle(
                                  fontSize: 15,
                                ),
                              )),
                          Positioned(
                              left: 16,
                              bottom: 16,
                              child: Text(
                                list[index].desc,
                                style: TextStyle(
                                    fontSize: 14, color: AppColors.unactive),
                              )),
                          Positioned(
                              bottom: 0,
                              left: 0,
                              right: 0,
                              child: Container(
                                height: 0.5,
                                color: Colors.black12,
                              )),
                          Positioned(
                              top: 0,
                              left: 0,
                              right: 0,
                              child: Container(
                                height: 0.5,
                                color: Colors.black12,
                              ))
                        ],
                      ),
                    );
                  })),
      ),
    );
  }

  Future _onLoad() async {
    if (_getData()) {
      _easyRefreshController.finishLoad(noMore: false, success: true);
    } else {
      _easyRefreshController.finishLoad(noMore: false, success: false);
    }
  }

  Future _onRefresh() async {
    page = 1;
    _isRefreshing = true;
    _getData();
    _easyRefreshController.finishRefresh(success: true);

  }
}
