import 'package:flutter/material.dart';
import 'package:flutter_chart/util/color_utils.dart';

//专注力等级
enum FocusState {
  FocusStateLow,
  FocusStateMid,
  FocusStateHigh,
}

class ChartBeanFocus {

  //这个专注值开始的时间，以秒为单位
  int second;
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

  List <Color> get gradualColors {
    switch (focusState) {
      case FocusState.FocusStateHigh:
        return [ColorsUtil.hexColor(0xF75E36), ColorsUtil.hexColor(0xF75E36).withOpacity(0.3)];
        break;
      case FocusState.FocusStateMid:
        return [ColorsUtil.hexColor(0xFFC278), ColorsUtil.hexColor(0xFFC278).withOpacity(0.3)];
        break;
      case FocusState.FocusStateHigh:
        return [ColorsUtil.hexColor(0x172B88), ColorsUtil.hexColor(0x172B88).withOpacity(0.3)];
        break;
      default:
        return [ColorsUtil.hexColor(0x172B88), ColorsUtil.hexColor(0x172B88).withOpacity(0.3)];
        break;
    }
  }

  ChartBeanFocus(
      {@required this.second, @required this.focus});


}
