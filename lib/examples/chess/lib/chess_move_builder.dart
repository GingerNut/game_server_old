import 'package:game_server/examples/chess/lib/chess_move.dart';
import 'package:game_server/src/game/move.dart';
import 'package:game_server/src/game/move_builder.dart';

class ChessMoveBuilder extends MoveBuilder{

  Move build(String string) => ChessMove.fromString(string);



}