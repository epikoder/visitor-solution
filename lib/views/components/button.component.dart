import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:styled_widget/styled_widget.dart';

class Button extends StatelessWidget {
  const Button({
    super.key,
    required this.text,
    required this.icon,
    this.onTap,
    this.color,
    this.horizontalPadding = 10,
    this.verticalPadding = 5,
  });

  final String text;
  final IconData icon;
  final VoidCallback? onTap;
  final Color? color;
  final double horizontalPadding;
  final double verticalPadding;

  @override
  Widget build(BuildContext context) {
    return <Widget>[
      Styled.icon(icon).iconSize(18).iconColor(Colors.white),
      Styled.text(text).textColor(Colors.white),
    ]
        .toRow(
          separator: const SizedBox(
            width: 5,
          ),
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
        )
        .paddingSymmetric(
            vertical: verticalPadding, horizontal: horizontalPadding)
        .ripple(enable: onTap != null)
        .gestures(onTap: onTap)
        .decorated(
          color: onTap != null ? (color ?? Colors.blue.shade400) : Colors.grey,
          borderRadius: BorderRadius.circular(10),
        );
  }
}

class StyledButton extends StatelessWidget {
  const StyledButton({
    super.key,
    required this.text,
    this.onTap,
    this.color,
    this.horizontalPadding = 10,
    this.verticalPadding = 15,
    this.mainAxisSize = MainAxisSize.max,
    this.borderRadius = 10,
  });

  final String text;
  final VoidCallback? onTap;
  final Color? color;
  final double horizontalPadding;
  final double verticalPadding;
  final MainAxisSize mainAxisSize;
  final double borderRadius;

  @override
  Widget build(BuildContext context) {
    return <Widget>[
      Styled.text(text).textColor(Colors.white),
    ]
        .toRow(
          separator: const SizedBox(
            width: 5,
          ),
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: mainAxisSize,
        )
        .paddingSymmetric(
            vertical: verticalPadding, horizontal: horizontalPadding)
        .ripple(enable: onTap != null)
        .gestures(onTap: onTap)
        .decorated(
          color: onTap != null ? (color ?? Colors.blue.shade400) : Colors.grey,
          borderRadius: BorderRadius.circular(borderRadius),
        );
  }
}

class StyledIconButton extends StatelessWidget {
  const StyledIconButton({
    super.key,
    required this.icon,
    this.onTap,
    this.color,
    this.bgColor,
    this.iconSize = 13,
  });

  final IconData icon;
  final Color? color;
  final Color? bgColor;
  final VoidCallback? onTap;
  final double iconSize;

  @override
  Widget build(BuildContext context) {
    return Styled.icon(icon)
        .iconColor(onTap != null ? (color ?? Colors.white) : Colors.white)
        .iconSize(iconSize)
        .padding(all: 5)
        .ripple(enable: onTap != null)
        .backgroundColor(
            onTap != null ? (bgColor ?? Colors.blue.shade500) : Colors.grey)
        .gestures(onTap: onTap)
        .clipRRect(all: 5);
  }
}
