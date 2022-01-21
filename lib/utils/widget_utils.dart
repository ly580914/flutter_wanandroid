import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:wanandroid/config/colors.dart';
import 'package:wanandroid/view/common/def.dart';

import '../page_status.dart';

class WidgetUtils {

  static Widget getPageStateWidget(BuildContext context, int pageStatus, WidgetFunction fun) {
    if (pageStatus == PageStatus.statusLoading) {
      return Center(
        child: SizedBox(
          height: 22,
          width: 22,
          child: CircularProgressIndicator(
            strokeWidth: 2,
            valueColor: AlwaysStoppedAnimation<Color>(AppColors.primary),
          ),
        ),
      );
    }
    if (pageStatus == PageStatus.statusLoadError) {
      return Center(
        child: Text('加载失败'),
      );
    }
    if (pageStatus == PageStatus.statusEmpty) {
      return Center(
        child: Container(
          margin: EdgeInsets.only(bottom: 100),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset('images/icons/icon_empty.png', width: 80, height: 80,),
              SizedBox(height: 6,),
              Text('暂无数据', style: TextStyle(color: AppColors.unactive),)
            ],
          ),
        )
      );
    }
    return fun.call(context);
  }
}
