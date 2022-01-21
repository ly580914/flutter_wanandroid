import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:share_plus/share_plus.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:wanandroid/account/account_info.dart';
import 'package:wanandroid/data/repository.dart';
import 'package:wanandroid/models/event_bus_model.dart';
import 'package:wanandroid/view/event_bus.dart';
import 'package:wanandroid/view/search/search_page.dart';
import 'package:webview_flutter/webview_flutter.dart';

import '../toast.dart';

class MyWebView extends StatefulWidget {
  MyWebView({Key? key}) : super(key: key);

  @override
  _MyWebViewState createState() => _MyWebViewState();
}

class _MyWebViewState extends State<MyWebView> {
  Account? account = Account.get;

  @override
  void initState() {
    super.initState();
    if (Platform.isAndroid) {
      WebView.platform = AndroidWebView();
    }
  }

  @override
  Widget build(BuildContext context) {
    Map<String, dynamic> args =
        ModalRoute.of(context)?.settings.arguments as Map<String, dynamic>;
    print('webview url = ${args['url']}');
    return Scaffold(
      appBar: AppBar(
        title: Text(args['title'],
            style: TextStyle(overflow: TextOverflow.ellipsis)),
        actions: args['id'] == null ? null : [
          PopupMenuButton(
            icon: Icon(Icons.more_vert),
            itemBuilder: (BuildContext context) => <PopupMenuItem>[
              PopupMenuItem(
                child: Text('分享'),
                value: 1,
              ),
              PopupMenuItem(
                child: Text(account != null && account!.isCollect(args['id']) ? "取消收藏" : '收藏'),
                value: 2,
              ),
              PopupMenuItem(child: Text('浏览器打开'), value: 3,),
            ],
            onSelected: (value) {
              switch (value) {
                case 1:
                  _share(args['title'], args['url']);
                  break;
                case 2:
                  _collect(args['id']);
                  break;
                case 3:
                  _openInBrowser(args['url']);
                  break;
              }
            },
          )
        ],
      ),
      body: WebView(
        initialUrl: args['url'],
      ),
    );
  }

  void _share(String title, String url) {
    final box = context.findRenderObject() as RenderBox;
    Share.share('玩Android分享文章【$title】: $url',
        subject: 'subject',
        sharePositionOrigin: box.localToGlobal(Offset.zero) & box.size);
  }

  void _collect(int id) {
    if (account == null) {
      Navigator.pushNamed(context, 'login');
      return;
    }
    if (account!.isCollect(id)) {
      account!.unCollect(id);
      setState(() {});
      Repository().unCollect(id).then((value) {
        if (value.data['errorCode'] != 0) {
          MyToast.show(context, '取消收藏失败');
          account!.addCollect(id);
          setState(() {});
        } else {
          MyToast.show(context, '取消收藏成功');
          EventBusHolder.get.fire(LoginState(true));
        }
      });
    } else {
      account!.addCollect(id);
      setState(() {});
      Repository().collect(id).then((value) {
        if (value.data['errorCode'] != 0) {
          MyToast.show(context, '收藏失败');
          account!.unCollect(id);
          setState(() {});
        } else {
          MyToast.show(context, '收藏成功');
          EventBusHolder.get.fire(LoginState(true));
        }
      });
    }
  }

  void _openInBrowser(String url) {
    launch(url);
  }
}
