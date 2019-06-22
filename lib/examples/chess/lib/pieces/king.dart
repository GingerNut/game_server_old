import 'package:game_server/examples/chess/lib/pieces/chess_piece.dart';
import 'package:game_server/src/game/board/board.dart';
import 'package:game_server/src/game/board/piece.dart';
import 'package:game_server/src/game/board/tile.dart';


class King extends ChessPiece{



  King(Board board) : super(board){
    name = 'K';
    value = 9;
  }

  List<Tile> get legalMoves {

    List<Tile> moves = List();

    Board.squareAllDirections.forEach((d){

      Tile nextTile = tile.nextInDirection(d);

        if(nextTile.tileOccupation(this) != OccupationStatus.friendly )moves.add(nextTile);


    });

    return moves;
  }

}