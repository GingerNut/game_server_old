part of chess;

class King extends ChessPiece{



  King(Board board) : super(board){
    name = 'K';
    value = 9;
  }

  List<Tile> get legalMoves {

    List<Tile> moves = List();

    Board.squareAllDirections.forEach((d){

      Tile nextTile = tile.nextInDirection(d);

        if(nextTile != null && nextTile.tileOccupation(this) != OccupationStatus.friendly )moves.add(nextTile);


    });

    return moves;
  }

}