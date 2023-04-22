import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'interface/playing_board.dart';

void main() {
  runApp(const ProviderScope(child: MainApp()));
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      themeMode: ThemeMode.dark,
      debugShowCheckedModeBanner: false,
      darkTheme: ThemeData.dark(
        useMaterial3: true,
      ).copyWith(
          colorScheme: ColorScheme.fromSeed(
        seedColor: Colors.greenAccent,
      )),
      home: const PlayingGameBoard(),
    );
  }
}
