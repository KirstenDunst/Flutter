import 'package:flutter/material.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  final String titleStr = '布局类组件介绍';
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

class _MyAppPageState extends State<MyAppPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body:
          //Row可以在水平方向排列其子widget
          /*
           * textDirection: 表示水平方向子组件的布局顺序(是从左往右还是从右往左)，默认为系统当前Locale环境的文本方向(如中文、英语都是从左往右，而阿拉伯语是从右往左)。
           * 
           * mainAxisSize：表示Row在主轴(水平)方向占用的空间，默认是MainAxisSize.max，表示尽可能多的占用水平方向的空间
           * 
           * mainAxisAlignment：表示子组件在Row所占用的水平空间内对齐方式
           * 
           * verticalDirection：表示Row纵轴（垂直）的对齐方向，默认是VerticalDirection.down，表示从上到下。
           * 
           * crossAxisAlignment：表示子组件在纵轴方向的对齐方式，Row的高度等于子组件中最高的子元素高度，
           */
          // Column(
          //   //测试Row对齐方式，排除Column默认居中对齐的干扰
          //   crossAxisAlignment: CrossAxisAlignment.start,
          //   children: <Widget>[
          //     Row(
          //       mainAxisAlignment: MainAxisAlignment.center,
          //       children: <Widget>[
          //         Text(" hello world "),
          //         Text(" I am Jack "),
          //       ],
          //     ),
          //     Row(
          //       mainAxisSize: MainAxisSize.min,
          //       mainAxisAlignment: MainAxisAlignment.center,
          //       children: <Widget>[
          //         Text(" hello world "),
          //         Text(" I am Jack "),
          //       ],
          //     ),
          //     Row(
          //       mainAxisAlignment: MainAxisAlignment.end,
          //       textDirection: TextDirection.rtl,
          //       children: <Widget>[
          //         Text(" hello world "),
          //         Text(" I am Jack "),
          //       ],
          //     ),
          //     Row(
          //       crossAxisAlignment: CrossAxisAlignment.start,
          //       verticalDirection: VerticalDirection.up,
          //       children: <Widget>[
          //         Text(
          //           " hello world ",
          //           style: TextStyle(fontSize: 30.0),
          //         ),
          //         Text(" I am Jack "),
          //       ],
          //     ),
          //   ],
          // ),

          //Column可以在垂直方向排列其子组件。参数和Row一样，不同的是布局方向为垂直，主轴纵轴正好相反，读者可类比Row来理解，
          // Column(
          //   crossAxisAlignment: CrossAxisAlignment.center,
          //   children: <Widget>[
          //     Text("hi", style: TextStyle(backgroundColor: Colors.orange)),
          //     Text("world", style: TextStyle(backgroundColor: Colors.orange)),
          //   ],
          // ),

          //实际上，Row和Column都只会在主轴方向占用尽可能大的空间，而纵轴的长度则取决于他们最大子元素的长度。
          //如果我们想让本例中的两个文本控件在整个手机屏幕中间对齐，我们有两种方法：1.使用center组件。2：将Column的宽度指定为屏幕宽度
          // ConstrainedBox(
          //   //将minWidth设为double.infinity，可以使宽度占用尽可能多的空间。
          //   constraints: BoxConstraints(minWidth: double.infinity),
          //   child: Column(
          //     crossAxisAlignment: CrossAxisAlignment.center,
          //     children: <Widget>[
          //       Text("hi", style: TextStyle(backgroundColor: Colors.cyan)),
          //       Text("world", style: TextStyle(backgroundColor: Colors.cyan)),
          //     ],
          //   ),
          // ),

          /**
           * 特殊情况
           * 
           * 如果Row里面嵌套Row，或者Column里面再嵌套Column，那么只有对最外面的Row或Column会占用尽可能大的空间，
           * 里面Row或Column所占用的空间为实际大小，下面以Column为例说明:
           */
          // Container(
          //   color: Colors.green,
          //   child: Padding(
          //     padding: const EdgeInsets.all(16.0),
          //     child: Column(
          //       crossAxisAlignment: CrossAxisAlignment.start,
          //       mainAxisSize: MainAxisSize.max, //有效，外层Colum高度为整个屏幕
          //       children: <Widget>[
          //         Container(
          //           color: Colors.red,
          //           child: Column(
          //             mainAxisSize: MainAxisSize.max, //无效，内层Colum高度为实际高度
          //             children: <Widget>[
          //               Text("hello world "),
          //               Text("I am Jack "),
          //             ],
          //           ),
          //         )
          //       ],
          //     ),
          //   ),
          // ),

          //如果要让里面的Column占满外部Column，可以使用Expanded 组件：
          // Container(
          //   color: Colors.green,
          //   child: Padding(
          //     padding: const EdgeInsets.all(16.0),
          //     child: Column(
          //       crossAxisAlignment: CrossAxisAlignment.start,
          //       mainAxisSize: MainAxisSize.max, //有效，外层Colum高度为整个屏幕
          //       children: <Widget>[
          //         Expanded(
          //           child: Container(
          //             color: Colors.red,
          //             child: Column(
          //               mainAxisAlignment: MainAxisAlignment.center, //垂直方向居中对齐
          //               children: <Widget>[
          //                 Text("hello world "),
          //                 Text("I am Jack "),
          //               ],
          //             ),
          //           ),
          //         ),
          //       ],
          //     ),
          //   ),
          // ),

          //弹性布局Flex : 弹性布局允许子组件按照一定比例来分配父容器空间。
          //Flutter中的弹性布局主要通过Flex和Expanded来配合实现。
          /**
       * Flex组件可以沿着水平或垂直方向排列子组件，如果你知道主轴方向，使用Row或Column会方便一些，因为Row和Column都继承自Flex，
       * 参数基本相同，所以能使用Flex的地方基本上都可以使用Row或Column。Flex本身功能是很强大的，它也可以和Expanded组件配合实现弹性布局。
       */
          //他的一个特殊参数：direction, 弹性布局的方向, Row默认为水平方向，Column默认为垂直方向
          //其他参数和Row与Column含义相同

          //Expanded ： 可以按比例“扩伸” Row、Column和Flex子组件所占用的空间
          /*参数flex
       * int类型，默认为1。
       * 如果为0或null，则child是没有弹性的，即不会被扩伸占用的空间。如果大于0，所有的Expanded按照其flex的比例来分割主轴的全部空闲空间
       */
      Column(
        children: <Widget>[
          //Flex的两个子widget按1：2来占据水平空间
          Flex(
            direction: Axis.horizontal,
            children: <Widget>[
              Expanded(
                flex: 1,
                child: Container(
                  height: 30.0,
                  color: Colors.red,
                ),
              ),
              Expanded(
                flex: 2,
                child: Container(
                  height: 30.0,
                  color: Colors.green,
                ),
              ),
            ],
          ),
          Padding(
            padding: const EdgeInsets.only(top: 20.0),
            child: SizedBox(
              height: 100.0,
              //Flex的三个子widget，在垂直方向按2：1：1来占用100像素的空间
              child: Flex(
                direction: Axis.vertical,
                children: <Widget>[
                  Expanded(
                    flex: 2,
                    child: Container(
                      height: 30.0,
                      color: Colors.red,
                    ),
                  ),
                  //Spacer的功能是占用指定比例的空间，实际上它只是Expanded的一个包装类
                  Spacer(
                    flex: 1,
                  ),
                  Expanded(
                    flex: 1,
                    child: Container(
                      height: 30.0,
                      color: Colors.green,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),


    );
  }
}
