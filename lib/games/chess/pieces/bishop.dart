part of chess;


class Bishop extends ChessPiece{


  Bishop(Board board ) : super(board){
    name = 'B';
    value = 3;
  }

  List<Tile> get legalMoves {

    List<Tile> moves = List();

    Board.squareDiagonalDirections.forEach((d)=> search(moves, d));

    return moves;
  }


}