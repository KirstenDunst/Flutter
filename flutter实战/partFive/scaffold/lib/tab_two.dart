/*
 * @Author: Cao Shixin
 * @Date: 2020-06-19 18:30:49
 * @LastEditors: Cao Shixin
 * @LastEditTime: 2020-06-19 18:30:50
 * @Description: 
 * @Email: cao_shixin@yahoo.com
 * @Company: BrainCo
 */ 
import 'package:flutter/material.dart';

class TabTwo extends StatefulWidget {
  TabTwo({Key key}) : super(key: key);

  @override
  _TabOneState createState() => _TabOneState();
}

class _TabOneState extends State<TabTwo> {
  @override
  Widget build(BuildContext context) {
    return Container(
       child: Text('TabTwo'),
    );
  }
}