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

import 'package:flutter/material.dart';
import 'package:flutter_guide_view/position_%20excursion.dart';

class ToolTipWidget extends StatelessWidget {
  final TextStyle titleTextStyle;
  final TextStyle descTextStyle;
  final Color tooltipColor;
  final Color textColor;
  final Widget container;
  final VoidCallback onTooltipTap;
  final PositionLocation location;

  ToolTipWidget({
    this.titleTextStyle,
    this.descTextStyle,
    this.tooltipColor,
    this.textColor,
    this.container,
    this.onTooltipTap,
    this.location,
  });

  //限定活动距离范围差
  static final offBetwon = 10.0;

  @override
  Widget build(BuildContext context) {
    final contentOrientation = location.findPositionForContent();
    final contentOffsetMultiplier = contentOrientation == "BELOW" ? 1.0 : -1.0;
    location.isArrowUp = contentOffsetMultiplier == 1.0 ? true : false;

    final contentY = location.isArrowUp
        ? location.position.getBottom() + (contentOffsetMultiplier * 3)
        : location.position.getTop() + (contentOffsetMultiplier * 3);
    final contentFractionalOffset = contentOffsetMultiplier.clamp(-1.0, 0.0);

    if (container == null) {
      final offspeace = offBetwon/(location.getTooltipHeight()+location.paddingTopBottomSpeace*2);
      return Stack(
        children: <Widget>[
          location.showArrow ? _getArrow(contentFractionalOffset,offBetwon) : Container(),
          Positioned(
            top: contentY,
            left: location.getLeft(),
            right: location.getRight(),
            child: FractionalTranslation(
              translation: Offset(0.0, contentFractionalOffset),
              child: SlideTransition(
                position: Tween<Offset>(
                  begin: Offset(0.0, contentFractionalOffset == -1 ? -offspeace : 0.0),
                  end: Offset(0.0, contentFractionalOffset == -1 ? 0.0 : offspeace),
                ).animate(location.animationOffset),
                child: Material(
                  color: Colors.transparent,
                  child: Container(
                    padding:
                    EdgeInsets.only(top: location.paddingTopBottomSpeace, bottom: location.paddingTopBottomSpeace),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(8),
                      child: GestureDetector(
                        onTap: onTooltipTap,
                        child: Container(
                          width: location.getTooltipWidth(),
                          padding: EdgeInsets.symmetric(vertical: 8),
                          color: tooltipColor,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: <Widget>[
                              Container(
                                child: Column(
                                  crossAxisAlignment: location.title != null
                                      ? CrossAxisAlignment.start
                                      : CrossAxisAlignment.center,
                                  children: <Widget>[
                                    location.title != null
                                        ? Text(
                                      location.title,
                                      style: titleTextStyle ??
                                          Theme.of(context)
                                              .textTheme
                                              .title
                                              .merge(TextStyle(
                                              color: textColor)),
                                    )
                                        : Container(),
                                    Text(
                                      location.description,
                                      style: descTextStyle ??
                                          Theme.of(context)
                                              .textTheme
                                              .subtitle
                                              .merge(TextStyle(color: textColor)),
                                    ),
                                  ],
                                ),
                              )
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          )
        ],
      );
    } else {
      //这里如果能够事先拿到传过来的widget的高度，用offBetwon/(widget高度) 效果会更好。
      final containerHeight = 0.100;
      return Stack(
        children: <Widget>[
          Positioned(
            left: location.getSpace(),
            top: contentY - 10,
            child: FractionalTranslation(
              translation: Offset(0.0, contentFractionalOffset),
              child: SlideTransition(
                position: Tween<Offset>(
                  begin: Offset(0.0, contentFractionalOffset == -1 ? -containerHeight: 0.0),
                  end: Offset(0.0, contentFractionalOffset == -1 ? 0.0 : containerHeight),
                ).animate(location.animationOffset),
                child: Material(
                  color: Colors.transparent,
                  child: GestureDetector(
                    onTap: onTooltipTap,
                    child: Container(
                      padding: EdgeInsets.only(
                        top: location.paddingTopBottomSpeace,
                      ),
                      color: Colors.transparent,
                      child: Center(
                        child: container,
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      );
    }
  }

  Widget _getArrow(contentFractionalOffset, offBetwon) {
    return Positioned(
      top: location.isArrowUp ? location.position.getBottom()+2 : location.position.getTop() - 2,
      left: location.position.getCenter() - 25,
      child: FractionalTranslation(
        translation: Offset(0.0, contentFractionalOffset),
        child: SlideTransition(
          position: Tween<Offset>(
            //50是小三角组件的高度，这样同比在动画的时候,动画的幅度都是offBetwon，那么就会同步运动了
            begin: Offset(0.0, contentFractionalOffset == -1 ? -offBetwon/50 : 0.0),
            end: Offset(0.0, contentFractionalOffset == -1 ? 0.0 : offBetwon/50),
          ).animate(location.animationOffset),
          child: location.isArrowUp
              ? Icon(
            Icons.arrow_drop_up,
            color: tooltipColor,
            size: 50,
          )
              : Icon(
            Icons.arrow_drop_down,
            color: tooltipColor,
            size: 50,
          ),
        ),
      ),
    );
  }
}
