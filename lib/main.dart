import 'package:flutter/material.dart';
import 'game_board.dart';

void main() {
  runApp(const ChessCheckersApp());
}

class ChessCheckersApp extends StatelessWidget {
  const ChessCheckersApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Шахматы против Шашек',
      theme: ThemeData.dark(),
      home: const GameBoardSquare(),
    );
  }
}
