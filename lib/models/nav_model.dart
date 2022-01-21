import 'dart:math';
import 'dart:ui';

import 'package:flutter/material.dart';

class NavList {
  final List<NavItem> list;

  NavList(this.list);

  factory NavList.fromJson(List<dynamic> list) {
    return NavList(list.map((e) => NavItem.fromJson(e)).toList());
  }
}

class NavItem {
  final List<Article> articles;
  final int cid;
  final String name;

  NavItem({required this.articles, required this.cid, required this.name});

  factory NavItem.fromJson(dynamic item) {
    return NavItem(
        cid: item['cid'],
        name: item['name'],
        articles: (item['articles'] as List)
            .map((e) => Article.fromJson(e))
            .toList());
  }
}

class Article {
  final String title;
  final String link;
  final Color color;

  Article({required this.title, required this.link})
      : color = Color.fromRGBO(Random().nextInt(200), Random().nextInt(200),
            Random().nextInt(200), 1);

  factory Article.fromJson(dynamic item) {
    return Article(title: item['title'], link: item['link']);
  }
}
