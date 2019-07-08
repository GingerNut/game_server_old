part of chess;


class Queen extends ChessPiece{

  Queen(Tiles board) : super(board){
    name = 'Q';
    value = 7;
  }

  List<Tile> get legalMoves {

    List<Tile> moves = List();

    Tiles.squareAllDirections.forEach((d){

      search(moves, d);

    });

    return moves;
  }


}