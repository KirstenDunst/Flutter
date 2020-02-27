/*
 * @Author       : Cao Shixin
 * @Date         : 2020-02-26 18:18:02
 * @LastEditors  : Cao Shixin
 * @LastEditTime : 2020-02-26 18:28:08
 * @Description  : 自定义widgets
 */

import 'package:flutter/material.dart';

class WidgetBySelf extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('自定义widgets'),
      ),
      body: Center(
       child: CustomButton("Hello"),
      ),
    );
  }
}






class CustomButton extends StatelessWidget {
  final String label;

  CustomButton(this.label);

  @override
  Widget build(BuildContext context) {
    return RaisedButton(onPressed:(){},child: Text(label));
  }
}


