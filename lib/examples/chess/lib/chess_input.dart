part of chess;

class ChessInput extends Input{

  final Interface ui;

  bool firstTap = true;
  Piece piece;

  ChessInput(this.ui);

  tapTile(Tile tile){

    if(firstTap){

    if(tile.pieces.first != null) {

      piece = tile.pieces.first;

      firstTap = false;
    }

    } else {

      Tile t = (ui.position as ChessPosition).board.tile(0, 1);

      t.north.printTile(ChessInjector());

      print(piece.legalMoves.length);

      piece.legalMoves.forEach((t) => t.printTile(ChessInjector()));

      if(piece != null && piece.legalMoves.contains(tile)){

        Move move = ChessMove(piece.tile, tile);

        ui.tryMove(move);


        print('move ');

      }


    }
    if(tile.pieces.isEmpty) firstTap = true;

  }




}