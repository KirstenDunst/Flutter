/*
 * @Author: Cao Shixin
 * @Date: 2020-06-19 18:30:58
 * @LastEditors: Cao Shixin
 * @LastEditTime: 2020-06-19 18:31:41
 * @Description: 
 * @Email: cao_shixin@yahoo.com
 * @Company: BrainCo
 */ 
import 'package:flutter/material.dart';

class TabThree extends StatefulWidget {
  TabThree({Key key}) : super(key: key);

  @override
  _TabOneState createState() => _TabOneState();
}

class _TabOneState extends State<TabThree> {
  @override
  Widget build(BuildContext context) {
    return Container(
       child: Text('TabThree'),
    );
  }
}