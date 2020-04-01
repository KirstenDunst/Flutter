/*
 * Copyright © 2020, Simform Solutions
 * All rights reserved.
 *
 * Redistribution and use in source and binary forms, with or without
 * modification, are permitted provided that the following conditions are met:
 *
 * 1. Redistributions of source code must retain the above copyright notice, this
 *    list of conditions and the following disclaimer.
 *
 * 2. Redistributions in binary form must reproduce the above copyright notice,
 *    this list of conditions and the following disclaimer in the documentation
 *    and/or other materials provided with the distribution.
 *
 * THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS"
 * AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE
 * IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE
 * DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT HOLDER OR CONTRIBUTORS BE LIABLE
 * FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL
 * DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR
 * SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER
 * CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY,
 * OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE
 * OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
 */
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:path_drawing/path_drawing.dart';
import 'package:flutter_guide_view/draw_enum.dart';
import 'package:flutter_guide_view/position_%20excursion.dart';

class ShapePainter extends CustomPainter {
  // Rect rect;
  final ShapeBorder shapeBorder;
  final Color color;
  final double opacity;
  final PositionLocation location;

  //绘制线路
  Path path = Path();
  //组件相距最近上或者下的中心点
  Point mainHoriCloseCenterPoint;
  //解释组件区域的相距最近对应下或者上的中心点
  Point subHoriCloseCenterPoint;
  //组件右侧中心点位置
  Point mainVertRightPoint;
  //解释右侧中心点位置
  Point subVertRightPoint;
  //解释左侧中心点位置
  Point subVertLeftPoint;

  ShapePainter(
      {@required this.location, this.color, this.shapeBorder, this.opacity});

