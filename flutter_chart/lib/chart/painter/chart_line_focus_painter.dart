import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_chart/chart/chart_bean_focus.dart';
import 'package:flutter_chart/util/color_utils.dart';

import 'base_painter.dart';

class ChartLineFocusPainter extends BasePainter {
  double value; //当前动画值
  List<ChartBeanFocus> chartBeans;
  List<Color> shaderColors; //渐变色
  Color lineColor; //曲线或折线的颜色
  Color xyColor; //xy轴的颜色
  static const double basePadding = 16; //默认的边距
  static const double overPadding = 0; //多出最大的极值额外的线长
  List<double> maxMin = [0, 0]; //存储极值
  bool isCurve; //是否为曲线
  bool isShowYValue; //是否显示y轴数值
  bool isShowXy; //是否显示坐标轴
  bool isShowXyRuler; //是否显示xy刻度
  bool isShowHintX, isShowHintY; //x、y轴的辅助线
  bool isShowBorderTop, isShowBorderRight;//顶部和右侧的辅助线
  bool isShowPressedHintLine; //触摸时是否显示辅助线
  double pressedPointRadius; //触摸点半径
  double pressedHintLineWidth; //触摸辅助线宽度
  Color pressedHintLineColor; //触摸辅助线颜色
  // int yNum; //y轴的值数量,默认为5个
  int maxXMinutes; //最大时间，默认25分钟
  List<String> xNumValues; //x坐标值显示
  bool isShowFloat; //y轴的值是否显示小数
  double fontSize;
  Color fontColor;
  double lineWidth; //线宽
  double rulerWidth; //刻度的宽度或者高度
  double startX, endX, startY, endY;
  double _fixedHeight, _fixedWidth; //宽高
  Path path;
  Map<double, Offset> _points = new Map();

  bool _isAnimationEnd = false;

  Offset globalPosition;
  static const Color defaultColor = Colors.deepPurple;

