/*
 * @Author: Cao Shixin
 * @Date: 2020-02-28 10:58:12
 * @LastEditors: Cao Shixin
 * @LastEditTime: 2020-02-28 11:37:00
 * @Description: UITableView 和 UICollectionView 相当于 Flutter 中的什么？
 */

/*
 * 在 iOS 中，你可能用 UITableView 或 UICollectionView 来展示一个列表。在 Flutter 中，你可以用 ListView 来达到相似的实现。
 * 在 iOS 中，你通过代理方法来确定行数，每一个 index path 的单元格，以及单元格的尺寸。
 * 由于 Flutter 中 widget 的不可变特性，你需要向 ListView 传递一个 widget 列表，Flutter 会确保滚动是快速且流畅的。
 */

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class TabColFlutter extends StatelessWidget {
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
  List widgets = [];

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(vsync: this);
    for (int i = 0; i < 100; i++) {
      widgets.add(getRow(i));
    }
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
        title: Text("列表")
      ),
      // body: ListView(children: widgets),
      //另外一个推荐的、高效的且有效的做法是，使用 ListView.Builder 来构建列表。这个方法在你想要构建动态列表，或是列表拥有大量数据时会非常好用。
      body: ListView.builder(
        itemCount: widgets.length,
        itemBuilder: (BuildContext context, int position) {
          return getRow(position);
        },
      ),
      /**
       * 与创建一个 “ListView” 不同，创建一个 ListView.builder 接受两个主要参数：列表的初始长度，和一个 ItemBuilder 方法。
       * ItemBuilder 方法和 cellForItemAt 代理方法非常类似，它接受一个位置，并且返回在这个位置上你希望渲染的 cell。
       * 最后，也是最重要的，注意 onTap() 函数里并没有重新创建一个 list，而是 .add 了一个 widget。
       */
    );
  }

  Widget getRow(int i) {
    return GestureDetector(
      child: Padding(
        padding: EdgeInsets.all(10.0),
        child: Text("Row $i"),
      ),
       //使用传递进来的 widget 的 touch handle：知道列表的哪个元素被点击了
      onTap: () {
        setState(() {
          // widgets = List.from(widgets); //使用 ListView.Builder 来构建列表则不需要创建
          widgets.add(getRow(widgets.length + 1));
          print('row $i');
        });
      },
    );
  }
  
}

