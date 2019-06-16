import 'dart:isolate';

import 'game/game.dart';
import 'game/game_host.dart';
import 'game/move_builder.dart';
import 'game/player/computer_isolate.dart';
import 'game/position.dart';
import 'game/position_builder.dart';
import 'messages/command/new_game.dart';

abstract class GameDependency{

  Game getGame(GameHost host, NewGame newGame);

  MoveBuilder getMoveBuilder();

  PositionBuilder getPositionBuilder();

  Position getPosition();

  Uri get computerUri;


}