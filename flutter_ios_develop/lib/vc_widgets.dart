/*
 * @Author: Cao Shixin
 * @Date: 2020-02-28 10:52:49
 * @LastEditors: Cao Shixin
 * @LastEditTime: 2020-02-28 10:57:06
 * @Description: ViewController 相当于 Flutter 中的什么？,怎么监听 iOS 中的生命周期事件？
 */

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class VCWidgets extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SampleApp();
  }
}

class SampleApp extends StatefulWidget {
  SampleApp({Key key}) : super(key: key);

  @override
  _SampleAppState createState() => _SampleAppState();
}
/*
 * ViewController 相当于 Flutter 中的什么？
在 iOS 中，一个 ViewController 代表了用户界面的一部分，最常用于一个屏幕，或是其中一部分。
它们被组合在一起用于构建复杂的用户界面，并帮助你拆分 App 的 UI。在 Flutter 中，这一任务回落到了 widgets 中。
就像在界面导航部分提到的一样，一个屏幕也是被 widgets 来表示的，因为“万物皆 widget！”。
使用 Navigator 在 Route 之间跳转，或者渲染相同数据的不同状态。
 */
class _SampleAppState extends State<SampleApp> {
  @override
  Widget build(BuildContext context) {
    var scaffold = Scaffold(
      appBar:  AppBar(
        title: Text("VC相当于 Flutter 中的什么"),
      ),
      body: Text("监听 iOS 中的生命周期事件")
    );
    return scaffold;
  }
}

/**
 * 监听 iOS 中的生命周期事件？
在 iOS 中，你可以重写 ViewController 中的方法来捕获它的视图的生命周期，或者在 AppDelegate 中注册生命周期的回调函数。
在 Flutter 中没有这两个概念，但你可以通过 hook WidgetsBinding 观察者来监听生命周期事件，
并监听 didChangeAppLifecycleState() 的变化事件。

可观察的生命周期事件有：

inactive - 应用处于不活跃的状态，并且不会接受用户的输入。这个事件仅工作在 iOS 平台，在 Android 上没有等价的事件。
paused - 应用暂时对用户不可见，虽然不接受用户输入，但是是在后台运行的。
resumed - 应用可见，也响应用户的输入。
suspending - 应用暂时被挂起，在 iOS 上没有这一事件。
 */
