import 'dart:math';

import 'package:event_bus/event_bus.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:wanandroid/config/colors.dart';
import 'package:wanandroid/custom/custom.dart';
import 'package:wanandroid/toast.dart';
import 'package:wanandroid/utils/text_utils.dart';

/**
 * 笔记
 * 本页面只想做局部刷新，所以用了两个stf，一个stl，使用eventbus通知刷新
 */

List<String> _history = <String>[];
late EventBus eventBus;
var _hotSearch = <String>[
  '面试',
  'flutter',
  'jetpack compose',
  '动画',
  '自定义view',
  '性能优化 速度',
  'gradle',
  '代码混淆 安全',
  '逆向 加固'
];

class SearchPage extends StatefulWidget {
  const SearchPage({Key? key}) : super(key: key);

  @override
  _SearchPageState createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  TextEditingController _controller = TextEditingController();
  FocusNode _focusNode = FocusNode();
  late bool showClearInput;

  @override
  void initState() {
    showClearInput = false;
    eventBus = EventBus();
    if (_history.isEmpty) {
      SharedPreferences.getInstance().then((sp) {
        sp.getStringList('history')?.forEach((element) {
          _history.add(element);
        });
        eventBus.fire(HistoryChange());
      });
    }
    _controller.addListener(() {
      print("_controller.text.isEmpty = ${_controller.text.isEmpty}");
      print("showClearInput = ${showClearInput}");
      if (_controller.text.isEmpty && showClearInput) {
        setState(() {
          showClearInput = false;
        });
      } else if (!_controller.text.isEmpty && !showClearInput) {
        setState(() {
          showClearInput = true;
        });
      }
    });
  }

  @override
  void dispose() {
    super.dispose();
    _controller.dispose();
    _focusNode.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: _inputContainer(),
        actions: [
          IconButton(
              onPressed: () {
                if (_controller.value.text.isEmpty) {
                  MyToast.show(context, '请输入搜索内容');
                  return;
                }
                Navigator.pushNamed(context, 'search_detail',
                    arguments: _controller.value.text);
                _saveHistory(_controller.value.text);
                _focusNode.unfocus();
              },
              icon: Icon(Icons.arrow_forward_ios_rounded))
        ],
      ),
      body: _SearchBody(),
    );
  }

  Widget _inputContainer() {
    return Container(
        height: 30,
        decoration: BoxDecoration(
            color: AppColors.page, borderRadius: BorderRadius.circular(30)),
        child: Center(
            child: Row(
          children: [
            SizedBox(
              width: 6,
            ),
            Icon(Icons.search, color: Colors.black38),
            Expanded(
              child: TextFormField(
                controller: _controller,
                focusNode: _focusNode,
                decoration: InputDecoration(
                  hintText: "发现更多干货",
                  hintStyle: TextStyle(color: Colors.black38),
                  isCollapsed: true,
                  enabledBorder: InputBorder.none,
                  focusedBorder: InputBorder.none,
                  contentPadding: EdgeInsets.symmetric(horizontal: 10),
                ),
              ),
            ),
            Container(
                child: !showClearInput
                    ? null
                    : InkWell(
                        onTap: () {
                          print('clear');
                          _controller.clear();
                          setState(() {});
                        },
                        child: Container(
                          margin: EdgeInsets.only(right: 4),
                          height: 20,
                          width: 20,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(180.0),
                            color: Colors.grey,
                          ),
                          child: Icon(
                            Icons.close,
                            color: Colors.white,
                            size: 16,
                          ),
                        ),
                      )),
          ],
        )));
  }
}

class _SearchBody extends StatelessWidget {
  const _SearchBody({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '热门搜索',
            style: TextStyle(color: Colors.redAccent, fontSize: 14),
          ),
          SizedBox(
            height: 14,
          ),
          Wrap(
            spacing: 12,
            runSpacing: 12,
            children: _hotSearch
                .map((e) => InkWell(
                      onTap: () {
                        Navigator.pushNamed(context, 'search_detail',
                            arguments: e);
                        _saveHistory(e);
                      },
                      child: Container(
                        color: Colors.black12,
                        height: 30,
                        child: Center(
                          widthFactor: 1,
                          child: Padding(
                            padding: EdgeInsets.symmetric(horizontal: 8),
                            child: Text(
                              e,
                              style: TextStyle(
                                  color: Color.fromRGBO(
                                      Random().nextInt(200),
                                      Random().nextInt(200),
                                      Random().nextInt(200),
                                      1)),
                            ),
                          ),
                        ),
                      ),
                    ))
                .toList(),
          ),
          SizedBox(
            height: 30,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                '搜索历史',
                style: TextStyle(color: Colors.cyan, fontSize: 14),
              ),
              InkWell(
                onTap: () => _clearHistory(),
                child: Text(
                  '清空',
                  style: TextStyle(color: AppColors.unactive2, fontSize: 14),
                ),
              )
            ],
          ),
          SizedBox(height: 10),
          SearchHistoryPage(),
        ],
      ),
    );
  }

  void _clearHistory() {
    if (_history.isEmpty) {
      return;
    }
    _history.clear();
    _saveSp();
    eventBus.fire(HistoryChange());
  }
}

class SearchHistoryPage extends StatefulWidget {
  SearchHistoryPage({Key? key}) : super(key: key);

  @override
  _SearchHistoryPageState createState() => _SearchHistoryPageState();
}

class _SearchHistoryPageState extends State<SearchHistoryPage> {
  @override
  void initState() {
    super.initState();
    eventBus.on<HistoryChange>().listen((event) {
      setState(() {});
    });
  }

  @override
  void dispose() {
    super.dispose();
    eventBus.destroy();
  }

  @override
  Widget build(BuildContext context) {
    return _searchWidget();
  }

  Widget _searchWidget() {
    if (_history.length == 0) {
      return Center(
          child: Padding(
        padding: EdgeInsets.only(top: 100),
        child: Text(
          '快来搜点干货吧',
          style: TextStyle(color: AppColors.unactive2, fontSize: 15),
        ),
      ));
    }
    return Expanded(
        child: ScrollConfiguration(
            behavior: CusBehavior(),
            child: ListView.builder(
                itemCount: _history.length,
                itemBuilder: (BuildContext context, int index) {
                  return Container(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        InkWell(
                          onTap: () {
                            Navigator.pushNamed(context, 'search_detail',
                                arguments: _history[index]);
                            _saveHistory(_history[index]);
                          },
                          child: Text(
                            _history[index],
                            style: TextStyle(
                                color: AppColors.unactive, fontSize: 15),
                          ),
                        ),
                        IconButton(
                          onPressed: () => _removeHistory(_history[index]),
                          icon: Icon(
                            Icons.close,
                            color: AppColors.unactive,
                            size: 15,
                          ),
                        )
                      ],
                    ),
                  );
                })));
  }

  void _removeHistory(String text) {
    if (!_history.contains(text)) {
      return;
    }
    _history.remove(text);
    _saveSp();
    setState(() {});
  }
}

class HistoryChange {}

void _saveHistory(String text) {
  Future.delayed(Duration(seconds: 1), () {
    if (_history.contains(text)) {
      _history.remove(text);
    }
    _history.insert(0, text);
    eventBus.fire(HistoryChange());
    _saveSp();
  });
}

void _saveSp() {
  SharedPreferences.getInstance().then((sp) {
    sp.setStringList('history', _history);
  });
}
