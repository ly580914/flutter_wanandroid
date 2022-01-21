import 'package:event_bus/event_bus.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:wanandroid/account/account_info.dart';
import 'package:wanandroid/models/event_bus_model.dart';
import 'package:wanandroid/toast.dart';
import 'package:wanandroid/config/colors.dart';
import 'package:wanandroid/custom_route.dart';
import 'package:wanandroid/data/repository.dart';
import 'package:wanandroid/data/service.dart';
import 'package:wanandroid/models/login_model.dart';
import 'package:wanandroid/view/custom/custom_view.dart';

import '../../main.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  // late MyToast myToast;
  TextEditingController _controller_user = TextEditingController();
  TextEditingController _controller_pwd = TextEditingController();
  bool loginEnable = false;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    // myToast = MyToast(context);
  }

  @override
  void dispose() {
    super.dispose();
    _controller_user.dispose();
    _controller_pwd.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("登录"),
        ),
        body: Padding(
          padding: EdgeInsets.all(30),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                height: 20,
              ),
              Text(
                '用户登录',
                style: TextStyle(color: AppColors.active, fontSize: 16),
              ),
              Text(
                '请使用WanAndroid账号登录!',
                style: TextStyle(color: AppColors.unactive, fontSize: 14),
              ),
              SizedBox(
                height: 20,
              ),
              TextFormField(
                controller: _controller_user,
                style: TextStyle(),
                onChanged: _onInputChanged,
                cursorColor: AppColors.active,
                decoration: InputDecoration(
                    labelText: "用户名",
                    hintText: "请输入用户名",
                    labelStyle: TextStyle(color: AppColors.unactive),
                    floatingLabelStyle: TextStyle(color: AppColors.active),
                    hintStyle: TextStyle(color: AppColors.unactive2),
                    enabledBorder: UnderlineInputBorder(
                      borderSide: BorderSide(color: AppColors.unactive),
                    ),
                    focusedBorder: UnderlineInputBorder(
                      borderSide: BorderSide(color: AppColors.active),
                    ),
                    // isCollapsed:true,
                    contentPadding: EdgeInsets.only()),
              ),
              SizedBox(
                height: 20,
              ),
              TextFormField(
                controller: _controller_pwd,
                style: TextStyle(),
                onChanged: _onInputChanged,
                cursorColor: AppColors.active,
                obscureText:true,
                decoration: InputDecoration(
                  labelText: "密码",
                  hintText: "请输入密码",
                  labelStyle: TextStyle(color: AppColors.unactive),
                  floatingLabelStyle: TextStyle(color: AppColors.active),
                  hintStyle: TextStyle(color: AppColors.unactive2),
                  // isCollapsed:true,
                  enabledBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: AppColors.unactive),
                  ),
                  focusedBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: AppColors.active),
                  ),
                  contentPadding: EdgeInsets.only(),
                  // isCollapsed:true,
                ),
              ),
              SizedBox(
                height: 50,
              ),
              ElevatedButton(
                onPressed: loginEnable ? _onConfirm : null,
                child: Container(
                  width: double.infinity,
                  height: 50,
                  child: Center(
                    child: Text(
                      '登录',
                      style: TextStyle(fontSize: 16),
                    ),
                  ),
                ),
              ),
              SizedBox(
                height: 20,
              ),
              Container(
                width: double.infinity,
                child: Align(
                  alignment: Alignment.centerRight,
                  child: InkWell(
                    onTap: () {
                      Navigator.of(globalKey.currentContext as BuildContext)
                          .pushNamed('register');
                    },
                    child: Text(
                      '没有账号？去注册',
                      style: TextStyle(color: AppColors.unactive, fontSize: 16),
                    ),
                  ),
                ),
              )
            ],
          ),
        ));
  }

  void _onInputChanged(String value) {
    if (!_controller_user.value.text.isEmpty &&
        _controller_pwd.value.text.length > 5 &&
        !loginEnable) {
      setState(() {
        loginEnable = true;
      });
    } else if (_controller_user.value.text.isEmpty ||
        _controller_pwd.value.text.length <= 5 && loginEnable) {
      setState(() {
        loginEnable = false;
      });
    }
  }

  void _onConfirm() {
    LoadingDialog.show(context, '正在登录');
    Repository()
        .login(_controller_user.value.text, _controller_pwd.value.text)
        .then((value) {
          LoadingDialog.close(context);
      // print("""errorCode = ${value.data['errorCode']}
      //      data = ${value.data['data']}""");
      if (value.data['errorCode'] != 0) {
        MyToast.show(context, "${value.data['errorMsg']}");  //toast();
        return;
      }
      // toast();
      MyToast.show(context, "登录成功");
      AccountData accountData = AccountData.fromJson(value.data['data']);
      print('username = ${accountData.username}');
      accountData.password = _controller_pwd.value.text;
      Account.login(accountData);
      Navigator.of(globalKey.currentContext as BuildContext).pushNamedAndRemoveUntil('home', (route) => false);


    });
  }
}
