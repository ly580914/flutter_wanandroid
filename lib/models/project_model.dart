class ProjectTabList {
  final List<ProjectTabItem> list;

  ProjectTabList(this.list);
  
  factory ProjectTabList.fromJson(List<dynamic> list) {
    return ProjectTabList(list.map((e) => ProjectTabItem.fromJson(e)).toList());
  }
}


class ProjectTabItem {
  final int id;
  final String name;

  ProjectTabItem({required this.id, required this.name});

  factory ProjectTabItem.fromJson(dynamic item) {
    return ProjectTabItem(id: item['id'], name: item['name']);
  }
  
}