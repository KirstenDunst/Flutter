import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_chart/util/color_utils.dart';
import 'base_painter.dart';

class ChartLineFocusBasePainter extends BasePainter {
  Color xyColor; //xy轴的颜色
  static const double basePadding = 16; //默认的边距
  static const double overPadding = 0; //多出最大的极值额外的线长
  List<double> maxMin = [100, 0]; //存储极值
  bool isShowYValue; //是否显示y轴数值
  bool isShowHintX, isShowHintY; //x、y轴的辅助线
  int maxXMinutes; //最大时间，默认25分钟
  List<String> xNumValues; //x坐标值显示数组
  double fontSize; //坐标轴刻度字体size
  Color fontColor; //坐标轴刻度字体颜色
  double rulerWidth; //坐标轴的宽度或者高度
  double startX, endX, startY, endY;
  double fixedHeight, fixedWidth; //坐标可容纳的宽高

  static const Color defaultColor = Colors.deepPurple;

  ChartLineFocusBasePainter({
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
    print("绘制");
    _init(size);
    _drawXy(canvas, size); //坐标轴
  }
  
  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return false;
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
    int length = xNumValues.length;
    double dw = fixedWidth / (length - 1); //两个点之间的x方向距离
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
        var yValue = showYArr[i].toStringAsFixed(0);
        var yLength = showYArr[i] / maxMin[0] * fixedHeight;
        var subLength = (showYArr[i] - (i > 0 ? showYArr[i - 1] : 0)) /
            2 /
            maxMin[0] *
            fixedHeight;
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
                text: focusGradeArr[i],
                style: TextStyle(color: focusColorArr[i], fontSize: fontSize)),
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
}
