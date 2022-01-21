import 'package:event_bus/event_bus.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:wanandroid/models/event_bus_model.dart';
import 'package:wanandroid/models/login_model.dart';
import 'package:wanandroid/view/event_bus.dart';

class Account {
  static Account? _instance;
  String _username;
  String _password;
  String? _icon;
  int? _coinCount;
  int? _level;
  String? _rank;
  List<dynamic>? collectIds;

  static void init() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    String? username = prefs.getString('username');
    String? password = prefs.getString('password');
    String? icon = prefs.getString('icon');
    int? coinCount = prefs.getInt('coinCount');
    int? level = prefs.getInt('level');
    String? rank = prefs.getString('rank');
    List<int>? collectIds =
        prefs.getStringList('collectIds')?.map((e) => int.parse(e)).toList();
    if (username is String && password is String) {
      _instance = Account._internal(
          username: username,
          password: password,
          icon: icon,
          coinCount: coinCount,
          level: level,
          rank: rank,
          collectIds: collectIds);
      EventBusHolder.get.fire(LoginState(true));
      print('账号已登录');
    } else {
      print('账号未登录');
    }
  }

  static void login(AccountData accountData) {
    _instance = Account._internal(
      username: accountData.username,
      password: accountData.password,
      icon: accountData.icon,
      coinCount: accountData.coinCount,
      collectIds: accountData.collectIds,
    );
    SharedPreferences.getInstance().then((sp) {
      sp.setString('username', accountData.username);
      sp.setString('password', accountData.password);
      sp.setString('icon', accountData.icon);
      sp.setInt('coinCount', accountData.coinCount);
      sp.setStringList(
          'collectIds', accountData.collectIds.map((e) => '$e').toList());
    });
   EventBusHolder.get.fire(LoginState(true));
  }

  static void logout() {
    SharedPreferences.getInstance().then((sp) {
      sp.remove('username');
      sp.remove('password');
      sp.remove('icon');
      sp.remove('level');
      sp.remove('rank');
      sp.remove('collectIds');
    });
    _instance = null;
    EventBusHolder.get.fire(LoginState(false));
  }

  Account._internal(
      {required username,
      required password,
      icon,
      coinCount,
      level,
      rank,
      this.collectIds})
      : _username = username,
        _password = password,
        _icon = icon,
        _coinCount = coinCount,
        _level = level,
        _rank = rank;

  static get get => _instance;

  get username => _username;

  get password => _password;

  get icon => _icon;

  get coinCount => _coinCount;

  get level => _level;

  get rank => _rank;

  set setLevel(int? level) {
    this._level = level;
    if (level != null) {
      SharedPreferences.getInstance().then((sp) {
        sp.setInt('level', level);
      });
    }
  }

  set setRank(String? rank) {
    this._rank = rank;
    if (rank != null) {
      SharedPreferences.getInstance().then((sp) {
        sp.setString('rank', rank);
      });
    }
  }

  void addCollect(int id) {
    collectIds?.add(id);
    SharedPreferences.getInstance().then((sp) {
      List<String>? list = collectIds?.map((e) => '$e').toList();
      if (list != null) {
        sp.setStringList('collectIds', list);
      }
    });
    EventBusHolder.get.fire(LoginState(true));
  }

  void unCollect(int id) {
    collectIds?.remove(id);
    SharedPreferences.getInstance().then((sp) {
      List<String>? list = collectIds?.map((e) => '$e').toList();
      if (list != null) {
        sp.setStringList('collectIds', list);
      }
    });
    EventBusHolder.get.fire(LoginState(true));
  }

  bool isCollect(int id) {
    if (collectIds == null) {
      return false;
    }
    return collectIds!.contains(id);
  }
}
