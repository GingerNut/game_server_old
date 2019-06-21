import 'package:game_server/examples/chess/lib/pieces/chess_piece.dart';
import 'package:game_server/src/game/board/board.dart';
import 'package:game_server/src/game/board/piece.dart';
import 'package:game_server/src/game/board/tile.dart';
import 'package:game_server/src/game/position.dart';

class Pawn extends ChessPiece{

  Pawn(Board board) : super(board){
    name = 'P';
  }

  @override
  // TODO: implement legalMoves
  List<Tile> get legalMoves => null;


}