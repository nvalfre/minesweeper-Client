import 'package:flutter/material.dart';
import 'dart:math';
import 'dart:async';

import 'package:minesweeper/view/game_position.dart';

import 'game_position_covered.dart';

enum PositionState {
  covered, //default
  bomb, //bomb
  open, //default-free
  flagged,
  revealed //with hints
}

void main() => runApp(MineSweeper());

class MineSweeper extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: "Mine Sweeper - flutter",
      home: Board(),
    );
  }
}

class Board extends StatefulWidget {
  @override
  BoardState createState() => BoardState();
}

class BoardState extends State<Board> {
  final int rows = 9; //tbd -> create endpoints to start new game
  final int cols = 9;
  final int numOfMines = 11;

  List<List<PositionState>> gridState;
  List<List<bool>> gridBombPositions;

  bool alive;
  bool wonGame;
  int minesFound;
  Timer timer;
  Stopwatch stopwatch = Stopwatch();

  @override
  void initState() {
    resetBoard();
    super.initState();
  }

  @override
  void dispose() {
    timer?.cancel();
    super.dispose();
  }

  void resetBoard() {
    alive = true;
    wonGame = false;
    minesFound = 0;
    stopwatch.reset();

    timer?.cancel();
    timer = Timer.periodic(Duration(seconds: 1), (Timer timer) {
      setState(() {});
    });

    gridState = new List<List<PositionState>>.generate(rows, (row) {
      return new List<PositionState>.filled(cols, PositionState.covered);
    });

    gridBombPositions = new List<List<bool>>.generate(rows, (row) {
      return new List<bool>.filled(cols, false);
    });

    Random random = Random();
    int remainingMines = numOfMines;
    while (remainingMines > 0) {
      int pos = random.nextInt(rows * cols);
      int row = pos ~/ rows;
      int col = pos % cols;
      if (!gridBombPositions[row][col]) {
        gridBombPositions[row][col] = true;
        remainingMines--;
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    int timeElapsed = stopwatch.elapsedMilliseconds ~/ 1000;
    return Scaffold(
      resizeToAvoidBottomPadding: false,
      appBar: AppBar(
          centerTitle: true,
          title: Text('Mine Sweeper'),
          bottom: PreferredSize(
            preferredSize: Size.fromHeight(45.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                FlatButton(
                  child: Text(
                    'Reset Board',
                    style: TextStyle(color: Colors.white),
                  ),
                  onPressed: () => resetBoard(),
                  highlightColor: Colors.green,
                  splashColor: Colors.redAccent,
                  shape: RoundedRectangleBorder(
                    side: BorderSide(
                      color: Colors.blue[200],
                    ),
                  ),
                  color: Colors.blueAccent[100],
                ),
                Container(
                  padding: EdgeInsets.only(left: 10),
                  height: 40.0,
                  alignment: Alignment.center,
                  child: RichText(
                    text: TextSpan(
                        style: TextStyle(color: Colors.white),
                        text: wonGame
                            ? "You've Won! $timeElapsed seconds"
                            : alive
                                ? "[Mines Found: $minesFound] [Total Mines: $numOfMines] [$timeElapsed seconds]"
                                : "You've Lost! $timeElapsed seconds"),
                  ),
                ),
              ],
            ),
          )),
      body: Container(
        color: Colors.grey[50],
        child: Center(
          child: buildBoard(),
        ),
      ),
    );
  }

  Widget buildBoard() {
    bool hasCoveredCell = false;
    List<Row> boardRow = <Row>[];
    for (int y = 0; y < rows; y++) {
      List<Widget> rowChildren = <Widget>[];
      for (int x = 0; x < cols; x++) {
        PositionState state = gridState[y][x];
        int count = mineCount(x, y);

        if (!alive) { //game is still in progress
          if (state != PositionState.bomb)
            state = gridBombPositions[y][x] ? PositionState.revealed : state;
        }

        if (state == PositionState.covered || state == PositionState.flagged) {
          rowChildren.add(
            GestureDetector(
              onLongPress: () {
                flag(x, y);
              },
              onTap: () {
                if (state == PositionState.covered) probe(x, y);
              },
              child: Listener(
                child: CoveredMineTile(
                  flagged: state == PositionState.flagged,
                  posX: x,
                  posY: y,
                ),
              ),
            ),
          );
          if (state == PositionState.covered) {
            hasCoveredCell = true;
          }
        } else {
          rowChildren.add(
            GamePositionClick(
              state: state,
              count: count,
            ),
          );
        }
      }
      boardRow.add(
        Row(
          children: rowChildren,
          mainAxisAlignment: MainAxisAlignment.center,
          key: ValueKey<int>(y),
        ),
      );
    }
    if (!hasCoveredCell) {
      if ((minesFound == numOfMines) && alive) {
        wonGame = true;
        stopwatch.stop();
      }
    }

    return Container(
      color: Colors.grey[700],
      padding: EdgeInsets.all(10.0),
      child: Column(
        children: boardRow,
      ),
    );
  }

  void probe(int x, int y) {
    if (!alive) return;
    if (gridState[y][x] == PositionState.flagged) return;
    setState(() {
      if (gridBombPositions[y][x]) {
        gridState[y][x] = PositionState.bomb;
        alive = false;
        timer.cancel();
        stopwatch.stop(); // force the stopwatch to stop.
      } else {
        open(x, y);
        if (!stopwatch.isRunning) stopwatch.start();
      }
    });
  }

  void open(int x, int y) {
    if (!inBoard(x, y)) return;
    if (gridState[y][x] == PositionState.open) return;
    gridState[y][x] = PositionState.open;

    if (mineCount(x, y) > 0) return;

    open(x - 1, y);
    open(x + 1, y);
    open(x, y - 1);
    open(x, y + 1);
    open(x - 1, y - 1);
    open(x + 1, y + 1);
    open(x + 1, y - 1);
    open(x - 1, y + 1);
  }

  void flag(int x, int y) {
    if (!alive) return;
    setState(() {
      if (gridState[y][x] == PositionState.flagged) {
        gridState[y][x] = PositionState.covered;
        --minesFound;
      } else {
        gridState[y][x] = PositionState.flagged;
        ++minesFound;
      }
    });
  }

  int mineCount(int x, int y) {
    int count = 0;
    count += bombs(x - 1, y);
    count += bombs(x + 1, y);
    count += bombs(x, y - 1);
    count += bombs(x, y + 1);
    count += bombs(x - 1, y - 1);
    count += bombs(x + 1, y + 1);
    count += bombs(x + 1, y - 1);
    count += bombs(x - 1, y + 1);
    return count;
  }

  int bombs(int x, int y) => inBoard(x, y) && gridBombPositions[y][x] ? 1 : 0;

  bool inBoard(int x, int y) => x >= 0 && x < cols && y >= 0 && y < rows;
}
