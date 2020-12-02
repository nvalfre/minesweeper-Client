import 'package:flutter/material.dart';
import 'package:minesweeper/app/router/router.dart';

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}
final String _startText = "Start New Game";
final String _historyText = "Games history";

class _HomeState extends State<Home> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Minesweeper Game')),
      body: Container(
        child: Center(
          child: Column(
            children: [
              Text(
                "Minesweeper !",
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 40.0,
                ),
              ),
              Divider(height:10),
              MaterialButton(
                  color: Colors.grey.withOpacity(0.3),
                  minWidth:200,
                  onPressed: () => Navigator.pushNamed(context, gameRoute),
                  child: Text(_startText)
              ),
              Divider(height:10),
              MaterialButton(
                  color: Colors.grey.withOpacity(0.3),
                  minWidth:200,
                  onPressed: () => Navigator.pushNamed(context, historyRoute),
                  child: Text(_historyText)
              ),
            ],
          ),
        ),
      ),
      floatingActionButton: null,
    );
  }
}
