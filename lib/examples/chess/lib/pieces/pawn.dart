
part of chess;

class Pawn extends ChessPiece{

  Pawn(Board board) : super(board){
    name = 'P';
    value = 1;
  }

  List<Tile> get legalMoves {
    List<Tile> moves = List();

    int direction = chessColor == ChessColor.white ? Board.North : Board.South;

      Tile nextTile = tile.nextInDirection(direction);

      if(nextTile != null && nextTile.tileOccupation(this) == OccupationStatus.neutral){
        moves.add(nextTile);

        if(tile == startingPosition){

        nextTile = nextTile.nextInDirection(direction);

        if(nextTile != null && nextTile.tileOccupation(this) == OccupationStatus.neutral) moves.add(nextTile);

        }
      }
    return moves;
}


}