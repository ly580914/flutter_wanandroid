import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class SplashPage extends StatefulWidget {
  const SplashPage({Key? key}) : super(key: key);

  @override
  _SplashPageState createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> {
  var _curentTime = 6;
  late Timer _timer;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _timer = Timer.periodic(Duration(seconds: 1), (timer) {
      setState(() {
        _curentTime--;
        if (_curentTime < 0) {
          _onNextPage();
          _curentTime = 0;
        }
      });
    });
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    _timer.cancel();
  }
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Image.asset(
            'images/page_splash.jpeg',
            fit: BoxFit.cover,
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height,
          ),
          Positioned(
            child: InkWell(
              child: _skipButton(),
              onTap: () => _onNextPage()
            ),
            top: MediaQuery.of(context).padding.top + 20,
            right: 20, // 获取状态栏的高度+10
          )
        ],
      ),
    );
  }
  
  Widget _skipButton() {
    return Container(
      width: 60,
      height: 40,
      decoration: BoxDecoration(
        shape: BoxShape.rectangle,
        borderRadius: BorderRadius.circular(100.0),
        color: Colors.black.withOpacity(0.5), //透明度
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            '跳过',
            style: TextStyle(color: Colors.white, fontSize: 12),
          ),
          Text(
            '${_curentTime}s',
            style: TextStyle(color: Colors.white, fontSize: 12),
          ),
        ],
      ),
    );
  }

  void _onNextPage() {
    Navigator.of(context).popAndPushNamed('home');
  }
}
