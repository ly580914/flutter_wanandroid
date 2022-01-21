import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:wanandroid/data/service.dart';
import 'package:wanandroid/view/common/common_article_page.dart';

class SearchDetailPage extends StatefulWidget {
  const SearchDetailPage({Key? key}) : super(key: key);

  @override
  _SearchDetailPageState createState() => _SearchDetailPageState();
}

class _SearchDetailPageState extends State<SearchDetailPage> {
  @override
  Widget build(BuildContext context) {
    String keyword = ModalRoute.of(context)?.settings.arguments as String;
    return ArticlePage(
      apiFunction: (page) {
        return MyService().dio.post("/article/query/$page/json", data: FormData.fromMap({"k": keyword}));
      },
      title: keyword,
    );
  }
}
