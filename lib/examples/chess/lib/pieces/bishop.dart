import 'package:game_server/examples/chess/lib/pieces/chess_piece.dart';
import 'package:game_server/src/game/board/board.dart';
import 'package:game_server/src/game/board/piece.dart';
import 'package:game_server/src/game/board/tile.dart';
import 'package:game_server/src/game/position.dart';

class Bishop extends ChessPiece{

  Bishop(Board board ) : super(board){
    name = 'B';
  }

  List<Tile> get legalMoves {

    List<Tile> moves = List();

    Board.squareDiagonalDirections.forEach((d)=> search(moves, d));

    return moves;
  }


}