import 'dart:math';

class AIEngine {
  static List<List<String>> calculateBestMove(List<List<String>> currentBoard) {
    List<List<int>> blackPieces = [];
    
    for (int r = 0; r < 8; r++) {
      for (int c = 0; c < 8; c++) {
        if (currentBoard[r][c] == 'B_C') {
          blackPieces.add([r, c]);
        }
      }
    }

    if (blackPieces.isEmpty) return currentBoard;

    final random = Random();
    blackPieces.shuffle(random);

    for (var piece in blackPieces) {
      int r = piece[0];
      int c = piece[1];

      List<List<int>> possibleMoves = [
        [r + 1, c - 1],
        [r + 1, c + 1]
      ];

      for (var move in possibleMoves) {
        int nr = move[0];
        int nc = move[1];

        if (nr >= 0 && nr < 8 && nc >= 0 && nc < 8) {
          if (currentBoard[nr][nc] == ' ' || currentBoard[nr][nc].startsWith('W')) {
            currentBoard[nr][nc] = 'B_C';
            currentBoard[r][c] = ' ';
            return currentBoard;
          }
        }
      }
    }
    return currentBoard;
  }
}
