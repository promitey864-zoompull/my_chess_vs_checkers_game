import 'package:flutter/material.dart';
import 'ai_engine.dart';

class GameBoardSquare extends StatefulWidget {
  const GameBoardSquare({super.key});

  @override
  State<GameBoardSquare> createState() => _GameBoardSquareState();
}

class _GameBoardSquareState extends State<GameBoardSquare> {
  List<List<String>> board = List.generate(8, (_) => List.generate(8, (_) => ' '));
  int? selectedRow;
  int? selectedCol;
  bool isWhiteTurn = true;

  @override
  void initState() {
    super.initState();
    resetGame();
  }

  void resetGame() {
    board = List.generate(8, (_) => List.generate(8, (_) => ' '));
    for (int i = 0; i < 8; i++) {
      board[7][i] = 'W_P';
    }
    board[7][4] = 'W_K'; 

    for (int r = 0; r < 3; r++) {
      for (int c = 0; c < 8; c++) {
        if ((r + c) % 2 != 0) {
          board[r][c] = 'B_C';
        }
      }
    }
    isWhiteTurn = true;
  }

  void handleTap(int row, int col) {
    if (!isWhiteTurn) return;

    if (selectedRow == null) {
      if (board[row][col].startsWith('W')) {
        setState(() {
          selectedRow = row;
          selectedCol = col;
        });
      }
    } else {
      if (board[row][col] == ' ' || board[row][col].startsWith('B')) {
        setState(() {
          board[row][col] = board[selectedRow!][selectedCol!];
          board[selectedRow!][selectedCol!] = ' ';
          selectedRow = null;
          selectedCol = null;
          isWhiteTurn = false;
        });
        
        Future.delayed(const Duration(milliseconds: 600), makeAIMove);
      } else {
        setState(() {
          selectedRow = null;
          selectedCol = null;
        });
      }
    }
  }

  void makeAIMove() {
    if (mounted) {
      setState(() {
        board = AIEngine.calculateBestMove(board);
        isWhiteTurn = true;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Шахматы (Вы) vs Шашки (ИИ)'),
        actions: [
          IconButton(icon: const Icon(Icons.refresh), onPressed: () => setState(resetGame)),
        ],
      ),
      body: Center(
        child: AspectRatio(
          aspectRatio: 1.0,
          child: GridView.builder(
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 8),
            itemCount: 64,
            itemBuilder: (context, index) {
              int row = index ~/ 8;
              int col = index % 8;
              bool isDark = (row + col) % 2 != 0;
              bool isSelected = selectedRow == row && selectedCol == col;

              return GestureDetector(
                onTap: () => handleTap(row, col),
                child: Container(
                  color: isSelected ? Colors.teal : (isDark ? Colors.brown : Colors.amber),
                  child: Center(
                    child: Text(
                      getPieceSymbol(board[row][col]),
                      style: TextStyle(
                        fontSize: 28, 
                        color: board[row][col].startsWith('W') ? Colors.white : Colors.black
                      ),
                    ),
                  ),
                ),
              );
            },
          ),
        ),
      ),
    );
  }

  String getPieceSymbol(String code) {
    switch (code) {
      case 'W_P': return '♙';
      case 'W_K': return '♔';
      case 'B_C': return '●';
      default: return '';
    }
  }
}
