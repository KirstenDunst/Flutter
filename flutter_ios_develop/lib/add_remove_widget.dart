/*
 * @Author       : Cao Shixin
 * @Date         : 2020-02-26 14:29:32
 * @LastEditors  : Cao Shixin
 * @LastEditTime : 2020-02-26 16:18:31
 * @Description  : 添加和移除组件
 */
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class AddRemoveWidget extends StatelessWidget {
  @override
  Widget build(BuildContext content) {
    return SampleAppPage();
  }
}

class SampleAppPage extends StatefulWidget {
  SampleAppPage ({Key key}) :super(key: key);
  @override
  _SampleAppPageState createState() => _SampleAppPageState();
}

class _SampleAppPageState extends State<SampleAppPage> {
  bool toggle = true;
  void _toggle() {
    setState(() {
      toggle = !toggle;
    });
  }

  _getToggleChild() {
    if (toggle) {
      return Text("Toggle One");
    } else {
      return CupertinoButton(child: Text("Toggle Two"), onPressed: (){},);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Sample App"),
      ),
      body: Center(
        child: _getToggleChild(),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _toggle,
        tooltip: 'Update Text',
        child: Icon(Icons.update),
      ),
    );
  }
}