import 'package:flutter/material.dart';
import 'package:flutter_chart/chart/chart_bean_focus.dart';
import 'package:flutter_chart/chart/painter/chart_line_focus_painter.dart';

class ChartLineFocusTemp extends StatefulWidget {
  final Color backgroundColor;
  final Size size;
  final List<ChartBeanFocus> chartBeans;
  final Color lineColor; //曲线或折线的颜色
  final List<double> maxMin; //存储极值
  final int maxXMinutes; //最大时间，默认25分钟
  final double lineWidth; //绘制的线宽
  final double startX, endX, startY, endY;
  final double fixedHeight, fixedWidth; //坐标可容纳的宽高
  final VoidCallback canvasEnd;

  const ChartLineFocusTemp({
    Key key,
    @required this.size,
    @required this.chartBeans,
    @required this.canvasEnd,
    this.backgroundColor,
    this.lineColor, 
    this.maxMin,
    this.lineWidth = 4,
    this.startX,
    this.startY,
    this.endX,
    this.endY,
    this.fixedHeight,
    this.fixedWidth,
    this.maxXMinutes = 25,
  }) : assert(lineColor != null),
        assert(size != null),
        super(key: key);

  @override
  ChartLineFocusTempState createState() => ChartLineFocusTempState();
}

class ChartLineFocusTempState extends State<ChartLineFocusTemp>
    with SingleTickerProviderStateMixin {
    bool canvasBase = true;
    List<ChartBeanFocus> canvasBeans;

  void changeChartBeans(List<ChartBeanFocus> chartBeans) {
    setState(() {
      canvasBeans = chartBeans;
    });
  }

  @override
  Widget build(BuildContext context) {
    var painter = ChartLineFocusPainter(canvasBeans, widget.lineColor,
        lineWidth: widget.lineWidth,
        maxMin: widget.maxMin,
        maxXMinutes: widget.maxXMinutes,
        canvasEnd: widget.canvasEnd,
        );
    return CustomPaint(
          size: widget.size,
          painter: null,
          foregroundPainter: painter,
          child: Container(
                  width: widget.size.width,
                  height: widget.size.height,
                  color: widget.backgroundColor,
                ),
      );
  }
}
