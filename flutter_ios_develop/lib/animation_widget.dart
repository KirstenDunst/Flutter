/*
 * @Author       : Cao Shixin
 * @Date         : 2020-02-26 15:20:51
 * @LastEditors  : Cao Shixin
 * @LastEditTime : 2020-02-26 17:04:26
 * @Description  : 对 widget 做动画
 */
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class AnimationWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return  MyFadeTest();
  }
}

class MyFadeTest extends StatefulWidget {
  MyFadeTest({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _MyFadeTest createState() => _MyFadeTest();
}

class _MyFadeTest extends State<MyFadeTest> with TickerProviderStateMixin {
  AnimationController controller;
  CurvedAnimation curve;

  @override
  void initState() {
    super.initState();
    controller = AnimationController(vsync: this, duration: const Duration(milliseconds:2000));
    curve = CurvedAnimation(parent: controller, curve: Curves.easeIn);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('widget.title怎么使用'),
      ),
      body: Center(
        child: Container(
          child: FadeTransition(
            opacity: curve,
            child: FlutterLogo(
              size: 100.0,
            )
          )
        )
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: (){
        controller.forward();
        },
        tooltip: 'Fade',
        child: Icon(Icons.brush),
      ),
    );
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }
}
