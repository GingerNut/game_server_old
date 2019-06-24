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

      print(piece.name);

      firstTap = false;
    }

    } else {

      if(piece.legalMoves.contains(tile)){

        Move move = ChessMove(piece.tile, tile);

        ui.tryMove(move);


        print('move ');

      }


    }
    if(tile.pieces.isEmpty) firstTap = true;

  }




}