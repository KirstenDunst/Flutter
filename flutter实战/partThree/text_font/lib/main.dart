import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: '文本字体样式',
      theme: ThemeData(primarySwatch: Colors.blue),
      home: MyAppPage(title: '文本字体样式'),
    );
  }
}

class MyAppPage extends StatefulWidget {
  final String title;
  MyAppPage({Key key, this.title}) : super(key: key);

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
          Text(
            "Hello world",
            textAlign: TextAlign.left,
          ),
          Text(
            "Hello world! I'm Jack. " * 4,
            maxLines: 1,
            //overflow来指定截断方式，默认是直接截断，TextOverflow.ellipsis，它会将多余文本截断后以省略符“...”表示；
            overflow: TextOverflow.ellipsis,
          ),
          Text(
            "Hello world",
            //textScaleFactor：代表文本相对于当前字体大小的缩放因子，相对于去设置文本的样式style属性的fontSize，
            //它是调整字体大小的一个快捷方式。该属性的默认值可以通过MediaQueryData.textScaleFactor获得，
            //如果没有MediaQuery，那么会默认值将为1.0。
            textScaleFactor: 1.5,
          ),
          Text(
            "Hello world",
            //TextStyle用于指定文本显示的样式如颜色、字体、粗细、背景等。
            style: TextStyle(
                color: Colors.blue,
                fontSize: 18.0,
                height: 1.2,
                fontFamily: "Courier",
                background: new Paint()..color = Colors.yellow,
                decoration: TextDecoration.underline,
                decorationStyle: TextDecorationStyle.dashed),
          ),
          /*
           * height：该属性用于指定行高，但它并不是一个绝对值，而是一个因子，具体的行高等于fontSize*height。
           * 
           * fontFamily ：由于不同平台默认支持的字体集不同，所以在手动指定字体时一定要先在不同平台测试一下。
           * 
           * fontSize：该属性和Text的textScaleFactor都用于控制字体大小。但是有两个主要区别：
           *     fontSize可以精确指定字体大小，而textScaleFactor只能通过缩放比例来控制。
           *     textScaleFactor主要是用于系统字体大小设置改变时对Flutter应用字体进行全局调整，而fontSize通常用于单个文本，字体大小不会跟随系统字体大小变化。
           */

          //TextSpan: 让Text内容的不同部分按照不同的样式显示。TextSpan，它代表文本的一个“片段”。
          Text.rich(TextSpan(children: [
            TextSpan(text: "Home: "),
            TextSpan(
                text: "https://flutterchina.club",
                style: TextStyle(color: Colors.blue),
                recognizer: _tapRecognizer()),
          ])),

          /*
   * DefaultTextStyle
   * 
   * 在Widget树中，文本的样式默认是可以被继承的（子类文本类组件未指定具体样式时可以使用Widget树中父级设置的默认样式），
   * 因此，如果在Widget树的某一个节点处设置一个默认的文本样式，那么该节点的子树中所有文本都会默认使用这个样式，
   * 而DefaultTextStyle正是用于设置默认文本样式的。
   */
          DefaultTextStyle(
            //1.设置文本默认样式
            style: TextStyle(
              color: Colors.red,
              fontSize: 20.0,
            ),
            textAlign: TextAlign.start,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text("hello world"),
                Text("I am Jack"),
                Text(
                  "I am Jack",
                  style: TextStyle(
                      inherit: false, //2.不继承默认样式
                      color: Colors.grey),
                ),
              ],
            ),
          ),

          
        ],
      ),
    );
  }

  GestureRecognizer _tapRecognizer() {
    print('跳转操作');
    //这里点击链接后的一个处理器，可以做跳转操作等。
  }
}
