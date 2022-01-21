class IntegralList {
  List<IntegralItem> list;
  IntegralList(this.list);

  factory IntegralList.fromJson(List<dynamic> list) {
    return IntegralList(list.map((e) => IntegralItem.fromJson(e)).toList());
  }
}

class IntegralItem {
  String reason;
  String desc;
  int coinCount;

  IntegralItem(
      {required this.reason, required this.desc, required this.coinCount});

  factory IntegralItem.fromJson(dynamic item) {
    return IntegralItem(
      reason: item['reason'],
      desc: item['desc'],
      coinCount: item['coinCount'],
    );
  }
}
