part of chess;

class ChessInput extends Input{

  final Interface ui;
  Tile selected;
  List<Tile> legalMoves = List();
  bool whiteAtBottom = true;

  ChessInput(this.ui);

  tapTile(Tile tile){

    setSelected(Tile t){

      ChessPiece tapped = tile.pieces.first;

      if(tapped.chessColor == (ui.position as ChessPosition).playerColor){
        selected = tapped.tile;
        legalMoves = tapped.legalMoves;
      }

    }


    if(selected == null){

    if(tile.pieces.isNotEmpty) {

        setSelected(tile);
      }

    } else {

      if(selected == tile
          || legalMoves.contains(tile)){

        Move move = ChessMove(selected, tile);

        ui.tryMove(move);

        selected = null;
        legalMoves.clear();
      } else{

        selected = null;
        legalMoves.clear();

        if(tile.pieces.isNotEmpty) {

        setSelected(tile);
      }



      }



    }

    ui.events.add(Success());

  }




}