import 'package:flutter/material.dart';
import 'package:flutter_chart/util/color_utils.dart';

class ChartBeanFocus {
  //这个专注值开始的时间，以秒为单位
  int second;
  double focus;
  //这个专注值的过程时间
  int timeDiff;
  List <Color> get gradualColors {
    if (focus > 65) {
      return [ColorsUtil.hexColor(0xF75E36), Colors.white];
    } else if (focus > 35) {
      return [ColorsUtil.hexColor(0xFFC278), Colors.white];
    } else {
      return [ColorsUtil.hexColor(0x172B88), Colors.white];
    }
  }

  ChartBeanFocus(
      {@required this.second, @required this.focus, this.timeDiff = 1});


}
