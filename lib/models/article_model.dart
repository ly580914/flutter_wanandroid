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
  int id;
  String? envelopePic;
  String? desc;
  int? originId;

  ArticleItem(
      {this.top = false,
      required this.title,
      required this.link,
      this.author,
      this.shareUser,
      this.niceDate,
      required this.zan,
      this.chapterName,
      this.superChapterName,
      required this.publishTime,
      required this.id,
      this.envelopePic,
      this.desc,
      this.originId});

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
      id: item['id'],
      envelopePic: item['envelopePic'],
      desc: item['desc'],
      originId: item['originId']
    );
  }

  set setTop(bool top) {
    this.top = top;
  }
}
