/*
 * 线条绘制枚举定义
 */

enum GuidePathType {
  //什么引导都不要
  None,
  //三角标识
  Triangle,
  //当前组件中心到引导组件最近距离的直线
  DirectStraight,
  //直线，center to center
  CenterStraight,
  //贝塞尔曲线向上弯曲
  TopBethel,
  //贝塞尔曲线向下弯曲
  BottomBethel,
  //center to border,就近的border
  CenterToBorder,
  //left to center，组件左侧的边界中心指向解释组件的顶或者底的中心
  LeftToCenter,
  //left to direct,组件左侧的边界中心距离解释最近的直线
  LeftDirect,
}
//引导线为线时实线or虚线
enum GuideWireType {
  //实线
  Solid,
  //虚线
  Hollow,
}
//引导线为线时两端的样式类型
enum GuideEndType {
  //什么都不要
  None,
  //实心三角
  SolidTriangle,
  //空心三角
  HollowTriangle,
  //箭头
  Arrows,
}
//当需要引导线两端的样式设置时，设置的哪端
enum GuideDirectionEndType {
  //两端都有
  BothPosition,
  //原文案方向
  InitialPosition,
  //解释文案方向
  EndPosition,
}