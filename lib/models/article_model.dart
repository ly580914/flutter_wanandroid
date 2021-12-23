class ArticleList {
  final List<ArticleItem> list;
  ArticleList(this.list);
  factory ArticleList.fromJson(List<dynamic> list) {
    return ArticleList(list.map((item) => ArticleItem.fromJson(item)).toList());
  }

}


class ArticleItem {
  bool top;
  String title;
  String link;
  String? author;
  String? shareUser;
  String? niceDate;
  int zan = 0;
  String? chapterName;
  String? superChapterName;
  int publishTime;

  ArticleItem({this.top = false,
    required this.title,
    required this.link,
    this.author,
    this.shareUser,
    this.niceDate,
    required this.zan,
    this.chapterName,
    this.superChapterName,
    required this.publishTime});

  factory ArticleItem.fromJson(dynamic item) {
    return ArticleItem(
      title: item['title'],
      link: item['link'],
      zan: item['zan'],
      publishTime: item['publishTime'],
      author: item['author'],
      shareUser: item['shareUser'],
      niceDate: item['niceDate'],
      chapterName: item['chapterName'],
      superChapterName: item['superChapterName'],
    );
  }


  set setTop(bool top) {
    this.top = top;
  }


}
