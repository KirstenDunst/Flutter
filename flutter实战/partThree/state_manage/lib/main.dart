import 'package:flutter/material.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: '状态管理',
      theme: ThemeData(primarySwatch: Colors.blue),
      home: MyAppPage(title: '状态管理'),
    );
  }
}

class MyAppPage extends StatefulWidget {
  final String title;
  MyAppPage({Key key, this.title}) : super(key: key);

  @override
  MyAppPageState createState() => MyAppPageState();
}

/*
 * 如何决定使用哪种管理方法？下面是官方给出的一些原则可以帮助你做决定：

如果状态是用户数据，如复选框的选中状态、滑块的位置，则该状态最好由父Widget管理。
如果状态是有关界面外观效果的，例如颜色、动画，那么状态最好由Widget本身来管理。
如果某一个状态是不同Widget共享的则最好由它们共同的父Widget管理。

在Widget内部管理状态封装性会好一些，而在父Widget中管理会比较灵活。有些时候，如果不确定到底该怎么管理状态，
那么推荐的首选是在父widget中管理（灵活会显得更重要一些）。
 */
class MyAppPageState extends State<MyAppPage> {
  //1.自己管理自己的状态：在这里创建变量，内部通过自身的事件触发setState方法来重新build

  //2.父Widget管理子Widget的状态，我们的子组件就是一个statelesswidget的组件，通过构造器将状态和点击方法传进去。

  //3.混合状态管理 ，这里着重解说一下（事例：手指按下时，盒子的周围会出现一个深绿色的边框，抬起时，边框消失。
  //点击完成后，盒子的颜色改变。 TapboxC将其_active状态导出到其父组件中，但在内部管理其_highlight状态。
  //这个例子有两个状态对象_ParentWidgetState和_TapboxCState。）
  bool _active = false;

  void _handleTapboxChanged(bool newValue) {
    setState(() {
      _active = newValue;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: new Container(
        child: new TapboxC(
          active: _active,
          onChanged: _handleTapboxChanged,
        ),
      ),
    );
  }

  /*4.全局状态管理
   * 
   * 当应用中需要一些跨组件（包括跨路由）的状态需要同步时，上面介绍的方法便很难胜任了。比如，我们有一个设置页，
   * 里面可以设置应用的语言，我们为了让设置实时生效，我们期望在语言状态发生改变时，APP中依赖应用语言的组件能够
   * 重新build一下，但这些依赖应用语言的组件和设置页并不在一起，所以这种情况用上面的方法很难管理。这时，正确的
   * 做法是通过一个全局状态管理器来处理这种相距较远的组件之间的通信。目前主要有两种办法：

实现一个全局的事件总线，将语言状态改变对应为一个事件，然后在APP中依赖应用语言的组件的initState 方法中订阅语言改变的事件。
当用户在设置页切换语言后，我们发布语言改变事件，而订阅了此事件的组件就会收到通知，收到通知后调用setState(...)方法重新build一下自身即可。

使用一些专门用于状态管理的包，如Provider、Redux，读者可以在pub上查看其详细信息。
   */
}

class TapboxC extends StatefulWidget {
  TapboxC({Key key, this.active: false, @required this.onChanged})
      : super(key: key);

  final bool active;
  final ValueChanged<bool> onChanged;

  @override
  _TapboxCState createState() => new _TapboxCState();
}

class _TapboxCState extends State<TapboxC> {
  bool _highlight = false;

  void _handleTapDown(TapDownDetails details) {
    setState(() {
      _highlight = true;
    });
  }

  void _handleTapUp(TapUpDetails details) {
    setState(() {
      _highlight = false;
    });
  }

  void _handleTapCancel() {
    setState(() {
      _highlight = false;
    });
  }

  void _handleTap() {
    widget.onChanged(!widget.active);
  }

  @override
  Widget build(BuildContext context) {
    // 在按下时添加绿色边框，当抬起时，取消高亮
    return new GestureDetector(
      onTapDown: _handleTapDown, // 处理按下事件
      onTapUp: _handleTapUp, // 处理抬起事件
      onTap: _handleTap,
      onTapCancel: _handleTapCancel,
      child: new Container(
        child: new Center(
          child: new Text(widget.active ? 'Active' : 'Inactive',
              style: new TextStyle(fontSize: 32.0, color: Colors.white)),
        ),
        width: 200.0,
        height: 200.0,
        decoration: new BoxDecoration(
          color: widget.active ? Colors.lightGreen[700] : Colors.grey[600],
          border: _highlight
              ? new Border.all(
                  color: Colors.teal[700],
                  width: 10.0,
                )
              : null,
        ),
      ),
    );
  }
}
