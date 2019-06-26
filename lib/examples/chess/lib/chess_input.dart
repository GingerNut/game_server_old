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
      if((piece as ChessPiece).chessColor == (ui.position as ChessPosition).playerColor){
          selected = piece;
          firstTap = false;
      }
      }

    } else {

      if(piece != null
          && piece.legalMoves.contains(tile)
          && selected.chessColor == (ui.position as ChessPosition).playerColor){

        selected = null;

        Move move = ChessMove(piece.tile, tile);

        ui.tryMove(move);




      }
      firstTap = true;

    }
    if(tile.pieces.isEmpty) firstTap = true;

    ui.events.add(Success());

  }




}