import 'package:flutter/cupertino.dart';
import 'package:wanandroid/data/repository.dart';

import 'collect_article_page.dart';

class CollectListPage extends StatelessWidget {
  const CollectListPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return CollectArticlePage(
      apiFunction: (page) {
        return Repository().getCollectList(page);
      },
      title: '收藏',
    );
  }

}
