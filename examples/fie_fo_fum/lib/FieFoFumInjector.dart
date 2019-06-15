import 'package:game_server/src/game/game.dart';
import 'package:game_server/src/game/game_host.dart';
import 'package:game_server/src/game/move_builder.dart';
import 'package:game_server/src/game/player/computer_isolate.dart';
import 'package:game_server/src/game/position.dart';
import 'package:game_server/src/game/position_builder.dart';
import 'package:game_server/src/injector.dart';
import 'package:game_server/src/messages/command/new_game.dart';

import 'fie_fo_fum_computer.dart';
import 'fie_fo_fum_move_builder.dart';
import 'fie_fo_fum_position.dart';
import 'fie_fo_fum_position_builder.dart';

class FieFoFumInjector extends Injector{

  Game getGame(GameHost host, NewGame newGame) => Game(host, this,  newGame);

  Position getPosition() => FieFoFumPosition();
  
  MoveBuilder getMoveBuilder() => FieFoFumMoveBuilder();

  PositionBuilder getPositionBuilder() => FieFoFumPositionBuilder();




}