/*
 * @Author: Cao Shixin
 * @Date: 2020-07-08 19:35:43
 * @LastEditors: Cao Shixin
 * @LastEditTime: 2020-09-19 16:16:23
 * @Description: 
 * @Email: cao_shixin@yahoo.com
 * @Company: BrainCo
 */
import 'package:flutter/material.dart';

import 'dragable_widget.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: '拖拽组件',
      theme: ThemeData(primarySwatch: Colors.blue),
      home: MyAppPage(),
      routes: routes,
    );
  }

  final Map<String, WidgetBuilder> routes = {
    DraggableWidget.routeName: (_) => DraggablePage(),
  };
}

class MyAppPage extends StatefulWidget {
  MyAppPage({Key key}) : super(key: key);

  @override
  _MyAppPageState createState() => _MyAppPageState();
}

class _MyAppPageState extends State<MyAppPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: SafeArea(
        child: Column(
          children: [
            Container(
              width: 100,
              height: 50,
              alignment: Alignment.center,
              decoration:
                  BoxDecoration(borderRadius: BorderRadius.circular(25)),
              child: RaisedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => DraggableWidget()),
                  );
                },
                color: Colors.red,
                child: Center(
                  child: Text('拖拽组件'),
                ),
              ),
            ),
            Container()
          ],
        ),
      ),
    );
  }
}
