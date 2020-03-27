import 'package:flutter/material.dart';
import 'package:flutter_chart/chart/bean/chart_bean_focus.dart';
import 'package:flutter_chart/chart/painter/chart_line_focus_painter.dart';

class ChartLineFocus extends StatefulWidget {
  final Size size; //宽高
  final double lineWidth; //线宽
  final List<ChartBeanFocus> chartBeans;
  final Color lineColor; //曲线或折线的颜色
  final Color xyColor; //xy轴的颜色
  final bool isShowYValue; //是否显示y轴数值
  final Color backgroundColor; //绘制的背景色
  final bool isShowHintX, isShowHintY; //x、y轴的辅助线
  final bool isShowBorderTop, isShowBorderRight; //顶部和右侧的辅助线
  final FocusXYValues focusXYValues;//处理xy的坐标显示
  final bool isShowFloat; //y刻度值是否显示小数
  final double fontSize; //刻度文本大小
  final Color fontColor; //文本颜色
  final double rulerWidth; //刻度的宽度或者高度
  final VoidCallback canvasEnd;

  const ChartLineFocus({
    Key key,
    @required this.size,
    @required this.chartBeans,
    @required this.canvasEnd,
    this.lineWidth = 4,
    this.lineColor,
    this.xyColor,
    this.backgroundColor,
    this.isShowYValue = true,
    this.isShowHintX = false,
    this.isShowHintY = false,
    this.isShowBorderTop = false,
    this.isShowBorderRight = false,
    this.focusXYValues,
    this.isShowFloat,
    this.fontSize,
    this.fontColor,
    this.rulerWidth = 8,
  })  : assert(lineColor != null),
        assert(size != null),
        super(key: key);

  @override
  ChartLineFocusState createState() => ChartLineFocusState();
}

class ChartLineFocusState extends State<ChartLineFocus>
    with SingleTickerProviderStateMixin {
  List<ChartBeanFocus> chartBeanList;
  
  void changeBeanList(List<ChartBeanFocus> beans) {
    setState(() {
      chartBeanList = beans;
    });
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var painter = ChartLineFocusPainter(chartBeanList, widget.lineColor,
        lineWidth: widget.lineWidth,
        focusXYValues: widget.focusXYValues,
        fontSize: widget.fontSize,
        fontColor: widget.fontColor,
        xyColor: widget.xyColor,
        isShowYValue: widget.isShowYValue,
        isShowHintX: widget.isShowHintX,
        isShowHintY: widget.isShowHintY,
        rulerWidth: widget.rulerWidth,
        canvasEnd: widget.canvasEnd);

    return CustomPaint(
        size: widget.size,
        painter: widget.backgroundColor == null ? painter : null,
        foregroundPainter: widget.backgroundColor != null ? painter : null,
        child: widget.backgroundColor != null
            ? Container(
                width: widget.size.width,
                height: widget.size.height,
                color: widget.backgroundColor,
              )
            : null,
      );
  }
}
