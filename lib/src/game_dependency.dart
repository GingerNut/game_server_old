import 'dart:isolate';

import 'game/board/board.dart';
import 'game/board/notation.dart';
import 'game/game.dart';
import 'game/move_builder.dart';
import 'game/player/computer.dart';
import 'game/position.dart';
import 'game/position_builder.dart';
import 'game/settings.dart';
import 'messages/command/new_game.dart';

abstract class GameDependency{

  Game getGame(NewGame newGame);

  Board getBoard();

  MoveBuilder getMoveBuilder();

  PositionBuilder getPositionBuilder();

  Position getPosition();

  Position setPositionType(Position position);

  Notation get notation;

  Settings get settings;

  Uri get computerUri;


}