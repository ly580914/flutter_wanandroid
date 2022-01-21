class SystemList {
  final List<SystemItem> list;
  SystemList(this.list);
  factory SystemList.fromJson(List<dynamic> list) {
    return SystemList(list.map((e) => SystemItem.fromJson(e)).toList());
  }
}

class SystemItem {
  final List<dynamic> children;
  final int courseId;
  final int id;
  final String name;
  final int order;
  final int parentChapterId;
  final bool userControlSetTop;
  final int visible;

  SystemItem({required this.children,
    required this.courseId,
    required this.id,
    required this.name,
    required this.order,
    required this.parentChapterId,
    required this.userControlSetTop,
    required this.visible});

  factory SystemItem.fromJson(dynamic item) {
    return SystemItem(
      children: item['children'],
      id: item['id'],
      name: item['name'],
      order: item['order'],
      parentChapterId: item['parentChapterId'],
      userControlSetTop: item['userControlSetTop'],
      visible: item['visible'],
      courseId: item['courseId'],
    );
  }
}
