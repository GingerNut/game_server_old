part of chess;


class Bishop extends ChessPiece{


  Bishop(Tiles board ) : super(board){
    name = 'B';
    value = 3;
  }

  List<Tile> get legalMoves {

    List<Tile> moves = List();

    Tiles.squareDiagonalDirections.forEach((d)=> search(moves, d));

    return moves;
  }


}