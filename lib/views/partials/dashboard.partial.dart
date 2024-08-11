import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:get/get.dart';
import 'package:styled_widget/styled_widget.dart';
import 'package:visitor_solution/views/components/app.page.component.dart';
import 'package:visitor_solution/views/components/appbar.component.dart';

class DashboardPartial extends StatelessWidget {
  const DashboardPartial({super.key});

  @override
  Widget build(BuildContext context) {
    return AppPage(
      appBar: const AppBarComponent(
        title: "Dashboard",
      ),
      body: <Widget>[
        StaggeredGrid.count(
          crossAxisCount: 12,
          crossAxisSpacing: 20,
          children: [
            StaggeredGridTile.count(
              crossAxisCellCount: 4,
              mainAxisCellCount: 1,
              child: Styled.text("1").backgroundColor(Colors.red),
            ),
            StaggeredGridTile.count(
              crossAxisCellCount: 4,
              mainAxisCellCount: 1,
              child: Styled.text("1").backgroundColor(Colors.red),
            ),
            StaggeredGridTile.count(
              crossAxisCellCount: 4,
              mainAxisCellCount: 2,
              child: Styled.text("1").backgroundColor(Colors.red),
            ),
          ],
        ).paddingSymmetric(horizontal: 10, vertical: 50).scrollable()
      ].toColumn(),
    );
  }
}
