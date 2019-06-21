import 'package:game_server/src/game/board/board.dart';
import 'package:game_server/src/game/board/piece.dart';
import 'package:game_server/src/game/board/tile.dart';
import 'package:game_server/src/game/position.dart';

class Queen extends Piece{

  Queen(Board board) : super(board){
    name = 'Q';
  }

  @override
  // TODO: implement legalMoves
  List<Tile> get legalMoves => null;


}