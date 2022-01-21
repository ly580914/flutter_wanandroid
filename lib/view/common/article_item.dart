import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:wanandroid/account/account_info.dart';
import 'package:wanandroid/config/colors.dart';
import 'package:wanandroid/data/repository.dart';
import 'package:wanandroid/models/article_model.dart';
import 'package:wanandroid/utils/text_utils.dart';
import 'package:wanandroid/view/common/def.dart';

import '../../toast.dart';


Widget articleItem(BuildContext context, ArticleItem item) {
  return InkWell(
    onTap: () {
      Map<String, dynamic> args = {'url': item.link, 'title': item.title, 'id': item.id};
      Navigator.pushNamed(context, 'webview', arguments: args,);
    },
    child: Padding(
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
          _bottomItem(context, item),
        ],
      ),
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

Widget _bottomItem(BuildContext context, ArticleItem item) {
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
          child: _collectionView(context, item.id),
        )
      ],
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
          Repository().unCollect(articleId).then((value) {
            if (value.data['errorCode'] != 0) {
              MyToast.show(context, '取消收藏失败');
              account.addCollect(articleId);
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
          Repository().collect(articleId).then((value) {
            if (value.data['errorCode'] != 0) {
              MyToast.show(context, '收藏失败');
              account.unCollect(articleId);
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
