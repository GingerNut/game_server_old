import 'package:game_server/examples/chess/lib/chess_injector.dart';
import 'package:game_server/examples/chess/lib/chess_move.dart';
import 'package:game_server/examples/chess/lib/pieces/chess_piece.dart';
import 'package:game_server/src/game/board/board.dart';
import 'package:game_server/src/game/board/piece.dart';
import 'package:game_server/src/game/board/tile.dart';
import 'package:game_server/src/game/position.dart';

class Rook extends ChessPiece{

  Rook(Board board) : super(board){
    name = 'R';
  }

  List<Tile> get legalMoves {

    List<Tile> moves = List();

    Board.squareOrthogonalDirections.forEach((d){

    search(moves, d);


    });

    return moves;
  }

  

}