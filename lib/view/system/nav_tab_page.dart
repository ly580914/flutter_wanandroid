import 'dart:math';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyrefresh/easy_refresh.dart';
import 'package:wanandroid/config/colors.dart';
import 'package:wanandroid/custom/custom.dart';
import 'package:wanandroid/data/repository.dart';
import 'package:wanandroid/models/nav_model.dart';
import 'package:wanandroid/utils/api_utils.dart';
import 'package:wanandroid/utils/widget_utils.dart';

import '../../page_status.dart';
import '../../toast.dart';

class NavTabPage extends StatefulWidget {
  const NavTabPage({Key? key}) : super(key: key);

  @override
  _NavTabPageState createState() => _NavTabPageState();
}

class _NavTabPageState extends State<NavTabPage>
    with AutomaticKeepAliveClientMixin {
  int pageStatus = PageStatus.statusLoading;
  List<NavItem>? list;
  int curIndex = 0;
  ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _initData();
  }

  @override
  void dispose() {
    super.dispose();
    _scrollController.dispose();
  }

  void _initData() {
    Repository().getNaviData().then((value) {
      if (!ApiUtils.isSuccess(value)) {
        MyToast.show(context, "获取导航失败 ${value.data['errorMsg']}");
        setState(() {
          pageStatus = PageStatus.statusLoadError;
        });
        return;
      }
      this.list = NavList.fromJson(value.data['data']).list;
      setState(() {
        pageStatus = PageStatus.statusLoaded;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return WidgetUtils.getPageStateWidget(context, pageStatus, _dataList);
  }

  Widget _dataList(BuildContext context) {
    return Row(
      children: [
        Container(
          width: 105,
          child: ScrollConfiguration(
            behavior: CusBehavior(),
            child: ListView.builder(
              itemCount: list?.length,
              shrinkWrap: true,
              itemBuilder: (BuildContext contexnt, int index) {
                return InkWell(
                  onTap: () => setState(() {
                    curIndex = index;
                    // _scrollController.animateTo(offset, duration: duration, curve: curve)
                    // print('_scrollController.position = ${_scrollController.jumpTo(value)}');
                  }),
                  child: Container(
                    height: 54,
                    color: index == curIndex ? AppColors.page : Colors.black12,
                    child: Center(
                      child: Text(
                        list?[index].name as String,
                        style: TextStyle(
                            color: index == curIndex
                                ? AppColors.blue
                                : AppColors.unactive,
                            fontSize: 16),
                      ),
                    ),
                  ),
                );
              }),),
        ),
        Container(
          width: 0.5,
          height: double.infinity,
          color: Colors.black12,
        ),
        Expanded(
            child: ScrollConfiguration(
          behavior: CusBehavior(),
          child: ListView.builder(
              controller: _scrollController,
              itemCount: list?.length,
              shrinkWrap: true,
              itemBuilder: (BuildContext context, int index) {
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: EdgeInsets.only(left: 12, top: 10),
                      child: Text(
                        list?[index].name as String,
                        style: TextStyle(color: AppColors.active, fontSize: 16),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.all(12),
                      child: Wrap(
                          spacing: 10,
                          runSpacing: 10,
                          alignment: WrapAlignment.start,
                          children: (list?[index].articles as List)
                              .map((e) => InkWell(
                                    onTap: () {
                                      Map<String, String> args = {
                                        'url': e.link,
                                        'title': e.title
                                      };
                                      Navigator.pushNamed(
                                        context,
                                        'webview',
                                        arguments: args,
                                      );
                                    },
                                    child: Container(
                                        height: 36,
                                        color: Colors.black12,
                                        child: Center(
                                          widthFactor: 1,
                                          child: Padding(
                                            padding: EdgeInsets.symmetric(
                                                horizontal: 8),
                                            child: Text(
                                              e.title,
                                              style: TextStyle(color: e.color),
                                            ),
                                          ),
                                        )),
                                  ))
                              .toList()),
                    )
                  ],
                );
              }),
        )),
      ],
    );
  }

  @override
  bool get wantKeepAlive => true;
}
