
import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_chart/chart/chart_bean_focus.dart';
import 'package:flutter_chart/chart/view/chart_line_focus.dart';

import 'chart/chart_bean.dart';
import 'chart/chart_pie_bean.dart';
import 'chart/view/chart_bar.dart';
import 'chart/view/chart_line.dart';
import 'chart/view/chart_pie.dart';

//how to use chart
class Example extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      //手动关闭debug角标
      // debugShowCheckedModeBanner: false,
      home: AnnotatedRegion(
        child: ExampleChart(), 
        value: SystemUiOverlayStyle.light.copyWith(statusBarBrightness: Brightness.dark),
      ),
    );
  }
}

class ExampleChart extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ListView(
      physics: BouncingScrollPhysics(),
      children: <Widget>[
        _buildFocusChartLine(context),
        // _buildChartBarCircle(context),
        // _buildChartBarRound(context),
        // _buildChartCurve(context),
        // _buildChartLine(context),
        // _buildChartPie(context),
      ],
    );
  }

  ///curve
  Widget _buildChartCurve(context) {
    var chartLine = ChartLine(
      chartBeans: [
        ChartBean(x: '12-01', y: 30),
        ChartBean(x: '12-02', y: 88),
        ChartBean(x: '12-03', y: 20),
        ChartBean(x: '12-04', y: 67),
        ChartBean(x: '12-05', y: 10),
        ChartBean(x: '12-06', y: 40),
        ChartBean(x: '12-07', y: 10),
      ],
      size: Size(MediaQuery.of(context).size.width,
          MediaQuery.of(context).size.height / 5 * 1.6),
      isCurve: true,
      lineWidth: 4,
      lineColor: Colors.blueAccent,
      fontColor: Colors.white,
      xyColor: Colors.white,
      shaderColors: [
        Colors.blueAccent.withOpacity(0.3),
        Colors.blueAccent.withOpacity(0.1)
      ],
      fontSize: 12,
      yNum: 8,
      isAnimation: true,
      isReverse: false,
      isCanTouch: true,
      isShowPressedHintLine: true,
      pressedPointRadius: 4,
      pressedHintLineWidth: 0.5,
      pressedHintLineColor: Colors.white,
      duration: Duration(milliseconds: 2000),
    );
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      margin: EdgeInsets.only(left: 16, right: 16, top: 8, bottom: 8),
      semanticContainer: true,
      color: Colors.green.withOpacity(0.5),
      child: chartLine,
      clipBehavior: Clip.antiAlias,
    );
  }
  ///FocusLine
  Widget _buildFocusChartLine(context) {
    var chartLine = ChartLineFocus(
      chartBeans: [
        ChartBeanFocus(focus: 32, second: 0),
        ChartBeanFocus(focus: 62, second: 1),
        ChartBeanFocus(focus: 78, second: 2),
        ChartBeanFocus(focus: 62, second: 3),
        ChartBeanFocus(focus: 90, second: 4),
        ChartBeanFocus(focus: 100, second: 5),
        ChartBeanFocus(focus: 11, second: 6),
        ChartBeanFocus(focus: 55, second: 8),
        ChartBeanFocus(focus: 77, second: 9),
        ChartBeanFocus(focus: 62, second: 10),
        ChartBeanFocus(focus: 93, second: 11),
        ChartBeanFocus(focus: 62, second: 12),
        ChartBeanFocus(focus: 43, second: 13),
        ChartBeanFocus(focus: 22, second: 14),
        ChartBeanFocus(focus: 77, second: 15),
        ChartBeanFocus(focus: 88, second: 16),
        ChartBeanFocus(focus: 87, second: 17),
        ChartBeanFocus(focus: 70, second: 18),
        ChartBeanFocus(focus: 60, second: 19),
        ChartBeanFocus(focus: 21, second: 20),
        ChartBeanFocus(focus: 22, second: 21),
        ChartBeanFocus(focus: 19, second: 22),
        ChartBeanFocus(focus: 15, second: 23),
        ChartBeanFocus(focus: 100, second: 24),
      ],
      size: Size(MediaQuery.of(context).size.width,
          MediaQuery.of(context).size.height / 5 * 1.6),
      isCurve: false,
      xNumValues: ["0","5'","10'","15'","20'","25'"],
      maxXMinutes: 25,
      lineWidth: 2,
      lineColor: Colors.red,
      fontColor: Colors.black,
      xyColor: Colors.black,
      shaderColors: [
        Colors.yellow.withOpacity(0.3),
        Colors.yellow.withOpacity(0.1)
      ],
      fontSize: 12,
      // yNum: 3,
      isAnimation: false,
      isReverse: false,
      isShowHintX: true,
      // isShowHintY: true,
      isShowPressedHintLine: true,
      pressedPointRadius: 4,
      pressedHintLineWidth: 0.5,
      pressedHintLineColor: Colors.white,
      duration: Duration(milliseconds: 2000),
    );
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      margin: EdgeInsets.only(left: 16, right: 16, top: 8, bottom: 8),
      semanticContainer: true,
      color: Colors.white,
      child: chartLine,
      clipBehavior: Clip.antiAlias,
    );
  }

  ///line
  Widget _buildChartLine(context) {
    var chartLine = ChartLine(
      chartBeans: [
        ChartBean(x: '12-01', y: 30),
        ChartBean(x: '12-02', y: 88),
        ChartBean(x: '12-03', y: 20),
        ChartBean(x: '12-04', y: 67),
        ChartBean(x: '12-05', y: 10),
        ChartBean(x: '12-06', y: 40),
        ChartBean(x: '12-07', y: 10),
      ],
      size: Size(MediaQuery.of(context).size.width,
          MediaQuery.of(context).size.height / 5 * 1.6),
      isCurve: false,
      lineWidth: 2,
      lineColor: Colors.yellow,
      fontColor: Colors.white,
      xyColor: Colors.white,
      shaderColors: [
        Colors.yellow.withOpacity(0.3),
        Colors.yellow.withOpacity(0.1)
      ],
      fontSize: 12,
      yNum: 8,
      isAnimation: true,
      isReverse: false,
      isCanTouch: true,
      isShowPressedHintLine: true,
      pressedPointRadius: 4,
      pressedHintLineWidth: 0.5,
      pressedHintLineColor: Colors.white,
      duration: Duration(milliseconds: 2000),
    );
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      margin: EdgeInsets.only(left: 16, right: 16, top: 8, bottom: 8),
      semanticContainer: true,
      color: Colors.yellow.withOpacity(0.4),
      child: chartLine,
      clipBehavior: Clip.antiAlias,
    );
  }

  ///bar-circle
  Widget _buildChartBarCircle(context) {
    var chartBar = ChartBar(
      chartBeans: [
        ChartBean(x: '12-01', y: 30, color: Colors.red),
        ChartBean(x: '12-02', y: 100, color: Colors.yellow),
        ChartBean(x: '12-03', y: 70, color: Colors.green),
        ChartBean(x: '12-04', y: 70, color: Colors.blue),
        ChartBean(x: '12-05', y: 30, color: Colors.deepPurple),
        ChartBean(x: '12-06', y: 90, color: Colors.deepOrange),
        ChartBean(x: '12-07', y: 50, color: Colors.greenAccent)
      ],
      size: Size(MediaQuery.of(context).size.width,
          MediaQuery.of(context).size.height / 5 * 1.8),
      rectColor: Colors.deepPurple,
      isShowX: true,
      fontColor: Colors.white,
      rectShadowColor: Colors.white.withOpacity(0.5),
      isReverse: false,
      isCanTouch: true,
      isShowTouchShadow: true,
      isShowTouchValue: true,
      rectRadiusTopLeft: 50,
      rectRadiusTopRight: 50,
      duration: Duration(milliseconds: 1000),
    );
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      margin: EdgeInsets.only(left: 16, right: 16, top: 8, bottom: 8),
      semanticContainer: true,
      color: Colors.blue.withOpacity(0.4),
      child: chartBar,
      clipBehavior: Clip.antiAlias,
    );
  }

  ///bar-round
  Widget _buildChartBarRound(context) {
    var chartBar = ChartBar(
      chartBeans: [
        ChartBean(x: '12-01', y: 30, color: Colors.red),
        ChartBean(x: '12-02', y: 100, color: Colors.deepOrange),
        ChartBean(x: '12-03', y: 70, color: Colors.yellow),
        ChartBean(x: '12-04', y: 70, color: Colors.green),
        ChartBean(x: '12-05', y: 30, color: Colors.greenAccent),
        ChartBean(x: '12-06', y: 90, color: Colors.blue),
        ChartBean(x: '12-07', y: 50, color: Colors.deepPurple)
      ],
      size: Size(MediaQuery.of(context).size.width,
          MediaQuery.of(context).size.height / 5 * 1.8),
      rectColor: Colors.deepPurple,
      isShowX: true,
      fontColor: Colors.white,
      rectShadowColor: Colors.white.withOpacity(0.5),
      isReverse: false,
      isCanTouch: true,
      isShowTouchShadow: true,
      isShowTouchValue: true,
      rectRadiusTopLeft: 4,
      rectRadiusTopRight: 4,
      duration: Duration(milliseconds: 1000),
    );
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      margin: EdgeInsets.only(left: 16, right: 16, top: 8, bottom: 8),
      semanticContainer: true,
      color: Colors.brown.withOpacity(0.6),
      child: chartBar,
      clipBehavior: Clip.antiAlias,
    );
  }

  ///pie
  Widget _buildChartPie(context) {
    var chartPie = ChartPie(
      chartBeans: [
        ChartPieBean(type: '话费', value: 30, color: Colors.blueGrey),
        ChartPieBean(type: '零食', value: 120, color: Colors.deepPurple),
        ChartPieBean(type: '衣服', value: 60, color: Colors.green),
        ChartPieBean(type: '早餐', value: 60, color: Colors.blue),
        ChartPieBean(type: '水果', value: 30, color: Colors.red),
      ],
      size: Size(
          MediaQuery.of(context).size.width, MediaQuery.of(context).size.width),
      R: MediaQuery.of(context).size.width / 3,
      centerR: 6,
      duration: Duration(milliseconds: 2000),
      centerColor: Colors.white,
      fontColor: Colors.white,
    );
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      margin: EdgeInsets.only(left: 16, right: 16, top: 8, bottom: 8),
      color: Colors.orangeAccent.withOpacity(0.6),
      clipBehavior: Clip.antiAlias,
      borderOnForeground: true,
      child: chartPie,
    );
  }
}