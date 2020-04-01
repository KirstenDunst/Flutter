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

  @override
  Widget build(BuildContext context) {
    final contentOrientation = location.findPositionForContent();
    final contentOffsetMultiplier = contentOrientation == "BELOW" ? 1.0 : -1.0;
    location.isArrowUp = contentOffsetMultiplier == 1.0 ? true : false;

    final contentY = location.isArrowUp
        ? location.position.getBottom() + (contentOffsetMultiplier * 3)
        : location.position.getTop() + (contentOffsetMultiplier * 3);

    //这里限制如果contentOffsetMultiplier为1.0这里将返回0.0（这个返回尽可能靠近的一个值)
    final contentFractionalOffset = contentOffsetMultiplier.clamp(-1.0, 0.0);

    if (container == null) {
      return Stack(
        children: <Widget>[
          location.showArrow ? _getArrow(contentOffsetMultiplier) : Container(),
          Positioned(
            top: contentY,
            left: location.getLeft(),
            right: location.getRight(),
            child: FractionalTranslation(
              translation: Offset(0.0, contentFractionalOffset),
              child: SlideTransition(
                position: Tween<Offset>(
                  begin: Offset(0.0, contentFractionalOffset / 10),
                  end: Offset(0.0, 0.100),
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
      return Stack(
        children: <Widget>[
          Positioned(
            left: location.getSpace(),
            top: contentY - 10,
            child: FractionalTranslation(
              translation: Offset(0.0, contentFractionalOffset),
              child: SlideTransition(
                position: Tween<Offset>(
                  begin: Offset(0.0, contentFractionalOffset / 5),
                  end: Offset(0.0, 0.100),
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

  Widget _getArrow(contentOffsetMultiplier) {
    final contentFractionalOffset = contentOffsetMultiplier.clamp(-1.0, 0.0);
    return Positioned(
      top: location.isArrowUp ? location.position.getBottom() : location.position.getTop() - 1,
      left: location.position.getCenter() - 24,
      child: FractionalTranslation(
        translation: Offset(0.0, contentFractionalOffset),
        child: SlideTransition(
          position: Tween<Offset>(
            begin: Offset(0.0, contentFractionalOffset / 5),
            end: Offset(0.0, 0.150),
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
