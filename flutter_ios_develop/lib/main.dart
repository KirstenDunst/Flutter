/*
 * @Author       : Cao Shixin
 * @Date         : 2020-02-26 09:23:54
 * @LastEditors: Cao Shixin
 * @LastEditTime: 2020-02-28 13:41:29
 * @Description  : 主控制器
 */
import 'package:flutter/material.dart';
import 'package:flutter_ios_develop/animation_widget.dart';
import 'package:flutter_ios_develop/canvas_widget.dart';
import 'package:flutter_ios_develop/ges_widget.dart';
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
      theme: new ThemeData(
        primaryColor: Colors.blue
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
          default:
        }
      },
    );
  }
}
