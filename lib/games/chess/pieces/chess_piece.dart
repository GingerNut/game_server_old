part of chess;


abstract class ChessPiece extends Piece{
  ChessPiece(Tiles board) : super(board);

  ChessColor chessColor;
  double value;

  bool isFriendly(Piece piece)=> chessColor == (piece as ChessPiece).chessColor;

  search(List<Tile> moves, int direction){
    Tile nextTile = tile.nextInDirection(direction);


    while(nextTile != null){

      var tileOccupation = nextTile.tileOccupation(this);

      switch(tileOccupation){


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

  Move createMove(Tile to){
    if(!legalMoves.contains(tile)) return null;

    return ChessMove(tile, to);

  }

}

enum ChessColor{
  white,
  black
}

