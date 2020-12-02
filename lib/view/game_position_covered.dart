import 'package:flutter/material.dart';
import 'package:minesweeper/widgets/position.dart';
const flagIcon = "\u2691";

class CoveredMineTile extends StatelessWidget {
  final bool flagged;
  final int posX;
  final int posY;

  CoveredMineTile({this.flagged, this.posX, this.posY});

  @override
  Widget build(BuildContext context) {
    Widget text;
    if (flagged) {
      text = BuildInnerPosition(RichText(
        text: TextSpan(
          text: flagIcon,
          style: TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.bold,
          ),
        ),
        textAlign: TextAlign.center,
      ));
    }
    Widget innerTile = Container(
      padding: EdgeInsets.all(1.0),
      margin: EdgeInsets.all(2.0),
      height: 20.0,
      width: 20.0,
      color: Colors.grey[350],
      child: text,
    );

    return BuildPosition(innerTile);
  }
}