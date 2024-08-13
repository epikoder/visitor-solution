import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:styled_widget/styled_widget.dart';
import 'package:visitor_solution/utils/size.dart';

class FragmentAppBar extends StatelessWidget {
  const FragmentAppBar({
    super.key,
    required this.title,
    this.leading,
    this.actions,
  });

  final String title;
  final Widget? leading;
  final List<Widget>? actions;

  @override
  Widget build(BuildContext context) {
    return <Widget>[
      if (leading != null) leading!,
      Styled.text(title).fontWeight(FontWeight.w700),
      if (actions != null) actions!.toRow(separator: const SizedBox(width: 10,)),
    ]
        .toRow(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          separator: const SizedBox(
            width: 10,
          ),
        )
        .paddingSymmetric(horizontal: 10)
        .border(bottom: 1, color: Colors.grey.shade400)
        .height(appBarHeight)
        .constrained(
            maxWidth: MediaQuery.of(context).size.width - sideNavWidth - 20);
  }
}
