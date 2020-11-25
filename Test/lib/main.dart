/*
 * @Author: Cao Shixin
 * @Date: 2020-11-20 17:04:49
 * @LastEditors: Cao Shixin
 * @LastEditTime: 2020-11-25 10:14:03
 * @Description: 
 */
import 'package:Test/UIExample/dragable_widget.dart';
import 'package:flutter/material.dart';

import 'UIExample/tabbar_tabbarview.dart';

void main() {
  runApp(MyApp());
}

final Map<String, WidgetBuilder> _routes = {
  TabbarTabbarView.routeName: (_) => TabbarTabbarView(),
  DraggableWidget.routeName: (_) => DraggableWidget(),
};

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(primaryColor: Colors.blue),
      routes: _routes,
      home: Scaffold(
        appBar: AppBar(
          title: Text('Flutter Demo'),
        ),
        body: MyAppPage(),
      ),
    );
  }
}

class MyAppPage extends StatefulWidget {
  @override
  _MyAppPageState createState() => _MyAppPageState();
}

class _MyAppPageState extends State<MyAppPage> {
  List<CellModel> _demoTitleArr = [];

  @override
  void initState() {
    super.initState();
    _demoTitleArr = [
      CellModel(
          title: TabbarTabbarView.navTitle,
          routeName: TabbarTabbarView.routeName),
      CellModel(
          title: DraggableWidget.navTitle,
          routeName: DraggableWidget.routeName),
    ];
  }

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemBuilder: (context, index) {
        return GestureDetector(
          onTap: () {
            Navigator.of(context).pushNamed(_demoTitleArr[index].routeName);
          },
          child: ListTile(
            title: Center(
              child: Text(_demoTitleArr[index].title),
            ),
          ),
        );
      },
      itemCount: _demoTitleArr.length,
    );
  }
}

class CellModel {
  //显示标题
  String title;
  //路由地址名
  String routeName;

  CellModel({this.title, this.routeName});
}
