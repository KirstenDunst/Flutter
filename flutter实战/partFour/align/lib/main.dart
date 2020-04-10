import 'package:flutter/material.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  final String titleStr = '对齐与相对定位Align';
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: titleStr,
      theme: ThemeData(primarySwatch: Colors.blue),
      home: MyAppPage(title: titleStr),
    );
  }
}

class MyAppPage extends StatefulWidget {
  final String title;
  MyAppPage({Key key, this.title}) : super(key: key);

  @override
  _MyAppPageState createState() => _MyAppPageState();
}

//与Stack和Positioned类似，
//但如果我们只想简单的调整一个子元素在父元素中的位置的话，使用Align组件会更简单一些。

//Align 组件可以调整子组件的位置，并且可以根据子组件的宽高来确定自身的的宽高

/*
 * alignment : 需要一个AlignmentGeometry类型的值，表示子组件在父组件中的起始位置。AlignmentGeometry 是一个抽象类，
 *    它有两个常用的子类：Alignment和 FractionalOffset，我们将在下面的示例中详细介绍。
 * 
 * widthFactor和heightFactor是用于确定Align 组件本身宽高的属性；它们是两个缩放因子，会分别乘以子元素的宽、高，最终的
 *    结果就是Align 组件的宽高。如果值为null，则组件的宽高将会占用尽可能多的空间。
 */

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
          Column(
            children: <Widget>[
              Container(
                height: 120.0,
                width: 120.0,
                color: Colors.blue[50],
                child: Align(
                  alignment: Alignment.topRight,
                  child: FlutterLogo(
                    size: 60,
                  ),
                ),
              ),
            ],
          ),

          //如果我们不显示的指定宽高都为120，而通过Align同时指定widthFactor和heightFactor 为2也是可以达到同样的效果：
          Column(
            children: <Widget>[
              Container(
                color: Colors.orangeAccent,
                child: Align(
                  //设置宽高因子，组件的宽和高就是子组件的宽或高乘以宽或高因子得出的宽或高
                  widthFactor: 2,
                  heightFactor: 2,
                  alignment: Alignment.topRight,
                  child: FlutterLogo(
                    size: 60,
                  ),
                ),
              ),
            ],
          ),

          //Alignment
          /*
           * Alignment继承自AlignmentGeometry，表示矩形内的一个点，他有两个属性x、y，分别表示在水平和垂直方向的偏移，
           * 
           * Alignment Widget会以矩形的中心点作为坐标原点，即Alignment(0.0, 0.0),x、y的值从-1到1分别代表矩形左边到右边的距离和顶部到底边的距离
           */
          Column(
            children: <Widget>[
              Container(
                  color: Colors.cyanAccent,
                  child: Align(
                    widthFactor: 2,
                    heightFactor: 2,
                    alignment: Alignment(2, 0.0),
                    child: FlutterLogo(
                      size: 60,
                    ),
                  )),
            ],
          ),

          //FractionalOffset
          /**
           * FractionalOffset 继承自 Alignment，它和 Alignment唯一的区别就是坐标原点不同！
           * FractionalOffset 的坐标原点为矩形的左侧顶点,和布局系统的一致
           */
          Column(
            children: <Widget>[
              Container(
                height: 120.0,
                width: 120.0,
                color: Colors.blue[50],
                child: Align(
                  alignment: FractionalOffset(0.2, 0.6),
                  child: FlutterLogo(
                    size: 60,
                  ),
                ),
              )
            ],
          ),

          //Align和Stack对比
          /*区别：
           * 1.定位参考系统不同；Stack/Positioned定位的的参考系可以是父容器矩形的四个顶点；
           *     而Align则需要先通过alignment 参数来确定坐标原点，不同的alignment会对应不同原点，
           *     最终的偏移是需要通过alignment的转换公式来计算出。
           * 2.Stack可以有多个子元素，并且子元素可以堆叠，而Align只能有一个子元素，不存在堆叠。
           */

          //Center组件
          /*
           * Center继承自Align，它比Align只少了一个alignment 参数；由于Align的构造函数中alignment 值为Alignment.center，
           * 所以，我们可以认为Center组件其实是对齐方式确定（Alignment.center）了的Align。
           */
          Column(
            //当widthFactor或heightFactor为null时组件的宽高将会占用尽可能多的空间
            children: <Widget>[
              DecoratedBox(
                decoration: BoxDecoration(color: Colors.red),
                child: Center(
                  child: Text("xxx"),
                ),
              ),
              DecoratedBox(
                decoration: BoxDecoration(color: Colors.red),
                child: Center(
                  widthFactor: 1,
                  heightFactor: 1,
                  child: Text("xxx"),
                ),
              ),
            ],
          ),


        ],
      ),
    );
  }
}
