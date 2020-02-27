/*
 * @Author       : Cao Shixin
 * @Date         : 2020-02-27 09:27:37
 * @LastEditors  : Cao Shixin
 * @LastEditTime : 2020-02-27 15:22:24
 * @Description  : 线程和异步
 * 
 * Dart 是单线程执行模型，但是它支持 Isolate（一种让 Dart 代码运行在其他线程的方式）、事件循环和异步编程。
 * 除非你自己创建一个 Isolate ，否则你的 Dart 代码永远运行在 UI 线程，并由 event loop 驱动。
 * Flutter 的 event loop 和 iOS 中的 main loop 相似——Looper 是附加在主线程上的。
 */

import 'dart:convert';
import 'dart:isolate';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class ThreadAsynchrony extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // //初级介绍
    // return  SampleAppPage();
    //多情况，运行于自己独立执行线程上的 Isolate
    return SampleAppPageOne();
  }
}

// /**
//  * Dart 的单线程模型并不意味着你写的代码一定是阻塞操作，从而卡住 UI。相反，使用 Dart 语言提供的异步工具，
//  * 例如 async / await ，来实现异步操作。
//  * 举个例子，你可以使用 async / await 来让 Dart 帮你做一些繁重的工作，编写网络请求代码而不会挂起 UI：
//  * 对于 I/O 操作，通过关键字 async，把方法声明为异步方法，然后通过await关键字等待该异步方法执行完成
//  */
// loadData() async {
//   String dataURL = "https://jsonplaceholder.typicode.com/posts";
//   var http;
//   http.Response response = await http.get(dataURL);
//   setState(() {
//     widgets = json.decode(response.body);
//   });
// }

class SampleAppPage extends StatefulWidget {
  SampleAppPage({Key key}) : super(key: key);

  @override
  _SampleAppPageState createState() => _SampleAppPageState();
}

class _SampleAppPageState extends State<SampleAppPage> {
  List widgets = [];

  @override
  void initState() {
    super.initState();
    loadData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("线程和异步"),
      ),
      body: ListView.builder(
        itemBuilder: (BuildContext context, int position) {
        return getRow(position);
        },
        itemCount: widgets.length,
      ),
    );
  }
  

  Widget getRow(int i) {
    return Padding(
      padding: EdgeInsets.all(10.0),
      child: Text("Row :${widgets[i]["title"]}"),
      );
  }



  loadData() async {
    String dataURL = "https://jsonplaceholder.typicode.com/posts";
    http.Response response = await http.get(dataURL);
    setState(() {
       widgets = json.decode(response.body);
    });
  }
}








/*
 * 然而，有时候你需要处理大量的数据，这会导致你的 UI 挂起。在 Flutter 中，使用 Isolate 来发挥多核心 CPU 的优势来处理那些长期运行或是计算密集型的任务。

Isolates 是分离的运行线程，并且不和主线程的内存堆共享内存。这意味着你不能访问主线程中的变量，或者使用 setState() 来更新 UI。正如它们的名字一样，Isolates 不能共享内存。

下面的例子展示了一个简单的 isolate，是如何把数据返回给主线程来更新 UI 的：

这里，dataLoader() 是一个运行于自己独立执行线程上的 Isolate。在 isolate 里，你可以执行 CPU 密集型任务（例如解析一个庞大的 json），或是计算密集型的数学操作，如加密或信号处理等。

你可以运行下面的完整例子：
 */

class SampleAppPageOne extends StatefulWidget {
  SampleAppPageOne({Key key}) : super(key: key);

  @override
  _SampleAppPageOneState createState() => _SampleAppPageOneState();
}

class _SampleAppPageOneState extends State<SampleAppPageOne> {
  List widgets = [];
  @override
  void initState() {
    super.initState();
    loadData();
  }

  showLoadingDialog() {
    if (widgets.length == 0) {
      return true;
    }
    return false;
  }

  getBody() {
    if (showLoadingDialog()) {
      return getProgressDialog();
    } else {
      return getListView();
    }
  }

  getProgressDialog() {
    return Center(child: CircularProgressIndicator());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("线程和异步one")
      ),
      body: getBody(),
    );
  }

  ListView getListView() => ListView.builder(
    itemBuilder: (BuildContext context, int position){
      return getRow(position);
  });

  Widget getRow(int i) {
    return Padding(padding: EdgeInsets.all(10.0), child: Text("Row ${widgets[i]["title"]}"));
  }

  loadData() async {
    ReceivePort receivePort = ReceivePort();
    await Isolate.spawn(dataLoader, receivePort.sendPort);

    SendPort sendPort = await receivePort.first;

    List msg = await sendReceive(sendPort, "https://jsonplaceholder.typicode.com/posts");
    setState(() {
      widgets = msg;
    });
  }

  static dataLoader(SendPort sendPort)async {
    ReceivePort receivePort = ReceivePort();
    sendPort.send(receivePort.sendPort);

    await for (var msg in receivePort) {
      String data = msg[0];
      SendPort replyTo = msg[1];

      String dataURL = data;
      http.Response response = await http.get(dataURL);

      replyTo.send(json.decode(response.body));
    }
  }

  Future sendReceive(SendPort port, msg) {
    ReceivePort response = ReceivePort();
    port.send([msg, response.sendPort]);
    return response.first;
  }

}

