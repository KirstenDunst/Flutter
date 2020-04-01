import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_guide_view/draw_enum.dart';
import 'package:flutter_guide_view/get_position.dart';

class PositionLocation {
  final GetPosition position;
  final Offset offset;
  final String title;
  final String description;
  final Size screenSize;
  final Animation<double> animationOffset;
  final double contentHeight;
  final double contentWidth;
  final GuidePathType guidePathType;
  final GuideWireType guideWireType;
  final GuideEndType guideEndType;
  final GuideDirectionEndType guideDirectionEndType;
  final bool showArrow;
  bool isArrowUp;
  final double paddingTopBottomSpeace;
  Point get horizontalCloseCenterMainPoint {
    return Point(
        position.getCenter(),
        isArrowUp
            ? position.getBottom()
            : position.getTop());
  }
  Point get horizontalCloseCenterSubPoint {
    double endX = position.getCenter();
    if (guidePathType != GuidePathType.DirectStraight) {
      endX = isLeft()
          ? (getLeft() + getTooltipWidth() / 2)
          : (screenSize.width -
              getRight() -
              getTooltipWidth() / 2);
    }
    double endY = isArrowUp ? (position.getBottom()+paddingTopBottomSpeace) : (position.getTop()-paddingTopBottomSpeace);
    return Point(endX, endY);
  }
  Point get verticalCenterRightMainPoint {
    Rect orignRect = position.getRect();
    return Point(orignRect.centerRight.dx, orignRect.centerRight.dy);
  }
  Point get verticalCenterRightSubPoint {
    double endX = isLeft()?(getLeft() + getTooltipWidth()):(screenSize.width-getRight());
    double endY = isArrowUp ? (position.getBottom()+paddingTopBottomSpeace + subHeightHalf) : (position.getTop()-paddingTopBottomSpeace-subHeightHalf);
    return Point(endX, endY);
  }
  Point get verticalCenterLeftSubPoint {
    double endX = isLeft()?getLeft():(screenSize.width-getRight()-getTooltipWidth());
    double endY = isArrowUp ? (position.getBottom()+paddingTopBottomSpeace + subHeightHalf) : (position.getTop()-paddingTopBottomSpeace-subHeightHalf);
    return Point(endX, endY);
  }
  //解释文案组件的高度的一半
  static final subHeightHalf = 25;
  

  PositionLocation(
      {this.position,
      this.offset,
      this.title,
      this.description,
      this.screenSize,
      this.animationOffset,
      this.showArrow,
      this.contentHeight,
      this.contentWidth,
      this.guidePathType,
      this.guideWireType,
      this.guideEndType,
      this.guideDirectionEndType,
      this.paddingTopBottomSpeace,
      });


  bool isCloseToTopOrBottom(Offset position) {
    double height = 120;
    if (contentHeight != null) {
      height = contentHeight;
    }
    return (screenSize.height - position.dy) <= height;
  }

  String findPositionForContent() {
    if (isCloseToTopOrBottom(offset)) {
      return 'ABOVE';
    } else {
      return 'BELOW';
    }
  }

  double getTooltipWidth() {
    double titleLength = title == null ? 0 : (title.length * 10.0);
    double descriptionLength = description == null ? 0 :(description.length * 7.0);
    return (max(titleLength, descriptionLength) + 10);
  }

  bool isLeft() {
    double screenWidth = screenSize.width / 3;
    return !(screenWidth <= position.getCenter());
  }

  bool isRight() {
    double screenWidth = screenSize.width / 3;
    return ((screenWidth * 2) <= position.getCenter());
  }

  double getLeft() {
    if (isLeft()) {
      double leftPadding = position.getCenter() - (getTooltipWidth() * 0.1);
      if (leftPadding + getTooltipWidth() > screenSize.width) {
        leftPadding = (screenSize.width - 20) - getTooltipWidth();
      }
      if (leftPadding < 20) {
        leftPadding = 14;
      }
      return leftPadding;
    } else if (!(isRight())) {
      return position.getCenter() - (getTooltipWidth() * 0.5);
    } else {
      return null;
    }
  }

  double getRight() {
    if (isRight()) {
      double rightPadding = position.getCenter() + (getTooltipWidth() / 2);
      if (rightPadding + getTooltipWidth() > screenSize.width) {
        rightPadding = 14;
      }
      return rightPadding;
    } else if (!(isLeft())) {
      return position.getCenter() - (getTooltipWidth() * 0.5);
    } else {
      return null;
    }
  }

  double getSpace() {
    double space = position.getCenter() - (contentWidth / 2);
    if (space + contentWidth > screenSize.width) {
      space = screenSize.width - contentWidth - 8;
    } else if (space < (contentWidth / 2)) {
      space = 16;
    }
    return space;
  }
}
