/*
 * @Author: Cao Shixin
 * @Date: 2020-11-23 17:25:07
 * @LastEditors: Cao Shixin
 * @LastEditTime: 2020-11-25 10:08:46
 * @Description: tabbar和tabbarview的组合使用
 */

import 'package:flutter/material.dart';

class TabbarTabbarView extends StatefulWidget {
  static const routeName = 'tabbar_tabbarview';
  static const navTitle = 'Tabbar和TabbarView';
  @override
  _TabbarTabbarViewState createState() => _TabbarTabbarViewState();
}

class _TabbarTabbarViewState extends State<TabbarTabbarView>
    with TickerProviderStateMixin {
  TabController _tabController; //需要定义一个Controller
  Map<String, List<String>> tabs;

  @override
  void initState() {
    super.initState();
    tabs = <String, List<String>>{};
    for (var i = 0; i < 10; i++) {
      tabs['$i'] = [
        "新闻$i",
        "历史$i",
        "图片$i",
        "新闻$i",
        "历史$i",
        "图片$i",
        "新闻$i",
        "历史$i",
        "图片$i",
        "新闻$i",
        "历史$i",
        "图片$i",
        "新闻$i",
        "历史$i",
        "图片$i",
        "新闻$i",
        "历史$i",
        "图片$i",
      ];
    }
    // 创建Controller
    _tabController = TabController(length: tabs.length, vsync: this);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(TabbarTabbarView.navTitle),
        bottom: TabBar(
          //生成Tab菜单
          isScrollable: true,
          controller: _tabController,
          tabs: tabs.keys.map((f) {
            return Container(
              alignment: Alignment.center,
              width: 80,
              child: Text(
                f,
                style: TextStyle(color: Colors.black, fontSize: 22),
              ),
            );
          }).toList(),
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: tabs.values.map((e) {
          //创建3个Tab页
          return MyHomePageCell(e);
        }).toList(),
      ),
    );
  }
}

class MyHomePageCell extends StatefulWidget {
  final List<String> tempArr;
  MyHomePageCell(this.tempArr);
  @override
  _MyHomePageCellState createState() => _MyHomePageCellState();
}

class _MyHomePageCellState extends State<MyHomePageCell>
    with AutomaticKeepAliveClientMixin, SingleTickerProviderStateMixin {
  TabController _tabController; //需要定义一个Controller

  @override
  void initState() {
    super.initState();
    // 创建Controller
    _tabController = TabController(length: widget.tempArr.length, vsync: this);
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Column(children: [
      Container(
        height: 80,
        child: TabBar(
          //生成Tab菜单
          isScrollable: true,
          controller: _tabController,
          tabs: widget.tempArr.map((f) {
            return Container(
              alignment: Alignment.center,
              width: 80,
              child: Text(
                f,
                style: TextStyle(color: Colors.black, fontSize: 22),
              ),
            );
          }).toList(),
        ),
      ),
      Expanded(
        child: TabBarView(
          controller: _tabController,
          children: widget.tempArr.map((e) {
            //创建3个Tab页
            return SingleChildScrollView(
              child: Container(
                height: 1000,
                alignment: Alignment.center,
                child: Text(e, textScaleFactor: 3),
              ),
            );
          }).toList(),
        ),
      ),
    ]);
  }

  @override
  bool get wantKeepAlive => true;
}
