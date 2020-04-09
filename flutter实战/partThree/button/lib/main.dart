import 'package:flutter/material.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'button',
      theme: ThemeData(primarySwatch: Colors.blue),
      home: MyAppPage(title: 'Button'),
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
 *Material 组件库中提供了多种按钮组件如RaisedButton、FlatButton、OutlineButton等，
 它们都是直接或间接对RawMaterialButton组件的包装定制，所以他们大多数属性都和RawMaterialButton一样。 
 */

/*
 * 所有Material 库中的按钮都有如下相同点：

按下时都会有“水波动画”（又称“涟漪动画”，就是点击时按钮上会出现水波荡漾的动画）。
有一个onPressed属性来设置点击回调，当按钮按下时会执行该回调，如果不提供该回调则按钮会处于禁用状态，禁用状态不响应用户点击。
 */

class MyAppPageState extends State<MyAppPage> {
  @override
  Widget build(BuildContext context) {
    var img = AssetImage("images/demo.jpg");

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: ListView(
        scrollDirection: Axis.vertical,
        children: <Widget>[
          //RaisedButton 即"漂浮"按钮，它默认带有阴影和灰色背景。按下后，阴影会变大
          RaisedButton(
            child: Text("normal"),
            onPressed: () {},
          ),

          //FlatButton即扁平按钮，默认背景透明并不带阴影。按下后，会有背景色，
          FlatButton(
            child: Text("normal"),
            onPressed: () {},
          ),

          //OutlineButton默认有一个边框，不带阴影且背景透明。按下后，边框颜色会变亮、同时出现背景和阴影(较弱)，
          OutlineButton(
            child: Text("normal"),
            onPressed: () {},
          ),

          //IconButton是一个可点击的Icon，不包括文字，默认没有背景，点击后会出现背景，
          IconButton(
            icon: Icon(Icons.thumb_up),
            onPressed: () {},
          ),

          //带图标的按钮 RaisedButton、FlatButton、OutlineButton都有一个icon 构造函数，通过它可以轻松创建带图标的按钮，
          RaisedButton.icon(
            icon: Icon(Icons.send),
            label: Text("发送"),
            onPressed: () {},
          ),
          OutlineButton.icon(
              icon: Icon(Icons.add), label: Text("添加"), onPressed: () {}),
          FlatButton.icon(
              icon: Icon(Icons.info), label: Text("详情"), onPressed: () {}),

          //自定义按钮外观 : 按钮外观可以通过其属性来定义，不同按钮属性大同小异，我们以FlatButton为例，介绍一下常见的按钮属性
          FlatButton(
            color: Colors.blue,
            highlightColor: Colors.blue[700],
            colorBrightness: Brightness.dark,
            splashColor: Colors.grey,
            child: Text("Submit"),
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20.0)),
            onPressed: () {},
          ),
          RaisedButton(
            color: Colors.blue,
            highlightColor: Colors.blue[700],
            colorBrightness: Brightness.dark,
            splashColor: Colors.grey,
            child: Text("Submit"),
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20.0)),
            onPressed: () {},
          ),

          //图片加载
          //加载本地图片
          Image(image: AssetImage("images/demo.jpg"), width: 100.0),
          //快捷构造函数
          Image.asset(
            "images/demo.jpg",
            //width、height：用于设置图片的宽、高，当不指定宽高时，图片会根据当前父容器的限制，尽可能的显示其原始大小，
            //如果只设置width、height的其中一个，那么另一个属性默认会按比例缩放，但可以通过下面介绍的fit属性来指定适应规则。
            width: 100.0,
          ),

          //加载网络图片
          Image(
            image: NetworkImage(
                'https://avatars2.githubusercontent.com/u/20411648?s=460&v=4'),
            width: 100,
          ),
          //快结构造器
          Image.network(
            'https://avatars2.githubusercontent.com/u/20411648?s=460&v=4',
            width: 100,
          ),

          Column(
              children: <Image>[
            //fit：该属性用于在图片的显示空间和图片本身大小不同时指定图片的适应模式。
            Image(
              image: img,
              height: 50.0,
              width: 100.0,
              //fill：会拉伸填充满显示空间，图片本身长宽比会发生变化，图片会变形
              fit: BoxFit.fill,
            ),
            Image(
              image: img,
              height: 50,
              width: 50.0,
              //contain：这是图片的默认适应规则，图片会在保证图片本身长宽比不变的情况下缩放以适应当前显示空间，图片不会变形。
              fit: BoxFit.contain,
            ),
            Image(
              image: img,
              width: 100.0,
              height: 50.0,
              //cover：会按图片的长宽比放大后居中填满显示空间，图片不会变形，超出显示空间部分会被剪裁。
              fit: BoxFit.cover,
            ),
            Image(
              image: img,
              width: 100.0,
              height: 50.0,
              //fitWidth：图片的宽度会缩放到显示空间的宽度，高度会按比例缩放，然后居中显示，图片不会变形，超出显示空间部分会被剪裁。
              fit: BoxFit.fitWidth,
            ),
            Image(
              image: img,
              width: 100.0,
              height: 50.0,
              //fitHeight：图片的高度会缩放到显示空间的高度，宽度会按比例缩放，然后居中显示，图片不会变形，超出显示空间部分会被剪裁。
              fit: BoxFit.fitHeight,
            ),
            Image(
              image: img,
              width: 100.0,
              height: 50.0,
              //默认居中，根据外部来调整尺寸大小以适应
              fit: BoxFit.scaleDown,
            ),
            Image(
              image: img,
              height: 50.0,
              width: 100.0,
              //none：图片没有适应策略，会在显示空间内显示图片，如果图片比显示空间大，则显示空间只会显示图片中间部分。
              fit: BoxFit.none,
            ),
            Image(
              image: img,
              width: 100.0,
              // color和 colorBlendMode：在图片绘制时可以对每一个像素进行颜色混合处理，color指定混合色，而colorBlendMode指定混合模式，
              color: Colors.blue,
              colorBlendMode: BlendMode.difference,
              fit: BoxFit.fill,
            ),
            Image(
              image: img,
              width: 100.0,
              height: 200.0,
              //repeat：当图片本身大小小于显示空间时，指定图片的重复规则。
              repeat: ImageRepeat.repeatY,
            )
          ].map((e) {
            return Row(
              children: <Widget>[
                Padding(
                  padding: EdgeInsets.all(16.0),
                  child: SizedBox(
                    width: 100,
                    child: e,
                  ),
                ),
                Text(e.fit.toString())
              ],
            );
          }).toList()),
