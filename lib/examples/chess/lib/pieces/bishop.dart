import 'package:game_server/src/game/board/board.dart';
import 'package:game_server/src/game/board/piece.dart';
import 'package:game_server/src/game/board/tile.dart';
import 'package:game_server/src/game/position.dart';

class Bishop extends Piece{

  Bishop(Board board ) : super(board){
    name = 'B';
  }

  @override
  // TODO: implement legalMoves
  List<Tile> get legalMoves => null;


}