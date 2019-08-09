part of chess;

abstract class ChessPiece extends Piece {
  ChessPiece(Tiles board, ChessPosition position) : super(board, position);

  int chessColor;
  double value;

  int _tileK;

  Tile get tile =>
      _tileK == null ? null : (position as ChessPosition).tiles[_tileK];

  set tile(Tile tile) {
    if (tile == null) {
      _tileK = null;
    } else {
      _tileK = tile.k;
    }
  }

  bool isFriendly(Piece piece) =>
      chessColor == (piece as ChessPiece).chessColor;

  OccupationStatus getOccupationStatus(Tile tile) {
    ChessPosition pos = position as ChessPosition;

    ChessPiece otherPiece = pos.pieces[tile.k];

    if (otherPiece == null)
      return OccupationStatus.neutral;
    else
      return otherPiece.isFriendly(this)
          ? OccupationStatus.friendly
          : OccupationStatus.enemy;
  }

  search(List<Tile> moves, int direction) {
    Tile nextTile = tile.nextInDirection(direction);

    while (nextTile != null) {
      var tileOccupation = getOccupationStatus(nextTile);

      switch (tileOccupation) {
        case OccupationStatus.neutral:
          moves.add(nextTile);
          nextTile = nextTile.nextInDirection(direction);
          break;

        case OccupationStatus.friendly:
          nextTile = null;
          break;

        case OccupationStatus.enemy:
          moves.add(nextTile);
          nextTile = null;
          break;
      }
    }
  }

  Move createMove(Tile to) {
    if (!legalMoves.contains(tile)) return null;

    return ChessMove(tile, to);
  }
}
