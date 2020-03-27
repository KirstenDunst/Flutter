import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_chart/chart/chart_bean_focus.dart';
import 'base_painter.dart';

class ChartLineFocusPainter extends BasePainter {
  List<ChartBeanFocus> chartBeans;
  Color xyColor; //xy轴的颜色
  static const double basePadding = 16; //默认的边距
  static const double overPadding = 0; //多出最大的极值额外的线长
  List<double> maxMin = [100, 0]; //存储极值
  bool isShowYValue; //是否显示y轴数值
  bool isShowHintX, isShowHintY; //x、y轴的辅助线
  FocusXYValues focusXYValues;//处理xy的坐标显示
  double fontSize; //坐标轴刻度字体size
  Color fontColor; //坐标轴刻度字体颜色
  double rulerWidth; //坐标轴的宽度或者高度
  Color lineColor; //曲线或折线的颜色
  double lineWidth; //绘制的线宽
  double startX, endX, startY, endY;
  double fixedHeight, fixedWidth; //坐标可容纳的宽高

  Path path;
  List<ShadowSub> shadowPaths = []; //小区域渐变色显示操作
  VoidCallback canvasEnd;

  static const Color defaultColor = Colors.deepPurple;
  
  ChartLineFocusPainter(
    this.chartBeans,
    this.lineColor, {
    this.isShowYValue = true,
    this.focusXYValues,
    this.isShowHintX = false,
    this.isShowHintY = false,
    this.rulerWidth = 8,
    this.xyColor = defaultColor,
    this.fontSize = 10,
    this.fontColor = defaultColor,
    this.lineWidth = 4,
    this.canvasEnd,
  });

  @override
  void paint(Canvas canvas, Size size) {
    _init(size);
    _drawXy(canvas, size); //坐标轴
    _calculatePath(size);
    _drawLine(canvas, size); //曲线或折线
  }

  @override
  bool shouldRepaint(ChartLineFocusPainter oldDelegate) {
    return true;
  }

  ///初始化
  void _init(Size size) {
    initValue();
    initBorder(size);
  }

  void initValue() {
    if (xyColor == null) {
      xyColor = defaultColor;
    }
    if (fontColor == null) {
      fontColor = defaultColor;
    }
    if (fontSize == null) {
      fontSize = 10;
    }
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

  ///x,y轴
  void _drawXy(Canvas canvas, Size size) {
    var paint = Paint()
      ..isAntiAlias = true
      ..strokeWidth = 1
      ..strokeCap = StrokeCap.round
      ..color = xyColor
      ..style = PaintingStyle.stroke;

    canvas.drawLine(
        Offset(startX, startY), Offset(endX + overPadding, startY), paint); //x轴
    canvas.drawLine(
        Offset(startX, startY), Offset(startX, endY - overPadding), paint); //y轴

    drawRuler(canvas, paint); //刻度
  }

  ///x,y轴刻度 & 辅助线
  void drawRuler(Canvas canvas, Paint paint) {
    int length = focusXYValues.xValues.length;
    double dw = fixedWidth / (length - 1); //两个点之间的x方向距离
    for (int i = 0; i < length; i++) {
      ///绘制x轴文本
      TextPainter(
          textAlign: TextAlign.center,
          ellipsis: '.',
          text: TextSpan(
              text: focusXYValues.xValues[i],
              style: TextStyle(color: fontColor, fontSize: fontSize)),
          textDirection: TextDirection.ltr)
        ..layout(minWidth: 40, maxWidth: 40)
        ..paint(canvas, Offset(startX + dw * i - 20, startY + basePadding));

      if (isShowHintY) {
        ///y轴辅助线
        canvas.drawLine(
            Offset(startX + dw * i, startY),
            Offset(startX + dw * i, endY - overPadding),
            paint..color = Colors.grey.withOpacity(0.5));
      }
      // ///x轴刻度
      // canvas.drawLine(Offset(startX + dw * i, startY),
      //     Offset(startX + dw * i, startY - rulerWidth), paint..color = xyColor);
    }
    for (int i = 0; i < focusXYValues.yValues.length; i++) {
      if (isShowYValue) {
        ///绘制y轴文本
        var yValue = focusXYValues.yValues[i].toStringAsFixed(0);
        var yLength = focusXYValues.yValues[i] / maxMin[0] * fixedHeight;
        var subLength = (focusXYValues.yValues[i] - (i > 0 ? focusXYValues.yValues[i-1] : 0)) / 2 / maxMin[0] * fixedHeight;
        TextPainter(
            textAlign: TextAlign.center,
            ellipsis: '.',
            maxLines: 1,
            text: TextSpan(
                text: '$yValue',
                style: TextStyle(color: fontColor, fontSize: fontSize)),
            textDirection: TextDirection.rtl)
          ..layout(minWidth: 40, maxWidth: 40)
          ..paint(canvas, Offset(startX - 40, startY - yLength - fontSize / 2));

        TextPainter(
            textAlign: TextAlign.center,
            ellipsis: '.',
            maxLines: 1,
            text: TextSpan(
                text: focusXYValues.yTexts[i],
                style: TextStyle(color: focusXYValues.yTextColors[i], fontSize: fontSize)),
            textDirection: TextDirection.rtl)
          ..layout(minWidth: 40, maxWidth: 40)
          ..paint(canvas,
              Offset(startX - 40, startY - yLength - fontSize / 2 + subLength));

        if (isShowHintX) {
          ///x轴辅助线
          canvas.drawLine(
              Offset(startX, startY - yLength),
              Offset(endX + overPadding, startY - yLength),
              paint..color = Colors.grey.withOpacity(0.5));
        }
        // ///y轴刻度
        // canvas.drawLine(Offset(startX, startY - yLength),
        //   Offset(startX + rulerWidth, startY - yLength), paint..color = xyColor);
      }
    }
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
        double W = (1 / (focusXYValues.xMaxMinutes * 60)) * fixedWidth; //x轴距离
        //用来控制中间过度线条的大小。
        double gradualStep = W / 4;
        double stepBegainX = startX;
        for (int i = 0; i < chartBeans.length; i++) {
          if (i == 0) {
            var value =
                (startY - chartBeans[i].focus / maxMin[0] * fixedHeight);
            path.moveTo(currentX, value);
            oldShadowPath.lineTo(currentX, value);
            oldShadowPath.lineTo(currentX+gradualStep, value);
            continue;
          }
          currentX += W;
          if (currentX > (fixedWidth + startX)) {
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
            if (chartBeans[i - 1].focus > chartBeans[i].focus) {
              oldShadowPath.cubicTo((preX + currentX) / 2, preY, (preX + currentX) / 2, currentY, currentX - gradualStep, currentY);
              oldShadowPath
                ..lineTo(currentX - gradualStep, startY)
                ..lineTo(stepBegainX, startY)
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
            stepBegainX = currentX;
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
  //矩形的渐变色
  Shader rectGradient;

  ShadowSub({this.focusPath, this.rectGradient});
}

