import 'package:flutter/material.dart';

import 'name_route.dart';

void main() => runApp(NameRoute());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: "路由管理",
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(title:"路由管理"),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}): super(key: key);
  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State <MyHomePage> {
  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Text("主页面"),
        FlatButton(
          onPressed: (){
            Navigator.push(context, 
              MaterialPageRoute(builder: (context) {
                return NewRoute();
              })
            );
          }, 
          child: Text("open new route"),
          textColor: Colors.blue,
        ),
      ],
    );
  }
}

/* 介绍一下MaterialPageRoute 构造函数的各个参数的意义：
 * builder: 是一个WidgetBuilder类型的回调函数，它的作用是构建路由页面的具体内容，返回值是一个widget。我们通常要实现此回调，返回新路由的实例。
 * settings: 包含路由的配置信息，如路由名称、是否初始路由（首页）。
 * maintainState: 默认情况下，当入栈一个新路由时，原来的路由仍然会被保存在内存中，如果想在路由没用的时候释放其所占用的所有资源，可以设置maintainState为false。
 * fullscreenDialog: 表示新的路由页面是否是一个全屏的模态对话框，在iOS中，如果fullscreenDialog为true，新页面将会从屏幕底部滑入（而不是水平方向）。
 */

/*
 * Future push(BuildContext context, Route route)
将给定的路由入栈（即打开新的页面），返回值是一个Future对象，用以接收新路由出栈（即关闭）时的返回数据。


bool pop(BuildContext context, [ result ])
将栈顶路由出栈，result为页面关闭时返回给上一个页面的数据。
Navigator 还有很多其它方法，如Navigator.replace、Navigator.popUntil等，



//等待返回结果事例：
          var result = await Navigator.push(
            context,
            MaterialPageRoute(
 */



class NewRoute extends StatelessWidget {
@override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("New route"),
      ),
      body: Center(
        child: Text("This is new route"),
      ),
    );
  }
  
}