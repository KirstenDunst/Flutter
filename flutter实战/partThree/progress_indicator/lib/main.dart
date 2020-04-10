import 'package:flutter/material.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  final String titleStr = '进度指示器';
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
 * Material 组件库中提供了两种进度指示器：LinearProgressIndicator和CircularProgressIndicator，
 * 它们都可以同时用于精确的进度指示和模糊的进度指示。
 * 
 * 精确进度通常用于任务进度可以计算和预估的情况，比如文件下载；
 * 而模糊进度则用户任务进度无法准确获得的情况，如下拉刷新，数据提交等。
 */
class _MyAppPageState extends State<MyAppPage>
    with SingleTickerProviderStateMixin {
  AnimationController _animationController;

  @override
  void initState() {
    //动画执行时间3秒
    _animationController =
        new AnimationController(vsync: this, duration: Duration(seconds: 3));
    _animationController.forward();
    _animationController.addListener(() => setState(() => {}));
    super.initState();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: ListView(
        scrollDirection: Axis.vertical,
        children: <Widget>[
          //LinearProgressIndicator是一个线性、条状的进度条
          /**
           * value：value表示当前的进度，取值范围为[0,1]；如果value为null时则指示器会执行一个循环动画（模糊进度）；
           *    当value不为null时，指示器为一个具体进度的进度条。
           * backgroundColor：指示器的背景色。
           * valueColor: 指示器的进度条颜色；值得注意的是，该值类型是Animation<Color>，这允许我们对进度条的颜色也可以指定动画。
           *    如果我们不需要对进度条颜色执行动画，换言之，我们想对进度条应用一种固定的颜色，此时我们可以通过AlwaysStoppedAnimation来指定。
           */
          Column(
            children: <Widget>[
              // 模糊进度条(会执行一个动画)
              Padding(
                padding: EdgeInsets.all(16),
                child: LinearProgressIndicator(
                  backgroundColor: Colors.grey[200],
                  valueColor: AlwaysStoppedAnimation(Colors.orange),
                ),
              ),
              //进度条显示50%
              Padding(
                padding: EdgeInsets.all(16),
                child: LinearProgressIndicator(
                  backgroundColor: Colors.grey[200],
                  valueColor: AlwaysStoppedAnimation(Colors.blue),
                  value: .5,
                ),
              ),
            ],
          ),

          //CircularProgressIndicator是一个圆形进度条
          /*
           * 前三个参数和LinearProgressIndicator相同，不再赘述。
           * strokeWidth 表示圆形进度条的粗细。
           */
          Column(
            children: <Widget>[
              // 模糊进度条(会执行一个旋转动画)
              Padding(
                padding: EdgeInsets.all(16),
                child: CircularProgressIndicator(
                  backgroundColor: Colors.grey[200],
                  valueColor: AlwaysStoppedAnimation(Colors.blue),
                ),
              ),
              //进度条显示50%，会显示一个半圆
              Padding(
                padding: EdgeInsets.all(16),
                child: CircularProgressIndicator(
                  backgroundColor: Colors.grey[200],
                  valueColor: AlwaysStoppedAnimation(Colors.blue),
                  value: .5,
                ),
              ),
            ],
          ),

          Text('自定义尺寸'),
          Column(
            children: <Widget>[
              // 线性进度条高度指定为3
              Padding(
                padding: EdgeInsets.all(16),
                child: SizedBox(
                  height: 3,
                  child: LinearProgressIndicator(
                    backgroundColor: Colors.grey[200],
                    valueColor: AlwaysStoppedAnimation(Colors.blue),
                    value: .5,
                  ),
                ),
              ),
              // 圆形进度条直径指定为100
              Padding(
                padding: EdgeInsets.all(16),
                child: SizedBox(
                  height: 100,
                  width: 100,
                  child: CircularProgressIndicator(
                    backgroundColor: Colors.grey[200],
                    valueColor: AlwaysStoppedAnimation(Colors.blue),
                    value: .7,
                  ),
                ),
              ),
            ],
          ),

          Text('进度色动画'),
          Padding(
            padding: EdgeInsets.all(16),
            child: LinearProgressIndicator(
              backgroundColor: Colors.grey[200],
              valueColor: ColorTween(begin: Colors.grey, end: Colors.blue)
                  .animate(_animationController), // 从灰色变成蓝色
              value: _animationController.value,
            ),
          ),


          
        ],
      ),
    );
  }
}
