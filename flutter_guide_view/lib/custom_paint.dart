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

  Path path = Path();

  ShapePainter(
      {@required this.location, this.color, this.shapeBorder, this.opacity});

  @override
  void paint(Canvas canvas, Size size) {
    _dealPath();
    _drawCanvas(canvas, size);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => false;

  void _dealPath() {}

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

    double extralInitialSpeace = 0;
    double extralEndSpeace = 0;
    //端口样式
    if (location.guideEndType != GuideEndType.None) {
      switch (location.guideDirectionEndType) {
        case GuideDirectionEndType.BothPosition:
          _drawExtraDescribe(canvas, size, location.startPoint, location.isArrowUp);
          _drawExtraDescribe(canvas, size, location.endPoint, !location.isArrowUp);
          extralInitialSpeace =
              (location.guideEndType == GuideEndType.SolidTriangle ||
                      location.guideEndType == GuideEndType.HollowTriangle)
                  ? speaceWidth
                  : 0;
          extralEndSpeace =
              (location.guideEndType == GuideEndType.SolidTriangle ||
                      location.guideEndType == GuideEndType.HollowTriangle)
                  ? speaceWidth
                  : 0;
          break;
        case GuideDirectionEndType.InitialPosition:
          _drawExtraDescribe(canvas, size, location.startPoint, location.isArrowUp);
          extralInitialSpeace =
              (location.guideEndType == GuideEndType.SolidTriangle ||
                      location.guideEndType == GuideEndType.HollowTriangle)
                  ? speaceWidth
                  : 0;
          break;
        case GuideDirectionEndType.EndPosition:
          _drawExtraDescribe(canvas, size, location.endPoint, !location.isArrowUp);
          extralEndSpeace =
              (location.guideEndType == GuideEndType.SolidTriangle ||
                      location.guideEndType == GuideEndType.HollowTriangle)
                  ? speaceWidth
                  : 0;
          break;
        default:
      }
    }
    if (!location.isArrowUp) {
      extralEndSpeace = -extralEndSpeace;
      extralInitialSpeace = -extralInitialSpeace;
    }
    path.moveTo(location.startPoint.x, location.startPoint.y + extralInitialSpeace);
    //绘制路线
    switch (location.guidePathType) {
      case GuidePathType.DirectStraight:
      case GuidePathType.CenterStraight:
        path.lineTo(location.endPoint.x, location.endPoint.y - extralEndSpeace);
        break;
      case GuidePathType.TopBethel:
        path.quadraticBezierTo(
            location.isArrowUp ? location.endPoint.x : location.startPoint.x,
            (location.startPoint.y + location.endPoint.y) / 2,
            location.endPoint.x,
            location.endPoint.y - extralEndSpeace);
        break;
      case GuidePathType.BottomBethel:
        path.quadraticBezierTo(
            location.isArrowUp ? location.startPoint.x : location.endPoint.x,
            (location.startPoint.y + location.endPoint.y) / 2,
            location.endPoint.x,
            location.endPoint.y - extralEndSpeace);
        break;
      case GuidePathType.CenterToBorder:

        break;
      case GuidePathType.LeftToCenter:

        break;
      case GuidePathType.LeftDirect:

        break;
      default:
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

  static double speaceWidth = 5;
  //绘制箭头，三角形
  void _drawExtraDescribe(Canvas canvas, Size size, Point point, bool upDown) {
    //辅助引导线绘制
    final paintSub = Paint()
      ..color = Colors.white
      ..isAntiAlias = true
      ..strokeCap = StrokeCap.round
      ..strokeWidth = 2;
    Path cellPath = Path();
    cellPath.moveTo(point.x, point.y);
    Point leftPoint, rightPoint;
    if (upDown) {
      //角朝上
      leftPoint = Point(point.x - speaceWidth, point.y + speaceWidth);
      rightPoint = Point(point.x + speaceWidth, point.y + speaceWidth);
    } else {
      leftPoint = Point(point.x - speaceWidth, point.y - speaceWidth);
      rightPoint = Point(point.x + speaceWidth, point.y - speaceWidth);
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
