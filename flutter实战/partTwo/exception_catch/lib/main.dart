import 'dart:async';

import 'package:flutter/material.dart';

void collectLog(String line){
    //收集日志
    print('收集错误日志：$line');
}
void reportErrorAndLog(FlutterErrorDetails details){
    //上报错误和日志逻辑
    print('上报错误和日志逻辑:$details');
}

FlutterErrorDetails makeDetails(Object obj, StackTrace stack){
    // 构建错误信息
  print('构建错误信息：$obj,$stack');
}

void main() {
  FlutterError.onError = (FlutterErrorDetails details) {
    reportErrorAndLog(details);
  };
  runZoned(
    () => runApp(MyApp()),
    zoneSpecification: ZoneSpecification(
      print: (Zone self, ZoneDelegate parent, Zone zone, String line) {
        collectLog(line); // 收集日志
      },
    ),
    onError: (Object obj, StackTrace stack) {
      var details = makeDetails(obj, stack);
      reportErrorAndLog(details);
    },
  );
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title:'异常捕获',
      theme: ThemeData(primarySwatch: Colors.cyan),
      home: MyAppPage(title:'异常捕获'),
    );
  }
}

class MyAppPage extends StatefulWidget {
  final String title;
  MyAppPage({Key key, this.title}) : super(key:key);

  @override
  MyAppPageState createState() => MyAppPageState();
}

class MyAppPageState extends State<MyAppPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: ListView(
        scrollDirection: Axis.vertical,
        children: <Widget>[
          FlatButton(
            onPressed: (){
              //报告错误 
              throw '异常测试';
              // print("结果输出");
            }, 
            child: Text('ceshi'),
            color: Colors.yellowAccent,
          ),
        ],
      )
    );
  }
}

