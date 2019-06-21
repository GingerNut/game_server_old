

import 'package:game_server/src/game/board/notation.dart';
import 'package:game_server/src/game/game.dart';
import 'package:game_server/src/game/move.dart';
import 'package:game_server/src/game/move_builder.dart';
import 'package:game_server/src/game/position.dart';
import 'package:game_server/src/game/position_builder.dart';
import 'package:game_server/src/game/settings.dart';
import 'package:game_server/src/game_dependency.dart';
import 'package:game_server/src/messages/command/new_game.dart';


import 'fie_fo_fum_move_builder.dart';
import 'fie_fo_fum_position.dart';
import 'fie_fo_fum_settings.dart';


class FieFoFumInjector extends GameDependency{

  Game getGame(NewGame newGame) => Game.fromNewGame(this,  newGame);

  getBoard() => null;

  Position getPosition() => FieFoFumPosition();
  
  MoveBuilder getMoveBuilder() => FieFoFumMoveBuilder();

  PositionBuilder getPositionBuilder() => PositionBuilder(this);

  setPositionType(Position position) => position as FieFoFumPosition;

  Settings get settings => FieFoFumSettings();

  String testAddress = 'package:game_server/examples/fie_fo_fum/lib/fie_fo_fum_isolate.dart';


  Uri get computerUri {
    return Uri.parse(testAddress);
  }

  Notation get notation => null;

}

