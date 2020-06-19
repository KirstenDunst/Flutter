/*
 * @Author: Cao Shixin
 * @Date: 2020-06-19 17:47:15
 * @LastEditors: Cao Shixin
 * @LastEditTime: 2020-06-19 18:33:39
 * @Description: 
 * @Email: cao_shixin@yahoo.com
 * @Company: BrainCo
 */

import 'package:flutter/material.dart';
import 'package:scaffold/draw.dart';
import 'package:scaffold/tab_one.dart';
import 'package:scaffold/tab_three.dart';
import 'package:scaffold/tab_two.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(primaryColor: Colors.blue),
      title: 'Material App',
      home: ScaffoldRoute(),
    );
  }
}

class ScaffoldRoute extends StatefulWidget {
  @override
  _ScaffoldRouteState createState() => _ScaffoldRouteState();
}

class _ScaffoldRouteState extends State<ScaffoldRoute> {
  int _selectedIndex = 0;
  List<Widget> _tabs = [];

  @override
  void initState() {
    _tabs = [TabOne(),TabTwo(),TabThree()];
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        //导航栏
        title: Text("App Name"),
        actions: <Widget>[
          //导航栏右侧菜单
          IconButton(icon: Icon(Icons.share), onPressed: () {}),
        ],
      ),
      drawer: new MyDrawer(), //抽屉
      bottomNavigationBar: BottomNavigationBar(
        // 底部导航
        items: <BottomNavigationBarItem>[
          BottomNavigationBarItem(icon: Icon(Icons.home), title: Text('Home')),
          BottomNavigationBarItem(
              icon: Icon(Icons.business), title: Text('Business')),
          BottomNavigationBarItem(
              icon: Icon(Icons.school), title: Text('School')),
        ],
        currentIndex: _selectedIndex,
        fixedColor: Colors.blue,
        onTap: _onItemTapped,
      ),
      floatingActionButton: FloatingActionButton(
          //悬浮按钮
          child: Icon(Icons.add),
          onPressed: _onAdd),
      body: _tabs[_selectedIndex],
    );
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  void _onAdd() {}
}
