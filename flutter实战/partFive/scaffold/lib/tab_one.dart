/*
 * @Author: Cao Shixin
 * @Date: 2020-06-19 18:29:55
 * @LastEditors: Cao Shixin
 * @LastEditTime: 2020-06-19 18:31:48
 * @Description: 
 * @Email: cao_shixin@yahoo.com
 * @Company: BrainCo
 */ 
import 'package:flutter/material.dart';

class TabOne extends StatefulWidget {
  TabOne({Key key}) : super(key: key);

  @override
  _TabOneState createState() => _TabOneState();
}

class _TabOneState extends State<TabOne> {
  @override
  Widget build(BuildContext context) {
    return Container(
       child: Text('tabOne'),
    );
  }
}