class LoginData {
  final int errorCode;
  final String? errorMsg;
  final AccountData? data;

  LoginData({required this.errorCode, this.errorMsg, this.data});

  factory LoginData.fromJson(dynamic item) {
    return LoginData(
        errorCode: item['errorCode'],
        errorMsg: item['errorMsg'],
        data: item['data'] == null ? null : AccountData.fromJson(item['data']));
  }
}

class AccountData {
  final bool admin;
  final List<dynamic>? chapterTops;
  final int coinCount;
  final List<dynamic> collectIds;
  final dynamic? email;
  final dynamic? icon;
  final int id;
  final String nickName;
  late final String password;
  final dynamic? token;
  final int type;
  final String username;

  AccountData(
      {required this.admin,
      this.chapterTops,
      required this.coinCount,
      required this.collectIds,
      this.email,
      this.icon,
      required this.id,
      required this.nickName,
      // this.password,
      this.token,
      required this.type,
      required this.username});

  factory AccountData.fromJson(dynamic item) {
    return AccountData(
        admin: item['admin'],
        coinCount: item['coinCount'],
        id: item['id'],
        nickName: item['nickname'],
        type: item['type'],
        username: item['username'],
        chapterTops: item['chapterTops'],
        collectIds: item['collectIds'],
        email: item['email'],
        icon: item['icon'],
        // password: item['password'],
        token: item['token']);
  }

// admin: false,
// chapterTops: [],
// coinCount: 10,
// collectIds: [],
// email: ,
// icon: ,
// id: 122657,
// nickname: lytest1,
// password: ,
// publicName: lytest1,
// token: ,
// type: 0,
// username: lytest1
}
