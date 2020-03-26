import 'package:flutter/material.dart';
import 'package:flutter_chart/chart/chart_bean_focus.dart';
import 'package:flutter_chart/chart/painter/chart_line_focus_base_painter.dart';
import 'package:flutter_chart/chart/view/chart_line_focus_temp.dart';

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
  final int maxXMinutes; //最大时间，默认25分钟
  final List<String> xNumValues; //x坐标值显示
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
    this.maxXMinutes,
    this.xNumValues,
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
    bool canvasBase = true;
    ChartLineFocusBasePainter basePainter;
    CustomPaint basePaint;

    GlobalKey<ChartLineFocusTempState> next = GlobalKey();

  @override
  void initState() {
    super.initState();
    basePainter = ChartLineFocusBasePainter(
        fontSize: widget.fontSize,
        fontColor: widget.fontColor,
        xyColor: widget.xyColor,
        xNumValues: widget.xNumValues,
        maxXMinutes: widget.maxXMinutes,
        isShowYValue: widget.isShowYValue,
        isShowHintX: widget.isShowHintX,
        isShowHintY: widget.isShowHintY,
        rulerWidth: widget.rulerWidth);
    basePaint = CustomPaint(
            size: widget.size,
            painter: basePainter,
            foregroundPainter: null,
            child: Container(
                  width: widget.size.width,
                  height: widget.size.height,
                  color: widget.backgroundColor,
                ),
          );
  }

  @override
  Widget build(BuildContext context) {
    print("刷新12e4153452436346");
    var painter = ChartLineFocusTemp(key: next,
          size: Size(MediaQuery.of(context).size.width,
                MediaQuery.of(context).size.height / 5 * 1.6),
          lineWidth: 1,
          maxMin:basePainter.maxMin,
          backgroundColor: widget.backgroundColor,
          chartBeans: widget.chartBeans,
          lineColor: Colors.transparent,
          maxXMinutes: 1,
          canvasEnd: widget.canvasEnd,
        );
    return Stack(
        children: <Widget>[
          basePaint,
          painter,
        ],
      ); 
  }
}
