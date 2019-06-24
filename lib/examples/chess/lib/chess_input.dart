part of chess;

class ChessInput extends Input{

  bool firstTap = true;
  Piece piece;

  tapTile(Tile tile){
    if(firstTap && tile.pieces.first != null){

      piece = tile.pieces.first;

      firstTap = false;
    } else {

      if(piece.legalMoves.contains(tile)){

        Move move = ChessMove(piece.tile, tile);


        print('move ');

      }


    }


  }




}