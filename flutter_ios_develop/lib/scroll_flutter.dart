/*
 * @Author: Cao Shixin
 * @Date: 2020-02-28 11:38:07
 * @LastEditors: Cao Shixin
 * @LastEditTime: 2020-02-28 13:36:47
 * @Description: ScrollView 相当于 Flutter 里的什么
 */

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

/*
 * 在 iOS 中，你给 view 包裹上 ScrollView 来允许用户在需要时滚动你的内容。
 * 在 Flutter 中，最简单的方法是使用 ListView widget。它表现得既和 iOS 中的 ScrollView 一致，也能和 TableView 一致，
 * 因为你可以给它的 widget 做垂直排布：
 */

class ScrollWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SampleApp();
  }
}

class SampleApp extends StatefulWidget {
  @override
  _SampleAppState createState() => _SampleAppState();
}

class _SampleAppState extends State<SampleApp>
    with SingleTickerProviderStateMixin {
  AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(vsync: this);
  }

  @override
  void dispose() {
    super.dispose();
    _controller.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("ScrollView 相当于 Flutter 里的什么")
      ),
      body: ListView(
        children: <Widget>[
          Text('Row One'),
          Text('Row Two'),
          Text('Row Three'),
          Text('Row Four'),
        ],
      )
    );
  }
}

