import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyrefresh/easy_refresh.dart';
import 'package:wanandroid/config/colors.dart';
import 'package:wanandroid/data/repository.dart';
import 'package:wanandroid/models/system_model.dart';
import 'package:wanandroid/utils/api_utils.dart';
import 'package:wanandroid/utils/widget_utils.dart';

import '../../page_status.dart';
import '../../toast.dart';

class SystemTabPage extends StatefulWidget {
  const SystemTabPage({Key? key}) : super(key: key);

  @override
  _SystemTabPageState createState() => _SystemTabPageState();
}

class _SystemTabPageState extends State<SystemTabPage>
    with AutomaticKeepAliveClientMixin {
  int pageStatus = PageStatus.statusLoading;
  List<SystemItem>? list;
  EasyRefreshController _easyRefreshController = EasyRefreshController();

  @override
  void initState() {
    super.initState();
    _initData();
  }

  Future _initData() async {
    Repository().getSystemData().then((value) {
      if (!ApiUtils.isSuccess(value)) {
        MyToast.show(context, "获取体系失败 ${value.data['errorMsg']}");
        setState(() {
          pageStatus = PageStatus.statusLoadError;
        });
        return;
      }
      this.list = SystemList.fromJson(value.data['data']).list;
      setState(() {
        pageStatus = PageStatus.statusLoaded;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return WidgetUtils.getPageStateWidget(context, pageStatus, _listView);
  }

  Widget _listView(BuildContext context) {
    return Container(
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
        onRefresh: _initData,
        child: ListView.builder(
            itemCount: list?.length,
            shrinkWrap: true,
            itemBuilder: (BuildContext context, int index) {
              return InkWell(
                onTap: () {
                  Navigator.pushNamed(context, 'system', arguments: list![index]);
                },

                child: Stack(
                  children: [
                    Padding(
                      padding:
                      EdgeInsets.only(left: 8, top: 6, bottom: 6, right: 36),
                      child: Column(
                        children: [
                          Row(
                            children: [
                              Text(
                                list![index].name,
                                style: TextStyle(
                                    color: AppColors.active, fontSize: 16),
                              ),
                              Expanded(child: Container())
                            ],
                          ),
                          SizedBox(
                            height: 8,
                          ),
                          Align(
                            alignment: Alignment.centerLeft,
                            child: Wrap(
                              spacing: 12,
                              runSpacing: 2,
                              alignment: WrapAlignment.start,
                              children: list![index]
                                  .children
                                  .map((e) => Container(
                                  height: 20,
                                  child: Center(
                                    widthFactor: 1,
                                    child: Text(
                                      e['name'],
                                      style: TextStyle(
                                          fontSize: 14,
                                          color: AppColors.unactive),
                                    ),
                                  )))
                                  .toList(),
                            ),
                          )
                        ],
                      ),
                    ),
                    Positioned(
                        child: Container(
                          width: double.infinity,
                          height: 0.5,
                          color: Colors.black12,
                        )),
                    Positioned(
                      right: 4,
                      top: 0,
                      bottom: 0,
                      child: Center(
                        child: Image.asset(
                          'images/icons/icon_into.png',
                          width: 30,
                          height: 50,
                          color: AppColors.unactive,
                        ),
                      ),
                    )
                  ],
                ),
              );
            }),
      ),
    );
  }

  @override
  bool get wantKeepAlive => true;
}
