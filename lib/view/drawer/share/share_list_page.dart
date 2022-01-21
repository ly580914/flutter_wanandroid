import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:wanandroid/data/repository.dart';
import 'package:wanandroid/models/article_model.dart';
import 'package:wanandroid/view/common/common_article_page.dart';
import 'package:wanandroid/view/drawer/share/share_notify.dart';
import 'package:wanandroid/view/event_bus.dart';

class ShareListPage extends StatefulWidget {
  const ShareListPage({Key? key}) : super(key: key);

  @override
  _ShareListPageState createState() => _ShareListPageState();
}

class _ShareListPageState extends State<ShareListPage> {
  late StreamSubscription event;

  @override
  void initState() {
    super.initState();
    event = EventBusHolder.get.on<ShareNotify>().listen((event) {
      setState(() {

      });
    });
  }

  @override
  void dispose() {
    super.dispose();
    event.cancel();
  }

  @override
  Widget build(BuildContext context) {
    print('_ShareListPageState build');
    return ArticlePage(
      apiFunction: (page) {
        return Repository().getShareList(page);
      },
      title: '我的分享',
      actions: [
        IconButton(onPressed: () {
          Navigator.pushNamed(context, 'share');
        }, icon: Icon(Icons.add))
      ],
      dataFunction: (value) {
        return ArticleList.fromJson(value.data['data']['shareArticles']['datas']).list;
      },
      initPage: 1,
    );
  }
}
