part of chess;

class ChessInput extends Input{

  final Interface ui;
  ChessPiece selected;

  bool firstTap = true;

  ChessInput(this.ui);

  tapTile(Tile tile){

    if(firstTap){

    if(tile.pieces.isNotEmpty) {

      selected = tile.pieces.first;

      if((selected as ChessPiece).chessColor == (ui.position as ChessPosition).playerColor){
          firstTap = false;
      } else{
        selected = null;
      }
      }

    } else {

      if(selected != null
          && selected.legalMoves.contains(tile)
          && selected.chessColor == (ui.position as ChessPosition).playerColor){



        Move move = ChessMove(selected.tile, tile);

        ui.tryMove(move);

        selected = null;


      }
      firstTap = true;

    }
    if(tile.pieces.isEmpty) firstTap = true;

    ui.events.add(Success());

  }




}