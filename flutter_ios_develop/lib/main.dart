/*
 * @Author       : Cao Shixin
 * @Date         : 2020-02-26 09:23:54
 * @LastEditors: Cao Shixin
 * @LastEditTime: 2020-02-28 14:48:39
 * @Description  : 主控制器
 */
import 'package:flutter/material.dart';
import 'package:flutter_ios_develop/animation_widget.dart';
import 'package:flutter_ios_develop/canvas_widget.dart';
import 'package:flutter_ios_develop/form_input.dart';
import 'package:flutter_ios_develop/ges_widget.dart';
import 'package:flutter_ios_develop/last_%20interaction_platform.dart';
import 'package:flutter_ios_develop/local_resource.dart';
import 'package:flutter_ios_develop/longtime_task_progress.dart';
import 'dart:convert' show json;
import 'package:flutter_ios_develop/padding_change_view.dart';
import 'package:flutter_ios_develop/add_remove_widget.dart';
import 'package:flutter_ios_develop/scroll_flutter.dart';
import 'package:flutter_ios_develop/tabview_collection.dart';
import 'package:flutter_ios_develop/threading_asynchrony.dart';
import 'package:flutter_ios_develop/vc_widgets.dart';
import 'package:flutter_ios_develop/widgets_by_self.dart';


void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    // final wordPair = new WordPair.random();
    return MaterialApp(
      title: 'Startup Name Generator',
      /**
       * 给 App 设置主题
       * 为了充分发挥你的 App 中 MD 组件的优势，声明一个顶级 widget，MaterialApp，用作你的 App 入口。
       * MaterialApp 是一个便利组件，包含了许多 App 通常需要的 MD 风格组件。它通过一个 WidgetsApp 添加了 MD 功能来实现。
       * 
       * 你也可以在你的 App 中使用 WidgetApp，它提供了许多相似的功能，但不如 MaterialApp 那样强大。
       * 对任何子组件定义颜色和样式，可以给 MaterialApp widget 传递一个 ThemeData 对象。
       * 举个例子，在下面的代码中，primary swatch 被设置为蓝色，并且文字的选中颜色是红色：
       */
      theme: new ThemeData(
        primaryColor: Colors.blue,
        textSelectionColor: Colors.red
      ),
      home: new Assets(),
    );
  }
}

class Assets extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: new AppBar(
        title: new Text('Flutter Main'),
      ),
      body: new JsonView(),
    );
  }
}
class JsonView extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return new _JsonViewState();
  }
}

class _JsonViewState extends State<JsonView> {
  @override
  Widget build(BuildContext context) {
    return new FutureBuilder(
      future: DefaultAssetBundle.of(context).loadString("assets/content.json"),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          List<dynamic> data = json.decode(snapshot.data.toString());

          return new ListView.builder(
            itemCount: data.length,
            itemBuilder: (BuildContext context, int index) {
              return new Card(
                child: new Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: <Widget>[
                    _buildRow(data[index])
                  ],
                ),
              );
            },
          );
        }
        return new CircularProgressIndicator();
      },
    );
  }

  Widget _buildRow(Map map) {
    return new ListTile(
      title: new Text("title: ${map["title"]}\ncontent: ${map["content"]}\nsubTitle: ${map["subTitle"]}"),
      onTap: () {
        switch (map["contentWidget"]) {
          case "PaddingChange":
            Navigator.push(context, MaterialPageRoute(builder: (context) => PaddingChange()),);
            break;
          case "AddRemoveWidget":
            Navigator.push(context, MaterialPageRoute(builder: (context) => AddRemoveWidget()),);
            break;
          case "AnimationWidget":
            Navigator.push(context, MaterialPageRoute(builder: (context) => AnimationWidget()),);
            break;
          case "Signature":
            Navigator.push(context, MaterialPageRoute(builder: (context) => Signature()),);
            break;
          case "WidgetBySelf":
            Navigator.push(context, MaterialPageRoute(builder: (context) => WidgetBySelf()),);
            break;
          case "ThreadAsynchrony":
            Navigator.push(context, MaterialPageRoute(builder: (context) => ThreadAsynchrony()),);
            break;
          case "TaskProgress":
            Navigator.push(context, MaterialPageRoute(builder: (context) => TaskProgress()),);
            break;
          case "LocalResource":
            Navigator.push(context, MaterialPageRoute(builder: (context) => LocalResource()),);
            break;
          case "VCWidgets":
            Navigator.push(context, MaterialPageRoute(builder: (context) => VCWidgets()),);
            break;
          case "TabColFlutter":
            Navigator.push(context, MaterialPageRoute(builder: (context) => TabColFlutter()),);
            break;
          case "ScrollWidget":
            Navigator.push(context, MaterialPageRoute(builder: (context) => ScrollWidget()),);
            break;
          case "GesterWidget":
            Navigator.push(context, MaterialPageRoute(builder: (context) => GesterWidget()),);
            break;
          case "FormInput":
            Navigator.push(context, MaterialPageRoute(builder: (context) => FormInput()),);
            break;
          case "PlatformInteraction":
            Navigator.push(context, MaterialPageRoute(builder: (context) => PlatformInteraction()),);
            break;
          default:
        }
      },
    );
  }
}
