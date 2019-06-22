import 'package:game_server/examples/chess/lib/pieces/chess_piece.dart';
import 'package:game_server/src/game/board/board.dart';
import 'package:game_server/src/game/board/piece.dart';
import 'package:game_server/src/game/board/tile.dart';
import 'package:game_server/src/game/position.dart';

class Queen extends ChessPiece{

  Queen(Board board) : super(board){
    name = 'Q';
    value = 7;
  }

  List<Tile> get legalMoves {

    List<Tile> moves = List();

    Board.squareAllDirections.forEach((d){

      search(moves, d);

    });

    return moves;
  }


}