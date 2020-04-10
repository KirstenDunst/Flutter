import 'package:flutter/material.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  final String titleStr = '尺寸限制类容器';
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
 * 尺寸限制类容器
 * 
 * 尺寸限制类容器用于限制容器大小，Flutter中提供了多种这样的容器，如ConstrainedBox、SizedBox、UnconstrainedBox、AspectRatio等，
 * 本节将介绍一些常用的。
 */

class _MyAppPageState extends State<MyAppPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
        actions: <Widget>[
          UnconstrainedBox(child: //如果这里没有阻断父限制的话将会是一个纵向椭圆形loading
            SizedBox(
              width: 20,
              height: 20,
              child: CircularProgressIndicator(
                strokeWidth: 3,
                valueColor: AlwaysStoppedAnimation(Colors.white70),
              ),
            ),
          )
        ],
      ),
      body: ListView(
        scrollDirection: Axis.vertical,
        children: <Widget>[
          /*
           * ConstrainedBox用于对子组件添加额外的约束。例如，如果你想让子组件的最小高度是80像素，
           * 你可以使用const BoxConstraints(minHeight: 80.0)作为子组件的约束
           */
          ConstrainedBox(
            /*
             * BoxConstraints用于设置限制条件，它的定义如下：
             * const BoxConstraints({
             *    this.minWidth = 0.0, //最小宽度
             *    this.maxWidth = double.infinity, //最大宽度
             *    this.minHeight = 0.0, //最小高度
             *    this.maxHeight = double.infinity //最大高度
             * })
             */
            constraints: BoxConstraints(
                minWidth: double.infinity, //宽度尽可能大
                minHeight: 50.0 //最小高度为50像素
                ),
            //这里虽设置了高度为5.0。但是外部的最小定义了50.0约束了最小高度
            child: Container(height: 5.0, child: redBox),
          ),

          /*
           * SizedBox用于给子元素指定固定的宽高，如：
           */
          Column(
            children: <Widget>[
              Padding(
                padding: EdgeInsets.only(top: 15),
                child: SizedBox(width: 80.0, height: 80.0, child: redBox),
              ),
            ],
          ),

          /*
           * 实际上SizedBox只是ConstrainedBox的一个定制，上面代码等价于：
           * ConstrainedBox(
           *    constraints: BoxConstraints.tightFor(width: 80.0,height: 80.0),
           *    child: redBox, 
           * )
           * 而BoxConstraints.tightFor(width: 80.0,height: 80.0)等价于：
           * BoxConstraints(minHeight: 80.0,maxHeight: 80.0,minWidth: 80.0,maxWidth: 80.0)
           */

          Column(
            children: <Widget>[
              Padding(
                padding: EdgeInsets.only(top: 12),
                /*
                 * 多重限制
                 * 如果某一个组件有多个父级ConstrainedBox限制，那么最终会是哪个生效？我们看一个例子：
                 */
                child: ConstrainedBox(
                    constraints:
                        BoxConstraints(minWidth: 60.0, minHeight: 60.0), //父
                    child: ConstrainedBox(
                      constraints:
                          BoxConstraints(minWidth: 90.0, minHeight: 20.0), //子
                      child: redBox,
                    )),
                //多重限制时，对于minWidth和minHeight来说，是取父子中相应数值较大的。maxWidth和maxHeight是取父子中相应数值较小的。
              ),
            ],
          ),

          /*
           * UnconstrainedBox不会对子组件产生任何限制，它允许其子组件按照其本身大小绘制。一般情况下，我们会很少直接使用此组件，
           * 但在"去除"多重限制的时候也许会有帮助，
           */
          ConstrainedBox(
              constraints: BoxConstraints(minWidth: 60.0, minHeight: 100.0), //父
              child: UnconstrainedBox(
                //“去除”父级限制
                child: ConstrainedBox(
                  constraints:
                      BoxConstraints(minWidth: 90.0, minHeight: 20.0), //子
                  child: redBox,
                ),
              )),
          //上面代码中，如果没有中间的UnconstrainedBox，那么根据上面所述的多重限制规则，那么最终将显示一个90×100的红色框。但是由于UnconstrainedBox “去除”了父ConstrainedBox的限制，则最终会按照子ConstrainedBox的限制来绘制redBox，即90×20：
          //UnconstrainedBox对父组件限制的“去除”并非是真正的去除：上面例子中虽然红色区域大小是90×20，但上方仍然有80的空白空间。也就是说父限制的minHeight(100.0)仍然是生效的，只不过它不影响最终子元素redBox的大小，但仍然还是占有相应的空间，可以认为此时的父ConstrainedBox是作用于子UnconstrainedBox上，而redBox只受子ConstrainedBox限制

          /*
           * 没有方法可以彻底去除父ConstrainedBox的限制。
           * 在定义一个通用的组件时，如果要对子组件指定限制，那么一定要注意，因为一旦指定限制条件，子组件如果要进行相关自定义大小时将可能非常困难，
           * 因为子组件在不更改父组件的代码的情况下无法彻底去除其限制条件。
           */
          //在实际开发中，当我们发现已经使用SizedBox或ConstrainedBox给子元素指定了宽高，但是仍然没有效果时，几乎可以断定：已经有父元素已经设置了限制！
          //例如：Material组件库中的AppBar（导航栏）的右侧菜单中，我们使用SizedBox指定了loading按钮的大小的操作。代码在上面：





          /*
           * 其它尺寸限制类容器
           * 
           * 除了上面介绍的这些常用的尺寸限制类容器外，还有一些其他的尺寸限制类容器，比如AspectRatio，它可以指定子组件的长宽比、
           * LimitedBox 用于指定最大宽高、FractionallySizedBox 可以根据父容器宽高的百分比来设置子组件宽高等
           */
        ],
      ),
    );
  }

  Widget redBox = DecoratedBox(
    decoration: BoxDecoration(color: Colors.red),
  );
}
