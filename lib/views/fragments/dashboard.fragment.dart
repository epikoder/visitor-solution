import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:get/get.dart';
import 'package:styled_widget/styled_widget.dart';
import 'package:visitor_solution/views/components/fragment.component.dart';
import 'package:visitor_solution/views/components/fragment.appbar.component.dart';
import 'package:visitor_solution/views/fragments/components/chart.dart';

class DashboardFragment extends StatelessWidget {
  const DashboardFragment({super.key});

  @override
  Widget build(BuildContext context) {
    return Fragment(
      appBar: const FragmentAppBar(
        title: "Dashboard",
      ),
      body: <Widget>[
        [
          [
            Styled.text("Hola!").fontSize(22).textColor(Colors.grey.shade500),
            Styled.text("Welcome to visitor solution")
                .fontSize(22)
                .textColor(Colors.grey.shade500)
          ].toColumn(
            crossAxisAlignment: CrossAxisAlignment.start,
            separator: const SizedBox(
              height: 20,
            ),
          )
        ].toRow(),
        // StaggeredGrid.count(
        //   crossAxisCount: 8,
        //   crossAxisSpacing: 20,
        //   children: [
        // StaggeredGridTile.count(
        //   crossAxisCellCount: 4,
        //   mainAxisCellCount: 1,
        //   child: Chart(),
        // ),
        // StaggeredGridTile.count(
        //   crossAxisCellCount: 4,
        //   mainAxisCellCount: 1,
        //   child: Chart(),
        // ),
        // ],
        // ).paddingSymmetric(horizontal: 10, vertical: 50).scrollable()
      ]
          .toColumn(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.start,
            mainAxisSize: MainAxisSize.max,
          )
          .padding(horizontal: 20, vertical: 20),
    );
  }
}
