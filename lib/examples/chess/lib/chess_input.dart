part of chess;

class ChessInput extends Input{

  final Interface ui;
  ChessPiece selected;

  bool firstTap = true;
  Piece piece;

  ChessInput(this.ui);

  tapTile(Tile tile){

    if(firstTap){

    if(tile.pieces.isNotEmpty) {

      piece = tile.pieces.first;
      selected = piece;

      firstTap = false;
    }

    } else {

      selected = null;

      if(piece != null && piece.legalMoves.contains(tile)){

        Move move = ChessMove(piece.tile, tile);

        ui.tryMove(move);

        firstTap = true;

      }


    }
    if(tile.pieces.isEmpty) firstTap = true;

    ui.events.add(Success());

  }




}