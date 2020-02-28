/*
 * @Author: Cao Shixin
 * @Date: 2020-02-27 18:35:16
 * @LastEditors: Cao Shixin
 * @LastEditTime: 2020-02-28 10:52:01
 * @Description: 工程结构、本地化、依赖和资源
 */

import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

class LocalResource extends StatelessWidget {
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

class _SampleAppState extends State<SampleApp> {
  @override
  Widget build(BuildContext context) {
    var scaffold = Scaffold(
      // localizationsDelegates: [
      //   // Add app-specific localization delegate[s] here
      //   GlobalMaterialLocalizations.delegate,
      //   GlobalWidgetsLocalizations.delegate,
      //  ],
      // supportedLocales: [
      //   const Locale('en', 'US'), // English
      //   const Locale('he', 'IL'), // Hebrew
      //   // ... other locales the app supports
      // ],
 
      appBar:  AppBar(
        title: Text("本地化、依赖和资源"),
      ),
      body: Image.asset("assets/images/doubleTap.png"),
    );
    return scaffold;
  }
}





/*放置字符串？我怎么做本地化？不像 iOS 拥有一个 Localizable.strings 文件，Flutter 目前并没有一个用于处理字符串的系统。
目前，最佳实践是把你的文本拷贝到静态区，并在这里访问。例如：
*/
class Strings {
  static String welcoMeessage = "Welcome To Flutter";
}
//并且这样访问你的字符串：
//Text(Strings.welcomeMessage)


/**
 * 默认情况下，Flutter 只支持美式英语字符串。如果你要支持其他语言，请引入 flutter_localizations 包。
 * 你可能也要引入  intl 包来支持其他的 i10n 机制，比如日期/时间格式化。

dependencies:
  # ...
  flutter_localizations:
    sdk: flutter
  intl: "^0.15.6"
 */
/**
 * 要使用 flutter_localizations 包，还需要在 app widget 中指定 localizationsDelegates 和 supportedLocales。
 */


