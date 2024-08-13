import 'package:flutter/material.dart';
import 'package:styled_widget/styled_widget.dart';
import 'package:visitor_solution/utils/assets.dart';
import 'package:visitor_solution/utils/size.dart';

class AboutFragment extends StatelessWidget {
  const AboutFragment({super.key});

  @override
  Widget build(BuildContext context) {
    return <Widget>[
      Image.asset(Assets.logo).constrained(width: 100),
      Styled.text("Visitor Solution").fontSize(18),
      Styled.text("Copyright © 2024").fontSize(12),
    ]
        .toColumn(
            separator: const SizedBox(
          height: 10,
        ))
        .padding(vertical: 30)
        .width(
          MediaQuery.of(context).size.width -
              fragmentNavWidth -
              sideNavWidth -
              60,
        );
  }
}
