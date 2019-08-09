part of chess;

class King extends ChessPiece {
  bool notYetMoved = true;

  King(Tiles board, ChessPosition position) : super(board, position) {
    name = 'K';
    value = 9;
  }

  List<Tile> get legalMoves {
    List<Tile> moves = List();

    Tiles.squareAllDirections.forEach((d) {
      Tile nextTile = tile.nextInDirection(d);

      if (nextTile != null &&
          getOccupationStatus(nextTile) != OccupationStatus.friendly)
        moves.add(nextTile);
    });

    //TODO: add casling

    return moves;
  }
}
