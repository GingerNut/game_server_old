
part of chess;

class Pawn extends ChessPiece{

  Pawn(Tiles board) : super(board){
    name = 'P';
    value = 1;
  }

  List<Tile> get legalMoves {
    List<Tile> moves = List();

    int direction = chessColor == ChessColor.white ? Tiles.North : Tiles.South;

      Tile nextTile = tile.nextInDirection(direction);

      if(nextTile != null && nextTile.tileOccupation(this) == OccupationStatus.neutral){
        moves.add(nextTile);

        if((chessColor == ChessColor.white && tile.j == 1)
        || (chessColor == ChessColor.black && tile.j == 6)){

        nextTile = nextTile.nextInDirection(direction);

        if(nextTile != null && nextTile.tileOccupation(this) == OccupationStatus.neutral) moves.add(nextTile);

        }
      }

      //TODO: add en pasane

      switch (direction){
        case Tiles.North:
          if(tile.northEast?.tileOccupation(this) == OccupationStatus.enemy)moves.add(tile.northEast);
          if(tile.northWest?.tileOccupation(this) == OccupationStatus.enemy)moves.add(tile.northWest);
          break;

        case Tiles.South:
          if(tile.southEast?.tileOccupation(this) == OccupationStatus.enemy)moves.add(tile.southEast);
          if(tile.southWest?.tileOccupation(this) == OccupationStatus.enemy)moves.add(tile.southWest);
          break;
      }

    return moves;
}


}