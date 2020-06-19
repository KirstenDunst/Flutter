/*
 * @Author: Cao Shixin
 * @Date: 2020-05-28 17:58:18
 * @LastEditors: Cao Shixin
 * @LastEditTime: 2020-06-19 17:08:02
 * @Description: 
 * @Email: cao_shixin@yahoo.com
 * @Company: BrainCo
 */
// import 'package:container/permission_handler.dart';
import 'package:flutter/material.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Container',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: Scaffold(
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
  @override
  Widget build(BuildContext context) {
    return ListView(
      scrollDirection: Axis.vertical,
      children: <Widget>[
        Container(
          margin: EdgeInsets.only(top: 50.0, left: 120.0), //容器外填充
          constraints:
              BoxConstraints.tightFor(width: 200.0, height: 150.0), //卡片大小
          decoration: BoxDecoration(
              //背景装饰
              gradient: RadialGradient(
                  //背景径向渐变
                  colors: [Colors.red, Colors.orange],
                  center: Alignment.topLeft,
                  radius: .98),
              boxShadow: [
                //卡片阴影
                BoxShadow(
                    color: Colors.black54,
                    offset: Offset(2.0, 2.0),
                    blurRadius: 4.0)
              ]),
          transform: Matrix4.rotationZ(.2), //卡片倾斜变换
          alignment: Alignment.center, //卡片内文字居中
          child: Text(
            //卡片文字
            "5.20", style: TextStyle(color: Colors.white, fontSize: 40.0),
          ),
        ),
        SizedBox(height: 100,),
        Container(
          margin: EdgeInsets.all(20.0), //容器外补白
          color: Colors.orange,
          child: Text("Hello world!"),
        ),
        SizedBox(height: 50,),
        Container(
          padding: EdgeInsets.all(20.0), //容器内补白
          color: Colors.orange,
          child: Text("Hello world!"),
        ),
      ],
    );
  }
}
