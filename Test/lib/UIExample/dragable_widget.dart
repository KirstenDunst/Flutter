/*
 * @Author: Cao Shixin
 * @Date: 2020-09-19 14:04:01
 * @LastEditors: Cao Shixin
 * @LastEditTime: 2020-11-25 10:12:44
 * @Description: 
 * @Email: cao_shixin@yahoo.com
 * @Company: BrainCo
 */
import 'package:flutter/material.dart';

class DraggableWidget extends StatefulWidget {
  static const routeName = 'draggable_widget';
  static const navTitle = 'Draggable';
  @override
  _CenterWidgetState createState() => _CenterWidgetState();
}

class _CenterWidgetState extends State<DraggableWidget> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Column(
        children: [
          Container(child: DraggablePage()),
          SizedBox(
            height: 200,
          ),
          Container(child: DragableOther()),
        ],
      ),
    );
  }
}

class DraggablePage extends StatefulWidget {
  DraggablePage({Key key}) : super(key: key);

  @override
  _DraggablePageState createState() => _DraggablePageState();
}

class _DraggablePageState extends State<DraggablePage> {
  @override
  Widget build(BuildContext context) {
    return Draggable(
      data: Color(0x000000FF),
      child: Container(
        height: 100,
        width: 100,
        alignment: Alignment.center,
        decoration: BoxDecoration(
            color: Colors.red, borderRadius: BorderRadius.circular(10)),
        child: Text(
          '曹',
          style: TextStyle(color: Colors.white, fontSize: 18),
        ),
      ),
      feedback: Container(
        height: 100,
        width: 100,
        alignment: Alignment.center,
        decoration: BoxDecoration(
            color: Colors.blue, borderRadius: BorderRadius.circular(10)),
        child: Text(
          '孟',
          style: TextStyle(color: Colors.white, fontSize: 18),
        ),
      ),
      childWhenDragging: Container(
        height: 100,
        width: 100,
        alignment: Alignment.center,
        decoration: BoxDecoration(
            color: Colors.grey, borderRadius: BorderRadius.circular(10)),
        child: Text(
          '德',
          style: TextStyle(color: Colors.white, fontSize: 18),
        ),
      ),
      //控制拖动的方向
      // axis: Axis.vertical,
      //拖动过程中的回调
      onDragStarted: () {
        print('开始拖动时回调。onDragStarted');
      },
      onDragEnd: (DraggableDetails details) {
        print('拖动结束时回调。onDragEnd:$details');
      },
      onDraggableCanceled: (Velocity velocity, Offset offset) {
        print(
            '未拖动到DragTarget控件上时回调 onDraggableCanceled velocity:$velocity,offset:$offset');
      },
      onDragCompleted: () {
        print('拖动到DragTarget控件上时回调 onDragCompleted');
      },
    );
  }
}

class DragableOther extends StatefulWidget {
  DragableOther({Key key}) : super(key: key);

  @override
  _DragableOtherState createState() => _DragableOtherState();
}

class _DragableOtherState extends State<DragableOther> {
  var _dragData;
  @override
  Widget build(BuildContext context) {
    return DragTarget<Color>(
      builder: (BuildContext context, List<Color> candidateData,
          List<dynamic> rejectedData) {
        print('candidateData:$candidateData,rejectedData:$rejectedData');
        return _dragData == null
            ? Container(
                height: 100,
                width: 100,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(color: Colors.red)),
              )
            : Container(
                height: 100,
                width: 100,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                    color: Colors.red, borderRadius: BorderRadius.circular(10)),
                child: Text(
                  '过来了',
                  style: TextStyle(color: Colors.white, fontSize: 18),
                ),
              );
      },
      onWillAccept: (Color color) {
        //拖到该控件上时调用，需要返回true或者false，返回true，松手后会回调onAccept，否则回调onLeave。
        print('onWillAccept:$color');
        return true;
      },
      onAccept: (Color color) {
        //onWillAccept返回true时，用户松手后调用。
        setState(() {
          _dragData = color;
        });
        print('onAccept:$color');
      },
      onLeave: (data) {
        //onWillAccept返回false时，用户松手后调用。
        print('onLeave:$data');
      },
    );
  }
}
