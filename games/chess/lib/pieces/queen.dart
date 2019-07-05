part of chess;


class Queen extends ChessPiece{

  Queen(Board board) : super(board){
    name = 'Q';
    value = 7;
  }

  List<Tile> get legalMoves {

    List<Tile> moves = List();

    Board.squareAllDirections.forEach((d){

      search(moves, d);

    });

    return moves;
  }


}