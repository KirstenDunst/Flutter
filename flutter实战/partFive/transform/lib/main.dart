import 'package:flutter/material.dart';
import 'dart:math' as math;

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  static String title = 'transform';
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MyAppPage(title: title),
    );
  }
}

class MyAppPage extends StatefulWidget {
  final String title;
  MyAppPage({Key key, this.title}) : super(key: key);

  @override
  _MyAppPageState createState() => _MyAppPageState();
}

class _MyAppPageState extends State<MyAppPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: ListView(
        scrollDirection: Axis.vertical,
        children: <Widget>[
          /**
           * Transform可以在其子组件绘制时对其应用一些矩阵变换来实现一些特效。Matrix4是一个4D矩阵，通过它我们可以实现各种矩阵操作，下面是一个例子:
           */
          Center(
            child: Container(
              color: Colors.black,
              child: new Transform(
                transform: new Matrix4.skewY(0.3), //沿y轴倾斜0.3弧度
                child: new Container(
                  padding: EdgeInsets.all(8.0),
                  color: Colors.orange,
                  child: const Text('Apartment for rent!'),
                ),
              ),
            ),
          ),

          /* 平移
           * Transform.translate接收一个offset参数，可以在绘制时沿x、y轴对子组件平移指定的距离。
           */
          Center(
            child: DecoratedBox(
              decoration: BoxDecoration(color: Colors.red),
              //默认原点为左上角，左移20像素，上移5像素
              child: Transform.translate(
                offset: Offset(-20.0, -5),
                child: Text('平移'),
              ),
            ),
          ),

          /**
           * 旋转 Transform.rotate可以对子组件进行旋转变换，如
           */
          Center(
            child: DecoratedBox(
              decoration: BoxDecoration(color: Colors.red),
              child: Transform.rotate(
                angle: math.pi / 2,
                child: Text("Hello world"),
              ),
            ),
          ),

          /**
           * 缩放
           */
          Center(
            child: DecoratedBox(
              decoration: BoxDecoration(color: Colors.red),
              child: Transform.scale(
                scale: 1.5, //放大到1.5倍
                child: Text('Hello World'),
              ),
            ),
          ),
          

          /**
           * 从上面来看Transform是在layout之后进行的变换。
           * 另外一个组件RotateBox也是进行变换，区别就在于，它是在layout之后的旋转。
           */
          Container(
              child: Row(
            children: <Widget>[
              DecoratedBox(
                decoration: BoxDecoration(color: Colors.red),
                child: RotatedBox(
                  quarterTurns: 1, //旋转90度，即1/4圈
                  child: Text('旋转90度'),
                ),
              ),
            ],
          ))
        ],
      ),
    );
  }
}
