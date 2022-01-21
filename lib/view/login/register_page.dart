import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:wanandroid/account/account_info.dart';
import 'package:wanandroid/config/colors.dart';
import 'package:wanandroid/data/repository.dart';
import 'package:wanandroid/models/login_model.dart';
import 'package:wanandroid/view/custom/custom_view.dart';

import '../../main.dart';
import '../../toast.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({Key? key}) : super(key: key);

  @override
  _RegisterPageState createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  TextEditingController _controller_user = TextEditingController();
  TextEditingController _controller_pwd = TextEditingController();
  TextEditingController _controller_repwd = TextEditingController();
  bool loginEnable = false;

  @override
  void dispose() {
    super.dispose();
    _controller_user.dispose();
    _controller_pwd.dispose();
    _controller_repwd.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("注册"),
        ),
        body: SingleChildScrollView(
            child: Padding(
          padding: EdgeInsets.all(30),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                height: 20,
              ),
              Text(
                '注册用户',
                style: TextStyle(color: AppColors.active, fontSize: 16),
              ),
              Text(
                '用户注册号才可以登录!',
                style: TextStyle(color: AppColors.unactive, fontSize: 14),
              ),
              SizedBox(
                height: 20,
              ),
              TextFormField(
                controller: _controller_user,
                style: TextStyle(),
                cursorColor: AppColors.active,
                onChanged: _onInputChanged,
                decoration: InputDecoration(
                  labelText: "用户名",
                  hintText: "请输入用户名",
                  labelStyle: TextStyle(color: AppColors.unactive),
                  floatingLabelStyle: TextStyle(color: AppColors.active),
                  hintStyle: TextStyle(color: AppColors.unactive2),
                  // isCollapsed:true,
                  contentPadding: EdgeInsets.only(),
                  enabledBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: AppColors.unactive),
                  ),
                  focusedBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: AppColors.active),
                  ),
                ),
              ),
              SizedBox(
                height: 20,
              ),
              TextFormField(
                controller: _controller_pwd,
                style: TextStyle(),
                cursorColor: AppColors.active,
                onChanged: _onInputChanged,
                obscureText:true,
                decoration: InputDecoration(
                  labelText: "密码",
                  hintText: "密码至少6位",
                  labelStyle: TextStyle(color: AppColors.unactive),
                  floatingLabelStyle: TextStyle(color: AppColors.active),
                  hintStyle: TextStyle(color: AppColors.unactive2),
                  // isCollapsed:true,
                  contentPadding: EdgeInsets.only(),
                  enabledBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: AppColors.unactive),
                  ),
                  focusedBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: AppColors.active),
                  ),
                  // isCollapsed:true,
                ),
              ),
              SizedBox(
                height: 20,
              ),
              TextFormField(
                controller: _controller_repwd,
                style: TextStyle(),
                cursorColor: AppColors.active,
                onChanged: _onInputChanged,
                obscureText:true,
                decoration: InputDecoration(
                  labelText: "确认密码",
                  hintText: "请再输入一次密码",
                  labelStyle: TextStyle(color: AppColors.unactive),
                  floatingLabelStyle: TextStyle(color: AppColors.active),
                  hintStyle: TextStyle(color: AppColors.unactive2),
                  // isCollapsed:true,
                  contentPadding: EdgeInsets.only(),
                  enabledBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: AppColors.unactive),
                  ),
                  focusedBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: AppColors.active),
                  ),
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
                      '注册',
                      style: TextStyle(fontSize: 16),
                    ),
                  ),
                ),
              ),
              SizedBox(
                height: 20,
              ),
            ],
          ),
        )));
  }

  void _onInputChanged(String value) {
    if (!_controller_user.value.text.isEmpty &&
        _controller_pwd.value.text.length > 5 &&
        _controller_repwd.value.text.length > 5 &&
        !loginEnable) {
      setState(() {
        loginEnable = true;
      });
    } else if (_controller_user.value.text.isEmpty ||
        _controller_pwd.value.text.length <= 5 ||
        _controller_repwd.value.text.length <= 5 && loginEnable) {
      setState(() {
        loginEnable = false;
      });
    }
  }

  void _onConfirm() {
    LoadingDialog.show(context, '正在注册');
    Repository()
        .register(_controller_user.value.text, _controller_pwd.value.text,
            _controller_repwd.value.text)
        .then((value) {
      LoadingDialog.close(context);
      if (value.data['errorCode'] != 0) {
        MyToast.show(context, "${value.data['errorMsg']}"); //toast();
        return;
      }
      MyToast.show(context, "注册成功");
      AccountData accountData = AccountData.fromJson(value.data['data']);
      accountData.password = _controller_pwd.value.text;
      Account.login(accountData);
      // print('data = ${value.data}');
      Navigator.of(globalKey.currentContext as BuildContext)
          .pushNamedAndRemoveUntil('home', (route) => false);
    });
  }
}
