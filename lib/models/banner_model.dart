class BannerList {
  final List<BannerItem> list;

  BannerList(this.list);

  factory BannerList.fromJson(List<dynamic> list) {
    return BannerList(
      list.map((item) => BannerItem.fromJson(item)).toList()
    );
  }
}


class BannerItem {
  final String desc;
  final int id;
  final String imagePath;
  final int isVisible;
  final int order;
  final String title;
  final int type;
  final String url;

  BannerItem({required this.desc,
    required this.id,
    required this.imagePath,
    required this.isVisible,
    required this.order,
    required this.title,
    required this.type,
    required this.url});

  factory BannerItem.fromJson(dynamic item) {
    return BannerItem(desc: item['desc'],
        id: item['id'],
        imagePath: item['imagePath'],
        isVisible: item['isVisible'],
        order: item['order'],
        title: item['title'],
        type: item['type'],
        url: item['url']);
  }
}
