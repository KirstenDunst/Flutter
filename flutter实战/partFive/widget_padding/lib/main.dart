import 'package:flutter/material.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  final String titleStr = '容器类Widget填充Padding';
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

/*
 * 容器类Widget和布局类Widget都作用于其子Widget，不同的是：
 * 
 * 1.布局类Widget一般都需要接收一个widget数组（children），他们直接或间接继承自（或包含）MultiChildRenderObjectWidget ；
 *      而容器类Widget一般只需要接收一个子Widget（child），他们直接或间接继承自（或包含）SingleChildRenderObjectWidget。
 * 
 * 2.布局类Widget是按照一定的排列方式来对其子Widget进行排列；而容器类Widget一般只是包装其子Widget，对其添加一些修饰（补白或背景色等）、
 *      变换(旋转或剪裁等)、或限制(大小等)。
 * 
 * 注意，Flutter官方并没有对Widget进行官方分类，我们对其分类主要是为了方便讨论和对Widget功能区分的记忆。
 */

/*
 * Padding可以给其子节点添加填充（留白），和边距效果类似。
 * 他的一个参数：EdgeInsetsGeometry是一个抽象类，开发中，我们一般都使用EdgeInsets类，它是EdgeInsetsGeometry的一个子类，定义了一些设置填充的便捷方法。
 */
class _MyAppPageState extends State<MyAppPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      /*
       * EdgeInsets
       * EdgeInsets提供的便捷方法：
       * 
       * 1.fromLTRB(double left, double top, double right, double bottom)：分别指定四个方向的填充。
       * 2.all(double value) : 所有方向均使用相同数值的填充。
       * 3.only({left, top, right ,bottom })：可以设置具体某个方向的填充(可以同时指定多个方向)。
       * 4.symmetric({ vertical, horizontal })：用于设置对称方向的填充，vertical指top和bottom，horizontal指left和right。
       */
      body: Padding(
        //上下左右各添加16像素补白
        padding: EdgeInsets.all(16.0),
        child: Column(
          //显式指定对齐方式为左对齐，排除对齐干扰
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Padding(
              //左边添加8像素补白
              padding: const EdgeInsets.only(left: 8.0),
              child: Text("Hello world"),
            ),
            Padding(
              //上下各添加8像素补白
              padding: const EdgeInsets.symmetric(vertical: 8.0),
              child: Text("I am Jack"),
            ),
            Padding(
              // 分别指定四个方向的补白
              padding: const EdgeInsets.fromLTRB(20.0, .0, 20.0, 20.0),
              child: Text("Your friend"),
            )
          ],
        ),
      ),
    );
  }
}
