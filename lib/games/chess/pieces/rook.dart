part of chess;

class Rook extends ChessPiece {
  Rook(Tiles board, ChessPosition position) : super(board, position) {
    name = 'R';
    value = 5;
  }

  List<Tile> get legalMoves {
    List<Tile> moves = List();

    Tiles.squareOrthogonalDirections.forEach((d) {
      search(moves, d);
    });

    return moves;
  }
}
