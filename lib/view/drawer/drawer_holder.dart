import 'dart:async';

import 'package:flutter/material.dart';
import 'package:wanandroid/account/account_info.dart';
import 'package:wanandroid/config/colors.dart';
import 'package:wanandroid/data/repository.dart';
import 'package:wanandroid/main.dart';
import 'package:wanandroid/models/event_bus_model.dart';
import 'package:wanandroid/toast.dart';
import 'package:wanandroid/view/custom/custom_view.dart';
import 'package:wanandroid/view/event_bus.dart';

class MyDrawer extends StatefulWidget {
  const MyDrawer({Key? key}) : super(key: key);

  @override
  _MyDrawerState createState() => _MyDrawerState();
}

class _MyDrawerState extends State<MyDrawer> {
  late StreamSubscription event;

  bool isLogin = false;

  @override
  void initState() {
    super.initState();
    print('initState');
    event = EventBusHolder.get.on<LoginState>().listen((event) {
      print("EventBus on ${event.isLogin}");
      setState(() {});
    });
  }

  @override
  void dispose() {
    super.dispose();
    event.cancel();
  }

  @override
  Widget build(BuildContext context) {
    return Drawer(
        child: Flex(
      direction: Axis.vertical,
      children: [
        Expanded(
          child: Container(
            color: AppColors.primary,
            child: Stack(
              children: [
                Container(
                  width: double.infinity,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        margin: EdgeInsets.only(top: 40),
                        child: Icon(
                          Icons.account_circle,
                          color: Colors.white,
                          size: 90,
                        ),
                      ),
                      Container(
                          margin: EdgeInsets.only(top: 4),
                          child: Account.get != null
                              ? Text(
                                  Account.get.username,
                                  style: TextStyle(
                                      color: Colors.white, fontSize: 16),
                                )
                              : InkWell(
                                  child: Text(
                                    '去登录',
                                    style: TextStyle(
                                        color: Colors.white, fontSize: 16),
                                  ),
                                  onTap: () {
                                    Navigator.of(globalKey.currentContext
                                            as BuildContext)
                                        .pushNamed('login');
                                  },
                                )),
                      Container(
                        margin: EdgeInsets.only(top: 4),
                        child: Text(
                          _getRankLevel(),
                          style: TextStyle(color: Colors.white, fontSize: 12),
                        ),
                      ),
                    ],
                  ),
                ),
                Positioned(
                  right: 10,
                  top: 20,
                  child: IconButton(
                    color: Colors.white,
                    onPressed: () {},
                    icon: Icon(Icons.sort),
                  ),
                ),
              ],
            ),
          ),
          flex: 2,
        ),
        Expanded(
          child: Container(
            child: Column(
              children: _settingItems(),
            ),
          ),
          flex: 5,
        )
      ],
    ));
  }

  List<Widget> _settingItems() {
    List<Widget> list = <Widget>[];
    list.add(
      SizedBox(
        height: 20,
      ),
    );
    list.add(
      _settingItem("jifen", "我的积分", () {
       if (Account.get == null) {
         Navigator.pushNamed(context, 'login');
         return;
       }
       print('into integral');
       Navigator.pushNamed(context, 'integral');
      }),
    );
    list.add(
      _settingItem("shoucang", "我的收藏", () {
        if (Account.get == null) {
          Navigator.pushNamed(context, 'login');
          return;
        }
        Navigator.pushNamed(context, 'collect_list');
      }),
    );
    list.add(
      _settingItem("share", "我的分享", () {
        if (Account.get == null) {
          Navigator.pushNamed(context, 'login');
          return;
        }
        Navigator.pushNamed(context, 'share_list');
      }),
    );
    list.add(
      _settingItem("todo", "TODO", () {
        if (Account.get == null) {
          Navigator.pushNamed(context, 'login');
        }
      }),
    );
    list.add(
      _settingItem("night", "夜间模式", () {
        if (Account.get == null) {
          Navigator.pushNamed(context, 'login');
        }
      }),
    );
    list.add(
      _settingItem("setting", "系统设置", () {
        if (Account.get == null) {
          Navigator.pushNamed(context, 'login');
        }
      }),
    );
    if (Account.get != null) {
      list.add(
        _settingItem("logout", "退出登录", _logout),
      );
    }
    return list;
  }

  Widget _settingItem(String iconName, String title, VoidCallback callback) {
    List<Widget> children = <Widget>[];
    children.add(
      SizedBox(
        width: 20,
        height: 40,
      ),
    );
    children.add(
      Image.asset(
        'images/icons/icon_${iconName}.png',
        width: 16,
        height: 16,
      ),
    );
    children.add(
      SizedBox(
        width: 30,
      ),
    );
    children.add(Text(title));
    if ('jifen' == iconName && Account.get != null) {
      children.add(Expanded(
          child: Align(
        alignment: Alignment.centerRight,
        child: Padding(
          padding: EdgeInsets.only(right: 20),
          child: Text('${Account.get.coinCount}'),
        ),
      )));
    }
    return InkWell(
      child: Row(
        children: children,
      ),
      onTap: callback,
    );
  }

  void _logout() {
    showDialog(
        context: context,
        barrierDismissible: false, // 点击空白不关闭
        builder: (context) {
          return AlertDialog(
            content: Text('确认退出登录？'),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop(false);
                },
                child: Text("取消", style: TextStyle(color: AppColors.blue)),
                style: ButtonStyle(
                  overlayColor:
                  MaterialStateProperty.all(Colors.transparent), // 去掉点击效果
                ),
              ),
              TextButton(
                onPressed: () {
                  Navigator.pop(context, true);
                  LoadingDialog.show(context, '正在退出');
                },
                child: Text("确定", style: TextStyle(color: AppColors.blue)),
                style: ButtonStyle(
                  overlayColor:
                      MaterialStateProperty.all(Colors.transparent), // 去掉点击效果
                ),
              ),
            ],
          );
        }).then((value) {
      if (value) {
        Repository().logout().then((value) {
          if (true) {
            LoadingDialog.close(context);
            MyToast.show(context, '已退出登录');
            Account.logout();
            setState(() {});
          }
        });
      }
    });
  }

  String _getRankLevel() {
    if (Account.get != null) {
      if (Account.get.level != null) {
        return '等级：${Account.get.level}   排名：${Account.get.rank}';
      } else {
        Repository().integral().then((value) {
          if (value.data['errorCode'] == 0 && Account.get != null) {
            Account.get.setLevel = value.data['data']['level'];
            Account.get.setRank = value.data['data']['rank'];
            setState(() {

            });
          }
        });
      }
    }
    return '等级：-   排名：-';
  }

}

class DrawerHolder {
  static MyDrawer _drawer = MyDrawer();

  static get drawer => _drawer;
}
