import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_chart/chart/chart_bean_focus.dart';
import 'base_painter.dart';

class ChartLineFocusPainter extends BasePainter {
  List<ChartBeanFocus> chartBeans;
  Color lineColor; //曲线或折线的颜色
  static const double basePadding = 16; //默认的边距
  static const double overPadding = 0; //多出最大的极值额外的线长
  int maxXMinutes; //最大时间，默认25分钟
  List<double> maxMin = [100, 0]; //存储极值
  double lineWidth; //绘制的线宽
  double startX, endX, startY, endY;
  double fixedHeight, fixedWidth; //坐标可容纳的宽高

  Path path;
  List<ShadowSub> shadowPaths = []; //小区域渐变色显示操作

  static const Color defaultColor = Colors.deepPurple;
  VoidCallback canvasEnd;

  ChartLineFocusPainter(
    this.chartBeans,
    this.lineColor, {
    this.lineWidth = 4,
    this.maxMin,
    this.maxXMinutes = 25,
    this.canvasEnd,
  });

  @override
  void paint(Canvas canvas, Size size) {
    initBorder(size);
    _calculatePath(size);
    _drawLine(canvas, size); //曲线或折线
  }

  ///计算边界
  void initBorder(Size size) {
    startX = basePadding * 2.5;
    // yNum > 0 ? basePadding * 2.5 : basePadding * 2; //预留出y轴刻度值所占的空间
    endX = size.width - basePadding * 2;
    startY = size.height - basePadding * 3;
    endY = basePadding * 2;
    fixedHeight = startY - endY;
    fixedWidth = endX - startX;
  }

  @override
  bool shouldRepaint(ChartLineFocusPainter oldDelegate) {
    return true;
  }

  ///计算Path
  void _calculatePath(Size size) {
    if (path == null) {
      if (chartBeans != null && chartBeans.length > 0) {
        shadowPaths.clear();
        path = Path();
        double preX, preY, currentX = startX, currentY, oldX = startX;
        Path oldShadowPath = Path();
        oldShadowPath.moveTo(currentX, startY);

        //折线轨迹,每个元素都是1秒的存在期
        double W = (1 / (maxXMinutes * 60)) * fixedWidth; //x轴距离
        //用来控制中间过度线条的大小。
        double gradualStep = W / 4;
        double stepBegainX = startX;
        for (int i = 0; i < chartBeans.length; i++) {
          if (i == 0) {
            var value =
                (startY - chartBeans[i].focus / maxMin[0] * fixedHeight);
            path.moveTo(currentX, value);
            continue;
          }
          currentX += W;
          if (currentX >= (fixedWidth + startX)) {
            // 绘制结束
            this.canvasEnd();
            break;
          }
          preX = oldX;

          preY = (startY - chartBeans[i - 1].focus / maxMin[0] * fixedHeight);
          currentY = (startY - chartBeans[i].focus / maxMin[0] * fixedHeight);

          //曲线连接轨迹
          path.cubicTo((preX + currentX) / 2, preY, (preX + currentX) / 2,
              currentY, currentX, currentY);
          //直线连接轨迹
          // path.lineTo(currentX, currentY);

          //阴影轨迹
          if (chartBeans[i - 1].focusState == chartBeans[i].focusState) {
            oldShadowPath.cubicTo((preX + currentX) / 2, preY, (preX + currentX) / 2,
              currentY, currentX - gradualStep, currentY);
            oldShadowPath.lineTo(currentX + gradualStep, currentY);
          } else {
            Path shadowPath = new Path();
            stepBegainX = preX;
            if (chartBeans[i - 1].focus > chartBeans[i].focus) {
              oldShadowPath.cubicTo((preX + currentX) / 2, preY, (preX + currentX) / 2, currentY, currentX - gradualStep, currentY);
              oldShadowPath
                ..lineTo(currentX - gradualStep, startY)
                ..lineTo(preX, startY)
                ..close();

              shadowPath.moveTo(currentX, startY);
              shadowPath.lineTo(currentX - gradualStep, startY);
              shadowPath.lineTo(currentX - gradualStep, currentY);
            } else {
              oldShadowPath
                ..lineTo(preX + gradualStep,startY)
                ..lineTo(preX, startY)
                ..close();

              shadowPath.moveTo(currentX, startY);
              shadowPath.lineTo(preX + gradualStep, startY);
              shadowPath.lineTo(preX + gradualStep, preY);
              shadowPath.cubicTo((preX + currentX) / 2, preY, (preX + currentX) / 2,
                currentY, currentX - gradualStep, currentY);
            }
            shadowPath.lineTo(currentX + gradualStep, currentY);
            oldShadowPath = shadowPath;

            shadowPaths.add(new ShadowSub(focusPath: oldShadowPath, rectGradient: _shader(i, stepBegainX, currentX)));
          }
          oldX = currentX;
        }
        oldShadowPath
              ..lineTo(currentX + W/4, startY)
              ..lineTo(currentX, startY)
              ..close();
        shadowPaths.add(new ShadowSub(focusPath: oldShadowPath, rectGradient: _shader(chartBeans.length-1, stepBegainX, currentX)));
      }
    }
  }

  Shader _shader(int index, double preX, double currentX) {
    double height = 0;
    switch (chartBeans[index].focusState) {
      case FocusState.FocusStateHigh:
        height = startY + fixedHeight;
        break;
      case FocusState.FocusStateMid:
        height = startY + 65/100 * fixedHeight;
        break;
      case FocusState.FocusStateLow:
        height = startY + 35/100 * fixedHeight;
        break;
      default:
        height = startY + 35/100 * fixedHeight;
    }
    //属于该专注力的固定小方块
    Rect rectFocus = Rect.fromLTRB(
              preX , height, currentX, startY);
    return LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  tileMode: TileMode.mirror,
                  colors: chartBeans[index].gradualColors)
              .createShader(rectFocus);
  }

  ///曲线或折线
  void _drawLine(Canvas canvas, Size size) {
    if (chartBeans == null || chartBeans.length == 0) return;
    var paint = Paint()
      ..isAntiAlias = true
      ..strokeWidth = lineWidth
      ..strokeCap = StrokeCap.round
      ..color = lineColor
      ..style = PaintingStyle.stroke;

    if (maxMin[0] <= 0) return;
    for (var sub in shadowPaths) {
      canvas
        ..drawPath(
            sub.focusPath,
            new Paint()
              ..shader = sub.rectGradient
              ..isAntiAlias = true
              ..style = PaintingStyle.fill);
    }

    ///先画阴影再画曲线，目的是防止阴影覆盖曲线
    canvas.drawPath(path, paint);
  }
}

class ShadowSub {
  //标准小专注矩形
  Path focusPath;
  // //小矩形两侧的弧度剪切
  // double rectRedius;
  //矩形的渐变色
  Shader rectGradient;

  ShadowSub(
      {this.focusPath,
      // this.rectRedius,
      this.rectGradient});
}
