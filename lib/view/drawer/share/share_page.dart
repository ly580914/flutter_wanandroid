import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:wanandroid/config/colors.dart';
import 'package:wanandroid/data/repository.dart';
import 'package:wanandroid/toast.dart';
import 'package:wanandroid/utils/api_utils.dart';
import 'package:wanandroid/view/custom/custom_view.dart';
import 'package:wanandroid/view/drawer/share/share_notify.dart';
import 'package:wanandroid/view/event_bus.dart';

String _desc = """
1.只要是任何号文都可以分享哈，并不一定要是原创！投递的文章会进入广场的tab;
2.CSDN，掘金，简书等官方博客站点会直接通过，不需要审核；
3.其他个人站点会进入审核阶段，不要投递任何无效链接，测试的请尽快删除，否则可能会对你的账号产生一定影响；
4.目前处于测试阶段，如果你发现500等错误，可以向我提交日志，让我们一起使网站变得更好；
5.由于本站只有我一个人开发与维护，会尽力保证24小时内审核，当然有可能哪天太累，会延期，请保持佛系...
""";

class SharePage extends StatefulWidget {
  const SharePage({Key? key}) : super(key: key);

  @override
  _SharePageState createState() => _SharePageState();
}

class _SharePageState extends State<SharePage> {
  TextEditingController _titleController = TextEditingController();
  TextEditingController _linkController = TextEditingController();

  @override
  void dispose() {
    super.dispose();
    _titleController.dispose();
    _linkController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(
            '分享文章',
          ),
          actions: [
            TextButton(
              onPressed: _share,
              child: Text('分享', style: TextStyle(color: Colors.white)),
            )
          ],
        ),
        body: Container(
          margin: EdgeInsets.only(
            left: 16,
            right: 16,
            top: 16,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                '文章标题',
                style: TextStyle(fontSize: 15),
              ),
              SizedBox(
                height: 8,
              ),
              TextFormField(
                maxLines: 1,
                controller: _titleController,
                style: TextStyle(color: AppColors.active),
                decoration: InputDecoration(
                    isCollapsed: true,
                    enabledBorder: InputBorder.none,
                    focusedBorder: InputBorder.none,
                    hintText: '100字以类',
                    hintStyle: TextStyle(color: AppColors.unactive2)),
              ),
              SizedBox(
                height: 60,
              ),
              Text(
                '文章链接',
                style: TextStyle(fontSize: 15),
              ),
              SizedBox(
                height: 8,
              ),
              TextFormField(
                maxLines: 1,
                controller: _linkController,
                style: TextStyle(color: AppColors.active),
                decoration: InputDecoration(
                    isCollapsed: true,
                    enabledBorder: InputBorder.none,
                    focusedBorder: InputBorder.none,
                    hintText: '例如：https://www.wanandroid.com',
                    hintStyle: TextStyle(color: AppColors.unactive2)),
              ),
              Expanded(child: Container()),
              Text(
                _desc,
                style: TextStyle(
                    color: AppColors.unactive, fontSize: 13, height: 2),
              )
            ],
          ),
        ),
      resizeToAvoidBottomInset: false, // todo 重要！ 弹出键盘直接覆盖下面，不挤压界面
    );
  }

  void _share() {
    if (_titleController.text.isEmpty) {
      MyToast.show(context, '文章标题不能为空');
      return;
    }
    if (_linkController.text.isEmpty) {
      MyToast.show(context, '文章链接不能为空');
      return;
    }
    LoadingDialog.show(context, '请等待');
    Repository().shareArticle(_titleController.text, _linkController.text).then((value) {
      LoadingDialog.close(context);
      if (!ApiUtils.isSuccess(value)) {
        MyToast.show(context, '分享失败');
        return;
      }
      EventBusHolder.get.fire(ShareNotify());
      MyToast.show(context, '分享成功');
      Navigator.pop(context);
    });
  }
}
