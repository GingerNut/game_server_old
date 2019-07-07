part of chess;

class Rook extends ChessPiece{

  Rook(Board board) : super(board){
    name = 'R';
    value = 5;
  }

  List<Tile> get legalMoves {

    List<Tile> moves = List();

    Board.squareOrthogonalDirections.forEach((d){

    search(moves, d);


    });

    return moves;
  }

  

}