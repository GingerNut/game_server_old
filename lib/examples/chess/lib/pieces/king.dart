import 'package:game_server/src/game/board/board.dart';
import 'package:game_server/src/game/board/piece.dart';
import 'package:game_server/src/game/board/tile.dart';


class King extends Piece{



  King(Board board) : super(board){
    name = 'K';
  }

  @override
  // TODO: implement legalMoves
  List<Tile> get legalMoves => null;


}