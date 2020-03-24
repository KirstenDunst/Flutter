import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_chart/chart/chart_bean_focus.dart';
import 'package:flutter_chart/util/color_utils.dart';

import 'base_painter.dart';

class ChartLineFocusPainter extends BasePainter {
  double value; //当前动画值
  List<ChartBeanFocus> chartBeans;
  Color lineColor; //曲线或折线的颜色
  Color xyColor; //xy轴的颜色
  static const double basePadding = 16; //默认的边距
  static const double overPadding = 0; //多出最大的极值额外的线长
  List<double> maxMin = [100, 0]; //存储极值
  bool isCurve; //是否为曲线
  bool isShowYValue; //是否显示y轴数值
  bool isShowHintX, isShowHintY; //x、y轴的辅助线
  int maxXMinutes; //最大时间，默认25分钟
  List<String> xNumValues; //x坐标值显示数组
  double fontSize; //坐标轴刻度字体size
  Color fontColor; //坐标轴刻度字体颜色
  double lineWidth; //绘制的线宽
  double rulerWidth; //坐标轴的宽度或者高度
  double startX, endX, startY, endY;
  double _fixedHeight, _fixedWidth; //坐标可容纳的宽高
  Path path;
  //小区域渐变色显示操作
  List<ShadowSub> shadowPaths = [];

  bool _isAnimationEnd = false;

  static const Color defaultColor = Colors.deepPurple;

  ChartLineFocusPainter(
    this.chartBeans,
    this.lineColor, {
    this.lineWidth = 4,
    this.value = 1,
    this.isCurve = true,
    this.isShowYValue = true,
    this.isShowHintX = false,
    this.isShowHintY = false,
    this.rulerWidth = 8,
    this.xyColor = defaultColor,
    this.maxXMinutes = 25,
    this.xNumValues,
    this.fontSize = 10,
    this.fontColor = defaultColor,
  });

  @override
  void paint(Canvas canvas, Size size) {
    _init(size);
    _drawXy(canvas, size); //坐标轴
    _drawLine(canvas, size); //曲线或折线
  }

  @override
  bool shouldRepaint(ChartLineFocusPainter oldDelegate) {
    _isAnimationEnd = oldDelegate.value == value;
    return oldDelegate.value != value;
  }

  ///初始化
  void _init(Size size) {
    initValue();
    initBorder(size);
    initPath(size);
  }

  void initValue() {
    if (lineColor == null) {
      lineColor = defaultColor;
    }
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
    _fixedHeight = startY - endY;
    _fixedWidth = endX - startX;
  }

