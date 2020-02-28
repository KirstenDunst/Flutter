/*
 * @Author: Cao Shixin
 * @Date: 2020-02-28 14:20:23
 * @LastEditors: Cao Shixin
 * @LastEditTime: 2020-02-28 14:41:51
 * @Description: 表单输入
 */

import 'package:flutter/material.dart';

class FormInput extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return SampleApp();
  }
}

class SampleApp extends StatefulWidget {
  @override
  _SampleAppState createState() => _SampleAppState();
}

class _SampleAppState extends State<SampleApp>
    with SingleTickerProviderStateMixin {
  AnimationController _controller;
  final _myController = TextEditingController();
  String _errorText;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(vsync: this);
  }

  @override
  void dispose() {
    super.dispose();
    _myController.dispose();
    _controller.dispose();
  }

/*
 * Flutter 中表单怎么工作？我怎么拿到用户的输入？
 * 我们已经提到 Flutter 使用不可变的 widget，并且状态是分离的，你可能会好奇在这种情境下怎么处理用户的输入。
 * 在 iOS 中，你经常在需要提交数据时查询组件当前的状态或动作，但这在 Flutter 中是怎么工作的呢？
 * 在表单处理的实践中，就像在 Flutter 中任何其他的地方一样，要通过特定的 widgets。
 * 如果你有一个 TextField 或是 TextFormField，你可以通过 TextEditingController 来获得用户输入：
 */
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Retrieve Text Input'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: TextField(
          controller: _myController,
          /**
           * 怎么展示验证错误信息？
           * 就像展示“小提示”一样，向 Text widget 的装饰器构造器参数中传递一个 InputDecoration。
           * 然而，你并不想在一开始就显示错误信息。相反，当用户输入了验证信息，更新状态，并传入一个新的 InputDecoration 对象：
           */
          onSubmitted: (String text) {
            setState(() {
              if (!isEmail(text)) {
                _errorText = "Error: is not a email";
              } else {
                _errorText = null;
              }
            });
          },
           /**
           * Text field 中的 placeholder 相当于什么？
           * 在 Flutter 中，你可以轻易地通过向 Text widget 的装饰构造器参数重传递 InputDecoration 来展示“小提示”，或是占位符文字：
           */
          decoration: InputDecoration(hintText:'This is a hit', errorText: _getErrorText()),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          return showDialog(
            context: context,
            builder: (context) {
              return AlertDialog(
                content: Text(_myController.text),
              );
            }
          );
        },
        tooltip: 'Show me value!',
        child: Icon(Icons.text_fields),
      ),
    );
  }

  _getErrorText() {
    return _errorText;
  }

  bool isEmail(String em) {
    String emailRegexp =
        r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';
    RegExp regExp = RegExp(emailRegexp);
    return regExp.hasMatch(em);
  }
}