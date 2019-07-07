part of chess;

class ChessMove extends Move<ChessPosition>{

  int fromI;
  int fromJ;
  int toI;
  int toJ;
  static const String delimiter = ',';

  ChessMove(Tile from, Tile to){
  fromI = from.i;
  fromJ = from.j;
  toI = to.i;
  toJ = to.j;
  }


  ChessMove.fromString(String string){

    List<String> details = string.split(delimiter);

    fromI = int.parse(details[0]);
    fromJ = int.parse(details[1]);
    toI = int.parse(details[2]);
    toJ = int.parse(details[3]);


  }


  Message doCheck(ChessPosition position) {
      Piece piece = position.board.tile(fromI, fromJ).pieces.first;

      if(piece.legalMoves.contains(position.board.tile(toI, toJ))) return Success();
      else return GameError('illegal move');
  }

  doMove(ChessPosition position) {

    ChessPiece piece = position.board.tile(fromI, fromJ).pieces.first;

    piece.tile = position.board.tile(toI, toJ);

    ChessPiece captured = piece.captured;

    switch(piece.chessColor){

      case ChessColor.white:
        position.board.blackArmy.remove(captured);
        break;

      case ChessColor.black:
        position.board.whiteArmy.remove(captured);
        break;
    }

    return Success();

  }

  String get string =>
      fromI.toString() + delimiter
      + fromJ.toString() + delimiter
      + toI.toString() + delimiter
      + toJ.toString();

}