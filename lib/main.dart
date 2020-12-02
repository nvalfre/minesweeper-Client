import 'app/server/server.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
  runApp(MinesweeperGame());
}

class MinesweeperGame extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Server();
  }
}
