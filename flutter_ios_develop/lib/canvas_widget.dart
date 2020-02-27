/*
 * @Author       : Cao Shixin
 * @Date         : 2020-02-26 17:18:01
 * @LastEditors: Please set LastEditors
 * @LastEditTime: 2020-02-27 17:13:04
 * @Description  : 绘图
 */

import 'package:flutter/material.dart';

class SignaturePainter extends CustomPainter {
  SignaturePainter(this.points);
  final List<Offset> points;

  void paint(Canvas canvas, Size size){
    var paint = Paint()
    ..color = Colors.cyan
    ..strokeCap = StrokeCap.round
    ..strokeWidth = 5.0;
    // canvas.drawRect(Rect.fromLTRB(0, 0, right, bottom), paint)
    for (int i = 0; i < points.length - 1; i++) {
      if (points[i] != null && points[i+1] != null) {
        canvas.drawLine(points[i], points[i+1], paint);
      }
    }
  }

  bool shouldRepaint(SignaturePainter other) => other.points != points;
}

class Signature extends StatefulWidget {
  SignatureState createState() => SignatureState();
}

class SignatureState extends State<Signature> {
  List<Offset> _points = <Offset>[];

  Widget build(BuildContext context) {
    return GestureDetector(
      onPanUpdate: (DragUpdateDetails details) {
        setState((){
          RenderBox referenceBox = context.findRenderObject();
          Offset localPosition = referenceBox.globalToLocal(details.globalPosition);
          _points = List.from(_points)..add(localPosition);
        });
      },
      onPanEnd: (DragEndDetails details) => _points.add(null),
      child: CustomPaint(painter: SignaturePainter(_points), size:Size.infinite),
    );
  }
}


