part of game;

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