  @override
  void paint(Canvas canvas, Size size) {
    _dealPath();
    _drawCanvas(canvas, size);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => false;

  void _dealPath() {
    mainHoriCloseCenterPoint = location.horizontalCloseCenterMainPoint;
    subHoriCloseCenterPoint = location.horizontalCloseCenterSubPoint;
    mainVertRightPoint = location.verticalCenterRightMainPoint;
    subVertLeftPoint = location.verticalCenterLeftSubPoint;
    subVertRightPoint = location.verticalCenterRightSubPoint;
  }

  void _drawCanvas(Canvas canvas, Size size) {
    final paint = Paint();
    paint.color = color.withOpacity(opacity);
    RRect outer =
        RRect.fromLTRBR(0, 0, size.width, size.height, Radius.circular(0));

    double radius = shapeBorder == CircleBorder() ? 50 : 3;

    RRect inner = RRect.fromRectAndRadius(
        location.position.getRect(), Radius.circular(radius));
    canvas.drawDRRect(outer, inner, paint);

    if (location.guidePathType != GuidePathType.None &&
        location.guidePathType != GuidePathType.Triangle) {
      _drawAssistLine(canvas, size);
    }
  }

  void _drawAssistLine(Canvas canvas, Size size) {
    //辅助引导线绘制
    final paintSub = Paint()
      ..color = Colors.white
      ..isAntiAlias = true
      ..strokeCap = StrokeCap.round
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2;

    ArrowsDirectType initialDirect, endDirect;
    Point startPoint, endPoint;

    double excessiveHeight = (location.isArrowUp ? speaceWidth : -speaceWidth);
    //绘制路线
    switch (location.guidePathType) {
      case GuidePathType.DirectStraight:
      case GuidePathType.CenterStraight:
        startPoint = mainHoriCloseCenterPoint;
        endPoint = subHoriCloseCenterPoint;
        double centerY = (startPoint.y + endPoint.y) / 2;
        path
          ..moveTo(startPoint.x, startPoint.y + excessiveHeight)
          ..lineTo(startPoint.x, centerY)
          ..lineTo(endPoint.x, centerY)
          ..lineTo(endPoint.x, endPoint.y - excessiveHeight);
        initialDirect =
            location.isArrowUp ? ArrowsDirectType.Up : ArrowsDirectType.Down;
        endDirect =
            !location.isArrowUp ? ArrowsDirectType.Up : ArrowsDirectType.Down;
        break;
      case GuidePathType.TopBethel:
        startPoint = mainHoriCloseCenterPoint;
        endPoint = subHoriCloseCenterPoint;
        path.moveTo(startPoint.x, startPoint.y + excessiveHeight);
        path.quadraticBezierTo(
            location.isArrowUp ? endPoint.x : startPoint.x,
            (startPoint.y + endPoint.y) / 2,
            endPoint.x,
            endPoint.y - excessiveHeight);
        initialDirect =
            location.isArrowUp ? ArrowsDirectType.Up : ArrowsDirectType.Down;
        endDirect =
            !location.isArrowUp ? ArrowsDirectType.Up : ArrowsDirectType.Down;
        break;
      case GuidePathType.BottomBethel:
        startPoint = mainHoriCloseCenterPoint;
        endPoint = subHoriCloseCenterPoint;
        path.moveTo(startPoint.x, startPoint.y + excessiveHeight);
        path.quadraticBezierTo(
            location.isArrowUp ? startPoint.x : endPoint.x,
            (startPoint.y + endPoint.y) / 2,
            endPoint.x,
            endPoint.y - excessiveHeight);
        initialDirect =
            location.isArrowUp ? ArrowsDirectType.Up : ArrowsDirectType.Down;
        endDirect =
            !location.isArrowUp ? ArrowsDirectType.Up : ArrowsDirectType.Down;
        break;
      case GuidePathType.CenterToBorder:
        startPoint = mainHoriCloseCenterPoint;
        path.moveTo(startPoint.x, startPoint.y + excessiveHeight);
        var endArr =
            _getClosePoint(subVertLeftPoint, subVertRightPoint, startPoint);
        endPoint = endArr.first;
        double centerY = (startPoint.y + endPoint.y) / 2;
        //判断是否需要添加折线
        if ((subVertLeftPoint.x - speaceWidth - brokeLineSafeWidth) <
                startPoint.x &&
            startPoint.x <
                (subVertRightPoint.x + speaceWidth + brokeLineSafeWidth)) {
          //需要折线
          path.lineTo(startPoint.x, centerY);
        }
        bool endIsStart = endArr.last;
        path
          ..lineTo(
              endPoint.x +
                  (endIsStart
                      ? (-speaceWidth - brokeLineSafeWidth)
                      : (speaceWidth + brokeLineSafeWidth)),
              centerY)
          ..lineTo(
              endPoint.x +
                  (endIsStart
                      ? (-speaceWidth - brokeLineSafeWidth)
                      : (speaceWidth + brokeLineSafeWidth)),
              endPoint.y)
          ..lineTo(endPoint.x + (endIsStart ? (-speaceWidth) : speaceWidth),
              endPoint.y);

        initialDirect =
            location.isArrowUp ? ArrowsDirectType.Up : ArrowsDirectType.Down;
        endDirect = endIsStart ? ArrowsDirectType.Right : ArrowsDirectType.Left;
        break;
      case GuidePathType.RightToCenter:
        startPoint = mainVertRightPoint;
        endPoint = subHoriCloseCenterPoint;
        path.moveTo(startPoint.x + speaceWidth, startPoint.y);
        //判断是否需要添加折线
        if (endPoint.x < (startPoint.x + speaceWidth)) {
          //需要折线
          double centerY = (startPoint.y + endPoint.y) / 2;
          path
            ..lineTo(
                startPoint.x + speaceWidth + brokeLineSafeWidth, startPoint.y)
            ..lineTo(startPoint.x + speaceWidth + brokeLineSafeWidth, centerY)
            ..lineTo(endPoint.x, centerY);
        } else {
          path..lineTo(endPoint.x, startPoint.y);
        }
        path.lineTo(endPoint.x,
            endPoint.y - (location.isArrowUp ? speaceWidth : -speaceWidth));

        initialDirect = ArrowsDirectType.Left;
        endDirect =
            !location.isArrowUp ? ArrowsDirectType.Up : ArrowsDirectType.Down;
        break;
      case GuidePathType.RightDirect:
        startPoint = mainVertRightPoint;
        endPoint = Point(startPoint.x + speaceWidth + brokeLineSafeWidth,
            subHoriCloseCenterPoint.y);
        path
          ..moveTo(startPoint.x + speaceWidth, startPoint.y)
          ..lineTo(
              startPoint.x + speaceWidth + brokeLineSafeWidth, startPoint.y)
          ..lineTo(endPoint.x,
              endPoint.y - (location.isArrowUp ? speaceWidth : -speaceWidth));
        initialDirect = ArrowsDirectType.Left;
        endDirect =
            !location.isArrowUp ? ArrowsDirectType.Up : ArrowsDirectType.Down;
        break;
      default:
    }

    //端口样式
    if (location.guideEndType != GuideEndType.None) {
      switch (location.guideDirectionEndType) {
        case GuideDirectionEndType.BothPosition:
          _drawExtraDescribe(canvas, size, startPoint, initialDirect);
          _drawExtraDescribe(canvas, size, endPoint, endDirect);
          break;
        case GuideDirectionEndType.InitialPosition:
          _drawExtraDescribe(canvas, size, startPoint, initialDirect);
          break;
        case GuideDirectionEndType.EndPosition:
          _drawExtraDescribe(canvas, size, endPoint, endDirect);
          break;
        default:
      }
    }

    //两种绘制方式
    if (location.guideWireType == GuideWireType.Hollow) {
      canvas.drawPath(
        dashPath(
          path,
          dashArray: CircularIntervalList<double>(<double>[5.0, 4.0]),
        ),
        paintSub,
      );
    } else {
      canvas.drawPath(path, paintSub);
    }
  }

//比较x轴方向的距离那个比较近
//startPoint endPoint :解释组件的左右边中心点， nowPoint当前要比较的点
  List _getClosePoint(Point startPoint, Point endPoint, Point nowPoint) {
    double startWidth = (startPoint.x - nowPoint.x).abs();
    double endWidth = (endPoint.x - nowPoint.x).abs();
    return startWidth > endWidth ? [endPoint, false] : [startPoint, true];
  }

  static double brokeLineSafeWidth = 5;
  static double speaceWidth = 5;
  //绘制箭头，三角形
  void _drawExtraDescribe(
      Canvas canvas, Size size, Point point, ArrowsDirectType directType) {
    //辅助引导线绘制
    final paintSub = Paint()
      ..color = Colors.white
      ..isAntiAlias = true
      ..strokeCap = StrokeCap.round
      ..strokeWidth = 2;
    Path cellPath = Path();
    cellPath.moveTo(point.x, point.y);
    Point leftPoint, rightPoint;
    switch (directType) {
      case ArrowsDirectType.Up:
        //角朝上
        leftPoint = Point(point.x - speaceWidth, point.y + speaceWidth);
        rightPoint = Point(point.x + speaceWidth, point.y + speaceWidth);
        break;
      case ArrowsDirectType.Down:
        leftPoint = Point(point.x - speaceWidth, point.y - speaceWidth);
        rightPoint = Point(point.x + speaceWidth, point.y - speaceWidth);
        break;
      case ArrowsDirectType.Left:
        leftPoint = Point(point.x + speaceWidth, point.y - speaceWidth);
        rightPoint = Point(point.x + speaceWidth, point.y + speaceWidth);
        break;
      case ArrowsDirectType.Right:
        leftPoint = Point(point.x - speaceWidth, point.y - speaceWidth);
        rightPoint = Point(point.x - speaceWidth, point.y + speaceWidth);
        break;
      default:
    }
    cellPath.lineTo(leftPoint.x, leftPoint.y);
    if (location.guideEndType == GuideEndType.Arrows) {
      cellPath..lineTo(point.x, point.y)..lineTo(rightPoint.x, rightPoint.y);
      paintSub.style = PaintingStyle.stroke;
    } else if (location.guideEndType == GuideEndType.HollowTriangle) {
      cellPath..lineTo(rightPoint.x, rightPoint.y)..lineTo(point.x, point.y);
      paintSub.style = PaintingStyle.stroke;
    } else {
      cellPath
        ..lineTo(rightPoint.x, rightPoint.y)
        ..lineTo(point.x, point.y)
        ..close();
      paintSub.style = PaintingStyle.fill;
    }
    canvas.drawPath(cellPath, paintSub);
  }
}

//箭头指向方向
enum ArrowsDirectType {
  //向上
  Up,
  //向下
  Down,
  //向左
  Left,
  //向右
  Right,
}
