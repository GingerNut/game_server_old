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
//    print('from chess move check ${fromI} ${fromJ} to ${toI} ${toJ}');

//    print(position.tiles.tile(fromI, fromJ).pieces);

    //TODO moves in computer being duplicated

    Piece piece;

    if(position.tiles.tile(fromI, fromJ).pieces.isNotEmpty){
      piece = position.tiles.tile(fromI, fromJ).pieces.first;
    }

    if(piece == null) return GameError('Chess Error : piece not found for move from '
        + fromI.toString() + ' '
        + fromJ.toString() + ' '
        + 'to '
        + toI.toString() + ' '
        + toJ.toString() + ' ');


      if(piece.legalMoves.contains(position.tiles.tile(toI, toJ))) {
        return Success();
      } else {
        return GameError('Chess Error: illegal move for '
            + piece.name + ' from '
            + fromI.toString() + ' '
            + fromJ.toString() + ' '
            + ' to '
            + toI.toString() + ' '
            + toJ.toString() + ' '
        );
      }
  }



  doMove(ChessPosition position) {

    Tile from = position.tiles.tile(fromI, fromJ);
    Tile to = position.tiles.tile(toI, toJ);

    ChessPiece piece = from.pieces.first;

    piece.tile = to;

    ChessPiece captured = piece.captured;

    switch(piece.chessColor){

      case Palette.COLOR_WHITE:
        position.blackArmy.remove(captured);
        break;

      case Palette.COLOR_WHITE:
        position.whiteArmy.remove(captured);
        break;
    }

    from.pieces.clear();
    to.pieces.clear();
    to.pieces.add(piece);

    return Success();

  }

  String get string =>
      fromI.toString() + delimiter
      + fromJ.toString() + delimiter
      + toI.toString() + delimiter
      + toJ.toString();

}