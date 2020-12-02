import 'package:flutter/material.dart';
import 'package:minesweeper/widgets/position.dart';

import 'game_board_main.dart';

class GamePositionClick extends StatelessWidget {
  final PositionState state;
  final int count;

  GamePositionClick({this.state, this.count});

  final List textColor = [
    Colors.blue,
    Colors.green,
    Colors.red,
    Colors.purple,
    Colors.cyan,
    Colors.amber,
    Colors.brown,
    Colors.black,
  ];

  @override
  Widget build(BuildContext context) {
    Widget text;

    if (state == PositionState.open) {
      if (count != 0) { // game not finished
        text = RichText(
          text: TextSpan(
            text: '$count',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: textColor[count - 1],
            ),
          ),
          textAlign: TextAlign.center,
        );
      }
    } else {
      text = RichText(
        text: TextSpan(
          text: '\u2739',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: Colors.red,
          ),
        ),
        textAlign: TextAlign.center,
      );
    }
    return BuildPosition(BuildInnerPosition(text));
  }
}