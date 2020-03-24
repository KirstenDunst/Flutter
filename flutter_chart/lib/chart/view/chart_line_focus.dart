import 'package:flutter/material.dart';
import 'package:flutter_chart/chart/chart_bean_focus.dart';
import 'package:flutter_chart/chart/painter/chart_line_focus_painter.dart';

class ChartLineFocus extends StatefulWidget {
  final Size size; //宽高
  final double lineWidth; //线宽
  final bool isCurve; //标记是否为曲线
  final List<ChartBeanFocus> chartBeans;
  final List<Color> shaderColors; //Line渐变色
  final Color lineColor; //曲线或折线的颜色
  final Color xyColor; //xy轴的颜色
  final Color backgroundColor; //绘制的背景色
  final bool isShowYValue; //是否显示y轴数值
  final bool isShowXy; //是否显示坐标轴
  final bool isShowXyRuler; //是否显示xy刻度
  final bool isShowHintX, isShowHintY; //x、y轴的辅助线
  final bool isShowBorderTop, isShowBorderRight; //顶部和右侧的辅助线
  final int maxXMinutes; //最大时间，默认25分钟
  final List<String> xNumValues; //x坐标值显示
  final bool isShowFloat; //y刻度值是否显示小数
  final double fontSize; //刻度文本大小
  final Color fontColor; //文本颜色
  final double rulerWidth; //刻度的宽度或者高度
  final Duration duration; //动画时长
  final bool isAnimation; //是否执行动画
  final bool isReverse; //是否重复执行动画
  final bool isShowPressedHintLine; //触摸时是否显示辅助线
  final double pressedPointRadius; //触摸点半径
  final double pressedHintLineWidth; //触摸辅助线宽度
  final Color pressedHintLineColor; //触摸辅助线颜色

  const ChartLineFocus({
    Key key,
    @required this.size,
    @required this.chartBeans,
    this.lineWidth = 4,
    this.isCurve = true,
    this.shaderColors,
    this.lineColor,
    this.xyColor,
    this.backgroundColor,
    this.isShowXy = true,
    this.isShowYValue = true,
    this.isShowXyRuler = true,
    this.isShowHintX = false,
    this.isShowHintY = false,
    this.isShowBorderTop = false,
    this.isShowBorderRight = false,
    // this.yNum,
    this.maxXMinutes,
    this.xNumValues,
    this.isShowFloat,
    this.fontSize,
    this.fontColor,
    this.rulerWidth = 8,
    this.duration = const Duration(milliseconds: 800),
    this.isAnimation = true,
    this.isReverse = false,
    this.isShowPressedHintLine = true,
    this.pressedPointRadius = 4,
    this.pressedHintLineWidth = 0.5,
    this.pressedHintLineColor,
  })  : assert(lineColor != null),
        assert(size != null),
        super(key: key);

  @override
  State<StatefulWidget> createState() => ChartLineFocusState();
}

class ChartLineFocusState extends State<ChartLineFocus>
    with SingleTickerProviderStateMixin {
  AnimationController _controller;
  double _value = 0;
  double begin = 0.0, end = 1.0;
  Offset globalPosition;

  @override
  void initState() {
    super.initState();
    if (widget.isAnimation) {
      _controller = AnimationController(vsync: this, duration: widget.duration);
      Tween(begin: begin, end: end).animate(_controller)
        ..addStatusListener((status) {
          if (status == AnimationStatus.completed) {
            if (widget.isReverse) {
              _controller.repeat(reverse: widget.isReverse);
            }
            print('绘制完成');
          }
        })
        ..addListener(() {
          _value = _controller.value;
          setState(() {});
        });
      _controller.forward();
    }
  }

  @override
  void dispose() {
    if (_controller != null) _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var painter = ChartLineFocusPainter(widget.chartBeans, widget.lineColor,
        isCurve: widget.isCurve,
        lineWidth: widget.lineWidth,
        fontSize: widget.fontSize,
        fontColor: widget.fontColor,
        xyColor: widget.xyColor,
        xNumValues: widget.xNumValues,
        maxXMinutes: widget.maxXMinutes,
        isShowYValue: widget.isShowYValue,
        isShowHintX: widget.isShowHintX,
        isShowHintY: widget.isShowHintY,
        rulerWidth: widget.rulerWidth,
        value: widget.isAnimation ? _value : 1);

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
