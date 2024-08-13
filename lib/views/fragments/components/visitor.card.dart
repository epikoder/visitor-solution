import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:styled_widget/styled_widget.dart';
import 'package:visitor_solution/models/visitor.model.dart';
import 'package:visitor_solution/utils/assets.dart';
import 'package:visitor_solution/utils/helper.dart';

class VisitorCard extends StatelessWidget {
  const VisitorCard({
    super.key,
    required this.visitor,
    required this.onTap,
  });
  final Visitor visitor;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return <Widget>[
      CachedNetworkImage(
        imageUrl: Assets.net(visitor.photo),
        imageBuilder: (context, imageProvider) => RepaintBoundary(
          child: CircleAvatar(
            radius: 40.0,
            backgroundColor: Colors.transparent,
            backgroundImage: imageProvider,
          ),
        ),
        errorWidget: (context, url, error) => CircleAvatar(
          child: Image.asset(
            Assets.logo,
            width: 80,
            height: 80,
            fit: BoxFit.cover,
          ),
        ),
      )
          .constrained(width: 100, height: 100)
          .backgroundColor(Colors.white)
          .clipRRect(all: 500)
          .padding(all: 5),
      [
        Styled.text(visitor.name).fontWeight(FontWeight.w800).fontSize(16),
        [
          [Styled.icon(Icons.phone).iconSize(15), Styled.text(visitor.phone)].toRow(),
          Styled.text(visitor.vid).fontWeight(FontWeight.w700),
        ].toRow(
            separator: const SizedBox(
          width: 10,
        )),
        Styled.text(datetimeToString(visitor.date))
            .textColor(Colors.grey.shade600),
      ].toColumn(
        separator: const SizedBox(
          height: 10,
        ),
        crossAxisAlignment: CrossAxisAlignment.start,
      )
    ]
        .toRow(
          separator: const SizedBox(
            width: 20,
          ),
          crossAxisAlignment: CrossAxisAlignment.start,
        )
        .padding(vertical: 5, horizontal: 10)
        .ripple()
        .clipRRect(all: 20)
        .gestures(onTap: onTap)
        .card(
          elevation: 2,
          color: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
        )
        .constrained(maxWidth: 800, height: 100);
  }
}
