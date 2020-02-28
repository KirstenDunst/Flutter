/*
 * @Author: Cao Shixin
 * @Date: 2020-02-28 14:42:44
 * @LastEditors: Cao Shixin
 * @LastEditTime: 2020-02-28 14:58:53
 * @Description: 和硬件、第三方服务以及平台交互
 */

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class PlatformInteraction extends StatelessWidget {
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

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(vsync: this);
  }

  @override
  void dispose() {
    super.dispose();
    _controller.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('和硬件、第三方服务以及平台交互')
      ),
      body: Center(
        child: Text('https://flutterchina.club/flutter-for-ios/#%E6%88%91%E6%80%8E%E4%B9%88%E6%8E%A8%E9%80%81%E9%80%9A%E7%9F%A5'),
      )
    );
  }
  
  /**
   * Flutter 的代码并不直接在平台之下运行，相反，Dart 代码构建的 Flutter 应用在设备上以原生的方式运行，却“侧步躲开了”平台提供的 SDK。这意味着，例如，你在 Dart 中发起一个网络请求，它就直接在 Dart 的上下文中运行。你并不会用上平常在 iOS 或 Android 上使用的原生 API。你的 Flutter 程序仍然被原生平台的 ViewController 管理作一个 view，但是你并不会直接访问 ViewController 自身，或是原生框架。

但这并不意味着 Flutter 不能和原生 API，或任何你编写的原生代码交互。Flutter 提供了 platform channels ，来和管理你的 Flutter view 的 ViewController 通信和交互数据。平台管道本质上是一个异步通信机制，桥接了 Dart 代码和宿主 ViewController，以及它运行于的 iOS 框架。你可以用平台管道来执行一个原生的函数，或者是从设备的传感器中获取数据。

除了直接使用平台管道之外，你还可以使用一系列预先制作好的 plugins。例如，你可以直接使用插件来访问相机胶卷或是设备的摄像头，而不必编写你自己的集成层代码。你可以在 Pub 上找到插件，这是一个 Dart 和 Flutter 的开源包仓库。其中一些包可能会支持集成 iOS 或 Android，或两者均可。

如果你在 Pub 上找不到符合你需求的插件，你可以自己编写 ，并且发布在 Pub 上。

我怎么访问 GPS 传感器？
使用 location 社区插件。

我怎么访问摄像头？
image_picker 在访问摄像头时非常常用。

我怎么登录 Facebook？
登录 Facebook 可以使用 flutter_facebook_login 社区插件。

我怎么使用 Firebase 特性？
大多数 Firebase 特性被  first party plugins 包含了。这些第一方插件由 Flutter 团队维护：

firebase_admob for Firebase AdMob
firebase_analytics for Firebase Analytics
firebase_auth for Firebase Auth
firebase_core for Firebase’s Core package
firebase_database for Firebase RTDB
firebase_storage for Firebase Cloud Storage
firebase_messaging for Firebase Messaging (FCM)
cloud_firestore for Firebase Cloud Firestore
你也可以在 Pub 上找到 Firebase 的第三方插件。

我怎创建自己的原生集成层？
如果有一些 Flutter 和社区插件遗漏的平台相关的特性，可以根据  developing packages and plugins 页面构建自己的插件。

Flutter 的插件结构，简要来说，就像 Android 中的 Event bus。你发送一个消息，并让接受者处理并反馈结果给你。在这种情况下，接受者就是在 Android 或 iOS 上的原生代码。

数据库和本地存储
我怎么在 Flutter 中访问 UserDefaults？
在 iOS 中，你可以使用属性列表来存储键值对的集合，即我们熟悉的 UserDefaults。

在 Flutter 中，可以使用  Shared Preferences plugin 来达到相似的功能。它包裹了 UserDefaluts 以及 Android 上等价的 SharedPreferences 的功能。

CoreData 相当于 Flutter 中的什么？
在 iOS 中，你通过 CoreData 来存储结构化的数据。这是一个 SQL 数据库的上层封装，让查询和关联模型变得更加简单。

在 Flutter 中，使用 SQFlite 插件来实现这个功能。

通知
我怎么推送通知？
在 iOS 中，你需要向苹果开发者平台中注册来允许推送通知。

在 Flutter 中，使用 firebase_messaging 插件来实现这一功能。

更多使用 Firebase Cloud Messaging API 的信息，请参阅 firebase_messaging 插件文档。
   */
}
