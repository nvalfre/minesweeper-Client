import 'package:flutter/material.dart';
import 'package:minesweeper/app/router/router.dart';
import 'dart:math';
import 'dart:async';

import 'package:minesweeper/view/game_position.dart';

import 'game_position_covered.dart';

enum Game { waiting, started, paused, finished }

const waitingForStart = "Start game";
const started = "Game in progress";
const pauseGame = "Pause Game.";
const resumeGame = "Resume Game.";
const paused = "Game paused.";
const finished = "Game finished!";

enum PositionState {
  covered, //default
  bomb, //bomb
  open, //default-free
  flagged,
  revealed //with hints
}

void main() => runApp(MineSweeper());

class MineSweeper extends StatefulWidget {
  @override
  _MineSweeperState createState() => _MineSweeperState();
}

class _MineSweeperState extends State<MineSweeper> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        debugShowCheckedModeBanner: false,
        title: "Minesweeper - flutter",
        home: Board());
  }
}

class Board extends StatefulWidget {
  @override
  BoardState createState() => BoardState();
}

class BoardState extends State<Board> {
  //tbd -> TODO  POST create endpoints to start new game
  final rowsController = TextEditingController();
  final colsController = TextEditingController();
  final minesController = TextEditingController();
  int rows = 9;
  int cols = 9;
  int numOfMines = 11;
  String currentGameStatus = waitingForStart;

  List<List<PositionState>> gridState;
  List<List<bool>> gridBombPositions;

  int count = 0;
  bool alive;
  bool wonGame;
  int minesFound;
  Timer timer;
  Stopwatch stopwatch = Stopwatch();

  @override
  void initState() {
    resetBoard();
    rowsController.addListener(_printRowsValue);
    colsController.addListener(_printColumnValue);
    minesController.addListener(_printMinestValue);
    super.initState();
  }

  _printRowsValue() {
    print("Rows text field: ${rowsController.text}");
  }

  _printColumnValue() {
    print("Columns text field: ${colsController.text}");
  }

  _printMinestValue() {
    print("Mines text field: ${minesController.text}");
  }

  @override
  void dispose() {
    rowsController.dispose();
    colsController.dispose();
    minesController.dispose();
    timer?.cancel();
    super.dispose();
  }

  void resetBoard() {
    //TODO TBD => POST StartNewGame
    alive = true;
    wonGame = false;

    rowsController.text = "";
    colsController.text = "";
    minesController.text = "";
    currentGameStatus = waitingForStart;
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
      body: SingleChildScrollView(
        child: Column(
          children: [
            Center(
              child: currentGameStatus != waitingForStart
                  ? buildBoard()
                  : Container(),
            ),
            Divider(
              height: 10,
            ),
            Container(
              child: Text(
                "Complete values to start",
                style: TextStyle(
                  color: Colors.black,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            currentGameStatus == waitingForStart ? Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                    width: 100,
                    child: TextField(
                      decoration: InputDecoration(
                          border: InputBorder.none, hintText: 'Rows'),
                      controller: rowsController,
                    )),
                SizedBox(
                  width: 10,
                ),
                Container(
                  width: 100,
                  child: TextField(
                    decoration: InputDecoration(
                        border: InputBorder.none, hintText: 'Columns'),
                    controller: colsController,
                  ),
                ),
                SizedBox(
                  width: 10,
                ),
                Container(
                  width: 100,
                  child: TextField(
                    decoration: InputDecoration(
                        border: InputBorder.none, hintText: 'Mines'),
                    controller: minesController,
                  ),
                ),
              ],
            ) : Container(),
            Container(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(currentGameStatus == waitingForStart
                      ? ""
                      : currentGameStatus),
                  Container(
                      child: currentGameStatus == started
                          ? MaterialButton(
                        color: Colors.grey.withOpacity(0.3),
                        minWidth: 200,
                        onPressed: () => pauseBoard(),
                        child: Text(pauseGame),
                      )
                          : currentGameStatus == paused
                          ? MaterialButton(
                        color: Colors.grey.withOpacity(0.3),
                        minWidth: 200,
                        onPressed: () => pauseBoard(),
                        child: Text(resumeGame),
                      )
                          : null),
                  SizedBox(
                    width: 10,
                  ),
                  Text(
                    alive && wonGame
                        ? "$finished - you win!"
                        : alive
                        ? "Alive, current moves $count"
                        : "$finished - you lost.",
                    style: TextStyle(
                      color: Colors.black87,
                      fontSize: 20.0,
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(
              height: 10,
            ),
            Container(
              child: MaterialButton(
                  color: Colors.grey.withOpacity(0.3),
                  minWidth: 200,
                  onPressed: () => startBoard(),
                  child: Text(currentGameStatus)),
            ),
          ],
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

        if (!alive) {
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
                if (state == PositionState.covered)
                  probe(x, y); //POST ClickPosition
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
    count++;
  }

  void open(int x, int y) {
    if (!isValidPosition(x, y)) return;
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

    count += isBomb(x - 1, y);
    count += isBomb(x + 1, y);

    count += isBomb(x, y - 1);
    count += isBomb(x, y + 1);

    count += isBomb(x - 1, y - 1);
    count += isBomb(x + 1, y + 1);
    count += isBomb(x + 1, y - 1);
    count += isBomb(x - 1, y + 1);
    return count;
  }

  int isBomb(int x, int y) =>
      isValidPosition(x, y) && gridBombPositions[y][x] ? 1 : 0;

  bool isValidPosition(int x, int y) =>
      x >= 0 && x < cols && y >= 0 && y < rows;

  startBoard() {
    setState(() {
      rows = int.parse (rowsController.text);
      cols = int.parse(colsController.text);
      numOfMines = int.parse(minesController.text);

      if (!isValidInput()) {
        resetBoard();
        _showAlert(context);
      } else {
        resetBoard();
        currentGameStatus = started;
      }

    });
  }

  pauseBoard() {
    setState(() {
      currentGameStatus = paused;
    });
  }

  bool isValidInput() {
    return (rows > 9 && cols > 9 && numOfMines > 12) && (rows < 30 && cols < 30 && numOfMines < 500 );
  }

  void _showAlert(BuildContext context) {
    showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: Text("Invalid Input"),
          content: Text("Invalid Input, minimum 10x10, maximum 30x30, mines maximum is 500 "),
        )
    );
  }

}
