part of chess;

class ChessInput extends Input{

  final Interface ui;
  ChessPiece selected;
  List<Tile> legalMoves = List();

  ChessInput(this.ui);

  tapTile(Tile tile){

    if(selected == null){

    if(tile.pieces.isNotEmpty) {

      ChessPiece tapped = tile.pieces.first;

      if(tapped.chessColor == (ui.position as ChessPosition).playerColor){
          selected = tapped;
          legalMoves = selected.legalMoves;
      }
      }

    } else {

      if(selected.tile == tile
          || selected.legalMoves.contains(tile)){

        Move move = ChessMove(selected.tile, tile);

        ui.tryMove(move);


      }

      selected = null;
      legalMoves.clear();

    }

    ui.events.add(Success());

  }




}