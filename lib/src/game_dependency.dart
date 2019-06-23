
import 'package:game_server/game_server.dart';

import 'messages/command/new_game.dart';

abstract class GameDependency{

  Game getGame(NewGame newGame);

  MoveBuilder getMoveBuilder();

  PositionBuilder getPositionBuilder() => PositionBuilder(this);

  Position getPosition();

  Position setPositionType(Position position);

  Notation get notation;

  Settings get settings;

  Uri get computerUri;


}