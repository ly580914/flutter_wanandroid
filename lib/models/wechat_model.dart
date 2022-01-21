class WxArticleTabList {
  final List<WxArticleTabItem> list;

  WxArticleTabList(this.list);

  factory WxArticleTabList.fromJson(List<dynamic> list) {
    return WxArticleTabList(
        list.map((item) => WxArticleTabItem.fromJson(item)).toList());
  }
}

class WxArticleTabItem {
  final int id;
  final String name;

  WxArticleTabItem({required this.id, required this.name});

  factory WxArticleTabItem.fromJson(dynamic item) {
    return WxArticleTabItem(id: item['id'], name: item['name']);
  }
}
