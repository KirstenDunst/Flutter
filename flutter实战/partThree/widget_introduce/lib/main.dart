import 'package:flutter/material.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {

    /*
     * Material组件
     * Flutter提供了一套丰富的Material组件，它可以帮助我们构建遵循Material Design设计规范的应用程序。
     * Material应用程序以MaterialApp 组件开始， 该组件在应用程序的根部创建了一些必要的组件，比如Theme组件，
     * 它用于配置应用的主题。 是否使用MaterialApp完全是可选的，但是使用它是一个很好的做法。在之前的示例中，
     * 我们已经使用过多个Material 组件了，如：Scaffold、AppBar、FlatButton等。要使用Material 组件，
     * 需要先引入它：
     * import 'package:flutter/material.dart';
     */
    return MaterialApp(
      title: 'widget介绍',
      theme: ThemeData(primarySwatch: Colors.blue),
      home: MyAppPage(title: 'widget介绍'),
    );


    /*
   * Cupertino组件
   * Flutter也提供了一套丰富的Cupertino风格的组件，尽管目前还没有Material 组件那么丰富，但是它仍在不断的完善中。
   * 值得一提的是在Material 组件库中有一些组件可以根据实际运行平台来切换表现风格，比如MaterialPageRoute，在路由切换
   * 时，如果是Android系统，它将会使用Android系统默认的页面切换动画(从底向上)；如果是iOS系统，它会使用iOS系统默认的
   * 页面切换动画（从右向左）。由于在前面的示例中还没有Cupertino组件的示例，下面我们实现一个简单的Cupertino组件风格的
   * 页面：
   */

  }

}

class MyAppPage extends StatefulWidget {
  final String title;
  final int initValue;
  MyAppPage({Key key, this.title, this.initValue: 0}) : super(key: key);

  @override
  MyAppPageState createState() => MyAppPageState();
}

class MyAppPageState extends State<MyAppPage> {
  int _counter;

/*
 * 当Widget第一次插入到Widget树时会被调用，对于每一个State对象，Flutter framework只会调用一次该回调，
 * 所以，通常在该回调中做一些一次性的操作，如状态初始化、订阅子树的事件通知等。不能在该回调中调用
 * BuildContext.inheritFromWidgetOfExactType（该方法用于在Widget树上获取离当前widget最近的一个
 * 父级InheritFromWidget，关于InheritedWidget我们将在后面章节介绍），原因是在初始化完成后，Widget树中
 * 的InheritFromWidget也可能会发生变化，所以正确的做法应该在在build（）方法或didChangeDependencies()中调用它。
 */
  @override
  void initState() {
    super.initState();
    //初始化状态
    _counter = widget.initValue;
    print('initState');
  }

/*
 * 此回调读者现在应该已经相当熟悉了，它主要是用于构建Widget子树的，会在如下场景被调用：

在调用initState()之后。
在调用didUpdateWidget()之后。
在调用setState()之后。
在调用didChangeDependencies()之后。
在State对象从树中一个位置移除后（会调用deactivate）又重新插入到树的其它位置之后。
 */
  @override
  Widget build(BuildContext context) {
    print('build');
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: ListView(
        scrollDirection: Axis.vertical,
        children: <Widget>[
          Container(
            child: Builder(builder: (context) {
              // 在Widget树中向上查找最近的父级`Scaffold` widget
              Scaffold scaffold = context.ancestorWidgetOfExactType(Scaffold);
              // 直接返回 AppBar的title， 此处实际上是Text("Context测试")
              return (scaffold.appBar as AppBar).title;
            }),
          ),
          FlatButton(
            onPressed: () {
              setState(() {
                ++_counter;
              });
            },
            child: Text('$_counter'),
          ),
          Center(
            child: Builder(builder: (context) {
              return RaisedButton(
                onPressed: () {
                  // 查找父级最近的Scaffold对应的ScaffoldState对象
                  ScaffoldState _state =
                      context.ancestorStateOfType(TypeMatcher<ScaffoldState>());
                  //调用ScaffoldState的showSnackBar来弹出SnackBar
                  _state.showSnackBar(
                    SnackBar(
                      content: Text("我是SnackBar"),
                    ),
                  );
                },
                child: Text("显示SnackBar"),
              );
            }),
          ),
          //另外一种通过GlobalKey来进行控制子节点widget的，这里就不再赘述
          //（GlobalKey<子节点的需要的state> _globalKey= GlobalKey();）
          //通过_globalKey.currentState.openDrawer()来调用openDrawer()方法。

        ],
      ),
    );
  }

/*
 * 在widget重新构建时，Flutter framework会调用Widget.canUpdate来检测Widget树中同一位置的新旧节点，
 * 然后决定是否需要更新，如果Widget.canUpdate返回true则会调用此回调。正如之前所述，Widget.canUpdate会在
 * 新旧widget的key和runtimeType同时相等时会返回true，也就是说在在新旧widget的key和runtimeType同时相等
 * 时didUpdateWidget()就会被调用。
 */
  @override
  void didUpdateWidget(MyAppPage oldWidget) {
    super.didUpdateWidget(oldWidget);
    print('didUpdateWidget');
  }

/*
 *当State对象从树中被移除时，会调用此回调。在一些场景下，Flutter framework会将State对象重新插到树中，如包
 含此State对象的子树在树的一个位置移动到另一个位置时（可以通过GlobalKey来实现）。如果移除后没有重新插入到树中
 则紧接着会调用dispose()方法。 
 */
  @override
  void deactivate() {
    super.deactivate();
    print('deactivate');
  }

/*
 * 当State对象从树中被永久移除时调用；通常在此回调中释放资源。
 */
  @override
  void dispose() {
    super.dispose();
    print('dispose');
  }

/*
 * 此回调是专门为了开发调试而提供的，在热重载(hot reload)时会被调用，此回调在Release模式下永远不会被调用。
 */
  @override
  void reassemble() {
    super.reassemble();
    print('reassemble');
  }

/*
 * 当State对象的依赖发生变化时会被调用；例如：在之前build() 中包含了一个InheritedWidget，然后在之后的build()
 *  中InheritedWidget发生了变化，那么此时InheritedWidget的子widget的didChangeDependencies()回调都会被调用。
 * 典型的场景是当系统语言Locale或应用主题改变时，Flutter framework会通知widget调用此回调。
 */
  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    print('didChangeDependencies');
  }

  //初次运行的时候
  //执行顺序：initState -> didChangeDependencies -> build

  //点击按钮进行技术增1的执行热重载的时候
  //执行顺序：reassemble -> didUpdateWidget -> build

  //我们在跟路径MyApp中的 return MyAppPage(title:'widget介绍'),改成别的widget（例如：return Text("xxx");）返回之后，在进行热重载的时候
  //执行顺序：reassemble -> deactive -> dispose

}