/*
 * Flutter框架对加载过的图片是有缓存的（内存），默认最大缓存数量是1000，最大缓存空间为100M
 */

/*
 *ICON
 
 Flutter中，可以像Web开发一样使用iconfont，iconfont即“字体图标”，它是将图标做成字体文件，然后通过指定不同的字符而显示不同的图片。

在字体文件中，每一个字符都对应一个位码，而每一个位码对应一个显示字形，不同的字体就是指字形不同，即字符对应的字形是不同的。而在iconfont中，只是将位码对应的字形做成了图标，所以不同的字符最终就会渲染成不同的图标。
 */
          Text(
            '\uE914' + ' \uE000' + ' \uE90D',
            style: TextStyle(
                fontFamily: "MaterialIcons",
                fontSize: 24.0,
                color: Colors.green),
          ),
          //通过这个示例可以看到，使用图标就像使用文本一样，但是这种方式需要我们提供每个图标的码点，这并对开发者不友好，所以，Flutter封装了IconData和Icon来专门显示字体图标，上面的例子也可以用如下方式实现：
          Icon(
            Icons.accessible,
            color: Colors.red,
          ),
          Icon(
            Icons.error,
            color: Colors.orange,
          ),
          Icon(
            Icons.fingerprint,
            color: Colors.green,
          ),

          //字体图标引入


        ],
      ),
    );
  }
}
