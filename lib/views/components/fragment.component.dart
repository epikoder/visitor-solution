import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:styled_widget/styled_widget.dart';
import 'package:visitor_solution/utils/size.dart';
import 'package:visitor_solution/views/components/fragment.appbar.component.dart';

class Fragment extends StatelessWidget {
  const Fragment({
    super.key,
    required this.appBar,
    required this.body,
    this.modal,
  });

  final FragmentAppBar appBar;
  final Widget body;
  final Widget? modal;

  @override
  Widget build(BuildContext context) {
    return [
      <Widget>[
        appBar,
        body.constrained(
          maxWidth: MediaQuery.of(context).size.width - sideNavWidth - 20,
          maxHeight: MediaQuery.of(context).size.height - appBarHeight,
        ),
      ].toColumn(mainAxisAlignment: MainAxisAlignment.start),
      if (modal != null) modal!,
    ].toStack();
  }
}
