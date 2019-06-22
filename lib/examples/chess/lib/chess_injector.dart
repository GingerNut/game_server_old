import 'package:game_server/examples/chess/lib/chess_move_builder.dart';
import 'package:game_server/src/game/board/board.dart';
import 'package:game_server/src/game/board/notation.dart';
import 'package:game_server/src/game/game.dart';
import 'package:game_server/src/game/move_builder.dart';
import 'package:game_server/src/game/position.dart';
import 'package:game_server/src/game/position_builder.dart';
import 'package:game_server/src/game/settings.dart';
import 'package:game_server/src/game_dependency.dart';
import 'package:game_server/src/messages/command/new_game.dart';

import 'chess_notation.dart';
import 'chess_position.dart';
import 'chess_settings.dart';

class ChessInjector extends GameDependency{

  Uri get computerUri => Uri.dataFromString('package:game_server/examples/chess/lib/chess_isolate.dart');
  
  Game getGame(NewGame newGame) => Game.fromNewGame(this, newGame);

  MoveBuilder getMoveBuilder() => ChessMoveBuilder();

  Position getPosition() => ChessPosition();

  setPositionType(Position position) => position as ChessPosition;

  PositionBuilder getPositionBuilder() => PositionBuilder(this);

  Settings get settings => ChessSettings();

  Notation get notation => ChessNotation();





}