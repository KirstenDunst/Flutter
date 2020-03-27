import 'package:flutter/material.dart';
import 'package:flutter_chart/chart/util/color_utils.dart';

//专注力等级
enum FocusState {
  FocusStateLow,
  FocusStateMid,
  FocusStateHigh,
}

class ChartBeanFocus {
  //这个专注值开始的时间，以秒为单位
  // int second;
  double focus;

  FocusState get focusState {
    if (focus > 65) {
      return FocusState.FocusStateHigh;
    } else if (focus > 35) {
      return FocusState.FocusStateMid;
    } else {
      return FocusState.FocusStateLow;
    }
  }

  double get toneHeightRatio {
    switch (focusState) {
      case FocusState.FocusStateHigh:
        return 1;
        break;
      case FocusState.FocusStateMid:
        return 65/100;
        break;
      case FocusState.FocusStateHigh:
        return 35/100;
        break;
      default:
        return 35/100;
        break;
    }
  }

  List<Color> get gradualColors {
    switch (focusState) {
      case FocusState.FocusStateHigh:
        return [
          ColorsUtil.hexColor(0xF75E36),
          ColorsUtil.hexColor(0xF75E36).withOpacity(0.3)
        ];
        break;
      case FocusState.FocusStateMid:
        return [
          ColorsUtil.hexColor(0xFFC278),
          ColorsUtil.hexColor(0xFFC278).withOpacity(0.3)
        ];
        break;
      case FocusState.FocusStateHigh:
        return [
          ColorsUtil.hexColor(0x172B88),
          ColorsUtil.hexColor(0x172B88).withOpacity(0.3)
        ];
        break;
      default:
        return [
          ColorsUtil.hexColor(0x172B88),
          ColorsUtil.hexColor(0x172B88).withOpacity(0.3)
        ];
        break;
    }
  }

  ChartBeanFocus({@required this.focus});
}

class FocusXYValues {
  List<double> yValues = [35, 65, 100];
  List<String> yTexts = ["走神", "一般", "忘我"];
  List<Color> yTextColors = [
    ColorsUtil.hexColor(0x172B88),
    ColorsUtil.hexColor(0xFFC278),
    ColorsUtil.hexColor(0xF75E36)
  ];
  //x轴最大的时间
  int xMaxMinutes;

  List<String> get xValues {
    String sub = "'";
    int number;
    if (this.xMaxMinutes < 3) {
      number = this.xMaxMinutes * 60;
      sub = "\"";
      return _getXValues(number, [2, 3], sub);
    } else {
      number = this.xMaxMinutes;
      sub = "'";
      return _getXValues(number, [3, 6], sub);
    }
  }

  FocusXYValues(this.xMaxMinutes);

  
  List<String> _getXValues(int number, List<int> rangeList, String sub) {
    List<String> temp = ["0"];
    int startDivisor = rangeList.first;
    int endDivisor = rangeList.last;
    List<int> remainderList = [];
    int divisor = endDivisor;
    for (var i = startDivisor; i <= endDivisor; i++) {
      remainderList.add(number % i == 0 ? 0 :(i - (number % i)));
    }
    //获取差异最小的除数，倒着计算
    int minPass = remainderList.last;
    for (var i = remainderList.length-2; i >= 0 ; i--) {
      if (remainderList[i] < minPass) {
        divisor = endDivisor-(remainderList.length-1-i);
        minPass = remainderList[i];
      }
    }
    for (var i = 1; i <= divisor; i++) {
      var numb = (number+minPass)/divisor;
      var numberStr = (numb*i).toStringAsFixed(0);
      temp.add("$numberStr$sub");
    }
    //时长记录使用
    this.xMaxMinutes = sub != "\""? number+minPass : this.xMaxMinutes;
    //处理根据最大的x时间返回来返回的刻度表
    return temp;
  }
}
