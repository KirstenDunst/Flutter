import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_chart/chart/bean/chart_bean.dart';

class BasePainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    // TODO: implement paint
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    // TODO: implement shouldRepaint
    return true;
  }

  ///计算极值 最大值,最小值
  List<double> calculateMaxMin(List<ChartBean> chatBeans) {
    if (chatBeans == null || chatBeans.length == 0) return [0, 0];
    double maxY = 0.0, minY= 0.0;
    for (ChartBean bean in chatBeans) {
      if (maxY < max(bean.y, bean.subY) ) {
        maxY = max(bean.y, bean.subY);
      }
      if (minY > min(bean.y, bean.subY)) {
        minY = min(bean.y, bean.subY);
      }
    }
    return [maxY, minY];
  }
}