  ///计算Path
  void initPath(Size size) {
    if (path == null) {
      if (chartBeans != null && chartBeans.length > 0) {
        path = Path();
        double preX, preY, currentX, currentY, oldX = startX;
        // chartBeans.length > 7 ? 7 : chartBeans.length;
        for (int i = 0; i < chartBeans.length; i++) {
          //折线轨迹
          double W = (chartBeans[i].timeDiff / (maxXMinutes * 60)) *
              _fixedWidth; //x轴距离
          if (i == 0) {
            currentX = startX;
            var value =
                (startY - chartBeans[i].focus / maxMin[0] * _fixedHeight);
            path.moveTo(currentX, value);
            continue;
          }
          currentX += W;
          preX = oldX;

          preY = (startY - chartBeans[i - 1].focus / maxMin[0] * _fixedHeight);
          currentY = (startY - chartBeans[i].focus / maxMin[0] * _fixedHeight);

          oldX = currentX;

          if (isCurve) {
            path.cubicTo((preX + currentX) / 2, preY, (preX + currentX) / 2,
                currentY, currentX, currentY);
          } else {
            path.lineTo(currentX, currentY);
          }

          //阴影轨迹

          double stepWidth = currentX - preX;
          //用来控制中间过度线条的大小。如果想看起来不怎么突兀，可以试试将这个改成：stepWidth/4
          double gradualStep = stepWidth / 8 * 3;
          //过度阴影
          Path shadowPath = new Path();
          shadowPath.moveTo(preX + gradualStep, startY);
          shadowPath.lineTo(preX + gradualStep, preY);
          shadowPath.cubicTo((preX + currentX) / 2, preY, (preX + currentX) / 2,
              currentY, currentX - gradualStep, currentY);
          //闭环
          shadowPath
            ..lineTo(currentX - gradualStep, startY)
            ..lineTo(preX + gradualStep, startY)
            ..close();
          //画阴影,注意LinearGradient这里需要指定方向，默认为从左到右
          var shader = LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  tileMode: TileMode.clamp,
                  colors: chartBeans[i - 1].focus > chartBeans[i].focus
                      ? chartBeans[i - 1].gradualColors
                      : chartBeans[i].gradualColors)
              .createShader(Rect.fromLTWH(preX + gradualStep, currentY,
                  stepWidth / 4, startY - currentY));

          //属于该专注力的固定小方块
          Rect rectFocus = Rect.fromLTRB(
              currentX - gradualStep, currentY, currentX + gradualStep, startY);
          var shader1 = LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  tileMode: TileMode.clamp,
                  colors: chartBeans[i].gradualColors)
              .createShader(rectFocus);

          shadowPaths.add(new ShadowSub(
              shadowPath: shadowPath,
              linearGradient: shader,
              focusRect: rectFocus,
              rectRedius: stepWidth / 2,
              rectGradient: shader1));
        }
      }
    }
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
    if (chartBeans != null && chartBeans.length > 0) {
      int length = xNumValues.length;
      double dw = _fixedWidth / (length - 1); //两个点之间的x方向距离
      for (int i = 0; i < length; i++) {
        ///绘制x轴文本
        TextPainter(
            textAlign: TextAlign.center,
            ellipsis: '.',
            text: TextSpan(
                text: xNumValues[i],
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
      List<double> showYArr = [35, 65, 100];
      List<String> focusGradeArr = ["走神", "一般", "忘我"];
      List<Color> focusColorArr = [
        ColorsUtil.hexColor(0x172B88),
        ColorsUtil.hexColor(0xFFC278),
        ColorsUtil.hexColor(0xF75E36)
      ];
      for (int i = 0; i < showYArr.length; i++) {
        if (isShowYValue) {
          ///绘制y轴文本
          var yValue = showYArr[i].toString();
          var yLength = showYArr[i] / maxMin[0] * _fixedHeight;
          var subLength = (showYArr[i] - (i > 0 ? showYArr[i - 1] : 0)) /
              2 /
              maxMin[0] *
              _fixedHeight;
          TextPainter(
              textAlign: TextAlign.center,
              ellipsis: '.',
              maxLines: 1,
              text: TextSpan(
                  text: '$yValue',
                  style: TextStyle(color: fontColor, fontSize: fontSize)),
              textDirection: TextDirection.rtl)
            ..layout(minWidth: 40, maxWidth: 40)
            ..paint(
                canvas, Offset(startX - 40, startY - yLength - fontSize / 2));

          TextPainter(
              textAlign: TextAlign.center,
              ellipsis: '.',
              maxLines: 1,
              text: TextSpan(
                  text: focusGradeArr[i],
                  style:
                      TextStyle(color: focusColorArr[i], fontSize: fontSize)),
              textDirection: TextDirection.rtl)
            ..layout(minWidth: 40, maxWidth: 40)
            ..paint(
                canvas,
                Offset(
                    startX - 40, startY - yLength - fontSize / 2 + subLength));

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
            sub.shadowPath,
            new Paint()
              ..shader = sub.linearGradient
              ..isAntiAlias = true
              ..style = PaintingStyle.fill);

      canvas.drawRRect(
          RRect.fromRectAndCorners(sub.focusRect,
              topLeft: Radius.circular(sub.rectRedius),
              topRight: Radius.circular(sub.rectRedius),
              bottomLeft: Radius.circular(0),
              bottomRight: Radius.circular(0)),
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
  //阴影过度路径
  Path shadowPath;
  //阴影渐变
  Shader linearGradient;
  //标准小专注矩形
  Rect focusRect;
  //小矩形两侧的弧度剪切
  double rectRedius;
  //矩形的渐变色
  Shader rectGradient;

  ShadowSub(
      {@required this.shadowPath,
      this.linearGradient,
      this.focusRect,
      this.rectRedius,
      this.rectGradient});
}
