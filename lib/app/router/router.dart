import 'package:flutter/material.dart';
import 'package:minesweeper/view/game_history.dart';
import 'package:minesweeper/view/game_new.dart';
import 'package:minesweeper/view/home.dart';

import '../../view/game_board_main.dart';

final _appName = 'minesweeper app';

final homeRoute = '/home';
final gameRoute = '/game';
final newGameRoute = '/newGame';
final historyRoute = '/history';

MaterialApp initRouter() {
  return MaterialApp(
    debugShowCheckedModeBanner: false,
    title: _appName,
    initialRoute: homeRoute,
    routes: {
      homeRoute: (context) => Home(),
      newGameRoute: (context) => NewGame(),
      historyRoute: (context) => GameHistory(),
      gameRoute: (context) => MineSweeper(),
    },
  );
}
