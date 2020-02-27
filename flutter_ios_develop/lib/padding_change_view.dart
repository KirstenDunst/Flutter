/*
 * @Author       : Cao Shixin
 * @Date         : 2020-02-26 10:37:29
 * @LastEditors  : Cao Shixin
 * @LastEditTime : 2020-02-26 16:19:43
 * @Description  : 约束widget
 */
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class PaddingChange extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    /*MaterialApp,实际上是整个APP的入口，类似于搭积木时最底层的积木，其他界面都是从materialApp push过去的，
    materialApp可以理解为一个大的容器，任何一个界面pop都相当于一个压栈的过程，而push是一个出栈的过程，
    无论你怎么pop、push都应该在这个容器内，而当你在另外一个文件中返回了materialApp，相当于新建了一个容器，
    因此，你pop时，你无法从新的容器中pop到另一个容器中，上一个界面是不存在的，因此黑屏。
    */
    // return MaterialApp(
    //   title: 'Sample App',
    //   theme: ThemeData(
    //     primarySwatch: Colors.blue,
    //   ),
    //   home: SampleAppPage(),
    // );
    return SampleAppPage();
  }
}

class SampleAppPage extends StatefulWidget {
  SampleAppPage({Key key}) :super(key: key);
  @override
  _SampleAppPageState createState() => _SampleAppPageState();
}

class _SampleAppPageState extends State<SampleAppPage> {
  String textToShow = "I Like Flutter";
  int _pressedCount = 0;
  void _updateText() {
    setState(() {
      textToShow = "Flutter is Awesome!";
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Sample App"),
        actions: <Widget>[
          new IconButton(icon: new Icon(Icons.backspace), onPressed: () {
            Navigator.pop(context);
          }),
        ],
      ),
      body: Center(
        //1.显示的变化文案，形参读取，做到实时修改
        //Text(textToShow)
        //2.按钮添加布局约束padding
        child: CupertinoButton(
          child: Text('Hello,计数递加:' + _pressedCount.toString()), 
          onPressed: () {
            setState(() {
              _pressedCount += 1;
            });
          },
          padding: EdgeInsets.only(left:10.0, right: 10.0),
          )
      ),
      //添加动态修改文字显示的widget
      floatingActionButton: FloatingActionButton(
        onPressed: _updateText,
        tooltip: 'UpdateText',
        child: Icon(Icons.update),
      ),
    );
  }
}