  ChartLineFocusPainter(
    this.chartBeans,
    this.lineColor, {
    this.lineWidth = 4,
    this.value = 1,
    this.isCurve = true,
    this.isShowXy = true,
    this.isShowYValue = true,
    this.isShowXyRuler = true,
    this.isShowHintX = false,
    this.isShowHintY = false,
    this.isShowBorderTop = false,
    this.isShowBorderRight = false,
    this.rulerWidth = 8,
    this.shaderColors,
    this.xyColor = defaultColor,
    // this.yNum = 5,
    this.maxXMinutes = 25,
    this.xNumValues,
    this.isShowFloat = false,
    this.fontSize = 10,
    this.fontColor = defaultColor,
    this.globalPosition,
    this.isShowPressedHintLine = true,
    this.pressedPointRadius = 4,
    this.pressedHintLineWidth = 0.5,
    this.pressedHintLineColor = defaultColor,
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
    if (pressedHintLineColor == null) {
      pressedHintLineColor = defaultColor;
    }
    // if (yNum == null) {
    //   yNum = 5;
    // }
    if (isShowFloat == null) {
      isShowFloat = false;
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
    // if (yMax != 0 || yMin != 0) {
      maxMin = [100, 0];
    // } else {
      // maxMin = calculateMaxMin(chartBeans);
    // }
  }

  ///计算Path
  void initPath(Size size) {
    if (path == null) {
      if (chartBeans != null && chartBeans.length > 0) {
        path = Path();
        double preX, preY, currentX, currentY;
        int length = chartBeans.length;
        // chartBeans.length > 7 ? 7 : chartBeans.length;
        double W = _fixedWidth / (length - 1); //两个点之间的x方向距离
        for (int i = 0; i < length; i++) {
          if (i == 0) {
            var key = startX;
            var value = (startY - chartBeans[i].focus / maxMin[0] * _fixedHeight);
            path.moveTo(key, value);
            _points[key] = Offset(key, value);
            continue;
          }
          currentX = startX + W * i;
          preX = startX + W * (i - 1);

          preY = (startY - chartBeans[i - 1].focus / maxMin[0] * _fixedHeight);
          currentY = (startY - chartBeans[i].focus / maxMin[0] * _fixedHeight);
          _points[currentX] = Offset(currentX, currentY);

          if (isCurve) {
            path.cubicTo((preX + currentX) / 2, preY, (preX + currentX) / 2,
                currentY, currentX, currentY);
          } else {
            path.lineTo(currentX, currentY);
          }
        }
      }
    }
  }

  ///x,y轴
  void _drawXy(Canvas canvas, Size size) {
    if (!isShowXy && !isShowXyRuler) return;
    var paint = Paint()
      ..isAntiAlias = true
      ..strokeWidth = 1
      ..strokeCap = StrokeCap.round
      ..color = xyColor
      ..style = PaintingStyle.stroke;
    if (isShowXy) {
      canvas.drawLine(Offset(startX, startY),
          Offset(endX + overPadding, startY), paint); //x轴
      canvas.drawLine(Offset(startX, startY),
          Offset(startX, endY - overPadding), paint); //y轴
    }
    if (isShowBorderTop) {
      ///最顶部水平边界线
      canvas.drawLine(Offset(startX, endY - overPadding),
          Offset(endX + overPadding, endY - overPadding), paint);
    }
    if (isShowBorderRight) {
      ///最右侧垂直边界线
      canvas.drawLine(Offset(endX + overPadding, startY),
          Offset(endX + overPadding, endY - overPadding), paint);
    }  
    drawRuler(canvas, paint); //刻度
  }

  ///x,y轴刻度 & 辅助线
  void drawRuler(Canvas canvas, Paint paint) {
    if (chartBeans != null && chartBeans.length > 0) {
      int length = xNumValues.length;
      // chartBeans.length > 7 ? 7 : chartBeans.length; //最多绘制7个
      double dw = _fixedWidth / (length - 1); //两个点之间的x方向距离
      // double dh = _fixedHeight / (length - 1); //两个点之间的y方向距离
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

        if (!isShowXyRuler) continue;


        if (isShowHintY) {
          ///y轴辅助线
          canvas.drawLine(Offset(startX + dw * i, startY),
              Offset(startX + dw * i, endY - overPadding), paint..color = Colors.grey.withOpacity(0.5));
        }

        // ///x轴刻度
        // canvas.drawLine(Offset(startX + dw * i, startY),
        //     Offset(startX + dw * i, startY - rulerWidth), paint..color = xyColor);

      }
      // int yLength = yNum + 1; //包含原点,所以 +1
      List <double> showYArr = [35,65,100];
      List <String> focusGradeArr = ["走神","一般","忘我"];
      List <Color> focusColorArr = [ColorsUtil.hexColor(0x172B88),ColorsUtil.hexColor(0xFFC278),ColorsUtil.hexColor(0xF75E36)];
      // double dValue = maxMin[0] / yNum; //一段对应的值
      // double dV = _fixedHeight / yNum; //一段对应的高度
      for (int i = 0; i < showYArr.length; i++) {
        if (isShowYValue) {
          ///绘制y轴文本，保留1位小数
          var yValue = showYArr[i].toStringAsFixed(isShowFloat ? 1 : 0);
          var yLength = showYArr[i]/maxMin[0] * _fixedHeight;
          var subLength = (showYArr[i] - (i > 0 ? showYArr[i-1] : 0))/2/maxMin[0] * _fixedHeight;
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
                  style: TextStyle(color: focusColorArr[i], fontSize: fontSize)),
              textDirection: TextDirection.rtl)
            ..layout(minWidth: 40, maxWidth: 40)
            ..paint(
                canvas, Offset(startX - 40, startY - yLength - fontSize/2 + subLength));


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

        // if (!isShowXyRuler) continue;
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
    var pathMetrics = path.computeMetrics(forceClosed: false);
    var list = pathMetrics.toList();
    var length = value * list.length.toInt();
    Path linePath = new Path();
    Path shadowPath = new Path();
    for (int i = 0; i < length; i++) {
      var extractPath =
          list[i].extractPath(0, list[i].length * value, startWithMoveTo: true);
      linePath.addPath(extractPath, Offset(0, 0));

      shadowPath = list[i].extractPath(i > 0 ? list[i].length * value : 0, list[i].length * value, startWithMoveTo: true);

      ///画阴影,注意LinearGradient这里需要指定方向，默认为从左到右
      var shader = LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              tileMode: TileMode.clamp,
              colors: chartBeans[i].gradualColors)
          .createShader(Rect.fromLTRB(startX, endY, endX, startY));

      ///从path的最后一个点连接起始点，形成一个闭环
      shadowPath
        ..lineTo(startX + _fixedWidth * value, startY)
        ..lineTo(startX, startY)
        ..close();

      canvas
        ..drawPath(
            shadowPath,
            new Paint()
              ..shader = shader
              ..isAntiAlias = true
              ..style = PaintingStyle.fill);
    }

    ///先画阴影再画曲线，目的是防止阴影覆盖曲线
    canvas.drawPath(linePath, paint);
  }
}
