

import 'package:game_server/src/game/game.dart';
import 'package:game_server/src/game/game_host.dart';
import 'package:game_server/src/game/move_builder.dart';
import 'package:game_server/src/game/position.dart';
import 'package:game_server/src/game/position_builder.dart';
import 'package:game_server/src/game_dependency.dart';
import 'package:game_server/src/messages/command/new_game.dart';


import 'fie_fo_fum_move_builder.dart';
import 'fie_fo_fum_position.dart';
import 'fie_fo_fum_position_builder.dart';

class FieFoFumInjector extends GameDependency{

  Game getGame(GameHost host, NewGame newGame) => Game(host, this,  newGame);

  Position getPosition() => FieFoFumPosition();
  
  MoveBuilder getMoveBuilder() => FieFoFumMoveBuilder();

  PositionBuilder getPositionBuilder() => FieFoFumPositionBuilder();

  Uri get computerUri =>

      Uri.parse('C://Users/Stephen/growing_games/game_server/examples/fie_fo_fum/lib/fie_fo_fum_isolate.dart');



}